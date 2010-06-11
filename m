Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0FKFYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:24:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65405 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab0FKFX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SPJdzmf1RWIpaw96Sy/Gn9meB1m5jm6y+gBNnMarsusPyvYAw4KgfM7V6veFngInrx
         MXfiDm7WLdc+r1+avv7UbV2L04yoxA5XPpQxYamNJ8HTmUO++uTkPWPzyznUnorAsgV8
         Q2jML+qk4rJR7vzy9Qs55t7sksEevN+gErQ/4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andi@firstfloor.org, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]script:conf.c Fix warning: variable 'type' set but not used
Date: Thu, 10 Jun 2010 22:23:52 -0700
Message-Id: <1276233832-17193-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is correct or not, but with 
make menuconfig
  HOSTCC  scripts/kconfig/conf.o
scripts/kconfig/conf.c: In function 'conf_sym':
scripts/kconfig/conf.c:159:6: warning: variable 'type' set but not used
scripts/kconfig/conf.c: In function 'conf_choice':
scripts/kconfig/conf.c:231:6: warning: variable 'type' set but not used
  HOSTLD  scripts/kconfig/mconf

I get this using gcc 4.6.0 the below change fixes this form me.
(not sure with earlier version of gcc).
please have a look and let me know.
 
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 scripts/kconfig/conf.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 9960d1c..d6369e8 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -156,14 +156,12 @@ static int conf_string(struct menu *menu)
 static int conf_sym(struct menu *menu)
 {
 	struct symbol *sym = menu->sym;
-	int type;
 	tristate oldval, newval;
 
 	while (1) {
 		printf("%*s%s ", indent - 1, "", _(menu->prompt->text));
 		if (sym->name)
 			printf("(%s) ", sym->name);
-		type = sym_get_type(sym);
 		putchar('[');
 		oldval = sym_get_tristate_value(sym);
 		switch (oldval) {
@@ -228,11 +226,9 @@ static int conf_choice(struct menu *menu)
 {
 	struct symbol *sym, *def_sym;
 	struct menu *child;
-	int type;
 	bool is_new;
 
 	sym = menu->sym;
-	type = sym_get_type(sym);
 	is_new = !sym_has_value(sym);
 	if (sym_is_changable(sym)) {
 		conf_sym(menu);
-- 
1.7.1.rc1.21.gf3bd6

