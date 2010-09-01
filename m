Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0IAPVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:21:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab0IAPVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:21:31 -0400
Date: Wed, 1 Sep 2010 11:21:30 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, aris@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: fix oldnoconfig to do the right thing
Message-ID: <20100901152130.GY2684@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Commit 861b4ea4 broke oldnoconfig when removed the oldnoconfig checks on
                       if (input_mode == nonint_oldconfig ||
                           input_mode == oldnoconfig) {
                               if (input_mode == nonint_oldconfig &&
                                   sym->name &&
                                    !sym_is_choice_value(sym)) {
to avoid oldnoconfig chugging through the else stanza.

Fix that to restore expected behaviour (which I've confirmed in the
Fedora kernel build that the configs end up looking the same.)

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 5b7c86e..7ef429c 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -427,7 +427,7 @@ static void check_conf(struct menu *menu)
 				if (sym->name && !sym_is_choice_value(sym)) {
 					printf("CONFIG_%s\n", sym->name);
 				}
-			} else {
+			} else if (input_mode != oldnoconfig) {
 				if (!conf_cnt++)
 					printf(_("*\n* Restart config...\n*\n"));
 				rootEntry = menu_get_parent_menu(menu);
