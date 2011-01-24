Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1AXW5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:57:06 -0500
Received: from claw.goop.org ([74.207.240.146]:58145 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab1AXW4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:56:20 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 7/9] vmalloc: use apply_to_page_range_batch() in alloc_vm_area()
Date: Mon, 24 Jan 2011 14:56:05 -0800
Message-Id: <d4205306bb6609275ad93a8d1bfb4de3d06d0eb5.1295653400.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1295653400.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1295653400.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1295653400.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1295653400.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 mm/vmalloc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index cf4e705..64d395f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1993,9 +1993,9 @@ void  __attribute__((weak)) vmalloc_sync_all(void)
 }
 
 
-static int f(pte_t *pte, unsigned long addr, void *data)
+static int f(pte_t *pte, unsigned count, unsigned long addr, void *data)
 {
-	/* apply_to_page_range() does all the hard work. */
+	/* apply_to_page_range_batch() does all the hard work. */
 	return 0;
 }
 
@@ -2024,8 +2024,8 @@ struct vm_struct *alloc_vm_area(size_t size)
 	 * This ensures that page tables are constructed for this region
 	 * of kernel virtual address space and mapped into init_mm.
 	 */
-	if (apply_to_page_range(&init_mm, (unsigned long)area->addr,
-				area->size, f, NULL)) {
+	if (apply_to_page_range_batch(&init_mm, (unsigned long)area->addr,
+				      area->size, f, NULL)) {
 		free_vm_area(area);
 		return NULL;
 	}
-- 
1.7.3.4

