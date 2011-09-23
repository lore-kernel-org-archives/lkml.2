Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1IWAuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 20:50:21 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:27733 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1IWAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 20:50:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-127.messagelabs.com!1316739015!32529061!6
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/memblock.c: quiet sparse noise
Date: Thu, 22 Sep 2011 17:49:21 -0700
User-Agent: KMail/1.9.9
CC: <linux-mm@kvack.org>, <akpm@linux-foundation.org>, <yinghai@kernel.org>,
        <hpa@linux.intel.com>, <benh@kernel.crashing.org>,
        <tomi.valkeinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109221749.22433.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the following sparse noise in this file:

warning: function 'memblock_memory_can_coalesce' with external linkage has definition
warning: symbol 'memblock_overlaps_region' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers,com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
"H. Peter Anvin" <hpa@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>

---

diff --git a/mm/memblock.c b/mm/memblock.c
index b7ed636..f40b22c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -58,7 +58,8 @@ static unsigned long __init_memblock memblock_addrs_overlap(phys_addr_t base1, p
 	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
 }
 
-long __init_memblock memblock_overlaps_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size)
+static long __init_memblock memblock_overlaps_region(struct memblock_type *type,
+					phys_addr_t base, phys_addr_t size)
 {
 	unsigned long i;
 
@@ -267,8 +268,8 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 	return 0;
 }
 
-extern int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
-					  phys_addr_t addr2, phys_addr_t size2)
+int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1,
+		phys_addr_t size1, phys_addr_t addr2, phys_addr_t size2)
 {
 	return 1;
 }
