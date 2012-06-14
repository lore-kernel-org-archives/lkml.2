Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2FNWBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:01:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46152 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2FNWBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:01:13 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Cc: pebolle@tiscali.nl, bp@amd64.org, pawel.moll@arm.com, jbaron@redhat.com,
        gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH] init: add comments to keep initcall-names in sync with initcall levels
Date: Thu, 14 Jun 2012 16:00:59 -0600
Message-Id: <1339711260-1349-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

main.c has initcall_level_names[] for parse_args to print in debug messages,
add comments to keep them in sync with initcalls defined in init.h.

Also add "loadable" into comment re not using *_initcall macros in
modules, to disambiguate from kernel/params.c and other builtins.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/init.h |    3 ++-
 init/main.c          |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 6b95109..5e664f6 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -191,6 +191,7 @@ extern bool initcall_debug;
  * initializes variables that couldn't be statically initialized.
  *
  * This only exists for built-in code, not for modules.
+ * Keep main.c:initcall_level_names[] in sync.
  */
 #define pure_initcall(fn)		__define_initcall("0",fn,0)
 
@@ -280,7 +281,7 @@ void __init parse_early_options(char *cmdline);
 
 #else /* MODULE */
 
-/* Don't use these in modules, but some people do... */
+/* Don't use these in loadable modules, but some people do... */
 #define early_initcall(fn)		module_init(fn)
 #define core_initcall(fn)		module_init(fn)
 #define postcore_initcall(fn)		module_init(fn)
diff --git a/init/main.c b/init/main.c
index b5cc0a7..7a74087 100644
--- a/init/main.c
+++ b/init/main.c
@@ -724,6 +724,7 @@ static initcall_t *initcall_levels[] __initdata = {
 	__initcall_end,
 };
 
+/* Keep these in sync with initcalls in include/linux/init.h */
 static char *initcall_level_names[] __initdata = {
 	"early",
 	"core",
-- 
1.7.10.2

