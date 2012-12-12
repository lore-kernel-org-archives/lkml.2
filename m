Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2LLSXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:23:39 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56871 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:23:37 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 26/26] kallsyms: Remove print_symbol
Date: Wed, 12 Dec 2012 10:19:15 -0800
Message-Id: <bc5b83ca73bd82dd4af2e6f81415493f086e5381.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is now unused, remove it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kallsyms.h |   18 ------------------
 kernel/kallsyms.c        |   11 -----------
 2 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 6883e19..b7a60ba 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -39,9 +39,6 @@ extern int sprint_symbol(char *buffer, unsigned long address);
 extern int sprint_symbol_no_offset(char *buffer, unsigned long address);
 extern int sprint_backtrace(char *buffer, unsigned long address);
 
-/* Look up a kernel symbol and print it to the kernel messages. */
-extern void __print_symbol(const char *fmt, unsigned long address);
-
 int lookup_symbol_name(unsigned long addr, char *symname);
 int lookup_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 
@@ -103,23 +100,8 @@ static inline int lookup_symbol_attrs(unsigned long addr, unsigned long *size, u
 	return -ERANGE;
 }
 
-/* Stupid that this does nothing, but I didn't create this mess. */
-#define __print_symbol(fmt, addr)
 #endif /*CONFIG_KALLSYMS*/
 
-/* This macro allows us to keep printk typechecking */
-static __printf(1, 2)
-void __check_printsym_format(const char *fmt, ...)
-{
-}
-
-static inline void print_symbol(const char *fmt, unsigned long addr)
-{
-	__check_printsym_format(fmt, "");
-	__print_symbol(fmt, (unsigned long)
-		       __builtin_extract_return_addr((void *)addr));
-}
-
 static inline void print_ip_sym(unsigned long ip)
 {
 	printk("[<%p>] %pS\n", (void *) ip, (void *) ip);
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 2169fee..6733476 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -422,17 +422,6 @@ int sprint_backtrace(char *buffer, unsigned long address)
 	return __sprint_symbol(buffer, address, -1, 1);
 }
 
-/* Look up a kernel symbol and print it to the kernel messages. */
-void __print_symbol(const char *fmt, unsigned long address)
-{
-	char buffer[KSYM_SYMBOL_LEN];
-
-	sprint_symbol(buffer, address);
-
-	printk(fmt, buffer);
-}
-EXPORT_SYMBOL(__print_symbol);
-
 /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
 struct kallsym_iter {
 	loff_t pos;
-- 
1.7.8.112.g3fd21

