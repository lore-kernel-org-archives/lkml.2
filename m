Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047Ab2INVkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:40:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab2INVfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 06/24] ARM: integrator: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:34 +0200
Message-Id: <1347658492-11608-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:j79YfF5zY+A0sNOUzwBQJzhiMmRo84PXXkxobysGyUk
 PbzjG7NId74H2zoymQWFYJNlrf3ybgJY8pcPR6wc+LDvwpXypD
 LfFGeYSaXna0zMrva7MYqcylzHlC/vMC+01GH3eeDTTaM7HWqb
 cu3XvIrM9WvtCYfDQUcu/SO4cL/Ghhxgv13cz0MaodTEfH2nc/
 JeIJGKzUGTpK4YcqQH9p/iw2OAU1jrBD39CMej53bgwhAGU7t+
 dN84WI1pashQ0Ruc3lsi2XUXj+j/Uya6psPC6M7Y2EKZ0bk1I4
 J/3Ghjh0K6QG0DiktN+Tu8Bzhhtkeb/dMxrgN3Fscj9AY//WuL
 NwcKAJRECM2qzCOPHrmPFuPu61JI0X2/IQ8rfZfyXrildyxURS
 5mV55ejsUk48Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

This patch has a few small conflicts with stuff in linux-next, which
we have to sort out in arm-soc.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-integrator/core.c          |    4 ++--
 arch/arm/mach-integrator/cpu.c           |    8 ++++----
 arch/arm/mach-integrator/integrator_ap.c |   12 ++++++------
 arch/arm/mach-integrator/integrator_cp.c |    6 +++---
 arch/arm/mach-integrator/pci_v3.c        |   12 ++++++------
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index 3fa6c51..a432d43 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -95,8 +95,8 @@ arch_initcall(integrator_init);
  *  UART0  7    6
  *  UART1  5    4
  */
-#define SC_CTRLC	IO_ADDRESS(INTEGRATOR_SC_CTRLC)
-#define SC_CTRLS	IO_ADDRESS(INTEGRATOR_SC_CTRLS)
+#define SC_CTRLC	__io_address(INTEGRATOR_SC_CTRLC)
+#define SC_CTRLS	__io_address(INTEGRATOR_SC_CTRLS)
 
 static void integrator_uart_set_mctrl(struct amba_device *dev, void __iomem *base, unsigned int mctrl)
 {
diff --git a/arch/arm/mach-integrator/cpu.c b/arch/arm/mach-integrator/cpu.c
index fbb4577..590c192 100644
--- a/arch/arm/mach-integrator/cpu.c
+++ b/arch/arm/mach-integrator/cpu.c
@@ -25,10 +25,10 @@
 
 static struct cpufreq_driver integrator_driver;
 
-#define CM_ID  	IO_ADDRESS(INTEGRATOR_HDR_ID)
-#define CM_OSC	IO_ADDRESS(INTEGRATOR_HDR_OSC)
-#define CM_STAT IO_ADDRESS(INTEGRATOR_HDR_STAT)
-#define CM_LOCK IO_ADDRESS(INTEGRATOR_HDR_LOCK)
+#define CM_ID  	__io_address(INTEGRATOR_HDR_ID)
+#define CM_OSC	__io_address(INTEGRATOR_HDR_OSC)
+#define CM_STAT __io_address(INTEGRATOR_HDR_STAT)
+#define CM_LOCK __io_address(INTEGRATOR_HDR_LOCK)
 
 static const struct icst_params lclk_params = {
 	.ref		= 24000000,
diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index 3b22675..c8e448e 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -133,17 +133,17 @@ static struct map_desc ap_io_desc[] __initdata = {
 		.length		= SZ_4K,
 		.type		= MT_DEVICE
 	}, {
-		.virtual	= PCI_MEMORY_VADDR,
+		.virtual	= (unsigned long)PCI_MEMORY_VADDR,
 		.pfn		= __phys_to_pfn(PHYS_PCI_MEM_BASE),
 		.length		= SZ_16M,
 		.type		= MT_DEVICE
 	}, {
-		.virtual	= PCI_CONFIG_VADDR,
+		.virtual	= (unsigned long)PCI_CONFIG_VADDR,
 		.pfn		= __phys_to_pfn(PHYS_PCI_CONFIG_BASE),
 		.length		= SZ_16M,
 		.type		= MT_DEVICE
 	}, {
-		.virtual	= PCI_V3_VADDR,
+		.virtual	= (unsigned long)PCI_V3_VADDR,
 		.pfn		= __phys_to_pfn(PHYS_PCI_V3_BASE),
 		.length		= SZ_64K,
 		.type		= MT_DEVICE
@@ -317,9 +317,9 @@ static void __init ap_init(void)
 /*
  * Where is the timer (VA)?
  */
-#define TIMER0_VA_BASE IO_ADDRESS(INTEGRATOR_TIMER0_BASE)
-#define TIMER1_VA_BASE IO_ADDRESS(INTEGRATOR_TIMER1_BASE)
-#define TIMER2_VA_BASE IO_ADDRESS(INTEGRATOR_TIMER2_BASE)
+#define TIMER0_VA_BASE __io_address(INTEGRATOR_TIMER0_BASE)
+#define TIMER1_VA_BASE __io_address(INTEGRATOR_TIMER1_BASE)
+#define TIMER2_VA_BASE __io_address(INTEGRATOR_TIMER2_BASE)
 
 static unsigned long timer_reload;
 
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index 82d5c83..3df5fc3 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -59,7 +59,7 @@
 
 #define INTCP_ETH_SIZE			0x10
 
-#define INTCP_VA_CTRL_BASE		IO_ADDRESS(INTEGRATOR_CP_CTL_BASE)
+#define INTCP_VA_CTRL_BASE		__io_address(INTEGRATOR_CP_CTL_BASE)
 #define INTCP_FLASHPROG			0x04
 #define CINTEGRATOR_FLASHPROG_FLVPPEN	(1 << 0)
 #define CINTEGRATOR_FLASHPROG_FLWREN	(1 << 1)
@@ -265,8 +265,8 @@ static struct platform_device *intcp_devs[] __initdata = {
  */
 static unsigned int mmc_status(struct device *dev)
 {
-	unsigned int status = readl(IO_ADDRESS(0xca000000 + 4));
-	writel(8, IO_ADDRESS(INTEGRATOR_CP_CTL_BASE + 8));
+	unsigned int status = readl(__io_address(0xca000000 + 4));
+	writel(8, __io_address(INTEGRATOR_CP_CTL_BASE + 8));
 
 	return status & 8;
 }
diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index b866880..e6145a85 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -181,7 +181,7 @@ static DEFINE_RAW_SPINLOCK(v3_lock);
 #undef V3_LB_BASE_PREFETCH
 #define V3_LB_BASE_PREFETCH 0
 
-static unsigned long v3_open_config_window(struct pci_bus *bus,
+static void __iomem *v3_open_config_window(struct pci_bus *bus,
 					   unsigned int devfn, int offset)
 {
 	unsigned int address, mapaddress, busnr;
@@ -280,7 +280,7 @@ static void v3_close_config_window(void)
 static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 			  int size, u32 *val)
 {
-	unsigned long addr;
+	void __iomem *addr;
 	unsigned long flags;
 	u32 v;
 
@@ -311,7 +311,7 @@ static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 static int v3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
 			   int size, u32 val)
 {
-	unsigned long addr;
+	void __iomem *addr;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&v3_lock, flags);
@@ -391,9 +391,9 @@ static int __init pci_v3_setup_resources(struct pci_sys_data *sys)
  * means I can't get additional information on the reason for the pm2fb
  * problems.  I suppose I'll just have to mind-meld with the machine. ;)
  */
-#define SC_PCI     IO_ADDRESS(INTEGRATOR_SC_PCIENABLE)
-#define SC_LBFADDR IO_ADDRESS(INTEGRATOR_SC_BASE + 0x20)
-#define SC_LBFCODE IO_ADDRESS(INTEGRATOR_SC_BASE + 0x24)
+#define SC_PCI     __io_address(INTEGRATOR_SC_PCIENABLE)
+#define SC_LBFADDR __io_address(INTEGRATOR_SC_BASE + 0x20)
+#define SC_LBFCODE __io_address(INTEGRATOR_SC_BASE + 0x24)
 
 static int
 v3_pci_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
-- 
1.7.10

