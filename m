Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0ELPce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:32:34 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40566 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754167Ab0ELPcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:32:33 -0400
Date: Wed, 12 May 2010 17:32:29 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>, maltesch@gmx.de,
       Ralf Baechle <ralf@linux-mips.org>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] Un(de)selectable block for DISCONTIGMEM/64BIT on parisc
Message-ID: <20100512153229.GA3379@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	When considering the restrictions inposed in kconfig 64BIT
will *always* be set when DISCONTIGMEM is present on parisc so the
code path depending on !64BIT is actually unreachable and the whole
check unnecessary.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From 5eeae9c56e2602a68b62b21691e6756fb5198dd7 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 12 May 2010 16:59:24 +0200
Subject: [PATCH] on parisc CONFIG_DISCONTIGMEM always depends on CONFIG_64BIT

Removing a conditional on 64BIT inside a DISCONTIGMEM block inside
arch/parisc. DISCONTIGMEM depends on ARCH_DISCONTIGMEM_ENABLE either
directly or through DISCONTIGMEM_MANUAL which in turn depends on 64BIT
inside Kconfig so the check and the else case isn't needed at all (the
else case can't ever be reached)

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/parisc/include/asm/mmzone.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/include/asm/mmzone.h b/arch/parisc/include/asm/mmzone.h
index 9608d2c..dbddcac 100644
--- a/arch/parisc/include/asm/mmzone.h
+++ b/arch/parisc/include/asm/mmzone.h
@@ -35,12 +35,7 @@ extern struct node_map_data node_data[];
 #define PFNNID_MAP_MAX  512     /* support 512GB */
 extern unsigned char pfnnid_map[PFNNID_MAP_MAX];
 
-#ifndef CONFIG_64BIT
 #define pfn_is_io(pfn) ((pfn & (0xf0000000UL >> PAGE_SHIFT)) == (0xf0000000UL >> PAGE_SHIFT))
-#else
-/* io can be 0xf0f0f0f0f0xxxxxx or 0xfffffffff0000000 */
-#define pfn_is_io(pfn) ((pfn & (0xf000000000000000UL >> PAGE_SHIFT)) == (0xf000000000000000UL >> PAGE_SHIFT))
-#endif
 
 static inline int pfn_to_nid(unsigned long pfn)
 {
-- 
1.6.3.3










