Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab1EUTSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:18:39 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:40119 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1EUTS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:18:29 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/5] m68k/amiga: Chip RAM - Use tabs for indentation
Date: Sat, 21 May 2011 21:18:16 +0200
Message-Id: <1306005500-29259-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/chipram.c |  118 +++++++++++++++++++++++----------------------
 1 files changed, 61 insertions(+), 57 deletions(-)

diff --git a/arch/m68k/amiga/chipram.c b/arch/m68k/amiga/chipram.c
index dd0447d..e757fff 100644
--- a/arch/m68k/amiga/chipram.c
+++ b/arch/m68k/amiga/chipram.c
@@ -23,101 +23,105 @@ unsigned long amiga_chip_size;
 EXPORT_SYMBOL(amiga_chip_size);
 
 static struct resource chipram_res = {
-    .name = "Chip RAM", .start = CHIP_PHYSADDR
+	.name = "Chip RAM", .start = CHIP_PHYSADDR
 };
 static unsigned long chipavail;
 
 
 void __init amiga_chip_init(void)
 {
-    if (!AMIGAHW_PRESENT(CHIP_RAM))
-	return;
+	if (!AMIGAHW_PRESENT(CHIP_RAM))
+		return;
 
-    chipram_res.end = amiga_chip_size-1;
-    request_resource(&iomem_resource, &chipram_res);
+	chipram_res.end = amiga_chip_size-1;
+	request_resource(&iomem_resource, &chipram_res);
 
-    chipavail = amiga_chip_size;
+	chipavail = amiga_chip_size;
 }
 
 
 void *amiga_chip_alloc(unsigned long size, const char *name)
 {
-    struct resource *res;
+	struct resource *res;
 
-    /* round up */
-    size = PAGE_ALIGN(size);
+	/* round up */
+	size = PAGE_ALIGN(size);
 
 #ifdef DEBUG
-    printk("amiga_chip_alloc: allocate %ld bytes\n", size);
+	printk("amiga_chip_alloc: allocate %ld bytes\n", size);
 #endif
-    res = kzalloc(sizeof(struct resource), GFP_KERNEL);
-    if (!res)
-	return NULL;
-    res->name = name;
-
-    if (allocate_resource(&chipram_res, res, size, 0, UINT_MAX, PAGE_SIZE, NULL, NULL) < 0) {
-	kfree(res);
-	return NULL;
-    }
-    chipavail -= size;
+	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
+	if (!res)
+		return NULL;
+	res->name = name;
+
+	if (allocate_resource(&chipram_res, res, size, 0, UINT_MAX, PAGE_SIZE,
+			      NULL, NULL) < 0) {
+		kfree(res);
+		return NULL;
+	}
+	chipavail -= size;
 #ifdef DEBUG
-    printk("amiga_chip_alloc: returning %lx\n", res->start);
+	printk("amiga_chip_alloc: returning %lx\n", res->start);
 #endif
-    return (void *)ZTWO_VADDR(res->start);
+	return (void *)ZTWO_VADDR(res->start);
 }
 EXPORT_SYMBOL(amiga_chip_alloc);
 
 
-    /*
-     *  Warning:
-     *  amiga_chip_alloc_res is meant only for drivers that need to allocate
-     *  Chip RAM before kmalloc() is functional. As a consequence, those
-     *  drivers must not free that Chip RAM afterwards.
-     */
+	/*
+	 *  Warning:
+	 *  amiga_chip_alloc_res is meant only for drivers that need to
+	 *  allocate Chip RAM before kmalloc() is functional. As a consequence,
+	 *  those drivers must not free that Chip RAM afterwards.
+	 */
 
 void * __init amiga_chip_alloc_res(unsigned long size, struct resource *res)
 {
-    unsigned long start;
+	unsigned long start;
 
-    /* round up */
-    size = PAGE_ALIGN(size);
-    /* dmesg into chipmem prefers memory at the safe end */
-    start = CHIP_PHYSADDR + chipavail - size;
+	/* round up */
+	size = PAGE_ALIGN(size);
+	/* dmesg into chipmem prefers memory at the safe end */
+	start = CHIP_PHYSADDR + chipavail - size;
 
 #ifdef DEBUG
-    printk("amiga_chip_alloc_res: allocate %ld bytes\n", size);
+	printk("amiga_chip_alloc_res: allocate %ld bytes\n", size);
 #endif
-    if (allocate_resource(&chipram_res, res, size, start, UINT_MAX, PAGE_SIZE, NULL, NULL) < 0) {
-	printk("amiga_chip_alloc_res: first alloc failed!\n");
-	if (allocate_resource(&chipram_res, res, size, 0, UINT_MAX, PAGE_SIZE, NULL, NULL) < 0)
-	    return NULL;
-    }
-    chipavail -= size;
+	if (allocate_resource(&chipram_res, res, size, start, UINT_MAX,
+			      PAGE_SIZE, NULL, NULL) < 0) {
+		printk("amiga_chip_alloc_res: first alloc failed!\n");
+		if (allocate_resource(&chipram_res, res, size, 0, UINT_MAX,
+				      PAGE_SIZE, NULL, NULL) < 0)
+			return NULL;
+	}
+	chipavail -= size;
 #ifdef DEBUG
-    printk("amiga_chip_alloc_res: returning %lx\n", res->start);
+	printk("amiga_chip_alloc_res: returning %lx\n", res->start);
 #endif
-    return (void *)ZTWO_VADDR(res->start);
+	return (void *)ZTWO_VADDR(res->start);
 }
 
 void amiga_chip_free(void *ptr)
 {
-    unsigned long start = ZTWO_PADDR(ptr);
-    struct resource **p, *res;
-    unsigned long size;
-
-    for (p = &chipram_res.child; (res = *p); p = &res->sibling) {
-	if (res->start != start)
-	    continue;
-	*p = res->sibling;
-	size = res->end-start;
+	unsigned long start = ZTWO_PADDR(ptr);
+	struct resource **p, *res;
+	unsigned long size;
+
+	for (p = &chipram_res.child; (res = *p); p = &res->sibling) {
+		if (res->start != start)
+			continue;
+		*p = res->sibling;
+		size = res->end-start;
 #ifdef DEBUG
-	printk("amiga_chip_free: free %ld bytes at %p\n", size, ptr);
+		printk("amiga_chip_free: free %ld bytes at %p\n", size, ptr);
 #endif
-	chipavail += size;
-	kfree(res);
-	return;
-    }
-    printk("amiga_chip_free: trying to free nonexistent region at %p\n", ptr);
+		chipavail += size;
+		kfree(res);
+		return;
+	}
+	printk("amiga_chip_free: trying to free nonexistent region at %p\n",
+	       ptr);
 }
 EXPORT_SYMBOL(amiga_chip_free);
 
-- 
1.7.0.4

