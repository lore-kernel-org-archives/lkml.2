Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0IJIdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:33:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54792 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab0IJIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OclcF4G3O/4zzydEs1PF8o++FE6/QUmZIrT+P3ZJtEExeZ8pvQ6jHFotLa4YcHDILw
         Q3z6hbjjrosy3XyJxbxu2LjEFBulU8MZooX/EIpQsRfWkDqvdVtPffAtChFypz6gWW01
         il7wbqT9CKup6x9WD76DdF1Q7ZKuuw+iJI7mQ=
From: Stephen Boyd <bebarino@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>
Subject: [PATCH] nconfig: Fix help for choice menus
Date: Fri, 10 Sep 2010 01:32:50 -0700
Message-Id: <1284107570-17124-1-git-send-email-bebarino@gmail.com>
X-Mailer: git-send-email 1.7.2.3.313.gcd15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When getting the help for a choice menu with a help section (for example
the "Choose SLAB allocator" menu) nconfig pops up a window with nothing
inside it. This is due to show_help() passing an empty string to
show_scroll_win()'s 3rd argument. The option really does have help
though, but it isn't a config symbol, so just add the help text for
the option, and don't try to add anything else like the config option
name.

Signed-off-by: Stephen Boyd <bebarino@gmail.com>
Cc: Nir Tzachar <nir.tzachar@gmail.com>
---
 scripts/kconfig/nconf.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 2ba71bc..19d3401 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -1252,6 +1252,8 @@ static void show_help(struct menu *menu)
 			str_append(&help, _(menu_get_help(menu)));
 			str_append(&help, "\n");
 			get_symbol_str(&help, menu->sym);
+		} else {
+			str_append(&help, _(menu_get_help(menu)));
 		}
 	} else {
 		str_append(&help, nohelp_text);
-- 
1.7.2.3.313.gcd15

