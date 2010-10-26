Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab0JZCok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:44:40 -0400
Received: from mail.perches.com ([173.55.12.10]:3557 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758297Ab0JZCof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:44:35 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] fs/proc/vmcore.c: Use pr_<level> and pr_<fmt>
Date: Mon, 25 Oct 2010 19:44:28 -0700
Message-Id: <a3e222b275df30bf518cda7af6019be2178d7f4b.1288059486.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.90.gd4c43
In-Reply-To: <cover.1288059486.git.joe@perches.com>
References: <cover.1288059486.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) "kdump: " fmt
Converted printk(KERN_WARNING...) to pr_warn(...) adding
the "kdump: " prefix.
Converted "is notsane" to "is not sane" to match other uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/proc/vmcore.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 2367fb3..a46a962 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -7,6 +7,8 @@
  *
  */
 
+#define pr_fmt(fmt) "kdump: " fmt
+
 #include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/user.h>
@@ -506,8 +508,7 @@ static int __init parse_crash_elf64_headers(void)
 		ehdr.e_ehsize != sizeof(Elf64_Ehdr) ||
 		ehdr.e_phentsize != sizeof(Elf64_Phdr) ||
 		ehdr.e_phnum == 0) {
-		printk(KERN_WARNING "Warning: Core image elf header is not"
-					"sane\n");
+		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
 	}
 
@@ -562,8 +563,7 @@ static int __init parse_crash_elf32_headers(void)
 		ehdr.e_ehsize != sizeof(Elf32_Ehdr) ||
 		ehdr.e_phentsize != sizeof(Elf32_Phdr) ||
 		ehdr.e_phnum == 0) {
-		printk(KERN_WARNING "Warning: Core image elf header is not"
-					"sane\n");
+		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
 	}
 
@@ -606,8 +606,7 @@ static int __init parse_crash_elf_headers(void)
 	if (rc < 0)
 		return rc;
 	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
-		printk(KERN_WARNING "Warning: Core image elf header"
-					" not found\n");
+		pr_warn("Warning: Core image elf header not found\n");
 		return -EINVAL;
 	}
 
@@ -626,8 +625,7 @@ static int __init parse_crash_elf_headers(void)
 		/* Determine vmcore size. */
 		vmcore_size = get_vmcore_size_elf32(elfcorebuf);
 	} else {
-		printk(KERN_WARNING "Warning: Core image elf header is not"
-					" sane\n");
+		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -643,7 +641,7 @@ static int __init vmcore_init(void)
 		return rc;
 	rc = parse_crash_elf_headers();
 	if (rc) {
-		printk(KERN_WARNING "Kdump: vmcore not initialized\n");
+		pr_warn("vmcore not initialized\n");
 		return rc;
 	}
 
-- 
1.7.3.dirty

