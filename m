Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0E0OUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:20:40 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:49124 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab0E0OUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:20:38 -0400
Date: Thu, 27 May 2010 09:17:17 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [BUG] slub crashes on dma allocations
In-Reply-To: <20100526153757.GB2232@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.2.00.1005270916220.5762@router.home>
References: <20100526153757.GB2232@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So S390 has NUMA and the minalign is allowing very small slabs of 8/16/32 bytes?


Try this patch

From: Christoph Lameter <cl@linux-foundation.org>
Subject: SLUB: Allow full duplication of kmalloc array for 390

Seems that S390 is running out of kmalloc caches.

Increase the number of kmalloc caches to a safe size.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/slub_def.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2010-05-27 09:14:16.000000000 -0500
+++ linux-2.6/include/linux/slub_def.h	2010-05-27 09:14:26.000000000 -0500
@@ -140,7 +140,7 @@ struct kmem_cache {
 #ifdef CONFIG_ZONE_DMA
 #define SLUB_DMA __GFP_DMA
 /* Reserve extra caches for potential DMA use */
-#define KMALLOC_CACHES (2 * SLUB_PAGE_SHIFT - 6)
+#define KMALLOC_CACHES (2 * SLUB_PAGE_SHIFT)
 #else
 /* Disable DMA functionality */
 #define SLUB_DMA (__force gfp_t)0

