Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0LOWVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:21:00 -0500
Received: from claw.goop.org ([74.207.240.146]:47910 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab0LOWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:12 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 7/9] vmalloc: use apply_to_page_range_batch() in alloc_vm_area()
Date: Wed, 15 Dec 2010 14:19:53 -0800
Message-Id: <cd5ee25e08c2b503750513b142f39920473f05a6.1292450600.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 mm/vmalloc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0e845bb..a1ecf33 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1991,9 +1991,9 @@ void  __attribute__((weak)) vmalloc_sync_all(void)
 }
 
 
-static int f(pte_t *pte, unsigned long addr, void *data)
+static int f(pte_t *pte, unsigned count, unsigned long addr, void *data)
 {
-	/* apply_to_page_range() does all the hard work. */
+	/* apply_to_page_range_batch() does all the hard work. */
 	return 0;
 }
 
@@ -2022,8 +2022,8 @@ struct vm_struct *alloc_vm_area(size_t size)
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
1.7.3.3

