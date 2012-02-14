Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab2BNAEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:04:38 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:35224 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab2BNAEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:04:35 -0500
Subject: [PATCH] swiotlb: print physical addresses consistently with other
	parts of kernel
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org
Date: Mon, 13 Feb 2012 17:04:34 -0700
Message-ID: <20120214000434.32437.96961.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print swiotlb info in a style consistent with the %pR style used elsewhere
in the kernel.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 lib/swiotlb.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 058935e..ec925ae 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -130,11 +130,9 @@ void swiotlb_print_info(void)
 	pstart = virt_to_phys(io_tlb_start);
 	pend = virt_to_phys(io_tlb_end);
 
-	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
-	       bytes >> 20, io_tlb_start, io_tlb_end);
-	printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
-	       (unsigned long long)pstart,
-	       (unsigned long long)pend);
+	printk(KERN_INFO "software IO TLB [mem %#010llx-%#010llx] (%luMB) mapped at [%p-%p]\n",
+	       (unsigned long long)pstart, (unsigned long long)pend - 1,
+	       bytes >> 20, io_tlb_start, io_tlb_end - 1);
 }
 
 void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)

