Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967313Ab0GTACg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:02:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16421 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967239Ab0GTABA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:01:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 12/49] memblock: Remove unused memblock.debug struct member
Date: Mon, 19 Jul 2010 16:56:21 -0700
Message-Id: <1279583818-14249-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C44E6A9.0132,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 3b41f61..5abb06b 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -32,7 +32,6 @@ struct memblock_type {
 };
 
 struct memblock {
-	unsigned long debug;
 	phys_addr_t current_limit;
 	struct memblock_type memory;
 	struct memblock_type reserved;
@@ -55,9 +54,11 @@ extern phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align);
 #define MEMBLOCK_ALLOC_ACCESSIBLE	0
 
 extern phys_addr_t __init memblock_alloc_base(phys_addr_t size,
-		phys_addr_t, phys_addr_t max_addr);
+					 phys_addr_t align,
+					 phys_addr_t max_addr);
 extern phys_addr_t __init __memblock_alloc_base(phys_addr_t size,
-		phys_addr_t align, phys_addr_t max_addr);
+					   phys_addr_t align,
+					   phys_addr_t max_addr);
 extern phys_addr_t __init memblock_phys_mem_size(void);
 extern phys_addr_t memblock_end_of_DRAM(void);
 extern void __init memblock_enforce_memory_limit(phys_addr_t memory_limit);
-- 
1.6.4.2

