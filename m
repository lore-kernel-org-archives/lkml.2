Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2GYW4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:56:35 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63932 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2GYW4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:56:32 -0400
From: Salar Ali Mumtaz <salaarali@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Salar Ali Mumtaz <salaarali@gmail.com>
Subject: [PATCH] xconfig: Display dependency values in debug_info
Date: Wed, 25 Jul 2012 18:56:22 -0400
Message-Id: <1343256982-11421-1-git-send-email-salaarali@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Displays the current value of each of the dependencies of a menu item.
Before, you needed to do tedious searching to find out the current values
of the dependences. Now they all are included in the debug_info, making
the task easier

Signed-off-by: Salar Ali Mumtaz <salaarali@gmail.com>
---
 scripts/kconfig/qconf.cc |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index df274fe..abd500f 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1073,8 +1073,10 @@ QString ConfigInfoView::debug_info(struct symbol *sym)
 		debug += " (choice)";
 	debug += "<br>";
 	if (sym->rev_dep.expr) {
-		debug += "reverse dep: ";
+		debug += "reverse dep: (";
 		expr_print(sym->rev_dep.expr, expr_print_help, &debug, E_NONE);
+		debug += " )  =";
+		debug += print_filter(sym_get_string_value(sym));
 		debug += "<br>";
 	}
 	for (struct property *prop = sym->prop; prop; prop = prop->next) {
@@ -1108,7 +1110,10 @@ QString ConfigInfoView::debug_info(struct symbol *sym)
 		}
 		if (prop->visible.expr) {
 			debug += "&nbsp;&nbsp;&nbsp;&nbsp;dep: ";
+			debug += " ( ";
 			expr_print(prop->visible.expr, expr_print_help, &debug, E_NONE);
+			debug += " )  =";
+			debug += print_filter(sym_get_string_value(sym));
 			debug += "<br>";
 		}
 	}
@@ -1157,6 +1162,9 @@ void ConfigInfoView::expr_print_help(void *data, struct symbol *sym, const char
 		*text += QString().sprintf("<a href=\"s%p\">", sym);
 		*text += str2;
 		*text += "</a>";
+		*text += "<b>   ";
+		*text += print_filter(sym_get_string_value(sym));
+		*text += "</b>";
 	} else
 		*text += str2;
 }
-- 
1.7.5.4

