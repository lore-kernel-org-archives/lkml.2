Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0CRPW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:22:56 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:47767 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0CRPWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:22:45 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [V2 PATCH 06/10] of/drivers: Always use struct device.of_node to get
	node pointer
To: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Date: Thu, 18 Mar 2010 09:22:39 -0600
Message-ID: <20100318152238.21082.10985.stgit@angua>
In-Reply-To: <20100318144836.21082.93040.stgit@angua>
References: <20100318144836.21082.93040.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following structure elements duplicate the information in
'struct device.of_node' and so are being eliminated.  This patches
makes all readers of the following elements use device.of_node instead.

struct dev_archdata.prom_node (sparc)
struct dev_archdata.of_node (powerpc)
struct of_device.node

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/ata/pata_macio.c                      |    2 +-
 drivers/ata/pata_mpc52xx.c                    |   10 ++++-----
 drivers/ata/pata_of_platform.c                |    2 +-
 drivers/atm/fore200e.c                        |   16 ++++++++------
 drivers/block/xsysace.c                       |    8 ++++---
 drivers/cdrom/viocd.c                         |    2 +-
 drivers/char/hw_random/n2-drv.c               |    2 +-
 drivers/char/hw_random/pasemi-rng.c           |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c              |    4 ++--
 drivers/char/viotape.c                        |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c    |    6 +++--
 drivers/gpio/pca953x.c                        |    2 +-
 drivers/i2c/busses/i2c-ibm_iic.c              |    4 ++--
 drivers/i2c/busses/i2c-mpc.c                  |   17 ++++++++-------
 drivers/ide/pmac.c                            |   10 ++++-----
 drivers/infiniband/hw/ehca/ehca_main.c        |   11 +++++-----
 drivers/input/serio/i8042-sparcio.h           |    2 +-
 drivers/input/serio/xilinx_ps2.c              |    8 ++++---
 drivers/leds/leds-gpio.c                      |    2 +-
 drivers/macintosh/macio_asic.c                |   16 +++++++-------
 drivers/macintosh/macio_sysfs.c               |    6 +++--
 drivers/macintosh/rack-meter.c                |    4 ++--
 drivers/macintosh/therm_pm72.c                |    2 +-
 drivers/mmc/host/of_mmc_spi.c                 |    4 ++--
 drivers/mmc/host/sdhci-of-core.c              |    2 +-
 drivers/mtd/maps/physmap_of.c                 |    6 +++--
 drivers/mtd/maps/sun_uflash.c                 |    2 +-
 drivers/mtd/nand/fsl_elbc_nand.c              |    6 +++--
 drivers/mtd/nand/pasemi_nand.c                |    2 +-
 drivers/net/can/sja1000/sja1000_of_platform.c |    4 ++--
 drivers/net/ehea/ehea_main.c                  |   14 ++++++-------
 drivers/net/fec_mpc52xx.c                     |   12 +++++------
 drivers/net/fec_mpc52xx_phy.c                 |    4 ++--
 drivers/net/greth.c                           |    3 ++-
 drivers/net/ibm_newemac/core.c                |   13 ++++++------
 drivers/net/ibm_newemac/debug.c               |    9 ++++----
 drivers/net/ibm_newemac/debug.h               |    4 ++--
 drivers/net/ibm_newemac/mal.c                 |   28 +++++++++++++------------
 drivers/net/ibm_newemac/rgmii.c               |   12 +++++------
 drivers/net/ibm_newemac/tah.c                 |    7 ++++--
 drivers/net/ibm_newemac/zmii.c                |    9 ++++----
 drivers/net/ll_temac_main.c                   |   10 ++++-----
 drivers/net/myri_sbus.c                       |    2 +-
 drivers/net/niu.c                             |   10 ++++-----
 drivers/net/phy/mdio-gpio.c                   |    6 +++--
 drivers/net/sunbmac.c                         |    6 +++--
 drivers/net/sunhme.c                          |    8 ++++---
 drivers/net/sunlance.c                        |    6 +++--
 drivers/net/sunqe.c                           |    6 +++--
 drivers/net/xilinx_emaclite.c                 |   10 ++++-----
 drivers/of/device.c                           |   20 +++++++++---------
 drivers/of/of_i2c.c                           |    2 +-
 drivers/of/of_mdio.c                          |    4 ++--
 drivers/pcmcia/electra_cf.c                   |    2 +-
 drivers/sbus/char/bbc_envctrl.c               |    4 ++--
 drivers/sbus/char/bbc_i2c.c                   |    4 ++--
 drivers/sbus/char/display7seg.c               |    2 +-
 drivers/sbus/char/envctrl.c                   |    2 +-
 drivers/sbus/char/flash.c                     |    4 ++--
 drivers/sbus/char/uctrl.c                     |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |    2 +-
 drivers/scsi/qlogicpti.c                      |   10 ++++-----
 drivers/scsi/sun_esp.c                        |   16 +++++++-------
 drivers/serial/apbuart.c                      |    2 +-
 drivers/serial/mpc52xx_uart.c                 |    8 ++++---
 drivers/serial/nwpserial.c                    |    2 +-
 drivers/serial/of_serial.c                    |    4 ++--
 drivers/serial/pmac_zilog.c                   |    2 +-
 drivers/serial/sunhv.c                        |    2 +-
 drivers/serial/sunsab.c                       |    6 +++--
 drivers/serial/sunsu.c                        |    6 +++--
 drivers/serial/sunzilog.c                     |    8 ++++---
 drivers/serial/uartlite.c                     |    6 +++--
 drivers/spi/mpc52xx_psc_spi.c                 |   11 +++++-----
 drivers/spi/mpc52xx_spi.c                     |   14 ++++++-------
 drivers/spi/spi_mpc8xxx.c                     |    6 +++--
 drivers/usb/host/ehci-ppc-of.c                |    2 +-
 drivers/usb/host/isp1760-if.c                 |    2 +-
 drivers/usb/host/ohci-ppc-of.c                |    2 +-
 drivers/video/cg6.c                           |    2 +-
 drivers/video/ffb.c                           |    2 +-
 drivers/video/fsl-diu-fb.c                    |    2 +-
 drivers/video/xilinxfb.c                      |   18 ++++++++--------
 drivers/watchdog/cpwd.c                       |    2 +-
 sound/aoa/fabrics/layout.c                    |    2 +-
 sound/aoa/soundbus/core.c                     |    8 ++++---
 sound/aoa/soundbus/i2sbus/control.c           |    2 +-
 sound/aoa/soundbus/i2sbus/core.c              |    4 ++--
 sound/aoa/soundbus/sysfs.c                    |    4 ++--
 sound/soc/fsl/mpc8610_hpcd.c                  |    2 +-
 sound/sparc/cs4231.c                          |    6 +++--
 sound/sparc/dbri.c                            |    2 +-
 93 files changed, 285 insertions(+), 275 deletions(-)

diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 4cc7bbd..2cf31e7 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -1138,7 +1138,7 @@ static int __devinit pata_macio_attach(struct macio_dev *mdev,
 			"Failed to allocate private memory\n");
 		return -ENOMEM;
 	}
-	priv->node = of_node_get(mdev->ofdev.node);
+	priv->node = of_node_get(mdev->ofdev.dev.of_node);
 	priv->mdev = mdev;
 	priv->dev = &mdev->ofdev.dev;
 
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 2bc2dbe..4635b55 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -694,7 +694,7 @@ mpc52xx_ata_probe(struct of_device *op, const struct of_device_id *match)
 	struct bcom_task *dmatsk = NULL;
 
 	/* Get ipb frequency */
-	ipb_freq = mpc5xxx_get_bus_frequency(op->node);
+	ipb_freq = mpc5xxx_get_bus_frequency(op->dev.of_node);
 	if (!ipb_freq) {
 		dev_err(&op->dev, "could not determine IPB bus frequency\n");
 		return -ENODEV;
@@ -702,7 +702,7 @@ mpc52xx_ata_probe(struct of_device *op, const struct of_device_id *match)
 
 	/* Get device base address from device tree, request the region
 	 * and ioremap it. */
-	rv = of_address_to_resource(op->node, 0, &res_mem);
+	rv = of_address_to_resource(op->dev.of_node, 0, &res_mem);
 	if (rv) {
 		dev_err(&op->dev, "could not determine device base address\n");
 		return rv;
@@ -735,14 +735,14 @@ mpc52xx_ata_probe(struct of_device *op, const struct of_device_id *match)
 	 * The MPC5200 ATA controller supports MWDMA modes 0, 1 and 2 and
 	 * UDMA modes 0, 1 and 2.
 	 */
-	prop = of_get_property(op->node, "mwdma-mode", &proplen);
+	prop = of_get_property(op->dev.of_node, "mwdma-mode", &proplen);
 	if ((prop) && (proplen >= 4))
 		mwdma_mask = ATA_MWDMA2 & ((1 << (*prop + 1)) - 1);
-	prop = of_get_property(op->node, "udma-mode", &proplen);
+	prop = of_get_property(op->dev.of_node, "udma-mode", &proplen);
 	if ((prop) && (proplen >= 4))
 		udma_mask = ATA_UDMA2 & ((1 << (*prop + 1)) - 1);
 
-	ata_irq = irq_of_parse_and_map(op->node, 0);
+	ata_irq = irq_of_parse_and_map(op->dev.of_node, 0);
 	if (ata_irq == NO_IRQ) {
 		dev_err(&op->dev, "error mapping irq\n");
 		return -EINVAL;
diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index 1f18ad9..19da29f 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -18,7 +18,7 @@ static int __devinit pata_of_platform_probe(struct of_device *ofdev,
 					    const struct of_device_id *match)
 {
 	int ret;
-	struct device_node *dn = ofdev->node;
+	struct device_node *dn = ofdev->dev.of_node;
 	struct resource io_res;
 	struct resource ctl_res;
 	struct resource irq_res;
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index f7d6eba..593a03a 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -789,7 +789,7 @@ static int __init fore200e_sba_map(struct fore200e *fore200e)
 	fore200e->bus->write(0x02, fore200e->regs.sba.isr); /* XXX hardwired interrupt level */
 
 	/* get the supported DVMA burst sizes */
-	bursts = of_getintprop_default(op->node->parent, "burst-sizes", 0x00);
+	bursts = of_getintprop_default(op->dev.of_node->parent, "burst-sizes", 0x00);
 
 	if (sbus_can_dma_64bit())
 		sbus_set_sbus64(&op->dev, bursts);
@@ -820,18 +820,20 @@ static int __init fore200e_sba_prom_read(struct fore200e *fore200e, struct prom_
 	const u8 *prop;
 	int len;
 
-	prop = of_get_property(op->node, "madaddrlo2", &len);
+	prop = of_get_property(op->dev.of_node, "madaddrlo2", &len);
 	if (!prop)
 		return -ENODEV;
 	memcpy(&prom->mac_addr[4], prop, 4);
 
-	prop = of_get_property(op->node, "madaddrhi4", &len);
+	prop = of_get_property(op->dev.of_node, "madaddrhi4", &len);
 	if (!prop)
 		return -ENODEV;
 	memcpy(&prom->mac_addr[2], prop, 4);
 
-	prom->serial_number = of_getintprop_default(op->node, "serialnumber", 0);
-	prom->hw_revision = of_getintprop_default(op->node, "promversion", 0);
+	prom->serial_number = of_getintprop_default(op->dev.of_node,
+						    "serialnumber", 0);
+	prom->hw_revision = of_getintprop_default(op->dev.of_node,
+						  "promversion", 0);
     
 	return 0;
 }
@@ -841,10 +843,10 @@ static int fore200e_sba_proc_read(struct fore200e *fore200e, char *page)
 	struct of_device *op = fore200e->bus_dev;
 	const struct linux_prom_registers *regs;
 
-	regs = of_get_property(op->node, "reg", NULL);
+	regs = of_get_property(op->dev.of_node, "reg", NULL);
 
 	return sprintf(page, "   SBUS slot/device:\t\t%d/'%s'\n",
-		       (regs ? regs->which_io : 0), op->node->name);
+		       (regs ? regs->which_io : 0), op->dev.of_node->name);
 }
 #endif /* CONFIG_SBUS */
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index e1c95e2..3094909 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1198,10 +1198,10 @@ ace_of_probe(struct of_device *op, const struct of_device_id *match)
 	dev_dbg(&op->dev, "ace_of_probe(%p, %p)\n", op, match);
 
 	/* device id */
-	id = of_get_property(op->node, "port-number", NULL);
+	id = of_get_property(op->dev.of_node, "port-number", NULL);
 
 	/* physaddr */
-	rc = of_address_to_resource(op->node, 0, &res);
+	rc = of_address_to_resource(op->dev.of_node, 0, &res);
 	if (rc) {
 		dev_err(&op->dev, "invalid address\n");
 		return rc;
@@ -1209,11 +1209,11 @@ ace_of_probe(struct of_device *op, const struct of_device_id *match)
 	physaddr = res.start;
 
 	/* irq */
-	irq = irq_of_parse_and_map(op->node, 0);
+	irq = irq_of_parse_and_map(op->dev.of_node, 0);
 
 	/* bus width */
 	bus_width = ACE_BUS_WIDTH_16;
-	if (of_find_property(op->node, "8-bit", NULL))
+	if (of_find_property(op->dev.of_node, "8-bit", NULL))
 		bus_width = ACE_BUS_WIDTH_8;
 
 	/* Call the bus-independant setup code */
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index cc435be..451cd70 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -567,7 +567,7 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	struct disk_info *d;
 	struct cdrom_device_info *c;
 	struct request_queue *q;
-	struct device_node *node = vdev->dev.archdata.of_node;
+	struct device_node *node = vdev->dev.of_node;
 
 	deviceno = vdev->unit_address;
 	if (deviceno >= VIOCD_MAX_CD)
diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 9b3e09c..4d05003 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -660,7 +660,7 @@ static int __devinit n2rng_probe(struct of_device *op,
 				np->hvapi_major);
 			goto out_hvapi_unregister;
 		}
-		np->num_units = of_getintprop_default(op->node,
+		np->num_units = of_getintprop_default(op->dev.of_node,
 						      "rng-#units", 0);
 		if (!np->num_units) {
 			dev_err(&op->dev, "VF RNG lacks rng-#units property\n");
diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index 7fa61dd..b213855 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -98,7 +98,7 @@ static int __devinit rng_probe(struct of_device *ofdev,
 			       const struct of_device_id *match)
 {
 	void __iomem *rng_regs;
-	struct device_node *rng_np = ofdev->node;
+	struct device_node *rng_np = ofdev->dev.of_node;
 	struct resource res;
 	int err = 0;
 
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 176f175..45305f2 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2406,7 +2406,7 @@ static int __devinit ipmi_of_probe(struct of_device *dev,
 	struct smi_info *info;
 	struct resource resource;
 	const int *regsize, *regspacing, *regshift;
-	struct device_node *np = dev->node;
+	struct device_node *np = dev->dev.of_node;
 	int ret;
 	int proplen;
 
@@ -2462,7 +2462,7 @@ static int __devinit ipmi_of_probe(struct of_device *dev,
 	info->io.regspacing	= regspacing ? *regspacing : DEFAULT_REGSPACING;
 	info->io.regshift	= regshift ? *regshift : 0;
 
-	info->irq		= irq_of_parse_and_map(dev->node, 0);
+	info->irq		= irq_of_parse_and_map(dev->dev.of_node, 0);
 	info->dev		= &dev->dev;
 
 	dev_dbg(&dev->dev, "addr 0x%lx regsize %d spacing %d irq %x\n",
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index 042c814..f37935c 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -865,7 +865,7 @@ static int viotape_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 {
 	int i = vdev->unit_address;
 	int j;
-	struct device_node *node = vdev->dev.archdata.of_node;
+	struct device_node *node = vdev->dev.of_node;
 
 	if (i >= VIOTAPE_MAX_TAPE)
 		return -ENODEV;
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 4846d50..061be2a 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -771,18 +771,18 @@ hwicap_of_probe(struct of_device *op, const struct of_device_id *match)
 
 	dev_dbg(&op->dev, "hwicap_of_probe(%p, %p)\n", op, match);
 
-	rc = of_address_to_resource(op->node, 0, &res);
+	rc = of_address_to_resource(op->dev.of_node, 0, &res);
 	if (rc) {
 		dev_err(&op->dev, "invalid address\n");
 		return rc;
 	}
 
-	id = of_get_property(op->node, "port-number", NULL);
+	id = of_get_property(op->dev.of_node, "port-number", NULL);
 
 	/* It's most likely that we're using V4, if the family is not
 	   specified */
 	regs = &v4_config_registers;
-	family = of_get_property(op->node, "xlnx,family", NULL);
+	family = of_get_property(op->dev.of_node, "xlnx,family", NULL);
 
 	if (family) {
 		if (!strcmp(family, "virtex2p")) {
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index ab5daab..abc9b8c 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -436,7 +436,7 @@ pca953x_get_alt_pdata(struct i2c_client *client)
 	struct device_node *node;
 	const uint16_t *val;
 
-	node = dev_archdata_get_node(&client->dev.archdata);
+	node = client->dev.of_node;
 	if (node == NULL)
 		return NULL;
 
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index b1bc6e2..e66dc83 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -664,7 +664,7 @@ static inline u8 iic_clckdiv(unsigned int opb)
 static int __devinit iic_request_irq(struct of_device *ofdev,
 				     struct ibm_iic_private *dev)
 {
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	int irq;
 
 	if (iic_force_poll)
@@ -695,7 +695,7 @@ static int __devinit iic_request_irq(struct of_device *ofdev,
 static int __devinit iic_probe(struct of_device *ofdev,
 			       const struct of_device_id *match)
 {
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct ibm_iic_private *dev;
 	struct i2c_adapter *adap;
 	const u32 *freq;
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 78a15af..0123a6e 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -559,14 +559,14 @@ static int __devinit fsl_i2c_probe(struct of_device *op,
 
 	init_waitqueue_head(&i2c->queue);
 
-	i2c->base = of_iomap(op->node, 0);
+	i2c->base = of_iomap(op->dev.of_node, 0);
 	if (!i2c->base) {
 		dev_err(i2c->dev, "failed to map controller\n");
 		result = -ENOMEM;
 		goto fail_map;
 	}
 
-	i2c->irq = irq_of_parse_and_map(op->node, 0);
+	i2c->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 	if (i2c->irq != NO_IRQ) { /* i2c->irq = NO_IRQ implies polling */
 		result = request_irq(i2c->irq, mpc_i2c_isr,
 				     IRQF_SHARED, "i2c-mpc", i2c);
@@ -576,21 +576,22 @@ static int __devinit fsl_i2c_probe(struct of_device *op,
 		}
 	}
 
-	if (of_get_property(op->node, "fsl,preserve-clocking", NULL)) {
+	if (of_get_property(op->dev.of_node, "fsl,preserve-clocking", NULL)) {
 		clock = MPC_I2C_CLOCK_PRESERVE;
 	} else {
-		prop = of_get_property(op->node, "clock-frequency", &plen);
+		prop = of_get_property(op->dev.of_node, "clock-frequency",
+					&plen);
 		if (prop && plen == sizeof(u32))
 			clock = *prop;
 	}
 
 	if (match->data) {
 		struct mpc_i2c_data *data = match->data;
-		data->setup(op->node, i2c, clock, data->prescaler);
+		data->setup(op->dev.of_node, i2c, clock, data->prescaler);
 	} else {
 		/* Backwards compatibility */
-		if (of_get_property(op->node, "dfsrr", NULL))
-			mpc_i2c_setup_8xxx(op->node, i2c, clock, 0);
+		if (of_get_property(op->dev.of_node, "dfsrr", NULL))
+			mpc_i2c_setup_8xxx(op->dev.of_node, i2c, clock, 0);
 	}
 
 	dev_set_drvdata(&op->dev, i2c);
@@ -604,7 +605,7 @@ static int __devinit fsl_i2c_probe(struct of_device *op,
 		dev_err(i2c->dev, "failed to add adapter\n");
 		goto fail_add;
 	}
-	of_register_i2c_devices(&i2c->adap, op->node);
+	of_register_i2c_devices(&i2c->adap, op->dev.of_node);
 
 	return result;
 
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index 850ee45..9697de9 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1152,7 +1152,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 
 	if (macio_resource_count(mdev) == 0) {
 		printk(KERN_WARNING "ide-pmac: no address for %s\n",
-				    mdev->ofdev.node->full_name);
+				    mdev->ofdev.dev.of_node->full_name);
 		rc = -ENXIO;
 		goto out_free_pmif;
 	}
@@ -1160,7 +1160,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	/* Request memory resource for IO ports */
 	if (macio_request_resource(mdev, 0, "ide-pmac (ports)")) {
 		printk(KERN_ERR "ide-pmac: can't request MMIO resource for "
-				"%s!\n", mdev->ofdev.node->full_name);
+				"%s!\n", mdev->ofdev.dev.of_node->full_name);
 		rc = -EBUSY;
 		goto out_free_pmif;
 	}
@@ -1172,7 +1172,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	 */
 	if (macio_irq_count(mdev) == 0) {
 		printk(KERN_WARNING "ide-pmac: no intrs for device %s, using "
-				    "13\n", mdev->ofdev.node->full_name);
+				    "13\n", mdev->ofdev.dev.of_node->full_name);
 		irq = irq_create_mapping(NULL, 13);
 	} else
 		irq = macio_irq(mdev, 0);
@@ -1181,7 +1181,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	regbase = (unsigned long) base;
 
 	pmif->mdev = mdev;
-	pmif->node = mdev->ofdev.node;
+	pmif->node = mdev->ofdev.dev.of_node;
 	pmif->regbase = regbase;
 	pmif->irq = irq;
 	pmif->kauai_fcr = NULL;
@@ -1190,7 +1190,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match)
 		if (macio_request_resource(mdev, 1, "ide-pmac (dma)"))
 			printk(KERN_WARNING "ide-pmac: can't request DMA "
 					    "resource for %s!\n",
-					    mdev->ofdev.node->full_name);
+					    mdev->ofdev.dev.of_node->full_name);
 		else
 			pmif->dma_regs = ioremap(macio_resource_start(mdev, 1), 0x1000);
 	} else
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 129a6be..2639185 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -291,8 +291,9 @@ static int ehca_sense_attributes(struct ehca_shca *shca)
 	};
 
 	ehca_gen_dbg("Probing adapter %s...",
-		     shca->ofdev->node->full_name);
-	loc_code = of_get_property(shca->ofdev->node, "ibm,loc-code", NULL);
+		     shca->ofdev->dev.of_node->full_name);
+	loc_code = of_get_property(shca->ofdev->dev.of_node, "ibm,loc-code",
+				   NULL);
 	if (loc_code)
 		ehca_gen_dbg(" ... location lode=%s", loc_code);
 
@@ -720,16 +721,16 @@ static int __devinit ehca_probe(struct of_device *dev,
 	int ret, i, eq_size;
 	unsigned long flags;
 
-	handle = of_get_property(dev->node, "ibm,hca-handle", NULL);
+	handle = of_get_property(dev->dev.of_node, "ibm,hca-handle", NULL);
 	if (!handle) {
 		ehca_gen_err("Cannot get eHCA handle for adapter: %s.",
-			     dev->node->full_name);
+			     dev->dev.of_node->full_name);
 		return -ENODEV;
 	}
 
 	if (!(*handle)) {
 		ehca_gen_err("Wrong eHCA handle for adapter: %s.",
-			     dev->node->full_name);
+			     dev->dev.of_node->full_name);
 		return -ENODEV;
 	}
 
diff --git a/drivers/input/serio/i8042-sparcio.h b/drivers/input/serio/i8042-sparcio.h
index 5071af2..29e1769 100644
--- a/drivers/input/serio/i8042-sparcio.h
+++ b/drivers/input/serio/i8042-sparcio.h
@@ -51,7 +51,7 @@ static inline void i8042_write_command(int val)
 
 static int __devinit sparc_i8042_probe(struct of_device *op, const struct of_device_id *match)
 {
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 
 	dp = dp->child;
 	while (dp) {
diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
index 8298e1f..f154153 100644
--- a/drivers/input/serio/xilinx_ps2.c
+++ b/drivers/input/serio/xilinx_ps2.c
@@ -243,17 +243,17 @@ static int __devinit xps2_of_probe(struct of_device *ofdev,
 	int error;
 
 	dev_info(dev, "Device Tree Probing \'%s\'\n",
-			ofdev->node->name);
+			ofdev->dev.of_node->name);
 
 	/* Get iospace for the device */
-	error = of_address_to_resource(ofdev->node, 0, &r_mem);
+	error = of_address_to_resource(ofdev->dev.of_node, 0, &r_mem);
 	if (error) {
 		dev_err(dev, "invalid address\n");
 		return error;
 	}
 
 	/* Get IRQ for the device */
-	if (of_irq_to_resource(ofdev->node, 0, &r_irq) == NO_IRQ) {
+	if (of_irq_to_resource(ofdev->dev.of_node, 0, &r_irq) == NO_IRQ) {
 		dev_err(dev, "no IRQ found\n");
 		return -ENODEV;
 	}
@@ -341,7 +341,7 @@ static int __devexit xps2_of_remove(struct of_device *of_dev)
 	iounmap(drvdata->base_address);
 
 	/* Get iospace of the device */
-	if (of_address_to_resource(of_dev->node, 0, &r_mem))
+	if (of_address_to_resource(of_dev->dev.of_node, 0, &r_mem))
 		dev_err(dev, "invalid address\n");
 	else
 		release_mem_region(r_mem.start, resource_size(&r_mem));
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index e5225d2..7ff758a 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -210,7 +210,7 @@ struct gpio_led_of_platform_data {
 static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
 					const struct of_device_id *match)
 {
-	struct device_node *np = ofdev->node, *child;
+	struct device_node *np = ofdev->dev.of_node, *child;
 	struct gpio_led led;
 	struct gpio_led_of_platform_data *pdata;
 	int count = 0, ret;
diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index 26a303a..67fe13f 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -248,7 +248,7 @@ static void macio_create_fixup_irq(struct macio_dev *dev, int index,
 
 static void macio_add_missing_resources(struct macio_dev *dev)
 {
-	struct device_node *np = dev->ofdev.node;
+	struct device_node *np = dev->ofdev.dev.of_node;
 	unsigned int irq_base;
 
 	/* Gatwick has some missing interrupts on child nodes */
@@ -289,7 +289,7 @@ static void macio_add_missing_resources(struct macio_dev *dev)
 
 static void macio_setup_interrupts(struct macio_dev *dev)
 {
-	struct device_node *np = dev->ofdev.node;
+	struct device_node *np = dev->ofdev.dev.of_node;
 	unsigned int irq;
 	int i = 0, j = 0;
 
@@ -317,7 +317,7 @@ static void macio_setup_interrupts(struct macio_dev *dev)
 static void macio_setup_resources(struct macio_dev *dev,
 				  struct resource *parent_res)
 {
-	struct device_node *np = dev->ofdev.node;
+	struct device_node *np = dev->ofdev.dev.of_node;
 	struct resource r;
 	int index;
 
@@ -373,7 +373,7 @@ static struct macio_dev * macio_add_one_device(struct macio_chip *chip,
 
 	dev->bus = &chip->lbus;
 	dev->media_bay = in_bay;
-	dev->ofdev.node = np;
+	dev->ofdev.dev.of_node = np;
 	dev->ofdev.dma_mask = 0xffffffffUL;
 	dev->ofdev.dev.dma_mask = &dev->ofdev.dma_mask;
 	dev->ofdev.dev.parent = parent;
@@ -494,9 +494,9 @@ static void macio_pci_add_devices(struct macio_chip *chip)
 	}
 
 	/* Add media bay devices if any */
+	pnode = mbdev->ofdev.dev.of_node;
 	if (mbdev)
-		for (np = NULL; (np = of_get_next_child(mbdev->ofdev.node, np))
-			     != NULL;) {
+		for (np = NULL; (np = of_get_next_child(pnode, np)) != NULL;) {
 			if (macio_skip_device(np))
 				continue;
 			of_node_get(np);
@@ -506,9 +506,9 @@ static void macio_pci_add_devices(struct macio_chip *chip)
 		}
 
 	/* Add serial ports if any */
+	pnode = sdev->ofdev.dev.of_node;
 	if (sdev) {
-		for (np = NULL; (np = of_get_next_child(sdev->ofdev.node, np))
-			     != NULL;) {
+		for (np = NULL; (np = of_get_next_child(pnode, np)) != NULL;) {
 			if (macio_skip_device(np))
 				continue;
 			of_node_get(np);
diff --git a/drivers/macintosh/macio_sysfs.c b/drivers/macintosh/macio_sysfs.c
index 9e9453b..6999ce5 100644
--- a/drivers/macintosh/macio_sysfs.c
+++ b/drivers/macintosh/macio_sysfs.c
@@ -9,7 +9,7 @@ field##_show (struct device *dev, struct device_attribute *attr,	\
               char *buf)						\
 {									\
 	struct macio_dev *mdev = to_macio_device (dev);			\
-	return sprintf (buf, format_string, mdev->ofdev.node->field);	\
+	return sprintf (buf, format_string, mdev->ofdev.dev.of_node->field); \
 }
 
 static ssize_t
@@ -21,7 +21,7 @@ compatible_show (struct device *dev, struct device_attribute *attr, char *buf)
 	int length = 0;
 
 	of = &to_macio_device (dev)->ofdev;
-	compat = of_get_property(of->node, "compatible", &cplen);
+	compat = of_get_property(of->dev.of_node, "compatible", &cplen);
 	if (!compat) {
 		*buf = '\0';
 		return 0;
@@ -58,7 +58,7 @@ static ssize_t devspec_show(struct device *dev,
 	struct of_device *ofdev;
 
 	ofdev = to_of_device(dev);
-	return sprintf(buf, "%s\n", ofdev->node->full_name);
+	return sprintf(buf, "%s\n", ofdev->dev.of_node->full_name);
 }
 
 macio_config_of_attr (name, "%s\n");
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index 93fb320..6a715d0 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -374,7 +374,7 @@ static int __devinit rackmeter_probe(struct macio_dev* mdev,
 	pr_debug("rackmeter_probe()\n");
 
 	/* Get i2s-a node */
-	while ((i2s = of_get_next_child(mdev->ofdev.node, i2s)) != NULL)
+	while ((i2s = of_get_next_child(mdev->ofdev.dev.of_node, i2s)) != NULL)
 	       if (strcmp(i2s->name, "i2s-a") == 0)
 		       break;
 	if (i2s == NULL) {
@@ -430,7 +430,7 @@ static int __devinit rackmeter_probe(struct macio_dev* mdev,
 	    of_address_to_resource(i2s, 1, &rdma)) {
 		printk(KERN_ERR
 		       "rackmeter: found match but lacks resources: %s",
-		       mdev->ofdev.node->full_name);
+		       mdev->ofdev.dev.of_node->full_name);
 		rc = -ENXIO;
 		goto bail_free;
 	}
diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index 5738d8b..f5b0f9e 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -2198,7 +2198,7 @@ static int fcu_of_probe(struct of_device* dev, const struct of_device_id *match)
 	state = state_detached;
 
 	/* Lookup the fans in the device tree */
-	fcu_lookup_fans(dev->node);
+	fcu_lookup_fans(dev->dev.of_node);
 
 	/* Add the driver */
 	return i2c_add_driver(&therm_pm72_driver);
diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
index 0c7a63c..a1ec5d0 100644
--- a/drivers/mmc/host/of_mmc_spi.c
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -63,7 +63,7 @@ static int of_mmc_spi_get_ro(struct device *dev)
 struct mmc_spi_platform_data *mmc_spi_get_pdata(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
-	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	struct device_node *np = dev->of_node;
 	struct of_mmc_spi *oms;
 	const u32 *voltage_ranges;
 	int num_ranges;
@@ -134,7 +134,7 @@ EXPORT_SYMBOL(mmc_spi_get_pdata);
 void mmc_spi_put_pdata(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
-	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	struct device_node *np = dev->of_node;
 	struct of_mmc_spi *oms = to_of_mmc_spi(dev);
 	int i;
 
diff --git a/drivers/mmc/host/sdhci-of-core.c b/drivers/mmc/host/sdhci-of-core.c
index 55e3313..dfe5cea 100644
--- a/drivers/mmc/host/sdhci-of-core.c
+++ b/drivers/mmc/host/sdhci-of-core.c
@@ -118,7 +118,7 @@ static bool __devinit sdhci_of_wp_inverted(struct device_node *np)
 static int __devinit sdhci_of_probe(struct of_device *ofdev,
 				 const struct of_device_id *match)
 {
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct sdhci_of_data *sdhci_of_data = match->data;
 	struct sdhci_host *host;
 	struct sdhci_of_host *of_host;
diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 61e4eb4..494af8e 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -142,7 +142,7 @@ static int of_flash_remove(struct of_device *dev)
 static struct mtd_info * __devinit obsolete_probe(struct of_device *dev,
 						  struct map_info *map)
 {
-	struct device_node *dp = dev->node;
+	struct device_node *dp = dev->dev.of_node;
 	const char *of_probe;
 	struct mtd_info *mtd;
 	static const char *rom_probe_types[]
@@ -179,7 +179,7 @@ static int __devinit of_flash_probe(struct of_device *dev,
 	static const char *part_probe_types[]
 		= { "cmdlinepart", "RedBoot", NULL };
 #endif
-	struct device_node *dp = dev->node;
+	struct device_node *dp = dev->dev.of_node;
 	struct resource res;
 	struct of_flash *info;
 	const char *probe_type = match->data;
@@ -203,7 +203,7 @@ static int __devinit of_flash_probe(struct of_device *dev,
 	p = of_get_property(dp, "reg", &count);
 	if (count % reg_tuple_size != 0) {
 		dev_err(&dev->dev, "Malformed reg property on %s\n",
-				dev->node->full_name);
+				dev->dev.of_node->full_name);
 		err = -EINVAL;
 		goto err_flash_remove;
 	}
diff --git a/drivers/mtd/maps/sun_uflash.c b/drivers/mtd/maps/sun_uflash.c
index fd7a101..365811d 100644
--- a/drivers/mtd/maps/sun_uflash.c
+++ b/drivers/mtd/maps/sun_uflash.c
@@ -109,7 +109,7 @@ int uflash_devinit(struct of_device *op, struct device_node *dp)
 
 static int __devinit uflash_probe(struct of_device *op, const struct of_device_id *match)
 {
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 
 	/* Flashprom must have the "user" property in order to
 	 * be used by this driver.
diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index ae30fb6..4a60795 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -1030,14 +1030,14 @@ static int __devinit fsl_elbc_ctrl_probe(struct of_device *ofdev,
 	init_waitqueue_head(&ctrl->controller.wq);
 	init_waitqueue_head(&ctrl->irq_wait);
 
-	ctrl->regs = of_iomap(ofdev->node, 0);
+	ctrl->regs = of_iomap(ofdev->dev.of_node, 0);
 	if (!ctrl->regs) {
 		dev_err(&ofdev->dev, "failed to get memory region\n");
 		ret = -ENODEV;
 		goto err;
 	}
 
-	ctrl->irq = of_irq_to_resource(ofdev->node, 0, NULL);
+	ctrl->irq = of_irq_to_resource(ofdev->dev.of_node, 0, NULL);
 	if (ctrl->irq == NO_IRQ) {
 		dev_err(&ofdev->dev, "failed to get irq resource\n");
 		ret = -ENODEV;
@@ -1058,7 +1058,7 @@ static int __devinit fsl_elbc_ctrl_probe(struct of_device *ofdev,
 		goto err;
 	}
 
-	for_each_child_of_node(ofdev->node, child)
+	for_each_child_of_node(ofdev->dev.of_node, child)
 		if (of_device_is_compatible(child, "fsl,elbc-fcm-nand"))
 			fsl_elbc_chip_probe(ctrl, child);
 
diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index a8b9376..edfc27b 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -93,7 +93,7 @@ static int __devinit pasemi_nand_probe(struct of_device *ofdev,
 				      const struct of_device_id *match)
 {
 	struct pci_dev *pdev;
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct resource res;
 	struct nand_chip *chip;
 	int err = 0;
diff --git a/drivers/net/can/sja1000/sja1000_of_platform.c b/drivers/net/can/sja1000/sja1000_of_platform.c
index 9dd076a..dc5f20c 100644
--- a/drivers/net/can/sja1000/sja1000_of_platform.c
+++ b/drivers/net/can/sja1000/sja1000_of_platform.c
@@ -72,7 +72,7 @@ static int __devexit sja1000_ofp_remove(struct of_device *ofdev)
 {
 	struct net_device *dev = dev_get_drvdata(&ofdev->dev);
 	struct sja1000_priv *priv = netdev_priv(dev);
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct resource res;
 
 	dev_set_drvdata(&ofdev->dev, NULL);
@@ -91,7 +91,7 @@ static int __devexit sja1000_ofp_remove(struct of_device *ofdev)
 static int __devinit sja1000_ofp_probe(struct of_device *ofdev,
 				       const struct of_device_id *id)
 {
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct net_device *dev;
 	struct sja1000_priv *priv;
 	struct resource res;
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index b004eab..3cdc938 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -3034,7 +3034,7 @@ static DEVICE_ATTR(log_port_id, S_IRUSR | S_IRGRP | S_IROTH, ehea_show_port_id,
 static void __devinit logical_port_release(struct device *dev)
 {
 	struct ehea_port *port = container_of(dev, struct ehea_port, ofdev.dev);
-	of_node_put(port->ofdev.node);
+	of_node_put(port->ofdev.dev.of_node);
 }
 
 static struct device *ehea_register_port(struct ehea_port *port,
@@ -3042,7 +3042,7 @@ static struct device *ehea_register_port(struct ehea_port *port,
 {
 	int ret;
 
-	port->ofdev.node = of_node_get(dn);
+	port->ofdev.dev.of_node = of_node_get(dn);
 	port->ofdev.dev.parent = &port->adapter->ofdev->dev;
 	port->ofdev.dev.bus = &ibmebus_bus_type;
 
@@ -3209,7 +3209,7 @@ static int ehea_setup_ports(struct ehea_adapter *adapter)
 	const u32 *dn_log_port_id;
 	int i = 0;
 
-	lhea_dn = adapter->ofdev->node;
+	lhea_dn = adapter->ofdev->dev.of_node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
 		dn_log_port_id = of_get_property(eth_dn, "ibm,hea-port-no",
@@ -3248,7 +3248,7 @@ static struct device_node *ehea_get_eth_dn(struct ehea_adapter *adapter,
 	struct device_node *eth_dn = NULL;
 	const u32 *dn_log_port_id;
 
-	lhea_dn = adapter->ofdev->node;
+	lhea_dn = adapter->ofdev->dev.of_node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
 		dn_log_port_id = of_get_property(eth_dn, "ibm,hea-port-no",
@@ -3378,7 +3378,7 @@ static int __devinit ehea_probe_adapter(struct of_device *dev,
 	const u64 *adapter_handle;
 	int ret;
 
-	if (!dev || !dev->node) {
+	if (!dev || !dev->dev.of_node) {
 		ehea_error("Invalid ibmebus device probed");
 		return -EINVAL;
 	}
@@ -3394,14 +3394,14 @@ static int __devinit ehea_probe_adapter(struct of_device *dev,
 
 	adapter->ofdev = dev;
 
-	adapter_handle = of_get_property(dev->node, "ibm,hea-handle",
+	adapter_handle = of_get_property(dev->dev.of_node, "ibm,hea-handle",
 					 NULL);
 	if (adapter_handle)
 		adapter->handle = *adapter_handle;
 
 	if (!adapter->handle) {
 		dev_err(&dev->dev, "failed getting handle for adapter"
-			" '%s'\n", dev->node->full_name);
+			" '%s'\n", dev->dev.of_node->full_name);
 		ret = -ENODEV;
 		goto out_free_ad;
 	}
diff --git a/drivers/net/fec_mpc52xx.c b/drivers/net/fec_mpc52xx.c
index 0dbd721..1b7c5a0 100644
--- a/drivers/net/fec_mpc52xx.c
+++ b/drivers/net/fec_mpc52xx.c
@@ -872,7 +872,7 @@ mpc52xx_fec_probe(struct of_device *op, const struct of_device_id *match)
 	priv->ndev = ndev;
 
 	/* Reserve FEC control zone */
-	rv = of_address_to_resource(op->node, 0, &mem);
+	rv = of_address_to_resource(op->dev.of_node, 0, &mem);
 	if (rv) {
 		printk(KERN_ERR DRIVER_NAME ": "
 				"Error while parsing device node resource\n" );
@@ -920,7 +920,7 @@ mpc52xx_fec_probe(struct of_device *op, const struct of_device_id *match)
 
 	/* Get the IRQ we need one by one */
 		/* Control */
-	ndev->irq = irq_of_parse_and_map(op->node, 0);
+	ndev->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 
 		/* RX */
 	priv->r_irq = bcom_get_task_irq(priv->rx_dmatsk);
@@ -943,20 +943,20 @@ mpc52xx_fec_probe(struct of_device *op, const struct of_device_id *match)
 	/* Start with safe defaults for link connection */
 	priv->speed = 100;
 	priv->duplex = DUPLEX_HALF;
-	priv->mdio_speed = ((mpc5xxx_get_bus_frequency(op->node) >> 20) / 5) << 1;
+	priv->mdio_speed = ((mpc5xxx_get_bus_frequency(op->dev.of_node) >> 20) / 5) << 1;
 
 	/* The current speed preconfigures the speed of the MII link */
-	prop = of_get_property(op->node, "current-speed", &prop_size);
+	prop = of_get_property(op->dev.of_node, "current-speed", &prop_size);
 	if (prop && (prop_size >= sizeof(u32) * 2)) {
 		priv->speed = prop[0];
 		priv->duplex = prop[1] ? DUPLEX_FULL : DUPLEX_HALF;
 	}
 
 	/* If there is a phy handle, then get the PHY node */
-	priv->phy_node = of_parse_phandle(op->node, "phy-handle", 0);
+	priv->phy_node = of_parse_phandle(op->dev.of_node, "phy-handle", 0);
 
 	/* the 7-wire property means don't use MII mode */
-	if (of_find_property(op->node, "fsl,7-wire-mode", NULL)) {
+	if (of_find_property(op->dev.of_node, "fsl,7-wire-mode", NULL)) {
 		priv->seven_wire_mode = 1;
 		dev_info(&ndev->dev, "using 7-wire PHY mode\n");
 	}
diff --git a/drivers/net/fec_mpc52xx_phy.c b/drivers/net/fec_mpc52xx_phy.c
index ee0f3c6..2150b54 100644
--- a/drivers/net/fec_mpc52xx_phy.c
+++ b/drivers/net/fec_mpc52xx_phy.c
@@ -65,7 +65,7 @@ static int mpc52xx_fec_mdio_probe(struct of_device *of,
 		const struct of_device_id *match)
 {
 	struct device *dev = &of->dev;
-	struct device_node *np = of->node;
+	struct device_node *np = of->dev.of_node;
 	struct mii_bus *bus;
 	struct mpc52xx_fec_mdio_priv *priv;
 	struct resource res = {};
@@ -106,7 +106,7 @@ static int mpc52xx_fec_mdio_probe(struct of_device *of,
 
 	/* set MII speed */
 	out_be32(&priv->regs->mii_speed,
-		((mpc5xxx_get_bus_frequency(of->node) >> 20) / 5) << 1);
+		((mpc5xxx_get_bus_frequency(of->dev.of_node) >> 20) / 5) << 1);
 
 	err = of_mdiobus_register(bus, np);
 	if (err)
diff --git a/drivers/net/greth.c b/drivers/net/greth.c
index 2b9c1cb..04be634 100644
--- a/drivers/net/greth.c
+++ b/drivers/net/greth.c
@@ -1499,7 +1499,8 @@ static int __devinit greth_of_probe(struct of_device *ofdev, const struct of_dev
 	if (i == 6) {
 		const unsigned char *addr;
 		int len;
-		addr = of_get_property(ofdev->node, "local-mac-address", &len);
+		addr = of_get_property(ofdev->dev.of_node, "local-mac-address",
+					&len);
 		if (addr != NULL && len == 6) {
 			for (i = 0; i < 6; i++)
 				macaddr[i] = (unsigned int) addr[i];
diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index fb0ac6d..bad72ba 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -135,7 +135,8 @@ static inline void emac_report_timeout_error(struct emac_instance *dev,
 				  EMAC_FTR_440EP_PHY_CLK_FIX))
 		DBG(dev, "%s" NL, error);
 	else if (net_ratelimit())
-		printk(KERN_ERR "%s: %s\n", dev->ofdev->node->full_name, error);
+		printk(KERN_ERR "%s: %s\n", dev->ofdev->dev.of_node->full_name,
+			error);
 }
 
 /* EMAC PHY clock workaround:
@@ -2184,7 +2185,7 @@ static void emac_ethtool_get_drvinfo(struct net_device *ndev,
 	strcpy(info->version, DRV_VERSION);
 	info->fw_version[0] = '\0';
 	sprintf(info->bus_info, "PPC 4xx EMAC-%d %s",
-		dev->cell_index, dev->ofdev->node->full_name);
+		dev->cell_index, dev->ofdev->dev.of_node->full_name);
 	info->regdump_len = emac_ethtool_get_regs_len(ndev);
 }
 
@@ -2378,7 +2379,7 @@ static int __devinit emac_read_uint_prop(struct device_node *np, const char *nam
 
 static int __devinit emac_init_phy(struct emac_instance *dev)
 {
-	struct device_node *np = dev->ofdev->node;
+	struct device_node *np = dev->ofdev->dev.of_node;
 	struct net_device *ndev = dev->ndev;
 	u32 phy_map, adv;
 	int i;
@@ -2513,7 +2514,7 @@ static int __devinit emac_init_phy(struct emac_instance *dev)
 
 static int __devinit emac_init_config(struct emac_instance *dev)
 {
-	struct device_node *np = dev->ofdev->node;
+	struct device_node *np = dev->ofdev->dev.of_node;
 	const void *p;
 	unsigned int plen;
 	const char *pm, *phy_modes[] = {
@@ -2722,7 +2723,7 @@ static int __devinit emac_probe(struct of_device *ofdev,
 {
 	struct net_device *ndev;
 	struct emac_instance *dev;
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct device_node **blist = NULL;
 	int err, i;
 
@@ -2809,7 +2810,7 @@ static int __devinit emac_probe(struct of_device *ofdev,
 	err = mal_register_commac(dev->mal, &dev->commac);
 	if (err) {
 		printk(KERN_ERR "%s: failed to register with mal %s!\n",
-		       np->full_name, dev->mal_dev->node->full_name);
+		       np->full_name, dev->mal_dev->dev.of_node->full_name);
 		goto err_rel_deps;
 	}
 	dev->rx_skb_size = emac_rx_skb_size(ndev->mtu);
diff --git a/drivers/net/ibm_newemac/debug.c b/drivers/net/ibm_newemac/debug.c
index 775c850..3995faf 100644
--- a/drivers/net/ibm_newemac/debug.c
+++ b/drivers/net/ibm_newemac/debug.c
@@ -33,7 +33,7 @@ static void emac_desc_dump(struct emac_instance *p)
 	int i;
 	printk("** EMAC %s TX BDs **\n"
 	       " tx_cnt = %d tx_slot = %d ack_slot = %d\n",
-	       p->ofdev->node->full_name,
+	       p->ofdev->dev.of_node->full_name,
 	       p->tx_cnt, p->tx_slot, p->ack_slot);
 	for (i = 0; i < NUM_TX_BUFF / 2; ++i)
 		printk
@@ -49,7 +49,7 @@ static void emac_desc_dump(struct emac_instance *p)
 	printk("** EMAC %s RX BDs **\n"
 	       " rx_slot = %d flags = 0x%lx rx_skb_size = %d rx_sync_size = %d\n"
 	       " rx_sg_skb = 0x%p\n",
-	       p->ofdev->node->full_name,
+	       p->ofdev->dev.of_node->full_name,
 	       p->rx_slot, p->commac.flags, p->rx_skb_size,
 	       p->rx_sync_size, p->rx_sg_skb);
 	for (i = 0; i < NUM_RX_BUFF / 2; ++i)
@@ -77,7 +77,8 @@ static void emac_mac_dump(struct emac_instance *dev)
 	       "MR0 = 0x%08x MR1 = 0x%08x TMR0 = 0x%08x TMR1 = 0x%08x\n"
 	       "RMR = 0x%08x ISR = 0x%08x ISER = 0x%08x\n"
 	       "IAR = %04x%08x VTPID = 0x%04x VTCI = 0x%04x\n",
-	       dev->ofdev->node->full_name, in_be32(&p->mr0), in_be32(&p->mr1),
+	       dev->ofdev->dev.of_node->full_name,
+	       in_be32(&p->mr0), in_be32(&p->mr1),
 	       in_be32(&p->tmr0), in_be32(&p->tmr1),
 	       in_be32(&p->rmr), in_be32(&p->isr), in_be32(&p->iser),
 	       in_be32(&p->iahr), in_be32(&p->ialr), in_be32(&p->vtpid),
@@ -128,7 +129,7 @@ static void emac_mal_dump(struct mal_instance *mal)
 	       "CFG = 0x%08x ESR = 0x%08x IER = 0x%08x\n"
 	       "TX|CASR = 0x%08x CARR = 0x%08x EOBISR = 0x%08x DEIR = 0x%08x\n"
 	       "RX|CASR = 0x%08x CARR = 0x%08x EOBISR = 0x%08x DEIR = 0x%08x\n",
-	       mal->ofdev->node->full_name,
+	       mal->ofdev->dev.of_node->full_name,
 	       get_mal_dcrn(mal, MAL_CFG), get_mal_dcrn(mal, MAL_ESR),
 	       get_mal_dcrn(mal, MAL_IER),
 	       get_mal_dcrn(mal, MAL_TXCASR), get_mal_dcrn(mal, MAL_TXCARR),
diff --git a/drivers/net/ibm_newemac/debug.h b/drivers/net/ibm_newemac/debug.h
index b631842..e596c77 100644
--- a/drivers/net/ibm_newemac/debug.h
+++ b/drivers/net/ibm_newemac/debug.h
@@ -53,8 +53,8 @@ extern void emac_dbg_dump_all(void);
 
 #endif
 
-#define EMAC_DBG(dev, name, fmt, arg...) \
-	printk(KERN_DEBUG #name "%s: " fmt, dev->ofdev->node->full_name, ## arg)
+#define EMAC_DBG(d, name, fmt, arg...) \
+	printk(KERN_DEBUG #name "%s: " fmt, d->ofdev->dev.of_node->full_name, ## arg)
 
 #if DBG_LEVEL > 0
 #  define DBG(d,f,x...)		EMAC_DBG(d, emac, f, ##x)
diff --git a/drivers/net/ibm_newemac/mal.c b/drivers/net/ibm_newemac/mal.c
index 2a2fc17..29ed695 100644
--- a/drivers/net/ibm_newemac/mal.c
+++ b/drivers/net/ibm_newemac/mal.c
@@ -537,11 +537,11 @@ static int __devinit mal_probe(struct of_device *ofdev,
 	}
 	mal->index = index;
 	mal->ofdev = ofdev;
-	mal->version = of_device_is_compatible(ofdev->node, "ibm,mcmal2") ? 2 : 1;
+	mal->version = of_device_is_compatible(ofdev->dev.of_node, "ibm,mcmal2") ? 2 : 1;
 
 	MAL_DBG(mal, "probe" NL);
 
-	prop = of_get_property(ofdev->node, "num-tx-chans", NULL);
+	prop = of_get_property(ofdev->dev.of_node, "num-tx-chans", NULL);
 	if (prop == NULL) {
 		printk(KERN_ERR
 		       "mal%d: can't find MAL num-tx-chans property!\n",
@@ -551,7 +551,7 @@ static int __devinit mal_probe(struct of_device *ofdev,
 	}
 	mal->num_tx_chans = prop[0];
 
-	prop = of_get_property(ofdev->node, "num-rx-chans", NULL);
+	prop = of_get_property(ofdev->dev.of_node, "num-rx-chans", NULL);
 	if (prop == NULL) {
 		printk(KERN_ERR
 		       "mal%d: can't find MAL num-rx-chans property!\n",
@@ -561,14 +561,14 @@ static int __devinit mal_probe(struct of_device *ofdev,
 	}
 	mal->num_rx_chans = prop[0];
 
-	dcr_base = dcr_resource_start(ofdev->node, 0);
+	dcr_base = dcr_resource_start(ofdev->dev.of_node, 0);
 	if (dcr_base == 0) {
 		printk(KERN_ERR
 		       "mal%d: can't find DCR resource!\n", index);
 		err = -ENODEV;
 		goto fail;
 	}
-	mal->dcr_host = dcr_map(ofdev->node, dcr_base, 0x100);
+	mal->dcr_host = dcr_map(ofdev->dev.of_node, dcr_base, 0x100);
 	if (!DCR_MAP_OK(mal->dcr_host)) {
 		printk(KERN_ERR
 		       "mal%d: failed to map DCRs !\n", index);
@@ -576,28 +576,28 @@ static int __devinit mal_probe(struct of_device *ofdev,
 		goto fail;
 	}
 
-	if (of_device_is_compatible(ofdev->node, "ibm,mcmal-405ez")) {
+	if (of_device_is_compatible(ofdev->dev.of_node, "ibm,mcmal-405ez")) {
 #if defined(CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT) && \
 		defined(CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR)
 		mal->features |= (MAL_FTR_CLEAR_ICINTSTAT |
 				MAL_FTR_COMMON_ERR_INT);
 #else
 		printk(KERN_ERR "%s: Support for 405EZ not enabled!\n",
-				ofdev->node->full_name);
+				ofdev->dev.of_node->full_name);
 		err = -ENODEV;
 		goto fail;
 #endif
 	}
 
-	mal->txeob_irq = irq_of_parse_and_map(ofdev->node, 0);
-	mal->rxeob_irq = irq_of_parse_and_map(ofdev->node, 1);
-	mal->serr_irq = irq_of_parse_and_map(ofdev->node, 2);
+	mal->txeob_irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
+	mal->rxeob_irq = irq_of_parse_and_map(ofdev->dev.of_node, 1);
+	mal->serr_irq = irq_of_parse_and_map(ofdev->dev.of_node, 2);
 
 	if (mal_has_feature(mal, MAL_FTR_COMMON_ERR_INT)) {
 		mal->txde_irq = mal->rxde_irq = mal->serr_irq;
 	} else {
-		mal->txde_irq = irq_of_parse_and_map(ofdev->node, 3);
-		mal->rxde_irq = irq_of_parse_and_map(ofdev->node, 4);
+		mal->txde_irq = irq_of_parse_and_map(ofdev->dev.of_node, 3);
+		mal->rxde_irq = irq_of_parse_and_map(ofdev->dev.of_node, 4);
 	}
 
 	if (mal->txeob_irq == NO_IRQ || mal->rxeob_irq == NO_IRQ ||
@@ -628,7 +628,7 @@ static int __devinit mal_probe(struct of_device *ofdev,
 	/* Current Axon is not happy with priority being non-0, it can
 	 * deadlock, fix it up here
 	 */
-	if (of_device_is_compatible(ofdev->node, "ibm,mcmal-axon"))
+	if (of_device_is_compatible(ofdev->dev.of_node, "ibm,mcmal-axon"))
 		cfg &= ~(MAL2_CFG_RPP_10 | MAL2_CFG_WPP_10);
 
 	/* Apply configuration */
@@ -700,7 +700,7 @@ static int __devinit mal_probe(struct of_device *ofdev,
 
 	printk(KERN_INFO
 	       "MAL v%d %s, %d TX channels, %d RX channels\n",
-	       mal->version, ofdev->node->full_name,
+	       mal->version, ofdev->dev.of_node->full_name,
 	       mal->num_tx_chans, mal->num_rx_chans);
 
 	/* Advertise this instance to the rest of the world */
diff --git a/drivers/net/ibm_newemac/rgmii.c b/drivers/net/ibm_newemac/rgmii.c
index 8d76cb8..57fc784 100644
--- a/drivers/net/ibm_newemac/rgmii.c
+++ b/drivers/net/ibm_newemac/rgmii.c
@@ -102,7 +102,7 @@ int __devinit rgmii_attach(struct of_device *ofdev, int input, int mode)
 	/* Check if we need to attach to a RGMII */
 	if (input < 0 || !rgmii_valid_mode(mode)) {
 		printk(KERN_ERR "%s: unsupported settings !\n",
-		       ofdev->node->full_name);
+		       ofdev->dev.of_node->full_name);
 		return -ENODEV;
 	}
 
@@ -112,7 +112,7 @@ int __devinit rgmii_attach(struct of_device *ofdev, int input, int mode)
 	out_be32(&p->fer, in_be32(&p->fer) | rgmii_mode_mask(mode, input));
 
 	printk(KERN_NOTICE "%s: input %d in %s mode\n",
-	       ofdev->node->full_name, input, rgmii_mode_name(mode));
+	       ofdev->dev.of_node->full_name, input, rgmii_mode_name(mode));
 
 	++dev->users;
 
@@ -230,7 +230,7 @@ void *rgmii_dump_regs(struct of_device *ofdev, void *buf)
 static int __devinit rgmii_probe(struct of_device *ofdev,
 				 const struct of_device_id *match)
 {
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct rgmii_instance *dev;
 	struct resource regs;
 	int rc;
@@ -263,11 +263,11 @@ static int __devinit rgmii_probe(struct of_device *ofdev,
 	}
 
 	/* Check for RGMII flags */
-	if (of_get_property(ofdev->node, "has-mdio", NULL))
+	if (of_get_property(ofdev->dev.of_node, "has-mdio", NULL))
 		dev->flags |= EMAC_RGMII_FLAG_HAS_MDIO;
 
 	/* CAB lacks the right properties, fix this up */
-	if (of_device_is_compatible(ofdev->node, "ibm,rgmii-axon"))
+	if (of_device_is_compatible(ofdev->dev.of_node, "ibm,rgmii-axon"))
 		dev->flags |= EMAC_RGMII_FLAG_HAS_MDIO;
 
 	DBG2(dev, " Boot FER = 0x%08x, SSR = 0x%08x\n",
@@ -278,7 +278,7 @@ static int __devinit rgmii_probe(struct of_device *ofdev,
 
 	printk(KERN_INFO
 	       "RGMII %s initialized with%s MDIO support\n",
-	       ofdev->node->full_name,
+	       ofdev->dev.of_node->full_name,
 	       (dev->flags & EMAC_RGMII_FLAG_HAS_MDIO) ? "" : "out");
 
 	wmb();
diff --git a/drivers/net/ibm_newemac/tah.c b/drivers/net/ibm_newemac/tah.c
index 30173a9..4f64b00 100644
--- a/drivers/net/ibm_newemac/tah.c
+++ b/drivers/net/ibm_newemac/tah.c
@@ -57,7 +57,8 @@ void tah_reset(struct of_device *ofdev)
 		--n;
 
 	if (unlikely(!n))
-		printk(KERN_ERR "%s: reset timeout\n", ofdev->node->full_name);
+		printk(KERN_ERR "%s: reset timeout\n",
+			ofdev->dev.of_node->full_name);
 
 	/* 10KB TAH TX FIFO accomodates the max MTU of 9000 */
 	out_be32(&p->mr,
@@ -89,7 +90,7 @@ void *tah_dump_regs(struct of_device *ofdev, void *buf)
 static int __devinit tah_probe(struct of_device *ofdev,
 			       const struct of_device_id *match)
 {
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct tah_instance *dev;
 	struct resource regs;
 	int rc;
@@ -127,7 +128,7 @@ static int __devinit tah_probe(struct of_device *ofdev,
 	tah_reset(ofdev);
 
 	printk(KERN_INFO
-	       "TAH %s initialized\n", ofdev->node->full_name);
+	       "TAH %s initialized\n", ofdev->dev.of_node->full_name);
 	wmb();
 
 	return 0;
diff --git a/drivers/net/ibm_newemac/zmii.c b/drivers/net/ibm_newemac/zmii.c
index 17b1541..724e00e 100644
--- a/drivers/net/ibm_newemac/zmii.c
+++ b/drivers/net/ibm_newemac/zmii.c
@@ -120,13 +120,14 @@ int __devinit zmii_attach(struct of_device *ofdev, int input, int *mode)
 			dev->mode = *mode;
 
 		printk(KERN_NOTICE "%s: bridge in %s mode\n",
-		       ofdev->node->full_name, zmii_mode_name(dev->mode));
+		       ofdev->dev.of_node->full_name,
+		       zmii_mode_name(dev->mode));
 	} else {
 		/* All inputs must use the same mode */
 		if (*mode != PHY_MODE_NA && *mode != dev->mode) {
 			printk(KERN_ERR
 			       "%s: invalid mode %d specified for input %d\n",
-			       ofdev->node->full_name, *mode, input);
+			       ofdev->dev.of_node->full_name, *mode, input);
 			mutex_unlock(&dev->lock);
 			return -EINVAL;
 		}
@@ -232,7 +233,7 @@ void *zmii_dump_regs(struct of_device *ofdev, void *buf)
 static int __devinit zmii_probe(struct of_device *ofdev,
 				const struct of_device_id *match)
 {
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct zmii_instance *dev;
 	struct resource regs;
 	int rc;
@@ -272,7 +273,7 @@ static int __devinit zmii_probe(struct of_device *ofdev,
 	out_be32(&dev->base->fer, 0);
 
 	printk(KERN_INFO
-	       "ZMII %s initialized\n", ofdev->node->full_name);
+	       "ZMII %s initialized\n", ofdev->dev.of_node->full_name);
 	wmb();
 	dev_set_drvdata(&ofdev->dev, dev);
 
diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index a18e348..eb13c7f 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -857,14 +857,14 @@ temac_of_probe(struct of_device *op, const struct of_device_id *match)
 	mutex_init(&lp->indirect_mutex);
 
 	/* map device registers */
-	lp->regs = of_iomap(op->node, 0);
+	lp->regs = of_iomap(op->dev.of_node, 0);
 	if (!lp->regs) {
 		dev_err(&op->dev, "could not map temac regs.\n");
 		goto nodev;
 	}
 
 	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
-	np = of_parse_phandle(op->node, "llink-connected", 0);
+	np = of_parse_phandle(op->dev.of_node, "llink-connected", 0);
 	if (!np) {
 		dev_err(&op->dev, "could not find DMA node\n");
 		goto nodev;
@@ -889,7 +889,7 @@ temac_of_probe(struct of_device *op, const struct of_device_id *match)
 	of_node_put(np); /* Finished with the DMA node; drop the reference */
 
 	/* Retrieve the MAC address */
-	addr = of_get_property(op->node, "local-mac-address", &size);
+	addr = of_get_property(op->dev.of_node, "local-mac-address", &size);
 	if ((!addr) || (size != 6)) {
 		dev_err(&op->dev, "could not find MAC address\n");
 		rc = -ENODEV;
@@ -897,11 +897,11 @@ temac_of_probe(struct of_device *op, const struct of_device_id *match)
 	}
 	temac_set_mac_address(ndev, (void *)addr);
 
-	rc = temac_mdio_setup(lp, op->node);
+	rc = temac_mdio_setup(lp, op->dev.of_node);
 	if (rc)
 		dev_warn(&op->dev, "error registering MDIO bus\n");
 
-	lp->phy_node = of_parse_phandle(op->node, "phy-handle", 0);
+	lp->phy_node = of_parse_phandle(op->dev.of_node, "phy-handle", 0);
 	if (lp->phy_node)
 		dev_dbg(lp->dev, "using PHY node %s (%p)\n", np->full_name, np);
 
diff --git a/drivers/net/myri_sbus.c b/drivers/net/myri_sbus.c
index 8b43130..be4e6e4 100644
--- a/drivers/net/myri_sbus.c
+++ b/drivers/net/myri_sbus.c
@@ -928,7 +928,7 @@ static const struct net_device_ops myri_ops = {
 
 static int __devinit myri_sbus_probe(struct of_device *op, const struct of_device_id *match)
 {
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 	static unsigned version_printed;
 	struct net_device *dev;
 	struct myri_eth *mp;
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 0678f31..1fcf1ac 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -9093,7 +9093,7 @@ static int __devinit niu_n2_irq_init(struct niu *np, u8 *ldg_num_map)
 	const u32 *int_prop;
 	int i;
 
-	int_prop = of_get_property(op->node, "interrupts", NULL);
+	int_prop = of_get_property(op->dev.of_node, "interrupts", NULL);
 	if (!int_prop)
 		return -ENODEV;
 
@@ -9244,7 +9244,7 @@ static int __devinit niu_get_of_props(struct niu *np)
 	int prop_len;
 
 	if (np->parent->plat_type == PLAT_TYPE_NIU)
-		dp = np->op->node;
+		dp = np->op->dev.of_node;
 	else
 		dp = pci_device_to_OF_node(np->pdev);
 
@@ -10055,10 +10055,10 @@ static int __devinit niu_of_probe(struct of_device *op,
 
 	niu_driver_version();
 
-	reg = of_get_property(op->node, "reg", NULL);
+	reg = of_get_property(op->dev.of_node, "reg", NULL);
 	if (!reg) {
 		dev_err(&op->dev, "%s: No 'reg' property, aborting\n",
-			op->node->full_name);
+			op->dev.of_node->full_name);
 		return -ENODEV;
 	}
 
@@ -10071,7 +10071,7 @@ static int __devinit niu_of_probe(struct of_device *op,
 	np = netdev_priv(dev);
 
 	memset(&parent_id, 0, sizeof(parent_id));
-	parent_id.of = of_get_parent(op->node);
+	parent_id.of = of_get_parent(op->dev.of_node);
 
 	np->parent = niu_get_parent(np, &parent_id,
 				    PLAT_TYPE_NIU);
diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
index 3589713..641973c 100644
--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -199,12 +199,12 @@ static int __devinit mdio_ofgpio_probe(struct of_device *ofdev,
 	if (!pdata)
 		return -ENOMEM;
 
-	ret = of_get_gpio(ofdev->node, 0);
+	ret = of_get_gpio(ofdev->dev.of_node, 0);
 	if (ret < 0)
 		goto out_free;
 	pdata->mdc = ret;
 
-	ret = of_get_gpio(ofdev->node, 1);
+	ret = of_get_gpio(ofdev->dev.of_node, 1);
 	if (ret < 0)
 		goto out_free;
 	pdata->mdio = ret;
@@ -213,7 +213,7 @@ static int __devinit mdio_ofgpio_probe(struct of_device *ofdev,
 	if (!new_bus)
 		goto out_free;
 
-	ret = of_mdiobus_register(new_bus, ofdev->node);
+	ret = of_mdiobus_register(new_bus, ofdev->dev.of_node);
 	if (ret)
 		mdio_gpio_bus_deinit(&ofdev->dev);
 
diff --git a/drivers/net/sunbmac.c b/drivers/net/sunbmac.c
index a0bd361..9b6aa7c 100644
--- a/drivers/net/sunbmac.c
+++ b/drivers/net/sunbmac.c
@@ -1133,8 +1133,8 @@ static int __devinit bigmac_ether_init(struct of_device *op,
 		goto fail_and_cleanup;
 
 	/* Get supported SBUS burst sizes. */
-	bsizes = of_getintprop_default(qec_op->node, "burst-sizes", 0xff);
-	bsizes_more = of_getintprop_default(qec_op->node, "burst-sizes", 0xff);
+	bsizes = of_getintprop_default(qec_op->dev.of_node, "burst-sizes", 0xff);
+	bsizes_more = of_getintprop_default(qec_op->dev.of_node, "burst-sizes", 0xff);
 
 	bsizes &= 0xff;
 	if (bsizes_more != 0xff)
@@ -1186,7 +1186,7 @@ static int __devinit bigmac_ether_init(struct of_device *op,
 	}
 
 	/* Get the board revision of this BigMAC. */
-	bp->board_rev = of_getintprop_default(bp->bigmac_op->node,
+	bp->board_rev = of_getintprop_default(bp->bigmac_op->dev.of_node,
 					      "board-version", 1);
 
 	/* Init auto-negotiation timer state. */
diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index b17dbb1..c6463f7 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -2483,7 +2483,7 @@ static void hme_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 	else {
 		const struct linux_prom_registers *regs;
 		struct of_device *op = hp->happy_dev;
-		regs = of_get_property(op->node, "regs", NULL);
+		regs = of_get_property(op->dev.of_node, "regs", NULL);
 		if (regs)
 			sprintf(info->bus_info, "SBUS:%d",
 				regs->which_io);
@@ -2643,14 +2643,14 @@ static const struct net_device_ops hme_netdev_ops = {
 #ifdef CONFIG_SBUS
 static int __devinit happy_meal_sbus_probe_one(struct of_device *op, int is_qfe)
 {
-	struct device_node *dp = op->node, *sbus_dp;
+	struct device_node *dp = op->dev.of_node, *sbus_dp;
 	struct quattro *qp = NULL;
 	struct happy_meal *hp;
 	struct net_device *dev;
 	int i, qfe_slot = -1;
 	int err = -ENODEV;
 
-	sbus_dp = to_of_device(op->dev.parent)->node;
+	sbus_dp = to_of_device(op->dev.parent)->dev.of_node;
 
 	/* We can match PCI devices too, do not accept those here. */
 	if (strcmp(sbus_dp->name, "sbus"))
@@ -3241,7 +3241,7 @@ static void happy_meal_pci_exit(void)
 #ifdef CONFIG_SBUS
 static int __devinit hme_sbus_probe(struct of_device *op, const struct of_device_id *match)
 {
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 	const char *model = of_get_property(dp, "model", NULL);
 	int is_qfe = (match->data != NULL);
 
diff --git a/drivers/net/sunlance.c b/drivers/net/sunlance.c
index d7c73f4..a139861 100644
--- a/drivers/net/sunlance.c
+++ b/drivers/net/sunlance.c
@@ -1324,7 +1324,7 @@ static int __devinit sparc_lance_probe_one(struct of_device *op,
 					   struct of_device *ledma,
 					   struct of_device *lebuffer)
 {
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 	static unsigned version_printed;
 	struct lance_private *lp;
 	struct net_device *dev;
@@ -1411,7 +1411,7 @@ static int __devinit sparc_lance_probe_one(struct of_device *op,
 
 	lp->burst_sizes = 0;
 	if (lp->ledma) {
-		struct device_node *ledma_dp = ledma->node;
+		struct device_node *ledma_dp = ledma->dev.of_node;
 		struct device_node *sbus_dp;
 		unsigned int sbmask;
 		const char *prop;
@@ -1507,7 +1507,7 @@ fail:
 static int __devinit sunlance_sbus_probe(struct of_device *op, const struct of_device_id *match)
 {
 	struct of_device *parent = to_of_device(op->dev.parent);
-	struct device_node *parent_dp = parent->node;
+	struct device_node *parent_dp = parent->dev.of_node;
 	int err;
 
 	if (!strcmp(parent_dp->name, "ledma")) {
diff --git a/drivers/net/sunqe.c b/drivers/net/sunqe.c
index be637dc..9864f4f 100644
--- a/drivers/net/sunqe.c
+++ b/drivers/net/sunqe.c
@@ -696,7 +696,7 @@ static void qe_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	strcpy(info->version, "3.0");
 
 	op = qep->op;
-	regs = of_get_property(op->node, "reg", NULL);
+	regs = of_get_property(op->dev.of_node, "reg", NULL);
 	if (regs)
 		sprintf(info->bus_info, "SBUS:%d", regs->which_io);
 
@@ -800,7 +800,7 @@ static struct sunqec * __devinit get_qec(struct of_device *child)
 			if (qec_global_reset(qecp->gregs))
 				goto fail;
 
-			qecp->qec_bursts = qec_get_burst(op->node);
+			qecp->qec_bursts = qec_get_burst(op->dev.of_node);
 
 			qec_init_once(qecp, op);
 
@@ -858,7 +858,7 @@ static int __devinit qec_ether_init(struct of_device *op)
 
 	res = -ENODEV;
 
-	i = of_getintprop_default(op->node, "channel#", -1);
+	i = of_getintprop_default(op->dev.of_node, "channel#", -1);
 	if (i == -1)
 		goto fail;
 	qe->channel = i;
diff --git a/drivers/net/xilinx_emaclite.c b/drivers/net/xilinx_emaclite.c
index 1a74594..40b8fdc 100644
--- a/drivers/net/xilinx_emaclite.c
+++ b/drivers/net/xilinx_emaclite.c
@@ -1089,7 +1089,7 @@ static void xemaclite_remove_ndev(struct net_device *ndev)
  */
 static bool get_bool(struct of_device *ofdev, const char *s)
 {
-	u32 *p = (u32 *)of_get_property(ofdev->node, s, NULL);
+	u32 *p = (u32 *)of_get_property(ofdev->dev.of_node, s, NULL);
 
 	if (p) {
 		return (bool)*p;
@@ -1131,14 +1131,14 @@ static int __devinit xemaclite_of_probe(struct of_device *ofdev,
 	dev_info(dev, "Device Tree Probing\n");
 
 	/* Get iospace for the device */
-	rc = of_address_to_resource(ofdev->node, 0, &r_mem);
+	rc = of_address_to_resource(ofdev->dev.of_node, 0, &r_mem);
 	if (rc) {
 		dev_err(dev, "invalid address\n");
 		return rc;
 	}
 
 	/* Get IRQ for the device */
-	rc = of_irq_to_resource(ofdev->node, 0, &r_irq);
+	rc = of_irq_to_resource(ofdev->dev.of_node, 0, &r_irq);
 	if (rc == NO_IRQ) {
 		dev_err(dev, "no IRQ found\n");
 		return rc;
@@ -1183,7 +1183,7 @@ static int __devinit xemaclite_of_probe(struct of_device *ofdev,
 	lp->next_rx_buf_to_use = 0x0;
 	lp->tx_ping_pong = get_bool(ofdev, "xlnx,tx-ping-pong");
 	lp->rx_ping_pong = get_bool(ofdev, "xlnx,rx-ping-pong");
-	mac_address = of_get_mac_address(ofdev->node);
+	mac_address = of_get_mac_address(ofdev->dev.of_node);
 
 	if (mac_address)
 		/* Set the MAC address. */
@@ -1198,7 +1198,7 @@ static int __devinit xemaclite_of_probe(struct of_device *ofdev,
 	/* Set the MAC address in the EmacLite device */
 	xemaclite_update_address(lp, ndev->dev_addr);
 
-	lp->phy_node = of_parse_phandle(ofdev->node, "phy-handle", 0);
+	lp->phy_node = of_parse_phandle(ofdev->dev.of_node, "phy-handle", 0);
 	rc = xemaclite_mdio_setup(lp, &ofdev->dev);
 	if (rc)
 		dev_warn(&ofdev->dev, "error registering MDIO bus\n");
diff --git a/drivers/of/device.c b/drivers/of/device.c
index 224ae6b..24068bb 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -21,9 +21,9 @@
 const struct of_device_id *of_match_device(const struct of_device_id *matches,
 					const struct of_device *dev)
 {
-	if (!dev->node)
+	if (!dev->dev.of_node)
 		return NULL;
-	return of_match_node(matches, dev->node);
+	return of_match_node(matches, dev->dev.of_node);
 }
 EXPORT_SYMBOL(of_match_device);
 
@@ -54,7 +54,7 @@ static ssize_t devspec_show(struct device *dev,
 	struct of_device *ofdev;
 
 	ofdev = to_of_device(dev);
-	return sprintf(buf, "%s\n", ofdev->node->full_name);
+	return sprintf(buf, "%s\n", ofdev->dev.of_node->full_name);
 }
 
 static ssize_t name_show(struct device *dev,
@@ -63,7 +63,7 @@ static ssize_t name_show(struct device *dev,
 	struct of_device *ofdev;
 
 	ofdev = to_of_device(dev);
-	return sprintf(buf, "%s\n", ofdev->node->name);
+	return sprintf(buf, "%s\n", ofdev->dev.of_node->name);
 }
 
 static ssize_t modalias_show(struct device *dev,
@@ -97,14 +97,14 @@ void of_release_dev(struct device *dev)
 	struct of_device *ofdev;
 
 	ofdev = to_of_device(dev);
-	of_node_put(ofdev->node);
+	of_node_put(ofdev->dev.of_node);
 	kfree(ofdev);
 }
 EXPORT_SYMBOL(of_release_dev);
 
 int of_device_register(struct of_device *ofdev)
 {
-	BUG_ON(ofdev->node == NULL);
+	BUG_ON(ofdev->dev.of_node == NULL);
 
 	device_initialize(&ofdev->dev);
 
@@ -112,7 +112,7 @@ int of_device_register(struct of_device *ofdev)
 	 * the parent. If there is no parent defined, set the node
 	 * explicitly */
 	if (!ofdev->dev.parent)
-		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->node));
+		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
 
 	return device_add(&ofdev->dev);
 }
@@ -132,11 +132,11 @@ ssize_t of_device_get_modalias(struct of_device *ofdev,
 	ssize_t tsize, csize, repend;
 
 	/* Name & Type */
-	csize = snprintf(str, len, "of:N%sT%s",
-				ofdev->node->name, ofdev->node->type);
+	csize = snprintf(str, len, "of:N%sT%s", ofdev->dev.of_node->name,
+			 ofdev->dev.of_node->type);
 
 	/* Get compatible property if any */
-	compat = of_get_property(ofdev->node, "compatible", &cplen);
+	compat = of_get_property(ofdev->dev.of_node, "compatible", &cplen);
 	if (!compat)
 		return csize;
 
diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index e690a2a..604ba96 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -69,7 +69,7 @@ EXPORT_SYMBOL(of_register_i2c_devices);
 
 static int of_dev_node_match(struct device *dev, void *data)
 {
-        return dev_archdata_get_node(&dev->archdata) == data;
+        return dev->of_node == data;
 }
 
 /* must call put_device() when done with returned i2c_client device */
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 12090f5..01d794a 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -101,7 +101,7 @@ EXPORT_SYMBOL(of_mdiobus_register);
 /* Helper function for of_phy_find_device */
 static int of_phy_match(struct device *dev, void *phy_np)
 {
-	return dev_archdata_get_node(&dev->archdata) == phy_np;
+	return dev->of_node == phy_np;
 }
 
 /**
@@ -167,7 +167,7 @@ struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
 	if (!dev->dev.parent)
 		return NULL;
 
-	net_np = dev_archdata_get_node(&dev->dev.parent->archdata);
+	net_np = dev->dev.parent->of_node;
 	if (!net_np)
 		return NULL;
 
diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 89cfddc..a4d821f 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -184,7 +184,7 @@ static int __devinit electra_cf_probe(struct of_device *ofdev,
 				      const struct of_device_id *match)
 {
 	struct device *device = &ofdev->dev;
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct electra_cf_socket   *cf;
 	struct resource mem, io;
 	int status;
diff --git a/drivers/sbus/char/bbc_envctrl.c b/drivers/sbus/char/bbc_envctrl.c
index 28d86f9..53c0230 100644
--- a/drivers/sbus/char/bbc_envctrl.c
+++ b/drivers/sbus/char/bbc_envctrl.c
@@ -564,9 +564,9 @@ int bbc_envctrl_init(struct bbc_i2c_bus *bp)
 	int devidx = 0;
 
 	while ((op = bbc_i2c_getdev(bp, devidx++)) != NULL) {
-		if (!strcmp(op->node->name, "temperature"))
+		if (!strcmp(op->dev.of_node->name, "temperature"))
 			attach_one_temp(bp, op, temp_index++);
-		if (!strcmp(op->node->name, "fan-control"))
+		if (!strcmp(op->dev.of_node->name, "fan-control"))
 			attach_one_fan(bp, op, fan_index++);
 	}
 	if (temp_index != 0 && fan_index != 0) {
diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
index 7e30e5f..1543ac3 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -97,7 +97,7 @@ struct bbc_i2c_client *bbc_i2c_attach(struct bbc_i2c_bus *bp, struct of_device *
 	client->bp = bp;
 	client->op = op;
 
-	reg = of_get_property(op->node, "reg", NULL);
+	reg = of_get_property(op->dev.of_node, "reg", NULL);
 	if (!reg) {
 		kfree(client);
 		return NULL;
@@ -327,7 +327,7 @@ static struct bbc_i2c_bus * __init attach_one_i2c(struct of_device *op, int inde
 	spin_lock_init(&bp->lock);
 
 	entry = 0;
-	for (dp = op->node->child;
+	for (dp = op->dev.of_node->child;
 	     dp && entry < 8;
 	     dp = dp->sibling, entry++) {
 		struct of_device *child_op;
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 4431578..d0a10f4 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -215,7 +215,7 @@ static int __devinit d7s_probe(struct of_device *op,
 	writeb(regs,  p->regs);
 
 	printk(KERN_INFO PFX "7-Segment Display%s at [%s:0x%llx] %s\n",
-	       op->node->full_name,
+	       op->dev.of_node->full_name,
 	       (regs & D7S_FLIP) ? " (FLIPPED)" : "",
 	       op->resource[0].start,
 	       sol_compat ? "in sol_compat mode" : "");
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index aa2b60a..84a4310 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -1042,7 +1042,7 @@ static int __devinit envctrl_probe(struct of_device *op,
 		return -ENOMEM;
 
 	index = 0;
-	dp = op->node->child;
+	dp = op->dev.of_node->child;
 	while (dp) {
 		if (!strcmp(dp->name, "gpio")) {
 			i2c_childlist[index].i2ctype = I2C_GPIO;
diff --git a/drivers/sbus/char/flash.c b/drivers/sbus/char/flash.c
index 4108347..dc8f95d 100644
--- a/drivers/sbus/char/flash.c
+++ b/drivers/sbus/char/flash.c
@@ -163,7 +163,7 @@ static struct miscdevice flash_dev = { FLASH_MINOR, "flash", &flash_fops };
 static int __devinit flash_probe(struct of_device *op,
 				 const struct of_device_id *match)
 {
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 	struct device_node *parent;
 
 	parent = dp->parent;
@@ -185,7 +185,7 @@ static int __devinit flash_probe(struct of_device *op,
 	flash.busy = 0;
 
 	printk(KERN_INFO "%s: OBP Flash, RD %lx[%lx] WR %lx[%lx]\n",
-	       op->node->full_name,
+	       op->dev.of_node->full_name,
 	       flash.read_base, flash.read_size,
 	       flash.write_base, flash.write_size);
 
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index 2c56fd5..acc6738 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -382,7 +382,7 @@ static int __devinit uctrl_probe(struct of_device *op,
 
 	sbus_writel(UCTRL_INTR_RXNE_REQ|UCTRL_INTR_RXNE_MSK, &p->regs->uctrl_intr);
 	printk(KERN_INFO "%s: uctrl regs[0x%p] (irq %d)\n",
-	       op->node->full_name, p->regs, p->irq);
+	       op->dev.of_node->full_name, p->regs, p->irq);
 	uctrl_get_event_status(p);
 	uctrl_get_external_status(p);
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 732f6d3..e230cd4 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1155,7 +1155,7 @@ static void ibmvfc_gather_partition_info(struct ibmvfc_host *vhost)
 static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_npiv_login *login_info = &vhost->login_info;
-	struct device_node *of_node = vhost->dev->archdata.of_node;
+	struct device_node *of_node = vhost->dev->of_node;
 	const char *location;
 
 	memset(login_info, 0, sizeof(*login_info));
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index e3a18e0..c4b5af3 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -955,7 +955,7 @@ static void send_mad_capabilities(struct ibmvscsi_host_data *hostdata)
 	struct viosrp_capabilities *req;
 	struct srp_event_struct *evt_struct;
 	unsigned long flags;
-	struct device_node *of_node = hostdata->dev->archdata.of_node;
+	struct device_node *of_node = hostdata->dev->of_node;
 	const char *location;
 
 	evt_struct = get_event_struct(&hostdata->pool);
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index fa34b92..7374fbe 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -755,7 +755,7 @@ static void __devinit qpti_get_scsi_id(struct qlogicpti *qpti)
 	struct of_device *op = qpti->op;
 	struct device_node *dp;
 
-	dp = op->node;
+	dp = op->dev.of_node;
 
 	qpti->scsi_id = of_getintprop_default(dp, "initiator-id", -1);
 	if (qpti->scsi_id == -1)
@@ -776,8 +776,8 @@ static void qpti_get_bursts(struct qlogicpti *qpti)
 	struct of_device *op = qpti->op;
 	u8 bursts, bmask;
 
-	bursts = of_getintprop_default(op->node, "burst-sizes", 0xff);
-	bmask = of_getintprop_default(op->node->parent, "burst-sizes", 0xff);
+	bursts = of_getintprop_default(op->dev.of_node, "burst-sizes", 0xff);
+	bmask = of_getintprop_default(op->dev.of_node->parent, "burst-sizes", 0xff);
 	if (bmask != 0xff)
 		bursts &= bmask;
 	if (bursts == 0xff ||
@@ -1293,7 +1293,7 @@ static struct scsi_host_template qpti_template = {
 static int __devinit qpti_sbus_probe(struct of_device *op, const struct of_device_id *match)
 {
 	struct scsi_host_template *tpnt = match->data;
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 	struct Scsi_Host *host;
 	struct qlogicpti *qpti;
 	static int nqptis;
@@ -1315,7 +1315,7 @@ static int __devinit qpti_sbus_probe(struct of_device *op, const struct of_devic
 	qpti->qhost = host;
 	qpti->op = op;
 	qpti->qpti_id = nqptis;
-	strcpy(qpti->prom_name, op->node->name);
+	strcpy(qpti->prom_name, op->dev.of_node->name);
 	qpti->is_pti = strcmp(qpti->prom_name, "QLGC,isp");
 
 	if (qpti_map_regs(qpti) < 0)
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 3d73aad..4369b76 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -124,7 +124,7 @@ static void __devinit esp_get_scsi_id(struct esp *esp, struct of_device *espdma)
 	struct of_device *op = esp->dev;
 	struct device_node *dp;
 
-	dp = op->node;
+	dp = op->dev.of_node;
 	esp->scsi_id = of_getintprop_default(dp, "initiator-id", 0xff);
 	if (esp->scsi_id != 0xff)
 		goto done;
@@ -133,7 +133,7 @@ static void __devinit esp_get_scsi_id(struct esp *esp, struct of_device *espdma)
 	if (esp->scsi_id != 0xff)
 		goto done;
 
-	esp->scsi_id = of_getintprop_default(espdma->node,
+	esp->scsi_id = of_getintprop_default(espdma->dev.of_node,
 					     "scsi-initiator-id", 7);
 
 done:
@@ -146,7 +146,7 @@ static void __devinit esp_get_differential(struct esp *esp)
 	struct of_device *op = esp->dev;
 	struct device_node *dp;
 
-	dp = op->node;
+	dp = op->dev.of_node;
 	if (of_find_property(dp, "differential", NULL))
 		esp->flags |= ESP_FLAG_DIFFERENTIAL;
 	else
@@ -159,7 +159,7 @@ static void __devinit esp_get_clock_params(struct esp *esp)
 	struct device_node *bus_dp, *dp;
 	int fmhz;
 
-	dp = op->node;
+	dp = op->dev.of_node;
 	bus_dp = dp->parent;
 
 	fmhz = of_getintprop_default(dp, "clock-frequency", 0);
@@ -171,12 +171,12 @@ static void __devinit esp_get_clock_params(struct esp *esp)
 
 static void __devinit esp_get_bursts(struct esp *esp, struct of_device *dma_of)
 {
-	struct device_node *dma_dp = dma_of->node;
+	struct device_node *dma_dp = dma_of->dev.of_node;
 	struct of_device *op = esp->dev;
 	struct device_node *dp;
 	u8 bursts, val;
 
-	dp = op->node;
+	dp = op->dev.of_node;
 	bursts = of_getintprop_default(dp, "burst-sizes", 0xff);
 	val = of_getintprop_default(dma_dp, "burst-sizes", 0xff);
 	if (val != 0xff)
@@ -564,7 +564,7 @@ fail:
 static int __devinit esp_sbus_probe(struct of_device *op, const struct of_device_id *match)
 {
 	struct device_node *dma_node = NULL;
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 	struct of_device *dma_of = NULL;
 	int hme = 0;
 
@@ -573,7 +573,7 @@ static int __devinit esp_sbus_probe(struct of_device *op, const struct of_device
 	     !strcmp(dp->parent->name, "dma")))
 		dma_node = dp->parent;
 	else if (!strcmp(dp->name, "SUNW,fas")) {
-		dma_node = op->node;
+		dma_node = op->dev.of_node;
 		hme = 1;
 	}
 	if (dma_node)
diff --git a/drivers/serial/apbuart.c b/drivers/serial/apbuart.c
index fe91319..52015d7 100644
--- a/drivers/serial/apbuart.c
+++ b/drivers/serial/apbuart.c
@@ -559,7 +559,7 @@ static int __devinit apbuart_probe(struct of_device *op,
 
 	i = 0;
 	for (i = 0; i < grlib_apbuart_port_nr; i++) {
-		if (op->node == grlib_apbuart_nodes[i])
+		if (op->dev.of_node == grlib_apbuart_nodes[i])
 			break;
 	}
 
diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index 3119fdd..cb07938 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -1328,14 +1328,14 @@ mpc52xx_uart_of_probe(struct of_device *op, const struct of_device_id *match)
 
 	/* Check validity & presence */
 	for (idx = 0; idx < MPC52xx_PSC_MAXNUM; idx++)
-		if (mpc52xx_uart_nodes[idx] == op->node)
+		if (mpc52xx_uart_nodes[idx] == op->dev.of_node)
 			break;
 	if (idx >= MPC52xx_PSC_MAXNUM)
 		return -EINVAL;
 	pr_debug("Found %s assigned to ttyPSC%x\n",
 		 mpc52xx_uart_nodes[idx]->full_name, idx);
 
-	uartclk = psc_ops->getuartclk(op->node);
+	uartclk = psc_ops->getuartclk(op->dev.of_node);
 	if (uartclk == 0) {
 		dev_dbg(&op->dev, "Could not find uart clock frequency!\n");
 		return -EINVAL;
@@ -1355,7 +1355,7 @@ mpc52xx_uart_of_probe(struct of_device *op, const struct of_device_id *match)
 	port->dev	= &op->dev;
 
 	/* Search for IRQ and mapbase */
-	ret = of_address_to_resource(op->node, 0, &res);
+	ret = of_address_to_resource(op->dev.of_node, 0, &res);
 	if (ret)
 		return ret;
 
@@ -1365,7 +1365,7 @@ mpc52xx_uart_of_probe(struct of_device *op, const struct of_device_id *match)
 		return -EINVAL;
 	}
 
-	psc_ops->get_irq(port, op->node);
+	psc_ops->get_irq(port, op->dev.of_node);
 	if (port->irq == NO_IRQ) {
 		dev_dbg(&op->dev, "Could not get irq\n");
 		return -EINVAL;
diff --git a/drivers/serial/nwpserial.c b/drivers/serial/nwpserial.c
index e1ab8ec..3c02fa9 100644
--- a/drivers/serial/nwpserial.c
+++ b/drivers/serial/nwpserial.c
@@ -344,7 +344,7 @@ int nwpserial_register_port(struct uart_port *port)
 
 	mutex_lock(&nwpserial_mutex);
 
-	dn = to_of_device(port->dev)->node;
+	dn = to_of_device(port->dev)->dev.of_node;
 	if (dn == NULL)
 		goto out;
 
diff --git a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
index cdf172e..18bf39b 100644
--- a/drivers/serial/of_serial.c
+++ b/drivers/serial/of_serial.c
@@ -30,7 +30,7 @@ static int __devinit of_platform_serial_setup(struct of_device *ofdev,
 					int type, struct uart_port *port)
 {
 	struct resource resource;
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	const unsigned int *clk, *spd;
 	const u32 *prop;
 	int ret, prop_size;
@@ -87,7 +87,7 @@ static int __devinit of_platform_serial_probe(struct of_device *ofdev,
 	int port_type;
 	int ret;
 
-	if (of_find_property(ofdev->node, "used-by-rtas", NULL))
+	if (of_find_property(ofdev->dev.of_node, "used-by-rtas", NULL))
 		return -EBUSY;
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
diff --git a/drivers/serial/pmac_zilog.c b/drivers/serial/pmac_zilog.c
index f020de1..8abbbb3 100644
--- a/drivers/serial/pmac_zilog.c
+++ b/drivers/serial/pmac_zilog.c
@@ -1610,7 +1610,7 @@ static int pmz_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	/* Iterate the pmz_ports array to find a matching entry
 	 */
 	for (i = 0; i < MAX_ZS_PORTS; i++)
-		if (pmz_ports[i].node == mdev->ofdev.node) {
+		if (pmz_ports[i].node == mdev->ofdev.dev.of_node) {
 			struct uart_pmac_port *uap = &pmz_ports[i];
 
 			uap->dev = mdev;
diff --git a/drivers/serial/sunhv.c b/drivers/serial/sunhv.c
index d14cca7..d1eedf1 100644
--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -565,7 +565,7 @@ static int __devinit hv_probe(struct of_device *op, const struct of_device_id *m
 	if (err)
 		goto out_free_con_read_page;
 
-	sunserial_console_match(&sunhv_console, op->node,
+	sunserial_console_match(&sunhv_console, op->dev.of_node,
 				&sunhv_reg, port->line, false);
 
 	err = uart_add_one_port(&sunhv_reg, port);
diff --git a/drivers/serial/sunsab.c b/drivers/serial/sunsab.c
index d514e28..2b8b2c2 100644
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -883,7 +883,7 @@ static int sunsab_console_setup(struct console *con, char *options)
 	printk("Console: ttyS%d (SAB82532)\n",
 	       (sunsab_reg.minor - 64) + con->index);
 
-	sunserial_console_termios(con, to_of_device(up->port.dev)->node);
+	sunserial_console_termios(con, to_of_device(up->port.dev)->dev.of_node);
 
 	switch (con->cflag & CBAUD) {
 	case B150: baud = 150; break;
@@ -1026,11 +1026,11 @@ static int __devinit sab_probe(struct of_device *op, const struct of_device_id *
 	if (err)
 		goto out1;
 
-	sunserial_console_match(SUNSAB_CONSOLE(), op->node,
+	sunserial_console_match(SUNSAB_CONSOLE(), op->dev.of_node,
 				&sunsab_reg, up[0].port.line,
 				false);
 
-	sunserial_console_match(SUNSAB_CONSOLE(), op->node,
+	sunserial_console_match(SUNSAB_CONSOLE(), op->dev.of_node,
 				&sunsab_reg, up[1].port.line,
 				false);
 
diff --git a/drivers/serial/sunsu.c b/drivers/serial/sunsu.c
index 170d3d6..2ab82ed 100644
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1199,7 +1199,7 @@ static int __devinit sunsu_kbd_ms_init(struct uart_sunsu_port *up)
 		return -ENODEV;
 
 	printk("%s: %s port at %llx, irq %u\n",
-	       to_of_device(up->port.dev)->node->full_name,
+	       to_of_device(up->port.dev)->dev.of_node->full_name,
 	       (up->su_type == SU_PORT_KBD) ? "Keyboard" : "Mouse",
 	       (unsigned long long) up->port.mapbase,
 	       up->port.irq);
@@ -1351,7 +1351,7 @@ static int __init sunsu_console_setup(struct console *co, char *options)
 	spin_lock_init(&port->lock);
 
 	/* Get firmware console settings.  */
-	sunserial_console_termios(co, to_of_device(port->dev)->node);
+	sunserial_console_termios(co, to_of_device(port->dev)->dev.of_node);
 
 	memset(&termios, 0, sizeof(struct ktermios));
 	termios.c_cflag = co->cflag;
@@ -1408,7 +1408,7 @@ static enum su_type __devinit su_get_type(struct device_node *dp)
 static int __devinit su_probe(struct of_device *op, const struct of_device_id *match)
 {
 	static int inst;
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 	struct uart_sunsu_port *up;
 	struct resource *rp;
 	enum su_type type;
diff --git a/drivers/serial/sunzilog.c b/drivers/serial/sunzilog.c
index 2c7a66a..20f9be8 100644
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -1180,7 +1180,7 @@ static int __init sunzilog_console_setup(struct console *con, char *options)
 	       (sunzilog_reg.minor - 64) + con->index, con->index);
 
 	/* Get firmware console settings.  */
-	sunserial_console_termios(con, to_of_device(up->port.dev)->node);
+	sunserial_console_termios(con, to_of_device(up->port.dev)->dev.of_node);
 
 	/* Firmware console speed is limited to 150-->38400 baud so
 	 * this hackish cflag thing is OK.
@@ -1358,7 +1358,7 @@ static int __devinit zs_probe(struct of_device *op, const struct of_device_id *m
 	int keyboard_mouse = 0;
 	int err;
 
-	if (of_find_property(op->node, "keyboard", NULL))
+	if (of_find_property(op->dev.of_node, "keyboard", NULL))
 		keyboard_mouse = 1;
 
 	/* uarts must come before keyboards/mice */
@@ -1415,7 +1415,7 @@ static int __devinit zs_probe(struct of_device *op, const struct of_device_id *m
 	sunzilog_init_hw(&up[1]);
 
 	if (!keyboard_mouse) {
-		if (sunserial_console_match(SUNZILOG_CONSOLE(), op->node,
+		if (sunserial_console_match(SUNZILOG_CONSOLE(), op->dev.of_node,
 					    &sunzilog_reg, up[0].port.line,
 					    false))
 			up->flags |= SUNZILOG_FLAG_IS_CONS;
@@ -1425,7 +1425,7 @@ static int __devinit zs_probe(struct of_device *op, const struct of_device_id *m
 				   rp, sizeof(struct zilog_layout));
 			return err;
 		}
-		if (sunserial_console_match(SUNZILOG_CONSOLE(), op->node,
+		if (sunserial_console_match(SUNZILOG_CONSOLE(), op->dev.of_node,
 					    &sunzilog_reg, up[1].port.line,
 					    false))
 			up->flags |= SUNZILOG_FLAG_IS_CONS;
diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index ab2ab3c..4b1d5a3 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -591,15 +591,15 @@ ulite_of_probe(struct of_device *op, const struct of_device_id *match)
 
 	dev_dbg(&op->dev, "%s(%p, %p)\n", __func__, op, match);
 
-	rc = of_address_to_resource(op->node, 0, &res);
+	rc = of_address_to_resource(op->dev.of_node, 0, &res);
 	if (rc) {
 		dev_err(&op->dev, "invalid address\n");
 		return rc;
 	}
 
-	irq = irq_of_parse_and_map(op->node, 0);
+	irq = irq_of_parse_and_map(op->dev.of_node, 0);
 
-	id = of_get_property(op->node, "port-number", NULL);
+	id = of_get_property(op->dev.of_node, "port-number", NULL);
 
 	return ulite_assign(&op->dev, id ? *id : -1, res.start+3, irq);
 }
diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/mpc52xx_psc_spi.c
index 0474786..f12cfd9 100644
--- a/drivers/spi/mpc52xx_psc_spi.c
+++ b/drivers/spi/mpc52xx_psc_spi.c
@@ -471,18 +471,18 @@ static int __init mpc52xx_psc_spi_of_probe(struct of_device *op,
 	s16 id = -1;
 	int rc;
 
-	regaddr_p = of_get_address(op->node, 0, &size64, NULL);
+	regaddr_p = of_get_address(op->dev.of_node, 0, &size64, NULL);
 	if (!regaddr_p) {
 		dev_err(&op->dev, "Invalid PSC address\n");
 		return -EINVAL;
 	}
-	regaddr64 = of_translate_address(op->node, regaddr_p);
+	regaddr64 = of_translate_address(op->dev.of_node, regaddr_p);
 
 	/* get PSC id (1..6, used by port_config) */
 	if (op->dev.platform_data == NULL) {
 		const u32 *psc_nump;
 
-		psc_nump = of_get_property(op->node, "cell-index", NULL);
+		psc_nump = of_get_property(op->dev.of_node, "cell-index", NULL);
 		if (!psc_nump || *psc_nump > 5) {
 			dev_err(&op->dev, "Invalid cell-index property\n");
 			return -EINVAL;
@@ -491,9 +491,10 @@ static int __init mpc52xx_psc_spi_of_probe(struct of_device *op,
 	}
 
 	rc = mpc52xx_psc_spi_do_probe(&op->dev, (u32)regaddr64, (u32)size64,
-					irq_of_parse_and_map(op->node, 0), id);
+				irq_of_parse_and_map(op->dev.of_node, 0), id);
 	if (rc == 0)
-		of_register_spi_devices(dev_get_drvdata(&op->dev), op->node);
+		of_register_spi_devices(dev_get_drvdata(&op->dev),
+					op->dev.of_node);
 
 	return rc;
 }
diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
index 6eab465..907c39a 100644
--- a/drivers/spi/mpc52xx_spi.c
+++ b/drivers/spi/mpc52xx_spi.c
@@ -402,7 +402,7 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 
 	/* MMIO registers */
 	dev_dbg(&op->dev, "probing mpc5200 SPI device\n");
-	regs = of_iomap(op->node, 0);
+	regs = of_iomap(op->dev.of_node, 0);
 	if (!regs)
 		return -ENODEV;
 
@@ -444,11 +444,11 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 	ms = spi_master_get_devdata(master);
 	ms->master = master;
 	ms->regs = regs;
-	ms->irq0 = irq_of_parse_and_map(op->node, 0);
-	ms->irq1 = irq_of_parse_and_map(op->node, 1);
+	ms->irq0 = irq_of_parse_and_map(op->dev.of_node, 0);
+	ms->irq1 = irq_of_parse_and_map(op->dev.of_node, 1);
 	ms->state = mpc52xx_spi_fsmstate_idle;
-	ms->ipb_freq = mpc5xxx_get_bus_frequency(op->node);
-	ms->gpio_cs_count = of_gpio_count(op->node);
+	ms->ipb_freq = mpc5xxx_get_bus_frequency(op->dev.of_node);
+	ms->gpio_cs_count = of_gpio_count(op->dev.of_node);
 	if (ms->gpio_cs_count > 0) {
 		master->num_chipselect = ms->gpio_cs_count;
 		ms->gpio_cs = kmalloc(ms->gpio_cs_count * sizeof(unsigned int),
@@ -459,7 +459,7 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 		}
 
 		for (i = 0; i < ms->gpio_cs_count; i++) {
-			gpio_cs = of_get_gpio(op->node, i);
+			gpio_cs = of_get_gpio(op->dev.of_node, i);
 			if (gpio_cs < 0) {
 				dev_err(&op->dev,
 					"could not parse the gpio field "
@@ -511,7 +511,7 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 	if (rc)
 		goto err_register;
 
-	of_register_spi_devices(master, op->node);
+	of_register_spi_devices(master, op->dev.of_node);
 	dev_info(&ms->master->dev, "registered MPC5200 SPI bus\n");
 
 	return rc;
diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
index 4f0cc9d..38b9c32 100644
--- a/drivers/spi/spi_mpc8xxx.c
+++ b/drivers/spi/spi_mpc8xxx.c
@@ -796,7 +796,7 @@ static void mpc8xxx_spi_free_dummy_rx(void)
 static unsigned long mpc8xxx_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
 {
 	struct device *dev = mspi->dev;
-	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	struct device_node *np = dev->of_node;
 	const u32 *iprop;
 	int size;
 	unsigned long spi_base_ofs;
@@ -850,7 +850,7 @@ static unsigned long mpc8xxx_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
 static int mpc8xxx_spi_cpm_init(struct mpc8xxx_spi *mspi)
 {
 	struct device *dev = mspi->dev;
-	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	struct device_node *np = dev->of_node;
 	const u32 *iprop;
 	int size;
 	unsigned long pram_ofs;
@@ -1122,7 +1122,7 @@ static void mpc8xxx_spi_cs_control(struct spi_device *spi, bool on)
 
 static int of_mpc8xxx_spi_get_chipselects(struct device *dev)
 {
-	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	struct device_node *np = dev->of_node;
 	struct fsl_spi_platform_data *pdata = dev->platform_data;
 	struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(pdata);
 	unsigned int ngpios;
diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
index 8df33b8..ad06623 100644
--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -108,7 +108,7 @@ ppc44x_enable_bmt(struct device_node *dn)
 static int __devinit
 ehci_hcd_ppc_of_probe(struct of_device *op, const struct of_device_id *match)
 {
-	struct device_node *dn = op->node;
+	struct device_node *dn = op->dev.of_node;
 	struct usb_hcd *hcd;
 	struct ehci_hcd	*ehci = NULL;
 	struct resource res;
diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index 4293cfd..36360e2 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -31,7 +31,7 @@ static int of_isp1760_probe(struct of_device *dev,
 		const struct of_device_id *match)
 {
 	struct usb_hcd *hcd;
-	struct device_node *dp = dev->node;
+	struct device_node *dp = dev->dev.of_node;
 	struct resource *res;
 	struct resource memory;
 	struct of_irq oirq;
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index 103263c..003aea2 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -83,7 +83,7 @@ static const struct hc_driver ohci_ppc_of_hc_driver = {
 static int __devinit
 ohci_hcd_ppc_of_probe(struct of_device *op, const struct of_device_id *match)
 {
-	struct device_node *dn = op->node;
+	struct device_node *dn = op->dev.of_node;
 	struct usb_hcd *hcd;
 	struct ohci_hcd	*ohci;
 	struct resource res;
diff --git a/drivers/video/cg6.c b/drivers/video/cg6.c
index 0d47c60..978c15f 100644
--- a/drivers/video/cg6.c
+++ b/drivers/video/cg6.c
@@ -741,7 +741,7 @@ static void cg6_unmap_regs(struct of_device *op, struct fb_info *info,
 static int __devinit cg6_probe(struct of_device *op,
 				const struct of_device_id *match)
 {
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 	struct fb_info *info;
 	struct cg6_par *par;
 	int linebytes, err;
diff --git a/drivers/video/ffb.c b/drivers/video/ffb.c
index 9dbb964..be0c982 100644
--- a/drivers/video/ffb.c
+++ b/drivers/video/ffb.c
@@ -897,7 +897,7 @@ static void ffb_init_fix(struct fb_info *info)
 static int __devinit ffb_probe(struct of_device *op,
 			       const struct of_device_id *match)
 {
-	struct device_node *dp = op->node;
+	struct device_node *dp = op->dev.of_node;
 	struct ffb_fbc __iomem *fbc;
 	struct ffb_dac __iomem *dac;
 	struct fb_info *info;
diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index 4637bcb..80a8eae 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -1421,7 +1421,7 @@ static ssize_t show_monitor(struct device *device,
 static int __devinit fsl_diu_probe(struct of_device *ofdev,
 	const struct of_device_id *match)
 {
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct mfb_info *mfbi;
 	phys_addr_t dummy_ad_addr;
 	int ret, i, error = 0;
diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index ed7c8d0..ba6ee6f 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -422,7 +422,7 @@ xilinxfb_of_probe(struct of_device *op, const struct of_device_id *match)
 	 * To check whether the core is connected directly to DCR or PLB
 	 * interface and initialize the tft_access accordingly.
 	 */
-	p = (u32 *)of_get_property(op->node, "xlnx,dcr-splb-slave-if", NULL);
+	p = (u32 *)of_get_property(op->dev.of_node, "xlnx,dcr-splb-slave-if", NULL);
 	tft_access = p ? *p : 0;
 
 	/*
@@ -431,41 +431,41 @@ xilinxfb_of_probe(struct of_device *op, const struct of_device_id *match)
 	 */
 	if (tft_access) {
 		drvdata->flags |= PLB_ACCESS_FLAG;
-		rc = of_address_to_resource(op->node, 0, &res);
+		rc = of_address_to_resource(op->dev.of_node, 0, &res);
 		if (rc) {
 			dev_err(&op->dev, "invalid address\n");
 			goto err;
 		}
 	} else {
 		res.start = 0;
-		start = dcr_resource_start(op->node, 0);
-		drvdata->dcr_len = dcr_resource_len(op->node, 0);
-		drvdata->dcr_host = dcr_map(op->node, start, drvdata->dcr_len);
+		start = dcr_resource_start(op->dev.of_node, 0);
+		drvdata->dcr_len = dcr_resource_len(op->dev.of_node, 0);
+		drvdata->dcr_host = dcr_map(op->dev.of_node, start, drvdata->dcr_len);
 		if (!DCR_MAP_OK(drvdata->dcr_host)) {
 			dev_err(&op->dev, "invalid DCR address\n");
 			goto err;
 		}
 	}
 
-	prop = of_get_property(op->node, "phys-size", &size);
+	prop = of_get_property(op->dev.of_node, "phys-size", &size);
 	if ((prop) && (size >= sizeof(u32)*2)) {
 		pdata.screen_width_mm = prop[0];
 		pdata.screen_height_mm = prop[1];
 	}
 
-	prop = of_get_property(op->node, "resolution", &size);
+	prop = of_get_property(op->dev.of_node, "resolution", &size);
 	if ((prop) && (size >= sizeof(u32)*2)) {
 		pdata.xres = prop[0];
 		pdata.yres = prop[1];
 	}
 
-	prop = of_get_property(op->node, "virtual-resolution", &size);
+	prop = of_get_property(op->dev.of_node, "virtual-resolution", &size);
 	if ((prop) && (size >= sizeof(u32)*2)) {
 		pdata.xvirt = prop[0];
 		pdata.yvirt = prop[1];
 	}
 
-	if (of_find_property(op->node, "rotate-display", NULL))
+	if (of_find_property(op->dev.of_node, "rotate-display", NULL))
 		pdata.rotate_screen = 1;
 
 	dev_set_drvdata(&op->dev, drvdata);
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 37ea052..89da14f 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -576,7 +576,7 @@ static int __devinit cpwd_probe(struct of_device *op,
 	 * interrupt_mask register cannot be written, so no timer
 	 * interrupts can be masked within the PLD.
 	 */
-	str_prop = of_get_property(op->node, "model", NULL);
+	str_prop = of_get_property(op->dev.of_node, "model", NULL);
 	p->broken = (str_prop && !strcmp(str_prop, WD_BADMODEL));
 
 	if (!p->enabled)
diff --git a/sound/aoa/fabrics/layout.c b/sound/aoa/fabrics/layout.c
index 7a437da..da38f2b 100644
--- a/sound/aoa/fabrics/layout.c
+++ b/sound/aoa/fabrics/layout.c
@@ -991,7 +991,7 @@ static int aoa_fabric_layout_probe(struct soundbus_dev *sdev)
 		return -ENODEV;
 
 	/* by breaking out we keep a reference */
-	while ((sound = of_get_next_child(sdev->ofdev.node, sound))) {
+	while ((sound = of_get_next_child(sdev->ofdev.dev.of_node, sound))) {
 		if (sound->type && strcasecmp(sound->type, "soundchip") == 0)
 			break;
 	}
diff --git a/sound/aoa/soundbus/core.c b/sound/aoa/soundbus/core.c
index fa8ab28..99ca712 100644
--- a/sound/aoa/soundbus/core.c
+++ b/sound/aoa/soundbus/core.c
@@ -74,11 +74,11 @@ static int soundbus_uevent(struct device *dev, struct kobj_uevent_env *env)
 	of = &soundbus_dev->ofdev;
 
 	/* stuff we want to pass to /sbin/hotplug */
-	retval = add_uevent_var(env, "OF_NAME=%s", of->node->name);
+	retval = add_uevent_var(env, "OF_NAME=%s", of->dev.of_node->name);
 	if (retval)
 		return retval;
 
-	retval = add_uevent_var(env, "OF_TYPE=%s", of->node->type);
+	retval = add_uevent_var(env, "OF_TYPE=%s", of->dev.of_node->type);
 	if (retval)
 		return retval;
 
@@ -86,7 +86,7 @@ static int soundbus_uevent(struct device *dev, struct kobj_uevent_env *env)
 	 * it's not really legal to split it out with commas. We split it
 	 * up using a number of environment variables instead. */
 
-	compat = of_get_property(of->node, "compatible", &cplen);
+	compat = of_get_property(of->dev.of_node, "compatible", &cplen);
 	while (compat && cplen > 0) {
 		int tmp = env->buflen;
 		retval = add_uevent_var(env, "OF_COMPATIBLE_%d=%s", seen, compat);
@@ -169,7 +169,7 @@ int soundbus_add_one(struct soundbus_dev *dev)
 
 	/* sanity checks */
 	if (!dev->attach_codec ||
-	    !dev->ofdev.node ||
+	    !dev->ofdev.dev.of_node ||
 	    dev->pcmname ||
 	    dev->pcmid != -1) {
 		printk(KERN_ERR "soundbus: adding device failed sanity check!\n");
diff --git a/sound/aoa/soundbus/i2sbus/control.c b/sound/aoa/soundbus/i2sbus/control.c
index 87beb4a..799804d 100644
--- a/sound/aoa/soundbus/i2sbus/control.c
+++ b/sound/aoa/soundbus/i2sbus/control.c
@@ -41,7 +41,7 @@ int i2sbus_control_add_dev(struct i2sbus_control *c,
 {
 	struct device_node *np;
 
-	np = i2sdev->sound.ofdev.node;
+	np = i2sdev->sound.ofdev.dev.of_node;
 	i2sdev->enable = pmf_find_function(np, "enable");
 	i2sdev->cell_enable = pmf_find_function(np, "cell-enable");
 	i2sdev->clock_enable = pmf_find_function(np, "clock-enable");
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 4e3b819..ddb1577 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -220,8 +220,8 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 
 	mutex_init(&dev->lock);
 	spin_lock_init(&dev->low_lock);
-	dev->sound.ofdev.node = np;
 	dev->sound.ofdev.dma_mask = macio->ofdev.dma_mask;
+	dev->sound.ofdev.dev.of_node = np;
 	dev->sound.ofdev.dev.dma_mask = &dev->sound.ofdev.dma_mask;
 	dev->sound.ofdev.dev.parent = &macio->ofdev.dev;
 	dev->sound.ofdev.dev.release = i2sbus_release_dev;
@@ -345,7 +345,7 @@ static int i2sbus_probe(struct macio_dev* dev, const struct of_device_id *match)
 		return -ENODEV;
 	}
 
-	while ((np = of_get_next_child(dev->ofdev.node, np))) {
+	while ((np = of_get_next_child(dev->ofdev.dev.of_node, np))) {
 		if (of_device_is_compatible(np, "i2sbus") ||
 		    of_device_is_compatible(np, "i2s-modem")) {
 			got += i2sbus_add_dev(dev, control, np);
diff --git a/sound/aoa/soundbus/sysfs.c b/sound/aoa/soundbus/sysfs.c
index f580942..6496e75 100644
--- a/sound/aoa/soundbus/sysfs.c
+++ b/sound/aoa/soundbus/sysfs.c
@@ -9,7 +9,7 @@ field##_show (struct device *dev, struct device_attribute *attr,	\
               char *buf)						\
 {									\
 	struct soundbus_dev *mdev = to_soundbus_device (dev);		\
-	return sprintf (buf, format_string, mdev->ofdev.node->field);	\
+	return sprintf (buf, format_string, mdev->ofdev.dev.of_node->field); \
 }
 
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
@@ -25,7 +25,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		length = strlen(buf);
 	} else {
 		length = sprintf(buf, "of:N%sT%s\n",
-				 of->node->name, of->node->type);
+				 of->dev.of_node->name, of->dev.of_node->type);
 	}
 
 	return length;
diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
index ef67d1c..d7e1b9a 100644
--- a/sound/soc/fsl/mpc8610_hpcd.c
+++ b/sound/soc/fsl/mpc8610_hpcd.c
@@ -202,7 +202,7 @@ static struct snd_soc_ops mpc8610_hpcd_ops = {
 static int mpc8610_hpcd_probe(struct of_device *ofdev,
 	const struct of_device_id *match)
 {
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct device_node *codec_np = NULL;
 	struct device_node *guts_np = NULL;
 	struct device_node *dma_np = NULL;
diff --git a/sound/sparc/cs4231.c b/sound/sparc/cs4231.c
index 8d13d93..14cb87c 100644
--- a/sound/sparc/cs4231.c
+++ b/sound/sparc/cs4231.c
@@ -2076,12 +2076,12 @@ static int __devinit cs4231_ebus_probe(struct of_device *op, const struct of_dev
 static int __devinit cs4231_probe(struct of_device *op, const struct of_device_id *match)
 {
 #ifdef EBUS_SUPPORT
-	if (!strcmp(op->node->parent->name, "ebus"))
+	if (!strcmp(op->dev.of_node->parent->name, "ebus"))
 		return cs4231_ebus_probe(op, match);
 #endif
 #ifdef SBUS_SUPPORT
-	if (!strcmp(op->node->parent->name, "sbus") ||
-	    !strcmp(op->node->parent->name, "sbi"))
+	if (!strcmp(op->dev.of_node->parent->name, "sbus") ||
+	    !strcmp(op->dev.of_node->parent->name, "sbi"))
 		return cs4231_sbus_probe(op, match);
 #endif
 	return -ENODEV;
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 1d2e51b..2734c36 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -2650,7 +2650,7 @@ static int __devinit dbri_probe(struct of_device *op, const struct of_device_id
 
 	printk(KERN_INFO "audio%d at %p (irq %d) is DBRI(%c)+CS4215(%d)\n",
 	       dev, dbri->regs,
-	       dbri->irq, op->node->name[9], dbri->mm.version);
+	       dbri->irq, op->dev.of_node->name[9], dbri->mm.version);
 	dev++;
 
 	return 0;

