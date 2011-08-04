Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab1HDBwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:52:25 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55657 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab1HDBwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:52:19 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH 2/2] kconfig: factor code in menu_get_ext_help()
Date: Wed,  3 Aug 2011 21:52:07 -0400
Message-Id: <1312422727-9740-2-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1312422727-9740-1-git-send-email-lacombar@gmail.com>
References: <1312422727-9740-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/menu.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index beeb92e..8c2a97e 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -10,8 +10,7 @@
 
 #include "lkc.h"
 
-static const char nohelp_text[] = N_(
-	"There is no help available for this option.\n");
+static const char nohelp_text[] = "There is no help available for this option.";
 
 struct menu rootmenu;
 static struct menu **last_entry_ptr;
@@ -595,15 +594,14 @@ struct gstr get_relations_str(struct symbol **sym_arr)
 void menu_get_ext_help(struct menu *menu, struct gstr *help)
 {
 	struct symbol *sym = menu->sym;
+	const char *help_text = nohelp_text;
 
 	if (menu_has_help(menu)) {
 		if (sym->name)
 			str_printf(help, "%s%s:\n\n", CONFIG_, sym->name);
-		str_append(help, _(menu_get_help(menu)));
-		str_append(help, "\n");
-	} else {
-		str_append(help, nohelp_text);
+		help_text = menu_get_help(menu);
 	}
+	str_printf(help, "%s\n", _(help_text));
 	if (sym)
 		get_symbol_str(help, sym);
 }
-- 
1.7.6.153.g78432

