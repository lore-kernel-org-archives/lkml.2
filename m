Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab2JVQ0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:26:19 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:59286 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2JVQ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:26:18 -0400
X-Greylist: delayed 2942 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2012 12:26:18 EDT
Date: Mon, 22 Oct 2012 10:37:35 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        John Linn <john.linn@xilinx.com>
Subject: [PATCH 3/4] zynq: remove use of CLKDEV_LOOKUP
Message-ID: <20121022153735.GC502@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/22/2012 10:37:30 AM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/22/2012 10:37:31 AM,
	Serialize complete at 10/22/2012 10:37:31 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-22_02:2012-10-22,2012-10-21,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Zynq support in mainline does not (yet) make use of any of the
generic clk or clk lookup functionality.  Remove what is upstream for
now, until the out-of-tree implementation is in suitable form for
merging.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/Kconfig                         |  1 -
 arch/arm/mach-zynq/common.c              |  1 -
 arch/arm/mach-zynq/include/mach/clkdev.h | 32 --------------------------------
 3 files changed, 34 deletions(-)
 delete mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 73067ef..e37bea3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -959,7 +959,6 @@ config ARCH_ZYNQ
 	bool "Xilinx Zynq ARM Cortex A9 Platform"
 	select ARM_AMBA
 	select ARM_GIC
-	select CLKDEV_LOOKUP
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select ICST
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index d73963b..6ea86cf 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -31,7 +31,6 @@
 #include <asm/hardware/cache-l2x0.h>
 
 #include <mach/zynq_soc.h>
-#include <mach/clkdev.h>
 #include "common.h"
 
 static struct of_device_id zynq_of_bus_ids[] __initdata = {
diff --git a/arch/arm/mach-zynq/include/mach/clkdev.h b/arch/arm/mach-zynq/include/mach/clkdev.h
deleted file mode 100644
index c6e73d8..0000000
--- a/arch/arm/mach-zynq/include/mach/clkdev.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * arch/arm/mach-zynq/include/mach/clkdev.h
- *
- *  Copyright (C) 2011 Xilinx, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __MACH_CLKDEV_H__
-#define __MACH_CLKDEV_H__
-
-#include <plat/clock.h>
-
-struct clk {
-	unsigned long		rate;
-	const struct clk_ops	*ops;
-	const struct icst_params *params;
-	void __iomem		*vcoreg;
-};
-
-#define __clk_get(clk) ({ 1; })
-#define __clk_put(clk) do { } while (0)
-
-#endif
-- 
1.8.0

