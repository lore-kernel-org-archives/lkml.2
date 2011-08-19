Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1HSO3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:29:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44408 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab1HSO1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:27:53 -0400
Date: Fri, 19 Aug 2011 16:27:44 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 8/8] ARM: S5PV210: example of CMA private area for FIMC device
 on Goni board
In-reply-to: <1313764064-9747-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>
Message-id: <1313764064-9747-9-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.5.4
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1313764064-9747-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is an example how device private CMA area can be activated.
It creates one CMA region and assigns it to the first s5p-fimc device on
Samsung Goni S5PC110 board.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/mach-goni.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 14578f5..f766c45 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -26,6 +26,7 @@
 #include <linux/input.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
+#include <linux/dma-contiguous.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -857,6 +858,9 @@ static void __init goni_map_io(void)
 static void __init goni_reserve(void)
 {
 	s5p_mfc_reserve_mem(0x43000000, 8 << 20, 0x51000000, 8 << 20);
+
+	/* Create private 16MiB contiguous memory area for s5p-fimc.0 device */
+	dma_declare_contiguous(&s5p_device_fimc0.dev, 16*SZ_1M, 0);
 }
 
 static void __init goni_machine_init(void)
-- 
1.7.1.569.g6f426

