Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab1FGBEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 21:04:42 -0400
Received: from mail.perches.com ([173.55.12.10]:2569 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab1FGBEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:04:40 -0400
Subject: [PATCH] treewide: Convert uses of struct resource * to
 resource_size(ptr)
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3820B7C78@AUSP01VMBX24.collaborationhost.net>
References: <201106061349.00474.hartleys@visionengravers.com>
	 <1307397174.4994.26.camel@Joe-Laptop>
	 <ADE657CA350FB648AAC2C43247A983F001F3820B7C78@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 18:04:38 -0700
Message-ID: <1307408678.4994.46.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done via coccinelle script:

struct resource *ptr;
@@

- ptr->end - ptr->start + 1
+ resource_size(ptr)

Mostly uncompiled, not enough cross-compilers.

Signed-off-by: Joe Perches <joe@perches.com>
---

> I think most of the offenders were caught back in late 2009.

There are quite a few left...

 arch/arm/common/scoop.c                    |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c   |    2 +-
 arch/arm/mach-u300/core.c                  |    2 +-
 arch/arm/plat-mxc/pwm.c                    |    8 ++++----
 arch/arm/plat-s5p/sysmmu.c                 |    2 +-
 arch/avr32/kernel/setup.c                  |    5 ++---
 arch/avr32/mach-at32ap/extint.c            |    2 +-
 arch/avr32/mach-at32ap/hsmc.c              |    2 +-
 arch/avr32/mach-at32ap/intc.c              |    2 +-
 arch/avr32/mach-at32ap/pio.c               |    2 +-
 arch/mips/pci/pci-vr41xx.c                 |    2 +-
 arch/powerpc/include/asm/macio.h           |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c  |    6 +++---
 arch/powerpc/sysdev/fsl_pci.c              |    4 ++--
 arch/powerpc/sysdev/ppc4xx_pci.c           |    6 +++---
 arch/sh/kernel/io_trapped.c                |    8 ++++----
 arch/sparc/kernel/ioport.c                 |   12 ++++++------
 drivers/char/hw_random/timeriomem-rng.c    |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    2 +-
 drivers/dma/at_hdmac.c                     |    4 ++--
 drivers/dma/ipu/ipu_idmac.c                |    6 ++----
 drivers/dma/mv_xor.c                       |    5 ++---
 drivers/gpio/vr41xx_giu.c                  |    2 +-
 drivers/ide/palm_bk3710.c                  |    2 +-
 drivers/ide/tx4939ide.c                    |    4 ++--
 drivers/media/video/davinci/vpif.c         |    2 +-
 drivers/media/video/omap24xxcam.c          |    5 ++---
 drivers/mfd/tc6387xb.c                     |    2 +-
 drivers/misc/atmel-ssc.c                   |    2 +-
 drivers/misc/atmel_pwm.c                   |    2 +-
 drivers/mmc/host/dw_mmc.c                  |    2 +-
 drivers/mtd/maps/bfin-async-flash.c        |    2 +-
 drivers/mtd/maps/pxa2xx-flash.c            |    2 +-
 drivers/mtd/nand/atmel_nand.c              |    4 ++--
 drivers/mtd/nand/bcm_umi_nand.c            |    2 +-
 drivers/net/bcm63xx_enet.c                 |    8 ++++----
 drivers/net/can/softing/softing_main.c     |    2 +-
 drivers/net/davinci_emac.c                 |    6 +++---
 drivers/net/ethoc.c                        |    2 +-
 drivers/net/mv643xx_eth.c                  |    2 +-
 drivers/net/pxa168_eth.c                   |    2 +-
 drivers/net/sb1250-mac.c                   |    2 +-
 drivers/parport/parport_ax88796.c          |    2 +-
 drivers/pnp/pnpacpi/rsparser.c             |   10 +++++-----
 drivers/pnp/pnpbios/rsparser.c             |   12 ++++++------
 drivers/rtc/rtc-at32ap700x.c               |    2 +-
 drivers/rtc/rtc-ds1286.c                   |    2 +-
 drivers/rtc/rtc-ds1511.c                   |    2 +-
 drivers/rtc/rtc-ds1742.c                   |    2 +-
 drivers/rtc/rtc-m48t35.c                   |    2 +-
 drivers/rtc/rtc-m48t59.c                   |    2 +-
 drivers/rtc/rtc-puv3.c                     |    5 ++---
 drivers/rtc/rtc-s3c.c                      |    5 ++---
 drivers/spi/ath79_spi.c                    |    2 +-
 drivers/spi/omap2_mcspi.c                  |   10 +++++-----
 drivers/spi/orion_spi.c                    |    6 +++---
 drivers/spi/spi_tegra.c                    |    8 ++++----
 drivers/tty/serial/imx.c                   |    5 ++---
 drivers/tty/serial/m32r_sio.c              |    2 +-
 drivers/tty/serial/omap-serial.c           |    4 ++--
 drivers/tty/serial/pxa.c                   |    2 +-
 drivers/tty/serial/sunsu.c                 |    2 +-
 drivers/tty/serial/vt8500_serial.c         |    3 +--
 drivers/uio/uio_pdrv.c                     |    2 +-
 drivers/uio/uio_pdrv_genirq.c              |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c        |    2 +-
 drivers/usb/gadget/fsl_udc_core.c          |    6 +++---
 drivers/usb/host/ehci-ath79.c              |    2 +-
 drivers/usb/host/ehci-cns3xxx.c            |    2 +-
 drivers/usb/host/ehci-fsl.c                |    2 +-
 drivers/usb/host/ehci-ixp4xx.c             |    2 +-
 drivers/usb/host/ehci-octeon.c             |    2 +-
 drivers/usb/host/ehci-pmcmsp.c             |   10 +++++-----
 drivers/usb/host/ehci-w90x900.c            |    2 +-
 drivers/usb/host/ohci-ath79.c              |    4 ++--
 drivers/usb/host/ohci-cns3xxx.c            |    2 +-
 drivers/usb/host/ohci-da8xx.c              |    2 +-
 drivers/usb/host/ohci-octeon.c             |    2 +-
 drivers/usb/host/ohci-ppc-soc.c            |    2 +-
 drivers/usb/host/ohci-sm501.c              |   11 +++++------
 drivers/usb/host/ohci-tmio.c               |    6 +++---
 drivers/usb/host/oxu210hp-hcd.c            |    2 +-
 drivers/video/atmel_lcdfb.c                |    4 ++--
 drivers/video/aty/atyfb_base.c             |    7 ++++---
 drivers/video/au1100fb.c                   |    2 +-
 drivers/video/cobalt_lcdfb.c               |    2 +-
 drivers/video/nuc900fb.c                   |    2 +-
 drivers/video/pxa168fb.c                   |    2 +-
 include/linux/pnp.h                        |    2 +-
 sound/aoa/soundbus/i2sbus/core.c           |    6 +++---
 sound/atmel/abdac.c                        |    2 +-
 sound/atmel/ac97c.c                        |    2 +-
 92 files changed, 161 insertions(+), 170 deletions(-)

diff --git a/arch/arm/common/scoop.c b/arch/arm/common/scoop.c
index c11af1e..a07b0e7 100644
--- a/arch/arm/common/scoop.c
+++ b/arch/arm/common/scoop.c
@@ -193,7 +193,7 @@ static int __devinit scoop_probe(struct platform_device *pdev)
 	spin_lock_init(&devptr->scoop_lock);
 
 	inf = pdev->dev.platform_data;
-	devptr->base = ioremap(mem->start, mem->end - mem->start + 1);
+	devptr->base = ioremap(mem->start, resource_size(mem));
 
 	if (!devptr->base) {
 		ret = -ENOMEM;
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 3eb4538..14dd6668 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -525,7 +525,7 @@ void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data)
 	if (ARRAY_SIZE(lcdc_resources) > 2) {
 		void __iomem *fb;
 		struct resource *fb_res = &lcdc_resources[2];
-		size_t fb_len = fb_res->end - fb_res->start + 1;
+		size_t fb_len = resource_size(fb_res);
 
 		fb = ioremap(fb_res->start, fb_len);
 		if (fb) {
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 513d6ab..399c89f 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1791,7 +1791,7 @@ static void __init u300_assign_physmem(void)
 				     0 == res->start) {
 				res->start  = curr_start;
 				res->end   += curr_start;
-				curr_start += (res->end - res->start + 1);
+				curr_start += resource_size(res);
 
 				printk(KERN_INFO "core.c: Mapping RAM " \
 				       "%#x-%#x to device %s:%s\n",
diff --git a/arch/arm/plat-mxc/pwm.c b/arch/arm/plat-mxc/pwm.c
index 7a61ef8..761c3c9 100644
--- a/arch/arm/plat-mxc/pwm.c
+++ b/arch/arm/plat-mxc/pwm.c
@@ -214,14 +214,14 @@ static int __devinit mxc_pwm_probe(struct platform_device *pdev)
 		goto err_free_clk;
 	}
 
-	r = request_mem_region(r->start, r->end - r->start + 1, pdev->name);
+	r = request_mem_region(r->start, resource_size(r), pdev->name);
 	if (r == NULL) {
 		dev_err(&pdev->dev, "failed to request memory resource\n");
 		ret = -EBUSY;
 		goto err_free_clk;
 	}
 
-	pwm->mmio_base = ioremap(r->start, r->end - r->start + 1);
+	pwm->mmio_base = ioremap(r->start, resource_size(r));
 	if (pwm->mmio_base == NULL) {
 		dev_err(&pdev->dev, "failed to ioremap() registers\n");
 		ret = -ENODEV;
@@ -236,7 +236,7 @@ static int __devinit mxc_pwm_probe(struct platform_device *pdev)
 	return 0;
 
 err_free_mem:
-	release_mem_region(r->start, r->end - r->start + 1);
+	release_mem_region(r->start, resource_size(r));
 err_free_clk:
 	clk_put(pwm->clk);
 err_free:
@@ -260,7 +260,7 @@ static int __devexit mxc_pwm_remove(struct platform_device *pdev)
 	iounmap(pwm->mmio_base);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, r->end - r->start + 1);
+	release_mem_region(r->start, resource_size(r));
 
 	clk_put(pwm->clk);
 
diff --git a/arch/arm/plat-s5p/sysmmu.c b/arch/arm/plat-s5p/sysmmu.c
index 54f5edd..ca180bd 100644
--- a/arch/arm/plat-s5p/sysmmu.c
+++ b/arch/arm/plat-s5p/sysmmu.c
@@ -241,7 +241,7 @@ static int s5p_sysmmu_probe(struct platform_device *pdev)
 			goto err_res;
 		}
 
-		sysmmusfrs[i] = ioremap(res->start, res->end - res->start + 1);
+		sysmmusfrs[i] = ioremap(res->start, resource_size(res));
 		if (!sysmmusfrs[i]) {
 			dev_err(dev, "Failed to ioremap() for %s.\n",
 							sysmmu_ips_name[i]);
diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
index bb0974c..086dc7c 100644
--- a/arch/avr32/kernel/setup.c
+++ b/arch/avr32/kernel/setup.c
@@ -444,7 +444,7 @@ static unsigned long __init
 find_bootmap_pfn(const struct resource *mem)
 {
 	unsigned long bootmap_pages, bootmap_len;
-	unsigned long node_pages = PFN_UP(mem->end - mem->start + 1);
+	unsigned long node_pages = PFN_UP(resource_size(mem));
 	unsigned long bootmap_start;
 
 	bootmap_pages = bootmem_bootmap_pages(node_pages);
@@ -543,8 +543,7 @@ static void __init setup_bootmem(void)
 			    && res->end < PFN_PHYS(max_pfn))
 				reserve_bootmem_node(
 					NODE_DATA(node), res->start,
-					res->end - res->start + 1,
-					BOOTMEM_DEFAULT);
+					resource_size(res), BOOTMEM_DEFAULT);
 		}
 
 		node_set_online(node);
diff --git a/arch/avr32/mach-at32ap/extint.c b/arch/avr32/mach-at32ap/extint.c
index fbc2aea..cfb298d 100644
--- a/arch/avr32/mach-at32ap/extint.c
+++ b/arch/avr32/mach-at32ap/extint.c
@@ -204,7 +204,7 @@ static int __init eic_probe(struct platform_device *pdev)
 	}
 
 	eic->first_irq = EIM_IRQ_BASE + 32 * pdev->id;
-	eic->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	eic->regs = ioremap(regs->start, resource_size(regs));
 	if (!eic->regs) {
 		dev_dbg(&pdev->dev, "failed to map regs\n");
 		goto err_ioremap;
diff --git a/arch/avr32/mach-at32ap/hsmc.c b/arch/avr32/mach-at32ap/hsmc.c
index f7672d3..f66245e 100644
--- a/arch/avr32/mach-at32ap/hsmc.c
+++ b/arch/avr32/mach-at32ap/hsmc.c
@@ -245,7 +245,7 @@ static int hsmc_probe(struct platform_device *pdev)
 
 	hsmc->pclk = pclk;
 	hsmc->mck = mck;
-	hsmc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	hsmc->regs = ioremap(regs->start, resource_size(regs));
 	if (!hsmc->regs)
 		goto out_disable_clocks;
 
diff --git a/arch/avr32/mach-at32ap/intc.c b/arch/avr32/mach-at32ap/intc.c
index 3e36461..6c70043 100644
--- a/arch/avr32/mach-at32ap/intc.c
+++ b/arch/avr32/mach-at32ap/intc.c
@@ -107,7 +107,7 @@ void __init init_IRQ(void)
 
 	clk_enable(pclk);
 
-	intc0.regs = ioremap(regs->start, regs->end - regs->start + 1);
+	intc0.regs = ioremap(regs->start, resource_size(regs));
 	if (!intc0.regs) {
 		printk(KERN_EMERG "intc: failed to map registers (0x%08lx)\n",
 		       (unsigned long)regs->start);
diff --git a/arch/avr32/mach-at32ap/pio.c b/arch/avr32/mach-at32ap/pio.c
index 2e0aa85..9b39dea 100644
--- a/arch/avr32/mach-at32ap/pio.c
+++ b/arch/avr32/mach-at32ap/pio.c
@@ -461,7 +461,7 @@ void __init at32_init_pio(struct platform_device *pdev)
 		clk_enable(pio->clk);
 
 	pio->pdev = pdev;
-	pio->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	pio->regs = ioremap(regs->start, resource_size(regs));
 
 	/* start with irqs disabled and acked */
 	pio_writel(pio, IDR, ~0UL);
diff --git a/arch/mips/pci/pci-vr41xx.c b/arch/mips/pci/pci-vr41xx.c
index 5652571..444b8d8 100644
--- a/arch/mips/pci/pci-vr41xx.c
+++ b/arch/mips/pci/pci-vr41xx.c
@@ -305,7 +305,7 @@ static int __init vr41xx_pciu_init(void)
 		struct resource *res = vr41xx_pci_controller.io_resource;
 		master = setup->master_io;
 		io_map_base = ioremap(master->bus_base_address,
-				      res->end - res->start + 1);
+				      resource_size(res));
 		if (!io_map_base)
 			return -EBUSY;
 
diff --git a/arch/powerpc/include/asm/macio.h b/arch/powerpc/include/asm/macio.h
index 7ab82c8..27af7f8 100644
--- a/arch/powerpc/include/asm/macio.h
+++ b/arch/powerpc/include/asm/macio.h
@@ -76,7 +76,7 @@ static inline unsigned long macio_resource_len(struct macio_dev *dev, int resour
 	struct resource *res = &dev->resource[resource_no];
 	if (res->start == 0 || res->end == 0 || res->end < res->start)
 		return 0;
-	return res->end - res->start + 1;
+	return resource_size(res);
 }
 
 extern int macio_enable_devres(struct macio_dev *dev);
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pci.c b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
index da110bd..33f99e3 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
@@ -264,7 +264,7 @@ mpc52xx_pci_setup(struct pci_controller *hose,
 			 (unsigned long long)res->flags);
 		out_be32(&pci_regs->iw0btar,
 		         MPC52xx_PCI_IWBTAR_TRANSLATION(res->start, res->start,
-		                  res->end - res->start + 1));
+		                  resource_size(res)));
 		iwcr0 = MPC52xx_PCI_IWCR_ENABLE | MPC52xx_PCI_IWCR_MEM;
 		if (res->flags & IORESOURCE_PREFETCH)
 			iwcr0 |= MPC52xx_PCI_IWCR_READ_MULTI;
@@ -278,7 +278,7 @@ mpc52xx_pci_setup(struct pci_controller *hose,
 		         res->start, res->end, res->flags);
 		out_be32(&pci_regs->iw1btar,
 		         MPC52xx_PCI_IWBTAR_TRANSLATION(res->start, res->start,
-		                  res->end - res->start + 1));
+		                  resource_size(res)));
 		iwcr1 = MPC52xx_PCI_IWCR_ENABLE | MPC52xx_PCI_IWCR_MEM;
 		if (res->flags & IORESOURCE_PREFETCH)
 			iwcr1 |= MPC52xx_PCI_IWCR_READ_MULTI;
@@ -300,7 +300,7 @@ mpc52xx_pci_setup(struct pci_controller *hose,
 	out_be32(&pci_regs->iw2btar,
 	         MPC52xx_PCI_IWBTAR_TRANSLATION(hose->io_base_phys,
 	                                        res->start,
-	                                        res->end - res->start + 1));
+	                                        resource_size(res)));
 	iwcr2 = MPC52xx_PCI_IWCR_ENABLE | MPC52xx_PCI_IWCR_IO;
 
 	/* Set all the IWCR fields at once; they're in the same reg */
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 68ca929..5f65180 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -64,7 +64,7 @@ static int __init setup_one_atmu(struct ccsr_pci __iomem *pci,
 {
 	resource_size_t pci_addr = res->start - offset;
 	resource_size_t phys_addr = res->start;
-	resource_size_t size = res->end - res->start + 1;
+	resource_size_t size = resource_size(res);
 	u32 flags = 0x80044000; /* enable & mem R/W */
 	unsigned int i;
 
@@ -116,7 +116,7 @@ static void __init setup_pci_atmu(struct pci_controller *hose,
 		end_idx = 3;
 	}
 
-	pci = ioremap(rsrc->start, rsrc->end - rsrc->start + 1);
+	pci = ioremap(rsrc->start, resource_size(rsrc));
 	if (!pci) {
 	    dev_err(hose->parent, "Unable to map ATMU registers\n");
 	    return;
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index 156aa7d..5300905 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -290,7 +290,7 @@ static void __init ppc4xx_configure_pci_PTMs(struct pci_controller *hose,
 					     void __iomem *reg,
 					     const struct resource *res)
 {
-	resource_size_t size = res->end - res->start + 1;
+	resource_size_t size = resource_size(res);
 	u32 sa;
 
 	/* Calculate window size */
@@ -492,7 +492,7 @@ static void __init ppc4xx_configure_pcix_PIMs(struct pci_controller *hose,
 					      int big_pim,
 					      int enable_msi_hole)
 {
-	resource_size_t size = res->end - res->start + 1;
+	resource_size_t size = resource_size(res);
 	u32 sa;
 
 	/* RAM is always at 0 */
@@ -1639,7 +1639,7 @@ static void __init ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
 					       void __iomem *mbase,
 					       struct resource *res)
 {
-	resource_size_t size = res->end - res->start + 1;
+	resource_size_t size = resource_size(res);
 	u64 sa;
 
 	if (port->endpoint) {
diff --git a/arch/sh/kernel/io_trapped.c b/arch/sh/kernel/io_trapped.c
index 32c385e..0f62f46 100644
--- a/arch/sh/kernel/io_trapped.c
+++ b/arch/sh/kernel/io_trapped.c
@@ -58,7 +58,7 @@ int register_trapped_io(struct trapped_io *tiop)
 
 	for (k = 0; k < tiop->num_resources; k++) {
 		res = tiop->resource + k;
-		len += roundup((res->end - res->start) + 1, PAGE_SIZE);
+		len += roundup(resource_size(res), PAGE_SIZE);
 		flags |= res->flags;
 	}
 
@@ -85,7 +85,7 @@ int register_trapped_io(struct trapped_io *tiop)
 		       (unsigned long)(tiop->virt_base + len),
 		       res->flags & IORESOURCE_IO ? "io" : "mmio",
 		       (unsigned long)res->start);
-		len += roundup((res->end - res->start) + 1, PAGE_SIZE);
+		len += roundup(resource_size(res), PAGE_SIZE);
 	}
 
 	tiop->magic = IO_TRAPPED_MAGIC;
@@ -128,7 +128,7 @@ void __iomem *match_trapped_io_handler(struct list_head *list,
 				return tiop->virt_base + voffs;
 			}
 
-			len = (res->end - res->start) + 1;
+			len = resource_size(res);
 			voffs += roundup(len, PAGE_SIZE);
 		}
 	}
@@ -173,7 +173,7 @@ static unsigned long lookup_address(struct trapped_io *tiop,
 
 	for (k = 0; k < tiop->num_resources; k++) {
 		res = tiop->resource + k;
-		len = roundup((res->end - res->start) + 1, PAGE_SIZE);
+		len = roundup(resource_size(res), PAGE_SIZE);
 		if (address < (vaddr + len))
 			return res->start + (address - vaddr);
 		vaddr += len;
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 92700c1..d302d78 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -229,7 +229,7 @@ _sparc_ioremap(struct resource *res, u32 bus, u32 pa, int sz)
 	}
 
 	pa &= PAGE_MASK;
-	sparc_mapiorange(bus, pa, res->start, res->end - res->start + 1);
+	sparc_mapiorange(bus, pa, res->start, resource_size(res));
 
 	return (void __iomem *)(unsigned long)(res->start + offset);
 }
@@ -241,7 +241,7 @@ static void _sparc_free_io(struct resource *res)
 {
 	unsigned long plen;
 
-	plen = res->end - res->start + 1;
+	plen = resource_size(res);
 	BUG_ON((plen & (PAGE_SIZE-1)) != 0);
 	sparc_unmapiorange(res->start, plen);
 	release_resource(res);
@@ -332,9 +332,9 @@ static void sbus_free_coherent(struct device *dev, size_t n, void *p,
 	}
 
 	n = PAGE_ALIGN(n);
-	if ((res->end-res->start)+1 != n) {
+	if (resource_size(res) != n) {
 		printk("sbus_free_consistent: region 0x%lx asked 0x%zx\n",
-		    (long)((res->end-res->start)+1), n);
+		    (long)(resource_size(res)), n);
 		return;
 	}
 
@@ -505,9 +505,9 @@ static void pci32_free_coherent(struct device *dev, size_t n, void *p,
 	}
 
 	n = PAGE_ALIGN(n);
-	if ((res->end-res->start)+1 != n) {
+	if (resource_size(res) != n) {
 		printk("pci_free_consistent: region 0x%lx asked 0x%lx\n",
-		    (long)((res->end-res->start)+1), (long)n);
+		    (long)(resource_size(res)), (long)n);
 		return;
 	}
 
diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index a94e930..c18ae2b 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -101,7 +101,7 @@ static int __devinit timeriomem_rng_probe(struct platform_device *pdev)
 	timeriomem_rng_data = pdev->dev.platform_data;
 
 	timeriomem_rng_data->address = ioremap(res->start,
-						res->end - res->start + 1);
+					       resource_size(res));
 	if (!timeriomem_rng_data->address)
 		return -EIO;
 
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 39ccdea..e90e1c7 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -621,7 +621,7 @@ static int __devinit hwicap_setup(struct device *dev, int id,
 
 	drvdata->mem_start = regs_res->start;
 	drvdata->mem_end = regs_res->end;
-	drvdata->mem_size = regs_res->end - regs_res->start + 1;
+	drvdata->mem_size = resource_size(regs_res);
 
 	if (!request_mem_region(drvdata->mem_start,
 					drvdata->mem_size, DRIVER_NAME)) {
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 36144f8..6a483ea 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1216,7 +1216,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	atdma->dma_common.cap_mask = pdata->cap_mask;
 	atdma->all_chan_mask = (1 << pdata->nr_channels) - 1;
 
-	size = io->end - io->start + 1;
+	size = resource_size(io);
 	if (!request_mem_region(io->start, size, pdev->dev.driver->name)) {
 		err = -EBUSY;
 		goto err_kfree;
@@ -1362,7 +1362,7 @@ static int __exit at_dma_remove(struct platform_device *pdev)
 	atdma->regs = NULL;
 
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(io->start, io->end - io->start + 1);
+	release_mem_region(io->start, resource_size(io));
 
 	kfree(atdma);
 
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index c1a125e..25447a8 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1705,16 +1705,14 @@ static int __init ipu_probe(struct platform_device *pdev)
 		ipu_data.irq_fn, ipu_data.irq_err, ipu_data.irq_base);
 
 	/* Remap IPU common registers */
-	ipu_data.reg_ipu = ioremap(mem_ipu->start,
-				   mem_ipu->end - mem_ipu->start + 1);
+	ipu_data.reg_ipu = ioremap(mem_ipu->start, resource_size(mem_ipu));
 	if (!ipu_data.reg_ipu) {
 		ret = -ENOMEM;
 		goto err_ioremap_ipu;
 	}
 
 	/* Remap Image Converter and Image DMA Controller registers */
-	ipu_data.reg_ic = ioremap(mem_ic->start,
-				  mem_ic->end - mem_ic->start + 1);
+	ipu_data.reg_ic = ioremap(mem_ic->start, resource_size(mem_ic));
 	if (!ipu_data.reg_ic) {
 		ret = -ENOMEM;
 		goto err_ioremap_ic;
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 954e334..06f9f27 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1304,8 +1304,7 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	msp->xor_base = devm_ioremap(&pdev->dev, res->start,
-				     res->end - res->start + 1);
+	msp->xor_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!msp->xor_base)
 		return -EBUSY;
 
@@ -1314,7 +1313,7 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	msp->xor_high_base = devm_ioremap(&pdev->dev, res->start,
-					  res->end - res->start + 1);
+					  resource_size(res));
 	if (!msp->xor_high_base)
 		return -EBUSY;
 
diff --git a/drivers/gpio/vr41xx_giu.c b/drivers/gpio/vr41xx_giu.c
index a365be0..98723cb 100644
--- a/drivers/gpio/vr41xx_giu.c
+++ b/drivers/gpio/vr41xx_giu.c
@@ -518,7 +518,7 @@ static int __devinit giu_probe(struct platform_device *pdev)
 	if (!res)
 		return -EBUSY;
 
-	giu_base = ioremap(res->start, res->end - res->start + 1);
+	giu_base = ioremap(res->start, resource_size(res));
 	if (!giu_base)
 		return -ENOMEM;
 
diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
index 9e8f4e1..712c790 100644
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -342,7 +342,7 @@ static int __init palm_bk3710_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	mem_size = mem->end - mem->start + 1;
+	mem_size = resource_size(mem);
 	if (request_mem_region(mem->start, mem_size, "palm_bk3710") == NULL) {
 		printk(KERN_ERR "failed to request memory region\n");
 		return -EBUSY;
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index bed3e39..71c2319 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -551,10 +551,10 @@ static int __init tx4939ide_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     res->end - res->start + 1, "tx4938ide"))
+				     resource_size(res), "tx4938ide"))
 		return -EBUSY;
 	mapbase = (unsigned long)devm_ioremap(&pdev->dev, res->start,
-					      res->end - res->start + 1);
+					      resource_size(res));
 	if (!mapbase)
 		return -EBUSY;
 	memset(&hw, 0, sizeof(hw));
diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
index 9f3bfc1..af96802 100644
--- a/drivers/media/video/davinci/vpif.c
+++ b/drivers/media/video/davinci/vpif.c
@@ -422,7 +422,7 @@ static int __init vpif_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENOENT;
 
-	res_len = res->end - res->start + 1;
+	res_len = resource_size(res);
 
 	res = request_mem_region(res->start, res_len, res->name);
 	if (!res)
diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index f6626e8..69b60ba 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -1768,14 +1768,13 @@ static int __devinit omap24xxcam_probe(struct platform_device *pdev)
 		dev_err(cam->dev, "no mem resource?\n");
 		goto err;
 	}
-	if (!request_mem_region(mem->start, (mem->end - mem->start) + 1,
-				pdev->name)) {
+	if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
 		dev_err(cam->dev,
 			"cannot reserve camera register I/O region\n");
 		goto err;
 	}
 	cam->mmio_base_phys = mem->start;
-	cam->mmio_size = (mem->end - mem->start) + 1;
+	cam->mmio_size = resource_size(mem);
 
 	/* map the region */
 	cam->mmio_base = (unsigned long)
diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index ad715bf..71bc835 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -177,7 +177,7 @@ static int __devinit tc6387xb_probe(struct platform_device *dev)
 	if (ret)
 		goto err_resource;
 
-	tc6387xb->scr = ioremap(rscr->start, rscr->end - rscr->start + 1);
+	tc6387xb->scr = ioremap(rscr->start, resource_size(rscr));
 	if (!tc6387xb->scr) {
 		ret = -ENOMEM;
 		goto err_ioremap;
diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 4afffe6..769a4e8 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -95,7 +95,7 @@ static int __init ssc_probe(struct platform_device *pdev)
 	}
 
 	ssc->pdev = pdev;
-	ssc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	ssc->regs = ioremap(regs->start, resource_size(regs));
 	if (!ssc->regs) {
 		dev_dbg(&pdev->dev, "ioremap failed\n");
 		retval = -EINVAL;
diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
index 0f3fb4f..28f5aaa 100644
--- a/drivers/misc/atmel_pwm.c
+++ b/drivers/misc/atmel_pwm.c
@@ -329,7 +329,7 @@ static int __init pwm_probe(struct platform_device *pdev)
 	p->pdev = pdev;
 	p->mask = *mp;
 	p->irq = irq;
-	p->base = ioremap(r->start, r->end - r->start + 1);
+	p->base = ioremap(r->start, resource_size(r));
 	if (!p->base)
 		goto fail;
 	p->clk = clk_get(&pdev->dev, "pwm_clk");
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 66dcddb..2a069f9 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1595,7 +1595,7 @@ static int dw_mci_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&host->queue);
 
 	ret = -ENOMEM;
-	host->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	host->regs = ioremap(regs->start, resource_size(regs));
 	if (!host->regs)
 		goto err_freehost;
 
diff --git a/drivers/mtd/maps/bfin-async-flash.c b/drivers/mtd/maps/bfin-async-flash.c
index d4297a9..67815ee 100644
--- a/drivers/mtd/maps/bfin-async-flash.c
+++ b/drivers/mtd/maps/bfin-async-flash.c
@@ -142,7 +142,7 @@ static int __devinit bfin_flash_probe(struct platform_device *pdev)
 	state->map.write      = bfin_flash_write;
 	state->map.copy_to    = bfin_flash_copy_to;
 	state->map.bankwidth  = pdata->width;
-	state->map.size       = memory->end - memory->start + 1;
+	state->map.size       = resource_size(memory);
 	state->map.virt       = (void __iomem *)memory->start;
 	state->map.phys       = memory->start;
 	state->map.map_priv_1 = (unsigned long)state;
diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index f59d62f..7ae137d 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -70,7 +70,7 @@ static int __devinit pxa2xx_flash_probe(struct platform_device *pdev)
 	info->map.name = (char *) flash->name;
 	info->map.bankwidth = flash->width;
 	info->map.phys = res->start;
-	info->map.size = res->end - res->start + 1;
+	info->map.size = resource_size(res);
 	info->parts = flash->parts;
 	info->nr_parts = flash->nr_parts;
 
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index b300705..d4ba1f2 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -513,7 +513,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 
 	host->io_phys = (dma_addr_t)mem->start;
 
-	host->io_base = ioremap(mem->start, mem->end - mem->start + 1);
+	host->io_base = ioremap(mem->start, resource_size(mem));
 	if (host->io_base == NULL) {
 		printk(KERN_ERR "atmel_nand: ioremap failed\n");
 		res = -EIO;
@@ -547,7 +547,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 	if (no_ecc)
 		nand_chip->ecc.mode = NAND_ECC_NONE;
 	if (hard_ecc && regs) {
-		host->ecc = ioremap(regs->start, regs->end - regs->start + 1);
+		host->ecc = ioremap(regs->start, resource_size(regs));
 		if (host->ecc == NULL) {
 			printk(KERN_ERR "atmel_nand: ioremap failed\n");
 			res = -EIO;
diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
index 9ec2807..8c569e4 100644
--- a/drivers/mtd/nand/bcm_umi_nand.c
+++ b/drivers/mtd/nand/bcm_umi_nand.c
@@ -380,7 +380,7 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
 		return -ENXIO;
 
 	/* map physical address */
-	bcm_umi_io_base = ioremap(r->start, r->end - r->start + 1);
+	bcm_umi_io_base = ioremap(r->start, resource_size(r));
 
 	if (!bcm_umi_io_base) {
 		printk(KERN_ERR "ioremap to access BCM UMI NAND chip failed\n");
diff --git a/drivers/net/bcm63xx_enet.c b/drivers/net/bcm63xx_enet.c
index f1573d4..85045cd 100644
--- a/drivers/net/bcm63xx_enet.c
+++ b/drivers/net/bcm63xx_enet.c
@@ -1646,7 +1646,7 @@ static int __devinit bcm_enet_probe(struct platform_device *pdev)
 	if (ret)
 		goto out;
 
-	iomem_size = res_mem->end - res_mem->start + 1;
+	iomem_size = resource_size(res_mem);
 	if (!request_mem_region(res_mem->start, iomem_size, "bcm63xx_enet")) {
 		ret = -EBUSY;
 		goto out;
@@ -1861,7 +1861,7 @@ static int __devexit bcm_enet_remove(struct platform_device *pdev)
 	/* release device resources */
 	iounmap(priv->base);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	/* disable hw block clocks */
 	if (priv->phy_clk) {
@@ -1897,7 +1897,7 @@ static int __devinit bcm_enet_shared_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	iomem_size = res->end - res->start + 1;
+	iomem_size = resource_size(res);
 	if (!request_mem_region(res->start, iomem_size, "bcm63xx_enet_dma"))
 		return -EBUSY;
 
@@ -1915,7 +1915,7 @@ static int __devexit bcm_enet_shared_remove(struct platform_device *pdev)
 
 	iounmap(bcm_enet_shared_base);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	return 0;
 }
 
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index 60a49e5..f76e88e 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -799,7 +799,7 @@ static __devinit int softing_pdev_probe(struct platform_device *pdev)
 	if (!pres)
 		goto platform_resource_failed;
 	card->dpram_phys = pres->start;
-	card->dpram_size = pres->end - pres->start + 1;
+	card->dpram_size = resource_size(pres);
 	card->dpram = ioremap_nocache(card->dpram_phys, card->dpram_size);
 	if (!card->dpram) {
 		dev_alert(&card->pdev->dev, "dpram ioremap failed\n");
diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
index dcc4a17..c35ba5f 100644
--- a/drivers/net/davinci_emac.c
+++ b/drivers/net/davinci_emac.c
@@ -1821,7 +1821,7 @@ static int __devinit davinci_emac_probe(struct platform_device *pdev)
 	}
 
 	priv->emac_base_phys = res->start + pdata->ctrl_reg_offset;
-	size = res->end - res->start + 1;
+	size = resource_size(res);
 	if (!request_mem_region(res->start, size, ndev->name)) {
 		dev_err(&pdev->dev, "failed request_mem_region() for regs\n");
 		rc = -ENXIO;
@@ -1926,7 +1926,7 @@ no_irq_res:
 	cpdma_ctlr_destroy(priv->dma);
 no_dma:
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	iounmap(priv->remap_addr);
 
 probe_quit:
@@ -1960,7 +1960,7 @@ static int __devexit davinci_emac_remove(struct platform_device *pdev)
 		cpdma_chan_destroy(priv->rxchan);
 	cpdma_ctlr_destroy(priv->dma);
 
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	unregister_netdev(ndev);
 	iounmap(priv->remap_addr);
diff --git a/drivers/net/ethoc.c b/drivers/net/ethoc.c
index a83dd31..15e4a71 100644
--- a/drivers/net/ethoc.c
+++ b/drivers/net/ethoc.c
@@ -965,7 +965,7 @@ static int __devinit ethoc_probe(struct platform_device *pdev)
 	priv = netdev_priv(netdev);
 	priv->netdev = netdev;
 	priv->dma_alloc = 0;
-	priv->io_region_size = mmio->end - mmio->start + 1;
+	priv->io_region_size = resource_size(mmio);
 
 	priv->iobase = devm_ioremap_nocache(&pdev->dev, netdev->base_addr,
 			resource_size(mmio));
diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index a5d9b1c..b756482 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -2593,7 +2593,7 @@ static int mv643xx_eth_shared_probe(struct platform_device *pdev)
 	if (msp == NULL)
 		goto out;
 
-	msp->base = ioremap(res->start, res->end - res->start + 1);
+	msp->base = ioremap(res->start, resource_size(res));
 	if (msp->base == NULL)
 		goto out_free;
 
diff --git a/drivers/net/pxa168_eth.c b/drivers/net/pxa168_eth.c
index 89f7540..df1292e 100644
--- a/drivers/net/pxa168_eth.c
+++ b/drivers/net/pxa168_eth.c
@@ -1502,7 +1502,7 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 		err = -ENODEV;
 		goto err_netdev;
 	}
-	pep->base = ioremap(res->start, res->end - res->start + 1);
+	pep->base = ioremap(res->start, resource_size(res));
 	if (pep->base == NULL) {
 		err = -ENOMEM;
 		goto err_netdev;
diff --git a/drivers/net/sb1250-mac.c b/drivers/net/sb1250-mac.c
index 68d5042..ea65f7e 100644
--- a/drivers/net/sb1250-mac.c
+++ b/drivers/net/sb1250-mac.c
@@ -2597,7 +2597,7 @@ static int __devinit sbmac_probe(struct platform_device *pldev)
 
 	res = platform_get_resource(pldev, IORESOURCE_MEM, 0);
 	BUG_ON(!res);
-	sbm_base = ioremap_nocache(res->start, res->end - res->start + 1);
+	sbm_base = ioremap_nocache(res->start, resource_size(res));
 	if (!sbm_base) {
 		printk(KERN_ERR "%s: unable to map device registers\n",
 		       dev_name(&pldev->dev));
diff --git a/drivers/parport/parport_ax88796.c b/drivers/parport/parport_ax88796.c
index 2c5ac2b..844f613 100644
--- a/drivers/parport/parport_ax88796.c
+++ b/drivers/parport/parport_ax88796.c
@@ -293,7 +293,7 @@ static int parport_ax88796_probe(struct platform_device *pdev)
 		goto exit_mem;
 	}
 
-	size = (res->end - res->start) + 1;
+	size = resource_size(res);
 	spacing = size / 3;
 
 	dd->io = request_mem_region(res->start, size, pdev->name);
diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 100e4d9..1a6937d9 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -1018,7 +1018,7 @@ static void pnpacpi_encode_io(struct pnp_dev *dev,
 		io->minimum = p->start;
 		io->maximum = p->end;
 		io->alignment = 0;	/* Correct? */
-		io->address_length = p->end - p->start + 1;
+		io->address_length = resource_size(p);
 	} else {
 		io->minimum = 0;
 		io->address_length = 0;
@@ -1036,7 +1036,7 @@ static void pnpacpi_encode_fixed_io(struct pnp_dev *dev,
 
 	if (pnp_resource_enabled(p)) {
 		fixed_io->address = p->start;
-		fixed_io->address_length = p->end - p->start + 1;
+		fixed_io->address_length = resource_size(p);
 	} else {
 		fixed_io->address = 0;
 		fixed_io->address_length = 0;
@@ -1059,7 +1059,7 @@ static void pnpacpi_encode_mem24(struct pnp_dev *dev,
 		memory24->minimum = p->start;
 		memory24->maximum = p->end;
 		memory24->alignment = 0;
-		memory24->address_length = p->end - p->start + 1;
+		memory24->address_length = resource_size(p);
 	} else {
 		memory24->minimum = 0;
 		memory24->address_length = 0;
@@ -1083,7 +1083,7 @@ static void pnpacpi_encode_mem32(struct pnp_dev *dev,
 		memory32->minimum = p->start;
 		memory32->maximum = p->end;
 		memory32->alignment = 0;
-		memory32->address_length = p->end - p->start + 1;
+		memory32->address_length = resource_size(p);
 	} else {
 		memory32->minimum = 0;
 		memory32->alignment = 0;
@@ -1106,7 +1106,7 @@ static void pnpacpi_encode_fixed_mem32(struct pnp_dev *dev,
 		    p->flags & IORESOURCE_MEM_WRITEABLE ?
 		    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
 		fixed_memory32->address = p->start;
-		fixed_memory32->address_length = p->end - p->start + 1;
+		fixed_memory32->address_length = resource_size(p);
 	} else {
 		fixed_memory32->address = 0;
 		fixed_memory32->address_length = 0;
diff --git a/drivers/pnp/pnpbios/rsparser.c b/drivers/pnp/pnpbios/rsparser.c
index cb1f47b..cca2f9f 100644
--- a/drivers/pnp/pnpbios/rsparser.c
+++ b/drivers/pnp/pnpbios/rsparser.c
@@ -505,7 +505,7 @@ static void pnpbios_encode_mem(struct pnp_dev *dev, unsigned char *p,
 
 	if (pnp_resource_enabled(res)) {
 		base = res->start;
-		len = res->end - res->start + 1;
+		len = resource_size(res);
 	} else {
 		base = 0;
 		len = 0;
@@ -529,7 +529,7 @@ static void pnpbios_encode_mem32(struct pnp_dev *dev, unsigned char *p,
 
 	if (pnp_resource_enabled(res)) {
 		base = res->start;
-		len = res->end - res->start + 1;
+		len = resource_size(res);
 	} else {
 		base = 0;
 		len = 0;
@@ -559,7 +559,7 @@ static void pnpbios_encode_fixed_mem32(struct pnp_dev *dev, unsigned char *p,
 
 	if (pnp_resource_enabled(res)) {
 		base = res->start;
-		len = res->end - res->start + 1;
+		len = resource_size(res);
 	} else {
 		base = 0;
 		len = 0;
@@ -617,7 +617,7 @@ static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
 
 	if (pnp_resource_enabled(res)) {
 		base = res->start;
-		len = res->end - res->start + 1;
+		len = resource_size(res);
 	} else {
 		base = 0;
 		len = 0;
@@ -636,11 +636,11 @@ static void pnpbios_encode_fixed_port(struct pnp_dev *dev, unsigned char *p,
 				      struct resource *res)
 {
 	unsigned long base = res->start;
-	unsigned long len = res->end - res->start + 1;
+	unsigned long len = resource_size(res);
 
 	if (pnp_resource_enabled(res)) {
 		base = res->start;
-		len = res->end - res->start + 1;
+		len = resource_size(res);
 	} else {
 		base = 0;
 		len = 0;
diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index e725d51..8dd0830 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -223,7 +223,7 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 	}
 
 	rtc->irq = irq;
-	rtc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	rtc->regs = ioremap(regs->start, resource_size(regs));
 	if (!rtc->regs) {
 		ret = -ENOMEM;
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
diff --git a/drivers/rtc/rtc-ds1286.c b/drivers/rtc/rtc-ds1286.c
index 47e681d..68e6caf 100644
--- a/drivers/rtc/rtc-ds1286.c
+++ b/drivers/rtc/rtc-ds1286.c
@@ -343,7 +343,7 @@ static int __devinit ds1286_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->size = res->end - res->start + 1;
+	priv->size = resource_size(res);
 	if (!request_mem_region(res->start, priv->size, pdev->name)) {
 		ret = -EBUSY;
 		goto out;
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index fbabc77..568ad30 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -490,7 +490,7 @@ ds1511_rtc_probe(struct platform_device *pdev)
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->size = res->end - res->start + 1;
+	pdata->size = resource_size(res);
 	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
 			pdev->name))
 		return -EBUSY;
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 042630c..d84a448d 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -173,7 +173,7 @@ static int __devinit ds1742_rtc_probe(struct platform_device *pdev)
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->size = res->end - res->start + 1;
+	pdata->size = resource_size(res);
 	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
 		pdev->name))
 		return -EBUSY;
diff --git a/drivers/rtc/rtc-m48t35.c b/drivers/rtc/rtc-m48t35.c
index 7410875..8e2a24e 100644
--- a/drivers/rtc/rtc-m48t35.c
+++ b/drivers/rtc/rtc-m48t35.c
@@ -154,7 +154,7 @@ static int __devinit m48t35_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->size = res->end - res->start + 1;
+	priv->size = resource_size(res);
 	/*
 	 * kludge: remove the #ifndef after ioc3 resource
 	 * conflicts are resolved
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 3978f4c..2836538 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -433,7 +433,7 @@ static int __devinit m48t59_rtc_probe(struct platform_device *pdev)
 
 	if (!m48t59->ioaddr) {
 		/* ioaddr not mapped externally */
-		m48t59->ioaddr = ioremap(res->start, res->end - res->start + 1);
+		m48t59->ioaddr = ioremap(res->start, resource_size(res));
 		if (!m48t59->ioaddr)
 			goto out;
 	}
diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index 46f14b8..b3eba3c 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -267,9 +267,8 @@ static int puv3_rtc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	puv3_rtc_mem = request_mem_region(res->start,
-					 res->end-res->start+1,
-					 pdev->name);
+	puv3_rtc_mem = request_mem_region(res->start, resource_size(res),
+					  pdev->name);
 
 	if (puv3_rtc_mem == NULL) {
 		dev_err(&pdev->dev, "failed to reserve memory region\n");
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 16512ec..2a65e85 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -455,8 +455,7 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	s3c_rtc_mem = request_mem_region(res->start,
-					 res->end-res->start+1,
+	s3c_rtc_mem = request_mem_region(res->start, resource_size(res),
 					 pdev->name);
 
 	if (s3c_rtc_mem == NULL) {
@@ -465,7 +464,7 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 		goto err_nores;
 	}
 
-	s3c_rtc_base = ioremap(res->start, res->end - res->start + 1);
+	s3c_rtc_base = ioremap(res->start, resource_size(res));
 	if (s3c_rtc_base == NULL) {
 		dev_err(&pdev->dev, "failed ioremap()\n");
 		ret = -EINVAL;
diff --git a/drivers/spi/ath79_spi.c b/drivers/spi/ath79_spi.c
index fcff810..03019bf 100644
--- a/drivers/spi/ath79_spi.c
+++ b/drivers/spi/ath79_spi.c
@@ -232,7 +232,7 @@ static __devinit int ath79_spi_probe(struct platform_device *pdev)
 		goto err_put_master;
 	}
 
-	sp->base = ioremap(r->start, r->end - r->start + 1);
+	sp->base = ioremap(r->start, resource_size(r));
 	if (!sp->base) {
 		ret = -ENXIO;
 		goto err_put_master;
diff --git a/drivers/spi/omap2_mcspi.c b/drivers/spi/omap2_mcspi.c
index 969cdd2..fde3a2d 100644
--- a/drivers/spi/omap2_mcspi.c
+++ b/drivers/spi/omap2_mcspi.c
@@ -1116,8 +1116,8 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 		status = -ENODEV;
 		goto err1;
 	}
-	if (!request_mem_region(r->start, (r->end - r->start) + 1,
-			dev_name(&pdev->dev))) {
+	if (!request_mem_region(r->start, resource_size(r),
+				dev_name(&pdev->dev))) {
 		status = -EBUSY;
 		goto err1;
 	}
@@ -1125,7 +1125,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 	r->start += pdata->regs_offset;
 	r->end += pdata->regs_offset;
 	mcspi->phys = r->start;
-	mcspi->base = ioremap(r->start, r->end - r->start + 1);
+	mcspi->base = ioremap(r->start, resource_size(r));
 	if (!mcspi->base) {
 		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
 		status = -ENOMEM;
@@ -1190,7 +1190,7 @@ err4:
 err3:
 	kfree(mcspi->dma_channels);
 err2:
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 	iounmap(mcspi->base);
 err1:
 	return status;
@@ -1210,7 +1210,7 @@ static int __exit omap2_mcspi_remove(struct platform_device *pdev)
 
 	omap2_mcspi_disable_clocks(mcspi);
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 
 	base = mcspi->base;
 	spi_unregister_master(master);
diff --git a/drivers/spi/orion_spi.c b/drivers/spi/orion_spi.c
index 0b677dc..afa2b76 100644
--- a/drivers/spi/orion_spi.c
+++ b/drivers/spi/orion_spi.c
@@ -489,7 +489,7 @@ static int __init orion_spi_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	if (!request_mem_region(r->start, (r->end - r->start) + 1,
+	if (!request_mem_region(r->start, resource_size(r),
 				dev_name(&pdev->dev))) {
 		status = -EBUSY;
 		goto out;
@@ -511,7 +511,7 @@ static int __init orion_spi_probe(struct platform_device *pdev)
 	return status;
 
 out_rel_mem:
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 
 out:
 	spi_master_put(master);
@@ -531,7 +531,7 @@ static int __exit orion_spi_remove(struct platform_device *pdev)
 	cancel_work_sync(&spi->work);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 
 	spi_unregister_master(master);
 
diff --git a/drivers/spi/spi_tegra.c b/drivers/spi/spi_tegra.c
index 6c3aa6e..8e30727 100644
--- a/drivers/spi/spi_tegra.c
+++ b/drivers/spi/spi_tegra.c
@@ -498,14 +498,14 @@ static int __init spi_tegra_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	if (!request_mem_region(r->start, (r->end - r->start) + 1,
+	if (!request_mem_region(r->start, resource_size(r),
 				dev_name(&pdev->dev))) {
 		ret = -EBUSY;
 		goto err0;
 	}
 
 	tspi->phys = r->start;
-	tspi->base = ioremap(r->start, r->end - r->start + 1);
+	tspi->base = ioremap(r->start, resource_size(r));
 	if (!tspi->base) {
 		dev_err(&pdev->dev, "can't ioremap iomem\n");
 		ret = -ENOMEM;
@@ -563,7 +563,7 @@ err3:
 err2:
 	iounmap(tspi->base);
 err1:
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 err0:
 	spi_master_put(master);
 	return ret;
@@ -588,7 +588,7 @@ static int __devexit spi_tegra_remove(struct platform_device *pdev)
 	iounmap(tspi->base);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, (r->end - r->start) + 1);
+	release_mem_region(r->start, resource_size(r));
 
 	return 0;
 }
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index a544731..22fe801 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -954,7 +954,7 @@ static void imx_release_port(struct uart_port *port)
 	struct resource *mmres;
 
 	mmres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mmres->start, mmres->end - mmres->start + 1);
+	release_mem_region(mmres->start, resource_size(mmres));
 }
 
 /*
@@ -970,8 +970,7 @@ static int imx_request_port(struct uart_port *port)
 	if (!mmres)
 		return -ENODEV;
 
-	ret = request_mem_region(mmres->start, mmres->end - mmres->start + 1,
-			"imx-uart");
+	ret = request_mem_region(mmres->start, resource_size(mmres), "imx-uart");
 
 	return  ret ? 0 : -EBUSY;
 }
diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
index 84db732..8e07517 100644
--- a/drivers/tty/serial/m32r_sio.c
+++ b/drivers/tty/serial/m32r_sio.c
@@ -892,7 +892,7 @@ static int m32r_sio_request_port(struct uart_port *port)
 	 * If we have a mapbase, then request that as well.
 	 */
 	if (ret == 0 && up->port.flags & UPF_IOREMAP) {
-		int size = res->end - res->start + 1;
+		int size = resource_size(res);
 
 		up->port.membase = ioremap(up->port.mapbase, size);
 		if (!up->port.membase)
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 47cadf4..f194d6c 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1241,7 +1241,7 @@ static int serial_omap_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (!request_mem_region(mem->start, (mem->end - mem->start) + 1,
+	if (!request_mem_region(mem->start, resource_size(mem),
 				     pdev->dev.driver->name)) {
 		dev_err(&pdev->dev, "memory region already claimed\n");
 		return -EBUSY;
@@ -1308,7 +1308,7 @@ err:
 	dev_err(&pdev->dev, "[UART%d]: failure [%s]: %d\n",
 				pdev->id, __func__, ret);
 do_release_region:
-	release_mem_region(mem->start, (mem->end - mem->start) + 1);
+	release_mem_region(mem->start, resource_size(mem));
 	return ret;
 }
 
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index 4302e6e..531931c 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -803,7 +803,7 @@ static int serial_pxa_probe(struct platform_device *dev)
 		break;
 	}
 
-	sport->port.membase = ioremap(mmres->start, mmres->end - mmres->start + 1);
+	sport->port.membase = ioremap(mmres->start, resource_size(mmres));
 	if (!sport->port.membase) {
 		ret = -ENOMEM;
 		goto err_clk;
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 92aa545..ad0f8f5 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -1435,7 +1435,7 @@ static int __devinit su_probe(struct platform_device *op)
 
 	rp = &op->resource[0];
 	up->port.mapbase = rp->start;
-	up->reg_size = (rp->end - rp->start) + 1;
+	up->reg_size = resource_size(rp);
 	up->port.membase = of_ioremap(rp, 0, up->reg_size, "su");
 	if (!up->port.membase) {
 		if (type != SU_PORT_PORT)
diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 37fc4e3..026cb9e 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -573,8 +573,7 @@ static int __init vt8500_serial_probe(struct platform_device *pdev)
 	snprintf(vt8500_port->name, sizeof(vt8500_port->name),
 		 "VT8500 UART%d", pdev->id);
 
-	vt8500_port->uart.membase = ioremap(mmres->start,
-					    mmres->end - mmres->start + 1);
+	vt8500_port->uart.membase = ioremap(mmres->start, resource_size(mmres));
 	if (!vt8500_port->uart.membase) {
 		ret = -ENOMEM;
 		goto err;
diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
index 7d3e469..bdc3db9 100644
--- a/drivers/uio/uio_pdrv.c
+++ b/drivers/uio/uio_pdrv.c
@@ -58,7 +58,7 @@ static int uio_pdrv_probe(struct platform_device *pdev)
 
 		uiomem->memtype = UIO_MEM_PHYS;
 		uiomem->addr = r->start;
-		uiomem->size = r->end - r->start + 1;
+		uiomem->size = resource_size(r);
 		++uiomem;
 	}
 
diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 0f424af..31e799d 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -137,7 +137,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 
 		uiomem->memtype = UIO_MEM_PHYS;
 		uiomem->addr = r->start;
-		uiomem->size = r->end - r->start + 1;
+		uiomem->size = resource_size(r);
 		++uiomem;
 	}
 
diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index db1a659..f045c89 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -272,7 +272,7 @@ static void usba_init_debugfs(struct usba_udc *udc)
 
 	regs_resource = platform_get_resource(udc->pdev, IORESOURCE_MEM,
 				CTRL_IOMEM_ID);
-	regs->d_inode->i_size = regs_resource->end - regs_resource->start + 1;
+	regs->d_inode->i_size = resource_size(regs_resource);
 	udc->debugfs_regs = regs;
 
 	usba_ep_init_debugfs(udc, to_usba_ep(udc->gadget.ep0));
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 2cd9a60..9c8e56f 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2445,7 +2445,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->operating_mode == FSL_USB2_DR_DEVICE) {
-		if (!request_mem_region(res->start, res->end - res->start + 1,
+		if (!request_mem_region(res->start, resource_size(res),
 					driver_name)) {
 			ERR("request mem region for %s failed\n", pdev->name);
 			ret = -EBUSY;
@@ -2593,7 +2593,7 @@ err_iounmap_noclk:
 	iounmap(dr_regs);
 err_release_mem_region:
 	if (pdata->operating_mode == FSL_USB2_DR_DEVICE)
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 err_kfree:
 	kfree(udc_controller);
 	udc_controller = NULL;
@@ -2628,7 +2628,7 @@ static int __exit fsl_udc_remove(struct platform_device *pdev)
 	free_irq(udc_controller->irq, udc_controller);
 	iounmap(dr_regs);
 	if (pdata->operating_mode == FSL_USB2_DR_DEVICE)
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 
 	device_unregister(&udc_controller->gadget.dev);
 	/* free udc --wait for the release() finished */
diff --git a/drivers/usb/host/ehci-ath79.c b/drivers/usb/host/ehci-ath79.c
index 98cc8a1..eab3d70 100644
--- a/drivers/usb/host/ehci-ath79.c
+++ b/drivers/usb/host/ehci-ath79.c
@@ -146,7 +146,7 @@ static int ehci_ath79_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	hcd->rsrc_start	= res->start;
-	hcd->rsrc_len	= res->end - res->start + 1;
+	hcd->rsrc_len	= resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		dev_dbg(&pdev->dev, "controller already in use\n");
diff --git a/drivers/usb/host/ehci-cns3xxx.c b/drivers/usb/host/ehci-cns3xxx.c
index d41745c..6536abd 100644
--- a/drivers/usb/host/ehci-cns3xxx.c
+++ b/drivers/usb/host/ehci-cns3xxx.c
@@ -107,7 +107,7 @@ static int cns3xxx_ehci_probe(struct platform_device *pdev)
 	}
 
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
 				driver->description)) {
diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index f380bf9..34a3140 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -100,7 +100,7 @@ static int usb_hcd_fsl_probe(const struct hc_driver *driver,
 		goto err2;
 	}
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
 				driver->description)) {
 		dev_dbg(&pdev->dev, "controller already in use\n");
diff --git a/drivers/usb/host/ehci-ixp4xx.c b/drivers/usb/host/ehci-ixp4xx.c
index 50e600d..c4460f3 100644
--- a/drivers/usb/host/ehci-ixp4xx.c
+++ b/drivers/usb/host/ehci-ixp4xx.c
@@ -100,7 +100,7 @@ static int ixp4xx_ehci_probe(struct platform_device *pdev)
 		goto fail_request_resource;
 	}
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
 				driver->description)) {
diff --git a/drivers/usb/host/ehci-octeon.c b/drivers/usb/host/ehci-octeon.c
index ff55757..c3ba3ed 100644
--- a/drivers/usb/host/ehci-octeon.c
+++ b/drivers/usb/host/ehci-octeon.c
@@ -124,7 +124,7 @@ static int ehci_octeon_drv_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	hcd->rsrc_start = res_mem->start;
-	hcd->rsrc_len = res_mem->end - res_mem->start + 1;
+	hcd->rsrc_len = resource_size(res_mem);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
 				OCTEON_EHCI_HCD_NAME)) {
diff --git a/drivers/usb/host/ehci-pmcmsp.c b/drivers/usb/host/ehci-pmcmsp.c
index cd69099..e8d54de 100644
--- a/drivers/usb/host/ehci-pmcmsp.c
+++ b/drivers/usb/host/ehci-pmcmsp.c
@@ -124,7 +124,7 @@ static int usb_hcd_msp_map_regs(struct mspusb_device *dev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res == NULL)
 		return -ENOMEM;
-	res_len = res->end - res->start + 1;
+	res_len = resource_size(res);
 	if (!request_mem_region(res->start, res_len, "mab regs"))
 		return -EBUSY;
 
@@ -140,7 +140,7 @@ static int usb_hcd_msp_map_regs(struct mspusb_device *dev)
 		retval = -ENOMEM;
 		goto err2;
 	}
-	res_len = res->end - res->start + 1;
+	res_len = resource_size(res);
 	if (!request_mem_region(res->start, res_len, "usbid regs")) {
 		retval = -EBUSY;
 		goto err2;
@@ -154,13 +154,13 @@ static int usb_hcd_msp_map_regs(struct mspusb_device *dev)
 	return 0;
 err3:
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-	res_len = res->end - res->start + 1;
+	res_len = resource_size(res);
 	release_mem_region(res->start, res_len);
 err2:
 	iounmap(dev->mab_regs);
 err1:
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	res_len = res->end - res->start + 1;
+	res_len = resource_size(res);
 	release_mem_region(res->start, res_len);
 	dev_err(&pdev->dev, "Failed to map non-EHCI regs.\n");
 	return retval;
@@ -194,7 +194,7 @@ int usb_hcd_msp_probe(const struct hc_driver *driver,
 		goto err1;
 	}
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, dev->name)) {
 		retval = -EBUSY;
 		goto err1;
diff --git a/drivers/usb/host/ehci-w90x900.c b/drivers/usb/host/ehci-w90x900.c
index 52a027a..d661cf7 100644
--- a/drivers/usb/host/ehci-w90x900.c
+++ b/drivers/usb/host/ehci-w90x900.c
@@ -41,7 +41,7 @@ static int __devinit usb_w90x900_probe(const struct hc_driver *driver,
 	}
 
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		retval = -EBUSY;
diff --git a/drivers/usb/host/ohci-ath79.c b/drivers/usb/host/ohci-ath79.c
index ffea3e7..c620c50 100644
--- a/drivers/usb/host/ohci-ath79.c
+++ b/drivers/usb/host/ohci-ath79.c
@@ -93,8 +93,8 @@ static int ohci_ath79_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto err_put_hcd;
 	}
-	hcd->rsrc_start	= res->start;
-	hcd->rsrc_len	= res->end - res->start + 1;
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		dev_dbg(&pdev->dev, "controller already in use\n");
diff --git a/drivers/usb/host/ohci-cns3xxx.c b/drivers/usb/host/ohci-cns3xxx.c
index f05ef87..5a00a1e 100644
--- a/drivers/usb/host/ohci-cns3xxx.c
+++ b/drivers/usb/host/ohci-cns3xxx.c
@@ -100,7 +100,7 @@ static int cns3xxx_ohci_probe(struct platform_device *pdev)
 		goto err1;
 	}
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
 			driver->description)) {
diff --git a/drivers/usb/host/ohci-da8xx.c b/drivers/usb/host/ohci-da8xx.c
index d22fb4d..6aca2c4 100644
--- a/drivers/usb/host/ohci-da8xx.c
+++ b/drivers/usb/host/ohci-da8xx.c
@@ -322,7 +322,7 @@ static int usb_hcd_da8xx_probe(const struct hc_driver *driver,
 		goto err2;
 	}
 	hcd->rsrc_start = mem->start;
-	hcd->rsrc_len = mem->end - mem->start + 1;
+	hcd->rsrc_len = resource_size(mem);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		dev_dbg(&pdev->dev, "request_mem_region failed\n");
diff --git a/drivers/usb/host/ohci-octeon.c b/drivers/usb/host/ohci-octeon.c
index e4ddfaf..d8b4564 100644
--- a/drivers/usb/host/ohci-octeon.c
+++ b/drivers/usb/host/ohci-octeon.c
@@ -135,7 +135,7 @@ static int ohci_octeon_drv_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	hcd->rsrc_start = res_mem->start;
-	hcd->rsrc_len = res_mem->end - res_mem->start + 1;
+	hcd->rsrc_len = resource_size(res_mem);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
 				OCTEON_OHCI_HCD_NAME)) {
diff --git a/drivers/usb/host/ohci-ppc-soc.c b/drivers/usb/host/ohci-ppc-soc.c
index 89e670e..c0f595c 100644
--- a/drivers/usb/host/ohci-ppc-soc.c
+++ b/drivers/usb/host/ohci-ppc-soc.c
@@ -56,7 +56,7 @@ static int usb_hcd_ppc_soc_probe(const struct hc_driver *driver,
 	if (!hcd)
 		return -ENOMEM;
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		pr_debug("%s: request_mem_region failed\n", __FILE__);
diff --git a/drivers/usb/host/ohci-sm501.c b/drivers/usb/host/ohci-sm501.c
index 041d30f..78918ca 100644
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -103,8 +103,7 @@ static int ohci_hcd_sm501_drv_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	if (!request_mem_region(mem->start, mem->end - mem->start + 1,
-				pdev->name)) {
+	if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
 		dev_err(dev, "request_mem_region failed\n");
 		retval = -EBUSY;
 		goto err0;
@@ -126,7 +125,7 @@ static int ohci_hcd_sm501_drv_probe(struct platform_device *pdev)
 
 	if (!dma_declare_coherent_memory(dev, mem->start,
 					 mem->start - mem->parent->start,
-					 (mem->end - mem->start) + 1,
+					 resource_size(mem),
 					 DMA_MEMORY_MAP |
 					 DMA_MEMORY_EXCLUSIVE)) {
 		dev_err(dev, "cannot declare coherent memory\n");
@@ -149,7 +148,7 @@ static int ohci_hcd_sm501_drv_probe(struct platform_device *pdev)
 	}
 
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,	pdev->name)) {
 		dev_err(dev, "request_mem_region failed\n");
@@ -185,7 +184,7 @@ err3:
 err2:
 	dma_release_declared_memory(dev);
 err1:
-	release_mem_region(mem->start, mem->end - mem->start + 1);
+	release_mem_region(mem->start, resource_size(mem));
 err0:
 	return retval;
 }
@@ -201,7 +200,7 @@ static int ohci_hcd_sm501_drv_remove(struct platform_device *pdev)
 	dma_release_declared_memory(&pdev->dev);
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (mem)
-		release_mem_region(mem->start, mem->end - mem->start + 1);
+		release_mem_region(mem->start, resource_size(mem));
 
 	/* mask interrupts and disable power */
 
diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index 3558491..57ad127 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -208,13 +208,13 @@ static int __devinit ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 	}
 
 	hcd->rsrc_start = regs->start;
-	hcd->rsrc_len = regs->end - regs->start + 1;
+	hcd->rsrc_len = resource_size(regs);
 
 	tmio = hcd_to_tmio(hcd);
 
 	spin_lock_init(&tmio->lock);
 
-	tmio->ccr = ioremap(config->start, config->end - config->start + 1);
+	tmio->ccr = ioremap(config->start, resource_size(config));
 	if (!tmio->ccr) {
 		ret = -ENOMEM;
 		goto err_ioremap_ccr;
@@ -228,7 +228,7 @@ static int __devinit ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 
 	if (!dma_declare_coherent_memory(&dev->dev, sram->start,
 				sram->start,
-				sram->end - sram->start + 1,
+				resource_size(sram),
 				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE)) {
 		ret = -EBUSY;
 		goto err_dma_declare;
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 5fbe997..dcd8898 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3828,7 +3828,7 @@ static int oxu_drv_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 	memstart = res->start;
-	memlen = res->end - res->start + 1;
+	memlen = resource_size(res);
 	dev_dbg(&pdev->dev, "MEM resource %lx-%lx\n", memstart, memlen);
 	if (!request_mem_region(memstart, memlen,
 				oxu_hc_driver.description)) {
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 4484c72..817ab60 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -906,7 +906,7 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 	if (map) {
 		/* use a pre-allocated memory buffer */
 		info->fix.smem_start = map->start;
-		info->fix.smem_len = map->end - map->start + 1;
+		info->fix.smem_len = resource_size(map);
 		if (!request_mem_region(info->fix.smem_start,
 					info->fix.smem_len, pdev->name)) {
 			ret = -EBUSY;
@@ -932,7 +932,7 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 
 	/* LCDC registers */
 	info->fix.mmio_start = regs->start;
-	info->fix.mmio_len = regs->end - regs->start + 1;
+	info->fix.mmio_len = resource_size(regs);
 
 	if (!request_mem_region(info->fix.mmio_start,
 				info->fix.mmio_len, pdev->name)) {
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index ebb893c..ad41f50 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -3460,9 +3460,10 @@ static int __devinit atyfb_setup_generic(struct pci_dev *pdev,
 
 	raddr = addr + 0x7ff000UL;
 	rrp = &pdev->resource[2];
-	if ((rrp->flags & IORESOURCE_MEM) && request_mem_region(rrp->start, rrp->end - rrp->start + 1, "atyfb")) {
+	if ((rrp->flags & IORESOURCE_MEM) &&
+	    request_mem_region(rrp->start, resource_size(rrp), "atyfb")) {
 		par->aux_start = rrp->start;
-		par->aux_size = rrp->end - rrp->start + 1;
+		par->aux_size = resource_size(rrp);
 		raddr = rrp->start;
 		PRINTKI("using auxiliary register aperture\n");
 	}
@@ -3552,7 +3553,7 @@ static int __devinit atyfb_pci_probe(struct pci_dev *pdev,
 
 	/* Reserve space */
 	res_start = rp->start;
-	res_size = rp->end - rp->start + 1;
+	res_size = resource_size(rp);
 	if (!request_mem_region(res_start, res_size, "atyfb"))
 		return -EBUSY;
 
diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index 34b2fc47..01a8fde 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -486,7 +486,7 @@ static int __devinit au1100fb_drv_probe(struct platform_device *dev)
 	}
 
 	au1100fb_fix.mmio_start = regs_res->start;
-	au1100fb_fix.mmio_len = regs_res->end - regs_res->start + 1;
+	au1100fb_fix.mmio_len = resource_size(regs_res);
 
 	if (!request_mem_region(au1100fb_fix.mmio_start, au1100fb_fix.mmio_len,
 				DRIVER_NAME)) {
diff --git a/drivers/video/cobalt_lcdfb.c b/drivers/video/cobalt_lcdfb.c
index 42fe155..e027643 100644
--- a/drivers/video/cobalt_lcdfb.c
+++ b/drivers/video/cobalt_lcdfb.c
@@ -303,7 +303,7 @@ static int __devinit cobalt_lcdfb_probe(struct platform_device *dev)
 		return -EBUSY;
 	}
 
-	info->screen_size = res->end - res->start + 1;
+	info->screen_size = resource_size(res);
 	info->screen_base = ioremap(res->start, info->screen_size);
 	info->fbops = &cobalt_lcd_fbops;
 	info->fix = cobalt_lcdfb_fix;
diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index f838d9e..0fff5978 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -551,7 +551,7 @@ static int __devinit nuc900fb_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	size = (res->end - res->start) + 1;
+	size = resource_size(res);
 	fbi->mem = request_mem_region(res->start, size, pdev->name);
 	if (fbi->mem == NULL) {
 		dev_err(&pdev->dev, "failed to alloc memory region\n");
diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
index bb95ec5..18ead6f 100644
--- a/drivers/video/pxa168fb.c
+++ b/drivers/video/pxa168fb.c
@@ -662,7 +662,7 @@ static int __devinit pxa168fb_probe(struct platform_device *pdev)
 	info->fix.ypanstep = 0;
 	info->fix.ywrapstep = 0;
 	info->fix.mmio_start = res->start;
-	info->fix.mmio_len = res->end - res->start + 1;
+	info->fix.mmio_len = resource_size(res);
 	info->fix.accel = FB_ACCEL_NONE;
 	info->fbops = &pxa168fb_ops;
 	info->pseudo_palette = fbi->pseudo_palette;
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 1bc1338..195aafc 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -50,7 +50,7 @@ static inline resource_size_t pnp_resource_len(struct resource *res)
 {
 	if (res->start == 0 && res->end == 0)
 		return 0;
-	return res->end - res->start + 1;
+	return resource_size(res);
 }
 
 
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 3ff8cc5..8bd132a 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -272,19 +272,19 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 	}
 
 	r = &dev->resources[aoa_resource_i2smmio];
-	rlen = r->end - r->start + 1;
+	rlen = resource_size(r);
 	if (rlen < sizeof(struct i2s_interface_regs))
 		goto err;
 	dev->intfregs = ioremap(r->start, rlen);
 
 	r = &dev->resources[aoa_resource_txdbdma];
-	rlen = r->end - r->start + 1;
+	rlen = resource_size(r);
 	if (rlen < sizeof(struct dbdma_regs))
 		goto err;
 	dev->out.dbdma = ioremap(r->start, rlen);
 
 	r = &dev->resources[aoa_resource_rxdbdma];
-	rlen = r->end - r->start + 1;
+	rlen = resource_size(r);
 	if (rlen < sizeof(struct dbdma_regs))
 		goto err;
 	dev->in.dbdma = ioremap(r->start, rlen);
diff --git a/sound/atmel/abdac.c b/sound/atmel/abdac.c
index 6e24091..30468b3 100644
--- a/sound/atmel/abdac.c
+++ b/sound/atmel/abdac.c
@@ -448,7 +448,7 @@ static int __devinit atmel_abdac_probe(struct platform_device *pdev)
 		goto out_free_card;
 	}
 
-	dac->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	dac->regs = ioremap(regs->start, resource_size(regs));
 	if (!dac->regs) {
 		dev_dbg(&pdev->dev, "could not remap register memory\n");
 		goto out_free_card;
diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index b310702..41b901b 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -971,7 +971,7 @@ static int __devinit atmel_ac97c_probe(struct platform_device *pdev)
 	chip->card = card;
 	chip->pclk = pclk;
 	chip->pdev = pdev;
-	chip->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	chip->regs = ioremap(regs->start, resource_size(regs));
 
 	if (!chip->regs) {
 		dev_dbg(&pdev->dev, "could not remap register memory\n");
-- 
1.7.6.rc0



