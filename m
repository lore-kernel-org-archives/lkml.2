Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1FGV3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:29:53 -0400
Received: from mail.perches.com ([173.55.12.10]:2603 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756937Ab1FGV3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:29:48 -0400
Subject: [TRIVIAL PATCH v2] treewide: Convert uses of struct resource to
 resource_size(ptr)
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3820B7EB4@AUSP01VMBX24.collaborationhost.net>
References: <201106061349.00474.hartleys@visionengravers.com>
	 <1307397174.4994.26.camel@Joe-Laptop>
	 <ADE657CA350FB648AAC2C43247A983F001F3820B7C78@AUSP01VMBX24.collaborationhost.net>
	 <1307408678.4994.46.camel@Joe-Laptop>
	 <ADE657CA350FB648AAC2C43247A983F001F3820B7EB4@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 14:29:46 -0700
Message-ID: <1307482186.22272.29.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several fixes as well where the +1 was missing.

Done via coccinelle scripts like:

@@
struct resource *ptr;
@@

- ptr->end - ptr->start + 1
+ resource_size(ptr)

and some grep and typing.

Mostly uncompiled, no cross-compilers.

Some checkpatch complaints cheerfully ignored.

Signed-off-by: Joe Perches <joe@perches.com>

---

On Tue, 2011-06-07 at 13:27 -0500, H Hartley Sweeten wrote:
> FWIW, your patch missed a couple...

This _should_ be all of them.

 arch/arm/common/scoop.c                        |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c       |    2 +-
 arch/arm/mach-mv78xx0/pcie.c                   |    8 ++++----
 arch/arm/mach-u300/core.c                      |    2 +-
 arch/arm/plat-mxc/pwm.c                        |    8 ++++----
 arch/arm/plat-s5p/sysmmu.c                     |    6 +++---
 arch/arm/plat-samsung/pm-check.c               |    2 +-
 arch/avr32/kernel/setup.c                      |   10 +++++-----
 arch/avr32/mach-at32ap/extint.c                |    2 +-
 arch/avr32/mach-at32ap/hsmc.c                  |    2 +-
 arch/avr32/mach-at32ap/intc.c                  |    2 +-
 arch/avr32/mach-at32ap/pio.c                   |    2 +-
 arch/microblaze/pci/pci-common.c               |    2 +-
 arch/mips/pci/pci-rc32434.c                    |    2 +-
 arch/mips/pci/pci-vr41xx.c                     |    2 +-
 arch/mips/powertv/asic/asic_devices.c          |   10 ++++------
 arch/powerpc/include/asm/macio.h               |    2 +-
 arch/powerpc/kernel/machine_kexec.c            |    4 ++--
 arch/powerpc/kernel/pci-common.c               |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c      |    8 ++++----
 arch/powerpc/platforms/83xx/km83xx.c           |    2 +-
 arch/powerpc/platforms/83xx/mpc832x_mds.c      |    2 +-
 arch/powerpc/platforms/83xx/mpc834x_mds.c      |    2 +-
 arch/powerpc/platforms/83xx/mpc836x_mds.c      |    2 +-
 arch/powerpc/platforms/83xx/usb.c              |    2 +-
 arch/powerpc/platforms/85xx/sbc8560.c          |    2 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c      |    2 +-
 arch/powerpc/platforms/cell/celleb_scc_epci.c  |    8 ++++----
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |    2 +-
 arch/powerpc/platforms/cell/spu_manage.c       |    2 +-
 arch/powerpc/platforms/chrp/pci.c              |    2 +-
 arch/powerpc/platforms/pasemi/dma_lib.c        |    2 +-
 arch/powerpc/platforms/powermac/nvram.c        |    4 ++--
 arch/powerpc/platforms/powermac/pci.c          |    6 ++----
 arch/powerpc/platforms/powermac/time.c         |    2 +-
 arch/powerpc/sysdev/axonram.c                  |    2 +-
 arch/powerpc/sysdev/cpm1.c                     |    2 +-
 arch/powerpc/sysdev/cpm_common.c               |    2 +-
 arch/powerpc/sysdev/dart_iommu.c               |    2 +-
 arch/powerpc/sysdev/fsl_msi.c                  |    2 +-
 arch/powerpc/sysdev/fsl_pci.c                  |   12 ++++++------
 arch/powerpc/sysdev/fsl_rio.c                  |    2 +-
 arch/powerpc/sysdev/ipic.c                     |    2 +-
 arch/powerpc/sysdev/mmio_nvram.c               |    2 +-
 arch/powerpc/sysdev/mpc8xx_pic.c               |    2 +-
 arch/powerpc/sysdev/mv64x60_udbg.c             |    4 ++--
 arch/powerpc/sysdev/ppc4xx_pci.c               |   16 ++++++++--------
 arch/powerpc/sysdev/qe_lib/qe_ic.c             |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_io.c             |    2 +-
 arch/powerpc/sysdev/xics/icp-native.c          |    2 +-
 arch/sh/kernel/io_trapped.c                    |    8 ++++----
 arch/sh/kernel/machine_kexec.c                 |    2 +-
 arch/sparc/kernel/ioport.c                     |   12 ++++++------
 arch/sparc/kernel/pci.c                        |    6 ++----
 arch/tile/kernel/setup.c                       |    3 +--
 arch/x86/kernel/pci-calgary_64.c               |    2 +-
 arch/x86/kernel/probe_roms.c                   |    2 +-
 drivers/char/bsr.c                             |    2 +-
 drivers/char/hw_random/timeriomem-rng.c        |    3 +--
 drivers/char/xilinx_hwicap/xilinx_hwicap.c     |    2 +-
 drivers/dma/mv_xor.c                           |    5 ++---
 drivers/edac/cell_edac.c                       |    2 +-
 drivers/edac/mpc85xx_edac.c                    |   12 ++++++------
 drivers/gpio/gpio-u300.c                       |    8 ++++----
 drivers/gpio/gpio-vr41xx.c                     |    2 +-
 drivers/ide/palm_bk3710.c                      |    2 +-
 drivers/ide/tx4939ide.c                        |    4 ++--
 drivers/input/serio/sa1111ps2.c                |    6 ++----
 drivers/media/video/davinci/vpif.c             |    2 +-
 drivers/media/video/omap24xxcam.c              |    5 ++---
 drivers/message/i2o/iop.c                      |    8 ++++----
 drivers/mfd/tc6387xb.c                         |    2 +-
 drivers/misc/atmel-ssc.c                       |    2 +-
 drivers/misc/atmel_pwm.c                       |    2 +-
 drivers/mmc/host/dw_mmc.c                      |    2 +-
 drivers/mtd/maps/bfin-async-flash.c            |    2 +-
 drivers/mtd/maps/ixp2000.c                     |   11 ++++++-----
 drivers/mtd/maps/pxa2xx-flash.c                |    2 +-
 drivers/mtd/nand/atmel_nand.c                  |    4 ++--
 drivers/mtd/nand/bcm_umi_nand.c                |    2 +-
 drivers/mtd/nand/mpc5121_nfc.c                 |    2 +-
 drivers/net/bcm63xx_enet.c                     |    8 ++++----
 drivers/net/can/softing/softing_main.c         |    2 +-
 drivers/net/davinci_emac.c                     |    6 +++---
 drivers/net/ethoc.c                            |    2 +-
 drivers/net/fec_mpc52xx.c                      |    7 ++++---
 drivers/net/fs_enet/mii-bitbang.c              |    4 ++--
 drivers/net/fs_enet/mii-fec.c                  |    2 +-
 drivers/net/gianfar_ptp.c                      |    2 +-
 drivers/net/ibm_newemac/core.c                 |    2 +-
 drivers/net/macb.c                             |    2 +-
 drivers/net/mv643xx_eth.c                      |    2 +-
 drivers/net/pxa168_eth.c                       |    2 +-
 drivers/net/sb1250-mac.c                       |    2 +-
 drivers/of/address.c                           |    2 +-
 drivers/parport/parport_ax88796.c              |    2 +-
 drivers/pci/hotplug/shpchp_sysfs.c             |   21 +++++++++------------
 drivers/pcmcia/at91_cf.c                       |    7 +++----
 drivers/pcmcia/electra_cf.c                    |    4 ++--
 drivers/pcmcia/rsrc_iodyn.c                    |    6 +++---
 drivers/pcmcia/rsrc_nonstatic.c                |    6 +++---
 drivers/pnp/pnpacpi/rsparser.c                 |   10 +++++-----
 drivers/pnp/pnpbios/rsparser.c                 |   12 ++++++------
 drivers/rtc/rtc-at32ap700x.c                   |    2 +-
 drivers/rtc/rtc-cmos.c                         |    6 +++---
 drivers/rtc/rtc-ds1286.c                       |    2 +-
 drivers/rtc/rtc-ds1511.c                       |    2 +-
 drivers/rtc/rtc-ds1742.c                       |    2 +-
 drivers/rtc/rtc-m48t35.c                       |    2 +-
 drivers/rtc/rtc-m48t59.c                       |    2 +-
 drivers/rtc/rtc-mrst.c                         |    5 ++---
 drivers/rtc/rtc-puv3.c                         |    5 ++---
 drivers/rtc/rtc-s3c.c                          |    5 ++---
 drivers/spi/ath79_spi.c                        |    2 +-
 drivers/spi/omap2_mcspi.c                      |   10 +++++-----
 drivers/spi/orion_spi.c                        |    6 +++---
 drivers/spi/spi_ppc4xx.c                       |    2 +-
 drivers/spi/spi_tegra.c                        |    8 ++++----
 drivers/staging/generic_serial/ser_a2232.c     |    3 ++-
 drivers/staging/gma500/psb_gtt.c               |    8 ++++----
 drivers/tty/serial/bfin_5xx.c                  |    5 ++---
 drivers/tty/serial/imx.c                       |    5 ++---
 drivers/tty/serial/m32r_sio.c                  |    2 +-
 drivers/tty/serial/omap-serial.c               |    6 +++---
 drivers/tty/serial/pxa.c                       |    2 +-
 drivers/tty/serial/sunsu.c                     |    2 +-
 drivers/tty/serial/vt8500_serial.c             |    3 +--
 drivers/uio/uio_pdrv.c                         |    2 +-
 drivers/uio/uio_pdrv_genirq.c                  |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c            |    2 +-
 drivers/usb/gadget/fsl_udc_core.c              |    6 +++---
 drivers/usb/host/ehci-ath79.c                  |    2 +-
 drivers/usb/host/ehci-cns3xxx.c                |    2 +-
 drivers/usb/host/ehci-fsl.c                    |    2 +-
 drivers/usb/host/ehci-grlib.c                  |    2 +-
 drivers/usb/host/ehci-ixp4xx.c                 |    2 +-
 drivers/usb/host/ehci-octeon.c                 |    2 +-
 drivers/usb/host/ehci-pmcmsp.c                 |   10 +++++-----
 drivers/usb/host/ehci-ppc-of.c                 |    2 +-
 drivers/usb/host/ehci-w90x900.c                |    2 +-
 drivers/usb/host/ehci-xilinx-of.c              |    2 +-
 drivers/usb/host/fhci-hcd.c                    |    2 +-
 drivers/usb/host/ohci-ath79.c                  |    4 ++--
 drivers/usb/host/ohci-cns3xxx.c                |    2 +-
 drivers/usb/host/ohci-da8xx.c                  |    2 +-
 drivers/usb/host/ohci-octeon.c                 |    2 +-
 drivers/usb/host/ohci-ppc-of.c                 |    2 +-
 drivers/usb/host/ohci-ppc-soc.c                |    2 +-
 drivers/usb/host/ohci-sa1111.c                 |    2 +-
 drivers/usb/host/ohci-sm501.c                  |   11 +++++------
 drivers/usb/host/ohci-tmio.c                   |    6 +++---
 drivers/usb/host/oxu210hp-hcd.c                |    2 +-
 drivers/usb/host/uhci-grlib.c                  |    2 +-
 drivers/usb/host/whci/init.c                   |    2 +-
 drivers/uwb/whc-rc.c                           |    2 +-
 drivers/video/atmel_lcdfb.c                    |    4 ++--
 drivers/video/aty/atyfb_base.c                 |    7 ++++---
 drivers/video/au1100fb.c                       |    2 +-
 drivers/video/cobalt_lcdfb.c                   |    2 +-
 drivers/video/controlfb.c                      |    4 ++--
 drivers/video/mb862xx/mb862xxfbdrv.c           |    4 ++--
 drivers/video/msm/mdp.c                        |    3 +--
 drivers/video/msm/msm_fb.c                     |    7 +++----
 drivers/video/nuc900fb.c                       |    2 +-
 drivers/video/platinumfb.c                     |    5 ++---
 drivers/video/pxa168fb.c                       |    2 +-
 include/linux/dio.h                            |    2 +-
 include/linux/pnp.h                            |    2 +-
 include/linux/zorro.h                          |    2 +-
 kernel/kexec.c                                 |    2 +-
 sound/aoa/soundbus/i2sbus/core.c               |    9 ++++-----
 sound/atmel/abdac.c                            |    2 +-
 sound/atmel/ac97c.c                            |    2 +-
 sound/ppc/pmac.c                               |    9 +++------
 sound/soc/fsl/fsl_ssi.c                        |    2 +-
 sound/soc/fsl/mpc5200_dma.c                    |    2 +-
 176 files changed, 325 insertions(+), 351 deletions(-)

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
diff --git a/arch/arm/mach-mv78xx0/pcie.c b/arch/arm/mach-mv78xx0/pcie.c
index a560439..f27c7d2 100644
--- a/arch/arm/mach-mv78xx0/pcie.c
+++ b/arch/arm/mach-mv78xx0/pcie.c
@@ -129,12 +129,12 @@ static void __init mv78xx0_pcie_preinit(void)
 		struct pcie_port *pp = pcie_port + i;
 
 		mv78xx0_setup_pcie_io_win(win++, pp->res[0].start,
-			pp->res[0].end - pp->res[0].start + 1,
-			pp->maj, pp->min);
+					  resource_size(&pp->res[0]),
+					  pp->maj, pp->min);
 
 		mv78xx0_setup_pcie_mem_win(win++, pp->res[1].start,
-			pp->res[1].end - pp->res[1].start + 1,
-			pp->maj, pp->min);
+					   resource_size(&pp->res[1]),
+					   pp->maj, pp->min);
 	}
 }
 
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
index 54f5edd..e1cbc72 100644
--- a/arch/arm/plat-s5p/sysmmu.c
+++ b/arch/arm/plat-s5p/sysmmu.c
@@ -232,8 +232,8 @@ static int s5p_sysmmu_probe(struct platform_device *pdev)
 			goto err_res;
 		}
 
-		mem = request_mem_region(res->start,
-				((res->end) - (res->start)) + 1, pdev->name);
+		mem = request_mem_region(res->start, resource_size(res),
+					 pdev->name);
 		if (!mem) {
 			dev_err(dev, "Failed to request the memory region of %s.\n",
 							sysmmu_ips_name[i]);
@@ -241,7 +241,7 @@ static int s5p_sysmmu_probe(struct platform_device *pdev)
 			goto err_res;
 		}
 
-		sysmmusfrs[i] = ioremap(res->start, res->end - res->start + 1);
+		sysmmusfrs[i] = ioremap(res->start, resource_size(res));
 		if (!sysmmusfrs[i]) {
 			dev_err(dev, "Failed to ioremap() for %s.\n",
 							sysmmu_ips_name[i]);
diff --git a/arch/arm/plat-samsung/pm-check.c b/arch/arm/plat-samsung/pm-check.c
index 6b733fa..3cbd626 100644
--- a/arch/arm/plat-samsung/pm-check.c
+++ b/arch/arm/plat-samsung/pm-check.c
@@ -72,7 +72,7 @@ static void s3c_pm_run_sysram(run_fn_t fn, u32 *arg)
 
 static u32 *s3c_pm_countram(struct resource *res, u32 *val)
 {
-	u32 size = (u32)(res->end - res->start)+1;
+	u32 size = (u32)resource_size(res);
 
 	size += CHECK_CHUNKSIZE-1;
 	size /= CHECK_CHUNKSIZE;
diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
index bb0974c..b4247f4 100644
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
@@ -541,10 +541,10 @@ static void __init setup_bootmem(void)
 			 */
 			if (res->start >= PFN_PHYS(first_pfn)
 			    && res->end < PFN_PHYS(max_pfn))
-				reserve_bootmem_node(
-					NODE_DATA(node), res->start,
-					res->end - res->start + 1,
-					BOOTMEM_DEFAULT);
+				reserve_bootmem_node(NODE_DATA(node),
+						     res->start,
+						     resource_size(res),
+						     BOOTMEM_DEFAULT);
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
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 5359906..dd3fae0 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -89,7 +89,7 @@ void pcibios_free_controller(struct pci_controller *phb)
 
 static resource_size_t pcibios_io_size(const struct pci_controller *hose)
 {
-	return hose->io_resource.end - hose->io_resource.start + 1;
+	return resource_size(&hose->io_resource);
 }
 
 int pcibios_vaddr_is_ioport(void __iomem *address)
diff --git a/arch/mips/pci/pci-rc32434.c b/arch/mips/pci/pci-rc32434.c
index f31218e..764362c 100644
--- a/arch/mips/pci/pci-rc32434.c
+++ b/arch/mips/pci/pci-rc32434.c
@@ -215,7 +215,7 @@ static int __init rc32434_pci_init(void)
 	rc32434_pcibridge_init();
 
 	io_map_base = ioremap(rc32434_res_pci_io1.start,
-		rc32434_res_pci_io1.end - rc32434_res_pci_io1.start + 1);
+			      resource_size(&rcrc32434_res_pci_io1));
 
 	if (!io_map_base)
 		return -ENOMEM;
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
 
diff --git a/arch/mips/powertv/asic/asic_devices.c b/arch/mips/powertv/asic/asic_devices.c
index e56fa61..bce1872 100644
--- a/arch/mips/powertv/asic/asic_devices.c
+++ b/arch/mips/powertv/asic/asic_devices.c
@@ -394,23 +394,21 @@ void __init platform_alloc_bootmem(void)
 
 	/* Loop through looking for resources that want a particular address */
 	for (i = 0; gp_resources[i].flags != 0; i++) {
-		int size = gp_resources[i].end - gp_resources[i].start + 1;
+		int size = resource_size(&gp_resources[i]);
 		if ((gp_resources[i].start != 0) &&
 			((gp_resources[i].flags & IORESOURCE_MEM) != 0)) {
 			reserve_bootmem(dma_to_phys(gp_resources[i].start),
 				size, 0);
-			total += gp_resources[i].end -
-				gp_resources[i].start + 1;
+			total += resource_size(&gp_resources[i]);
 			pr_info("reserve resource %s at %08x (%u bytes)\n",
 				gp_resources[i].name, gp_resources[i].start,
-				gp_resources[i].end -
-					gp_resources[i].start + 1);
+				resource_size(&gp_resources[i]));
 		}
 	}
 
 	/* Loop through assigning addresses for those that are left */
 	for (i = 0; gp_resources[i].flags != 0; i++) {
-		int size = gp_resources[i].end - gp_resources[i].start + 1;
+		int size = resource_size(&gp_resources[i]);
 		if ((gp_resources[i].start == 0) &&
 			((gp_resources[i].flags & IORESOURCE_MEM) != 0)) {
 			void *mem = alloc_bootmem_pages(size);
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
diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index 7ee50f0..6658a15 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -126,7 +126,7 @@ void __init reserve_crashkernel(void)
 	/* We might have got these values via the command line or the
 	 * device tree, either way sanitise them now. */
 
-	crash_size = crashk_res.end - crashk_res.start + 1;
+	crash_size = resource_size(&crashk_res);
 
 #ifndef CONFIG_RELOCATABLE
 	if (crashk_res.start != KDUMP_KERNELBASE)
@@ -222,7 +222,7 @@ static void __init export_crashk_values(struct device_node *node)
 
 	if (crashk_res.start != 0) {
 		prom_add_property(node, &crashk_base_prop);
-		crashk_size = crashk_res.end - crashk_res.start + 1;
+		crashk_size = resource_size(&crashk_res);
 		prom_add_property(node, &crashk_size_prop);
 	}
 }
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 893af2a..3764e37 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -107,7 +107,7 @@ static resource_size_t pcibios_io_size(const struct pci_controller *hose)
 #ifdef CONFIG_PPC64
 	return hose->pci_io_size;
 #else
-	return hose->io_resource.end - hose->io_resource.start + 1;
+	return resource_size(&hose->io_resource);
 #endif
 }
 
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pci.c b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
index da110bd..5f5e693 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
@@ -264,7 +264,7 @@ mpc52xx_pci_setup(struct pci_controller *hose,
 			 (unsigned long long)res->flags);
 		out_be32(&pci_regs->iw0btar,
 		         MPC52xx_PCI_IWBTAR_TRANSLATION(res->start, res->start,
-		                  res->end - res->start + 1));
+							resource_size(res)));
 		iwcr0 = MPC52xx_PCI_IWCR_ENABLE | MPC52xx_PCI_IWCR_MEM;
 		if (res->flags & IORESOURCE_PREFETCH)
 			iwcr0 |= MPC52xx_PCI_IWCR_READ_MULTI;
@@ -278,7 +278,7 @@ mpc52xx_pci_setup(struct pci_controller *hose,
 		         res->start, res->end, res->flags);
 		out_be32(&pci_regs->iw1btar,
 		         MPC52xx_PCI_IWBTAR_TRANSLATION(res->start, res->start,
-		                  res->end - res->start + 1));
+							resource_size(res)));
 		iwcr1 = MPC52xx_PCI_IWCR_ENABLE | MPC52xx_PCI_IWCR_MEM;
 		if (res->flags & IORESOURCE_PREFETCH)
 			iwcr1 |= MPC52xx_PCI_IWCR_READ_MULTI;
@@ -300,7 +300,7 @@ mpc52xx_pci_setup(struct pci_controller *hose,
 	out_be32(&pci_regs->iw2btar,
 	         MPC52xx_PCI_IWBTAR_TRANSLATION(hose->io_base_phys,
 	                                        res->start,
-	                                        res->end - res->start + 1));
+						resource_size(res)));
 	iwcr2 = MPC52xx_PCI_IWCR_ENABLE | MPC52xx_PCI_IWCR_IO;
 
 	/* Set all the IWCR fields at once; they're in the same reg */
@@ -402,7 +402,7 @@ mpc52xx_add_bridge(struct device_node *node)
 
 	hose->ops = &mpc52xx_pci_ops;
 
-	pci_regs = ioremap(rsrc.start, rsrc.end - rsrc.start + 1);
+	pci_regs = ioremap(rsrc.start, resource_size(&rsrc));
 	if (!pci_regs)
 		return -ENOMEM;
 
diff --git a/arch/powerpc/platforms/83xx/km83xx.c b/arch/powerpc/platforms/83xx/km83xx.c
index a2b9b9e..f8fa2fc 100644
--- a/arch/powerpc/platforms/83xx/km83xx.c
+++ b/arch/powerpc/platforms/83xx/km83xx.c
@@ -101,7 +101,7 @@ static void __init mpc83xx_km_setup_arch(void)
 					__func__);
 				return;
 			}
-			base = ioremap(res.start, res.end - res.start + 1);
+			base = ioremap(res.start, resource_size(&res));
 
 			/*
 			 * IMMR + 0x14A8[4:5] = 11 (clk delay for UCC 2)
diff --git a/arch/powerpc/platforms/83xx/mpc832x_mds.c b/arch/powerpc/platforms/83xx/mpc832x_mds.c
index ec0b401b..93e60f1 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
@@ -68,7 +68,7 @@ static void __init mpc832x_sys_setup_arch(void)
 		struct resource res;
 
 		of_address_to_resource(np, 0, &res);
-		bcsr_regs = ioremap(res.start, res.end - res.start +1);
+		bcsr_regs = ioremap(res.start, resource_size(&res));
 		of_node_put(np);
 	}
 
diff --git a/arch/powerpc/platforms/83xx/mpc834x_mds.c b/arch/powerpc/platforms/83xx/mpc834x_mds.c
index d0a634b..c1b1dc5 100644
--- a/arch/powerpc/platforms/83xx/mpc834x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc834x_mds.c
@@ -53,7 +53,7 @@ static int mpc834xemds_usb_cfg(void)
 		struct resource res;
 
 		of_address_to_resource(np, 0, &res);
-		bcsr_regs = ioremap(res.start, res.end - res.start + 1);
+		bcsr_regs = ioremap(res.start, resource_size(&res));
 		of_node_put(np);
 	}
 	if (!bcsr_regs)
diff --git a/arch/powerpc/platforms/83xx/mpc836x_mds.c b/arch/powerpc/platforms/83xx/mpc836x_mds.c
index 09e9d6f..81c052b 100644
--- a/arch/powerpc/platforms/83xx/mpc836x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc836x_mds.c
@@ -76,7 +76,7 @@ static void __init mpc836x_mds_setup_arch(void)
 		struct resource res;
 
 		of_address_to_resource(np, 0, &res);
-		bcsr_regs = ioremap(res.start, res.end - res.start +1);
+		bcsr_regs = ioremap(res.start, resource_size(&res));
 		of_node_put(np);
 	}
 
diff --git a/arch/powerpc/platforms/83xx/usb.c b/arch/powerpc/platforms/83xx/usb.c
index 2c64164..1ad748b 100644
--- a/arch/powerpc/platforms/83xx/usb.c
+++ b/arch/powerpc/platforms/83xx/usb.c
@@ -171,7 +171,7 @@ int mpc831x_usb_cfg(void)
 		of_node_put(np);
 		return ret;
 	}
-	usb_regs = ioremap(res.start, res.end - res.start + 1);
+	usb_regs = ioremap(res.start, resource_size(&res));
 
 	/* Using on-chip PHY */
 	if (prop && (!strcmp(prop, "utmi_wide") ||
diff --git a/arch/powerpc/platforms/85xx/sbc8560.c b/arch/powerpc/platforms/85xx/sbc8560.c
index d2dfd46..09ced72 100644
--- a/arch/powerpc/platforms/85xx/sbc8560.c
+++ b/arch/powerpc/platforms/85xx/sbc8560.c
@@ -285,7 +285,7 @@ static int __init sbc8560_bdrstcr_init(void)
 
 	printk(KERN_INFO "sbc8560: Found BRSTCR at i/o 0x%x\n", res.start);
 
-	brstcr = ioremap(res.start, res.end - res.start);
+	brstcr = ioremap(res.start, resource_size(&res));
 	if(!brstcr)
 		printk(KERN_WARNING "sbc8560: ioremap of brstcr failed.\n");
 
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index 0125604..a9dc5e7 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -123,7 +123,7 @@ static void xes_mpc85xx_fixups(void)
 			continue;
 		}
 
-		l2_base = ioremap(r[0].start, r[0].end - r[0].start + 1);
+		l2_base = ioremap(r[0].start, resource_size(&r[0]));
 
 		xes_mpc85xx_configure_l2(l2_base);
 	}
diff --git a/arch/powerpc/platforms/cell/celleb_scc_epci.c b/arch/powerpc/platforms/cell/celleb_scc_epci.c
index 05b0db3..844c0fa 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_epci.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_epci.c
@@ -393,19 +393,19 @@ static int __init celleb_setup_epci(struct device_node *node,
 
 	if (of_address_to_resource(node, 0, &r))
 		goto error;
-	hose->cfg_addr = ioremap(r.start, (r.end - r.start + 1));
+	hose->cfg_addr = ioremap(r.start, resource_size(&r));
 	if (!hose->cfg_addr)
 		goto error;
 	pr_debug("EPCI: cfg_addr map 0x%016llx->0x%016lx + 0x%016llx\n",
-		 r.start, (unsigned long)hose->cfg_addr, (r.end - r.start + 1));
+		 r.start, (unsigned long)hose->cfg_addr, resource_size(&r));
 
 	if (of_address_to_resource(node, 2, &r))
 		goto error;
-	hose->cfg_data = ioremap(r.start, (r.end - r.start + 1));
+	hose->cfg_data = ioremap(r.start, resource_size(&r));
 	if (!hose->cfg_data)
 		goto error;
 	pr_debug("EPCI: cfg_data map 0x%016llx->0x%016lx + 0x%016llx\n",
-		 r.start, (unsigned long)hose->cfg_data, (r.end - r.start + 1));
+		 r.start, (unsigned long)hose->cfg_data, resource_size(&r));
 
 	hose->ops = &celleb_epci_ops;
 	celleb_epci_init(hose);
diff --git a/arch/powerpc/platforms/cell/celleb_scc_pciex.c b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
index a881bbe..ae790ac 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_pciex.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
@@ -494,7 +494,7 @@ static __init int celleb_setup_pciex(struct device_node *node,
 		pr_err("PCIEXC:Failed to get config resource.\n");
 		return 1;
 	}
-	phb->cfg_addr = ioremap(r.start, r.end - r.start + 1);
+	phb->cfg_addr = ioremap(r.start, resource_size(&r));
 	if (!phb->cfg_addr) {
 		pr_err("PCIEXC:Failed to remap SMMIO region.\n");
 		return 1;
diff --git a/arch/powerpc/platforms/cell/spu_manage.c b/arch/powerpc/platforms/cell/spu_manage.c
index f465d47..4e5c914 100644
--- a/arch/powerpc/platforms/cell/spu_manage.c
+++ b/arch/powerpc/platforms/cell/spu_manage.c
@@ -222,7 +222,7 @@ static int spu_map_resource(struct spu *spu, int nr,
 		return ret;
 	if (phys)
 		*phys = resource.start;
-	len = resource.end - resource.start + 1;
+	len = resource_size(&resource);
 	*virt = ioremap(resource.start, len);
 	if (!*virt)
 		return -EINVAL;
diff --git a/arch/powerpc/platforms/chrp/pci.c b/arch/powerpc/platforms/chrp/pci.c
index 8f67a39..3f65443 100644
--- a/arch/powerpc/platforms/chrp/pci.c
+++ b/arch/powerpc/platforms/chrp/pci.c
@@ -142,7 +142,7 @@ hydra_init(void)
 		return 0;
 	}
 	of_node_put(np);
-	Hydra = ioremap(r.start, r.end-r.start);
+	Hydra = ioremap(r.start, resource_size(&r));
 	printk("Hydra Mac I/O at %llx\n", (unsigned long long)r.start);
 	printk("Hydra Feature_Control was %x",
 	       in_le32(&Hydra->Feature_Control));
diff --git a/arch/powerpc/platforms/pasemi/dma_lib.c b/arch/powerpc/platforms/pasemi/dma_lib.c
index 321a9b3..756123b 100644
--- a/arch/powerpc/platforms/pasemi/dma_lib.c
+++ b/arch/powerpc/platforms/pasemi/dma_lib.c
@@ -576,7 +576,7 @@ int pasemi_dma_init(void)
 		res.start = 0xfd800000;
 		res.end = res.start + 0x1000;
 	}
-	dma_status = __ioremap(res.start, res.end-res.start, 0);
+	dma_status = __ioremap(res.start, resource_size(&res), 0);
 	pci_dev_put(iob_pdev);
 
 	for (i = 0; i < MAX_TXCH; i++)
diff --git a/arch/powerpc/platforms/powermac/nvram.c b/arch/powerpc/platforms/powermac/nvram.c
index b1cdcf9..695443b 100644
--- a/arch/powerpc/platforms/powermac/nvram.c
+++ b/arch/powerpc/platforms/powermac/nvram.c
@@ -580,10 +580,10 @@ int __init pmac_nvram_init(void)
 	/* Try to obtain an address */
 	if (of_address_to_resource(dp, 0, &r1) == 0) {
 		nvram_naddrs = 1;
-		s1 = (r1.end - r1.start) + 1;
+		s1 = resource_size(&r1);
 		if (of_address_to_resource(dp, 1, &r2) == 0) {
 			nvram_naddrs = 2;
-			s2 = (r2.end - r2.start) + 1;
+			s2 = resource_size(&r2);
 		}
 	}
 
diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
index f33e08d..4d4eba3 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -838,8 +838,7 @@ static void __init setup_u3_ht(struct pci_controller* hose)
 	 * into cfg_addr
 	 */
 	hose->cfg_data = ioremap(cfg_res.start, 0x02000000);
-	hose->cfg_addr = ioremap(self_res.start,
-				 self_res.end - self_res.start + 1);
+	hose->cfg_addr = ioremap(self_res.start, resource_size(&self_res));
 
 	/*
 	 * /ht node doesn't expose a "ranges" property, we read the register
@@ -1323,8 +1322,7 @@ static void fixup_u4_pcie(struct pci_dev* dev)
 		 */
 		if (r->start >= 0xf0000000 && r->start < 0xf3000000)
 			continue;
-		if (!region || (r->end - r->start) >
-		    (region->end - region->start))
+		if (!region || resource_size(r) > resource_size(region))
 			region = r;
 	}
 	/* Nothing found, bail */
diff --git a/arch/powerpc/platforms/powermac/time.c b/arch/powerpc/platforms/powermac/time.c
index 48211ca..11c9fce 100644
--- a/arch/powerpc/platforms/powermac/time.c
+++ b/arch/powerpc/platforms/powermac/time.c
@@ -274,7 +274,7 @@ int __init via_calibrate_decr(void)
 		return 0;
 	}
 	of_node_put(vias);
-	via = ioremap(rsrc.start, rsrc.end - rsrc.start + 1);
+	via = ioremap(rsrc.start, resource_size(&rsrc));
 	if (via == NULL) {
 		printk(KERN_ERR "Failed to map VIA for timer calibration !\n");
 		return 0;
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index bd0d540..265f0f0 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -203,7 +203,7 @@ static int axon_ram_probe(struct platform_device *device)
 		goto failed;
 	}
 
-	bank->size = resource.end - resource.start + 1;
+	bank->size = resource_size(&resource);
 
 	if (bank->size == 0) {
 		dev_err(&device->dev, "No DDR2 memory found for %s%d\n",
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index 350787c..5d7d59a 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -148,7 +148,7 @@ unsigned int cpm_pic_init(void)
 	if (ret)
 		goto end;
 
-	cpic_reg = ioremap(res.start, res.end - res.start + 1);
+	cpic_reg = ioremap(res.start, resource_size(&res));
 	if (cpic_reg == NULL)
 		goto end;
 
diff --git a/arch/powerpc/sysdev/cpm_common.c b/arch/powerpc/sysdev/cpm_common.c
index 2b69aa0..d55d0ad 100644
--- a/arch/powerpc/sysdev/cpm_common.c
+++ b/arch/powerpc/sysdev/cpm_common.c
@@ -115,7 +115,7 @@ int cpm_muram_init(void)
 			max = r.end;
 
 		rh_attach_region(&cpm_muram_info, r.start - muram_pbase,
-		                 r.end - r.start + 1);
+				 resource_size(&r));
 	}
 
 	muram_vbase = ioremap(muram_pbase, max - muram_pbase + 1);
diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index 8e9e06a..4f2680f 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -239,7 +239,7 @@ static int __init dart_init(struct device_node *dart_node)
 					 DARTMAP_RPNMASK);
 
 	/* Map in DART registers */
-	dart = ioremap(r.start, r.end - r.start + 1);
+	dart = ioremap(r.start, resource_size(&r));
 	if (dart == NULL)
 		panic("DART: Cannot map registers!");
 
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 92e7833..419a772 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -349,7 +349,7 @@ static int __devinit fsl_of_msi_probe(struct platform_device *dev)
 		goto error_out;
 	}
 
-	msi->msi_regs = ioremap(res.start, res.end - res.start + 1);
+	msi->msi_regs = ioremap(res.start, resource_size(&res));
 	if (!msi->msi_regs) {
 		dev_err(&dev->dev, "ioremap problem failed\n");
 		goto error_out;
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 68ca929..ba5cb3fa 100644
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
 
@@ -108,7 +108,7 @@ static void __init setup_pci_atmu(struct pci_controller *hose,
 	char *name = hose->dn->full_name;
 
 	pr_debug("PCI memory map start 0x%016llx, size 0x%016llx\n",
-		    (u64)rsrc->start, (u64)rsrc->end - (u64)rsrc->start + 1);
+		 (u64)rsrc->start, (u64)resource_size(rsrc));
 
 	if (of_device_is_compatible(hose->dn, "fsl,qoriq-pcie-v2.2")) {
 		win_idx = 2;
@@ -116,7 +116,7 @@ static void __init setup_pci_atmu(struct pci_controller *hose,
 		end_idx = 3;
 	}
 
-	pci = ioremap(rsrc->start, rsrc->end - rsrc->start + 1);
+	pci = ioremap(rsrc->start, resource_size(rsrc));
 	if (!pci) {
 	    dev_err(hose->parent, "Unable to map ATMU registers\n");
 	    return;
@@ -153,9 +153,9 @@ static void __init setup_pci_atmu(struct pci_controller *hose,
 		} else {
 			pr_debug("PCI IO resource start 0x%016llx, size 0x%016llx, "
 				 "phy base 0x%016llx.\n",
-				(u64)hose->io_resource.start,
-				(u64)hose->io_resource.end - (u64)hose->io_resource.start + 1,
-				(u64)hose->io_base_phys);
+				 (u64)hose->io_resource.start,
+				 (u64)resource_size(&hose->io_resource),
+				 (u64)hose->io_base_phys);
 			out_be32(&pci->pow[j].potar, (hose->io_resource.start >> 12));
 			out_be32(&pci->pow[j].potear, 0);
 			out_be32(&pci->pow[j].powbar, (hose->io_base_phys >> 12));
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 5b206a2..9585338 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1523,7 +1523,7 @@ int fsl_rio_setup(struct platform_device *dev)
 	port->priv = priv;
 	port->phys_efptr = 0x100;
 
-	priv->regs_win = ioremap(regs.start, regs.end - regs.start + 1);
+	priv->regs_win = ioremap(regs.start, resource_size(&regs));
 	rio_regs_win = priv->regs_win;
 
 	/* Probe the master port phy type */
diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
index 7367d17..95da897 100644
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -736,7 +736,7 @@ struct ipic * __init ipic_init(struct device_node *node, unsigned int flags)
 		return NULL;
 	}
 
-	ipic->regs = ioremap(res.start, res.end - res.start + 1);
+	ipic->regs = ioremap(res.start, resource_size(&res));
 
 	ipic->irqhost->host_data = ipic;
 
diff --git a/arch/powerpc/sysdev/mmio_nvram.c b/arch/powerpc/sysdev/mmio_nvram.c
index ddc877a..69f5814 100644
--- a/arch/powerpc/sysdev/mmio_nvram.c
+++ b/arch/powerpc/sysdev/mmio_nvram.c
@@ -129,7 +129,7 @@ int __init mmio_nvram_init(void)
 		goto out;
 	}
 	nvram_addr = r.start;
-	mmio_nvram_len = r.end - r.start + 1;
+	mmio_nvram_len = resource_size(&r);
 	if ( (!mmio_nvram_len) || (!nvram_addr) ) {
 		printk(KERN_WARNING "nvram: address or length is 0\n");
 		ret = -EIO;
diff --git a/arch/powerpc/sysdev/mpc8xx_pic.c b/arch/powerpc/sysdev/mpc8xx_pic.c
index 20924f2..22e48e2 100644
--- a/arch/powerpc/sysdev/mpc8xx_pic.c
+++ b/arch/powerpc/sysdev/mpc8xx_pic.c
@@ -166,7 +166,7 @@ int mpc8xx_pic_init(void)
 	if (ret)
 		goto out;
 
-	siu_reg = ioremap(res.start, res.end - res.start + 1);
+	siu_reg = ioremap(res.start, resource_size(&res));
 	if (siu_reg == NULL) {
 		ret = -EINVAL;
 		goto out;
diff --git a/arch/powerpc/sysdev/mv64x60_udbg.c b/arch/powerpc/sysdev/mv64x60_udbg.c
index 2792dc8..50a8138 100644
--- a/arch/powerpc/sysdev/mv64x60_udbg.c
+++ b/arch/powerpc/sysdev/mv64x60_udbg.c
@@ -125,11 +125,11 @@ static void mv64x60_udbg_init(void)
 
 	of_node_put(np);
 
-	mpsc_base = ioremap(r[0].start, r[0].end - r[0].start + 1);
+	mpsc_base = ioremap(r[0].start, resource_size(&r[0]));
 	if (!mpsc_base)
 		return;
 
-	mpsc_intr_cause = ioremap(r[1].start, r[1].end - r[1].start + 1);
+	mpsc_intr_cause = ioremap(r[1].start, resource_size(&r[1]));
 	if (!mpsc_intr_cause) {
 		iounmap(mpsc_base);
 		return;
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index 156aa7d..deda60a 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -265,7 +265,7 @@ static void __init ppc4xx_configure_pci_PMMs(struct pci_controller *hose,
 		if (ppc4xx_setup_one_pci_PMM(hose, reg,
 					     res->start,
 					     res->start - hose->pci_mem_offset,
-					     res->end + 1 - res->start,
+					     resource_size(res),
 					     res->flags,
 					     j) == 0) {
 			j++;
@@ -290,7 +290,7 @@ static void __init ppc4xx_configure_pci_PTMs(struct pci_controller *hose,
 					     void __iomem *reg,
 					     const struct resource *res)
 {
-	resource_size_t size = res->end - res->start + 1;
+	resource_size_t size = resource_size(res);
 	u32 sa;
 
 	/* Calculate window size */
@@ -349,7 +349,7 @@ static void __init ppc4xx_probe_pci_bridge(struct device_node *np)
 	bus_range = of_get_property(np, "bus-range", NULL);
 
 	/* Map registers */
-	reg = ioremap(rsrc_reg.start, rsrc_reg.end + 1 - rsrc_reg.start);
+	reg = ioremap(rsrc_reg.start, resource_size(&rsrc_reg));
 	if (reg == NULL) {
 		printk(KERN_ERR "%s: Can't map registers !", np->full_name);
 		goto fail;
@@ -465,7 +465,7 @@ static void __init ppc4xx_configure_pcix_POMs(struct pci_controller *hose,
 		if (ppc4xx_setup_one_pcix_POM(hose, reg,
 					      res->start,
 					      res->start - hose->pci_mem_offset,
-					      res->end + 1 - res->start,
+					      resource_size(res),
 					      res->flags,
 					      j) == 0) {
 			j++;
@@ -492,7 +492,7 @@ static void __init ppc4xx_configure_pcix_PIMs(struct pci_controller *hose,
 					      int big_pim,
 					      int enable_msi_hole)
 {
-	resource_size_t size = res->end - res->start + 1;
+	resource_size_t size = resource_size(res);
 	u32 sa;
 
 	/* RAM is always at 0 */
@@ -555,7 +555,7 @@ static void __init ppc4xx_probe_pcix_bridge(struct device_node *np)
 	bus_range = of_get_property(np, "bus-range", NULL);
 
 	/* Map registers */
-	reg = ioremap(rsrc_reg.start, rsrc_reg.end + 1 - rsrc_reg.start);
+	reg = ioremap(rsrc_reg.start, resource_size(&rsrc_reg));
 	if (reg == NULL) {
 		printk(KERN_ERR "%s: Can't map registers !", np->full_name);
 		goto fail;
@@ -1604,7 +1604,7 @@ static void __init ppc4xx_configure_pciex_POMs(struct ppc4xx_pciex_port *port,
 		if (ppc4xx_setup_one_pciex_POM(port, hose, mbase,
 					       res->start,
 					       res->start - hose->pci_mem_offset,
-					       res->end + 1 - res->start,
+					       resource_size(res),
 					       res->flags,
 					       j) == 0) {
 			j++;
@@ -1639,7 +1639,7 @@ static void __init ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
 					       void __iomem *mbase,
 					       struct resource *res)
 {
-	resource_size_t size = res->end - res->start + 1;
+	resource_size_t size = resource_size(res);
 	u64 sa;
 
 	if (port->endpoint) {
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index b2acda0..18e75ca 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -347,7 +347,7 @@ void __init qe_ic_init(struct device_node *node, unsigned int flags,
 		return;
 	}
 
-	qe_ic->regs = ioremap(res.start, res.end - res.start + 1);
+	qe_ic->regs = ioremap(res.start, resource_size(&res));
 
 	qe_ic->irqhost->host_data = qe_ic;
 	qe_ic->hc_irq = qe_ic_irq_chip;
diff --git a/arch/powerpc/sysdev/qe_lib/qe_io.c b/arch/powerpc/sysdev/qe_lib/qe_io.c
index 77e4934..fd1a6c3 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_io.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_io.c
@@ -41,7 +41,7 @@ int par_io_init(struct device_node *np)
 	ret = of_address_to_resource(np, 0, &res);
 	if (ret)
 		return ret;
-	par_io = ioremap(res.start, res.end - res.start + 1);
+	par_io = ioremap(res.start, resource_size(&res));
 
 	num_ports = of_get_property(np, "num-ports", NULL);
 	if (num_ports)
diff --git a/arch/powerpc/sysdev/xics/icp-native.c b/arch/powerpc/sysdev/xics/icp-native.c
index 1f15ad4..039a782 100644
--- a/arch/powerpc/sysdev/xics/icp-native.c
+++ b/arch/powerpc/sysdev/xics/icp-native.c
@@ -247,7 +247,7 @@ static int __init icp_native_init_one_node(struct device_node *np,
 			return -1;
 		}
 
-		if (icp_native_map_one_cpu(*indx, r.start, r.end - r.start))
+		if (icp_native_map_one_cpu(*indx, r.start, resource_size(&r)))
 			return -1;
 
 		(*indx)++;
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
diff --git a/arch/sh/kernel/machine_kexec.c b/arch/sh/kernel/machine_kexec.c
index e2a3af3..c5a33f0 100644
--- a/arch/sh/kernel/machine_kexec.c
+++ b/arch/sh/kernel/machine_kexec.c
@@ -170,7 +170,7 @@ void __init reserve_crashkernel(void)
 	if (crashk_res.end == crashk_res.start)
 		goto disable;
 
-	crash_size = PAGE_ALIGN(crashk_res.end - crashk_res.start + 1);
+	crash_size = PAGE_ALIGN(resource_size(&crashk_res));
 	if (!crashk_res.start) {
 		unsigned long max = memblock_end_of_DRAM() - memory_limit;
 		crashk_res.start = __memblock_alloc_base(crash_size, PAGE_SIZE, max);
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 92700c1..d0479e2 100644
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
+		    (long)resource_size(res), n);
 		return;
 	}
 
@@ -505,9 +505,9 @@ static void pci32_free_coherent(struct device *dev, size_t n, void *p,
 	}
 
 	n = PAGE_ALIGN(n);
-	if ((res->end-res->start)+1 != n) {
+	if (resource_size(res) != n) {
 		printk("pci_free_consistent: region 0x%lx asked 0x%lx\n",
-		    (long)((res->end-res->start)+1), (long)n);
+		    (long)resource_size(res), (long)n);
 		return;
 	}
 
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 713dc91..2d1453d 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -820,11 +820,9 @@ static int __pci_mmap_make_offset_bus(struct pci_dev *pdev, struct vm_area_struc
 	unsigned long space_size, user_offset, user_size;
 
 	if (mmap_state == pci_mmap_io) {
-		space_size = (pbm->io_space.end -
-			      pbm->io_space.start) + 1;
+		space_size = resource_size(&pbm->io_space);
 	} else {
-		space_size = (pbm->mem_space.end -
-			      pbm->mem_space.start) + 1;
+		space_size = resource_size(&pbm->mem_space);
 	}
 
 	/* Make sure the request is in range. */
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 6cdc9ba..5f85d8b 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -553,8 +553,7 @@ static void __init setup_bootmem_allocator(void)
 
 #ifdef CONFIG_KEXEC
 	if (crashk_res.start != crashk_res.end)
-		reserve_bootmem(crashk_res.start,
-			crashk_res.end - crashk_res.start + 1, 0);
+		reserve_bootmem(crashk_res.start, resource_size(&crashk_res), 0);
 #endif
 }
 
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index e8c33a3..726494b 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1553,7 +1553,7 @@ static void __init calgary_fixup_one_tce_space(struct pci_dev *dev)
 			continue;
 
 		/* cover the whole region */
-		npages = (r->end - r->start) >> PAGE_SHIFT;
+		npages = resource_size(r) >> PAGE_SHIFT;
 		npages++;
 
 		iommu_range_reserve(tbl, r->start, npages);
diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index ba0a4cc..6322803 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -234,7 +234,7 @@ void __init probe_roms(void)
 	/* check for extension rom (ignore length byte!) */
 	rom = isa_bus_to_virt(extension_rom_resource.start);
 	if (romsignature(rom)) {
-		length = extension_rom_resource.end - extension_rom_resource.start + 1;
+		length = resource_size(&extension_rom_resource);
 		if (romchecksum(rom, length)) {
 			request_resource(&iomem_resource, &extension_rom_resource);
 			upper = extension_rom_resource.start;
diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
index cf39bc0..0c68823 100644
--- a/drivers/char/bsr.c
+++ b/drivers/char/bsr.c
@@ -212,7 +212,7 @@ static int bsr_add_node(struct device_node *bn)
 
 		cur->bsr_minor  = i + total_bsr_devs;
 		cur->bsr_addr   = res.start;
-		cur->bsr_len    = res.end - res.start + 1;
+		cur->bsr_len    = resource_size(&res);
 		cur->bsr_bytes  = bsr_bytes[i];
 		cur->bsr_stride = bsr_stride[i];
 		cur->bsr_dev    = MKDEV(bsr_major, i + total_bsr_devs);
diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index a94e930..a8428e6 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -100,8 +100,7 @@ static int __devinit timeriomem_rng_probe(struct platform_device *pdev)
 
 	timeriomem_rng_data = pdev->dev.platform_data;
 
-	timeriomem_rng_data->address = ioremap(res->start,
-						res->end - res->start + 1);
+	timeriomem_rng_data->address = ioremap(res->start, resource_size(res));
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
 
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index db1df59..9a6a274 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -140,7 +140,7 @@ static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 		if (of_node_to_nid(np) != priv->node)
 			continue;
 		csrow->first_page = r.start >> PAGE_SHIFT;
-		csrow->nr_pages = (r.end - r.start + 1) >> PAGE_SHIFT;
+		csrow->nr_pages = resource_size(&r) >> PAGE_SHIFT;
 		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
 		csrow->mtype = MEM_XDR;
 		csrow->edac_mode = EDAC_SECDED;
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 38ab8e2..11e1a5d 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -538,15 +538,15 @@ static int __devinit mpc85xx_l2_err_probe(struct platform_device *op)
 	/* we only need the error registers */
 	r.start += 0xe00;
 
-	if (!devm_request_mem_region(&op->dev, r.start,
-				     r.end - r.start + 1, pdata->name)) {
+	if (!devm_request_mem_region(&op->dev, r.start, resource_size(&r),
+				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
 		res = -EBUSY;
 		goto err;
 	}
 
-	pdata->l2_vbase = devm_ioremap(&op->dev, r.start, r.end - r.start + 1);
+	pdata->l2_vbase = devm_ioremap(&op->dev, r.start, resource_size(&r));
 	if (!pdata->l2_vbase) {
 		printk(KERN_ERR "%s: Unable to setup L2 err regs\n", __func__);
 		res = -ENOMEM;
@@ -987,15 +987,15 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 		goto err;
 	}
 
-	if (!devm_request_mem_region(&op->dev, r.start,
-				     r.end - r.start + 1, pdata->name)) {
+	if (!devm_request_mem_region(&op->dev, r.start, resource_size(&r),
+				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
 		res = -EBUSY;
 		goto err;
 	}
 
-	pdata->mc_vbase = devm_ioremap(&op->dev, r.start, r.end - r.start + 1);
+	pdata->mc_vbase = devm_ioremap(&op->dev, r.start, resource_size(&r));
 	if (!pdata->mc_vbase) {
 		printk(KERN_ERR "%s: Unable to setup MC err regs\n", __func__);
 		res = -ENOMEM;
diff --git a/drivers/gpio/gpio-u300.c b/drivers/gpio/gpio-u300.c
index fd2dfee..53e8255 100644
--- a/drivers/gpio/gpio-u300.c
+++ b/drivers/gpio/gpio-u300.c
@@ -578,8 +578,8 @@ static int __init gpio_probe(struct platform_device *pdev)
 	if (!memres)
 		goto err_no_resource;
 
-	if (request_mem_region(memres->start, memres->end - memres->start, "GPIO Controller")
-	    == NULL) {
+	if (!request_mem_region(memres->start, resource_size(memres),
+				"GPIO Controller")) {
 		err = -ENODEV;
 		goto err_no_ioregion;
 	}
@@ -637,7 +637,7 @@ static int __init gpio_probe(struct platform_device *pdev)
 		free_irq(gpio_ports[i].irq, &gpio_ports[i]);
 	iounmap(virtbase);
  err_no_ioremap:
-	release_mem_region(memres->start, memres->end - memres->start);
+	release_mem_region(memres->start, resource_size(memres));
  err_no_ioregion:
  err_no_resource:
 	clk_disable(clk);
@@ -657,7 +657,7 @@ static int __exit gpio_remove(struct platform_device *pdev)
 	for (i = 0 ; i < U300_GPIO_NUM_PORTS; i++)
 		free_irq(gpio_ports[i].irq, &gpio_ports[i]);
 	iounmap(virtbase);
-	release_mem_region(memres->start, memres->end - memres->start);
+	release_mem_region(memres->start, resource_size(memres));
 	clk_disable(clk);
 	clk_put(clk);
 	return 0;
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index a365be0..98723cb 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
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
diff --git a/drivers/input/serio/sa1111ps2.c b/drivers/input/serio/sa1111ps2.c
index d55874e..44fc8b4 100644
--- a/drivers/input/serio/sa1111ps2.c
+++ b/drivers/input/serio/sa1111ps2.c
@@ -300,8 +300,7 @@ static int __devinit ps2_probe(struct sa1111_dev *dev)
 
  out:
 	sa1111_disable_device(ps2if->dev);
-	release_mem_region(dev->res.start,
-			   dev->res.end - dev->res.start + 1);
+	release_mem_region(dev->res.start, resource_size(&dev->res));
  free:
 	sa1111_set_drvdata(dev, NULL);
 	kfree(ps2if);
@@ -317,8 +316,7 @@ static int __devexit ps2_remove(struct sa1111_dev *dev)
 	struct ps2if *ps2if = sa1111_get_drvdata(dev);
 
 	serio_unregister_port(ps2if->io);
-	release_mem_region(dev->res.start,
-			   dev->res.end - dev->res.start + 1);
+	release_mem_region(dev->res.start, resource_size(&dev->res));
 	sa1111_set_drvdata(dev, NULL);
 
 	kfree(ps2if);
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
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index 090d2a3..a8c08f3 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -681,11 +681,11 @@ static int i2o_iop_systab_set(struct i2o_controller *c)
 		if (root && allocate_resource(root, res, sb->desired_mem_size, sb->desired_mem_size, sb->desired_mem_size, 1 << 20,	/* Unspecified, so use 1Mb and play safe */
 					      NULL, NULL) >= 0) {
 			c->mem_alloc = 1;
-			sb->current_mem_size = 1 + res->end - res->start;
+			sb->current_mem_size = resource_size(res);
 			sb->current_mem_base = res->start;
 			osm_info("%s: allocated %llu bytes of PCI memory at "
 				"0x%016llX.\n", c->name,
-				(unsigned long long)(1 + res->end - res->start),
+				(unsigned long long)resource_size(res),
 				(unsigned long long)res->start);
 		}
 	}
@@ -703,11 +703,11 @@ static int i2o_iop_systab_set(struct i2o_controller *c)
 		if (root && allocate_resource(root, res, sb->desired_io_size, sb->desired_io_size, sb->desired_io_size, 1 << 20,	/* Unspecified, so use 1Mb and play safe */
 					      NULL, NULL) >= 0) {
 			c->io_alloc = 1;
-			sb->current_io_size = 1 + res->end - res->start;
+			sb->current_io_size = resource_size(res);
 			sb->current_mem_base = res->start;
 			osm_info("%s: allocated %llu bytes of PCI I/O at "
 				"0x%016llX.\n", c->name,
-				(unsigned long long)(1 + res->end - res->start),
+				(unsigned long long)resource_size(res),
 				(unsigned long long)res->start);
 		}
 	}
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
diff --git a/drivers/mtd/maps/ixp2000.c b/drivers/mtd/maps/ixp2000.c
index c00b917..1594a80 100644
--- a/drivers/mtd/maps/ixp2000.c
+++ b/drivers/mtd/maps/ixp2000.c
@@ -155,7 +155,7 @@ static int ixp2000_flash_probe(struct platform_device *dev)
 	if (!plat)
 		return -ENODEV;
 
-	window_size = dev->resource->end - dev->resource->start + 1;
+	window_size = resource_size(dev->resource);
 	dev_info(&dev->dev, "Probe of IXP2000 flash(%d banks x %dMiB)\n",
 		 ixp_data->nr_banks, ((u32)window_size >> 20));
 
@@ -194,16 +194,17 @@ static int ixp2000_flash_probe(struct platform_device *dev)
 	info->map.copy_to = ixp2000_flash_copy_to;
 
 	info->res = request_mem_region(dev->resource->start,
-			dev->resource->end - dev->resource->start + 1,
-			dev_name(&dev->dev));
+				       resource_size(dev->resource),
+				       dev_name(&dev->dev));
 	if (!info->res) {
 		dev_err(&dev->dev, "Could not reserve memory region\n");
 		err = -ENOMEM;
 		goto Error;
 	}
 
-	info->map.map_priv_1 = (unsigned long) ioremap(dev->resource->start,
-			    	dev->resource->end - dev->resource->start + 1);
+	info->map.map_priv_1 =
+		(unsigned long)ioremap(dev->resource->start,
+				       resource_size(dev->resource));
 	if (!info->map.map_priv_1) {
 		dev_err(&dev->dev, "Failed to ioremap flash region\n");
 		err = -EIO;
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
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index 2f7c930..eb1fbac 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -713,7 +713,7 @@ static int __devinit mpc5121_nfc_probe(struct platform_device *op)
 	}
 
 	regs_paddr = res.start;
-	regs_size = res.end - res.start + 1;
+	regs_size = resource_size(&res);
 
 	if (!devm_request_mem_region(dev, regs_paddr, regs_size, DRV_NAME)) {
 		dev_err(dev, "Error requesting memory region!\n");
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
diff --git a/drivers/net/fec_mpc52xx.c b/drivers/net/fec_mpc52xx.c
index 9f81b1a..fe57eee 100644
--- a/drivers/net/fec_mpc52xx.c
+++ b/drivers/net/fec_mpc52xx.c
@@ -867,10 +867,11 @@ static int __devinit mpc52xx_fec_probe(struct platform_device *op)
 				"Error while parsing device node resource\n" );
 		goto err_netdev;
 	}
-	if ((mem.end - mem.start + 1) < sizeof(struct mpc52xx_fec)) {
+	if (resource_size(&mem) < sizeof(struct mpc52xx_fec)) {
 		printk(KERN_ERR DRIVER_NAME
-			" - invalid resource size (%lx < %x), check mpc52xx_devices.c\n",
-			(unsigned long)(mem.end - mem.start + 1), sizeof(struct mpc52xx_fec));
+		       " - invalid resource size (%lx < %x), check mpc52xx_devices.c\n",
+		       (unsigned long)resource_size(&mem),
+		       sizeof(struct mpc52xx_fec));
 		rv = -EINVAL;
 		goto err_netdev;
 	}
diff --git a/drivers/net/fs_enet/mii-bitbang.c b/drivers/net/fs_enet/mii-bitbang.c
index ad29754..b09270b 100644
--- a/drivers/net/fs_enet/mii-bitbang.c
+++ b/drivers/net/fs_enet/mii-bitbang.c
@@ -120,7 +120,7 @@ static int __devinit fs_mii_bitbang_init(struct mii_bus *bus,
 	if (ret)
 		return ret;
 
-	if (res.end - res.start < 13)
+	if (resource_size(&res) <= 13)
 		return -ENODEV;
 
 	/* This should really encode the pin number as well, but all
@@ -139,7 +139,7 @@ static int __devinit fs_mii_bitbang_init(struct mii_bus *bus,
 		return -ENODEV;
 	mdc_pin = *data;
 
-	bitbang->dir = ioremap(res.start, res.end - res.start + 1);
+	bitbang->dir = ioremap(res.start, resource_size(&res));
 	if (!bitbang->dir)
 		return -ENOMEM;
 
diff --git a/drivers/net/fs_enet/mii-fec.c b/drivers/net/fs_enet/mii-fec.c
index 6a2e150..e0e9d6c 100644
--- a/drivers/net/fs_enet/mii-fec.c
+++ b/drivers/net/fs_enet/mii-fec.c
@@ -136,7 +136,7 @@ static int __devinit fs_enet_mdio_probe(struct platform_device *ofdev)
 
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%x", res.start);
 
-	fec->fecp = ioremap(res.start, res.end - res.start + 1);
+	fec->fecp = ioremap(res.start, resource_size(&res));
 	if (!fec->fecp)
 		goto out_fec;
 
diff --git a/drivers/net/gianfar_ptp.c b/drivers/net/gianfar_ptp.c
index d8e1753..1c97861 100644
--- a/drivers/net/gianfar_ptp.c
+++ b/drivers/net/gianfar_ptp.c
@@ -491,7 +491,7 @@ static int gianfar_ptp_probe(struct platform_device *dev)
 	spin_lock_init(&etsects->lock);
 
 	etsects->regs = ioremap(etsects->rsrc->start,
-				1 + etsects->rsrc->end - etsects->rsrc->start);
+				resource_size(etsects->rsrc));
 	if (!etsects->regs) {
 		pr_err("ioremap ptp registers failed\n");
 		goto no_ioremap;
diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index 079450f..725399e 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -2770,7 +2770,7 @@ static int __devinit emac_probe(struct platform_device *ofdev)
 	}
 	// TODO : request_mem_region
 	dev->emacp = ioremap(dev->rsrc_regs.start,
-			     dev->rsrc_regs.end - dev->rsrc_regs.start + 1);
+			     resource_size(&dev->rsrc_regs));
 	if (dev->emacp == NULL) {
 		printk(KERN_ERR "%s: Can't map device registers!\n",
 		       np->full_name);
diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index 6c6a028..27125cd 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -1169,7 +1169,7 @@ static int __init macb_probe(struct platform_device *pdev)
 	clk_enable(bp->hclk);
 #endif
 
-	bp->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	bp->regs = ioremap(regs->start, resource_size(regs));
 	if (!bp->regs) {
 		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
 		err = -ENOMEM;
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
diff --git a/drivers/of/address.c b/drivers/of/address.c
index b4559c5..d9bdf82 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -592,6 +592,6 @@ void __iomem *of_iomap(struct device_node *np, int index)
 	if (of_address_to_resource(np, index, &res))
 		return NULL;
 
-	return ioremap(res.start, 1 + res.end - res.start);
+	return ioremap(res.start, resource_size(&res));
 }
 EXPORT_SYMBOL(of_iomap);
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
diff --git a/drivers/pci/hotplug/shpchp_sysfs.c b/drivers/pci/hotplug/shpchp_sysfs.c
index 071b7dc..efa30da 100644
--- a/drivers/pci/hotplug/shpchp_sysfs.c
+++ b/drivers/pci/hotplug/shpchp_sysfs.c
@@ -50,29 +50,26 @@ static ssize_t show_ctrl (struct device *dev, struct device_attribute *attr, cha
 	pci_bus_for_each_resource(bus, res, index) {
 		if (res && (res->flags & IORESOURCE_MEM) &&
 				!(res->flags & IORESOURCE_PREFETCH)) {
-			out += sprintf(out, "start = %8.8llx, "
-					"length = %8.8llx\n",
-					(unsigned long long)res->start,
-					(unsigned long long)(res->end - res->start));
+			out += sprintf(out, "start = %8.8llx, length = %8.8llx\n",
+				       (unsigned long long)res->start,
+				       (unsigned long long)resource_size(res));
 		}
 	}
 	out += sprintf(out, "Free resources: prefetchable memory\n");
 	pci_bus_for_each_resource(bus, res, index) {
 		if (res && (res->flags & IORESOURCE_MEM) &&
 			       (res->flags & IORESOURCE_PREFETCH)) {
-			out += sprintf(out, "start = %8.8llx, "
-					"length = %8.8llx\n",
-					(unsigned long long)res->start,
-					(unsigned long long)(res->end - res->start));
+			out += sprintf(out, "start = %8.8llx, length = %8.8llx\n",
+				       (unsigned long long)res->start,
+				       (unsigned long long)resource_size(res));
 		}
 	}
 	out += sprintf(out, "Free resources: IO\n");
 	pci_bus_for_each_resource(bus, res, index) {
 		if (res && (res->flags & IORESOURCE_IO)) {
-			out += sprintf(out, "start = %8.8llx, "
-					"length = %8.8llx\n",
-					(unsigned long long)res->start,
-					(unsigned long long)(res->end - res->start));
+			out += sprintf(out, "start = %8.8llx, length = %8.8llx\n",
+				       (unsigned long long)res->start,
+				       (unsigned long long)resource_size(res));
 		}
 	}
 	out += sprintf(out, "Free resources: bus numbers\n");
diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index fb33fa4..4902206 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -283,8 +283,7 @@ static int __init at91_cf_probe(struct platform_device *pdev)
 	}
 
 	/* reserve chip-select regions */
-	if (!request_mem_region(io->start, io->end + 1 - io->start,
-				driver_name)) {
+	if (!request_mem_region(io->start, resource_size(io), driver_name)) {
 		status = -ENXIO;
 		goto fail1;
 	}
@@ -308,7 +307,7 @@ static int __init at91_cf_probe(struct platform_device *pdev)
 	return 0;
 
 fail2:
-	release_mem_region(io->start, io->end + 1 - io->start);
+	release_mem_region(io->start, resource_size(io));
 fail1:
 	if (cf->socket.io_offset)
 		iounmap((void __iomem *) cf->socket.io_offset);
@@ -339,7 +338,7 @@ static int __exit at91_cf_remove(struct platform_device *pdev)
 	struct resource		*io = cf->socket.io[0].res;
 
 	pcmcia_unregister_socket(&cf->socket);
-	release_mem_region(io->start, io->end + 1 - io->start);
+	release_mem_region(io->start, resource_size(io));
 	iounmap((void __iomem *) cf->socket.io_offset);
 	if (board->irq_pin) {
 		free_irq(board->irq_pin, cf);
diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 6defd4a..06ad3e5 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -209,9 +209,9 @@ static int __devinit electra_cf_probe(struct platform_device *ofdev)
 
 	cf->ofdev = ofdev;
 	cf->mem_phys = mem.start;
-	cf->mem_size = PAGE_ALIGN(mem.end - mem.start);
+	cf->mem_size = PAGE_ALIGN(resource_size(&mem));
 	cf->mem_base = ioremap(cf->mem_phys, cf->mem_size);
-	cf->io_size = PAGE_ALIGN(io.end - io.start);
+	cf->io_size = PAGE_ALIGN(resource_size(&io));
 
 	area = __get_vm_area(cf->io_size, 0, PHB_IO_BASE, PHB_IO_END);
 	if (area == NULL)
diff --git a/drivers/pcmcia/rsrc_iodyn.c b/drivers/pcmcia/rsrc_iodyn.c
index 523eb69..f53c237 100644
--- a/drivers/pcmcia/rsrc_iodyn.c
+++ b/drivers/pcmcia/rsrc_iodyn.c
@@ -135,7 +135,7 @@ static int iodyn_find_io(struct pcmcia_socket *s, unsigned int attr,
 		try = res->end + 1;
 		if ((*base == 0) || (*base == try)) {
 			if (adjust_resource(s->io[i].res, res->start,
-					res->end - res->start + num + 1))
+					    resource_size(res) + num))
 				continue;
 			*base = try;
 			s->io[i].InUse += num;
@@ -147,8 +147,8 @@ static int iodyn_find_io(struct pcmcia_socket *s, unsigned int attr,
 		try = res->start - num;
 		if ((*base == 0) || (*base == try)) {
 			if (adjust_resource(s->io[i].res,
-					res->start - num,
-					res->end - res->start + num + 1))
+					    res->start - num,
+					    resource_size(res) + num))
 				continue;
 			*base = try;
 			s->io[i].InUse += num;
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index b187555..9da9656 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -770,7 +770,7 @@ static int nonstatic_find_io(struct pcmcia_socket *s, unsigned int attr,
 							res->end + num);
 			if (!ret) {
 				ret = adjust_resource(s->io[i].res, res->start,
-					       res->end - res->start + num + 1);
+						      resource_size(res) + num);
 				if (ret)
 					continue;
 				*base = try;
@@ -788,8 +788,8 @@ static int nonstatic_find_io(struct pcmcia_socket *s, unsigned int attr,
 							res->end);
 			if (!ret) {
 				ret = adjust_resource(s->io[i].res,
-					       res->start - num,
-					       res->end - res->start + num + 1);
+						      res->start - num,
+						      resource_size(res) + num);
 				if (ret)
 					continue;
 				*base = try;
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
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 911e75c..05beb6c 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -606,7 +606,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	 * (needing ioremap etc), not i/o space resources like this ...
 	 */
 	ports = request_region(ports->start,
-			ports->end + 1 - ports->start,
+			resource_size(ports),
 			driver_name);
 	if (!ports) {
 		dev_dbg(dev, "i/o registers already in use\n");
@@ -750,7 +750,7 @@ cleanup1:
 	cmos_rtc.dev = NULL;
 	rtc_device_unregister(cmos_rtc.rtc);
 cleanup0:
-	release_region(ports->start, ports->end + 1 - ports->start);
+	release_region(ports->start, resource_size(ports));
 	return retval;
 }
 
@@ -779,7 +779,7 @@ static void __exit cmos_do_remove(struct device *dev)
 	cmos->rtc = NULL;
 
 	ports = cmos->iomem;
-	release_region(ports->start, ports->end + 1 - ports->start);
+	release_region(ports->start, resource_size(ports));
 	cmos->iomem = NULL;
 
 	cmos->dev = NULL;
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
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index 0cec565..d335448 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -332,9 +332,8 @@ vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 	if (!iomem)
 		return -ENODEV;
 
-	iomem = request_mem_region(iomem->start,
-			iomem->end + 1 - iomem->start,
-			driver_name);
+	iomem = request_mem_region(iomem->start, resource_size(iomem),
+				   driver_name);
 	if (!iomem) {
 		dev_dbg(dev, "i/o mem already in use.\n");
 		return -EBUSY;
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
 
diff --git a/drivers/spi/spi_ppc4xx.c b/drivers/spi/spi_ppc4xx.c
index 2a298c0..b267fd9 100644
--- a/drivers/spi/spi_ppc4xx.c
+++ b/drivers/spi/spi_ppc4xx.c
@@ -502,7 +502,7 @@ static int __init spi_ppc4xx_of_probe(struct platform_device *op)
 		goto free_gpios;
 	}
 	hw->mapbase = resource.start;
-	hw->mapsize = resource.end - resource.start + 1;
+	hw->mapsize = resource_size(&resource);
 
 	/* Sanity check */
 	if (hw->mapsize < sizeof(struct spi_ppc4xx_regs)) {
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
diff --git a/drivers/staging/generic_serial/ser_a2232.c b/drivers/staging/generic_serial/ser_a2232.c
index 3f47c2e..0c08e1c 100644
--- a/drivers/staging/generic_serial/ser_a2232.c
+++ b/drivers/staging/generic_serial/ser_a2232.c
@@ -746,7 +746,8 @@ static int __init a2232board_init(void)
 		zd_a2232[nr_a2232] = z;
 
 		boardaddr = ZTWO_VADDR( z->resource.start );
-		printk("Board is located at address 0x%x, size is 0x%x.\n", boardaddr, (unsigned int) ((z->resource.end+1) - (z->resource.start)));
+		printk("Board is located at address 0x%x, size is 0x%x\n",
+		       boardaddr, (unsigned int)resource_size(&z->resource));
 
 		mem = (volatile struct a2232memory *) boardaddr;
 
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 74c5a65..280f9d4 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -80,7 +80,7 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 {
         struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 *gtt_slot, pte;
-	int numpages = (r->resource.end + 1 - r->resource.start) >> PAGE_SHIFT;
+	int numpages = resource_size(&r->resource) >> PAGE_SHIFT;
 	struct page **pages;
 	int i;
 
@@ -121,7 +121,7 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 *gtt_slot, pte;
-	int numpages = (r->resource.end + 1 - r->resource.start) >> PAGE_SHIFT;
+	int numpages = resource_size(&r->resource) >> PAGE_SHIFT;
 	int i;
 
 	WARN_ON(r->stolen);
@@ -149,7 +149,7 @@ static int psb_gtt_attach_pages(struct gtt_range *gt)
 	struct address_space *mapping;
 	int i;
 	struct page *p;
-	int pages = (gt->resource.end + 1 - gt->resource.start) >> PAGE_SHIFT;
+	int pages = resource_size(&gt->resource) >> PAGE_SHIFT;
 
 	WARN_ON(gt->pages);
 
@@ -191,7 +191,7 @@ err:
 static void psb_gtt_detach_pages(struct gtt_range *gt)
 {
 	int i;
-	int pages = (gt->resource.end + 1 - gt->resource.start) >> PAGE_SHIFT;
+	int pages = resource_size(&gt->resource) >> PAGE_SHIFT;
 
 	for (i = 0; i < pages; i++) {
 		/* FIXME: do we need to force dirty */
diff --git a/drivers/tty/serial/bfin_5xx.c b/drivers/tty/serial/bfin_5xx.c
index 9b1ff2b..ff69791 100644
--- a/drivers/tty/serial/bfin_5xx.c
+++ b/drivers/tty/serial/bfin_5xx.c
@@ -1304,8 +1304,7 @@ static int bfin_serial_probe(struct platform_device *pdev)
 			goto out_error_free_peripherals;
 		}
 
-		uart->port.membase = ioremap(res->start,
-			res->end - res->start);
+		uart->port.membase = ioremap(res->start, resource_size(res));
 		if (!uart->port.membase) {
 			dev_err(&pdev->dev, "Cannot map uart IO\n");
 			ret = -ENXIO;
@@ -1483,7 +1482,7 @@ static int bfin_earlyprintk_probe(struct platform_device *pdev)
 	}
 
 	bfin_earlyprintk_port.port.membase = ioremap(res->start,
-			res->end - res->start);
+						     resource_size(res));
 	if (!bfin_earlyprintk_port.port.membase) {
 		dev_err(&pdev->dev, "Cannot map uart IO\n");
 		ret = -ENXIO;
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
index 47cadf4..c37df8d 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1241,8 +1241,8 @@ static int serial_omap_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (!request_mem_region(mem->start, (mem->end - mem->start) + 1,
-				     pdev->dev.driver->name)) {
+	if (!request_mem_region(mem->start, resource_size(mem),
+				pdev->dev.driver->name)) {
 		dev_err(&pdev->dev, "memory region already claimed\n");
 		return -EBUSY;
 	}
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
diff --git a/drivers/usb/host/ehci-grlib.c b/drivers/usb/host/ehci-grlib.c
index 93b230d..fdfd8c5 100644
--- a/drivers/usb/host/ehci-grlib.c
+++ b/drivers/usb/host/ehci-grlib.c
@@ -130,7 +130,7 @@ static int __devinit ehci_hcd_grlib_probe(struct platform_device *op)
 		return -ENOMEM;
 
 	hcd->rsrc_start = res.start;
-	hcd->rsrc_len = res.end - res.start + 1;
+	hcd->rsrc_len = resource_size(&res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
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
diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
index 8552db6..41d11fe 100644
--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -130,7 +130,7 @@ static int __devinit ehci_hcd_ppc_of_probe(struct platform_device *op)
 		return -ENOMEM;
 
 	hcd->rsrc_start = res.start;
-	hcd->rsrc_len = res.end - res.start + 1;
+	hcd->rsrc_len = resource_size(&res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
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
diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index a64d6d6..32793ce 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -174,7 +174,7 @@ static int __devinit ehci_hcd_xilinx_of_probe(struct platform_device *op)
 		return -ENOMEM;
 
 	hcd->rsrc_start = res.start;
-	hcd->rsrc_len = res.end - res.start + 1;
+	hcd->rsrc_len = resource_size(&res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index 19223c7..572ea53 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -605,7 +605,7 @@ static int __devinit of_fhci_probe(struct platform_device *ofdev)
 		goto err_regs;
 	}
 
-	hcd->regs = ioremap(usb_regs.start, usb_regs.end - usb_regs.start + 1);
+	hcd->regs = ioremap(usb_regs.start, resource_size(&usb_regs));
 	if (!hcd->regs) {
 		dev_err(dev, "could not ioremap regs\n");
 		ret = -ENOMEM;
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
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index 1ca1821..0c12f4e 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -110,7 +110,7 @@ static int __devinit ohci_hcd_ppc_of_probe(struct platform_device *op)
 		return -ENOMEM;
 
 	hcd->rsrc_start = res.start;
-	hcd->rsrc_len = res.end - res.start + 1;
+	hcd->rsrc_len = resource_size(&res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
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
diff --git a/drivers/usb/host/ohci-sa1111.c b/drivers/usb/host/ohci-sa1111.c
index d8eb3bd..4204d972 100644
--- a/drivers/usb/host/ohci-sa1111.c
+++ b/drivers/usb/host/ohci-sa1111.c
@@ -131,7 +131,7 @@ int usb_hcd_sa1111_probe (const struct hc_driver *driver,
 	if (!hcd)
 		return -ENOMEM;
 	hcd->rsrc_start = dev->res.start;
-	hcd->rsrc_len = dev->res.end - dev->res.start + 1;
+	hcd->rsrc_len = resource_size(&dev->res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		dbg("request_mem_region failed");
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
diff --git a/drivers/usb/host/uhci-grlib.c b/drivers/usb/host/uhci-grlib.c
index d01c1e2..f7a6213 100644
--- a/drivers/usb/host/uhci-grlib.c
+++ b/drivers/usb/host/uhci-grlib.c
@@ -111,7 +111,7 @@ static int __devinit uhci_hcd_grlib_probe(struct platform_device *op)
 		return -ENOMEM;
 
 	hcd->rsrc_start = res.start;
-	hcd->rsrc_len = res.end - res.start + 1;
+	hcd->rsrc_len = resource_size(&res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
diff --git a/drivers/usb/host/whci/init.c b/drivers/usb/host/whci/init.c
index f7582e8..d3e13b6 100644
--- a/drivers/usb/host/whci/init.c
+++ b/drivers/usb/host/whci/init.c
@@ -178,7 +178,7 @@ void whc_clean_up(struct whc *whc)
 	if (whc->qset_pool)
 		dma_pool_destroy(whc->qset_pool);
 
-	len   = whc->umc->resource.end - whc->umc->resource.start + 1;
+	len   = resource_size(&whc->umc->resource);
 	if (whc->base)
 		iounmap(whc->base);
 	if (whc->base_phys)
diff --git a/drivers/uwb/whc-rc.c b/drivers/uwb/whc-rc.c
index 70a004a..3ae3c70 100644
--- a/drivers/uwb/whc-rc.c
+++ b/drivers/uwb/whc-rc.c
@@ -222,7 +222,7 @@ int whcrc_setup_rc_umc(struct whcrc *whcrc)
 	struct umc_dev *umc_dev = whcrc->umc_dev;
 
 	whcrc->area = umc_dev->resource.start;
-	whcrc->rc_len = umc_dev->resource.end - umc_dev->resource.start + 1;
+	whcrc->rc_len = resource_size(&umc_dev->resource);
 	result = -EBUSY;
 	if (request_mem_region(whcrc->area, whcrc->rc_len, KBUILD_MODNAME) == NULL) {
 		dev_err(dev, "can't request URC region (%zu bytes @ 0x%lx): %d\n",
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
diff --git a/drivers/video/controlfb.c b/drivers/video/controlfb.c
index c225dcc..9075bea 100644
--- a/drivers/video/controlfb.c
+++ b/drivers/video/controlfb.c
@@ -709,11 +709,11 @@ static int __init control_of_init(struct device_node *dp)
 
 	/* Map in frame buffer and registers */
 	p->fb_orig_base = fb_res.start;
-	p->fb_orig_size = fb_res.end - fb_res.start + 1;
+	p->fb_orig_size = resource_size(&fb_res);
 	/* use the big-endian aperture (??) */
 	p->frame_buffer_phys = fb_res.start + 0x800000;
 	p->control_regs_phys = reg_res.start;
-	p->control_regs_size = reg_res.end - reg_res.start + 1;
+	p->control_regs_size = resource_size(&reg_res);
 
 	if (!p->fb_orig_base ||
 	    !request_mem_region(p->fb_orig_base,p->fb_orig_size,"controlfb")) {
diff --git a/drivers/video/mb862xx/mb862xxfbdrv.c b/drivers/video/mb862xx/mb862xxfbdrv.c
index f70bd63..ee1de3e 100644
--- a/drivers/video/mb862xx/mb862xxfbdrv.c
+++ b/drivers/video/mb862xx/mb862xxfbdrv.c
@@ -697,7 +697,7 @@ static int __devinit of_platform_mb862xx_probe(struct platform_device *ofdev)
 		goto fbrel;
 	}
 
-	res_size = 1 + res.end - res.start;
+	res_size = resource_size(&res);
 	par->res = request_mem_region(res.start, res_size, DRV_NAME);
 	if (par->res == NULL) {
 		dev_err(dev, "Cannot claim framebuffer/mmio\n");
@@ -787,7 +787,7 @@ static int __devexit of_platform_mb862xx_remove(struct platform_device *ofdev)
 {
 	struct fb_info *fbi = dev_get_drvdata(&ofdev->dev);
 	struct mb862xxfb_par *par = fbi->par;
-	resource_size_t res_size = 1 + par->res->end - par->res->start;
+	resource_size_t res_size = resource_size(par->res);
 	unsigned long reg;
 
 	dev_dbg(fbi->dev, "%s release\n", fbi->fix.id);
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index c3636d5..243d16f 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -406,8 +406,7 @@ int mdp_probe(struct platform_device *pdev)
 		goto error_get_irq;
 	}
 
-	mdp->base = ioremap(resource->start,
-			    resource->end - resource->start);
+	mdp->base = ioremap(resource->start, resource_size(resource));
 	if (mdp->base == 0) {
 		printk(KERN_ERR "msmfb: cannot allocate mdp regs!\n");
 		ret = -ENOMEM;
diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
index ec35130..c6e3b4f 100644
--- a/drivers/video/msm/msm_fb.c
+++ b/drivers/video/msm/msm_fb.c
@@ -525,10 +525,9 @@ static int setup_fbmem(struct msmfb_info *msmfb, struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	fb->fix.smem_start = resource->start;
-	fb->fix.smem_len = resource->end - resource->start;
-	fbram = ioremap(resource->start,
-			resource->end - resource->start);
-	if (fbram == 0) {
+	fb->fix.smem_len = resource_size(resource);
+	fbram = ioremap(resource->start, resource_size(resource));
+	if (fbram == NULL) {
 		printk(KERN_ERR "msmfb: cannot allocate fbram!\n");
 		return -ENOMEM;
 	}
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
diff --git a/drivers/video/platinumfb.c b/drivers/video/platinumfb.c
index ef532d9..f27ae16 100644
--- a/drivers/video/platinumfb.c
+++ b/drivers/video/platinumfb.c
@@ -567,7 +567,7 @@ static int __devinit platinumfb_probe(struct platform_device* odev)
 	 * northbridge and that can fail. Only request framebuffer
 	 */
 	if (!request_mem_region(pinfo->rsrc_fb.start,
-				pinfo->rsrc_fb.end - pinfo->rsrc_fb.start + 1,
+				resource_size(&pinfo->rsrc_fb),
 				"platinumfb framebuffer")) {
 		printk(KERN_ERR "platinumfb: Can't request framebuffer !\n");
 		framebuffer_release(info);
@@ -658,8 +658,7 @@ static int __devexit platinumfb_remove(struct platform_device* odev)
 	iounmap(pinfo->cmap_regs);
 
 	release_mem_region(pinfo->rsrc_fb.start,
-			   pinfo->rsrc_fb.end -
-			   pinfo->rsrc_fb.start + 1);
+			   resource_size(&pinfo->rsrc_fb));
 
 	release_mem_region(pinfo->cmap_regs_phys, 0x1000);
 
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
diff --git a/include/linux/dio.h b/include/linux/dio.h
index b2dd31c..2cc0fd0 100644
--- a/include/linux/dio.h
+++ b/include/linux/dio.h
@@ -254,7 +254,7 @@ static inline struct dio_driver *dio_dev_driver(const struct dio_dev *d)
 
 #define dio_resource_start(d) ((d)->resource.start)
 #define dio_resource_end(d)   ((d)->resource.end)
-#define dio_resource_len(d)   ((d)->resource.end-(d)->resource.start+1)
+#define dio_resource_len(d)   (resource_size(&(d)->resource))
 #define dio_resource_flags(d) ((d)->resource.flags)
 
 #define dio_request_device(d, name) \
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
 
 
diff --git a/include/linux/zorro.h b/include/linux/zorro.h
index 7bf9db5..dff4202 100644
--- a/include/linux/zorro.h
+++ b/include/linux/zorro.h
@@ -187,7 +187,7 @@ extern struct zorro_dev *zorro_find_device(zorro_id id,
 
 #define zorro_resource_start(z)	((z)->resource.start)
 #define zorro_resource_end(z)	((z)->resource.end)
-#define zorro_resource_len(z)	((z)->resource.end-(z)->resource.start+1)
+#define zorro_resource_len(z)	(resource_size(&(z)->resource))
 #define zorro_resource_flags(z)	((z)->resource.flags)
 
 #define zorro_request_device(z, name) \
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 8d814cb..296fbc8 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1095,7 +1095,7 @@ size_t crash_get_memory_size(void)
 	size_t size = 0;
 	mutex_lock(&kexec_mutex);
 	if (crashk_res.end != crashk_res.start)
-		size = crashk_res.end - crashk_res.start + 1;
+		size = resource_size(&crashk_res);
 	mutex_unlock(&kexec_mutex);
 	return size;
 }
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 3ff8cc5..0106583 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -262,8 +262,7 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 		 */
 		dev->allocated_resource[i] =
 			request_mem_region(dev->resources[i].start,
-					   dev->resources[i].end -
-					   dev->resources[i].start + 1,
+					   resource_size(&dev->resources[i]),
 					   dev->rnames[i]);
 		if (!dev->allocated_resource[i]) {
 			printk(KERN_ERR "i2sbus: failed to claim resource %d!\n", i);
@@ -272,19 +271,19 @@ static int i2sbus_add_dev(struct macio_dev *macio,
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
diff --git a/sound/ppc/pmac.c b/sound/ppc/pmac.c
index 3ecbd67..ab96cde 100644
--- a/sound/ppc/pmac.c
+++ b/sound/ppc/pmac.c
@@ -881,8 +881,7 @@ static int snd_pmac_free(struct snd_pmac *chip)
 		for (i = 0; i < 3; i++) {
 			if (chip->requested & (1 << i))
 				release_mem_region(chip->rsrc[i].start,
-						   chip->rsrc[i].end -
-						   chip->rsrc[i].start + 1);
+						   resource_size(&chip->rsrc[i]));
 		}
 	}
 
@@ -1228,8 +1227,7 @@ int __devinit snd_pmac_new(struct snd_card *card, struct snd_pmac **chip_return)
 				goto __error;
 			}
 			if (request_mem_region(chip->rsrc[i].start,
-					       chip->rsrc[i].end -
-					       chip->rsrc[i].start + 1,
+					       resource_size(&chip->rsrc[i]),
 					       rnames[i]) == NULL) {
 				printk(KERN_ERR "snd: can't request rsrc "
 				       " %d (%s: %pR)\n",
@@ -1254,8 +1252,7 @@ int __devinit snd_pmac_new(struct snd_card *card, struct snd_pmac **chip_return)
 				goto __error;
 			}
 			if (request_mem_region(chip->rsrc[i].start,
-					       chip->rsrc[i].end -
-					       chip->rsrc[i].start + 1,
+					       resource_size(&chip->rsrc[i]),
 					       rnames[i]) == NULL) {
 				printk(KERN_ERR "snd: can't request rsrc "
 				       " %d (%s: %pR)\n",
diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 313e0cc..6a882aa 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -678,7 +678,7 @@ static int __devinit fsl_ssi_probe(struct platform_device *pdev)
 		kfree(ssi_private);
 		return ret;
 	}
-	ssi_private->ssi = ioremap(res.start, 1 + res.end - res.start);
+	ssi_private->ssi = ioremap(res.start, resource_size(&res));
 	ssi_private->ssi_phys = res.start;
 	ssi_private->irq = irq_of_parse_and_map(np, 0);
 
diff --git a/sound/soc/fsl/mpc5200_dma.c b/sound/soc/fsl/mpc5200_dma.c
index fff695c..8602314 100644
--- a/sound/soc/fsl/mpc5200_dma.c
+++ b/sound/soc/fsl/mpc5200_dma.c
@@ -384,7 +384,7 @@ static int mpc5200_hpcd_probe(struct of_device *op)
 		dev_err(&op->dev, "Missing reg property\n");
 		return -ENODEV;
 	}
-	regs = ioremap(res.start, 1 + res.end - res.start);
+	regs = ioremap(res.start, resource_size(&res));
 	if (!regs) {
 		dev_err(&op->dev, "Could not map registers\n");
 		return -ENODEV;
-- 
1.7.6.rc0



