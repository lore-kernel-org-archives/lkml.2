Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444Ab0GAVqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:46:47 -0400
Received: from kroah.org ([198.145.64.141]:32800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759057Ab0GAVOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:10 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:55 2010
Message-Id: <20100701174255.036095068@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [102/200] Blackfin: set ARCH_KMALLOC_MINALIGN
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 76b99699a2bbf9efdb578f9a38a202af2ecb354b upstream.

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
the buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/blackfin/include/asm/cache.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/blackfin/include/asm/cache.h
+++ b/arch/blackfin/include/asm/cache.h
@@ -15,6 +15,8 @@
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 #define SMP_CACHE_BYTES	L1_CACHE_BYTES
 
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+
 #ifdef CONFIG_SMP
 #define __cacheline_aligned
 #else


