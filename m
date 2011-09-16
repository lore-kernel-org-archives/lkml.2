Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1IPQsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:48:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62852 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab1IPQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:48:13 -0400
From: Tzu-Jung Lee <roylee17@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rmk+kernel@arm.linux.org.uk, Tzu-Jung Lee <tjlee@ambarella.com>
Subject: [PATCH] ARM: mm: Compile out HIGHMEM specific code when itss undefined
Date: Sat, 17 Sep 2011 00:46:34 +0800
Message-Id: <1316191594-30486-1-git-send-email-tjlee@ambarella.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicitly compile out HIGHMEM specific code to eliminate compile-time errors
when built with -O0.

Change-Id: I98237f11aef07864017c67fb1a69b86f28a46e80

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 4771dba..10d1e3c 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -456,6 +456,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
 	size_t size, enum dma_data_direction dir,
 	void (*op)(const void *, size_t, int))
 {
+#ifdef CONFIG_HIGHMEM
 	/*
 	 * A single sg entry may refer to multiple physically contiguous
 	 * pages.  But we still need to process highmem pages individually.
@@ -494,6 +495,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
 		page++;
 		left -= len;
 	} while (left);
+#endif
 }
 
 void ___dma_page_cpu_to_dev(struct page *page, unsigned long off,
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 2b269c9..3349df2 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -167,6 +167,7 @@ void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 
 void __flush_dcache_page(struct address_space *mapping, struct page *page)
 {
+#ifdef CONFIG_HIGHMEM
 	/*
 	 * Writeback any data associated with the kernel mapping of this
 	 * page.  This ensures that data in the physical page is mutually
@@ -186,7 +187,7 @@ void __flush_dcache_page(struct address_space *mapping, struct page *page)
 			kunmap_atomic(addr);
 		}
 	}
-
+#endif
 	/*
 	 * If this is a page cache page, and we have an aliasing VIPT cache,
 	 * we only need to do one flush - which would be at the relevant
-- 
1.7.6.1

