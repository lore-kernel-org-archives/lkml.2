Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2LQO4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:56:11 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:45582 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2LQO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:56:07 -0500
Date: Mon, 17 Dec 2012 22:56:14 +0800
From: Wang YanQing <udknight@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
Subject: [PATCH 2/2] menuconfig: Get rid of the top-level entries for "Load
 an Alternate/Save an Alternate"
Message-ID: <20121217145614.GC17427@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
	sakiwit@gmail.com, lacombar@gmail.com,
	lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have Load/Save buttons to do the Load/Save
in the convenient place, so we can drop the
top-level entries.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 scripts/kconfig/mconf.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index c074f8a..0ac1524 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -593,14 +593,6 @@ static void conf(struct menu *menu, struct menu *active_menu)
 		build_conf(menu);
 		if (!child_count)
 			break;
-		if (menu == &rootmenu) {
-			item_make("--- ");
-			item_set_tag(':');
-			item_make(_("    Load an Alternate Configuration File"));
-			item_set_tag('L');
-			item_make(_("    Save an Alternate Configuration File"));
-			item_set_tag('S');
-		}
 		dialog_clear();
 		res = dialog_menu(prompt ? _(prompt) : _("Main Menu"),
 				  _(menu_instructions),
@@ -637,12 +629,6 @@ static void conf(struct menu *menu, struct menu *active_menu)
 			case 's':
 				conf_string(submenu);
 				break;
-			case 'L':
-				conf_load();
-				break;
-			case 'S':
-				conf_save();
-				break;
 			}
 			break;
 		case 2:
-- 
1.7.11.1.116.g8228a23
