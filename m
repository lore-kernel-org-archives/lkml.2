Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1HFS70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 14:59:26 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:28048 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab1HFS70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 14:59:26 -0400
Date: Sat, 6 Aug 2011 20:59:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] memblock: add memblock_start_of_DRAM()
Message-ID: <20110806185923.GA8494@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPARC32 require access to the start address.
Add a new helper memblock_start_of_DRAM() to give
access to the address of the first memblock - which
contains the lowest address.

The ackward name was chosen to match the already present
memblock_end_of_DRAM().

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
---
Hi Tejun.

I have started to replace bootmem with memblock for sparc32.
This is so far the only general functionality missing.

But conversion is not finished yet - more may come.

This is on top of the memblock branch of your misc tree

	Sam

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 7c59804..a6bb102 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -157,6 +157,7 @@ phys_addr_t memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 				  phys_addr_t max_addr);
 phys_addr_t memblock_phys_mem_size(void);
+phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
 void memblock_enforce_memory_limit(phys_addr_t memory_limit);
 int memblock_is_memory(phys_addr_t addr);
diff --git a/mm/memblock.c b/mm/memblock.c
index 07cb3ae..2f55f19 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -782,6 +782,12 @@ phys_addr_t __init memblock_phys_mem_size(void)
 	return memblock.memory.total_size;
 }
 
+/* lowest address */
+phys_addr_t __init_memblock memblock_start_of_DRAM(void)
+{
+	return memblock.memory.regions[0].base;
+}
+
 phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 {
 	int idx = memblock.memory.cnt - 1;
