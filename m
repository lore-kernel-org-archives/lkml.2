Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1FNA7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 20:59:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:50565 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1FNA7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 20:59:18 -0400
Subject: [PATCH 1/2] mm: Move definition of MIN_MEMORY_BLOCK_SIZE to a
 header
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 10:57:50 +1000
Message-ID: <1308013070.2874.784.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro MIN_MEMORY_BLOCK_SIZE is currently defined twice in two .c
files, and I need it in a third one to fix a powerpc bug, so let's
first move it into a header

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Ingo, Thomas: Who needs to ack the x86 bit ? I'd like to send that
to Linus asap with the powerpc fix.

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d865c4a..bbaaa00 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -28,6 +28,7 @@
 #include <linux/poison.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
+#include <linux/memory.h>
 #include <linux/memory_hotplug.h>
 #include <linux/nmi.h>
 #include <linux/gfp.h>
@@ -895,8 +896,6 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 }
 
 #ifdef CONFIG_X86_UV
-#define MIN_MEMORY_BLOCK_SIZE   (1 << SECTION_SIZE_BITS)
-
 unsigned long memory_block_size_bytes(void)
 {
 	if (is_uv_system()) {
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 9f9b235..45d7c8f 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -30,7 +30,6 @@
 static DEFINE_MUTEX(mem_sysfs_mutex);
 
 #define MEMORY_CLASS_NAME	"memory"
-#define MIN_MEMORY_BLOCK_SIZE	(1 << SECTION_SIZE_BITS)
 
 static int sections_per_block;
 
diff --git a/include/linux/memory.h b/include/linux/memory.h
index e1e3b2b..935699b 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -20,6 +20,8 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 
+#define MIN_MEMORY_BLOCK_SIZE     (1 << SECTION_SIZE_BITS)
+
 struct memory_block {
 	unsigned long start_section_nr;
 	unsigned long end_section_nr;


