Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0L1AtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 19:49:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32113 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0L1AtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 19:49:13 -0500
Message-ID: <4D1933C8.7060105@kernel.org>
Date: Mon, 27 Dec 2010 16:48:08 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] x86, 64bit, numa: Allocate memnodemap under max_pfn_mapped
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org>
In-Reply-To: <4D19320B.7030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need to access it right way, so make sure that it is mapped already.

Prepare to put page table on local node, and nodemap is used before that.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -87,7 +87,7 @@ static int __init allocate_cachealigned_
 
 	addr = 0x8000;
 	nodemap_size = roundup(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
-	nodemap_addr = memblock_find_in_range(addr, max_pfn<<PAGE_SHIFT,
+	nodemap_addr = memblock_find_in_range(addr, get_max_mapped(),
 				      nodemap_size, L1_CACHE_BYTES);
 	if (nodemap_addr == MEMBLOCK_ERROR) {
 		printk(KERN_ERR
