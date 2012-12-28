Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2L1Tky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:40:54 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:51094 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab2L1Tks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:40:48 -0500
From: Dmitry Voytik <dvv.kernel@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Stephen Boyd <sboyd@codeaurora.org>, dvv.kernel@gmail.com,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] nconf: add vi-style command keys for the menu navigation
Date: Fri, 28 Dec 2012 23:40:07 +0400
Message-Id: <1356723607-17027-1-git-send-email-dvv.kernel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20121228185108.GA13644@voyt-hp>
References: <20121228185108.GA13644@voyt-hp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add alternative vi-style keys for the menu navigation:
<j>/<k> for down/up navigation, <C-f>/<C-b> for
page down/up, <g>/<G> for first/last menu item selection
and <l> for entering to a submenu.

Signed-off-by: Dmitry Voytik <dvv.kernel@gmail.com>
---
 scripts/kconfig/nconf.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index ce93e87..632447b 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -13,6 +13,8 @@
 #include "nconf.h"
 #include <ctype.h>
 
+#define KEY_CONTROL(k) ((k) & 0x1f)
+
 static const char nconf_readme[] = N_(
 "Overview\n"
 "--------\n"
@@ -38,10 +40,10 @@ static const char nconf_readme[] = N_(
 "\n"
 "Menus\n"
 "----------\n"
-"o  Use the Up/Down arrow keys (cursor keys) to highlight the item\n"
-"   you wish to change use <Enter> or <Space>. Goto submenu by \n"
-"   pressing <Enter> of <right-arrow>. Use <Esc> or <left-arrow> to go back.\n"
-"   Submenus are designated by \"--->\".\n"
+"o  Use the Up/Down arrow keys (cursor keys) or <j>/<k> to highlight\n"
+"   the item you wish to change use <Enter> or <Space>. Goto submenu by\n"
+"   pressing <Enter>, <right-arrow> or <l>. Use <Esc> or <left-arrow>\n"
+"   to go back. Submenus are designated by \"--->\".\n"
 "\n"
 "   Searching: pressing '/' triggers interactive search mode.\n"
 "              nconfig performs a case insensitive search for the string\n"
@@ -51,8 +53,8 @@ static const char nconf_readme[] = N_(
 "              match string. Pressing either '/' again or ESC exits\n"
 "              search mode. All other keys behave normally.\n"
 "\n"
-"   You may also use the <PAGE UP> and <PAGE DOWN> keys to scroll\n"
-"   unseen options into view.\n"
+"   You may also use the <PAGE UP> (<C-b>) and <PAGE DOWN> (<C-f>) keys\n"
+"   to scroll unseen options into view.\n"
 "\n"
 "o  To exit a menu use the just press <ESC> <F5> <F8> or <left-arrow>.\n"
 "\n"
@@ -1116,21 +1118,27 @@ static void conf(struct menu *menu)
 				break;
 			switch (res) {
 			case KEY_DOWN:
+			case 'j':
 				menu_driver(curses_menu, REQ_DOWN_ITEM);
 				break;
 			case KEY_UP:
+			case 'k':
 				menu_driver(curses_menu, REQ_UP_ITEM);
 				break;
 			case KEY_NPAGE:
+			case KEY_CONTROL('f'):
 				menu_driver(curses_menu, REQ_SCR_DPAGE);
 				break;
 			case KEY_PPAGE:
+			case KEY_CONTROL('b'):
 				menu_driver(curses_menu, REQ_SCR_UPAGE);
 				break;
 			case KEY_HOME:
+			case 'g':
 				menu_driver(curses_menu, REQ_FIRST_ITEM);
 				break;
 			case KEY_END:
+			case 'G':
 				menu_driver(curses_menu, REQ_LAST_ITEM);
 				break;
 			case 'h':
@@ -1141,7 +1149,7 @@ static void conf(struct menu *menu)
 			if (res == 10 || res == 27 ||
 				res == 32 || res == 'n' || res == 'y' ||
 				res == KEY_LEFT || res == KEY_RIGHT ||
-				res == 'm')
+				res == 'm' || res == 'l')
 				break;
 			refresh_all_windows(main_window);
 		}
@@ -1170,6 +1178,7 @@ static void conf(struct menu *menu)
 			else if (item_is_tag('m'))
 				conf(submenu);
 			break;
+		case 'l':
 		case KEY_RIGHT:
 		case 10: /* ENTER WAS PRESSED */
 			switch (item_tag()) {
@@ -1301,21 +1310,27 @@ static void conf_choice(struct menu *menu)
 				break;
 			switch (res) {
 			case KEY_DOWN:
+			case 'j':
 				menu_driver(curses_menu, REQ_DOWN_ITEM);
 				break;
 			case KEY_UP:
+			case 'k':
 				menu_driver(curses_menu, REQ_UP_ITEM);
 				break;
 			case KEY_NPAGE:
+			case KEY_CONTROL('f'):
 				menu_driver(curses_menu, REQ_SCR_DPAGE);
 				break;
 			case KEY_PPAGE:
+			case KEY_CONTROL('b'):
 				menu_driver(curses_menu, REQ_SCR_UPAGE);
 				break;
 			case KEY_HOME:
+			case 'g':
 				menu_driver(curses_menu, REQ_FIRST_ITEM);
 				break;
 			case KEY_END:
+			case 'G':
 				menu_driver(curses_menu, REQ_LAST_ITEM);
 				break;
 			case 'h':
-- 
1.7.9.5

