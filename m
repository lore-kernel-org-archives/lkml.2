Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1HWLVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 07:21:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37300 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1HWLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 07:21:36 -0400
Date: Tue, 23 Aug 2011 14:21:28 +0300
From: Maxin B John <maxin.john@gmail.com>
To: Jiandong Zheng <jdzheng@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] arm: mach-bcmring: fix build error in dma.c
Message-ID: <20110823112128.GA2825@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 CC      arch/arm/mach-bcmring/dma.o
arch/arm/mach-bcmring/dma.c: In function 'dma_request_channel_dbg':
arch/arm/mach-bcmring/dma.c:1022: error: 'TASK_INTERRUPTIBLE'
undeclared (first use in this function)
arch/arm/mach-bcmring/dma.c:1022: error: (Each undeclared identifier
is reported only once
arch/arm/mach-bcmring/dma.c:1022: error: for each function it appears
in.)
arch/arm/mach-bcmring/dma.c:1024: error: implicit declaration of
function 'schedule'
arch/arm/mach-bcmring/dma.c:1027: error: implicit declaration of
function 'signal_pending'
arch/arm/mach-bcmring/dma.c: In function 'dma_free_channel':
arch/arm/mach-bcmring/dma.c:1092: error: 'TASK_INTERRUPTIBLE'
undeclared (first use in this function)
arch/arm/mach-bcmring/dma.c: In function 'dma_map_add_region':
arch/arm/mach-bcmring/dma.c:1946: error: dereferencing pointer to
incomplete type
arch/arm/mach-bcmring/dma.c:1948: error: dereferencing pointer to
incomplete type
arch/arm/mach-bcmring/dma.c:1955: error: dereferencing pointer to
incomplete type
make[1]: *** [arch/arm/mach-bcmring/dma.o] Error 1
make: *** [arch/arm/mach-bcmring] Error 2

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
index 0ca0005..12d1504 100644
--- a/arch/arm/mach-bcmring/dma.c
+++ b/arch/arm/mach-bcmring/dma.c
@@ -35,6 +35,7 @@
 #include <linux/mm.h>
 #include <linux/pfn.h>
 #include <linux/atomic.h>
+#include <linux/sched.h>
 #include <mach/dma.h>
 
 /* I don't quite understand why dc4 fails when this is set to 1 and DMA is enabled */
