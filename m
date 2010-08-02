Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab0HBXQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:16:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36002 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0HBXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:16:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Mm5QoBhy+eLAyZMzRXRdDMQeLaGiiJjuKHJokPFxCPe/jsZgPfJ6hHvPFOP9jsDFV2
         Jf6kCRw3JPdOk3ghysXfCiQkC1sp5c/KdE8VcpMvZ4L0cJgEcG/rPMj8ZwpzbYnRV132
         nofYYIs9/BQNWpxVEFpEB89RkmN9UyWbbB8yI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: zippel@linux-m68k.org, mmarek@suse.cz, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]scripts/kconfig/nconf.gui.c Fix warning: value computed is not used
Date: Mon,  2 Aug 2010 16:16:06 -0700
Message-Id: <1280790966-417-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes some warning messages Im getting when doing
make nconfig

 make nconfig
  HOSTCC  scripts/kconfig/nconf.gui.o
scripts/kconfig/nconf.gui.c: In function 'print_in_middle':
scripts/kconfig/nconf.gui.c:170:2: warning: value computed is not used
scripts/kconfig/nconf.gui.c: In function 'btn_dialog':
scripts/kconfig/nconf.gui.c:300:2: warning: value computed is not used
scripts/kconfig/nconf.gui.c:304:2: warning: value computed is not used
scripts/kconfig/nconf.gui.c: In function 'dialog_inputbox':
scripts/kconfig/nconf.gui.c:395:2: warning: value computed is not used
scripts/kconfig/nconf.gui.c:397:2: warning: value computed is not used
scripts/kconfig/nconf.gui.c:399:2: warning: value computed is not used
scripts/kconfig/nconf.gui.c:404:2: warning: value computed is not used
scripts/kconfig/nconf.gui.c: In function 'show_scroll_win':
scripts/kconfig/nconf.gui.c:534:2: warning: value computed is not used
scripts/kconfig/nconf.gui.c:549:2: warning: value computed is not used
scripts/kconfig/nconf.gui.c:551:2: warning: value computed is not used
  HOSTLD  scripts/kconfig/nconf
scripts/kconfig/nconf arch/x86/Kconfig

I looked around for a way to fix these, but am not familiar with ncurses.
if there's a better way let me know and/or send a seperate fix.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 scripts/kconfig/nconf.gui.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index a9d9344..08a5a04 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -167,7 +167,6 @@ void print_in_middle(WINDOW *win,
 	length = strlen(string);
 	temp = (width - length) / 2;
 	x = startx + (int)temp;
-	wattrset(win, color);
 	mvwprintw(win, y, x, "%s", string);
 	refresh();
 }
@@ -297,11 +296,9 @@ int btn_dialog(WINDOW *main_window, const char *msg, int btn_num, ...)
 	set_menu_fore(menu, attributes[DIALOG_MENU_FORE]);
 	set_menu_back(menu, attributes[DIALOG_MENU_BACK]);
 
-	wattrset(win, attributes[DIALOG_BOX]);
 	box(win, 0, 0);
 
 	/* print message */
-	wattrset(msg_win, attributes[DIALOG_TEXT]);
 	fill_window(msg_win, msg);
 
 	set_menu_win(menu, win);
@@ -392,16 +389,11 @@ int dialog_inputbox(WINDOW *main_window,
 	form_win = derwin(win, 1, prompt_width, prompt_lines+3, 2);
 	keypad(form_win, TRUE);
 
-	wattrset(form_win, attributes[INPUT_FIELD]);
-
-	wattrset(win, attributes[INPUT_BOX]);
 	box(win, 0, 0);
-	wattrset(win, attributes[INPUT_HEADING]);
 	if (title)
 		mvwprintw(win, 0, 3, "%s", title);
 
 	/* print message */
-	wattrset(prompt_win, attributes[INPUT_TEXT]);
 	fill_window(prompt_win, prompt);
 
 	mvwprintw(form_win, 0, 0, "%*s", prompt_width, " ");
@@ -531,7 +523,6 @@ void show_scroll_win(WINDOW *main_window,
 
 	/* create the pad */
 	pad = newpad(total_lines+10, total_cols+10);
-	wattrset(pad, attributes[SCROLLWIN_TEXT]);
 	fill_window(pad, text);
 
 	win_lines = min(total_lines+4, LINES-2);
@@ -546,9 +537,7 @@ void show_scroll_win(WINDOW *main_window,
 	win = newwin(win_lines, win_cols, y, x);
 	keypad(win, TRUE);
 	/* show the help in the help window, and show the help panel */
-	wattrset(win, attributes[SCROLLWIN_BOX]);
 	box(win, 0, 0);
-	wattrset(win, attributes[SCROLLWIN_HEADING]);
 	mvwprintw(win, 0, 3, " %s ", title);
 	panel = new_panel(win);
 
-- 
1.7.1.rc1.21.gf3bd6

