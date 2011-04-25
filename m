Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab1DYSLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:11:39 -0400
Received: from relay2.sgi.com ([192.48.179.30]:34841 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757722Ab1DYSLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:11:38 -0400
Message-Id: <20110425181136.211858618@gulag1.americas.sgi.com>
References: <20110425181136.055235992@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Apr 2011 13:11:37 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] memblock: add error return when CONFIG_HAVE_MEMBLOCK is not set
Content-Disposition: inline; filename=add-no-memblock
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Add an error return if CONFIG_HAVE_MEMBLOCK is not set instead
	of having to add #ifdef CONFIG_HAVE_MEMBLOCK around blocks of
	code calling that function.

Authored-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/memblock.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- linux.orig/include/linux/memblock.h
+++ linux/include/linux/memblock.h
@@ -2,6 +2,8 @@
 #define _LINUX_MEMBLOCK_H
 #ifdef __KERNEL__
 
+#define MEMBLOCK_ERROR	0
+
 #ifdef CONFIG_HAVE_MEMBLOCK
 /*
  * Logical memory blocks.
@@ -20,7 +22,6 @@
 #include <asm/memblock.h>
 
 #define INIT_MEMBLOCK_REGIONS	128
-#define MEMBLOCK_ERROR		0
 
 struct memblock_region {
 	phys_addr_t base;
@@ -160,6 +161,12 @@ static inline unsigned long memblock_reg
 #define __initdata_memblock
 #endif
 
+#else
+static inline phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align)
+{
+	return MEMBLOCK_ERROR;
+}
+
 #endif /* CONFIG_HAVE_MEMBLOCK */
 
 #endif /* __KERNEL__ */

-- 
