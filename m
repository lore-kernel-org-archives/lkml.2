Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2FNSvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:51:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40933 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab2FNSvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:51:10 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Cc: bp@amd64.org, pawel.moll@arm.com, jbaron@redhat.com,
        gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH] init: add comments to keep initcall-names in sync with initcall levels
Date: Thu, 14 Jun 2012 12:51:02 -0600
Message-Id: <1339699862-3731-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <20120612105913.GA8404@aftab.osrc.amd.com>
References: <20120612105913.GA8404@aftab.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

main.c has initcall_level_names[] for parse_args to print in debug messages,
add comments to keep them in sync with initcalls defined in init.h.
Also tweak comment re not using *_initcall macros in loadable modules.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/init.h |    3 ++-
 init/main.c          |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 6b95109..da6f6f9 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -191,6 +191,7 @@ extern bool initcall_debug;
  * initializes variables that couldn't be statically initialized.
  *
  * This only exists for built-in code, not for modules.
+ * Keep main.c:initcall_level_names[] in sync. */
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

