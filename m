Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2D0XnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:43:04 -0400
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:48228 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756992Ab2D0XnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:43:02 -0400
Subject: [PATCH 3/4] swiotlb: print physical addresses consistently with other
	parts of kernel
To: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 27 Apr 2012 17:37:46 -0600
Message-ID: <20120427233746.25317.34308.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120427233620.25317.67562.stgit@bhelgaas.mtv.corp.google.com>
References: <20120427233620.25317.67562.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print swiotlb info in a style consistent with the %pR style used elsewhere
in the kernel.  For example:

    -Placing 64MB software IO TLB between ffff88007a662000 - ffff88007e662000
    -software IO TLB at phys 0x7a662000 - 0x7e662000
    +software IO TLB [mem 0x7a662000-0x7e661fff] (64MB) mapped at [ffff88007a662000-ffff88007e661fff]

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 lib/swiotlb.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 414f46e..45bc1f8 100644
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

