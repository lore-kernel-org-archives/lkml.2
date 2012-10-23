Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab2JWJYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:24:10 -0400
Received: from multi.imgtec.com ([194.200.65.239]:11188 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab2JWJYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:24:08 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Arnd Bergmann <arnd@arndb.de>, Jonas Bonn <jonas@southpole.se>
CC: <linux-arch@vger.kernel.org>, <linux@openrisc.net>,
        <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-xtensa@linux-xtensa.org>, James Hogan <james.hogan@imgtec.com>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH] asm-generic/io.h: remove asm/cacheflush.h include
Date: Tue, 23 Oct 2012 10:21:57 +0100
Message-ID: <1350984117-17369-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
X-OriginalArrivalTime: 23 Oct 2012 09:23:30.0916 (UTC) FILETIME=[1121DA40:01CDB100]
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_10_23_10_23_32
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
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
Any compile testing of score and unicore32 anybody could provide would
be great.

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


