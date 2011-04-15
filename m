Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1DOWxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:53:36 -0400
Received: from mail.perches.com ([173.55.12.10]:4728 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab1DOWxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:53:34 -0400
From: Joe Perches <joe@perches.com>
To: Jeff Garzik <jgarzik@pobox.com>, Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ata: Add and use ata_print_version_once
Date: Fri, 15 Apr 2011 15:52:00 -0700
Message-Id: <440aa7f6bb99bec705b83796894f843bfc1b7bf9.1302907497.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302907496.git.joe@perches.com>
References: <cover.1302907496.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a single mechanism to show driver version.
Reduces text a tiny bit too.

Remove uses of static int printed_version
Add and use ata_print_version(const struct device *, const char *ver)
and ata_print_version_once.

$ size drivers/ata/built-in.*
   text	   data	    bss	    dec	    hex	filename
 544969	  73893	 116584	 735446	  b38d6	drivers/ata/built-in.allyesconfig.ata.o
 543870	  73893	 116592	 734355	  b34ad	drivers/ata/built-in.allyesconfig.print_once.o
 141328	  14689	   4220	 160237	  271ed	drivers/ata/built-in.defconfig.ata.o
 141212	  14689	   4220	 160121	  27179	drivers/ata/built-in.defconfig.print_once.o

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/acard-ahci.c     |    4 +---
 drivers/ata/ahci.c           |    4 +---
 drivers/ata/ata_piix.c       |    5 +----
 drivers/ata/libata-core.c    |    6 ++++++
 drivers/ata/pata_amd.c       |    4 +---
 drivers/ata/pata_artop.c     |    5 +----
 drivers/ata/pata_atp867x.c   |    4 +---
 drivers/ata/pata_efar.c      |    5 +----
 drivers/ata/pata_hpt3x3.c    |    4 +---
 drivers/ata/pata_it8213.c    |    5 +----
 drivers/ata/pata_ixp4xx_cf.c |    2 +-
 drivers/ata/pata_mpiix.c     |    4 +---
 drivers/ata/pata_netcell.c   |    5 +----
 drivers/ata/pata_ns87415.c   |    5 +----
 drivers/ata/pata_octeon_cf.c |    6 ++++--
 drivers/ata/pata_oldpiix.c   |    5 +----
 drivers/ata/pata_opti.c      |    4 +---
 drivers/ata/pata_optidma.c   |    4 +---
 drivers/ata/pata_pdc2027x.c  |    4 +---
 drivers/ata/pata_radisys.c   |    5 +----
 drivers/ata/pata_rdc.c       |    5 +----
 drivers/ata/pata_rz1000.c    |    2 +-
 drivers/ata/pata_scc.c       |    5 +----
 drivers/ata/pata_sch.c       |    5 +----
 drivers/ata/pata_sil680.c    |    4 +---
 drivers/ata/pata_sis.c       |    5 +----
 drivers/ata/pata_triflex.c   |    4 +---
 drivers/ata/pata_via.c       |    4 +---
 drivers/ata/pdc_adma.c       |    4 +---
 drivers/ata/sata_inic162x.c  |    4 +---
 drivers/ata/sata_mv.c        |    8 ++------
 drivers/ata/sata_nv.c        |    4 +---
 drivers/ata/sata_promise.c   |    4 +---
 drivers/ata/sata_qstor.c     |    4 +---
 drivers/ata/sata_sil.c       |    4 +---
 drivers/ata/sata_sil24.c     |    4 +---
 drivers/ata/sata_sis.c       |    4 +---
 drivers/ata/sata_svw.c       |    4 +---
 drivers/ata/sata_sx4.c       |    4 +---
 drivers/ata/sata_uli.c       |    4 +---
 drivers/ata/sata_via.c       |    4 +---
 drivers/ata/sata_vsc.c       |    4 +---
 include/linux/libata.h       |   12 ++++++++++++
 43 files changed, 63 insertions(+), 133 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 06a23be..be7b139 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -403,7 +403,6 @@ static int acard_ahci_port_start(struct ata_port *ap)
 
 static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	unsigned int board_id = ent->driver_data;
 	struct ata_port_info pi = acard_ahci_port_info[board_id];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
@@ -416,8 +415,7 @@ static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id
 
 	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5296792..c74a7c1 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1053,7 +1053,6 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	unsigned int board_id = ent->driver_data;
 	struct ata_port_info pi = ahci_port_info[board_id];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
@@ -1066,8 +1065,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	WARN_ON((int)ATA_MAX_QUEUE > AHCI_MAX_CMDS);
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* The AHCI driver can only drive the SATA ports, the PATA driver
 	   can drive them all so if both drivers are selected make sure
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 86cf97e..27f7b94 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1554,7 +1554,6 @@ static bool piix_broken_system_poweroff(struct pci_dev *pdev)
 static int __devinit piix_init_one(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
 {
-	static int printed_version;
 	struct device *dev = &pdev->dev;
 	struct ata_port_info port_info[2];
 	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
@@ -1564,9 +1563,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	struct piix_host_priv *hpriv;
 	int rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* no hotplugging support for later devices (FIXME) */
 	if (!in_module_init && ent->driver_data >= ich5_sata)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 03b05b0..8319770 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6640,6 +6640,12 @@ int ata_dev_printk(const struct ata_device *dev, const char *level,
 }
 EXPORT_SYMBOL(ata_dev_printk);
 
+void ata_print_version(const struct device *dev, const char *version)
+{
+	dev_printk(KERN_DEBUG, dev, "version %s\n", version);
+}
+EXPORT_SYMBOL(ata_print_version);
+
 /*
  * libata is essentially a library of internal helper functions for
  * low-level ATA host controller drivers.  As such, the API/ABI is
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 801554d..dc6b5da 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -530,14 +530,12 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	};
 	const struct ata_port_info *ppi[] = { NULL, NULL };
-	static int printed_version;
 	int type = id->driver_data;
 	void *hpriv = NULL;
 	u8 fifo;
 	int rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 2215632..78a93b6 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -346,7 +346,6 @@ static struct ata_port_operations artop6260_ops = {
 
 static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static int printed_version;
 	static const struct ata_port_info info_6210 = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
@@ -378,9 +377,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 	int rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
index bcbf998..3cfabb2 100644
--- a/drivers/ata/pata_atp867x.c
+++ b/drivers/ata/pata_atp867x.c
@@ -487,7 +487,6 @@ static int atp867x_ata_pci_sff_init_host(struct ata_host *host)
 static int atp867x_init_one(struct pci_dev *pdev,
 	const struct pci_device_id *id)
 {
-	static int printed_version;
 	static const struct ata_port_info info_867x = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
@@ -499,8 +498,7 @@ static int atp867x_init_one(struct pci_dev *pdev,
 	const struct ata_port_info *ppi[] = { &info_867x, NULL };
 	int rc;
 
-	if (!printed_version++)
-		dev_info(&pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index a088347..aca47e4 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -263,7 +263,6 @@ static struct ata_port_operations efar_ops = {
 
 static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
@@ -273,9 +272,7 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	};
 	const struct ata_port_info *ppi[] = { &info, &info };
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &efar_sht, NULL,
 				      ATA_HOST_PARALLEL_SCAN);
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index 24d7df8..b3042da 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -185,7 +185,6 @@ static void hpt3x3_init_chipset(struct pci_dev *dev)
 
 static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
@@ -206,8 +205,7 @@ static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	hpt3x3_init_chipset(pdev);
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
 	if (!host)
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 4d142a2..998af0e 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -258,7 +258,6 @@ static struct ata_port_operations it8213_ops = {
 
 static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
@@ -269,9 +268,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	/* Current IT8213 stuff is single port */
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &it8213_sht, NULL, 0);
 }
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index fc424924..15b6431 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -181,7 +181,7 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 
 	ixp4xx_setup_port(ap, data, cs0->start, cs1->start);
 
-	dev_info(&pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* activate host */
 	return ata_host_activate(host, irq, ata_sff_interrupt, 0, &ixp4xx_sht);
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index d8d9c58..9dc16df 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -152,15 +152,13 @@ static struct ata_port_operations mpiix_port_ops = {
 static int mpiix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	/* Single threaded by the PCI probe logic */
-	static int printed_version;
 	struct ata_host *host;
 	struct ata_port *ap;
 	void __iomem *cmd_addr, *ctl_addr;
 	u16 idetim;
 	int cmd, ctl, irq;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&dev->dev, DRV_VERSION);
 
 	host = ata_host_alloc(&dev->dev, 1);
 	if (!host)
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index 3eb921c..9979a43 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -57,7 +57,6 @@ static struct ata_port_operations netcell_ops = {
 
 static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		/* Actually we don't really care about these as the
@@ -70,9 +69,7 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	const struct ata_port_info *port_info[] = { &info, NULL };
 	int rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index 605f198..f1d517b 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -350,7 +350,6 @@ static void ns87415_fixup(struct pci_dev *pdev)
 
 static int ns87415_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
@@ -370,9 +369,7 @@ static int ns87415_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	if (PCI_SLOT(pdev->devfn) == 0x0E)
 		ppi[0] = &info87560;
 #endif
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index c8707f0..1d61d5d 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -807,6 +807,7 @@ static int __devinit octeon_cf_probe(struct platform_device *pdev)
 	irq_handler_t irq_handler = NULL;
 	void __iomem *base;
 	struct octeon_cf_port *cf_port;
+	char version[32];
 
 	res_cs0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
@@ -905,10 +906,11 @@ static int __devinit octeon_cf_probe(struct platform_device *pdev)
 	ata_port_desc(ap, "cmd %p ctl %p", base, ap->ioaddr.ctl_addr);
 
 
-	dev_info(&pdev->dev, "version " DRV_VERSION" %d bit%s.\n",
+	snprintf(version, sizeof(version), "%s %d bit%s",
+		 DRV_VERSION,
 		 (ocd->is16bit) ? 16 : 8,
 		 (cs1) ? ", True IDE" : "");
-
+	ata_print_version_once(&pdev->dev, version);
 
 	return ata_host_activate(host, irq, irq_handler, 0, &octeon_cf_sht);
 
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index b811c16..98cdf50 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -235,7 +235,6 @@ static struct ata_port_operations oldpiix_pata_ops = {
 
 static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
@@ -244,9 +243,7 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &oldpiix_sht, NULL, 0);
 }
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index 00c5a02..accc033 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -167,10 +167,8 @@ static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &opti_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
-	static int printed_version;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&dev->dev, DRV_VERSION);
 
 	return ata_pci_sff_init_one(dev, ppi, &opti_sht, NULL, 0);
 }
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 0852cd0..77cb914 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -411,11 +411,9 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &optiplus_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info_82c700, NULL };
-	static int printed_version;
 	int rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&dev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(dev);
 	if (rc)
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index c8cdd6d..b1511f3 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -697,7 +697,6 @@ static void pdc_ata_setup_port(struct ata_ioports *port, void __iomem *base)
  */
 static int __devinit pdc2027x_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	static const unsigned long cmd_offset[] = { 0x17c0, 0x15c0 };
 	static const unsigned long bmdma_offset[] = { 0x1000, 0x1008 };
 	unsigned int board_idx = (unsigned int) ent->driver_data;
@@ -707,8 +706,7 @@ static int __devinit pdc2027x_init_one(struct pci_dev *pdev, const struct pci_de
 	void __iomem *mmio_base;
 	int i, rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* alloc host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 8574b31..b2d3a2b 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -213,7 +213,6 @@ static struct ata_port_operations radisys_pata_ops = {
 
 static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
@@ -223,9 +222,7 @@ static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &radisys_sht, NULL, 0);
 }
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index 5fbe9b1..4d318f8 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -312,7 +312,6 @@ static struct scsi_host_template rdc_sht = {
 static int __devinit rdc_init_one(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
 {
-	static int printed_version;
 	struct device *dev = &pdev->dev;
 	struct ata_port_info port_info[2];
 	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
@@ -321,9 +320,7 @@ static int __devinit rdc_init_one(struct pci_dev *pdev,
 	struct rdc_host_priv *hpriv;
 	int rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	port_info[0] = rdc_port_info;
 	port_info[1] = rdc_port_info;
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index ed8c905..aca321e 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -92,7 +92,7 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	printk_once(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	if (rz1000_fifo_disable(pdev) == 0)
 		return ata_pci_sff_init_one(pdev, ppi, &rz1000_sht, NULL, 0);
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index a72e366..eb748e3 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -1071,15 +1071,12 @@ static int scc_host_init(struct ata_host *host)
 
 static int scc_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	unsigned int board_idx = (unsigned int) ent->driver_data;
 	const struct ata_port_info *ppi[] = { &scc_port_info[board_idx], NULL };
 	struct ata_host *host;
 	int rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 1);
 	if (!host)
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index e97b32f..7c78b99 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -172,12 +172,9 @@ static void sch_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 static int __devinit sch_init_one(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
 {
-	static int printed_version;
 	const struct ata_port_info *ppi[] = { &sch_port_info, NULL };
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &sch_sht, NULL, 0);
 }
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 118787c..31f759b 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -327,13 +327,11 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 		.port_ops = &sil680_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
-	static int printed_version;
 	struct ata_host *host;
 	void __iomem *mmio_base;
 	int rc, try_mmio;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index be08ff9..533f2ae 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -681,7 +681,6 @@ static void sis_fixup(struct pci_dev *pdev, struct sis_chipset *sis)
 
 static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 	struct pci_dev *host = NULL;
 	struct sis_chipset *chipset = NULL;
@@ -735,9 +734,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		0x0, &sis_info100
 	};
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index 03b6d69..3e88439 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -196,10 +196,8 @@ static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &triflex_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
-	static int printed_version;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&dev->dev, DRV_VERSION);
 
 	return ata_pci_bmdma_init_one(dev, ppi, &triflex_sht, NULL, 0);
 }
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 74763c3..65e4be6 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -551,14 +551,12 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 	struct pci_dev *isa;
 	const struct via_isa_bridge *config;
-	static int printed_version;
 	u8 enable;
 	u32 timing;
 	unsigned long flags = id->driver_data;
 	int rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index fdad56c..04911d5 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -610,15 +610,13 @@ static int adma_set_dma_masks(struct pci_dev *pdev, void __iomem *mmio_base)
 static int adma_ata_init_one(struct pci_dev *pdev,
 			     const struct pci_device_id *ent)
 {
-	static int printed_version;
 	unsigned int board_idx = (unsigned int) ent->driver_data;
 	const struct ata_port_info *ppi[] = { &adma_port_info[board_idx], NULL };
 	struct ata_host *host;
 	void __iomem *mmio_base;
 	int rc, port_no;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* alloc host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, ADMA_PORTS);
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 7a5667d..5c7d70c 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -800,7 +800,6 @@ static int inic_pci_device_resume(struct pci_dev *pdev)
 
 static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	const struct ata_port_info *ppi[] = { &inic_port_info, NULL };
 	struct ata_host *host;
 	struct inic_host_priv *hpriv;
@@ -808,8 +807,7 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int mmio_bar;
 	int i, rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* alloc host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, NR_PORTS);
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index b0e45d2..4b6b209 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4018,7 +4018,6 @@ static void mv_conf_mbus_windows(struct mv_host_priv *hpriv,
  */
 static int mv_platform_probe(struct platform_device *pdev)
 {
-	static int printed_version;
 	const struct mv_sata_platform_data *mv_platform_data;
 	const struct ata_port_info *ppi[] =
 	    { &mv_port_info[chip_soc], NULL };
@@ -4027,8 +4026,7 @@ static int mv_platform_probe(struct platform_device *pdev)
 	struct resource *res;
 	int n_ports, rc;
 
-	if (!printed_version++)
-		dev_info(&pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/*
 	 * Simple resource validation ..
@@ -4285,15 +4283,13 @@ static void mv_print_info(struct ata_host *host)
 static int mv_pci_init_one(struct pci_dev *pdev,
 			   const struct pci_device_id *ent)
 {
-	static int printed_version;
 	unsigned int board_idx = (unsigned int)ent->driver_data;
 	const struct ata_port_info *ppi[] = { &mv_port_info[board_idx], NULL };
 	struct ata_host *host;
 	struct mv_host_priv *hpriv;
 	int n_ports, port, rc;
 
-	if (!printed_version++)
-		dev_info(&pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* allocate host */
 	n_ports = mv_get_hc_count(ppi[0]->flags) * MV_PORTS_PER_HC;
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index b33f525..e0bc964 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -2353,7 +2353,6 @@ static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance)
 
 static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 	struct nv_pi_priv *ipriv;
 	struct ata_host *host;
@@ -2370,8 +2369,7 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (pci_resource_start(pdev, bar) == 0)
 			return -ENODEV;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 2ad51f9..000fcc9 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -1179,7 +1179,6 @@ static void pdc_host_init(struct ata_host *host)
 static int pdc_ata_init_one(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
-	static int printed_version;
 	const struct ata_port_info *pi = &pdc_port_info[ent->driver_data];
 	const struct ata_port_info *ppi[PDC_MAX_PORTS];
 	struct ata_host *host;
@@ -1187,8 +1186,7 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 	int n_ports, i, rc;
 	int is_sataii_tx4;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* enable and acquire resources */
 	rc = pcim_enable_device(pdev);
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 5702561..9d1a47b 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -587,14 +587,12 @@ static int qs_set_dma_masks(struct pci_dev *pdev, void __iomem *mmio_base)
 static int qs_ata_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	static int printed_version;
 	unsigned int board_idx = (unsigned int) ent->driver_data;
 	const struct ata_port_info *ppi[] = { &qs_port_info[board_idx], NULL };
 	struct ata_host *host;
 	int rc, port_no;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* alloc host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, QS_PORTS);
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 280ba8a..98c1d78 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -732,7 +732,6 @@ static bool sil_broken_system_poweroff(struct pci_dev *pdev)
 
 static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	int board_id = ent->driver_data;
 	struct ata_port_info pi = sil_port_info[board_id];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
@@ -741,8 +740,7 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int n_ports, rc;
 	unsigned int i;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* allocate host */
 	n_ports = 2;
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 792e936..55470f3 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1270,7 +1270,6 @@ static void sil24_init_controller(struct ata_host *host)
 static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	extern int __MARKER__sil24_cmd_block_is_sized_wrongly;
-	static int printed_version;
 	struct ata_port_info pi = sil24_port_info[ent->driver_data];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 	void __iomem * const *iomap;
@@ -1282,8 +1281,7 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (sizeof(union sil24_cmd_block) != PAGE_SIZE)
 		__MARKER__sil24_cmd_block_is_sized_wrongly = 1;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index ae040de..447d9c0 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -193,7 +193,6 @@ static int sis_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 
 static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	struct ata_port_info pi = sis_port_info;
 	const struct ata_port_info *ppi[] = { &pi, &pi };
 	struct ata_host *host;
@@ -202,8 +201,7 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	u8 port2_start = 0x20;
 	int i, rc;
 
-	if (!printed_version++)
-		dev_info(&pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 35eabcf..c646118 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -414,15 +414,13 @@ static void k2_sata_setup_port(struct ata_ioports *port, void __iomem *base)
 
 static int k2_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	const struct ata_port_info *ppi[] =
 		{ &k2_port_info[ent->driver_data], NULL };
 	struct ata_host *host;
 	void __iomem *mmio_base;
 	int n_ports, i, rc, bar_pos;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* allocate host */
 	n_ports = 4;
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 8fd3b72..cdaebbe 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -1440,15 +1440,13 @@ static void pdc_20621_init(struct ata_host *host)
 static int pdc_sata_init_one(struct pci_dev *pdev,
 			     const struct pci_device_id *ent)
 {
-	static int printed_version;
 	const struct ata_port_info *ppi[] =
 		{ &pdc_port_info[ent->driver_data], NULL };
 	struct ata_host *host;
 	struct pdc_host_priv *hpriv;
 	int i, rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* allocate host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 4);
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 3072fd3..b54ebfc 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -145,7 +145,6 @@ static int uli_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 
 static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	const struct ata_port_info *ppi[] = { &uli_port_info, NULL };
 	unsigned int board_idx = (unsigned int) ent->driver_data;
 	struct ata_host *host;
@@ -154,8 +153,7 @@ static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ata_ioports *ioaddr;
 	int n_ports, rc;
 
-	if (!printed_version++)
-		dev_info(&pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 0fc1582..21007b1 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -606,15 +606,13 @@ static void svia_configure(struct pci_dev *pdev, int board_id)
 
 static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	unsigned int i;
 	int rc;
 	struct ata_host *host = NULL;
 	int board_id = (int) ent->driver_data;
 	const unsigned *bar_sizes;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index dcd57b0..6135a52 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -346,14 +346,12 @@ static int __devinit vsc_sata_init_one(struct pci_dev *pdev,
 		.port_ops	= &vsc_sata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &pi, NULL };
-	static int printed_version;
 	struct ata_host *host;
 	void __iomem *mmio_base;
 	int i, rc;
 	u8 cls;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* allocate host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 4);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2beeebb..e39b659 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -74,6 +74,16 @@
 
 #define BPRINTK(fmt, args...) if (ap->flags & ATA_FLAG_DEBUGMSG) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 
+#define ata_print_version_once(dev, version)			\
+({								\
+	static bool __print_once;				\
+								\
+	if (!__print_once) {					\
+		__print_once = true;				\
+		ata_print_version(dev, version);		\
+	}							\
+})
+
 /* NEW: debug levels */
 #define HAVE_LIBATA_MSG 1
 
@@ -1287,6 +1297,8 @@ int ata_dev_printk(const struct ata_device *dev, const char *level,
 #define ata_dev_dbg(dev, fmt, ...)				\
 	ata_dev_printk(dev, KERN_DEBUG, fmt, ##__VA_ARGS__)
 
+void ata_print_version(const struct device *dev, const char *version);
+
 /*
  * ata_eh_info helpers
  */
-- 
1.7.4.2.g597a6.dirty

