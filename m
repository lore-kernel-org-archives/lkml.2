Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab1BBBIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:08:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:41311 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1BBAn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622308"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: suresh.b.siddha@intel.com, ak@linux.intel.com, hpa@linux.intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [24/139] bootmem: Add alloc_bootmem_align()
Message-Id: <20110202004338.E82B83E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 53dde5f385bc56e312f78b7cb25ffaf8efd4735d upstream.

Add an alloc_bootmem_align() interface to allocate bootmem with
specified alignment.  This is necessary to be able to allocate the
xsave area in a subsequent patch.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20101116212441.977574826@sbsiddha-MOBL3.sc.intel.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/bootmem.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/include/linux/bootmem.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/bootmem.h
+++ linux-2.6.35.y/include/linux/bootmem.h
@@ -105,6 +105,8 @@ extern void *__alloc_bootmem_low_node(pg
 
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_align(x, align) \
+	__alloc_bootmem(x, align, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_nopanic(x) \
 	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages(x) \
