;;; .emacs --- Phil Hollenback's ultra emacs config file

;; Copyright (c) 2012 Philip J. Hollenback <philiph@pobox.com>
;;
;; Based on Jeff Jones' .emacs and various other sources
;; off the web.
;;
;; Everyone's .emacs rips off someone else's...
;;
;; $Id: .emacs,v 1.2 2005/09/01 20:19:33 hollenba Exp hollenba $

;; Commentary: An amalgamation of ideas from many sources.  First, notice the
;; section headers - they look like that for use in outline-mode.  Type C-c @
;; C-t to get a listing of all the headings, type the usual motion keys to
;; move among them, & type C-c @ C-a to see all the text again.  I remap the
;; outline-minor-mode-prefix to C-c C-k, which I find easier to type.  A
;; "Local Variables" section at the end of this file sets up outline mode
;; appropriately.
;;
;; Update: I just tried the above outline-mode commands in GNU Emacs
;; and they don't seem to work.
;;
;; I place all my emacs packages in ~/.emacstuff, and furthermore
;; there are links to ~/.Xdefaults and ~/.emacs there.  That way I can
;; tar up the whole directory and move it easily.
;;
;; My key bindings are similar to what a lot of other folks use, and
;; in addition I try to cover all the cases on a remote xterm, where
;; regular keybindings seem to fail.
;;
;; I include extensive cc-mode and vc-mode customizations that make program
;; editing very pleasant.  Most of these changes were contributed by Harvey
;; Thompson at Lutris, a company I used to work for.

;;;; Global Settings ;;;;

;; Provide a useful error trace if loading this monster fails.
(setq debug-on-error t)

;; Put all my collected emacs packages and files in my-emacs-dir
;; Note that I also put my .emacs in there and link to ~/.emacs.
;; That way I can easily bundle the dir and give it to others.
(setq my-emacs-dir "~/.emacstuff/")        ;concat this to dir names.

(setq load-path (cons my-emacs-dir load-path))

;; Load my defaults from another file.  Again, makes distributing this file
;; easier.  These defaults are things like my name and email address.
(load (expand-file-name "~/.private.el"))

;;;;; Global Functions ;;;;;
;; Some functions that change global behaviors, so they should be at top of
;; file.
(defun mark-line-and-copy ()
  "Copy the current line into the kill ring."
  (interactive)
  (beginning-of-line)
  (push-mark (point) t t)
  (forward-line 1)
  (kill-ring-save (region-beginning) (region-end))
  (message "line copied")
)

(defun duplicate-line ()
  "Copy this line under it; put point on copy in current column."
  (interactive)
  (let ((start-column (current-column)))
    (save-excursion
      (mark-line-and-copy) ;save-excursion restores mark
      (yank))
    (forward-line 1)
    (move-to-column start-column))
  (message "line dup'ed")
)

(defun duplicate-region ()
  "Copy this region after itself."
  (interactive)
  (let ((start (dot-marker)))
    (kill-ring-save (region-beginning) (region-end))
    (yank)
    (goto-char start))
  (message"region dup'ed")
)

;; Get rid of that annoying prompt that requires one to type
;; in Y-E-S and then press the friggin enter key to confirm.
(defun yes-or-no-p (PROMPT)
  (beep)
  (y-or-n-p PROMPT))

;; GNU/FSF Emacs doesn't come with this useful function
(unless (fboundp 'prefix-region)
  (defun prefix-region
    (prefix) "Add a prefix string to each line between mark and point."
    (interactive "sPrefix string: ")
    (if prefix (let ((count (count-lines (mark) (point))))
                 (goto-char (min (mark) (point)))
                 (while (> count 0) (setq count (1- count))
                        (beginning-of-line 1) (insert prefix)
                        (end-of-line 1) (forward-char 1))))))

;;;;; Global Keybindings ;;;;;;

; Now the functions are defined, we can assign them to keys.
(global-set-key (kbd "C-c C-y")  'duplicate-line)
(global-set-key (kbd "C-c y")    'duplicate-region)
(global-set-key (kbd "C-c Y")    'duplicate-line)
(global-set-key (kbd "C-c C-l")  'mark-line-and-copy) ;has many modal
						      ;remappings
(global-set-key (kbd "C-c l")    'mark-line-and-copy)

;; keyboard mods not specific to any mode.
;;  note the use of kbd function to make these work better
;;  cross-platform
(global-set-key (kbd "C-h") 'delete-backward-char)   ;backspace, not help!
(global-set-key (kbd "C-c g") 'goto-line)
(global-set-key (kbd "<home>") 'beginning-of-line)   ;instead of top-of-screen
(global-set-key (kbd "<end>") 'end-of-line)      ;inactive by default?

(global-set-key (kbd "C-<home>") 'beginning-of-buffer) ;M$-style beginning and
(global-set-key (kbd "C-<end>") 'end-of-buffer)        ;same bindings for

(global-set-key (kbd "<delete>") 'delete-char)    ; delete char, don't
						  ; move cursor.

(global-set-key (kbd "M-C-h") 'backward-kill-word)

(global-set-key (kbd "<f2>") 'other-window)       ;convenient shortcuts.
(global-set-key (kbd "<f3>") 'kill-this-buffer)
(global-set-key (kbd "<f4>") 'speedbar-get-focus) ;jump to the speedbar.

(global-unset-key (kbd "ESC ESC"))         ;eval-expr gets in my way.
(global-set-key (kbd "C-x C-u") 'undo)     ;bind to something useful.
;; Bind ctrl-z to undo instead of default of
;; go to background.
(global-set-key (kbd "C-z") 'undo)

(global-set-key (kbd "C-`") 'capitalize-word)      ;I want c-~, but
						   ;that's too
                                                   ;hard to type.
;; make hippie-expand easy to access
(global-set-key (kbd "M-SPC") 'hippie-expand)
(setq hippie-expand-try-functions-list
          '(try-expand-line
            try-expand-dabbrev
            try-expand-line-all-buffers
            try-expand-list
            try-expand-list-all-buffers
            try-expand-dabbrev-visible
            try-expand-dabbrev-all-buffers
            try-expand-dabbrev-from-kill
            try-complete-file-name
            try-complete-file-name-partially
            try-complete-lisp-symbol
            try-complete-lisp-symbol-partially
            try-expand-whole-kill))

;; Duplicates of some of the keys above so everything works
;; properly on remote xterms.
(global-set-key "\eOH" 'beginning-of-line)
(global-set-key "\eOF" 'end-of-line)
(global-set-key "\e[1~" 'beginning-of-line)
(global-set-key "\e[4~" 'end-of-line)
(global-set-key "\e[1^" 'beginning-of-buffer)
(global-set-key "\e[4^" 'end-of-buffer)
(global-set-key "\e[11~" 'help)
(global-set-key "\e[12~" 'other-window)
(global-set-key "\e[13~" 'kill-this-buffer)
(global-unset-key "\e\e")


;; Keys that Jeff likes - maybe I'll try them too.
(global-set-key (kbd "C-x C-k") 'compile)
(global-set-key (kbd "C-x C-j") 'fill-paragraph)
;; Make the sequence "C-x w" execute the `what-line' command, which
;; prints the current line number in the echo area.
(global-set-key (kbd "C-x w") 'what-line)

(global-set-key [(shift down-mouse-2)]     ;<shift>-mouse2 to load
                'browse-url-at-mouse)      ;url at point into netscape.


;;;;; Global Settings ;;;;;

;; start in homedir
(cd "~")

;; Miscellaneous settings
(setq inhibit-startup-message t)           ;don't need it anymore.
(setq transient-mark-mode t)               ;where's that selection?
(setq lpr-command "a2ps")   ;use my favorite print program.
(setq lpr-switches nil)
(setq mouse-yank-at-point t)               ;paste at point NOT at cursor
(setq next-line-add-newlines nil)          ;no newlines if I cursor past EOF.
;(standard-display-european t)              ;disable multibyte support.
(setq minibuffer-max-depth nil)            ;enable multiple minibuffers:
 ;I didn't understand this for a long time - if you don't set this,
 ;you can't do things like search the minibuffer history with M-s
 ;(cause that requires another minibuffer)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "open")
(setq browse-url-new-window-p t)           ;open a fresh netscape window.

;; Set the modeline to tell me the filename, hostname, etc..
(setq-default mode-line-format
      (list " "
            'mode-line-modified
            "--"
            'mode-line-buffer-identification
            "--"
            'mode-line-modes
            '(which-func-mode ("" which-func-format "--"))
            'mode-line-position
            "--"
            `(vc-mode vc-mode)
            "--"
            'system-name
            "-%-"
            )
)

;; set the modeline to blue on white
; you HAVE to set mode-line-inverse-video to t, otherwise the face
; gets ignored. Retarded.  That means you have to reverse the colors -
; setting foreground color actually sets background.
; see this gem: http://www.delorie.com/gnu/docs/emacs/emacs_89.html
(cond
 ((not window-system)
  (setq mode-line-inverse-video t)
  (set-face-foreground 'modeline "blue")
  (set-face-background 'modeline "white")
))

;; Don't truncate lines in vertically split windows (suggested by Jeff).
(setq truncate-partial-width-windows nil)

;; I hate tabs.  Don't allow them.
(setq-default indent-tabs-mode nil)

;; Set up default editing mode.
(setq default-major-mode 'indented-text-mode)
(toggle-text-mode-auto-fill)       ;always auto-fill in text mode.

(menu-bar-mode (if window-system 1 -1))
(if (functionp 'tool-bar-mode) (tool-bar-mode -1))

;; turn off tab bar mode in aquamacs
(if (functionp 'tabbar-mode) (tabbar-mode -1))

;; I like seeing the line and column in my modeline.
(setq line-number-mode t)
(setq column-number-mode t)

;; Disable RMAIL so accidentally starting it doesn't munge your mbox
(put 'rmail 'disabled t)

;; I want to know which function I'm currently in.
(which-func-mode)

;; bugfix for c-xc-x behavior, suggested by @jeramey
(defadvice exchange-point-and-mark (after epam-deactivate-mark)
  "Use `deactivate-mark' after running `exchange-point-and-mark'. This
helps it play nicer with `transient-mark-mode'."
  (deactivate-mark))

(ad-activate 'exchange-point-and-mark)

;; I like the extra feedback from icomplete-mode
;; http://www.gnu.org/software/libtool/manual/emacs/Completion-Options.html#Completion-Options
(setq-default icomplete-mode t)

;;;; Package Load and Configuration ;;;;
;;;;; org-mode ;;;;;
(setq load-path (cons "~/.emacstuff/org-mode/lisp" load-path))
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
;(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(add-hook 'org-mode-hook 'turn-on-font-lock)  ; Org buffers only

;(load "org-exp")
;(load "org-latex")

(setq org-log-done (quote time))
(setq org-log-into-drawer t)

;;;;; org-mode beamer export ;;;;;
;; allow for export=>beamer by placing

;; #+LaTeX_CLASS: beamer in org files
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
  ;; beamer class, for presentations
  '("beamer"
     "\\documentclass[11pt]{beamer}\n
      \\mode<{{{beamermode}}}>\n
      \\usetheme{{{{beamertheme}}}}\n
      \\usecolortheme{{{{beamercolortheme}}}}\n
      \\beamertemplateballitem\n
      \\setbeameroption{show notes}
      \\usepackage[utf8]{inputenc}\n
      \\usepackage[T1]{fontenc}\n
      \\usepackage{hyperref}\n
      \\usepackage{color}
      \\usepackage{listings}
      \\lstset{numbers=none,language=[ISO]C++,tabsize=4,
  frame=single,
  basicstyle=\\small,
  showspaces=false,showstringspaces=false,
  showtabs=false,
  keywordstyle=\\color{blue}\\bfseries,
  commentstyle=\\color{red},
  }\n
      \\usepackage{verbatim}\n
      \\institute{{{{beamerinstitute}}}}\n
       \\subject{{{{beamersubject}}}}\n"

     ("\\section{%s}" . "\\section*{%s}")

     ("\\begin{frame}[fragile]\\frametitle{%s}"
       "\\end{frame}"
       "\\begin{frame}[fragile]\\frametitle{%s}"
       "\\end{frame}")))

  ;; letter class, for formal letters

  (add-to-list 'org-export-latex-classes

  '("letter"
     "\\documentclass[11pt]{letter}\n
      \\usepackage[utf8]{inputenc}\n
      \\usepackage[T1]{fontenc}\n
      \\usepackage{color}"

     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
     ("\\paragraph{%s}" . "\\paragraph*{%s}")
     ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  ;; article class
  (add-to-list 'org-export-latex-classes
	       '("article"
		 "\\documentclass{article}"
		 ("\\section{%s}" . "\\section*{%s}")
		 ("\\subsection{%s}" . "\\subsection*{%s}")))

;;;;; filladapt-mode ;;;;;
;; (filladapt.el) Augment the standard fill-mode
;; with more smarts - handles multiply quoted mail text, for example.
;(require 'filladapt)
; always use filladapt in several modes
;(add-hook 'text-mode-hook 'turn-on-filladapt-mode)
;(add-hook 'emacs-lisp-mode 'turn-on-filladapt-mode)

;;;;; pager.el
;; more sensible scrolling behavior
;; from: http://user.it.uu.se/~mic/pager.el
(require 'pager)
(global-set-key "\C-v"     'pager-page-down)
(global-set-key [next]     'pager-page-down)
(global-set-key "\ev"      'pager-page-up)
(global-set-key [prior]    'pager-page-up)
(global-set-key '[M-up]    'pager-row-up)
(global-set-key '[M-kp-8]  'pager-row-up)
(global-set-key '[M-down]  'pager-row-down)
(global-set-key '[M-kp-2]  'pager-row-down)

;;;;; evernote-mode.el
(require 'evernote-mode)
(setq evernote-username "phollenback") ; optional: you can use this username as default.
(setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8")) ; option
(setq evernote-ruby-command "/opt/local/bin/ruby")
(setq evernote-password-cache t)
(global-set-key "\C-cec" 'evernote-create-note)
(global-set-key "\C-ceo" 'evernote-open-note)
(global-set-key "\C-ces" 'evernote-search-notes)
(global-set-key "\C-ceS" 'evernote-do-saved-search)
(global-set-key "\C-cew" 'evernote-write-note)
(global-set-key "\C-cep" 'evernote-post-region)
(global-set-key "\C-ceb" 'evernote-browser)

;;;;; template.el ;;;;;
(require 'template)
(template-initialize)

;;;;; cperl ;;;;;
;; force cperl instead of perl mode
(fset 'perl-mode 'cperl-mode)
; default macos version of cperl doesn't have
; cperl-set-style, so don't set it if it doesn't
; exist, to avoid a startup error.
(if (functionp 'cperl-set-style)
    (cperl-set-style "GNU"))
(setq cperl-electric-keywords t)
(setq cperl-continued-brace-offset -2)
(setq cperl-extra-newline-before-brace t)

;;;;; perlnow ;;;;;
(require 'perlnow)

(setq perlnow-script-location
      (substitute-in-file-name "$HOME/bin"))
(setq perlnow-pm-location
      (substitute-in-file-name "$HOME/lib"))
(setq perlnow-dev-location
      (substitute-in-file-name "$HOME/dev"))

(perlnow-define-standard-keymappings)

;;;;; tramp ;;;;;
;; more powerful replacement for efs and ange-ftp
(add-to-list 'load-path "~/share/emacs/site-lisp")
(require 'tramp)
(add-to-list 'Info-default-directory-list "~/share/tramp/info/")

;;;;; uniquify ;;;;;
;; give buffers more intelligent names.
;; standard emacs package.
(require 'uniquify)
; create unique buffer names with shared directoy components.
;(setq uniquify-buffer-name-style 'forward)

;;;;; a2ps-print ;;;;;
;; print buffer or region using a2ps
(load "a2ps-print")
; 2 pages per side, double sided
(setq a2ps-switches `("-2" "-s 2"))
(global-set-key (kbd "<f5>") 'a2ps-buffer)
(global-set-key "\e[15~" 'a2ps-buffer)
(global-set-key (kbd "S-<f5>") 'a2ps-region-1)
(global-set-key "\e[28~" 'a2ps-region-1)

;;;;; markdown-mode ;;;;;
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

;;;;; iswitchb ;;;;;
;; A quicker way to switch between buffers.  C-xb will
;; give a list of buffers, and what you then type is matched as a
;; substring.  One of those things that is hard to explain, but very
;; easy to use.  Standard GNU Emacs package.
;(iswitchb-default-keybindings)
(iswitchb-mode 1)

;;;;; php-mode ;;;;;
;; Add a mode for editing php code.
;; http://www.ontosys.com/reports/PHP.html
(autoload 'php-mode "php-mode" "PHP editing mode" t)
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php3\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php4\\'" . php-mode))

;;;;; redo ;;;;
;; Handy little redo function (redo.el)
;; http://www.wonderworks.com/
(require 'redo)
(global-set-key (kbd "C-x C-r") 'redo) ;consistent with my undo.

;;;;; whitespace ;;;;;
;; An extremely powerful package to strip whitespace from a file.  If all
;; developers would use this, diff problems would be eliminated and code
;; would be cleaner. (whitespace.el).
;; http://www.splode.com/users/friedman/software/emacs-lisp/
(autoload 'nuke-trailing-whitespace "whitespace" nil t)
; Strip whitespace when saving files.  whitespace.el contains a list
; of modes to operate in.
; This appears to cause console GNU Emacs to segfault, you have been
; warned...
(add-hook 'write-file-hooks 'nuke-trailing-whitespace)

;;;;; rect-mark ;;;;;
;; Support for marking a rectangle of text with highlighting (rect-mark.el).
; ftp://ls6-ftp.cs.uni-dortmund.de/pub/src/emacs/
(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x") 'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w") 'rm-kill-region)
(global-set-key (kbd "C-x r M-w") 'rm-kill-ring-save)
                                        ;<shift>-<mouse button 1> now does a rectangular mark.
(global-set-key [(shift down-mouse-1)] 'rm-mouse-drag-region)
(autoload 'rm-set-mark "rect-mark"
  "Set mark for rectangle." t)
(autoload 'rm-exchange-point-and-mark "rect-mark"
  "Exchange point and mark for rectangle." t)
(autoload 'rm-kill-region "rect-mark"
  "Kill a rectangular region and save it in the kill ring." t)
(autoload 'rm-kill-ring-save "rect-mark"
  "Copy a rectangular region to the kill ring." t)
(autoload 'rm-mouse-drag-region "rect-mark"
  "Drag out a rectangular region with the mouse." t)

;;;;; dired+ ;;;;;
;; dired extensions
;; http://www.emacswiki.org/emacs/DiredPlus
(require 'dired+)

;;;;; ispell ;;;;;
(setq-default ispell-program-name "/opt/local/bin/aspell")
(require 'ispell)

;;;;; post ;;;;;
;; mutt mail message editing mode (post.el)
;; http://sourceforge.net/projects/post-mode/
(require 'post)

;; Add an informative message when editing mail messages under post.el.
;; I should combine these cases more elegantly.
(defadvice server-process-filter (after post-mode-message first activate)
  "If the buffer is in post mode, overwrite the server-edit
   message with a post-save-current-buffer-and-exit message."
  (if (eq major-mode 'post-mode)
      (progn
        (message
         (substitute-command-keys
          "Type \\[describe-mode] for help composing; \
\\[post-save-current-buffer-and-exit] when done.")))))


; Make sure we get moved to the message body when using emacsclient.
(add-hook 'server-switch-hook
          (function (lambda()
                      (cond ((string-match "Post" mode-name)
                             (post-goto-body))))))

;; Customize post mode a bit.
(defun my-post-mode-hook ()
  ;Turn on abbrev mode
  ; (sort of a simple auto-correct for common mispellings).
  (setq abbrev-mode t)
  (read-abbrev-file (concat my-emacs-dir ".post_abbrev_defs"))
  (setq save-abbrevs t)
  ;Add a key binding for ispell-buffer.
  (local-set-key (kbd "C-c C-i") 'ispell-buffer)
  ;Put the cursor just where I want it - at the beginning of the body
  ;text.
  (post-goto-body)
  (beginning-of-line)
  ;(insert "\n")
  ;Bind ldap lookup to a key.
  (local-set-key (kbd "C-c C-m") 'insert-ldap-mail-search)
)
(add-hook 'post-mode-hook 'my-post-mode-hook)


;;;;; dictionary ;;;;;
;; Enable dictionary mode (dictionary.el).  With this, you can do a
;;  M-x dictionary-search and search a number of free
;;  dictionaries on the web for a definition.  Works great.
;; http://www.in-berlin.de/User/myrkr/dictionary.html
(autoload 'dictionary-search "dictionary"
  "Ask for a word and search it in all dictionaries" t)
(autoload 'dictionary-match-words "dictionary"
  "Ask for a word and search all matching words in the dictionaries" t)
(autoload 'dictionary "dictionary"
  "Create a new dictionary buffer" t)
; Assign keyboard shortcuts C-c s and C-c m.
(global-set-key (kbd "C-c s") 'dictionary-search)
(global-set-key (kbd "C-c m") 'dictionary-match-words)


;;;;; shebang ;;;;;
;; automatically set files executable if they have a valid bang-path
;; as the first lien.
(require 'shebang)

;;;;; html-mode ;;;;;
;; Enable html-helper-mode for editing html files.
;; http://www.gest.unipd.it/~saint/hth.html
;; Set some defaults.
(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)

; Update file timestamps automatically
(setq html-helper-do-write-file-hooks t)
; Insert template into new files.
(setq html-helper-build-new-buffer t)
; Ask for tag data in the minibuffer.
(setq tempo-interactive t)
; Turn on bigger menu.
(setq html-helper-use-expert-menu t)
(setq html-helper-address-string
      (concat "<a href=\"mailto:" user-mail-address "\">" user-full-name "</a>" ))


;;;;; jiggle ;;;;;
;; jiggle.el - a mode which jiggles the cursor whenever you do things
;; like change buffers.  Just a little visual reminder of where that
;; thing went.
;; http://www.eskimo.com/~seldon
;(require 'jiggle)
;(jiggle-mode 1)
;(setq jiggle-how-many-times 5)
;(jiggle-searches-too 1)

;;;;; auto-save ;;;;;
;; Load the auto-save.el package, which lets you put all of your autosave
;; files in one place, instead of scattering them around the file system.
;; ftp://archive.cis.ohio-state.edu/pub/emacs-lisp/misc/auto-save.el.Z
(setq auto-save-directory
      (expand-file-name (concat my-emacs-dir "autosave"))
      auto-save-directory-fallback auto-save-directory
      auto-save-hash-p nil
      efs-auto-save t
      efs-auto-save-remotely nil
      ;; now that we have auto-save-timeout, let's crank this up
      ;; for better interactive response.
      auto-save-interval 2000
      )
;; We load this afterwards because it checks to make sure the
;; auto-save-directory exists (creating it if not) when it's loaded.
(require 'auto-save)

;;;;; diminish ;;;;;
;; diminish.el - change modeline displays for minor modes.  If you
;; enable a lot of minor modes at once, the modeline goes off the end
;; off the screen.  This allows you to give the minor modes shorter
;; display names.
;; http://www.eskimo.com/~seldon
;(require 'diminish)
;(diminish 'abbrev-mode "Abv")
;(diminish 'auto-fill-function " F")
;(diminish 'font-lock-mode "Fn")
;(diminish 'filladapt-mode "FA")
;(diminish 'jiggle-mode)

;;;;; crypt++ ;;;;;;
;; use crypt++ to transparently encode/decode gpg encrypted files.
;; replaced by EasyPG in emacs 23 and later.
;(require 'crypt++)
;; set the default encryption type to gpg
;(setq crypt-encryption-type 'gpg)

;;;;; vc ;;;;;
;; I used to have a bunch of vc-mode customizations here, but they
;; all seemed to break with GNU Emacs so I've removed them.
(require 'vc)

;;;;; google-weather ;;;;
                                        ;
;(require `google-weather)

;;;;; gist ;;;;;
(setq tls-program '("openssl s_client -connect %h:%p -no_ssl2 -ign_eof"))
(require 'gist)

;;;;; desktop ;;;;;
;; save desktop and other histories on exit.
;; save a list of open files in ~/.emacs.desktop

;;;;; bubble-buffer ;;;;;
;;   http://xsteve.nit.at/prg/emacs/bubble-buffer.el
;(require 'bubble-buffer)
;(global-set-key (kbd "<f11>") 'bubble-buffer-next)
;(global-set-key (kbd "S-<f11>") 'bubble-buffer-previous)

;; save the desktop file automatically if it already exists
(setq desktop-save 'if-exists)
(desktop-save-mode 1)

; don't save gpg-encrypted buffers
(setq desktop-buffers-not-to-save
      (concat "\\("
              "\\.gpg"
              "\\)$"))

;; save a bunch of variables to the desktop file
;; for lists specify the len of the maximal saved data also
(setq desktop-globals-to-save
      (append '((extended-command-history . 30)
                (file-name-history        . 100)
                (grep-history             . 30)
                (compile-history          . 30)
                (minibuffer-history       . 50)
                (query-replace-history    . 60)
                (read-expression-history  . 60)
                (regexp-history           . 60)
                (regexp-search-ring       . 20)
                (search-ring              . 20)
                (shell-command-history    . 50)
                tags-file-name
                register-alist)))

;;;;; font-lock ;;;;;
;; Font-Lock is a syntax-highlighting package.
(setq font-lock-use-default-fonts nil)
(setq font-lock-use-default-colors nil)

;; force fontification of everything.
(global-font-lock-mode t)
(require 'font-lock)

;; Mess around with the faces a bit.  Note that you have
;; to change the font-lock-use-default-* variables *before*
;; loading font-lock, and wait till *after* loading font-lock
;; to customize the faces.

;; string face is green
(set-face-foreground 'font-lock-string-face "yellow")

;; function names are bold green
(copy-face 'bold 'font-lock-function-name-face)
(set-face-foreground 'font-lock-function-name-face "green")

;; comments are green2
(copy-face 'font-lock-comment-face 'font-lock-doc-string-face)
(set-face-foreground 'font-lock-comment-face "green2")

;; misc. faces
(copy-face 'italic 'font-lock-type-face)
(set-face-foreground 'font-lock-keyword-face "orchid")
(set-face-foreground 'font-lock-variable-name-face "white")
(set-face-foreground 'font-lock-type-face "yellow")

; Turn off debug-on-error now that file loaded.
(setq debug-on-error nil)

;;;; Emacs Control ;;;;

;; Local Variables:
;; mode: outline-minor
;; center-line-decoration-char: ?-
;; center-line-padding-length: 1
;; center-line-leader: ";;;; "
;; fill-column: 77
;; line-move-ignore-invisible: t
;; outline-regexp: ";;;;+"
;; page-delimiter: "^;;;;"
;; End:

;;; End of my .emacs

;;;; Revision Control Log ;;;;

;; $Log: .emacs,v $
;; Revision 1.2  2005/09/01 20:19:33  hollenba
;; mouse avoidance mode was annoying me so I turned it off.
;;
;; Revision 1.1  2005/08/31 21:49:44  hollenba
;; Initial revision
;;
;; Revision 1.26  2000/09/07 22:00:08  philip
;; Many structural changes.  Added outline-mode headers for easier naviagation.
;; Turn on debug mode for duration of .emacs loading.
;; Put my user defaults in a separate file.
;; Move global functions to a central location.
;; turn off truncate-partial-width-windows
;; Revamped all keyboard shortcuts to hopefully be consistent.
;; Configured ldap parameters
;;
;; Revision 1.25  2000/08/12 00:03:12  philip
;; Big and little changes:
;; Corrected movement key bindings to hopefully work properly on xterms.
;; Set uniquify to actually do something (default setting was no buffer
;; name changes.
;; Corrected a2ps.el keys to work on xterm.
;; Dropped todo mode, as I don't actually use it.
;; Tweaked a few html-helper settings.
;; Added jiggle-mode to make cursor more visible sometimes.
;; Added diminish-mode to make minor mode line indicators briefer.
;; Got rid of widget-button and speedbar-selected faces which don't seem
;; to exist all the time.
;;
;; Revision 1.24  2000/08/09 20:12:24  philip
;; Changed sgml options slightly.
;; turned tempo-interactive on for html-helper in xemacs
;;
;; Revision 1.23  2000/08/04 23:26:38  philip
;; Turned on uniqify to give more intelligent names to buffers.
;; Enabled crypt mode to transparently open encrypted and compressed files.
;; Added a2ps.el for convenient printing of buffer via a2ps.  Bound to f5.
;; Added a few customizations for psgml.
;; Only load my own html-helper if under GNU Emacs (html mode with xemacs
;; is already good).
;;
;; Revision 1.22  2000/08/01 20:00:52  philip
;; Added some keys suggested by Jeff Jones.
;; Twekaed faces a bit.
:;; Change mosue-avoidance mode.
;;
;; Revision 1.21  2000/07/31 21:41:55  philip
;; Removed redundant text-mode setup commands.
;; Removed cycle-buffers function, since I nver use it.
;; Converted cc-mode keyboard bindings to use "kbd" macro.
;;
;; Revision 1.20  2000/07/31 19:31:15  philip
;; Added filladapt.el for better paragraph filling.  Upgraded to latest
;; (5.27) cc-mode.  Tweaked jde and cc modes.
;;
;; Revision 1.19  2000/07/25 00:06:54  philip
;; Got rid of all those GNUEmacs/XEmacs macros, as they were cumbersome
;; and created some weird problems.  Added a keyboard command for
;; capitialize-word.  Added todo-mode for tracking todo items.
;;
;; Revision 1.18  2000/07/24 20:28:53  philip
;; GNU Emacs needs rsz-mini instead of rsz-minibuf.  Changed browse-url to open a
;; fresh netscape window.  Re-enabled catdoc in xemacs as I fixed its problems.
;; Turned on rsz-minibuf.
;;
;; Revision 1.17  2000/07/21 20:36:32  philip
;; Corrected load of mouse-avoid - it must be custom-set. Added auto
;; minibuffer-resize functionality.  Added a whole bunch of vc, cc, and
;; java mode improvements suggested by Harvey Thompson.
;;
;; Revision 1.16  2000/07/20 20:05:53  philip
;; Corrected xemacs mouse button for browse-url. Set mouse-avoid to
;; animate.
