Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1CPV1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:27:44 -0400
Received: from kroah.org ([198.145.64.141]:42603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab1CPVLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nathan Fontenot <nfont@austin.ibm.com>, Robin Holt <holt@sgi.com>,
        Jack Steiner <steiner@sgi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/50] memory hotplug: Define memory_block_size_bytes for x86_64 with CONFIG_X86_UV
Date: Wed, 16 Mar 2011 14:10:54 -0700
Message-Id: <1300309888-5028-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Fontenot <nfont@austin.ibm.com>

Define a version of memory_block_size_bytes for x86_64 when CONFIG_X86_UV is
set.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/mm/init_64.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 71a5929..17e90d1 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -51,6 +51,7 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
+#include <asm/uv/uv.h>
 
 static int __init parse_direct_gbpages_off(char *arg)
 {
@@ -908,6 +909,19 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 	return NULL;
 }
 
+#ifdef CONFIG_X86_UV
+#define MIN_MEMORY_BLOCK_SIZE   (1 << SECTION_SIZE_BITS)
+
+unsigned long memory_block_size_bytes(void)
+{
+	if (is_uv_system()) {
+		printk(KERN_INFO "UV: memory block size 2GB\n");
+		return 2UL * 1024 * 1024 * 1024;
+	}
+	return MIN_MEMORY_BLOCK_SIZE;
+}
+#endif
+
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
-- 
1.7.4.1

