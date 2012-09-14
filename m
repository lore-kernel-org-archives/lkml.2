Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab2INVjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:39:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55306 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab2INVff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
Subject: [PATCH 01/24] ARM: shmobile: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:29 +0200
Message-Id: <1347658492-11608-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:qUTqIHs95tgOCba+bFGEtyOP92trKhKsqbw1nSL2bQi
 jcyEiFxNYLNX3zGYp0pVMY31bD5i1JrhYBrtwjrvMT6Cydxog8
 kurzNYU1jVSGzjASH+AaxzLc4aCC8wpkqNptOJg86JTOMrhM/z
 cfrB7O/QGfGOt84odKv4X8pqU664bjeCCKL7wVtPya3vEY6MH1
 Na5smsbAqHFEHgMU/i3rsKpfj2HNXAppWrBYkJtOE3k6magddR
 h26A8U0MQEgzdbm7W2KqLb4rhYUH7tIYpldpkD2ezDgRnhtr2s
 yZIbd4jnOgwD6y+f3xWDugyDqBd2OwFgSa9HeGCUyuCB4pW+Mj
 pQENVAWCun6890cxvgLUmgnS2GA4v/IQLXR64+uTQptuxf6DOH
 46veSPauATaSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

This patch is a bit ugly for shmobile, which is the only platform
that just uses integer literals all over the place, but I can't
see a better way to do this.

Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-shmobile/board-ap4evb.c          |   12 ++--
 arch/arm/mach-shmobile/board-armadillo800eva.c |    6 +-
 arch/arm/mach-shmobile/board-bonito.c          |    8 +--
 arch/arm/mach-shmobile/board-g3evm.c           |   12 ++--
 arch/arm/mach-shmobile/board-g4evm.c           |   30 +++++-----
 arch/arm/mach-shmobile/board-kzm9g.c           |    8 +--
 arch/arm/mach-shmobile/board-mackerel.c        |   22 ++++----
 arch/arm/mach-shmobile/clock-r8a7740.c         |   46 ++++++++--------
 arch/arm/mach-shmobile/clock-sh7367.c          |   44 +++++++--------
 arch/arm/mach-shmobile/clock-sh7372.c          |   60 ++++++++++----------
 arch/arm/mach-shmobile/clock-sh7377.c          |   50 ++++++++---------
 arch/arm/mach-shmobile/clock-sh73a0.c          |   70 ++++++++++++------------
 arch/arm/mach-shmobile/include/mach/gpio.h     |    6 +-
 arch/arm/mach-shmobile/intc-r8a7779.c          |   14 ++---
 arch/arm/mach-shmobile/intc-sh7372.c           |   27 +++++----
 arch/arm/mach-shmobile/intc-sh73a0.c           |   20 ++++---
 arch/arm/mach-shmobile/pm-rmobile.c            |    6 +-
 arch/arm/mach-shmobile/pm-sh7372.c             |   57 +++++++++----------
 arch/arm/mach-shmobile/setup-sh7367.c          |    2 +-
 arch/arm/mach-shmobile/setup-sh7377.c          |    2 +-
 arch/arm/mach-shmobile/setup-sh73a0.c          |    2 +-
 include/linux/serial_sci.h                     |    2 +-
 22 files changed, 256 insertions(+), 250 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index f172ca8..1089ee5 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -432,7 +432,7 @@ static void usb1_host_port_power(int port, int power)
 		return;
 
 	/* set VBOUT/PWEN and EXTLP1 in DVSTCTR */
-	__raw_writew(__raw_readw(0xE68B0008) | 0x600, 0xE68B0008);
+	__raw_writew(__raw_readw(IOMEM(0xE68B0008)) | 0x600, IOMEM(0xE68B0008));
 }
 
 static struct r8a66597_platdata usb1_host_data = {
@@ -1224,9 +1224,9 @@ static struct i2c_board_info i2c1_devices[] = {
 };
 
 
-#define GPIO_PORT9CR	0xE6051009
-#define GPIO_PORT10CR	0xE605100A
-#define USCCR1		0xE6058144
+#define GPIO_PORT9CR	IOMEM(0xE6051009)
+#define GPIO_PORT10CR	IOMEM(0xE605100A)
+#define USCCR1		IOMEM(0xE6058144)
 static void __init ap4evb_init(void)
 {
 	u32 srcr4;
@@ -1304,7 +1304,7 @@ static void __init ap4evb_init(void)
 	gpio_request(GPIO_FN_OVCN2_1,    NULL);
 
 	/* setup USB phy */
-	__raw_writew(0x8a0a, 0xE6058130);	/* USBCR4 */
+	__raw_writew(0x8a0a, IOMEM(0xE6058130));	/* USBCR4 */
 
 	/* enable FSI2 port A (ak4643) */
 	gpio_request(GPIO_FN_FSIAIBT,	NULL);
@@ -1453,7 +1453,7 @@ static void __init ap4evb_init(void)
 	gpio_request(GPIO_FN_HDMI_CEC, NULL);
 
 	/* Reset HDMI, must be held at least one EXTALR (32768Hz) period */
-#define SRCR4 0xe61580bc
+#define SRCR4 IOMEM(0xe61580bc)
 	srcr4 = __raw_readl(SRCR4);
 	__raw_writel(srcr4 | (1 << 13), SRCR4);
 	udelay(50);
diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
index cf10f92..2f32aa6 100644
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@ -135,7 +135,7 @@
  *	usbhsf_power_ctrl()
  */
 #define IRQ7		evt2irq(0x02e0)
-#define USBCR1		0xe605810a
+#define USBCR1		IOMEM(0xe605810a)
 #define USBH		0xC6700000
 #define USBH_USBCTR	0x10834
 
@@ -949,8 +949,8 @@ clock_error:
 /*
  * board init
  */
-#define GPIO_PORT7CR	0xe6050007
-#define GPIO_PORT8CR	0xe6050008
+#define GPIO_PORT7CR	IOMEM(0xe6050007)
+#define GPIO_PORT8CR	IOMEM(0xe6050008)
 static void __init eva_init(void)
 {
 	struct platform_device *usb = NULL;
diff --git a/arch/arm/mach-shmobile/board-bonito.c b/arch/arm/mach-shmobile/board-bonito.c
index 4129008..cb8c994 100644
--- a/arch/arm/mach-shmobile/board-bonito.c
+++ b/arch/arm/mach-shmobile/board-bonito.c
@@ -108,12 +108,12 @@ static struct regulator_consumer_supply dummy_supplies[] = {
 #define FPGA_ETH_IRQ		(FPGA_IRQ0 + 15)
 static u16 bonito_fpga_read(u32 offset)
 {
-	return __raw_readw(0xf0003000 + offset);
+	return __raw_readw(IOMEM(0xf0003000) + offset);
 }
 
 static void bonito_fpga_write(u32 offset, u16 val)
 {
-	__raw_writew(val, 0xf0003000 + offset);
+	__raw_writew(val, IOMEM(0xf0003000) + offset);
 }
 
 static void bonito_fpga_irq_disable(struct irq_data *data)
@@ -361,8 +361,8 @@ static void __init bonito_map_io(void)
 #define BIT_ON(sw, bit)		(sw & (1 << bit))
 #define BIT_OFF(sw, bit)	(!(sw & (1 << bit)))
 
-#define VCCQ1CR		0xE6058140
-#define VCCQ1LCDCR	0xE6058186
+#define VCCQ1CR		IOMEM(0xE6058140)
+#define VCCQ1LCDCR	IOMEM(0xE6058186)
 
 static void __init bonito_init(void)
 {
diff --git a/arch/arm/mach-shmobile/board-g3evm.c b/arch/arm/mach-shmobile/board-g3evm.c
index 796fa00..b179d4c 100644
--- a/arch/arm/mach-shmobile/board-g3evm.c
+++ b/arch/arm/mach-shmobile/board-g3evm.c
@@ -106,7 +106,7 @@ static void usb_host_port_power(int port, int power)
 		return;
 
 	/* set VBOUT/PWEN and EXTLP0 in DVSTCTR */
-	__raw_writew(__raw_readw(0xe6890008) | 0x600, 0xe6890008);
+	__raw_writew(__raw_readw(IOMEM(0xe6890008)) | 0x600, IOMEM(0xe6890008));
 }
 
 static struct r8a66597_platdata usb_host_data = {
@@ -279,10 +279,10 @@ static void __init g3evm_init(void)
 	gpio_request(GPIO_FN_IDIN, NULL);
 
 	/* setup USB phy */
-	__raw_writew(0x0300, 0xe605810a);	/* USBCR1 */
-	__raw_writew(0x00e0, 0xe60581c0);	/* CPFCH */
-	__raw_writew(0x6010, 0xe60581c6);	/* CGPOSR */
-	__raw_writew(0x8a0a, 0xe605810c);	/* USBCR2 */
+	__raw_writew(0x0300, IOMEM(0xe605810a));	/* USBCR1 */
+	__raw_writew(0x00e0, IOMEM(0xe60581c0));	/* CPFCH */
+	__raw_writew(0x6010, IOMEM(0xe60581c6));	/* CGPOSR */
+	__raw_writew(0x8a0a, IOMEM(0xe605810c));	/* USBCR2 */
 
 	/* KEYSC @ CN7 */
 	gpio_request(GPIO_FN_PORT42_KEYOUT0, NULL);
@@ -320,7 +320,7 @@ static void __init g3evm_init(void)
 	gpio_request(GPIO_FN_WE0_XWR0_FWE, NULL);
 	gpio_request(GPIO_FN_FRB, NULL);
 	/* FOE, FCDE, FSC on dedicated pins */
-	__raw_writel(__raw_readl(0xe6158048) & ~(1 << 15), 0xe6158048);
+	__raw_writel(__raw_readl(IOMEM(0xe6158048)) & ~(1 << 15), IOMEM(0xe6158048));
 
 	/* IrDA */
 	gpio_request(GPIO_FN_IRDA_OUT, NULL);
diff --git a/arch/arm/mach-shmobile/board-g4evm.c b/arch/arm/mach-shmobile/board-g4evm.c
index fa5dfc5..22d6893 100644
--- a/arch/arm/mach-shmobile/board-g4evm.c
+++ b/arch/arm/mach-shmobile/board-g4evm.c
@@ -126,7 +126,7 @@ static void usb_host_port_power(int port, int power)
 		return;
 
 	/* set VBOUT/PWEN and EXTLP0 in DVSTCTR */
-	__raw_writew(__raw_readw(0xe6890008) | 0x600, 0xe6890008);
+	__raw_writew(__raw_readw(IOMEM(0xe6890008)) | 0x600, IOMEM(0xe6890008));
 }
 
 static struct r8a66597_platdata usb_host_data = {
@@ -270,17 +270,17 @@ static struct platform_device *g4evm_devices[] __initdata = {
 	&sdhi1_device,
 };
 
-#define GPIO_SDHID0_D0	0xe60520fc
-#define GPIO_SDHID0_D1	0xe60520fd
-#define GPIO_SDHID0_D2	0xe60520fe
-#define GPIO_SDHID0_D3	0xe60520ff
-#define GPIO_SDHICMD0	0xe6052100
+#define GPIO_SDHID0_D0	IOMEM(0xe60520fc)
+#define GPIO_SDHID0_D1	IOMEM(0xe60520fd)
+#define GPIO_SDHID0_D2	IOMEM(0xe60520fe)
+#define GPIO_SDHID0_D3	IOMEM(0xe60520ff)
+#define GPIO_SDHICMD0	IOMEM(0xe6052100)
 
-#define GPIO_SDHID1_D0	0xe6052103
-#define GPIO_SDHID1_D1	0xe6052104
-#define GPIO_SDHID1_D2	0xe6052105
-#define GPIO_SDHID1_D3	0xe6052106
-#define GPIO_SDHICMD1	0xe6052107
+#define GPIO_SDHID1_D0	IOMEM(0xe6052103)
+#define GPIO_SDHID1_D1	IOMEM(0xe6052104)
+#define GPIO_SDHID1_D2	IOMEM(0xe6052105)
+#define GPIO_SDHID1_D3	IOMEM(0xe6052106)
+#define GPIO_SDHICMD1	IOMEM(0xe6052107)
 
 static void __init g4evm_init(void)
 {
@@ -318,10 +318,10 @@ static void __init g4evm_init(void)
 	gpio_request(GPIO_FN_IDIN, NULL);
 
 	/* setup USB phy */
-	__raw_writew(0x0200, 0xe605810a);       /* USBCR1 */
-	__raw_writew(0x00e0, 0xe60581c0);       /* CPFCH */
-	__raw_writew(0x6010, 0xe60581c6);       /* CGPOSR */
-	__raw_writew(0x8a0a, 0xe605810c);       /* USBCR2 */
+	__raw_writew(0x0200, IOMEM(0xe605810a));       /* USBCR1 */
+	__raw_writew(0x00e0, IOMEM(0xe60581c0));       /* CPFCH */
+	__raw_writew(0x6010, IOMEM(0xe60581c6));       /* CGPOSR */
+	__raw_writew(0x8a0a, IOMEM(0xe605810c));       /* USBCR2 */
 
 	/* KEYSC @ CN31 */
 	gpio_request(GPIO_FN_PORT60_KEYOUT5, NULL);
diff --git a/arch/arm/mach-shmobile/board-kzm9g.c b/arch/arm/mach-shmobile/board-kzm9g.c
index 53b7ea9..5ffafc1 100644
--- a/arch/arm/mach-shmobile/board-kzm9g.c
+++ b/arch/arm/mach-shmobile/board-kzm9g.c
@@ -133,8 +133,8 @@ static struct platform_device usb_host_device = {
 
 /* USB Func CN17 */
 struct usbhs_private {
-	unsigned int phy;
-	unsigned int cr2;
+	void __iomem *phy;
+	void __iomem *cr2;
 	struct renesas_usbhs_platform_info info;
 };
 
@@ -232,8 +232,8 @@ static u32 usbhs_pipe_cfg[] = {
 };
 
 static struct usbhs_private usbhs_private = {
-	.phy	= 0xe60781e0,		/* USBPHYINT */
-	.cr2	= 0xe605810c,		/* USBCR2 */
+	.phy	= IOMEM(0xe60781e0),		/* USBPHYINT */
+	.cr2	= IOMEM(0xe605810c),		/* USBCR2 */
 	.info = {
 		.platform_callback = {
 			.hardware_init	= usbhs_hardware_init,
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 7ea2b31..d271b46 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -583,8 +583,8 @@ out:
 #define USBHS0_POLL_INTERVAL (HZ * 5)
 
 struct usbhs_private {
-	unsigned int usbphyaddr;
-	unsigned int usbcrcaddr;
+	void __iomem *usbphyaddr;
+	void __iomem *usbcrcaddr;
 	struct renesas_usbhs_platform_info info;
 	struct delayed_work work;
 	struct platform_device *pdev;
@@ -642,7 +642,7 @@ static void usbhs0_hardware_exit(struct platform_device *pdev)
 }
 
 static struct usbhs_private usbhs0_private = {
-	.usbcrcaddr	= 0xe605810c,		/* USBCR2 */
+	.usbcrcaddr	= IOMEM(0xe605810c),		/* USBCR2 */
 	.info = {
 		.platform_callback = {
 			.hardware_init	= usbhs0_hardware_init,
@@ -775,8 +775,8 @@ static u32 usbhs1_pipe_cfg[] = {
 };
 
 static struct usbhs_private usbhs1_private = {
-	.usbphyaddr	= 0xe60581e2,		/* USBPHY1INTAP */
-	.usbcrcaddr	= 0xe6058130,		/* USBCR4 */
+	.usbphyaddr	= IOMEM(0xe60581e2),	/* USBPHY1INTAP */
+	.usbcrcaddr	= IOMEM(0xe6058130),	/* USBCR4 */
 	.info = {
 		.platform_callback = {
 			.hardware_init	= usbhs1_hardware_init,
@@ -1401,12 +1401,12 @@ static struct i2c_board_info i2c1_devices[] = {
 	},
 };
 
-#define GPIO_PORT9CR	0xE6051009
-#define GPIO_PORT10CR	0xE605100A
-#define GPIO_PORT167CR	0xE60520A7
-#define GPIO_PORT168CR	0xE60520A8
-#define SRCR4		0xe61580bc
-#define USCCR1		0xE6058144
+#define GPIO_PORT9CR	IOMEM(0xE6051009)
+#define GPIO_PORT10CR	IOMEM(0xE605100A)
+#define GPIO_PORT167CR	IOMEM(0xE60520A7)
+#define GPIO_PORT168CR	IOMEM(0xE60520A8)
+#define SRCR4		IOMEM(0xe61580bc)
+#define USCCR1		IOMEM(0xE6058144)
 static void __init mackerel_init(void)
 {
 	u32 srcr4;
diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
index ad5fccc..6729e00 100644
--- a/arch/arm/mach-shmobile/clock-r8a7740.c
+++ b/arch/arm/mach-shmobile/clock-r8a7740.c
@@ -41,29 +41,29 @@
  */
 
 /* CPG registers */
-#define FRQCRA		0xe6150000
-#define FRQCRB		0xe6150004
-#define VCLKCR1		0xE6150008
-#define VCLKCR2		0xE615000c
-#define FRQCRC		0xe61500e0
-#define FSIACKCR	0xe6150018
-#define PLLC01CR	0xe6150028
-
-#define SUBCKCR		0xe6150080
-#define USBCKCR		0xe615008c
-
-#define MSTPSR0		0xe6150030
-#define MSTPSR1		0xe6150038
-#define MSTPSR2		0xe6150040
-#define MSTPSR3		0xe6150048
-#define MSTPSR4		0xe615004c
-#define FSIBCKCR	0xe6150090
-#define HDMICKCR	0xe6150094
-#define SMSTPCR0	0xe6150130
-#define SMSTPCR1	0xe6150134
-#define SMSTPCR2	0xe6150138
-#define SMSTPCR3	0xe615013c
-#define SMSTPCR4	0xe6150140
+#define FRQCRA		IOMEM(0xe6150000)
+#define FRQCRB		IOMEM(0xe6150004)
+#define VCLKCR1		IOMEM(0xE6150008)
+#define VCLKCR2		IOMEM(0xE615000c)
+#define FRQCRC		IOMEM(0xe61500e0)
+#define FSIACKCR	IOMEM(0xe6150018)
+#define PLLC01CR	IOMEM(0xe6150028)
+
+#define SUBCKCR		IOMEM(0xe6150080)
+#define USBCKCR		IOMEM(0xe615008c)
+
+#define MSTPSR0		IOMEM(0xe6150030)
+#define MSTPSR1		IOMEM(0xe6150038)
+#define MSTPSR2		IOMEM(0xe6150040)
+#define MSTPSR3		IOMEM(0xe6150048)
+#define MSTPSR4		IOMEM(0xe615004c)
+#define FSIBCKCR	IOMEM(0xe6150090)
+#define HDMICKCR	IOMEM(0xe6150094)
+#define SMSTPCR0	IOMEM(0xe6150130)
+#define SMSTPCR1	IOMEM(0xe6150134)
+#define SMSTPCR2	IOMEM(0xe6150138)
+#define SMSTPCR3	IOMEM(0xe615013c)
+#define SMSTPCR4	IOMEM(0xe6150140)
 
 /* Fixed 32 KHz root clock from EXTALR pin */
 static struct clk extalr_clk = {
diff --git a/arch/arm/mach-shmobile/clock-sh7367.c b/arch/arm/mach-shmobile/clock-sh7367.c
index 162b791..ef0a95e 100644
--- a/arch/arm/mach-shmobile/clock-sh7367.c
+++ b/arch/arm/mach-shmobile/clock-sh7367.c
@@ -24,28 +24,28 @@
 #include <mach/common.h>
 
 /* SH7367 registers */
-#define RTFRQCR    0xe6150000
-#define SYFRQCR    0xe6150004
-#define CMFRQCR    0xe61500E0
-#define VCLKCR1    0xe6150008
-#define VCLKCR2    0xe615000C
-#define VCLKCR3    0xe615001C
-#define SCLKACR    0xe6150010
-#define SCLKBCR    0xe6150014
-#define SUBUSBCKCR 0xe6158080
-#define SPUCKCR    0xe6150084
-#define MSUCKCR    0xe6150088
-#define MVI3CKCR   0xe6150090
-#define VOUCKCR    0xe6150094
-#define MFCK1CR    0xe6150098
-#define MFCK2CR    0xe615009C
-#define PLLC1CR    0xe6150028
-#define PLLC2CR    0xe615002C
-#define RTMSTPCR0  0xe6158030
-#define RTMSTPCR2  0xe6158038
-#define SYMSTPCR0  0xe6158040
-#define SYMSTPCR2  0xe6158048
-#define CMMSTPCR0  0xe615804c
+#define RTFRQCR    IOMEM(0xe6150000)
+#define SYFRQCR    IOMEM(0xe6150004)
+#define CMFRQCR    IOMEM(0xe61500E0)
+#define VCLKCR1    IOMEM(0xe6150008)
+#define VCLKCR2    IOMEM(0xe615000C)
+#define VCLKCR3    IOMEM(0xe615001C)
+#define SCLKACR    IOMEM(0xe6150010)
+#define SCLKBCR    IOMEM(0xe6150014)
+#define SUBUSBCKCR IOMEM(0xe6158080)
+#define SPUCKCR    IOMEM(0xe6150084)
+#define MSUCKCR    IOMEM(0xe6150088)
+#define MVI3CKCR   IOMEM(0xe6150090)
+#define VOUCKCR    IOMEM(0xe6150094)
+#define MFCK1CR    IOMEM(0xe6150098)
+#define MFCK2CR    IOMEM(0xe615009C)
+#define PLLC1CR    IOMEM(0xe6150028)
+#define PLLC2CR    IOMEM(0xe615002C)
+#define RTMSTPCR0  IOMEM(0xe6158030)
+#define RTMSTPCR2  IOMEM(0xe6158038)
+#define SYMSTPCR0  IOMEM(0xe6158040)
+#define SYMSTPCR2  IOMEM(0xe6158048)
+#define CMMSTPCR0  IOMEM(0xe615804c)
 
 /* Fixed 32 KHz root clock from EXTALR pin */
 static struct clk r_clk = {
diff --git a/arch/arm/mach-shmobile/clock-sh7372.c b/arch/arm/mach-shmobile/clock-sh7372.c
index 5a2894b..430a90f 100644
--- a/arch/arm/mach-shmobile/clock-sh7372.c
+++ b/arch/arm/mach-shmobile/clock-sh7372.c
@@ -24,36 +24,36 @@
 #include <mach/common.h>
 
 /* SH7372 registers */
-#define FRQCRA		0xe6150000
-#define FRQCRB		0xe6150004
-#define FRQCRC		0xe61500e0
-#define FRQCRD		0xe61500e4
-#define VCLKCR1		0xe6150008
-#define VCLKCR2		0xe615000c
-#define VCLKCR3		0xe615001c
-#define FMSICKCR	0xe6150010
-#define FMSOCKCR	0xe6150014
-#define FSIACKCR	0xe6150018
-#define FSIBCKCR	0xe6150090
-#define SUBCKCR		0xe6150080
-#define SPUCKCR		0xe6150084
-#define VOUCKCR		0xe6150088
-#define HDMICKCR	0xe6150094
-#define DSITCKCR	0xe6150060
-#define DSI0PCKCR	0xe6150064
-#define DSI1PCKCR	0xe6150098
-#define PLLC01CR	0xe6150028
-#define PLLC2CR		0xe615002c
-#define RMSTPCR0	0xe6150110
-#define RMSTPCR1	0xe6150114
-#define RMSTPCR2	0xe6150118
-#define RMSTPCR3	0xe615011c
-#define RMSTPCR4	0xe6150120
-#define SMSTPCR0	0xe6150130
-#define SMSTPCR1	0xe6150134
-#define SMSTPCR2	0xe6150138
-#define SMSTPCR3	0xe615013c
-#define SMSTPCR4	0xe6150140
+#define FRQCRA		IOMEM(0xe6150000)
+#define FRQCRB		IOMEM(0xe6150004)
+#define FRQCRC		IOMEM(0xe61500e0)
+#define FRQCRD		IOMEM(0xe61500e4)
+#define VCLKCR1		IOMEM(0xe6150008)
+#define VCLKCR2		IOMEM(0xe615000c)
+#define VCLKCR3		IOMEM(0xe615001c)
+#define FMSICKCR	IOMEM(0xe6150010)
+#define FMSOCKCR	IOMEM(0xe6150014)
+#define FSIACKCR	IOMEM(0xe6150018)
+#define FSIBCKCR	IOMEM(0xe6150090)
+#define SUBCKCR		IOMEM(0xe6150080)
+#define SPUCKCR		IOMEM(0xe6150084)
+#define VOUCKCR		IOMEM(0xe6150088)
+#define HDMICKCR	IOMEM(0xe6150094)
+#define DSITCKCR	IOMEM(0xe6150060)
+#define DSI0PCKCR	IOMEM(0xe6150064)
+#define DSI1PCKCR	IOMEM(0xe6150098)
+#define PLLC01CR	IOMEM(0xe6150028)
+#define PLLC2CR		IOMEM(0xe615002c)
+#define RMSTPCR0	IOMEM(0xe6150110)
+#define RMSTPCR1	IOMEM(0xe6150114)
+#define RMSTPCR2	IOMEM(0xe6150118)
+#define RMSTPCR3	IOMEM(0xe615011c)
+#define RMSTPCR4	IOMEM(0xe6150120)
+#define SMSTPCR0	IOMEM(0xe6150130)
+#define SMSTPCR1	IOMEM(0xe6150134)
+#define SMSTPCR2	IOMEM(0xe6150138)
+#define SMSTPCR3	IOMEM(0xe615013c)
+#define SMSTPCR4	IOMEM(0xe6150140)
 
 #define FSIDIVA		0xFE1F8000
 #define FSIDIVB		0xFE1F8008
diff --git a/arch/arm/mach-shmobile/clock-sh7377.c b/arch/arm/mach-shmobile/clock-sh7377.c
index 85f2a3e..b8480d1 100644
--- a/arch/arm/mach-shmobile/clock-sh7377.c
+++ b/arch/arm/mach-shmobile/clock-sh7377.c
@@ -24,31 +24,31 @@
 #include <mach/common.h>
 
 /* SH7377 registers */
-#define RTFRQCR    0xe6150000
-#define SYFRQCR    0xe6150004
-#define CMFRQCR    0xe61500E0
-#define VCLKCR1    0xe6150008
-#define VCLKCR2    0xe615000C
-#define VCLKCR3    0xe615001C
-#define FMSICKCR   0xe6150010
-#define FMSOCKCR   0xe6150014
-#define FSICKCR    0xe6150018
-#define PLLC1CR    0xe6150028
-#define PLLC2CR    0xe615002C
-#define SUBUSBCKCR 0xe6150080
-#define SPUCKCR    0xe6150084
-#define MSUCKCR    0xe6150088
-#define MVI3CKCR   0xe6150090
-#define HDMICKCR   0xe6150094
-#define MFCK1CR    0xe6150098
-#define MFCK2CR    0xe615009C
-#define DSITCKCR   0xe6150060
-#define DSIPCKCR   0xe6150064
-#define SMSTPCR0   0xe6150130
-#define SMSTPCR1   0xe6150134
-#define SMSTPCR2   0xe6150138
-#define SMSTPCR3   0xe615013C
-#define SMSTPCR4   0xe6150140
+#define RTFRQCR    IOMEM(0xe6150000)
+#define SYFRQCR    IOMEM(0xe6150004)
+#define CMFRQCR    IOMEM(0xe61500E0)
+#define VCLKCR1    IOMEM(0xe6150008)
+#define VCLKCR2    IOMEM(0xe615000C)
+#define VCLKCR3    IOMEM(0xe615001C)
+#define FMSICKCR   IOMEM(0xe6150010)
+#define FMSOCKCR   IOMEM(0xe6150014)
+#define FSICKCR    IOMEM(0xe6150018)
+#define PLLC1CR    IOMEM(0xe6150028)
+#define PLLC2CR    IOMEM(0xe615002C)
+#define SUBUSBCKCR IOMEM(0xe6150080)
+#define SPUCKCR    IOMEM(0xe6150084)
+#define MSUCKCR    IOMEM(0xe6150088)
+#define MVI3CKCR   IOMEM(0xe6150090)
+#define HDMICKCR   IOMEM(0xe6150094)
+#define MFCK1CR    IOMEM(0xe6150098)
+#define MFCK2CR    IOMEM(0xe615009C)
+#define DSITCKCR   IOMEM(0xe6150060)
+#define DSIPCKCR   IOMEM(0xe6150064)
+#define SMSTPCR0   IOMEM(0xe6150130)
+#define SMSTPCR1   IOMEM(0xe6150134)
+#define SMSTPCR2   IOMEM(0xe6150138)
+#define SMSTPCR3   IOMEM(0xe615013C)
+#define SMSTPCR4   IOMEM(0xe6150140)
 
 /* Fixed 32 KHz root clock from EXTALR pin */
 static struct clk r_clk = {
diff --git a/arch/arm/mach-shmobile/clock-sh73a0.c b/arch/arm/mach-shmobile/clock-sh73a0.c
index 7f8da18..516ff7f 100644
--- a/arch/arm/mach-shmobile/clock-sh73a0.c
+++ b/arch/arm/mach-shmobile/clock-sh73a0.c
@@ -23,43 +23,43 @@
 #include <linux/clkdev.h>
 #include <mach/common.h>
 
-#define FRQCRA		0xe6150000
-#define FRQCRB		0xe6150004
-#define FRQCRD		0xe61500e4
-#define VCLKCR1		0xe6150008
-#define VCLKCR2		0xe615000C
-#define VCLKCR3		0xe615001C
-#define ZBCKCR		0xe6150010
-#define FLCKCR		0xe6150014
-#define SD0CKCR		0xe6150074
-#define SD1CKCR		0xe6150078
-#define SD2CKCR		0xe615007C
-#define FSIACKCR	0xe6150018
-#define FSIBCKCR	0xe6150090
-#define SUBCKCR		0xe6150080
-#define SPUACKCR	0xe6150084
-#define SPUVCKCR	0xe6150094
-#define MSUCKCR		0xe6150088
-#define HSICKCR		0xe615008C
-#define MFCK1CR		0xe6150098
-#define MFCK2CR		0xe615009C
-#define DSITCKCR	0xe6150060
-#define DSI0PCKCR	0xe6150064
-#define DSI1PCKCR	0xe6150068
+#define FRQCRA		IOMEM(0xe6150000)
+#define FRQCRB		IOMEM(0xe6150004)
+#define FRQCRD		IOMEM(0xe61500e4)
+#define VCLKCR1		IOMEM(0xe6150008)
+#define VCLKCR2		IOMEM(0xe615000C)
+#define VCLKCR3		IOMEM(0xe615001C)
+#define ZBCKCR		IOMEM(0xe6150010)
+#define FLCKCR		IOMEM(0xe6150014)
+#define SD0CKCR		IOMEM(0xe6150074)
+#define SD1CKCR		IOMEM(0xe6150078)
+#define SD2CKCR		IOMEM(0xe615007C)
+#define FSIACKCR	IOMEM(0xe6150018)
+#define FSIBCKCR	IOMEM(0xe6150090)
+#define SUBCKCR		IOMEM(0xe6150080)
+#define SPUACKCR	IOMEM(0xe6150084)
+#define SPUVCKCR	IOMEM(0xe6150094)
+#define MSUCKCR		IOMEM(0xe6150088)
+#define HSICKCR		IOMEM(0xe615008C)
+#define MFCK1CR		IOMEM(0xe6150098)
+#define MFCK2CR		IOMEM(0xe615009C)
+#define DSITCKCR	IOMEM(0xe6150060)
+#define DSI0PCKCR	IOMEM(0xe6150064)
+#define DSI1PCKCR	IOMEM(0xe6150068)
 #define DSI0PHYCR	0xe615006C
 #define DSI1PHYCR	0xe6150070
-#define PLLECR		0xe61500d0
-#define PLL0CR		0xe61500d8
-#define PLL1CR		0xe6150028
-#define PLL2CR		0xe615002c
-#define PLL3CR		0xe61500dc
-#define SMSTPCR0	0xe6150130
-#define SMSTPCR1	0xe6150134
-#define SMSTPCR2	0xe6150138
-#define SMSTPCR3	0xe615013c
-#define SMSTPCR4	0xe6150140
-#define SMSTPCR5	0xe6150144
-#define CKSCR		0xe61500c0
+#define PLLECR		IOMEM(0xe61500d0)
+#define PLL0CR		IOMEM(0xe61500d8)
+#define PLL1CR		IOMEM(0xe6150028)
+#define PLL2CR		IOMEM(0xe615002c)
+#define PLL3CR		IOMEM(0xe61500dc)
+#define SMSTPCR0	IOMEM(0xe6150130)
+#define SMSTPCR1	IOMEM(0xe6150134)
+#define SMSTPCR2	IOMEM(0xe6150138)
+#define SMSTPCR3	IOMEM(0xe615013c)
+#define SMSTPCR4	IOMEM(0xe6150140)
+#define SMSTPCR5	IOMEM(0xe6150144)
+#define CKSCR		IOMEM(0xe61500c0)
 
 /* Fixed 32 KHz root clock from EXTALR pin */
 static struct clk r_clk = {
diff --git a/arch/arm/mach-shmobile/include/mach/gpio.h b/arch/arm/mach-shmobile/include/mach/gpio.h
index 844507d..90a92b2 100644
--- a/arch/arm/mach-shmobile/include/mach/gpio.h
+++ b/arch/arm/mach-shmobile/include/mach/gpio.h
@@ -35,12 +35,12 @@ static inline int irq_to_gpio(unsigned int irq)
  * the method to control only pull up/down/free.
  * this function should be replaced by correct gpio function
  */
-static inline void __init gpio_direction_none(u32 addr)
+static inline void __init gpio_direction_none(void __iomem * addr)
 {
 	__raw_writeb(0x00, addr);
 }
 
-static inline void __init gpio_request_pullup(u32 addr)
+static inline void __init gpio_request_pullup(void __iomem * addr)
 {
 	u8 data = __raw_readb(addr);
 
@@ -49,7 +49,7 @@ static inline void __init gpio_request_pullup(u32 addr)
 	__raw_writeb(data, addr);
 }
 
-static inline void __init gpio_request_pulldown(u32 addr)
+static inline void __init gpio_request_pulldown(void __iomem * addr)
 {
 	u8 data = __raw_readb(addr);
 
diff --git a/arch/arm/mach-shmobile/intc-r8a7779.c b/arch/arm/mach-shmobile/intc-r8a7779.c
index f04fad4..ef66f1a 100644
--- a/arch/arm/mach-shmobile/intc-r8a7779.c
+++ b/arch/arm/mach-shmobile/intc-r8a7779.c
@@ -29,14 +29,14 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#define INT2SMSKCR0 0xfe7822a0
-#define INT2SMSKCR1 0xfe7822a4
-#define INT2SMSKCR2 0xfe7822a8
-#define INT2SMSKCR3 0xfe7822ac
-#define INT2SMSKCR4 0xfe7822b0
+#define INT2SMSKCR0 IOMEM(0xfe7822a0)
+#define INT2SMSKCR1 IOMEM(0xfe7822a4)
+#define INT2SMSKCR2 IOMEM(0xfe7822a8)
+#define INT2SMSKCR3 IOMEM(0xfe7822ac)
+#define INT2SMSKCR4 IOMEM(0xfe7822b0)
 
-#define INT2NTSR0 0xfe700060
-#define INT2NTSR1 0xfe700064
+#define INT2NTSR0 IOMEM(0xfe700060)
+#define INT2NTSR1 IOMEM(0xfe700064)
 
 static int r8a7779_set_wake(struct irq_data *data, unsigned int on)
 {
diff --git a/arch/arm/mach-shmobile/intc-sh7372.c b/arch/arm/mach-shmobile/intc-sh7372.c
index 2587a22..a91caad 100644
--- a/arch/arm/mach-shmobile/intc-sh7372.c
+++ b/arch/arm/mach-shmobile/intc-sh7372.c
@@ -624,6 +624,9 @@ void sh7372_intcs_resume(void)
 		__raw_writeb(ffd5[k], intcs_ffd5 + k);
 }
 
+#define E694_BASE IOMEM(0xe6940000)
+#define E695_BASE IOMEM(0xe6950000)
+
 static unsigned short e694[0x200];
 static unsigned short e695[0x200];
 
@@ -632,22 +635,22 @@ void sh7372_intca_suspend(void)
 	int k;
 
 	for (k = 0x00; k <= 0x38; k += 4)
-		e694[k] = __raw_readw(0xe6940000 + k);
+		e694[k] = __raw_readw(E694_BASE + k);
 
 	for (k = 0x80; k <= 0xb4; k += 4)
-		e694[k] = __raw_readb(0xe6940000 + k);
+		e694[k] = __raw_readb(E694_BASE + k);
 
 	for (k = 0x180; k <= 0x1b4; k += 4)
-		e694[k] = __raw_readb(0xe6940000 + k);
+		e694[k] = __raw_readb(E694_BASE + k);
 
 	for (k = 0x00; k <= 0x50; k += 4)
-		e695[k] = __raw_readw(0xe6950000 + k);
+		e695[k] = __raw_readw(E695_BASE + k);
 
 	for (k = 0x80; k <= 0xa8; k += 4)
-		e695[k] = __raw_readb(0xe6950000 + k);
+		e695[k] = __raw_readb(E695_BASE + k);
 
 	for (k = 0x180; k <= 0x1a8; k += 4)
-		e695[k] = __raw_readb(0xe6950000 + k);
+		e695[k] = __raw_readb(E695_BASE + k);
 }
 
 void sh7372_intca_resume(void)
@@ -655,20 +658,20 @@ void sh7372_intca_resume(void)
 	int k;
 
 	for (k = 0x00; k <= 0x38; k += 4)
-		__raw_writew(e694[k], 0xe6940000 + k);
+		__raw_writew(e694[k], E694_BASE + k);
 
 	for (k = 0x80; k <= 0xb4; k += 4)
-		__raw_writeb(e694[k], 0xe6940000 + k);
+		__raw_writeb(e694[k], E694_BASE + k);
 
 	for (k = 0x180; k <= 0x1b4; k += 4)
-		__raw_writeb(e694[k], 0xe6940000 + k);
+		__raw_writeb(e694[k], E694_BASE + k);
 
 	for (k = 0x00; k <= 0x50; k += 4)
-		__raw_writew(e695[k], 0xe6950000 + k);
+		__raw_writew(e695[k], E695_BASE + k);
 
 	for (k = 0x80; k <= 0xa8; k += 4)
-		__raw_writeb(e695[k], 0xe6950000 + k);
+		__raw_writeb(e695[k], E695_BASE + k);
 
 	for (k = 0x180; k <= 0x1a8; k += 4)
-		__raw_writeb(e695[k], 0xe6950000 + k);
+		__raw_writeb(e695[k], E695_BASE + k);
 }
diff --git a/arch/arm/mach-shmobile/intc-sh73a0.c b/arch/arm/mach-shmobile/intc-sh73a0.c
index ee44740..a8b2dd7 100644
--- a/arch/arm/mach-shmobile/intc-sh73a0.c
+++ b/arch/arm/mach-shmobile/intc-sh73a0.c
@@ -366,10 +366,12 @@ static irqreturn_t sh73a0_irq_pin_demux(int irq, void *dev_id)
 
 static struct irqaction sh73a0_irq_pin_cascade[32];
 
-#define PINTER0 0xe69000a0
-#define PINTER1 0xe69000a4
-#define PINTRR0 0xe69000d0
-#define PINTRR1 0xe69000d4
+#define PINTER0_PHYS 0xe69000a0
+#define PINTER1_PHYS 0xe69000a4
+#define PINTER0_VIRT IOMEM(0xe69000a0)
+#define PINTER1_VIRT IOMEM(0xe69000a4)
+#define PINTRR0 IOMEM(0xe69000d0)
+#define PINTRR1 IOMEM(0xe69000d4)
 
 #define PINT0A_IRQ(n, irq) INTC_IRQ((n), SH73A0_PINT0_IRQ(irq))
 #define PINT0B_IRQ(n, irq) INTC_IRQ((n), SH73A0_PINT0_IRQ(irq + 8))
@@ -377,14 +379,14 @@ static struct irqaction sh73a0_irq_pin_cascade[32];
 #define PINT0D_IRQ(n, irq) INTC_IRQ((n), SH73A0_PINT0_IRQ(irq + 24))
 #define PINT1E_IRQ(n, irq) INTC_IRQ((n), SH73A0_PINT1_IRQ(irq))
 
-INTC_PINT(intc_pint0, PINTER0, 0xe69000b0, "sh73a0-pint0",		\
+INTC_PINT(intc_pint0, PINTER0_PHYS, 0xe69000b0, "sh73a0-pint0",		\
   INTC_PINT_E(A), INTC_PINT_E(B), INTC_PINT_E(C), INTC_PINT_E(D),	\
   INTC_PINT_V(A, PINT0A_IRQ), INTC_PINT_V(B, PINT0B_IRQ),		\
   INTC_PINT_V(C, PINT0C_IRQ), INTC_PINT_V(D, PINT0D_IRQ),		\
   INTC_PINT_E(A), INTC_PINT_E(B), INTC_PINT_E(C), INTC_PINT_E(D),	\
   INTC_PINT_E(A), INTC_PINT_E(B), INTC_PINT_E(C), INTC_PINT_E(D));
 
-INTC_PINT(intc_pint1, PINTER1, 0xe69000c0, "sh73a0-pint1",		\
+INTC_PINT(intc_pint1, PINTER1_PHYS, 0xe69000c0, "sh73a0-pint1",		\
   INTC_PINT_E(E), INTC_PINT_E_EMPTY, INTC_PINT_E_EMPTY, INTC_PINT_E_EMPTY, \
   INTC_PINT_V(E, PINT1E_IRQ), INTC_PINT_V_NONE,				\
   INTC_PINT_V_NONE, INTC_PINT_V_NONE,					\
@@ -394,7 +396,7 @@ INTC_PINT(intc_pint1, PINTER1, 0xe69000c0, "sh73a0-pint1",		\
 static struct irqaction sh73a0_pint0_cascade;
 static struct irqaction sh73a0_pint1_cascade;
 
-static void pint_demux(unsigned long rr, unsigned long er, int base_irq)
+static void pint_demux(void __iomem *rr, void __iomem *er, int base_irq)
 {
 	unsigned long value =  ioread32(rr) & ioread32(er);
 	int k;
@@ -409,13 +411,13 @@ static void pint_demux(unsigned long rr, unsigned long er, int base_irq)
 
 static irqreturn_t sh73a0_pint0_demux(int irq, void *dev_id)
 {
-	pint_demux(PINTRR0, PINTER0, SH73A0_PINT0_IRQ(0));
+	pint_demux(PINTRR0, PINTER0_VIRT, SH73A0_PINT0_IRQ(0));
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t sh73a0_pint1_demux(int irq, void *dev_id)
 {
-	pint_demux(PINTRR1, PINTER1, SH73A0_PINT1_IRQ(0));
+	pint_demux(PINTRR1, PINTER1_VIRT, SH73A0_PINT1_IRQ(0));
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
index a856254..32e1772 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.c
+++ b/arch/arm/mach-shmobile/pm-rmobile.c
@@ -20,9 +20,9 @@
 #include <mach/pm-rmobile.h>
 
 /* SYSC */
-#define SPDCR		0xe6180008
-#define SWUCR		0xe6180014
-#define PSTR		0xe6180080
+#define SPDCR		IOMEM(0xe6180008)
+#define SWUCR		IOMEM(0xe6180014)
+#define PSTR		IOMEM(0xe6180080)
 
 #define PSTR_RETRIES	100
 #define PSTR_DELAY_US	10
diff --git a/arch/arm/mach-shmobile/pm-sh7372.c b/arch/arm/mach-shmobile/pm-sh7372.c
index 7920370..1621218 100644
--- a/arch/arm/mach-shmobile/pm-sh7372.c
+++ b/arch/arm/mach-shmobile/pm-sh7372.c
@@ -29,45 +29,46 @@
 #include <mach/pm-rmobile.h>
 
 /* DBG */
-#define DBGREG1 0xe6100020
-#define DBGREG9 0xe6100040
+#define DBGREG1 IOMEM(0xe6100020)
+#define DBGREG9 IOMEM(0xe6100040)
 
 /* CPGA */
-#define SYSTBCR 0xe6150024
-#define MSTPSR0 0xe6150030
-#define MSTPSR1 0xe6150038
-#define MSTPSR2 0xe6150040
-#define MSTPSR3 0xe6150048
-#define MSTPSR4 0xe615004c
-#define PLLC01STPCR 0xe61500c8
+#define SYSTBCR IOMEM(0xe6150024)
+#define MSTPSR0 IOMEM(0xe6150030)
+#define MSTPSR1 IOMEM(0xe6150038)
+#define MSTPSR2 IOMEM(0xe6150040)
+#define MSTPSR3 IOMEM(0xe6150048)
+#define MSTPSR4 IOMEM(0xe615004c)
+#define PLLC01STPCR IOMEM(0xe61500c8)
 
 /* SYSC */
-#define SBAR 0xe6180020
-#define WUPRMSK 0xe6180028
-#define WUPSMSK 0xe618002c
-#define WUPSMSK2 0xe6180048
-#define WUPSFAC 0xe6180098
-#define IRQCR 0xe618022c
-#define IRQCR2 0xe6180238
-#define IRQCR3 0xe6180244
-#define IRQCR4 0xe6180248
-#define PDNSEL 0xe6180254
+#define SBAR IOMEM(0xe6180020)
+#define WUPRMSK IOMEM(0xe6180028)
+#define WUPSMSK IOMEM(0xe618002c)
+#define WUPSMSK2 IOMEM(0xe6180048)
+#define WUPSFAC IOMEM(0xe6180098)
+#define IRQCR IOMEM(0xe618022c)
+#define IRQCR2 IOMEM(0xe6180238)
+#define IRQCR3 IOMEM(0xe6180244)
+#define IRQCR4 IOMEM(0xe6180248)
+#define PDNSEL IOMEM(0xe6180254)
 
 /* INTC */
-#define ICR1A 0xe6900000
-#define ICR2A 0xe6900004
-#define ICR3A 0xe6900008
-#define ICR4A 0xe690000c
-#define INTMSK00A 0xe6900040
-#define INTMSK10A 0xe6900044
-#define INTMSK20A 0xe6900048
-#define INTMSK30A 0xe690004c
+#define ICR1A IOMEM(0xe6900000)
+#define ICR2A IOMEM(0xe6900004)
+#define ICR3A IOMEM(0xe6900008)
+#define ICR4A IOMEM(0xe690000c)
+#define INTMSK00A IOMEM(0xe6900040)
+#define INTMSK10A IOMEM(0xe6900044)
+#define INTMSK20A IOMEM(0xe6900048)
+#define INTMSK30A IOMEM(0xe690004c)
 
 /* MFIS */
+/* FIXME: pointing where? */
 #define SMFRAM 0xe6a70000
 
 /* AP-System Core */
-#define APARMBAREA 0xe6f10020
+#define APARMBAREA IOMEM(0xe6f10020)
 
 #ifdef CONFIG_PM
 
diff --git a/arch/arm/mach-shmobile/setup-sh7367.c b/arch/arm/mach-shmobile/setup-sh7367.c
index 2e3074a..e647f54 100644
--- a/arch/arm/mach-shmobile/setup-sh7367.c
+++ b/arch/arm/mach-shmobile/setup-sh7367.c
@@ -462,7 +462,7 @@ static void __init sh7367_earlytimer_init(void)
 	shmobile_earlytimer_init();
 }
 
-#define SYMSTPCR2 0xe6158048
+#define SYMSTPCR2 IOMEM(0xe6158048)
 #define SYMSTPCR2_CMT1 (1 << 29)
 
 void __init sh7367_add_early_devices(void)
diff --git a/arch/arm/mach-shmobile/setup-sh7377.c b/arch/arm/mach-shmobile/setup-sh7377.c
index 855b150..edcf98b 100644
--- a/arch/arm/mach-shmobile/setup-sh7377.c
+++ b/arch/arm/mach-shmobile/setup-sh7377.c
@@ -484,7 +484,7 @@ static void __init sh7377_earlytimer_init(void)
 	shmobile_earlytimer_init();
 }
 
-#define SMSTPCR3 0xe615013c
+#define SMSTPCR3 IOMEM(0xe615013c)
 #define SMSTPCR3_CMT1 (1 << 29)
 
 void __init sh7377_add_early_devices(void)
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index d230af6..a13c97b 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -759,7 +759,7 @@ static struct platform_device *sh73a0_late_devices[] __initdata = {
 	&mpdma0_device,
 };
 
-#define SRCR2          0xe61580b0
+#define SRCR2          IOMEM(0xe61580b0)
 
 void __init sh73a0_add_standard_devices(void)
 {
diff --git a/include/linux/serial_sci.h b/include/linux/serial_sci.h
index eb763ad..d323290 100644
--- a/include/linux/serial_sci.h
+++ b/include/linux/serial_sci.h
@@ -150,7 +150,7 @@ struct plat_sci_port {
 	int		overrun_bit;
 	unsigned int	error_mask;
 
-	int		port_reg;
+	void __iomem   *port_reg;
 	unsigned char	regshift;
 	unsigned char	regtype;
 
-- 
1.7.10

