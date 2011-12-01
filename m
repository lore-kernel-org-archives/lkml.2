Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1LASPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:15:11 -0500
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:14917 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1LASPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:15:09 -0500
Message-Id: <201112011815.pB1IF8P0004904@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Dec 2011 11:37:20 -0500
Subject: [PATCH] arch/tile: add a few #includes and an EXPORT to catch up with kernel changes.
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 01 Dec 2011 18:15:08.0596 (UTC) FILETIME=[288D4F40:01CCB055]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The empty_zero_page[] export is required for ZERO_PAGE() module references.
The #includes are due to changes in implicit inclusion, and should of
course have been in the sources from the beginning.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci-dma.c |    1 +
 arch/tile/kernel/pci.c     |    1 +
 arch/tile/kernel/sysfs.c   |    1 +
 arch/tile/lib/exports.c    |    3 +++
 4 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index 658f2ce..b3ed19f 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/vmalloc.h>
+#include <linux/export.h>
 #include <asm/tlbflush.h>
 #include <asm/homecache.h>
 
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 2a8014c..9d610d3 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -24,6 +24,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/export.h>
 
 #include <asm/processor.h>
 #include <asm/sections.h>
diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
index b671a86..6029082 100644
--- a/arch/tile/kernel/sysfs.c
+++ b/arch/tile/kernel/sysfs.c
@@ -18,6 +18,7 @@
 #include <linux/cpu.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
+#include <linux/stat.h>
 #include <hv/hypervisor.h>
 
 /* Return a string queried from the hypervisor, truncated to page size. */
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index a87d2a8..2a81d32 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -39,6 +39,9 @@ EXPORT_SYMBOL(finv_user_asm);
 EXPORT_SYMBOL(current_text_addr);
 EXPORT_SYMBOL(dump_stack);
 
+/* arch/tile/kernel/head.S */
+EXPORT_SYMBOL(empty_zero_page);
+
 /* arch/tile/lib/, various memcpy files */
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(__copy_to_user_inatomic);
-- 
1.6.5.2

