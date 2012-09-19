Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2ISNwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:52:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2ISNwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:52:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/24] ARM: ixp4xx: use __iomem pointers for MMIO
Date: Wed, 19 Sep 2012 13:52:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Nicolas Pitre <nico@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Imre Kaloz <kaloz@openwrt.org>, Olof Johansson <olof@lixom.net>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <m3ipbbmxke.fsf@intrepid.localdomain> <m3ipbbdtlt.fsf@intrepid.localdomain>
In-Reply-To: <m3ipbbdtlt.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201209191352.28034.arnd@arndb.de>
X-Provags-ID: V02:K0:n5R1CYHKByMA/Vh9KclF8XvNUlw6Yr6n8NjjHAzJbJu
 4ZzDH0vMSiPHnFHHxgNQBHDo1YLB/e/jUyMN6NMrEZ8/M5PfHR
 HoIlr5zSMZAXm1bHzkw0abLP39hBxG9TYsJAaZGpRv2Gy8Nbu9
 m8A4Rz5flOVsbTVAmpehLIy1ulAI5iPnhCB0+EBXKWJ+L8XGwj
 UESSIYc0GQHYElWuCo2Shr41qpOHprpHwvE5mKgNxxmO0+UoGq
 SzMvUecRqAXFSVias+9I0ZRmxNwogrUclJ+seG4B7sVtoWKuTT
 77bOUeGSRU8a0pgRRr8yOgHTS+dLSt/DxEwhDaIxVDy3O1sR2w
 3rU7KZLy0QTEwOabO8/U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Krzysztof Halasa wrote:
> Krzysztof Halasa <khc@pm.waw.pl> writes:
> 
> >> At the moment, this patch conflicts with other patches in linux-next,
> >> need to sort this out.
> >
> > Very nice, I will take care of these 3 patches.
> 
> I mean, just this one IXP4xx patch :-)

Ok. I just noticed that I made a mistake in splitting up the changes between
iop32x and ixp4xx. I've corrected this in my tree now and fixed the bug you
pointed out, see the new version below. I'm not completely sure how to
proceed with this. I noticed you have some patches in linux-next but haven't
sent any pull requests yet. The merge window is getting closer, so I'd
like to come to a conclusion with this.

	Arnd

8<----
>From 13ec32f47cb42cecc9cd262c307ef9377c601007 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 14 Sep 2012 20:19:40 +0000
Subject: [PATCH] ARM: ixp4xx: use __iomem pointers for MMIO

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

At the moment, this patch conflicts with other patches in linux-next,
need to sort this out.

Cc: Imre Kaloz <kaloz@openwrt.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index a9f8094..fdf91a1 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -53,24 +53,24 @@ static struct clock_event_device clockevent_ixp4xx;
  *************************************************************************/
 static struct map_desc ixp4xx_io_desc[] __initdata = {
 	{	/* UART, Interrupt ctrl, GPIO, timers, NPEs, MACs, USB .... */
-		.virtual	= IXP4XX_PERIPHERAL_BASE_VIRT,
+		.virtual	= (unsigned long)IXP4XX_PERIPHERAL_BASE_VIRT,
 		.pfn		= __phys_to_pfn(IXP4XX_PERIPHERAL_BASE_PHYS),
 		.length		= IXP4XX_PERIPHERAL_REGION_SIZE,
 		.type		= MT_DEVICE
 	}, {	/* Expansion Bus Config Registers */
-		.virtual	= IXP4XX_EXP_CFG_BASE_VIRT,
+		.virtual	= (unsigned long)IXP4XX_EXP_CFG_BASE_VIRT,
 		.pfn		= __phys_to_pfn(IXP4XX_EXP_CFG_BASE_PHYS),
 		.length		= IXP4XX_EXP_CFG_REGION_SIZE,
 		.type		= MT_DEVICE
 	}, {	/* PCI Registers */
-		.virtual	= IXP4XX_PCI_CFG_BASE_VIRT,
+		.virtual	= (unsigned long)IXP4XX_PCI_CFG_BASE_VIRT,
 		.pfn		= __phys_to_pfn(IXP4XX_PCI_CFG_BASE_PHYS),
 		.length		= IXP4XX_PCI_CFG_REGION_SIZE,
 		.type		= MT_DEVICE
 	},
 #ifdef CONFIG_DEBUG_LL
 	{	/* Debug UART mapping */
-		.virtual	= IXP4XX_DEBUG_UART_BASE_VIRT,
+		.virtual	= (unsigned long)IXP4XX_DEBUG_UART_BASE_VIRT,
 		.pfn		= __phys_to_pfn(IXP4XX_DEBUG_UART_BASE_PHYS),
 		.length		= IXP4XX_DEBUG_UART_REGION_SIZE,
 		.type		= MT_DEVICE
diff --git a/arch/arm/mach-ixp4xx/include/mach/cpu.h b/arch/arm/mach-ixp4xx/include/mach/cpu.h
index b2ef65d..ebc0ba3 100644
--- a/arch/arm/mach-ixp4xx/include/mach/cpu.h
+++ b/arch/arm/mach-ixp4xx/include/mach/cpu.h
@@ -14,6 +14,7 @@
 #ifndef __ASM_ARCH_CPU_H__
 #define __ASM_ARCH_CPU_H__
 
+#include <linux/io.h>
 #include <asm/cputype.h>
 
 /* Processor id value in CP15 Register 0 */
@@ -37,7 +38,7 @@
 
 static inline u32 ixp4xx_read_feature_bits(void)
 {
-	u32 val = ~*IXP4XX_EXP_CFG2;
+	u32 val = ~__raw_readl(IXP4XX_EXP_CFG2);
 
 	if (cpu_is_ixp42x_rev_a0())
 		return IXP42X_FEATURE_MASK & ~(IXP4XX_FEATURE_RCOMP |
@@ -51,7 +52,7 @@ static inline u32 ixp4xx_read_feature_bits(void)
 
 static inline void ixp4xx_write_feature_bits(u32 value)
 {
-	*IXP4XX_EXP_CFG2 = ~value;
+	__raw_writel(~value, IXP4XX_EXP_CFG2);
 }
 
 #endif  /* _ASM_ARCH_CPU_H */
diff --git a/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h b/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
index 97c530f..eb68b61 100644
--- a/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
+++ b/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
@@ -49,21 +49,21 @@
  * Expansion BUS Configuration registers
  */
 #define IXP4XX_EXP_CFG_BASE_PHYS	(0xC4000000)
-#define IXP4XX_EXP_CFG_BASE_VIRT	(0xFFBFE000)
+#define IXP4XX_EXP_CFG_BASE_VIRT	IOMEM(0xFFBFE000)
 #define IXP4XX_EXP_CFG_REGION_SIZE	(0x00001000)
 
 /*
  * PCI Config registers
  */
 #define IXP4XX_PCI_CFG_BASE_PHYS	(0xC0000000)
-#define	IXP4XX_PCI_CFG_BASE_VIRT	(0xFFBFF000)
+#define	IXP4XX_PCI_CFG_BASE_VIRT	IOMEM(0xFFBFF000)
 #define IXP4XX_PCI_CFG_REGION_SIZE	(0x00001000)
 
 /*
  * Peripheral space
  */
 #define IXP4XX_PERIPHERAL_BASE_PHYS	(0xC8000000)
-#define IXP4XX_PERIPHERAL_BASE_VIRT	(0xFFBEB000)
+#define IXP4XX_PERIPHERAL_BASE_VIRT	IOMEM(0xFFBEB000)
 #define IXP4XX_PERIPHERAL_REGION_SIZE	(0x00013000)
 
 /*
@@ -73,7 +73,7 @@
  * aligned so that it * can be used with the low-level debug code.
  */
 #define	IXP4XX_DEBUG_UART_BASE_PHYS	(0xC8000000)
-#define	IXP4XX_DEBUG_UART_BASE_VIRT	(0xffb00000)
+#define	IXP4XX_DEBUG_UART_BASE_VIRT	IOMEM(0xffb00000)
 #define	IXP4XX_DEBUG_UART_REGION_SIZE	(0x00001000)
 
 #define IXP4XX_EXP_CS0_OFFSET	0x00
@@ -92,7 +92,7 @@
 /*
  * Expansion Bus Controller registers.
  */
-#define IXP4XX_EXP_REG(x) ((volatile u32 *)(IXP4XX_EXP_CFG_BASE_VIRT+(x)))
+#define IXP4XX_EXP_REG(x) ((volatile u32 __iomem *)(IXP4XX_EXP_CFG_BASE_VIRT+(x)))
 
 #define IXP4XX_EXP_CS0      IXP4XX_EXP_REG(IXP4XX_EXP_CS0_OFFSET)
 #define IXP4XX_EXP_CS1      IXP4XX_EXP_REG(IXP4XX_EXP_CS1_OFFSET)
