Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab1FKB55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 21:57:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58165 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758515Ab1FKB5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 21:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JgiNK5bdXYWmVjuNSFdJDHEAd5SB7K3XChERD+//cNaYpvSVVv8HKcJg/zT23LsbeW
         rcnxDulLiS87T7zehz82Uk6QdG4CBNN0KvhQwjS/p+ASp0IkwqgVM/pN9MooblO7CSE2
         UIqdekhp1tM7ZQMwjpllEJTS5xXgSmyEOy/Tg=
From: Dave Carroll <dtcarroll@gmail.com>
To: Milton Miller <miltonm@bga.com>, BenH <benh@kernel.crashing.org>
Cc: LPPC <linuxppc-dev@lists.ozlabs.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Carroll <dcarroll@astekcorp.com>
Subject: [PATCH 2/2] powerpc: Add printk companion for ppc_md.progress
Date: Fri, 10 Jun 2011 19:38:11 -0600
Message-Id: <1307756291-26513-2-git-send-email-dcarroll@astekcorp.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1307756291-26513-1-git-send-email-dcarroll@astekcorp.com>
References: <initrd-align-v5-reply@mdm.bga.com>
 <1307756291-26513-1-git-send-email-dcarroll@astekcorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Carroll <dcarroll@astekcorp.com>

This patch adds a printk companion to replace the udbg progress function
when initmem is freed.

Suggested-by: Milton Miller <miltonm@bga.com>
Suggested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Dave Carroll <dcarroll@astekcorp.com>
---
 arch/powerpc/include/asm/setup.h   |    2 ++
 arch/powerpc/kernel/setup-common.c |    5 +++++
 arch/powerpc/mm/mem.c              |    2 +-
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/setup.h b/arch/powerpc/include/asm/setup.h
index dae1934..c77cb7a 100644
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -3,4 +3,6 @@
 
 #include <asm-generic/setup.h>
 
+extern void ppc_printk_progress(char *s, unsigned short hex);
+
 #endif	/* _ASM_POWERPC_SETUP_H */
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 79fca26..e053b16 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -704,6 +704,11 @@ static int powerpc_debugfs_init(void)
 arch_initcall(powerpc_debugfs_init);
 #endif
 
+void ppc_printk_progress(char *s, unsigned short hex)
+{
+	pr_info("%s\n", s);
+}
+
 static int ppc_dflt_bus_notify(struct notifier_block *nb,
 				unsigned long action, void *data)
 {
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index f4e6408..e0d2aa0 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -386,7 +386,7 @@ void free_initmem(void)
 {
 	unsigned long addr;
 
-	ppc_md.progress = NULL;
+	ppc_md.progress = ppc_printk_progress;
 
 	addr = (unsigned long)__init_begin;
 	for (; addr < (unsigned long)__init_end; addr += PAGE_SIZE) {
-- 
1.7.4

