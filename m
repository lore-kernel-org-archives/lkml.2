Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2KSSkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:40:19 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:50177 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2KSSkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:40:16 -0500
Message-Id: <1443f143846f22125e3d6631cf3a2fdf75d925d3.1353349191.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1353349191.git.josh.cartwright@ni.com>
References: <cover.1353349191.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Mon, 19 Nov 2012 10:01:03 -0600
Subject: [PATCH 1/3] ARM: zynq: remove TTC early mapping
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Michal Simek <michal.simek@xilinx.com>, arm@kernel.org
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/19/2012 12:40:08 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/19/2012 12:40:08 PM,
	Serialize complete at 11/19/2012 12:40:08 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-19_07:2012-11-19,2012-11-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the TTC driver has proper support for DT bindings, it is not
necessary for the registers to be mapped early.  They will be mapped
during clock initialization using of_iomap().  Remove the early mapping.

In addition, remove the extraneous zynq_soc.h include from the timer
driver.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/mach-zynq/common.c                | 5 -----
 arch/arm/mach-zynq/include/mach/zynq_soc.h | 6 +-----
 arch/arm/mach-zynq/timer.c                 | 1 -
 3 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 79bf5fb..2202f67 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -74,11 +74,6 @@ static void __init xilinx_irq_init(void)
 
 static struct map_desc io_desc[] __initdata = {
 	{
-		.virtual	= TTC0_VIRT,
-		.pfn		= __phys_to_pfn(TTC0_PHYS),
-		.length		= TTC0_SIZE,
-		.type		= MT_DEVICE,
-	}, {
 		.virtual	= SCU_PERIPH_VIRT,
 		.pfn		= __phys_to_pfn(SCU_PERIPH_PHYS),
 		.length		= SCU_PERIPH_SIZE,
diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
index 5ebbd8e..2995044 100644
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -29,13 +29,9 @@
 #define UART_SIZE		SZ_4K
 #define UART_VIRT		0xF0001000
 
-#define TTC0_PHYS		0xF8001000
-#define TTC0_SIZE		SZ_4K
-#define TTC0_VIRT		(VMALLOC_END - TTC0_SIZE)
-
 #define SCU_PERIPH_PHYS		0xF8F00000
 #define SCU_PERIPH_SIZE		SZ_8K
-#define SCU_PERIPH_VIRT		(TTC0_VIRT - SCU_PERIPH_SIZE)
+#define SCU_PERIPH_VIRT		(VMALLOC_END - SCU_PERIPH_SIZE)
 
 #if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
 # define LL_UART_PADDR		UART1_PHYS
diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
index 9662306..de3df28 100644
--- a/arch/arm/mach-zynq/timer.c
+++ b/arch/arm/mach-zynq/timer.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/clk-provider.h>
 
-#include <mach/zynq_soc.h>
 #include "common.h"
 
 /*
-- 
1.8.0


