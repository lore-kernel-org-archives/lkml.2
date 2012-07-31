Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2GaS6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:58:40 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41370 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2GaS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:58:36 -0400
Message-ID: <50182ACF.6070704@gmail.com>
Date: Tue, 31 Jul 2012 14:58:23 -0400
From: Salar Ali Mumtaz <salaarali@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] xconfig: Display dependency values in debug_info
References: <1343256982-11421-1-git-send-email-salaarali@gmail.com> <50107EB7.8000009@xenotime.net> <CA+jpPM=nrbpDJpaka6xAp4dbEOQjJrtwQWtUXwi_gGS9b4yK-A@mail.gmail.com> <50117812.5080302@xenotime.net>
In-Reply-To: <50117812.5080302@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the debug_info only shows y/n/m values.

Signed-off-by: Salar Ali Mumtaz <salaarali@gmail.com>
---
 scripts/kconfig/qconf.cc |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index df274fe..b6a7cc5 100644
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
@@ -1152,11 +1157,18 @@ void ConfigInfoView::expr_print_help(void *data, struct symbol *sym, const char
 {
 	QString* text = reinterpret_cast<QString*>(data);
 	QString str2 = print_filter(str);
+	QString value;
 
 	if (sym && sym->name && !(sym->flags & SYMBOL_CONST)) {
+		value = print_filter(sym_get_string_value(sym));
+
 		*text += QString().sprintf("<a href=\"s%p\">", sym);
 		*text += str2;
 		*text += "</a>";
+		*text += "<b>   ";
+		if(value == "y" || value == "m" || value == "n")
+			*text += print_filter(sym_get_string_value(sym));
+		*text += "</b>";
 	} else
 		*text += str2;
 }
-- 
1.7.5.4
