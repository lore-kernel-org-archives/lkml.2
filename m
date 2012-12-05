Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2LEQJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:09:15 -0500
Received: from multi.imgtec.com ([194.200.65.239]:54483 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2LEQJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:12 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        Chris Zankel <chris@zankel.net>, Mike Frysinger <vapier@gentoo.org>,
        "Chen Liqin" <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH v2 01/44] asm-generic/io.h: remove asm/cacheflush.h include
Date: Wed, 5 Dec 2012 16:08:19 +0000
Message-ID: <1354723742-6195-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including <asm/cacheflush.h> from <asm-generic/io.h> prevents
cacheflush.h being able to use I/O functions like readl and writel due
to circular include dependencies. It doesn't appear as if anything from
cacheflush.h is actually used by the generic io.h, so remove the
include.

I've compile tested a defconfig compilation of blackfin, openrisc (which
needed <asm/pgtable.h> including from it's <asm/io.h> to get the PAGE_*
definitions), and xtensa.

Other architectures which use asm-generic/io.h are score and unicore32,
and looking at their io.h I don't see any obvious problems.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Jonas Bonn <jonas@southpole.se>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Chris Zankel <chris@zankel.net>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/openrisc/include/asm/io.h |    1 +
 include/asm-generic/io.h       |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/openrisc/include/asm/io.h b/arch/openrisc/include/asm/io.h
index 07f5299..7c69139 100644
--- a/arch/openrisc/include/asm/io.h
+++ b/arch/openrisc/include/asm/io.h
@@ -30,6 +30,7 @@
 #define PIO_MASK		0
 
 #include <asm-generic/io.h>
+#include <asm/pgtable.h>
 
 extern void __iomem *__ioremap(phys_addr_t offset, unsigned long size,
 				pgprot_t prot);
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 448303b..616eea5 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -12,7 +12,6 @@
 #define __ASM_GENERIC_IO_H
 
 #include <asm/page.h> /* I/O is all done through memory accesses */
-#include <asm/cacheflush.h>
 #include <linux/types.h>
 
 #ifdef CONFIG_GENERIC_IOMAP
-- 
1.7.7.6


