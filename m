Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1GJH1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 03:27:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52387 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab1GJH1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 03:27:20 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Andrej Gelenberg <andrej.gelenberg@udo.edu>
Subject: [PATCH 1/2] kconfig/nconf: use the generic menu_get_ext_help()
Date: Sun, 10 Jul 2011 03:27:04 -0400
Message-Id: <1310282825-14509-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <CACqU3MXvHR0v4Hgn5UMwDtzaX5nWqmKEneN_s7r4PuEGzifauw@mail.gmail.com>
References: <CACqU3MXvHR0v4Hgn5UMwDtzaX5nWqmKEneN_s7r4PuEGzifauw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nconf is the only front-end which does not use this helper, but prefer to
copy/paste the code. The test wrt. menu validity added in this version of the
code is bogus anyway as an invalid menu will get dereferenced a few line below
by calling menu_get_prompt().

For now, convert nconf to use menu_get_ext_help(), as do every other front-end.
We will deals with menu validity checks properly in a separate commit.

Cc: Nir Tzachar <nir.tzachar@gmail.com>
Cc: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/nconf.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index da9f5c4..24fc79a 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -1223,19 +1223,7 @@ static void conf_message_callback(const char *fmt, va_list ap)
 static void show_help(struct menu *menu)
 {
 	struct gstr help = str_new();
-
-	if (menu && menu->sym && menu_has_help(menu)) {
-		if (menu->sym->name) {
-			str_printf(&help, "%s%s:\n\n", CONFIG_, menu->sym->name);
-			str_append(&help, _(menu_get_help(menu)));
-			str_append(&help, "\n");
-			get_symbol_str(&help, menu->sym);
-		} else {
-			str_append(&help, _(menu_get_help(menu)));
-		}
-	} else {
-		str_append(&help, nohelp_text);
-	}
+	menu_get_ext_help(menu, &help);
 	show_scroll_win(main_window, _(menu_get_prompt(menu)), str_get(&help));
 	str_free(&help);
 }
-- 
1.7.3.4.574.g608b.dirty

