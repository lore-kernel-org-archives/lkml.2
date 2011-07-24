Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1GXUIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 16:08:14 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58364 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab1GXUII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 16:08:08 -0400
Date: Sun, 24 Jul 2011 16:08:07 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 3.1
Message-ID: <20110724200807.GA29271@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not a whole lot, for 3.1.

1) Most LOC changes due to printk cleanups (dev_printk ->
   dev_{err,warn,info,etc}

2) libata error handling (EH) tweak, attempting to reduce the
   stream of resets that occurred while hotplugging a faulty
   device

3) minor fixes and PCI ID additions

4) move some ahci code to libahci, because the SB600 workaround
   is apparently generally applicable to other hardware

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig           |    1 +
 drivers/ata/acard-ahci.c      |   27 ++--
 drivers/ata/ahci.c            |  122 ++++---------
 drivers/ata/ahci.h            |    1 +
 drivers/ata/ata_generic.c     |    5 +-
 drivers/ata/ata_piix.c        |   44 +++---
 drivers/ata/libahci.c         |  152 ++++++++++------
 drivers/ata/libata-acpi.c     |   66 +++----
 drivers/ata/libata-core.c     |  400 +++++++++++++++++++++++------------------
 drivers/ata/libata-eh.c       |  154 ++++++++--------
 drivers/ata/libata-pmp.c      |  123 ++++++-------
 drivers/ata/libata-scsi.c     |   22 +--
 drivers/ata/libata-sff.c      |   53 +++---
 drivers/ata/pata_acpi.c       |    8 +-
 drivers/ata/pata_ali.c        |    8 +-
 drivers/ata/pata_amd.c        |    8 +-
 drivers/ata/pata_artop.c      |    5 +-
 drivers/ata/pata_atp867x.c    |   13 +-
 drivers/ata/pata_bf54x.c      |    4 +-
 drivers/ata/pata_cs5520.c     |    3 +-
 drivers/ata/pata_efar.c       |    5 +-
 drivers/ata/pata_hpt3x3.c     |    4 +-
 drivers/ata/pata_icside.c     |    4 +-
 drivers/ata/pata_it8213.c     |    5 +-
 drivers/ata/pata_it821x.c     |   16 +-
 drivers/ata/pata_ixp4xx_cf.c  |    4 +-
 drivers/ata/pata_legacy.c     |    2 +-
 drivers/ata/pata_macio.c      |   10 +-
 drivers/ata/pata_mpiix.c      |    4 +-
 drivers/ata/pata_netcell.c    |    5 +-
 drivers/ata/pata_ns87410.c    |    2 +-
 drivers/ata/pata_ns87415.c    |    5 +-
 drivers/ata/pata_octeon_cf.c  |    8 +-
 drivers/ata/pata_oldpiix.c    |    5 +-
 drivers/ata/pata_opti.c       |    4 +-
 drivers/ata/pata_optidma.c    |    4 +-
 drivers/ata/pata_pcmcia.c     |    5 +-
 drivers/ata/pata_pdc2027x.c   |    6 +-
 drivers/ata/pata_platform.c   |    2 +-
 drivers/ata/pata_radisys.c    |    5 +-
 drivers/ata/pata_rdc.c        |    5 +-
 drivers/ata/pata_rz1000.c     |    4 +-
 drivers/ata/pata_samsung_cf.c |    2 +-
 drivers/ata/pata_scc.c        |    8 +-
 drivers/ata/pata_sch.c        |    5 +-
 drivers/ata/pata_sil680.c     |    4 +-
 drivers/ata/pata_sis.c        |    5 +-
 drivers/ata/pata_sl82c105.c   |    6 +-
 drivers/ata/pata_triflex.c    |    4 +-
 drivers/ata/pata_via.c        |    8 +-
 drivers/ata/pdc_adma.c        |   10 +-
 drivers/ata/sata_dwc_460ex.c  |   21 ++-
 drivers/ata/sata_fsl.c        |   43 ++---
 drivers/ata/sata_inic162x.c   |   31 ++--
 drivers/ata/sata_mv.c         |   94 +++++------
 drivers/ata/sata_nv.c         |   79 ++++-----
 drivers/ata/sata_promise.c    |    6 +-
 drivers/ata/sata_qstor.c      |   13 +-
 drivers/ata/sata_sil.c        |   21 +--
 drivers/ata/sata_sil24.c      |   43 ++---
 drivers/ata/sata_sis.c        |   26 ++--
 drivers/ata/sata_svw.c        |    4 +-
 drivers/ata/sata_sx4.c        |    4 +-
 drivers/ata/sata_uli.c        |    4 +-
 drivers/ata/sata_via.c        |   42 ++---
 drivers/ata/sata_vsc.c        |    9 +-
 include/linux/libata.h        |   68 ++++++--
 67 files changed, 920 insertions(+), 973 deletions(-)

Greg Dietsche (1):
      ata: remove unnecessary code

Gwendal Grignou (1):
      [libata] Prevent warning during PMP error recovery

Jean Delvare (1):
      pata_it821x: Fix RAID type display, by adding missing comma

Joe Perches (4):
      ata: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
      ata: Convert ata_<foo>_printk(KERN_<LEVEL> to ata_<foo>_<level>
      ata: Add and use ata_print_version_once
      ata: sata_via: Use dev_dbg

Mark Nelson (1):
      ahci: Enable SB600 64bit DMA on Asus M3A

Randy Dunlap (1):
      ata: PATA_ARASAN_CF depends on DMADEVICES

Seth Heasley (1):
      ahci: RAID-mode SATA patch for Intel Panther Point DeviceIDs

Tejun Heo (2):
      libata: leave port thawed after reset failure
      libata: report link resume failure as KERN_WARNING instead of ERR

Vasiliy Kulikov (1):
      sata_dwc_460ex: fix error path

Yuan-Hsin Chen (1):
      ahci: move ahci_sb600_softreset to libahci.c and rename it

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 75afa75..ca3e6be 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -313,6 +313,7 @@ config PATA_AMD
 
 config PATA_ARASAN_CF
 	tristate "ARASAN CompactFlash PATA Controller Support"
+	depends on DMADEVICES
 	select DMA_ENGINE
 	help
 	  Say Y here to support the ARASAN CompactFlash PATA controller
diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index ae22be4..3bc8c79 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -135,8 +135,8 @@ static int acard_ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg
 
 	if (mesg.event & PM_EVENT_SUSPEND &&
 	    hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "BIOS update required for suspend/resume\n");
+		dev_err(&pdev->dev,
+			"BIOS update required for suspend/resume\n");
 		return -EIO;
 	}
 
@@ -187,7 +187,7 @@ static int acard_ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
-				dev_printk(KERN_ERR, &pdev->dev,
+				dev_err(&pdev->dev,
 					   "64-bit DMA enable failed\n");
 				return rc;
 			}
@@ -195,14 +195,13 @@ static int acard_ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
 	} else {
 		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit DMA enable failed\n");
+			dev_err(&pdev->dev, "32-bit DMA enable failed\n");
 			return rc;
 		}
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit consistent DMA enable failed\n");
+			dev_err(&pdev->dev,
+				"32-bit consistent DMA enable failed\n");
 			return rc;
 		}
 	}
@@ -343,14 +342,12 @@ static int acard_ahci_port_start(struct ata_port *ap)
 		if (cmd & PORT_CMD_FBSCP)
 			pp->fbs_supported = true;
 		else if (hpriv->flags & AHCI_HFLAG_YES_FBS) {
-			dev_printk(KERN_INFO, dev,
-				   "port %d can do FBS, forcing FBSCP\n",
-				   ap->port_no);
+			dev_info(dev, "port %d can do FBS, forcing FBSCP\n",
+				 ap->port_no);
 			pp->fbs_supported = true;
 		} else
-			dev_printk(KERN_WARNING, dev,
-				   "port %d is not capable of FBS\n",
-				   ap->port_no);
+			dev_warn(dev, "port %d is not capable of FBS\n",
+				 ap->port_no);
 	}
 
 	if (pp->fbs_supported) {
@@ -406,7 +403,6 @@ static int acard_ahci_port_start(struct ata_port *ap)
 
 static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	unsigned int board_id = ent->driver_data;
 	struct ata_port_info pi = acard_ahci_port_info[board_id];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
@@ -419,8 +415,7 @@ static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id
 
 	WARN_ON((int)ATA_MAX_QUEUE > AHCI_MAX_CMDS);
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 71afe03..fb7b90b 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -79,8 +79,6 @@ enum board_ids {
 };
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
@@ -104,12 +102,6 @@ static struct ata_port_operations ahci_p5wdh_ops = {
 	.hardreset		= ahci_p5wdh_hardreset,
 };
 
-static struct ata_port_operations ahci_sb600_ops = {
-	.inherits		= &ahci_ops,
-	.softreset		= ahci_sb600_softreset,
-	.pmp_softreset		= ahci_sb600_softreset,
-};
-
 #define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
 
 static const struct ata_port_info ahci_port_info[] = {
@@ -188,7 +180,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_sb600_ops,
+		.port_ops	= &ahci_pmp_retry_srst_ops,
 	},
 	[board_ahci_sb700] =	/* for SB700 and SB800 */
 	{
@@ -196,7 +188,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_sb600_ops,
+		.port_ops	= &ahci_pmp_retry_srst_ops,
 	},
 	[board_ahci_vt8251] =
 	{
@@ -267,6 +259,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x1e05), board_ahci }, /* Panther Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x1e06), board_ahci }, /* Panther Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x1e07), board_ahci }, /* Panther Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x1e0e), board_ahci }, /* Panther Point RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
@@ -502,55 +495,6 @@ static void ahci_pci_init_controller(struct ata_host *host)
 	ahci_init_controller(host);
 }
 
-static int ahci_sb600_check_ready(struct ata_link *link)
-{
-	void __iomem *port_mmio = ahci_port_base(link->ap);
-	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
-	u32 irq_status = readl(port_mmio + PORT_IRQ_STAT);
-
-	/*
-	 * There is no need to check TFDATA if BAD PMP is found due to HW bug,
-	 * which can save timeout delay.
-	 */
-	if (irq_status & PORT_IRQ_BAD_PMP)
-		return -EIO;
-
-	return ata_check_ready(status);
-}
-
-static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
-				unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	int pmp = sata_srst_pmp(link);
-	int rc;
-	u32 irq_sts;
-
-	DPRINTK("ENTER\n");
-
-	rc = ahci_do_softreset(link, class, pmp, deadline,
-			       ahci_sb600_check_ready);
-
-	/*
-	 * Soft reset fails on some ATI chips with IPMS set when PMP
-	 * is enabled but SATA HDD/ODD is connected to SATA port,
-	 * do soft reset again to port 0.
-	 */
-	if (rc == -EIO) {
-		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
-		if (irq_sts & PORT_IRQ_BAD_PMP) {
-			ata_link_printk(link, KERN_WARNING,
-					"applying SB600 PMP SRST workaround "
-					"and retrying\n");
-			rc = ahci_do_softreset(link, class, 0, deadline,
-					       ahci_check_ready);
-		}
-	}
-
-	return rc;
-}
-
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline)
 {
@@ -629,8 +573,8 @@ static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 
 	if (mesg.event & PM_EVENT_SUSPEND &&
 	    hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "BIOS update required for suspend/resume\n");
+		dev_err(&pdev->dev,
+			"BIOS update required for suspend/resume\n");
 		return -EIO;
 	}
 
@@ -681,22 +625,21 @@ static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
-				dev_printk(KERN_ERR, &pdev->dev,
-					   "64-bit DMA enable failed\n");
+				dev_err(&pdev->dev,
+					"64-bit DMA enable failed\n");
 				return rc;
 			}
 		}
 	} else {
 		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit DMA enable failed\n");
+			dev_err(&pdev->dev, "32-bit DMA enable failed\n");
 			return rc;
 		}
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit consistent DMA enable failed\n");
+			dev_err(&pdev->dev,
+				"32-bit consistent DMA enable failed\n");
 			return rc;
 		}
 	}
@@ -759,8 +702,8 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
 	    dmi_check_system(sysids)) {
 		struct ata_port *ap = host->ports[1];
 
-		dev_printk(KERN_INFO, &pdev->dev, "enabling ASUS P5W DH "
-			   "Deluxe on-board SIMG4726 workaround\n");
+		dev_info(&pdev->dev,
+			 "enabling ASUS P5W DH Deluxe on-board SIMG4726 workaround\n");
 
 		ap->ops = &ahci_p5wdh_ops;
 		ap->link.flags |= ATA_LFLAG_NO_SRST | ATA_LFLAG_ASSUME_ATA;
@@ -811,6 +754,18 @@ static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
 				DMI_MATCH(DMI_BOARD_NAME, "MS-7376"),
 			},
 		},
+		/*
+		 * All BIOS versions for the Asus M3A support 64bit DMA.
+		 * (all release versions from 0301 to 1206 were tested)
+		 */
+		{
+			.ident = "ASUS M3A",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "ASUSTeK Computer INC."),
+				DMI_MATCH(DMI_BOARD_NAME, "M3A"),
+			},
+		},
 		{ }
 	};
 	const struct dmi_system_id *match;
@@ -831,14 +786,14 @@ static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
 	if (strcmp(buf, match->driver_data) >= 0)
 		goto enable_64bit;
 	else {
-		dev_printk(KERN_WARNING, &pdev->dev, "%s: BIOS too old, "
-			   "forcing 32bit DMA, update BIOS\n", match->ident);
+		dev_warn(&pdev->dev,
+			 "%s: BIOS too old, forcing 32bit DMA, update BIOS\n",
+			 match->ident);
 		return false;
 	}
 
 enable_64bit:
-	dev_printk(KERN_WARNING, &pdev->dev, "%s: enabling 64bit DMA\n",
-		   match->ident);
+	dev_warn(&pdev->dev, "%s: enabling 64bit DMA\n", match->ident);
 	return true;
 }
 
@@ -1041,9 +996,8 @@ static void ahci_gtf_filter_workaround(struct ata_host *host)
 		return;
 
 	filter = (unsigned long)dmi->driver_data;
-	dev_printk(KERN_INFO, host->dev,
-		   "applying extra ACPI _GTF filter 0x%x for %s\n",
-		   filter, dmi->ident);
+	dev_info(host->dev, "applying extra ACPI _GTF filter 0x%x for %s\n",
+		 filter, dmi->ident);
 
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
@@ -1062,7 +1016,6 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	unsigned int board_id = ent->driver_data;
 	struct ata_port_info pi = ahci_port_info[board_id];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
@@ -1075,8 +1028,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	WARN_ON((int)ATA_MAX_QUEUE > AHCI_MAX_CMDS);
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* The AHCI driver can only drive the SATA ports, the PATA driver
 	   can drive them all so if both drivers are selected make sure
@@ -1099,8 +1051,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * that for SAS drives they're out of luck.
 	 */
 	if (pdev->vendor == PCI_VENDOR_ID_PROMISE)
-		dev_printk(KERN_INFO, &pdev->dev, "PDC42819 "
-			   "can only drive SATA devices with this driver\n");
+		dev_info(&pdev->dev,
+			 "PDC42819 can only drive SATA devices with this driver\n");
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
@@ -1126,8 +1078,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 */
 		pci_read_config_byte(pdev, ICH_MAP, &map);
 		if (map & 0x3) {
-			dev_printk(KERN_INFO, &pdev->dev, "controller is in "
-				   "combined mode, can't enable AHCI mode\n");
+			dev_info(&pdev->dev,
+				 "controller is in combined mode, can't enable AHCI mode\n");
 			return -ENODEV;
 		}
 	}
@@ -1184,8 +1136,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (ahci_broken_suspend(pdev)) {
 		hpriv->flags |= AHCI_HFLAG_NO_SUSPEND;
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "BIOS update required for suspend/resume\n");
+		dev_warn(&pdev->dev,
+			 "BIOS update required for suspend/resume\n");
 	}
 
 	if (ahci_broken_online(pdev)) {
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 12c5282..b175000 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -312,6 +312,7 @@ extern struct device_attribute *ahci_sdev_attrs[];
 	.sdev_attrs		= ahci_sdev_attrs
 
 extern struct ata_port_operations ahci_ops;
+extern struct ata_port_operations ahci_pmp_retry_srst_ops;
 
 void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			u32 opts);
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 721d38b..7df56ec 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -81,14 +81,13 @@ static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 				xfer_mask |= ata_xfer_mode2mask(XFER_MW_DMA_0);
 			}
 
-			ata_dev_printk(dev, KERN_INFO, "configured for %s\n",
-				       name);
+			ata_dev_info(dev, "configured for %s\n", name);
 
 			dev->xfer_mode = ata_xfer_mask2mode(xfer_mask);
 			dev->xfer_shift = ata_xfer_mode2shift(dev->xfer_mode);
 			dev->flags &= ~ATA_DFLAG_PIO;
 		} else {
-			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+			ata_dev_info(dev, "configured for PIO\n");
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
 			dev->flags |= ATA_DFLAG_PIO;
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6f6e771..43107e9 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1225,8 +1225,9 @@ static int piix_pci_device_resume(struct pci_dev *pdev)
 		 */
 		rc = pci_reenable_device(pdev);
 		if (rc)
-			dev_printk(KERN_ERR, &pdev->dev, "failed to enable "
-				   "device after resume (%d)\n", rc);
+			dev_err(&pdev->dev,
+				"failed to enable device after resume (%d)\n",
+				rc);
 	} else
 		rc = ata_pci_device_do_resume(pdev);
 
@@ -1303,9 +1304,11 @@ static int __devinit piix_check_450nx_errata(struct pci_dev *ata_dev)
 			no_piix_dma = 2;
 	}
 	if (no_piix_dma)
-		dev_printk(KERN_WARNING, &ata_dev->dev, "450NX errata present, disabling IDE DMA.\n");
-	if (no_piix_dma == 2)
-		dev_printk(KERN_WARNING, &ata_dev->dev, "A BIOS update may resolve this.\n");
+		dev_warn(&ata_dev->dev,
+			 "450NX errata present, disabling IDE DMA%s\n",
+			 no_piix_dma == 2 ? " - a BIOS update may resolve this"
+			 : "");
+
 	return no_piix_dma;
 }
 
@@ -1338,37 +1341,36 @@ static const int *__devinit piix_init_sata_map(struct pci_dev *pdev,
 
 	map = map_db->map[map_value & map_db->mask];
 
-	dev_printk(KERN_INFO, &pdev->dev, "MAP [");
+	dev_info(&pdev->dev, "MAP [");
 	for (i = 0; i < 4; i++) {
 		switch (map[i]) {
 		case RV:
 			invalid_map = 1;
-			printk(" XX");
+			pr_cont(" XX");
 			break;
 
 		case NA:
-			printk(" --");
+			pr_cont(" --");
 			break;
 
 		case IDE:
 			WARN_ON((i & 1) || map[i + 1] != IDE);
 			pinfo[i / 2] = piix_port_info[ich_pata_100];
 			i++;
-			printk(" IDE IDE");
+			pr_cont(" IDE IDE");
 			break;
 
 		default:
-			printk(" P%d", map[i]);
+			pr_cont(" P%d", map[i]);
 			if (i & 1)
 				pinfo[i / 2].flags |= ATA_FLAG_SLAVE_POSS;
 			break;
 		}
 	}
-	printk(" ]\n");
+	pr_cont(" ]\n");
 
 	if (invalid_map)
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "invalid MAP value %u\n", map_value);
+		dev_err(&pdev->dev, "invalid MAP value %u\n", map_value);
 
 	return map;
 }
@@ -1398,8 +1400,8 @@ static bool piix_no_sidpr(struct ata_host *host)
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL && pdev->device == 0x2920 &&
 	    pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG &&
 	    pdev->subsystem_device == 0xb049) {
-		dev_printk(KERN_WARNING, host->dev,
-			   "Samsung DB-P70 detected, disabling SIDPR\n");
+		dev_warn(host->dev,
+			 "Samsung DB-P70 detected, disabling SIDPR\n");
 		return true;
 	}
 
@@ -1451,8 +1453,8 @@ static int __devinit piix_init_sidpr(struct ata_host *host)
 		piix_sidpr_scr_read(link0, SCR_CONTROL, &scontrol);
 
 		if ((scontrol & 0xf00) != 0x300) {
-			dev_printk(KERN_INFO, host->dev, "SCR access via "
-				   "SIDPR is available but doesn't work\n");
+			dev_info(host->dev,
+				 "SCR access via SIDPR is available but doesn't work\n");
 			return 0;
 		}
 	}
@@ -1501,8 +1503,7 @@ static void piix_iocfg_bit18_quirk(struct ata_host *host)
 	 * affected systems.
 	 */
 	if (hpriv->saved_iocfg & (1 << 18)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "applying IOCFG bit18 quirk\n");
+		dev_info(&pdev->dev, "applying IOCFG bit18 quirk\n");
 		pci_write_config_dword(pdev, PIIX_IOCFG,
 				       hpriv->saved_iocfg & ~(1 << 18));
 	}
@@ -1561,7 +1562,6 @@ static bool piix_broken_system_poweroff(struct pci_dev *pdev)
 static int __devinit piix_init_one(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
 {
-	static int printed_version;
 	struct device *dev = &pdev->dev;
 	struct ata_port_info port_info[2];
 	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
@@ -1571,9 +1571,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	struct piix_host_priv *hpriv;
 	int rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* no hotplugging support for later devices (FIXME) */
 	if (!in_module_init && ent->driver_data >= ich5_sata)
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 41223c7..3c92dbd 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -82,6 +82,8 @@ static void ahci_pmp_attach(struct ata_port *ap);
 static void ahci_pmp_detach(struct ata_port *ap);
 static int ahci_softreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
+static int ahci_pmp_retry_softreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline);
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
 static void ahci_postreset(struct ata_link *link, unsigned int *class);
@@ -178,6 +180,12 @@ struct ata_port_operations ahci_ops = {
 };
 EXPORT_SYMBOL_GPL(ahci_ops);
 
+struct ata_port_operations ahci_pmp_retry_srst_ops = {
+	.inherits		= &ahci_ops,
+	.softreset		= ahci_pmp_retry_softreset,
+};
+EXPORT_SYMBOL_GPL(ahci_pmp_retry_srst_ops);
+
 int ahci_em_messages = 1;
 EXPORT_SYMBOL_GPL(ahci_em_messages);
 module_param(ahci_em_messages, int, 0444);
@@ -286,10 +294,10 @@ static ssize_t ahci_read_em_buffer(struct device *dev,
 	/* the count should not be larger than PAGE_SIZE */
 	if (count > PAGE_SIZE) {
 		if (printk_ratelimit())
-			ata_port_printk(ap, KERN_WARNING,
-					"EM read buffer size too large: "
-					"buffer size %u, page size %lu\n",
-					hpriv->em_buf_sz, PAGE_SIZE);
+			ata_port_warn(ap,
+				      "EM read buffer size too large: "
+				      "buffer size %u, page size %lu\n",
+				      hpriv->em_buf_sz, PAGE_SIZE);
 		count = PAGE_SIZE;
 	}
 
@@ -410,51 +418,46 @@ void ahci_save_initial_config(struct device *dev,
 
 	/* some chips have errata preventing 64bit use */
 	if ((cap & HOST_CAP_64) && (hpriv->flags & AHCI_HFLAG_32BIT_ONLY)) {
-		dev_printk(KERN_INFO, dev,
-			   "controller can't do 64bit DMA, forcing 32bit\n");
+		dev_info(dev, "controller can't do 64bit DMA, forcing 32bit\n");
 		cap &= ~HOST_CAP_64;
 	}
 
 	if ((cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_NO_NCQ)) {
-		dev_printk(KERN_INFO, dev,
-			   "controller can't do NCQ, turning off CAP_NCQ\n");
+		dev_info(dev, "controller can't do NCQ, turning off CAP_NCQ\n");
 		cap &= ~HOST_CAP_NCQ;
 	}
 
 	if (!(cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_YES_NCQ)) {
-		dev_printk(KERN_INFO, dev,
-			   "controller can do NCQ, turning on CAP_NCQ\n");
+		dev_info(dev, "controller can do NCQ, turning on CAP_NCQ\n");
 		cap |= HOST_CAP_NCQ;
 	}
 
 	if ((cap & HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
-		dev_printk(KERN_INFO, dev,
-			   "controller can't do PMP, turning off CAP_PMP\n");
+		dev_info(dev, "controller can't do PMP, turning off CAP_PMP\n");
 		cap &= ~HOST_CAP_PMP;
 	}
 
 	if ((cap & HOST_CAP_SNTF) && (hpriv->flags & AHCI_HFLAG_NO_SNTF)) {
-		dev_printk(KERN_INFO, dev,
-			   "controller can't do SNTF, turning off CAP_SNTF\n");
+		dev_info(dev,
+			 "controller can't do SNTF, turning off CAP_SNTF\n");
 		cap &= ~HOST_CAP_SNTF;
 	}
 
 	if (!(cap & HOST_CAP_FBS) && (hpriv->flags & AHCI_HFLAG_YES_FBS)) {
-		dev_printk(KERN_INFO, dev,
-			   "controller can do FBS, turning on CAP_FBS\n");
+		dev_info(dev, "controller can do FBS, turning on CAP_FBS\n");
 		cap |= HOST_CAP_FBS;
 	}
 
 	if (force_port_map && port_map != force_port_map) {
-		dev_printk(KERN_INFO, dev, "forcing port_map 0x%x -> 0x%x\n",
-			   port_map, force_port_map);
+		dev_info(dev, "forcing port_map 0x%x -> 0x%x\n",
+			 port_map, force_port_map);
 		port_map = force_port_map;
 	}
 
 	if (mask_port_map) {
-		dev_printk(KERN_WARNING, dev, "masking port_map 0x%x -> 0x%x\n",
-			   port_map,
-			   port_map & mask_port_map);
+		dev_warn(dev, "masking port_map 0x%x -> 0x%x\n",
+			port_map,
+			port_map & mask_port_map);
 		port_map &= mask_port_map;
 	}
 
@@ -470,10 +473,9 @@ void ahci_save_initial_config(struct device *dev,
 		 * port_map and let it be generated from n_ports.
 		 */
 		if (map_ports > ahci_nr_ports(cap)) {
-			dev_printk(KERN_WARNING, dev,
-				   "implemented port map (0x%x) contains more "
-				   "ports than nr_ports (%u), using nr_ports\n",
-				   port_map, ahci_nr_ports(cap));
+			dev_warn(dev,
+				 "implemented port map (0x%x) contains more ports than nr_ports (%u), using nr_ports\n",
+				 port_map, ahci_nr_ports(cap));
 			port_map = 0;
 		}
 	}
@@ -481,8 +483,7 @@ void ahci_save_initial_config(struct device *dev,
 	/* fabricate port_map from cap.nr_ports */
 	if (!port_map) {
 		port_map = (1 << ahci_nr_ports(cap)) - 1;
-		dev_printk(KERN_WARNING, dev,
-			   "forcing PORTS_IMPL to 0x%x\n", port_map);
+		dev_warn(dev, "forcing PORTS_IMPL to 0x%x\n", port_map);
 
 		/* write the fixed up value to the PI register */
 		hpriv->saved_port_map = port_map;
@@ -822,8 +823,8 @@ int ahci_reset_controller(struct ata_host *host)
 					HOST_RESET, 10, 1000);
 
 		if (tmp & HOST_RESET) {
-			dev_printk(KERN_ERR, host->dev,
-				   "controller reset failed (0x%x)\n", tmp);
+			dev_err(host->dev, "controller reset failed (0x%x)\n",
+				tmp);
 			return -EIO;
 		}
 
@@ -835,8 +836,7 @@ int ahci_reset_controller(struct ata_host *host)
 		 */
 		ahci_restore_initial_config(host);
 	} else
-		dev_printk(KERN_INFO, host->dev,
-			   "skipping global host reset\n");
+		dev_info(host->dev, "skipping global host reset\n");
 
 	return 0;
 }
@@ -1132,8 +1132,8 @@ static void ahci_dev_config(struct ata_device *dev)
 
 	if (hpriv->flags & AHCI_HFLAG_SECT255) {
 		dev->max_sectors = 255;
-		ata_dev_printk(dev, KERN_INFO,
-			       "SB600 AHCI: limiting to 255 sectors per cmd\n");
+		ata_dev_info(dev,
+			     "SB600 AHCI: limiting to 255 sectors per cmd\n");
 	}
 }
 
@@ -1257,8 +1257,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	/* prepare for SRST (AHCI-1.1 10.4.1) */
 	rc = ahci_kick_engine(ap);
 	if (rc && rc != -EOPNOTSUPP)
-		ata_link_printk(link, KERN_WARNING,
-				"failed to reset engine (errno=%d)\n", rc);
+		ata_link_warn(link, "failed to reset engine (errno=%d)\n", rc);
 
 	ata_tf_init(link->device, &tf);
 
@@ -1291,8 +1290,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 		 * be trusted.  Treat device readiness timeout as link
 		 * offline.
 		 */
-		ata_link_printk(link, KERN_INFO,
-				"device not ready, treating as offline\n");
+		ata_link_info(link, "device not ready, treating as offline\n");
 		*class = ATA_DEV_NONE;
 	} else if (rc) {
 		/* link occupied, -ENODEV too is an error */
@@ -1305,7 +1303,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	return 0;
 
  fail:
-	ata_link_printk(link, KERN_ERR, "softreset failed (%s)\n", reason);
+	ata_link_err(link, "softreset failed (%s)\n", reason);
 	return rc;
 }
 
@@ -1329,6 +1327,55 @@ static int ahci_softreset(struct ata_link *link, unsigned int *class,
 }
 EXPORT_SYMBOL_GPL(ahci_do_softreset);
 
+static int ahci_bad_pmp_check_ready(struct ata_link *link)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+	u32 irq_status = readl(port_mmio + PORT_IRQ_STAT);
+
+	/*
+	 * There is no need to check TFDATA if BAD PMP is found due to HW bug,
+	 * which can save timeout delay.
+	 */
+	if (irq_status & PORT_IRQ_BAD_PMP)
+		return -EIO;
+
+	return ata_check_ready(status);
+}
+
+int ahci_pmp_retry_softreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	int pmp = sata_srst_pmp(link);
+	int rc;
+	u32 irq_sts;
+
+	DPRINTK("ENTER\n");
+
+	rc = ahci_do_softreset(link, class, pmp, deadline,
+			       ahci_bad_pmp_check_ready);
+
+	/*
+	 * Soft reset fails with IPMS set when PMP is enabled but
+	 * SATA HDD/ODD is connected to SATA port, do soft reset
+	 * again to port 0.
+	 */
+	if (rc == -EIO) {
+		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
+		if (irq_sts & PORT_IRQ_BAD_PMP) {
+			ata_link_printk(link, KERN_WARNING,
+					"applying PMP SRST workaround "
+					"and retrying\n");
+			rc = ahci_do_softreset(link, class, 0, deadline,
+					       ahci_check_ready);
+		}
+	}
+
+	return rc;
+}
+
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline)
 {
@@ -1474,8 +1521,7 @@ static void ahci_fbs_dec_intr(struct ata_port *ap)
 	}
 
 	if (fbs & PORT_FBS_DEC)
-		dev_printk(KERN_ERR, ap->host->dev,
-			   "failed to clear device error\n");
+		dev_err(ap->host->dev, "failed to clear device error\n");
 }
 
 static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
@@ -1713,8 +1759,8 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
 			if (ata_ratelimit())
-				dev_printk(KERN_WARNING, host->dev,
-					"interrupt on disabled port %u\n", i);
+				dev_warn(host->dev,
+					 "interrupt on disabled port %u\n", i);
 		}
 
 		handled = 1;
@@ -1865,11 +1911,11 @@ static void ahci_enable_fbs(struct ata_port *ap)
 	writel(fbs | PORT_FBS_EN, port_mmio + PORT_FBS);
 	fbs = readl(port_mmio + PORT_FBS);
 	if (fbs & PORT_FBS_EN) {
-		dev_printk(KERN_INFO, ap->host->dev, "FBS is enabled.\n");
+		dev_info(ap->host->dev, "FBS is enabled\n");
 		pp->fbs_enabled = true;
 		pp->fbs_last_dev = -1; /* initialization */
 	} else
-		dev_printk(KERN_ERR, ap->host->dev, "Failed to enable FBS\n");
+		dev_err(ap->host->dev, "Failed to enable FBS\n");
 
 	ahci_start_engine(ap);
 }
@@ -1897,9 +1943,9 @@ static void ahci_disable_fbs(struct ata_port *ap)
 	writel(fbs & ~PORT_FBS_EN, port_mmio + PORT_FBS);
 	fbs = readl(port_mmio + PORT_FBS);
 	if (fbs & PORT_FBS_EN)
-		dev_printk(KERN_ERR, ap->host->dev, "Failed to disable FBS\n");
+		dev_err(ap->host->dev, "Failed to disable FBS\n");
 	else {
-		dev_printk(KERN_INFO, ap->host->dev, "FBS is disabled.\n");
+		dev_info(ap->host->dev, "FBS is disabled\n");
 		pp->fbs_enabled = false;
 	}
 
@@ -1975,7 +2021,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 	if (rc == 0)
 		ahci_power_down(ap);
 	else {
-		ata_port_printk(ap, KERN_ERR, "%s (%d)\n", emsg, rc);
+		ata_port_err(ap, "%s (%d)\n", emsg, rc);
 		ahci_start_port(ap);
 	}
 
@@ -2003,14 +2049,12 @@ static int ahci_port_start(struct ata_port *ap)
 		if (cmd & PORT_CMD_FBSCP)
 			pp->fbs_supported = true;
 		else if (hpriv->flags & AHCI_HFLAG_YES_FBS) {
-			dev_printk(KERN_INFO, dev,
-				   "port %d can do FBS, forcing FBSCP\n",
-				   ap->port_no);
+			dev_info(dev, "port %d can do FBS, forcing FBSCP\n",
+				 ap->port_no);
 			pp->fbs_supported = true;
 		} else
-			dev_printk(KERN_WARNING, dev,
-				   "port %d is not capable of FBS\n",
-				   ap->port_no);
+			dev_warn(dev, "port %d is not capable of FBS\n",
+				 ap->port_no);
 	}
 
 	if (pp->fbs_supported) {
@@ -2072,7 +2116,7 @@ static void ahci_port_stop(struct ata_port *ap)
 	/* de-initialize port */
 	rc = ahci_deinit_port(ap, &emsg);
 	if (rc)
-		ata_port_printk(ap, KERN_WARNING, "%s (%d)\n", emsg, rc);
+		ata_port_warn(ap, "%s (%d)\n", emsg, rc);
 }
 
 void ahci_print_info(struct ata_host *host, const char *scc_s)
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index a791b8ce..e0a5b55 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -332,25 +332,22 @@ int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *gtm)
 
 	rc = -EINVAL;
 	if (ACPI_FAILURE(status)) {
-		ata_port_printk(ap, KERN_ERR,
-				"ACPI get timing mode failed (AE 0x%x)\n",
-				status);
+		ata_port_err(ap, "ACPI get timing mode failed (AE 0x%x)\n",
+			     status);
 		goto out_free;
 	}
 
 	out_obj = output.pointer;
 	if (out_obj->type != ACPI_TYPE_BUFFER) {
-		ata_port_printk(ap, KERN_WARNING,
-				"_GTM returned unexpected object type 0x%x\n",
-				out_obj->type);
+		ata_port_warn(ap, "_GTM returned unexpected object type 0x%x\n",
+			      out_obj->type);
 
 		goto out_free;
 	}
 
 	if (out_obj->buffer.length != sizeof(struct ata_acpi_gtm)) {
-		ata_port_printk(ap, KERN_ERR,
-				"_GTM returned invalid length %d\n",
-				out_obj->buffer.length);
+		ata_port_err(ap, "_GTM returned invalid length %d\n",
+			     out_obj->buffer.length);
 		goto out_free;
 	}
 
@@ -402,8 +399,8 @@ int ata_acpi_stm(struct ata_port *ap, const struct ata_acpi_gtm *stm)
 	if (status == AE_NOT_FOUND)
 		return -ENOENT;
 	if (ACPI_FAILURE(status)) {
-		ata_port_printk(ap, KERN_ERR,
-			"ACPI set timing mode failed (status=0x%x)\n", status);
+		ata_port_err(ap, "ACPI set timing mode failed (status=0x%x)\n",
+			     status);
 		return -EINVAL;
 	}
 	return 0;
@@ -450,8 +447,8 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 	output.pointer = NULL;	/* ACPI-CA sets this; save/free it later */
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
-			       __func__, ap->port_no);
+		ata_dev_dbg(dev, "%s: ENTER: port#: %d\n",
+			    __func__, ap->port_no);
 
 	/* _GTF has no input parameters */
 	status = acpi_evaluate_object(dev->acpi_handle, "_GTF", NULL, &output);
@@ -459,9 +456,8 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 
 	if (ACPI_FAILURE(status)) {
 		if (status != AE_NOT_FOUND) {
-			ata_dev_printk(dev, KERN_WARNING,
-				       "_GTF evaluation failed (AE 0x%x)\n",
-				       status);
+			ata_dev_warn(dev, "_GTF evaluation failed (AE 0x%x)\n",
+				     status);
 			rc = -EINVAL;
 		}
 		goto out_free;
@@ -469,27 +465,24 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 
 	if (!output.length || !output.pointer) {
 		if (ata_msg_probe(ap))
-			ata_dev_printk(dev, KERN_DEBUG, "%s: Run _GTF: "
-				"length or ptr is NULL (0x%llx, 0x%p)\n",
-				__func__,
-				(unsigned long long)output.length,
-				output.pointer);
+			ata_dev_dbg(dev, "%s: Run _GTF: length or ptr is NULL (0x%llx, 0x%p)\n",
+				    __func__,
+				    (unsigned long long)output.length,
+				    output.pointer);
 		rc = -EINVAL;
 		goto out_free;
 	}
 
 	if (out_obj->type != ACPI_TYPE_BUFFER) {
-		ata_dev_printk(dev, KERN_WARNING,
-			       "_GTF unexpected object type 0x%x\n",
-			       out_obj->type);
+		ata_dev_warn(dev, "_GTF unexpected object type 0x%x\n",
+			     out_obj->type);
 		rc = -EINVAL;
 		goto out_free;
 	}
 
 	if (out_obj->buffer.length % REGS_PER_GTF) {
-		ata_dev_printk(dev, KERN_WARNING,
-			       "unexpected _GTF length (%d)\n",
-			       out_obj->buffer.length);
+		ata_dev_warn(dev, "unexpected _GTF length (%d)\n",
+			     out_obj->buffer.length);
 		rc = -EINVAL;
 		goto out_free;
 	}
@@ -499,9 +492,8 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 	if (gtf) {
 		*gtf = (void *)out_obj->buffer.pointer;
 		if (ata_msg_probe(ap))
-			ata_dev_printk(dev, KERN_DEBUG,
-				       "%s: returning gtf=%p, gtf_count=%d\n",
-				       __func__, *gtf, rc);
+			ata_dev_dbg(dev, "%s: returning gtf=%p, gtf_count=%d\n",
+				    __func__, *gtf, rc);
 	}
 	return rc;
 
@@ -811,8 +803,8 @@ static int ata_acpi_push_id(struct ata_device *dev)
 	union acpi_object in_params[1];
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ix = %d, port#: %d\n",
-			       __func__, dev->devno, ap->port_no);
+		ata_dev_dbg(dev, "%s: ix = %d, port#: %d\n",
+			    __func__, dev->devno, ap->port_no);
 
 	/* Give the drive Identify data to the drive via the _SDD method */
 	/* _SDD: set up input parameters */
@@ -832,8 +824,7 @@ static int ata_acpi_push_id(struct ata_device *dev)
 		return -ENOENT;
 
 	if (ACPI_FAILURE(status)) {
-		ata_dev_printk(dev, KERN_WARNING,
-			       "ACPI _SDD failed (AE 0x%x)\n", status);
+		ata_dev_warn(dev, "ACPI _SDD failed (AE 0x%x)\n", status);
 		return -EIO;
 	}
 
@@ -983,8 +974,8 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 	if (nr_executed) {
 		rc = ata_dev_reread_id(dev, 0);
 		if (rc < 0) {
-			ata_dev_printk(dev, KERN_ERR, "failed to IDENTIFY "
-				       "after ACPI commands\n");
+			ata_dev_err(dev,
+				    "failed to IDENTIFY after ACPI commands\n");
 			return rc;
 		}
 	}
@@ -1002,8 +993,7 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 		return rc;
 	}
 
-	ata_dev_printk(dev, KERN_WARNING,
-		       "ACPI: failed the second time, disabled\n");
+	ata_dev_warn(dev, "ACPI: failed the second time, disabled\n");
 	dev->acpi_handle = NULL;
 
 	/* We can safely continue if no _GTF command has been executed
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 000d03a..4a3a5ae 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -335,8 +335,7 @@ void ata_force_cbl(struct ata_port *ap)
 			continue;
 
 		ap->cbl = fe->param.cbl;
-		ata_port_printk(ap, KERN_NOTICE,
-				"FORCE: cable set to %s\n", fe->param.name);
+		ata_port_notice(ap, "FORCE: cable set to %s\n", fe->param.name);
 		return;
 	}
 }
@@ -378,8 +377,7 @@ static void ata_force_link_limits(struct ata_link *link)
 		/* only honor the first spd limit */
 		if (!did_spd && fe->param.spd_limit) {
 			link->hw_sata_spd_limit = (1 << fe->param.spd_limit) - 1;
-			ata_link_printk(link, KERN_NOTICE,
-					"FORCE: PHY spd limit set to %s\n",
+			ata_link_notice(link, "FORCE: PHY spd limit set to %s\n",
 					fe->param.name);
 			did_spd = true;
 		}
@@ -387,7 +385,7 @@ static void ata_force_link_limits(struct ata_link *link)
 		/* let lflags stack */
 		if (fe->param.lflags) {
 			link->flags |= fe->param.lflags;
-			ata_link_printk(link, KERN_NOTICE,
+			ata_link_notice(link,
 					"FORCE: link flag 0x%x forced -> 0x%x\n",
 					fe->param.lflags, link->flags);
 		}
@@ -442,8 +440,8 @@ static void ata_force_xfermask(struct ata_device *dev)
 			dev->pio_mask = pio_mask;
 		}
 
-		ata_dev_printk(dev, KERN_NOTICE,
-			"FORCE: xfer_mask set to %s\n", fe->param.name);
+		ata_dev_notice(dev, "FORCE: xfer_mask set to %s\n",
+			       fe->param.name);
 		return;
 	}
 }
@@ -486,8 +484,8 @@ static void ata_force_horkage(struct ata_device *dev)
 		dev->horkage |= fe->param.horkage_on;
 		dev->horkage &= ~fe->param.horkage_off;
 
-		ata_dev_printk(dev, KERN_NOTICE,
-			"FORCE: horkage modified (%s)\n", fe->param.name);
+		ata_dev_notice(dev, "FORCE: horkage modified (%s)\n",
+			       fe->param.name);
 	}
 }
 
@@ -711,8 +709,8 @@ u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
 		sect = tf->lbal;
 
 		if (!sect) {
-			ata_dev_printk(dev, KERN_WARNING, "device reported "
-				       "invalid CHS sector 0\n");
+			ata_dev_warn(dev,
+				     "device reported invalid CHS sector 0\n");
 			sect = 1; /* oh well */
 		}
 
@@ -1230,8 +1228,9 @@ static int ata_read_native_max_address(struct ata_device *dev, u64 *max_sectors)
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 	if (err_mask) {
-		ata_dev_printk(dev, KERN_WARNING, "failed to read native "
-			       "max address (err_mask=0x%x)\n", err_mask);
+		ata_dev_warn(dev,
+			     "failed to read native max address (err_mask=0x%x)\n",
+			     err_mask);
 		if (err_mask == AC_ERR_DEV && (tf.feature & ATA_ABORTED))
 			return -EACCES;
 		return -EIO;
@@ -1292,8 +1291,9 @@ static int ata_set_max_sectors(struct ata_device *dev, u64 new_sectors)
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 	if (err_mask) {
-		ata_dev_printk(dev, KERN_WARNING, "failed to set "
-			       "max address (err_mask=0x%x)\n", err_mask);
+		ata_dev_warn(dev,
+			     "failed to set max address (err_mask=0x%x)\n",
+			     err_mask);
 		if (err_mask == AC_ERR_DEV &&
 		    (tf.feature & (ATA_ABORTED | ATA_IDNF)))
 			return -EACCES;
@@ -1336,8 +1336,8 @@ static int ata_hpa_resize(struct ata_device *dev)
 		 * be unlocked, skip HPA resizing.
 		 */
 		if (rc == -EACCES || !unlock_hpa) {
-			ata_dev_printk(dev, KERN_WARNING, "HPA support seems "
-				       "broken, skipping HPA handling\n");
+			ata_dev_warn(dev,
+				     "HPA support seems broken, skipping HPA handling\n");
 			dev->horkage |= ATA_HORKAGE_BROKEN_HPA;
 
 			/* we can continue if device aborted the command */
@@ -1355,14 +1355,13 @@ static int ata_hpa_resize(struct ata_device *dev)
 			return 0;
 
 		if (native_sectors > sectors)
-			ata_dev_printk(dev, KERN_INFO,
+			ata_dev_info(dev,
 				"HPA detected: current %llu, native %llu\n",
 				(unsigned long long)sectors,
 				(unsigned long long)native_sectors);
 		else if (native_sectors < sectors)
-			ata_dev_printk(dev, KERN_WARNING,
-				"native sectors (%llu) is smaller than "
-				"sectors (%llu)\n",
+			ata_dev_warn(dev,
+				"native sectors (%llu) is smaller than sectors (%llu)\n",
 				(unsigned long long)native_sectors,
 				(unsigned long long)sectors);
 		return 0;
@@ -1372,10 +1371,10 @@ static int ata_hpa_resize(struct ata_device *dev)
 	rc = ata_set_max_sectors(dev, native_sectors);
 	if (rc == -EACCES) {
 		/* if device aborted the command, skip HPA resizing */
-		ata_dev_printk(dev, KERN_WARNING, "device aborted resize "
-			       "(%llu -> %llu), skipping HPA handling\n",
-			       (unsigned long long)sectors,
-			       (unsigned long long)native_sectors);
+		ata_dev_warn(dev,
+			     "device aborted resize (%llu -> %llu), skipping HPA handling\n",
+			     (unsigned long long)sectors,
+			     (unsigned long long)native_sectors);
 		dev->horkage |= ATA_HORKAGE_BROKEN_HPA;
 		return 0;
 	} else if (rc)
@@ -1384,14 +1383,14 @@ static int ata_hpa_resize(struct ata_device *dev)
 	/* re-read IDENTIFY data */
 	rc = ata_dev_reread_id(dev, 0);
 	if (rc) {
-		ata_dev_printk(dev, KERN_ERR, "failed to re-read IDENTIFY "
-			       "data after HPA resizing\n");
+		ata_dev_err(dev,
+			    "failed to re-read IDENTIFY data after HPA resizing\n");
 		return rc;
 	}
 
 	if (print_info) {
 		u64 new_sectors = ata_id_n_sectors(dev->id);
-		ata_dev_printk(dev, KERN_INFO,
+		ata_dev_info(dev,
 			"HPA unlocked: %llu -> %llu, native %llu\n",
 			(unsigned long long)sectors,
 			(unsigned long long)new_sectors,
@@ -1655,8 +1654,8 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 				ata_qc_complete(qc);
 
 			if (ata_msg_warn(ap))
-				ata_dev_printk(dev, KERN_WARNING,
-					"qc timeout (cmd 0x%x)\n", command);
+				ata_dev_warn(dev, "qc timeout (cmd 0x%x)\n",
+					     command);
 		}
 
 		spin_unlock_irqrestore(ap->lock, flags);
@@ -1870,7 +1869,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	int rc;
 
 	if (ata_msg_ctl(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __func__);
+		ata_dev_dbg(dev, "%s: ENTER\n", __func__);
 
 retry:
 	ata_tf_init(dev, &tf);
@@ -1909,14 +1908,13 @@ retry:
 
 	if (err_mask) {
 		if (err_mask & AC_ERR_NODEV_HINT) {
-			ata_dev_printk(dev, KERN_DEBUG,
-				       "NODEV after polling detection\n");
+			ata_dev_dbg(dev, "NODEV after polling detection\n");
 			return -ENOENT;
 		}
 
 		if (is_semb) {
-			ata_dev_printk(dev, KERN_INFO, "IDENTIFY failed on "
-				       "device w/ SEMB sig, disabled\n");
+			ata_dev_info(dev,
+		     "IDENTIFY failed on device w/ SEMB sig, disabled\n");
 			/* SEMB is not supported yet */
 			*p_class = ATA_DEV_SEMB_UNSUP;
 			return 0;
@@ -1942,8 +1940,8 @@ retry:
 			 * both flavors of IDENTIFYs which happens
 			 * sometimes with phantom devices.
 			 */
-			ata_dev_printk(dev, KERN_DEBUG,
-				       "both IDENTIFYs aborted, assuming NODEV\n");
+			ata_dev_dbg(dev,
+				    "both IDENTIFYs aborted, assuming NODEV\n");
 			return -ENOENT;
 		}
 
@@ -1953,9 +1951,9 @@ retry:
 	}
 
 	if (dev->horkage & ATA_HORKAGE_DUMP_ID) {
-		ata_dev_printk(dev, KERN_DEBUG, "dumping IDENTIFY data, "
-			       "class=%d may_fallback=%d tried_spinup=%d\n",
-			       class, may_fallback, tried_spinup);
+		ata_dev_dbg(dev, "dumping IDENTIFY data, "
+			    "class=%d may_fallback=%d tried_spinup=%d\n",
+			    class, may_fallback, tried_spinup);
 		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET,
 			       16, 2, id, ATA_ID_WORDS * sizeof(*id), true);
 	}
@@ -2034,8 +2032,8 @@ retry:
 
  err_out:
 	if (ata_msg_warn(ap))
-		ata_dev_printk(dev, KERN_WARNING, "failed to IDENTIFY "
-			       "(%s, err_mask=0x%x)\n", reason, err_mask);
+		ata_dev_warn(dev, "failed to IDENTIFY (%s, err_mask=0x%x)\n",
+			     reason, err_mask);
 	return rc;
 }
 
@@ -2065,9 +2063,8 @@ static int ata_do_link_spd_horkage(struct ata_device *dev)
 	 * guaranteed by setting sata_spd_limit to target_limit above.
 	 */
 	if (plink->sata_spd > target) {
-		ata_dev_printk(dev, KERN_INFO,
-			       "applying link speed limit horkage to %s\n",
-			       sata_spd_string(target));
+		ata_dev_info(dev, "applying link speed limit horkage to %s\n",
+			     sata_spd_string(target));
 		return -EAGAIN;
 	}
 	return 0;
@@ -2110,8 +2107,9 @@ static int ata_dev_config_ncq(struct ata_device *dev,
 		err_mask = ata_dev_set_feature(dev, SETFEATURES_SATA_ENABLE,
 			SATA_FPDMA_AA);
 		if (err_mask) {
-			ata_dev_printk(dev, KERN_ERR, "failed to enable AA"
-				"(error_mask=0x%x)\n", err_mask);
+			ata_dev_err(dev,
+				    "failed to enable AA (error_mask=0x%x)\n",
+				    err_mask);
 			if (err_mask != AC_ERR_DEV) {
 				dev->horkage |= ATA_HORKAGE_BROKEN_FPDMA_AA;
 				return -EIO;
@@ -2154,31 +2152,28 @@ int ata_dev_configure(struct ata_device *dev)
 	int rc;
 
 	if (!ata_dev_enabled(dev) && ata_msg_info(ap)) {
-		ata_dev_printk(dev, KERN_INFO, "%s: ENTER/EXIT -- nodev\n",
-			       __func__);
+		ata_dev_info(dev, "%s: ENTER/EXIT -- nodev\n", __func__);
 		return 0;
 	}
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __func__);
+		ata_dev_dbg(dev, "%s: ENTER\n", __func__);
 
 	/* set horkage */
 	dev->horkage |= ata_dev_blacklisted(dev);
 	ata_force_horkage(dev);
 
 	if (dev->horkage & ATA_HORKAGE_DISABLE) {
-		ata_dev_printk(dev, KERN_INFO,
-			       "unsupported device, disabling\n");
+		ata_dev_info(dev, "unsupported device, disabling\n");
 		ata_dev_disable(dev);
 		return 0;
 	}
 
 	if ((!atapi_enabled || (ap->flags & ATA_FLAG_NO_ATAPI)) &&
 	    dev->class == ATA_DEV_ATAPI) {
-		ata_dev_printk(dev, KERN_WARNING,
-			"WARNING: ATAPI is %s, device ignored.\n",
-			atapi_enabled ? "not supported with this driver"
-				      : "disabled");
+		ata_dev_warn(dev, "WARNING: ATAPI is %s, device ignored\n",
+			     atapi_enabled ? "not supported with this driver"
+			     : "disabled");
 		ata_dev_disable(dev);
 		return 0;
 	}
@@ -2199,12 +2194,12 @@ int ata_dev_configure(struct ata_device *dev)
 
 	/* print device capabilities */
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG,
-			       "%s: cfg 49:%04x 82:%04x 83:%04x 84:%04x "
-			       "85:%04x 86:%04x 87:%04x 88:%04x\n",
-			       __func__,
-			       id[49], id[82], id[83], id[84],
-			       id[85], id[86], id[87], id[88]);
+		ata_dev_dbg(dev,
+			    "%s: cfg 49:%04x 82:%04x 83:%04x 84:%04x "
+			    "85:%04x 86:%04x 87:%04x 88:%04x\n",
+			    __func__,
+			    id[49], id[82], id[83], id[84],
+			    id[85], id[86], id[87], id[88]);
 
 	/* initialize to-be-configured parameters */
 	dev->flags &= ~ATA_DFLAG_CFG_MASK;
@@ -2238,17 +2233,15 @@ int ata_dev_configure(struct ata_device *dev)
 		if (ata_id_is_cfa(id)) {
 			/* CPRM may make this media unusable */
 			if (id[ATA_ID_CFA_KEY_MGMT] & 1)
-				ata_dev_printk(dev, KERN_WARNING,
-					       "supports DRM functions and may "
-					       "not be fully accessible.\n");
+				ata_dev_warn(dev,
+	"supports DRM functions and may not be fully accessible\n");
 			snprintf(revbuf, 7, "CFA");
 		} else {
 			snprintf(revbuf, 7, "ATA-%d", ata_id_major_version(id));
 			/* Warn the user if the device has TPM extensions */
 			if (ata_id_has_tpm(id))
-				ata_dev_printk(dev, KERN_WARNING,
-					       "supports DRM functions and may "
-					       "not be fully accessible.\n");
+				ata_dev_warn(dev,
+	"supports DRM functions and may not be fully accessible\n");
 		}
 
 		dev->n_sectors = ata_id_n_sectors(id);
@@ -2285,12 +2278,11 @@ int ata_dev_configure(struct ata_device *dev)
 
 			/* print device info to dmesg */
 			if (ata_msg_drv(ap) && print_info) {
-				ata_dev_printk(dev, KERN_INFO,
-					"%s: %s, %s, max %s\n",
-					revbuf, modelbuf, fwrevbuf,
-					ata_mode_string(xfer_mask));
-				ata_dev_printk(dev, KERN_INFO,
-					"%Lu sectors, multi %u: %s %s\n",
+				ata_dev_info(dev, "%s: %s, %s, max %s\n",
+					     revbuf, modelbuf, fwrevbuf,
+					     ata_mode_string(xfer_mask));
+				ata_dev_info(dev,
+					     "%llu sectors, multi %u: %s %s\n",
 					(unsigned long long)dev->n_sectors,
 					dev->multi_count, lba_desc, ncq_desc);
 			}
@@ -2311,15 +2303,14 @@ int ata_dev_configure(struct ata_device *dev)
 
 			/* print device info to dmesg */
 			if (ata_msg_drv(ap) && print_info) {
-				ata_dev_printk(dev, KERN_INFO,
-					"%s: %s, %s, max %s\n",
-					revbuf,	modelbuf, fwrevbuf,
-					ata_mode_string(xfer_mask));
-				ata_dev_printk(dev, KERN_INFO,
-					"%Lu sectors, multi %u, CHS %u/%u/%u\n",
-					(unsigned long long)dev->n_sectors,
-					dev->multi_count, dev->cylinders,
-					dev->heads, dev->sectors);
+				ata_dev_info(dev, "%s: %s, %s, max %s\n",
+					     revbuf,	modelbuf, fwrevbuf,
+					     ata_mode_string(xfer_mask));
+				ata_dev_info(dev,
+					     "%llu sectors, multi %u, CHS %u/%u/%u\n",
+					     (unsigned long long)dev->n_sectors,
+					     dev->multi_count, dev->cylinders,
+					     dev->heads, dev->sectors);
 			}
 		}
 
@@ -2336,8 +2327,7 @@ int ata_dev_configure(struct ata_device *dev)
 		rc = atapi_cdb_len(id);
 		if ((rc < 12) || (rc > ATAPI_CDB_LEN)) {
 			if (ata_msg_warn(ap))
-				ata_dev_printk(dev, KERN_WARNING,
-					       "unsupported CDB len\n");
+				ata_dev_warn(dev, "unsupported CDB len\n");
 			rc = -EINVAL;
 			goto err_out_nosup;
 		}
@@ -2358,9 +2348,9 @@ int ata_dev_configure(struct ata_device *dev)
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_ENABLE, SATA_AN);
 			if (err_mask)
-				ata_dev_printk(dev, KERN_ERR,
-					"failed to enable ATAPI AN "
-					"(err_mask=0x%x)\n", err_mask);
+				ata_dev_err(dev,
+					    "failed to enable ATAPI AN (err_mask=0x%x)\n",
+					    err_mask);
 			else {
 				dev->flags |= ATA_DFLAG_AN;
 				atapi_an_string = ", ATAPI AN";
@@ -2379,12 +2369,12 @@ int ata_dev_configure(struct ata_device *dev)
 
 		/* print device info to dmesg */
 		if (ata_msg_drv(ap) && print_info)
-			ata_dev_printk(dev, KERN_INFO,
-				       "ATAPI: %s, %s, max %s%s%s%s\n",
-				       modelbuf, fwrevbuf,
-				       ata_mode_string(xfer_mask),
-				       cdb_intr_string, atapi_an_string,
-				       dma_dir_string);
+			ata_dev_info(dev,
+				     "ATAPI: %s, %s, max %s%s%s%s\n",
+				     modelbuf, fwrevbuf,
+				     ata_mode_string(xfer_mask),
+				     cdb_intr_string, atapi_an_string,
+				     dma_dir_string);
 	}
 
 	/* determine max_sectors */
@@ -2396,8 +2386,7 @@ int ata_dev_configure(struct ata_device *dev)
 	   200 sectors */
 	if (ata_dev_knobble(dev)) {
 		if (ata_msg_drv(ap) && print_info)
-			ata_dev_printk(dev, KERN_INFO,
-				       "applying bridge limits\n");
+			ata_dev_info(dev, "applying bridge limits\n");
 		dev->udma_mask &= ATA_UDMA5;
 		dev->max_sectors = ATA_MAX_SECTORS;
 	}
@@ -2423,26 +2412,23 @@ int ata_dev_configure(struct ata_device *dev)
 		   bugs */
 
 		if (print_info) {
-			ata_dev_printk(dev, KERN_WARNING,
+			ata_dev_warn(dev,
 "Drive reports diagnostics failure. This may indicate a drive\n");
-			ata_dev_printk(dev, KERN_WARNING,
+			ata_dev_warn(dev,
 "fault or invalid emulation. Contact drive vendor for information.\n");
 		}
 	}
 
 	if ((dev->horkage & ATA_HORKAGE_FIRMWARE_WARN) && print_info) {
-		ata_dev_printk(dev, KERN_WARNING, "WARNING: device requires "
-			       "firmware update to be fully functional.\n");
-		ata_dev_printk(dev, KERN_WARNING, "         contact the vendor "
-			       "or visit http://ata.wiki.kernel.org.\n");
+		ata_dev_warn(dev, "WARNING: device requires firmware update to be fully functional\n");
+		ata_dev_warn(dev, "         contact the vendor or visit http://ata.wiki.kernel.org\n");
 	}
 
 	return 0;
 
 err_out_nosup:
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG,
-			       "%s: EXIT, err\n", __func__);
+		ata_dev_dbg(dev, "%s: EXIT, err\n", __func__);
 	return rc;
 }
 
@@ -2663,13 +2649,11 @@ static void sata_print_link_status(struct ata_link *link)
 
 	if (ata_phys_link_online(link)) {
 		tmp = (sstatus >> 4) & 0xf;
-		ata_link_printk(link, KERN_INFO,
-				"SATA link up %s (SStatus %X SControl %X)\n",
-				sata_spd_string(tmp), sstatus, scontrol);
+		ata_link_info(link, "SATA link up %s (SStatus %X SControl %X)\n",
+			      sata_spd_string(tmp), sstatus, scontrol);
 	} else {
-		ata_link_printk(link, KERN_INFO,
-				"SATA link down (SStatus %X SControl %X)\n",
-				sstatus, scontrol);
+		ata_link_info(link, "SATA link down (SStatus %X SControl %X)\n",
+			      sstatus, scontrol);
 	}
 }
 
@@ -2758,8 +2742,8 @@ int sata_down_spd_limit(struct ata_link *link, u32 spd_limit)
 
 	link->sata_spd_limit = mask;
 
-	ata_link_printk(link, KERN_WARNING, "limiting SATA link speed to %s\n",
-			sata_spd_string(fls(mask)));
+	ata_link_warn(link, "limiting SATA link speed to %s\n",
+		      sata_spd_string(fls(mask)));
 
 	return 0;
 }
@@ -3136,8 +3120,7 @@ int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel)
 			snprintf(buf, sizeof(buf), "%s",
 				 ata_mode_string(xfer_mask));
 
-		ata_dev_printk(dev, KERN_WARNING,
-			       "limiting speed to %s\n", buf);
+		ata_dev_warn(dev, "limiting speed to %s\n", buf);
 	}
 
 	ata_unpack_xfermask(xfer_mask, &dev->pio_mask, &dev->mwdma_mask,
@@ -3164,9 +3147,9 @@ static int ata_dev_set_mode(struct ata_device *dev)
 		dev_err_whine = " (SET_XFERMODE skipped)";
 	else {
 		if (nosetxfer)
-			ata_dev_printk(dev, KERN_WARNING,
-				       "NOSETXFER but PATA detected - can't "
-				       "skip SETXFER, might malfunction\n");
+			ata_dev_warn(dev,
+				     "NOSETXFER but PATA detected - can't "
+				     "skip SETXFER, might malfunction\n");
 		err_mask = ata_dev_set_xfermode(dev);
 	}
 
@@ -3216,15 +3199,14 @@ static int ata_dev_set_mode(struct ata_device *dev)
 	DPRINTK("xfer_shift=%u, xfer_mode=0x%x\n",
 		dev->xfer_shift, (int)dev->xfer_mode);
 
-	ata_dev_printk(dev, KERN_INFO, "configured for %s%s\n",
-		       ata_mode_string(ata_xfer_mode2mask(dev->xfer_mode)),
-		       dev_err_whine);
+	ata_dev_info(dev, "configured for %s%s\n",
+		     ata_mode_string(ata_xfer_mode2mask(dev->xfer_mode)),
+		     dev_err_whine);
 
 	return 0;
 
  fail:
-	ata_dev_printk(dev, KERN_ERR, "failed to set xfermode "
-		       "(err_mask=0x%x)\n", err_mask);
+	ata_dev_err(dev, "failed to set xfermode (err_mask=0x%x)\n", err_mask);
 	return -EIO;
 }
 
@@ -3286,7 +3268,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 	/* step 2: always set host PIO timings */
 	ata_for_each_dev(dev, link, ENABLED) {
 		if (dev->pio_mode == 0xff) {
-			ata_dev_printk(dev, KERN_WARNING, "no PIO support\n");
+			ata_dev_warn(dev, "no PIO support\n");
 			rc = -EINVAL;
 			goto out;
 		}
@@ -3404,7 +3386,7 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 
 		if (!warned && time_after(now, start + 5 * HZ) &&
 		    (deadline - now > 3 * HZ)) {
-			ata_link_printk(link, KERN_WARNING,
+			ata_link_warn(link,
 				"link is slow to respond, please be patient "
 				"(ready=%d)\n", tmp);
 			warned = 1;
@@ -3552,16 +3534,14 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 	} while ((scontrol & 0xf0f) != 0x300 && --tries);
 
 	if ((scontrol & 0xf0f) != 0x300) {
-		ata_link_printk(link, KERN_ERR,
-				"failed to resume link (SControl %X)\n",
-				scontrol);
+		ata_link_warn(link, "failed to resume link (SControl %X)\n",
+			     scontrol);
 		return 0;
 	}
 
 	if (tries < ATA_LINK_RESUME_TRIES)
-		ata_link_printk(link, KERN_WARNING,
-				"link resume succeeded after %d retries\n",
-				ATA_LINK_RESUME_TRIES - tries);
+		ata_link_warn(link, "link resume succeeded after %d retries\n",
+			      ATA_LINK_RESUME_TRIES - tries);
 
 	if ((rc = sata_link_debounce(link, params, deadline)))
 		return rc;
@@ -3678,8 +3658,9 @@ int ata_std_prereset(struct ata_link *link, unsigned long deadline)
 		rc = sata_link_resume(link, timing, deadline);
 		/* whine about phy resume failure but proceed */
 		if (rc && rc != -EOPNOTSUPP)
-			ata_link_printk(link, KERN_WARNING, "failed to resume "
-					"link for reset (errno=%d)\n", rc);
+			ata_link_warn(link,
+				      "failed to resume link for reset (errno=%d)\n",
+				      rc);
 	}
 
 	/* no point in trying softreset on offline link */
@@ -3795,8 +3776,7 @@ int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
 		/* online is set iff link is online && reset succeeded */
 		if (online)
 			*online = false;
-		ata_link_printk(link, KERN_ERR,
-				"COMRESET failed (errno=%d)\n", rc);
+		ata_link_err(link, "COMRESET failed (errno=%d)\n", rc);
 	}
 	DPRINTK("EXIT, rc=%d\n", rc);
 	return rc;
@@ -3880,8 +3860,8 @@ static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
 	unsigned char serial[2][ATA_ID_SERNO_LEN + 1];
 
 	if (dev->class != new_class) {
-		ata_dev_printk(dev, KERN_INFO, "class mismatch %d != %d\n",
-			       dev->class, new_class);
+		ata_dev_info(dev, "class mismatch %d != %d\n",
+			     dev->class, new_class);
 		return 0;
 	}
 
@@ -3891,14 +3871,14 @@ static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
 	ata_id_c_string(new_id, serial[1], ATA_ID_SERNO, sizeof(serial[1]));
 
 	if (strcmp(model[0], model[1])) {
-		ata_dev_printk(dev, KERN_INFO, "model number mismatch "
-			       "'%s' != '%s'\n", model[0], model[1]);
+		ata_dev_info(dev, "model number mismatch '%s' != '%s'\n",
+			     model[0], model[1]);
 		return 0;
 	}
 
 	if (strcmp(serial[0], serial[1])) {
-		ata_dev_printk(dev, KERN_INFO, "serial number mismatch "
-			       "'%s' != '%s'\n", serial[0], serial[1]);
+		ata_dev_info(dev, "serial number mismatch '%s' != '%s'\n",
+			     serial[0], serial[1]);
 		return 0;
 	}
 
@@ -3968,8 +3948,8 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	    new_class != ATA_DEV_ATA &&
 	    new_class != ATA_DEV_ATAPI &&
 	    new_class != ATA_DEV_SEMB) {
-		ata_dev_printk(dev, KERN_INFO, "class mismatch %u != %u\n",
-			       dev->class, new_class);
+		ata_dev_info(dev, "class mismatch %u != %u\n",
+			     dev->class, new_class);
 		rc = -ENODEV;
 		goto fail;
 	}
@@ -3990,9 +3970,9 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 		return 0;
 
 	/* n_sectors has changed */
-	ata_dev_printk(dev, KERN_WARNING, "n_sectors mismatch %llu != %llu\n",
-		       (unsigned long long)n_sectors,
-		       (unsigned long long)dev->n_sectors);
+	ata_dev_warn(dev, "n_sectors mismatch %llu != %llu\n",
+		     (unsigned long long)n_sectors,
+		     (unsigned long long)dev->n_sectors);
 
 	/*
 	 * Something could have caused HPA to be unlocked
@@ -4001,9 +3981,9 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	 */
 	if (dev->n_native_sectors == n_native_sectors &&
 	    dev->n_sectors > n_sectors && dev->n_sectors == n_native_sectors) {
-		ata_dev_printk(dev, KERN_WARNING,
-			       "new n_sectors matches native, probably "
-			       "late HPA unlock, n_sectors updated\n");
+		ata_dev_warn(dev,
+			     "new n_sectors matches native, probably "
+			     "late HPA unlock, n_sectors updated\n");
 		/* use the larger n_sectors */
 		return 0;
 	}
@@ -4017,9 +3997,9 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	if (dev->n_native_sectors == n_native_sectors &&
 	    dev->n_sectors < n_sectors && n_sectors == n_native_sectors &&
 	    !(dev->horkage & ATA_HORKAGE_BROKEN_HPA)) {
-		ata_dev_printk(dev, KERN_WARNING,
-			       "old n_sectors matches native, probably "
-			       "late HPA lock, will try to unlock HPA\n");
+		ata_dev_warn(dev,
+			     "old n_sectors matches native, probably "
+			     "late HPA lock, will try to unlock HPA\n");
 		/* try unlocking HPA */
 		dev->flags |= ATA_DFLAG_UNLOCK_HPA;
 		rc = -EIO;
@@ -4030,7 +4010,7 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	dev->n_native_sectors = n_native_sectors;
 	dev->n_sectors = n_sectors;
  fail:
-	ata_dev_printk(dev, KERN_ERR, "revalidation failed (errno=%d)\n", rc);
+	ata_dev_err(dev, "revalidation failed (errno=%d)\n", rc);
 	return rc;
 }
 
@@ -4358,15 +4338,15 @@ static void ata_dev_xfermask(struct ata_device *dev)
 
 	if (ata_dma_blacklisted(dev)) {
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
-		ata_dev_printk(dev, KERN_WARNING,
-			       "device is on DMA blacklist, disabling DMA\n");
+		ata_dev_warn(dev,
+			     "device is on DMA blacklist, disabling DMA\n");
 	}
 
 	if ((host->flags & ATA_HOST_SIMPLEX) &&
 	    host->simplex_claimed && host->simplex_claimed != ap) {
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
-		ata_dev_printk(dev, KERN_WARNING, "simplex DMA is claimed by "
-			       "other device, disabling DMA\n");
+		ata_dev_warn(dev,
+			     "simplex DMA is claimed by other device, disabling DMA\n");
 	}
 
 	if (ap->flags & ATA_FLAG_NO_IORDY)
@@ -4386,8 +4366,8 @@ static void ata_dev_xfermask(struct ata_device *dev)
 	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
 		/* UDMA/44 or higher would be available */
 		if (cable_is_40wire(ap)) {
-			ata_dev_printk(dev, KERN_WARNING,
-				 "limited to UDMA/33 due to 40-wire cable\n");
+			ata_dev_warn(dev,
+				     "limited to UDMA/33 due to 40-wire cable\n");
 			xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
 		}
 
@@ -4954,8 +4934,8 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
 	done_mask = ap->qc_active ^ qc_active;
 
 	if (unlikely(done_mask & qc_active)) {
-		ata_port_printk(ap, KERN_ERR, "illegal qc_active transition "
-				"(%08x->%08x)\n", ap->qc_active, qc_active);
+		ata_port_err(ap, "illegal qc_active transition (%08x->%08x)\n",
+			     ap->qc_active, qc_active);
 		return -EINVAL;
 	}
 
@@ -5847,9 +5827,9 @@ int ata_host_start(struct ata_host *host)
 			rc = ap->ops->port_start(ap);
 			if (rc) {
 				if (rc != -ENODEV)
-					dev_printk(KERN_ERR, host->dev,
-						"failed to start port %d "
-						"(errno=%d)\n", i, rc);
+					dev_err(host->dev,
+						"failed to start port %d (errno=%d)\n",
+						i, rc);
 				goto err_out;
 			}
 		}
@@ -5971,8 +5951,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 	/* host must have been started */
 	if (!(host->flags & ATA_HOST_STARTED)) {
-		dev_printk(KERN_ERR, host->dev,
-			   "BUG: trying to register unstarted host\n");
+		dev_err(host->dev, "BUG: trying to register unstarted host\n");
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -6023,14 +6002,13 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 					      ap->udma_mask);
 
 		if (!ata_port_is_dummy(ap)) {
-			ata_port_printk(ap, KERN_INFO,
-					"%cATA max %s %s\n",
-					(ap->flags & ATA_FLAG_SATA) ? 'S' : 'P',
-					ata_mode_string(xfer_mask),
-					ap->link.eh_info.desc);
+			ata_port_info(ap, "%cATA max %s %s\n",
+				      (ap->flags & ATA_FLAG_SATA) ? 'S' : 'P',
+				      ata_mode_string(xfer_mask),
+				      ap->link.eh_info.desc);
 			ata_ehi_clear_desc(&ap->link.eh_info);
 		} else
-			ata_port_printk(ap, KERN_INFO, "DUMMY\n");
+			ata_port_info(ap, "DUMMY\n");
 	}
 
 	/* perform each probe asynchronously */
@@ -6242,8 +6220,8 @@ int ata_pci_device_do_resume(struct pci_dev *pdev)
 
 	rc = pcim_enable_device(pdev);
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "failed to enable device after resume (%d)\n", rc);
+		dev_err(&pdev->dev,
+			"failed to enable device after resume (%d)\n", rc);
 		return rc;
 	}
 
@@ -6600,6 +6578,82 @@ const struct ata_port_info ata_dummy_port_info = {
 };
 
 /*
+ * Utility print functions
+ */
+int ata_port_printk(const struct ata_port *ap, const char *level,
+		    const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	r = printk("%sata%u: %pV", level, ap->print_id, &vaf);
+
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(ata_port_printk);
+
+int ata_link_printk(const struct ata_link *link, const char *level,
+		    const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (sata_pmp_attached(link->ap) || link->ap->slave_link)
+		r = printk("%sata%u.%02u: %pV",
+			   level, link->ap->print_id, link->pmp, &vaf);
+	else
+		r = printk("%sata%u: %pV",
+			   level, link->ap->print_id, &vaf);
+
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(ata_link_printk);
+
+int ata_dev_printk(const struct ata_device *dev, const char *level,
+		    const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	r = printk("%sata%u.%02u: %pV",
+		   level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
+		   &vaf);
+
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(ata_dev_printk);
+
+void ata_print_version(const struct device *dev, const char *version)
+{
+	dev_printk(KERN_DEBUG, dev, "version %s\n", version);
+}
+EXPORT_SYMBOL(ata_print_version);
+
+/*
  * libata is essentially a library of internal helper functions for
  * low-level ATA host controller drivers.  As such, the API/ABI is
  * likely to change as new drivers are added and updated.
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 7f099d6..ed16fbe 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -782,8 +782,9 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 				spin_unlock_irqrestore(ap->lock, flags);
 				goto repeat;
 			}
-			ata_port_printk(ap, KERN_ERR, "EH pending after %d "
-					"tries, giving up\n", ATA_EH_MAX_TRIES);
+			ata_port_err(ap,
+				     "EH pending after %d tries, giving up\n",
+				     ATA_EH_MAX_TRIES);
 			ap->pflags &= ~ATA_PFLAG_EH_PENDING;
 		}
 
@@ -816,7 +817,7 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 		schedule_delayed_work(&ap->hotplug_task, 0);
 
 	if (ap->pflags & ATA_PFLAG_RECOVERED)
-		ata_port_printk(ap, KERN_INFO, "EH complete\n");
+		ata_port_info(ap, "EH complete\n");
 
 	ap->pflags &= ~(ATA_PFLAG_SCSI_HOTPLUG | ATA_PFLAG_RECOVERED);
 
@@ -1310,7 +1311,7 @@ void ata_dev_disable(struct ata_device *dev)
 		return;
 
 	if (ata_msg_drv(dev->link->ap))
-		ata_dev_printk(dev, KERN_WARNING, "disabled\n");
+		ata_dev_warn(dev, "disabled\n");
 	ata_acpi_on_disable(dev);
 	ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO0 | ATA_DNXFER_QUIET);
 	dev->class++;
@@ -1515,8 +1516,8 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 	for (i = 0; i < ATA_SECT_SIZE; i++)
 		csum += buf[i];
 	if (csum)
-		ata_dev_printk(dev, KERN_WARNING,
-			       "invalid checksum 0x%x on log page 10h\n", csum);
+		ata_dev_warn(dev, "invalid checksum 0x%x on log page 10h\n",
+			     csum);
 
 	if (buf[0] & 0x80)
 		return -ENOENT;
@@ -1716,14 +1717,14 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	memset(&tf, 0, sizeof(tf));
 	rc = ata_eh_read_log_10h(dev, &tag, &tf);
 	if (rc) {
-		ata_link_printk(link, KERN_ERR, "failed to read log page 10h "
-				"(errno=%d)\n", rc);
+		ata_link_err(link, "failed to read log page 10h (errno=%d)\n",
+			     rc);
 		return;
 	}
 
 	if (!(link->sactive & (1 << tag))) {
-		ata_link_printk(link, KERN_ERR, "log page 10h reported "
-				"inactive tag %d\n", tag);
+		ata_link_err(link, "log page 10h reported inactive tag %d\n",
+			     tag);
 		return;
 	}
 
@@ -1988,8 +1989,7 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev,
 	    (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ |
 			   ATA_DFLAG_NCQ_OFF)) == ATA_DFLAG_NCQ) {
 		dev->flags |= ATA_DFLAG_NCQ_OFF;
-		ata_dev_printk(dev, KERN_WARNING,
-			       "NCQ disabled due to excessive errors\n");
+		ata_dev_warn(dev, "NCQ disabled due to excessive errors\n");
 		goto done;
 	}
 
@@ -2374,24 +2374,24 @@ static void ata_eh_link_report(struct ata_link *link)
 			 ap->eh_tries);
 
 	if (ehc->i.dev) {
-		ata_dev_printk(ehc->i.dev, KERN_ERR, "exception Emask 0x%x "
-			       "SAct 0x%x SErr 0x%x action 0x%x%s%s\n",
-			       ehc->i.err_mask, link->sactive, ehc->i.serror,
-			       ehc->i.action, frozen, tries_buf);
+		ata_dev_err(ehc->i.dev, "exception Emask 0x%x "
+			    "SAct 0x%x SErr 0x%x action 0x%x%s%s\n",
+			    ehc->i.err_mask, link->sactive, ehc->i.serror,
+			    ehc->i.action, frozen, tries_buf);
 		if (desc)
-			ata_dev_printk(ehc->i.dev, KERN_ERR, "%s\n", desc);
+			ata_dev_err(ehc->i.dev, "%s\n", desc);
 	} else {
-		ata_link_printk(link, KERN_ERR, "exception Emask 0x%x "
-				"SAct 0x%x SErr 0x%x action 0x%x%s%s\n",
-				ehc->i.err_mask, link->sactive, ehc->i.serror,
-				ehc->i.action, frozen, tries_buf);
+		ata_link_err(link, "exception Emask 0x%x "
+			     "SAct 0x%x SErr 0x%x action 0x%x%s%s\n",
+			     ehc->i.err_mask, link->sactive, ehc->i.serror,
+			     ehc->i.action, frozen, tries_buf);
 		if (desc)
-			ata_link_printk(link, KERN_ERR, "%s\n", desc);
+			ata_link_err(link, "%s\n", desc);
 	}
 
 #ifdef CONFIG_ATA_VERBOSE_ERROR
 	if (ehc->i.serror)
-		ata_link_printk(link, KERN_ERR,
+		ata_link_err(link,
 		  "SError: { %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
 		  ehc->i.serror & SERR_DATA_RECOVERED ? "RecovData " : "",
 		  ehc->i.serror & SERR_COMM_RECOVERED ? "RecovComm " : "",
@@ -2456,11 +2456,11 @@ static void ata_eh_link_report(struct ata_link *link)
 		} else {
 			const char *descr = ata_get_cmd_descript(cmd->command);
 			if (descr)
-				ata_dev_printk(qc->dev, KERN_ERR,
-					"failed command: %s\n", descr);
+				ata_dev_err(qc->dev, "failed command: %s\n",
+					    descr);
 		}
 
-		ata_dev_printk(qc->dev, KERN_ERR,
+		ata_dev_err(qc->dev,
 			"cmd %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
 			"tag %d%s\n         %s"
 			"res %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
@@ -2481,11 +2481,9 @@ static void ata_eh_link_report(struct ata_link *link)
 		if (res->command & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ |
 				    ATA_ERR)) {
 			if (res->command & ATA_BUSY)
-				ata_dev_printk(qc->dev, KERN_ERR,
-				  "status: { Busy }\n");
+				ata_dev_err(qc->dev, "status: { Busy }\n");
 			else
-				ata_dev_printk(qc->dev, KERN_ERR,
-				  "status: { %s%s%s%s}\n",
+				ata_dev_err(qc->dev, "status: { %s%s%s%s}\n",
 				  res->command & ATA_DRDY ? "DRDY " : "",
 				  res->command & ATA_DF ? "DF " : "",
 				  res->command & ATA_DRQ ? "DRQ " : "",
@@ -2495,8 +2493,7 @@ static void ata_eh_link_report(struct ata_link *link)
 		if (cmd->command != ATA_CMD_PACKET &&
 		    (res->feature & (ATA_ICRC | ATA_UNC | ATA_IDNF |
 				     ATA_ABORTED)))
-			ata_dev_printk(qc->dev, KERN_ERR,
-			  "error: { %s%s%s%s}\n",
+			ata_dev_err(qc->dev, "error: { %s%s%s%s}\n",
 			  res->feature & ATA_ICRC ? "ICRC " : "",
 			  res->feature & ATA_UNC ? "UNC " : "",
 			  res->feature & ATA_IDNF ? "IDNF " : "",
@@ -2650,8 +2647,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 		if (rc) {
 			if (rc == -ENOENT) {
-				ata_link_printk(link, KERN_DEBUG,
-						"port disabled. ignoring.\n");
+				ata_link_dbg(link, "port disabled--ignoring\n");
 				ehc->i.action &= ~ATA_EH_RESET;
 
 				ata_for_each_dev(dev, link, ALL)
@@ -2659,8 +2655,9 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 				rc = 0;
 			} else
-				ata_link_printk(link, KERN_ERR,
-					"prereset failed (errno=%d)\n", rc);
+				ata_link_err(link,
+					     "prereset failed (errno=%d)\n",
+					     rc);
 			goto out;
 		}
 
@@ -2689,8 +2686,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 	if (reset) {
 		if (verbose)
-			ata_link_printk(link, KERN_INFO, "%s resetting link\n",
-					reset == softreset ? "soft" : "hard");
+			ata_link_info(link, "%s resetting link\n",
+				      reset == softreset ? "soft" : "hard");
 
 		/* mark that this EH session started with reset */
 		ehc->last_reset = jiffies;
@@ -2710,8 +2707,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			int tmp;
 
 			if (verbose)
-				ata_link_printk(slave, KERN_INFO,
-						"hard resetting link\n");
+				ata_link_info(slave, "hard resetting link\n");
 
 			ata_eh_about_to_do(slave, NULL, ATA_EH_RESET);
 			tmp = ata_do_reset(slave, reset, classes, deadline,
@@ -2734,9 +2730,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			reset = softreset;
 
 			if (!reset) {
-				ata_link_printk(link, KERN_ERR,
-						"follow-up softreset required "
-						"but no softreset available\n");
+				ata_link_err(link,
+	     "follow-up softreset required but no softreset available\n");
 				failed_link = link;
 				rc = -EINVAL;
 				goto fail;
@@ -2751,8 +2746,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		}
 	} else {
 		if (verbose)
-			ata_link_printk(link, KERN_INFO, "no reset method "
-					"available, skipping reset\n");
+			ata_link_info(link,
+	"no reset method available, skipping reset\n");
 		if (!(lflags & ATA_LFLAG_ASSUME_CLASS))
 			lflags |= ATA_LFLAG_ASSUME_ATA;
 	}
@@ -2830,36 +2825,35 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	ata_for_each_dev(dev, link, ALL) {
 		if (ata_phys_link_online(ata_dev_phys_link(dev))) {
 			if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
-				ata_dev_printk(dev, KERN_DEBUG, "link online "
-					       "but device misclassifed\n");
+				ata_dev_dbg(dev, "link online but device misclassified\n");
 				classes[dev->devno] = ATA_DEV_NONE;
 				nr_unknown++;
 			}
 		} else if (ata_phys_link_offline(ata_dev_phys_link(dev))) {
 			if (ata_class_enabled(classes[dev->devno]))
-				ata_dev_printk(dev, KERN_DEBUG, "link offline, "
-					       "clearing class %d to NONE\n",
-					       classes[dev->devno]);
+				ata_dev_dbg(dev,
+					    "link offline, clearing class %d to NONE\n",
+					    classes[dev->devno]);
 			classes[dev->devno] = ATA_DEV_NONE;
 		} else if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
-			ata_dev_printk(dev, KERN_DEBUG, "link status unknown, "
-				       "clearing UNKNOWN to NONE\n");
+			ata_dev_dbg(dev,
+				    "link status unknown, clearing UNKNOWN to NONE\n");
 			classes[dev->devno] = ATA_DEV_NONE;
 		}
 	}
 
 	if (classify && nr_unknown) {
 		if (try < max_tries) {
-			ata_link_printk(link, KERN_WARNING, "link online but "
-					"%d devices misclassified, retrying\n",
-					nr_unknown);
+			ata_link_warn(link,
+				      "link online but %d devices misclassified, retrying\n",
+				      nr_unknown);
 			failed_link = link;
 			rc = -EAGAIN;
 			goto fail;
 		}
-		ata_link_printk(link, KERN_WARNING,
-				"link online but %d devices misclassified, "
-				"device detection might fail\n", nr_unknown);
+		ata_link_warn(link,
+			      "link online but %d devices misclassified, "
+			      "device detection might fail\n", nr_unknown);
 	}
 
 	/* reset successful, schedule revalidation */
@@ -2889,14 +2883,23 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	    sata_scr_read(link, SCR_STATUS, &sstatus))
 		rc = -ERESTART;
 
-	if (rc == -ERESTART || try >= max_tries)
+	if (rc == -ERESTART || try >= max_tries) {
+		/*
+		 * Thaw host port even if reset failed, so that the port
+		 * can be retried on the next phy event.  This risks
+		 * repeated EH runs but seems to be a better tradeoff than
+		 * shutting down a port after a botched hotplug attempt.
+		 */
+		if (ata_is_host_link(link))
+			ata_eh_thaw_port(ap);
 		goto out;
+	}
 
 	now = jiffies;
 	if (time_before(now, deadline)) {
 		unsigned long delta = deadline - now;
 
-		ata_link_printk(failed_link, KERN_WARNING,
+		ata_link_warn(failed_link,
 			"reset failed (errno=%d), retrying in %u secs\n",
 			rc, DIV_ROUND_UP(jiffies_to_msecs(delta), 1000));
 
@@ -2987,7 +2990,7 @@ static void ata_eh_park_issue_cmd(struct ata_device *dev, int park)
 	tf.protocol |= ATA_PROT_NODATA;
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 	if (park && (err_mask || tf.lbal != 0xc4)) {
-		ata_dev_printk(dev, KERN_ERR, "head unload failed!\n");
+		ata_dev_err(dev, "head unload failed!\n");
 		ehc->unloaded_mask &= ~(1 << dev->devno);
 	}
 }
@@ -3198,8 +3201,9 @@ static int atapi_eh_clear_ua(struct ata_device *dev)
 
 		err_mask = atapi_eh_tur(dev, &sense_key);
 		if (err_mask != 0 && err_mask != AC_ERR_DEV) {
-			ata_dev_printk(dev, KERN_WARNING, "TEST_UNIT_READY "
-				"failed (err_mask=0x%x)\n", err_mask);
+			ata_dev_warn(dev,
+				     "TEST_UNIT_READY failed (err_mask=0x%x)\n",
+				     err_mask);
 			return -EIO;
 		}
 
@@ -3208,14 +3212,14 @@ static int atapi_eh_clear_ua(struct ata_device *dev)
 
 		err_mask = atapi_eh_request_sense(dev, sense_buffer, sense_key);
 		if (err_mask) {
-			ata_dev_printk(dev, KERN_WARNING, "failed to clear "
+			ata_dev_warn(dev, "failed to clear "
 				"UNIT ATTENTION (err_mask=0x%x)\n", err_mask);
 			return -EIO;
 		}
 	}
 
-	ata_dev_printk(dev, KERN_WARNING,
-		"UNIT ATTENTION persists after %d tries\n", ATA_EH_UA_TRIES);
+	ata_dev_warn(dev, "UNIT ATTENTION persists after %d tries\n",
+		     ATA_EH_UA_TRIES);
 
 	return 0;
 }
@@ -3266,7 +3270,7 @@ static int ata_eh_maybe_retry_flush(struct ata_device *dev)
 	tf.flags |= ATA_TFLAG_DEVICE;
 	tf.protocol = ATA_PROT_NODATA;
 
-	ata_dev_printk(dev, KERN_WARNING, "retrying FLUSH 0x%x Emask 0x%x\n",
+	ata_dev_warn(dev, "retrying FLUSH 0x%x Emask 0x%x\n",
 		       tf.command, qc->err_mask);
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
@@ -3281,7 +3285,7 @@ static int ata_eh_maybe_retry_flush(struct ata_device *dev)
 		 */
 		qc->scsicmd->allowed = max(qc->scsicmd->allowed, 1);
 	} else {
-		ata_dev_printk(dev, KERN_WARNING, "FLUSH failed Emask 0x%x\n",
+		ata_dev_warn(dev, "FLUSH failed Emask 0x%x\n",
 			       err_mask);
 		rc = -EIO;
 
@@ -3355,9 +3359,9 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_DISABLE, SATA_DIPM);
 			if (err_mask && err_mask != AC_ERR_DEV) {
-				ata_dev_printk(dev, KERN_WARNING,
-					"failed to disable DIPM, Emask 0x%x\n",
-					err_mask);
+				ata_dev_warn(dev,
+					     "failed to disable DIPM, Emask 0x%x\n",
+					     err_mask);
 				rc = -EIO;
 				goto fail;
 			}
@@ -3399,7 +3403,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_ENABLE, SATA_DIPM);
 			if (err_mask && err_mask != AC_ERR_DEV) {
-				ata_dev_printk(dev, KERN_WARNING,
+				ata_dev_warn(dev,
 					"failed to enable DIPM, Emask 0x%x\n",
 					err_mask);
 				rc = -EIO;
@@ -3418,8 +3422,7 @@ fail:
 
 	/* if no device or only one more chance is left, disable LPM */
 	if (!dev || ehc->tries[dev->devno] <= 2) {
-		ata_link_printk(link, KERN_WARNING,
-				"disabling LPM on the link\n");
+		ata_link_warn(link, "disabling LPM on the link\n");
 		link->flags |= ATA_LFLAG_NO_LPM;
 	}
 	if (r_failed_dev)
@@ -3690,8 +3693,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		rc = ata_eh_reset(link, ata_link_nr_vacant(link),
 				  prereset, softreset, hardreset, postreset);
 		if (rc) {
-			ata_link_printk(link, KERN_ERR,
-					"reset failed, giving up\n");
+			ata_link_err(link, "reset failed, giving up\n");
 			goto out;
 		}
 	}
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index f06b7ea..3eb2b81 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -147,8 +147,8 @@ int sata_pmp_scr_read(struct ata_link *link, int reg, u32 *r_val)
 
 	err_mask = sata_pmp_read(link, reg, r_val);
 	if (err_mask) {
-		ata_link_printk(link, KERN_WARNING, "failed to read SCR %d "
-				"(Emask=0x%x)\n", reg, err_mask);
+		ata_link_warn(link, "failed to read SCR %d (Emask=0x%x)\n",
+			      reg, err_mask);
 		return -EIO;
 	}
 	return 0;
@@ -178,8 +178,8 @@ int sata_pmp_scr_write(struct ata_link *link, int reg, u32 val)
 
 	err_mask = sata_pmp_write(link, reg, val);
 	if (err_mask) {
-		ata_link_printk(link, KERN_WARNING, "failed to write SCR %d "
-				"(Emask=0x%x)\n", reg, err_mask);
+		ata_link_warn(link, "failed to write SCR %d (Emask=0x%x)\n",
+			      reg, err_mask);
 		return -EIO;
 	}
 	return 0;
@@ -231,8 +231,8 @@ static int sata_pmp_read_gscr(struct ata_device *dev, u32 *gscr)
 
 		err_mask = sata_pmp_read(dev->link, reg, &gscr[reg]);
 		if (err_mask) {
-			ata_dev_printk(dev, KERN_ERR, "failed to read PMP "
-				"GSCR[%d] (Emask=0x%x)\n", reg, err_mask);
+			ata_dev_err(dev, "failed to read PMP GSCR[%d] (Emask=0x%x)\n",
+				    reg, err_mask);
 			return -EIO;
 		}
 	}
@@ -311,26 +311,25 @@ static int sata_pmp_configure(struct ata_device *dev, int print_info)
 	}
 
 	if (print_info) {
-		ata_dev_printk(dev, KERN_INFO, "Port Multiplier %s, "
-			       "0x%04x:0x%04x r%d, %d ports, feat 0x%x/0x%x\n",
-			       sata_pmp_spec_rev_str(gscr), vendor, devid,
-			       sata_pmp_gscr_rev(gscr),
-			       nr_ports, gscr[SATA_PMP_GSCR_FEAT_EN],
-			       gscr[SATA_PMP_GSCR_FEAT]);
+		ata_dev_info(dev, "Port Multiplier %s, "
+			     "0x%04x:0x%04x r%d, %d ports, feat 0x%x/0x%x\n",
+			     sata_pmp_spec_rev_str(gscr), vendor, devid,
+			     sata_pmp_gscr_rev(gscr),
+			     nr_ports, gscr[SATA_PMP_GSCR_FEAT_EN],
+			     gscr[SATA_PMP_GSCR_FEAT]);
 
 		if (!(dev->flags & ATA_DFLAG_AN))
-			ata_dev_printk(dev, KERN_INFO,
+			ata_dev_info(dev,
 				"Asynchronous notification not supported, "
-				"hotplug won't\n         work on fan-out "
-				"ports. Use warm-plug instead.\n");
+				"hotplug won't work on fan-out ports. Use warm-plug instead.\n");
 	}
 
 	return 0;
 
  fail:
-	ata_dev_printk(dev, KERN_ERR,
-		       "failed to configure Port Multiplier (%s, Emask=0x%x)\n",
-		       reason, err_mask);
+	ata_dev_err(dev,
+		    "failed to configure Port Multiplier (%s, Emask=0x%x)\n",
+		    reason, err_mask);
 	return rc;
 }
 
@@ -485,20 +484,17 @@ int sata_pmp_attach(struct ata_device *dev)
 
 	/* is it hanging off the right place? */
 	if (!sata_pmp_supported(ap)) {
-		ata_dev_printk(dev, KERN_ERR,
-			       "host does not support Port Multiplier\n");
+		ata_dev_err(dev, "host does not support Port Multiplier\n");
 		return -EINVAL;
 	}
 
 	if (!ata_is_host_link(link)) {
-		ata_dev_printk(dev, KERN_ERR,
-			       "Port Multipliers cannot be nested\n");
+		ata_dev_err(dev, "Port Multipliers cannot be nested\n");
 		return -EINVAL;
 	}
 
 	if (dev->devno) {
-		ata_dev_printk(dev, KERN_ERR,
-			       "Port Multiplier must be the first device\n");
+		ata_dev_err(dev, "Port Multiplier must be the first device\n");
 		return -EINVAL;
 	}
 
@@ -517,8 +513,7 @@ int sata_pmp_attach(struct ata_device *dev)
 
 	rc = sata_pmp_init_links(ap, sata_pmp_gscr_ports(dev->gscr));
 	if (rc) {
-		ata_dev_printk(dev, KERN_INFO,
-			       "failed to initialize PMP links\n");
+		ata_dev_info(dev, "failed to initialize PMP links\n");
 		goto fail;
 	}
 
@@ -562,7 +557,7 @@ static void sata_pmp_detach(struct ata_device *dev)
 	struct ata_link *tlink;
 	unsigned long flags;
 
-	ata_dev_printk(dev, KERN_INFO, "Port Multiplier detaching\n");
+	ata_dev_info(dev, "Port Multiplier detaching\n");
 
 	WARN_ON(!ata_is_host_link(link) || dev->devno ||
 		link->pmp != SATA_PMP_CTRL_PORT);
@@ -609,23 +604,23 @@ static int sata_pmp_same_pmp(struct ata_device *dev, const u32 *new_gscr)
 	new_nr_ports = sata_pmp_gscr_ports(new_gscr);
 
 	if (old_vendor != new_vendor) {
-		ata_dev_printk(dev, KERN_INFO, "Port Multiplier "
-			       "vendor mismatch '0x%x' != '0x%x'\n",
-			       old_vendor, new_vendor);
+		ata_dev_info(dev,
+			     "Port Multiplier vendor mismatch '0x%x' != '0x%x'\n",
+			     old_vendor, new_vendor);
 		return 0;
 	}
 
 	if (old_devid != new_devid) {
-		ata_dev_printk(dev, KERN_INFO, "Port Multiplier "
-			       "device ID mismatch '0x%x' != '0x%x'\n",
-			       old_devid, new_devid);
+		ata_dev_info(dev,
+			     "Port Multiplier device ID mismatch '0x%x' != '0x%x'\n",
+			     old_devid, new_devid);
 		return 0;
 	}
 
 	if (old_nr_ports != new_nr_ports) {
-		ata_dev_printk(dev, KERN_INFO, "Port Multiplier "
-			       "nr_ports mismatch '0x%x' != '0x%x'\n",
-			       old_nr_ports, new_nr_ports);
+		ata_dev_info(dev,
+			     "Port Multiplier nr_ports mismatch '0x%x' != '0x%x'\n",
+			     old_nr_ports, new_nr_ports);
 		return 0;
 	}
 
@@ -691,8 +686,7 @@ static int sata_pmp_revalidate(struct ata_device *dev, unsigned int new_class)
 	return 0;
 
  fail:
-	ata_dev_printk(dev, KERN_ERR,
-		       "PMP revalidation failed (errno=%d)\n", rc);
+	ata_dev_err(dev, "PMP revalidation failed (errno=%d)\n", rc);
 	DPRINTK("EXIT, rc=%d\n", rc);
 	return rc;
 }
@@ -716,13 +710,14 @@ static int sata_pmp_revalidate_quick(struct ata_device *dev)
 
 	err_mask = sata_pmp_read(dev->link, SATA_PMP_GSCR_PROD_ID, &prod_id);
 	if (err_mask) {
-		ata_dev_printk(dev, KERN_ERR, "failed to read PMP product ID "
-			       "(Emask=0x%x)\n", err_mask);
+		ata_dev_err(dev,
+			    "failed to read PMP product ID (Emask=0x%x)\n",
+			    err_mask);
 		return -EIO;
 	}
 
 	if (prod_id != dev->gscr[SATA_PMP_GSCR_PROD_ID]) {
-		ata_dev_printk(dev, KERN_ERR, "PMP product ID mismatch\n");
+		ata_dev_err(dev, "PMP product ID mismatch\n");
 		/* something weird is going on, request full PMP recovery */
 		return -EIO;
 	}
@@ -777,8 +772,7 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 		rc = ata_eh_reset(link, 0, prereset, softreset, hardreset,
 				  postreset);
 		if (rc) {
-			ata_link_printk(link, KERN_ERR,
-					"failed to reset PMP, giving up\n");
+			ata_link_err(link, "failed to reset PMP, giving up\n");
 			goto fail;
 		}
 
@@ -819,9 +813,9 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 			ehc->i.action |= ATA_EH_RESET;
 			goto retry;
 		} else {
-			ata_dev_printk(dev, KERN_ERR, "failed to recover PMP "
-				       "after %d tries, giving up\n",
-				       ATA_EH_PMP_TRIES);
+			ata_dev_err(dev,
+				    "failed to recover PMP after %d tries, giving up\n",
+				    ATA_EH_PMP_TRIES);
 			goto fail;
 		}
 	}
@@ -867,8 +861,9 @@ static int sata_pmp_eh_handle_disabled_links(struct ata_port *ap)
 		/* unconditionally clear SError.N */
 		rc = sata_scr_write(link, SCR_ERROR, SERR_PHYRDY_CHG);
 		if (rc) {
-			ata_link_printk(link, KERN_ERR, "failed to clear "
-					"SError.N (errno=%d)\n", rc);
+			ata_link_err(link,
+				     "failed to clear SError.N (errno=%d)\n",
+				     rc);
 			return rc;
 		}
 
@@ -890,7 +885,7 @@ static int sata_pmp_handle_link_fail(struct ata_link *link, int *link_tries)
 
 	/* disable this link */
 	if (!(link->flags & ATA_LFLAG_DISABLED)) {
-		ata_link_printk(link, KERN_WARNING,
+		ata_link_warn(link,
 			"failed to recover link after %d tries, disabling\n",
 			ATA_EH_PMP_LINK_TRIES);
 
@@ -974,7 +969,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 		err_mask = sata_pmp_write(pmp_link, SATA_PMP_GSCR_FEAT_EN,
 					  gscr[SATA_PMP_GSCR_FEAT_EN]);
 		if (err_mask) {
-			ata_link_printk(pmp_link, KERN_WARNING,
+			ata_link_warn(pmp_link,
 				"failed to disable NOTIFY (err_mask=0x%x)\n",
 				err_mask);
 			goto pmp_fail;
@@ -1018,8 +1013,9 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 		err_mask = sata_pmp_write(pmp_link, SATA_PMP_GSCR_FEAT_EN,
 					  gscr[SATA_PMP_GSCR_FEAT_EN]);
 		if (err_mask) {
-			ata_dev_printk(pmp_dev, KERN_ERR, "failed to write "
-				       "PMP_FEAT_EN (Emask=0x%x)\n", err_mask);
+			ata_dev_err(pmp_dev,
+				    "failed to write PMP_FEAT_EN (Emask=0x%x)\n",
+				    err_mask);
 			rc = -EIO;
 			goto pmp_fail;
 		}
@@ -1028,8 +1024,9 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 	/* check GSCR_ERROR */
 	err_mask = sata_pmp_read(pmp_link, SATA_PMP_GSCR_ERROR, &gscr_error);
 	if (err_mask) {
-		ata_dev_printk(pmp_dev, KERN_ERR, "failed to read "
-			       "PMP_GSCR_ERROR (Emask=0x%x)\n", err_mask);
+		ata_dev_err(pmp_dev,
+			    "failed to read PMP_GSCR_ERROR (Emask=0x%x)\n",
+			    err_mask);
 		rc = -EIO;
 		goto pmp_fail;
 	}
@@ -1043,17 +1040,16 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 			ata_ehi_hotplugged(&link->eh_context.i);
 			cnt++;
 		} else {
-			ata_link_printk(link, KERN_WARNING,
-				"PHY status changed but maxed out on retries, "
-				"giving up\n");
-			ata_link_printk(link, KERN_WARNING,
-				"Manully issue scan to resume this link\n");
+			ata_link_warn(link,
+				"PHY status changed but maxed out on retries, giving up\n");
+			ata_link_warn(link,
+				"Manually issue scan to resume this link\n");
 		}
 	}
 
 	if (cnt) {
-		ata_port_printk(ap, KERN_INFO, "PMP SError.N set for some "
-				"ports, repeating recovery\n");
+		ata_port_info(ap,
+			"PMP SError.N set for some ports, repeating recovery\n");
 		goto retry;
 	}
 
@@ -1081,9 +1077,8 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 		goto retry;
 	}
 
-	ata_port_printk(ap, KERN_ERR,
-			"failed to recover PMP after %d tries, giving up\n",
-			ATA_EH_PMP_TRIES);
+	ata_port_err(ap, "failed to recover PMP after %d tries, giving up\n",
+		     ATA_EH_PMP_TRIES);
 	sata_pmp_detach(pmp_dev);
 	ata_dev_disable(pmp_dev);
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 927f968..46d087f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1108,8 +1108,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		/* configure draining */
 		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
 		if (!buf) {
-			ata_dev_printk(dev, KERN_ERR,
-				       "drain buffer allocation failed\n");
+			ata_dev_err(dev, "drain buffer allocation failed\n");
 			return -ENOMEM;
 		}
 
@@ -1127,7 +1126,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 	 * IDENTIFY_PACKET is executed as ATA_PROT_PIO.
 	 */
 	if (sdev->sector_size > PAGE_SIZE)
-		ata_dev_printk(dev, KERN_WARNING,
+		ata_dev_warn(dev,
 			"sector_size=%u > PAGE_SIZE, PIO may malfunction\n",
 			sdev->sector_size);
 
@@ -1784,8 +1783,7 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE ||
 	    cmd->sc_data_direction == DMA_TO_DEVICE) {
 		if (unlikely(scsi_bufflen(cmd) < 1)) {
-			ata_dev_printk(dev, KERN_WARNING,
-				       "WARNING: zero len r/w req\n");
+			ata_dev_warn(dev, "WARNING: zero len r/w req\n");
 			goto err_did;
 		}
 
@@ -2969,9 +2967,8 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 		 * with the cached multi_count of libata
 		 */
 		if (multi_count != dev->multi_count)
-			ata_dev_printk(dev, KERN_WARNING,
-				       "invalid multi_count %u ignored\n",
-				       multi_count);
+			ata_dev_warn(dev, "invalid multi_count %u ignored\n",
+				     multi_count);
 	}
 
 	/*
@@ -3466,9 +3463,8 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			goto repeat;
 		}
 
-		ata_port_printk(ap, KERN_ERR, "WARNING: synchronous SCSI scan "
-				"failed without making any progress,\n"
-				"                  switching to async\n");
+		ata_port_err(ap,
+			     "WARNING: synchronous SCSI scan failed without making any progress, switching to async\n");
 	}
 
 	queue_delayed_work(system_long_wq, &ap->hotplug_task,
@@ -3550,8 +3546,8 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
 	mutex_unlock(&ap->scsi_host->scan_mutex);
 
 	if (sdev) {
-		ata_dev_printk(dev, KERN_INFO, "detaching (SCSI %s)\n",
-			       dev_name(&sdev->sdev_gendev));
+		ata_dev_info(dev, "detaching (SCSI %s)\n",
+			     dev_name(&sdev->sdev_gendev));
 
 		scsi_remove_device(sdev);
 		scsi_device_put(sdev);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index b1b926c..c24127d 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -227,9 +227,9 @@ int ata_sff_busy_sleep(struct ata_port *ap,
 	}
 
 	if (status != 0xff && (status & ATA_BUSY))
-		ata_port_printk(ap, KERN_WARNING,
-				"port is slow to respond, please be patient "
-				"(Status 0x%x)\n", status);
+		ata_port_warn(ap,
+			      "port is slow to respond, please be patient (Status 0x%x)\n",
+			      status);
 
 	timeout = ata_deadline(timer_start, tmout);
 	while (status != 0xff && (status & ATA_BUSY) &&
@@ -242,9 +242,9 @@ int ata_sff_busy_sleep(struct ata_port *ap,
 		return -ENODEV;
 
 	if (status & ATA_BUSY) {
-		ata_port_printk(ap, KERN_ERR, "port failed to respond "
-				"(%lu secs, Status 0x%x)\n",
-				DIV_ROUND_UP(tmout, 1000), status);
+		ata_port_err(ap,
+			     "port failed to respond (%lu secs, Status 0x%x)\n",
+			     DIV_ROUND_UP(tmout, 1000), status);
 		return -EBUSY;
 	}
 
@@ -350,8 +350,8 @@ static void ata_dev_select(struct ata_port *ap, unsigned int device,
 			   unsigned int wait, unsigned int can_sleep)
 {
 	if (ata_msg_probe(ap))
-		ata_port_printk(ap, KERN_INFO, "ata_dev_select: ENTER, "
-				"device %u, wait %u\n", device, wait);
+		ata_port_info(ap, "ata_dev_select: ENTER, device %u, wait %u\n",
+			      device, wait);
 
 	if (wait)
 		ata_wait_idle(ap);
@@ -1333,9 +1333,10 @@ void ata_sff_flush_pio_task(struct ata_port *ap)
 
 	cancel_delayed_work_sync(&ap->sff_pio_task);
 	ap->hsm_task_state = HSM_ST_IDLE;
+	ap->sff_pio_task_link = NULL;
 
 	if (ata_msg_ctl(ap))
-		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __func__);
+		ata_port_dbg(ap, "%s: EXIT\n", __func__);
 }
 
 static void ata_sff_pio_task(struct work_struct *work)
@@ -1513,7 +1514,7 @@ static unsigned int ata_sff_idle_irq(struct ata_port *ap)
 		ap->ops->sff_check_status(ap);
 		if (ap->ops->sff_irq_clear)
 			ap->ops->sff_irq_clear(ap);
-		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
+		ata_port_warn(ap, "irq trap\n");
 		return 1;
 	}
 #endif
@@ -1711,7 +1712,7 @@ void ata_sff_lost_interrupt(struct ata_port *ap)
 
 	/* There was a command running, we are no longer busy and we have
 	   no interrupt. */
-	ata_port_printk(ap, KERN_WARNING, "lost interrupt (Status 0x%x)\n",
+	ata_port_warn(ap, "lost interrupt (Status 0x%x)\n",
 								status);
 	/* Run the host interrupt logic as if the interrupt had not been
 	   lost */
@@ -1798,8 +1799,9 @@ int ata_sff_prereset(struct ata_link *link, unsigned long deadline)
 	if (!ata_link_offline(link)) {
 		rc = ata_sff_wait_ready(link, deadline);
 		if (rc && rc != -ENODEV) {
-			ata_link_printk(link, KERN_WARNING, "device not ready "
-					"(errno=%d), forcing hardreset\n", rc);
+			ata_link_warn(link,
+				      "device not ready (errno=%d), forcing hardreset\n",
+				      rc);
 			ehc->i.action |= ATA_EH_HARDRESET;
 		}
 	}
@@ -2056,7 +2058,7 @@ int ata_sff_softreset(struct ata_link *link, unsigned int *classes,
 	rc = ata_bus_softreset(ap, devmask, deadline);
 	/* if link is occupied, -ENODEV too is an error */
 	if (rc && (rc != -ENODEV || sata_scr_valid(link))) {
-		ata_link_printk(link, KERN_ERR, "SRST failed (errno=%d)\n", rc);
+		ata_link_err(link, "SRST failed (errno=%d)\n", rc);
 		return rc;
 	}
 
@@ -2170,8 +2172,7 @@ void ata_sff_drain_fifo(struct ata_queued_cmd *qc)
 
 	/* Can become DEBUG later */
 	if (count)
-		ata_port_printk(ap, KERN_DEBUG,
-			"drained %d bytes to clear DRQ.\n", count);
+		ata_port_dbg(ap, "drained %d bytes to clear DRQ\n", count);
 
 }
 EXPORT_SYMBOL_GPL(ata_sff_drain_fifo);
@@ -2316,9 +2317,9 @@ int ata_pci_sff_init_host(struct ata_host *host)
 		rc = pcim_iomap_regions(pdev, 0x3 << base,
 					dev_driver_string(gdev));
 		if (rc) {
-			dev_printk(KERN_WARNING, gdev,
-				   "failed to request/iomap BARs for port %d "
-				   "(errno=%d)\n", i, rc);
+			dev_warn(gdev,
+				 "failed to request/iomap BARs for port %d (errno=%d)\n",
+				 i, rc);
 			if (rc == -EBUSY)
 				pcim_pin_device(pdev);
 			ap->ops = &ata_dummy_port_ops;
@@ -2340,7 +2341,7 @@ int ata_pci_sff_init_host(struct ata_host *host)
 	}
 
 	if (!mask) {
-		dev_printk(KERN_ERR, gdev, "no available native port\n");
+		dev_err(gdev, "no available native port\n");
 		return -ENODEV;
 	}
 
@@ -2375,8 +2376,7 @@ int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
 	if (!host) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "failed to allocate ATA host\n");
+		dev_err(&pdev->dev, "failed to allocate ATA host\n");
 		rc = -ENOMEM;
 		goto err_out;
 	}
@@ -2542,8 +2542,7 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 
 	pi = ata_sff_find_valid_pi(ppi);
 	if (!pi) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "no valid port_info specified\n");
+		dev_err(&pdev->dev, "no valid port_info specified\n");
 		return -EINVAL;
 	}
 
@@ -3164,8 +3163,7 @@ static void ata_bmdma_nodma(struct ata_host *host, const char *reason)
 {
 	int i;
 
-	dev_printk(KERN_ERR, host->dev, "BMDMA: %s, falling back to PIO\n",
-		   reason);
+	dev_err(host->dev, "BMDMA: %s, falling back to PIO\n", reason);
 
 	for (i = 0; i < 2; i++) {
 		host->ports[i]->mwdma_mask = 0;
@@ -3297,8 +3295,7 @@ int ata_pci_bmdma_init_one(struct pci_dev *pdev,
 
 	pi = ata_sff_find_valid_pi(ppi);
 	if (!pi) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "no valid port_info specified\n");
+		dev_err(&pdev->dev, "no valid port_info specified\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 91949d9..54145ed 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -195,8 +195,6 @@ static int pacpi_port_start(struct ata_port *ap)
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct pata_acpi *acpi;
 
-	int ret;
-
 	if (ap->acpi_handle == NULL)
 		return -ENODEV;
 
@@ -205,11 +203,7 @@ static int pacpi_port_start(struct ata_port *ap)
 		return -ENOMEM;
 	acpi->mask[0] = pacpi_discover_modes(ap, &ap->link.device[0]);
 	acpi->mask[1] = pacpi_discover_modes(ap, &ap->link.device[1]);
-	ret = ata_bmdma_port_start(ap);
-	if (ret < 0)
-		return ret;
-
-	return ret;
+	return ata_bmdma_port_start(ap);
 }
 
 static struct scsi_host_template pacpi_sht = {
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 794ec6e..cadd679 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -287,10 +287,10 @@ static void ali_warn_atapi_dma(struct ata_device *adev)
 	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
 
 	if (print_info && adev->class == ATA_DEV_ATAPI && !ali_atapi_dma) {
-		ata_dev_printk(adev, KERN_WARNING,
-			       "WARNING: ATAPI DMA disabled for reliability issues.  It can be enabled\n");
-		ata_dev_printk(adev, KERN_WARNING,
-			       "WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.\n");
+		ata_dev_warn(adev,
+			     "WARNING: ATAPI DMA disabled for reliability issues.  It can be enabled\n");
+		ata_dev_warn(adev,
+			     "WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.\n");
 	}
 }
 
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index b0975a5..dc6b5da 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -60,7 +60,7 @@ static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offse
 		UT = T / 2;
 
 	if (ata_timing_compute(adev, speed, &at, T, UT) < 0) {
-		dev_printk(KERN_ERR, &pdev->dev, "unknown mode %d.\n", speed);
+		dev_err(&pdev->dev, "unknown mode %d\n", speed);
 		return;
 	}
 
@@ -311,7 +311,7 @@ static unsigned long nv_mode_filter(struct ata_device *dev,
 	   cable detection result */
 	limit |= ata_pack_xfermask(ATA_PIO4, ATA_MWDMA2, ATA_UDMA2);
 
-	ata_port_printk(ap, KERN_DEBUG, "nv_mode_filter: 0x%lx&0x%lx->0x%lx, "
+	ata_port_dbg(ap, "nv_mode_filter: 0x%lx&0x%lx->0x%lx, "
 			"BIOS=0x%lx (0x%x) ACPI=0x%lx%s\n",
 			xfer_mask, limit, xfer_mask & limit, bios_limit,
 			saved_udma, acpi_limit, acpi_str);
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
index 9529593..3cfabb2 100644
--- a/drivers/ata/pata_atp867x.c
+++ b/drivers/ata/pata_atp867x.c
@@ -470,7 +470,7 @@ static int atp867x_ata_pci_sff_init_host(struct ata_host *host)
 	}
 
 	if (!mask) {
-		dev_printk(KERN_ERR, gdev, "no available native port\n");
+		dev_err(gdev, "no available native port\n");
 		return -ENODEV;
 	}
 
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
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -511,15 +509,14 @@ static int atp867x_init_one(struct pci_dev *pdev,
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, ATP867X_NUM_PORTS);
 	if (!host) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			"failed to allocate ATA host\n");
+		dev_err(&pdev->dev, "failed to allocate ATA host\n");
 		rc = -ENOMEM;
 		goto err_out;
 	}
 
 	rc = atp867x_ata_pci_sff_init_host(host);
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev, "failed to init host\n");
+		dev_err(&pdev->dev, "failed to init host\n");
 		goto err_out;
 	}
 
@@ -528,7 +525,7 @@ static int atp867x_init_one(struct pci_dev *pdev,
 	rc = ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				IRQF_SHARED, &atp867x_sht);
 	if (rc)
-		dev_printk(KERN_ERR, &pdev->dev, "failed to activate host\n");
+		dev_err(&pdev->dev, "failed to activate host\n");
 
 err_out:
 	return rc;
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index ea64967..bd987bb 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1129,7 +1129,7 @@ static int bfin_softreset(struct ata_link *link, unsigned int *classes,
 	/* issue bus reset */
 	err_mask = bfin_bus_softreset(ap, devmask);
 	if (err_mask) {
-		ata_port_printk(ap, KERN_ERR, "SRST failed (err_mask=0x%x)\n",
+		ata_port_err(ap, "SRST failed (err_mask=0x%x)\n",
 				err_mask);
 		return -EIO;
 	}
@@ -1382,7 +1382,7 @@ idle_irq:
 #ifdef ATA_IRQ_TRAP
 	if ((ap->stats.idle_irq % 1000) == 0) {
 		ap->ops->irq_ack(ap, 0); /* debug trap */
-		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
+		ata_port_warn(ap, "irq trap\n");
 		return 1;
 	}
 #endif
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index e3254fc..9ddcddc 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -149,8 +149,7 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
 		ppi[1] = &pi;
 
 	if ((pcicfg & 0x40) == 0) {
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "DMA mode disabled. Enabling.\n");
+		dev_warn(&pdev->dev, "DMA mode disabled. Enabling.\n");
 		pci_write_config_byte(pdev, 0x60, pcicfg | 0x40);
 	}
 
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
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 9f2889f..52e7e7b 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -210,8 +210,8 @@ static void pata_icside_set_dmamode(struct ata_port *ap, struct ata_device *adev
 	else
 		iomd_type = 'A', cycle = 562;
 
-	ata_dev_printk(adev, KERN_INFO, "timings: act %dns rec %dns cyc %dns (%c)\n",
-		t.active, t.recover, t.cycle, iomd_type);
+	ata_dev_info(adev, "timings: act %dns rec %dns cyc %dns (%c)\n",
+		     t.active, t.recover, t.cycle, iomd_type);
 
 	state->port[ap->port_no].speed[adev->devno] = cycle;
 }
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
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 2d15f25..62c5d00 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -473,12 +473,12 @@ static int it821x_smart_set_mode(struct ata_link *link, struct ata_device **unus
 		/* We do need the right mode information for DMA or PIO
 		   and this comes from the current configuration flags */
 		if (ata_id_has_dma(dev->id)) {
-			ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
+			ata_dev_info(dev, "configured for DMA\n");
 			dev->xfer_mode = XFER_MW_DMA_0;
 			dev->xfer_shift = ATA_SHIFT_MWDMA;
 			dev->flags &= ~ATA_DFLAG_PIO;
 		} else {
-			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+			ata_dev_info(dev, "configured for PIO\n");
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
 			dev->flags |= ATA_DFLAG_PIO;
@@ -508,12 +508,12 @@ static void it821x_dev_config(struct ata_device *adev)
 
 	if (strstr(model_num, "Integrated Technology Express")) {
 		/* RAID mode */
-		ata_dev_printk(adev, KERN_INFO, "%sRAID%d volume",
-			adev->id[147]?"Bootable ":"",
-			adev->id[129]);
+		ata_dev_info(adev, "%sRAID%d volume",
+			     adev->id[147] ? "Bootable " : "",
+			     adev->id[129]);
 		if (adev->id[129] != 1)
-			printk("(%dK stripe)", adev->id[146]);
-		printk(".\n");
+			pr_cont("(%dK stripe)", adev->id[146]);
+		pr_cont("\n");
 	}
 	/* This is a controller firmware triggered funny, don't
 	   report the drive faulty! */
@@ -610,7 +610,7 @@ static void it821x_display_disk(int n, u8 *buf)
 	char *cbl = "(40 wire cable)";
 
 	static const char *types[5] = {
-		"RAID0", "RAID1" "RAID 0+1", "JBOD", "DISK"
+		"RAID0", "RAID1", "RAID 0+1", "JBOD", "DISK"
 	};
 
 	if (buf[52] > 4)	/* No Disk */
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index f6b3f99..15b6431 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -31,7 +31,7 @@ static int ixp4xx_set_mode(struct ata_link *link, struct ata_device **error)
 	struct ata_device *dev;
 
 	ata_for_each_dev(dev, link, ENABLED) {
-		ata_dev_printk(dev, KERN_INFO, "configured for PIO0\n");
+		ata_dev_info(dev, "configured for PIO0\n");
 		dev->pio_mode = XFER_PIO_0;
 		dev->xfer_mode = XFER_PIO_0;
 		dev->xfer_shift = ATA_SHIFT_PIO;
@@ -181,7 +181,7 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 
 	ixp4xx_setup_port(ap, data, cs0->start, cs1->start);
 
-	dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* activate host */
 	return ata_host_activate(host, irq, ata_sff_interrupt, 0, &ixp4xx_sht);
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6bd9425..d960f8e 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -213,7 +213,7 @@ static int legacy_set_mode(struct ata_link *link, struct ata_device **unused)
 	struct ata_device *dev;
 
 	ata_for_each_dev(dev, link, ENABLED) {
-		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+		ata_dev_info(dev, "configured for PIO\n");
 		dev->pio_mode = XFER_PIO_0;
 		dev->xfer_mode = XFER_PIO_0;
 		dev->xfer_shift = ATA_SHIFT_PIO;
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 46f589e..b057e3f 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -772,8 +772,9 @@ static void pata_macio_reset_hw(struct pata_macio_priv *priv, int resume)
 		pci_restore_state(priv->pdev);
 		rc = pcim_enable_device(priv->pdev);
 		if (rc)
-			dev_printk(KERN_ERR, &priv->pdev->dev,
-				   "Failed to enable device after resume (%d)\n", rc);
+			dev_err(&priv->pdev->dev,
+				"Failed to enable device after resume (%d)\n",
+				rc);
 		else
 			pci_set_master(priv->pdev);
 	}
@@ -812,7 +813,7 @@ static int pata_macio_slave_config(struct scsi_device *sdev)
 		blk_queue_update_dma_pad(sdev->request_queue, 31);
 
 		/* Tell the world about it */
-		ata_dev_printk(dev, KERN_INFO, "OHare alignment limits applied\n");
+		ata_dev_info(dev, "OHare alignment limits applied\n");
 		return 0;
 	}
 
@@ -838,8 +839,7 @@ static int pata_macio_slave_config(struct scsi_device *sdev)
 				      cmd | PCI_COMMAND_INVALIDATE);
 
 		/* Tell the world about it */
-		ata_dev_printk(dev, KERN_INFO,
-			       "K2/Shasta alignment limits applied\n");
+		ata_dev_info(dev, "K2/Shasta alignment limits applied\n");
 	}
 
 	return 0;
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
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 2110863..31d5986 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -86,7 +86,7 @@ static void ns87410_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		idefr &= ~0x04;
 
 	if (ata_timing_compute(adev, adev->pio_mode, &at, 30303, 1) < 0) {
-		dev_printk(KERN_ERR, &pdev->dev, "unknown mode %d.\n", adev->pio_mode);
+		dev_err(&pdev->dev, "unknown mode %d\n", adev->pio_mode);
 		return;
 	}
 
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
index 220ddc9..1d61d5d 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -405,7 +405,7 @@ static int octeon_cf_softreset16(struct ata_link *link, unsigned int *classes,
 
 	rc = ata_sff_wait_after_reset(link, 1, deadline);
 	if (rc) {
-		ata_link_printk(link, KERN_ERR, "SRST failed (errno=%d)\n", rc);
+		ata_link_err(link, "SRST failed (errno=%d)\n", rc);
 		return rc;
 	}
 
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
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 021abe6..a808ba0 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -68,7 +68,7 @@ static int pcmcia_set_mode(struct ata_link *link, struct ata_device **r_failed_d
 		   the same vendor - check serial */
 		if (memcmp(master->id + ATA_ID_SERNO, slave->id + ATA_ID_SERNO,
 			   ATA_ID_SERNO_LEN) == 0 && master->id[ATA_ID_SERNO] >> 8) {
-			ata_dev_printk(slave, KERN_WARNING, "is a ghost device, ignoring.\n");
+			ata_dev_warn(slave, "is a ghost device, ignoring\n");
 			ata_dev_disable(slave);
 		}
 	}
@@ -142,8 +142,7 @@ static void pcmcia_8bit_drain_fifo(struct ata_queued_cmd *qc)
 		ioread8(ap->ioaddr.data_addr);
 
 	if (count)
-		ata_port_printk(ap, KERN_WARNING, "drained %d bytes to clear DRQ.\n",
-								count);
+		ata_port_warn(ap, "drained %d bytes to clear DRQ\n", count);
 
 }
 
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 9765ace..b1511f3 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -655,7 +655,7 @@ static int pdc_hardware_init(struct ata_host *host, unsigned int board_idx)
 	 */
 	pll_clock = pdc_detect_pll_input_clock(host);
 
-	dev_printk(KERN_INFO, host->dev, "PLL input clock %ld kHz\n", pll_clock/1000);
+	dev_info(host->dev, "PLL input clock %ld kHz\n", pll_clock/1000);
 
 	/* Adjust PLL control register */
 	pdc_adjust_pll(host, pll_clock, board_idx);
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
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 50400fa..2067308 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -39,7 +39,7 @@ static int pata_platform_set_mode(struct ata_link *link, struct ata_device **unu
 		dev->pio_mode = dev->xfer_mode = XFER_PIO_0;
 		dev->xfer_shift = ATA_SHIFT_PIO;
 		dev->flags |= ATA_DFLAG_PIO;
-		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+		ata_dev_info(dev, "configured for PIO\n");
 	}
 	return 0;
 }
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
index 4d04471..aca321e 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -44,7 +44,7 @@ static int rz1000_set_mode(struct ata_link *link, struct ata_device **unused)
 		dev->xfer_mode = XFER_PIO_0;
 		dev->xfer_shift = ATA_SHIFT_PIO;
 		dev->flags |= ATA_DFLAG_PIO;
-		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+		ata_dev_info(dev, "configured for PIO\n");
 	}
 	return 0;
 }
@@ -92,7 +92,7 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	printk_once(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	if (rz1000_fifo_disable(pdev) == 0)
 		return ata_pci_sff_init_one(pdev, ppi, &rz1000_sht, NULL, 0);
diff --git a/drivers/ata/pata_samsung_cf.c b/drivers/ata/pata_samsung_cf.c
index c446ae6..1b372c2 100644
--- a/drivers/ata/pata_samsung_cf.c
+++ b/drivers/ata/pata_samsung_cf.c
@@ -376,7 +376,7 @@ static int pata_s3c_softreset(struct ata_link *link, unsigned int *classes,
 	rc = pata_s3c_bus_softreset(ap, deadline);
 	/* if link is occupied, -ENODEV too is an error */
 	if (rc && rc != -ENODEV) {
-		ata_link_printk(link, KERN_ERR, "SRST failed (errno=%d)\n", rc);
+		ata_link_err(link, "SRST failed (errno=%d)\n", rc);
 		return rc;
 	}
 
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 88ea9b6..eb748e3 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -637,8 +637,7 @@ static int scc_softreset(struct ata_link *link, unsigned int *classes,
 	DPRINTK("about to softreset, devmask=%x\n", devmask);
 	err_mask = scc_bus_softreset(ap, devmask, deadline);
 	if (err_mask) {
-		ata_port_printk(ap, KERN_ERR, "SRST failed (err_mask=0x%x)\n",
-				err_mask);
+		ata_port_err(ap, "SRST failed (err_mask=0x%x)\n", err_mask);
 		return -EIO;
 	}
 
@@ -1072,15 +1071,12 @@ static int scc_host_init(struct ata_host *host)
 
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
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 7f5d020..c06ce8c 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -317,9 +317,11 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	rev = sl82c105_bridge_revision(dev);
 
 	if (rev == -1)
-		dev_printk(KERN_WARNING, &dev->dev, "pata_sl82c105: Unable to find bridge, disabling DMA.\n");
+		dev_warn(&dev->dev,
+			 "pata_sl82c105: Unable to find bridge, disabling DMA\n");
 	else if (rev <= 5)
-		dev_printk(KERN_WARNING, &dev->dev, "pata_sl82c105: Early bridge revision, no DMA available.\n");
+		dev_warn(&dev->dev,
+			 "pata_sl82c105: Early bridge revision, no DMA available\n");
 	else
 		ppi[0] = &info_dma;
 
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index b3e0c94..28da1c6 100644
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
index ac8d7d9..65e4be6 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -350,8 +350,8 @@ static unsigned long via_mode_filter(struct ata_device *dev, unsigned long mask)
 	if (config->id == PCI_DEVICE_ID_VIA_82C586_0) {
 		ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 		if (strcmp(model_num, "TS64GSSD25-M") == 0) {
-			ata_dev_printk(dev, KERN_WARNING,
-	"disabling UDMA mode due to reported lockups with this device.\n");
+			ata_dev_warn(dev,
+	"disabling UDMA mode due to reported lockups with this device\n");
 			mask &= ~ ATA_MASK_UDMA;
 		}
 	}
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
index 1111712..04911d5 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -596,14 +596,12 @@ static int adma_set_dma_masks(struct pci_dev *pdev, void __iomem *mmio_base)
 
 	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			"32-bit DMA enable failed\n");
+		dev_err(&pdev->dev, "32-bit DMA enable failed\n");
 		return rc;
 	}
 	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			"32-bit consistent DMA enable failed\n");
+		dev_err(&pdev->dev, "32-bit consistent DMA enable failed\n");
 		return rc;
 	}
 	return 0;
@@ -612,15 +610,13 @@ static int adma_set_dma_masks(struct pci_dev *pdev, void __iomem *mmio_base)
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
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index dc88a39..b02c4ff 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -766,11 +766,15 @@ static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
 static void dma_dwc_exit(struct sata_dwc_device *hsdev)
 {
 	dev_dbg(host_pvt.dwc_dev, "%s:\n", __func__);
-	if (host_pvt.sata_dma_regs)
+	if (host_pvt.sata_dma_regs) {
 		iounmap(host_pvt.sata_dma_regs);
+		host_pvt.sata_dma_regs = NULL;
+	}
 
-	if (hsdev->irq_dma)
+	if (hsdev->irq_dma) {
 		free_irq(hsdev->irq_dma, hsdev);
+		hsdev->irq_dma = 0;
+	}
 }
 
 /*
@@ -1642,7 +1646,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	if (hsdev == NULL) {
 		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
 		err = -ENOMEM;
-		goto error_out;
+		goto error;
 	}
 	memset(hsdev, 0, sizeof(*hsdev));
 
@@ -1652,7 +1656,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 		dev_err(&ofdev->dev, "ioremap failed for SATA register"
 			" address\n");
 		err = -ENODEV;
-		goto error_out;
+		goto error_kmalloc;
 	}
 	hsdev->reg_base = base;
 	dev_dbg(&ofdev->dev, "ioremap done for SATA register address\n");
@@ -1665,7 +1669,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	if (!host) {
 		dev_err(&ofdev->dev, "ata_host_alloc_pinfo failed\n");
 		err = -ENOMEM;
-		goto error_out;
+		goto error_iomap;
 	}
 
 	host->private_data = hsdev;
@@ -1733,8 +1737,11 @@ error_out:
 	/* Free SATA DMA resources */
 	dma_dwc_exit(hsdev);
 
-	if (base)
-		iounmap(base);
+error_iomap:
+	iounmap(base);
+error_kmalloc:
+	kfree(hsdev);
+error:
 	return err;
 }
 
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 35a71d8..78ae7b6 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -346,12 +346,11 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 
 		/* warn if each s/g element is not dword aligned */
 		if (sg_addr & 0x03)
-			ata_port_printk(qc->ap, KERN_ERR,
-					"s/g addr unaligned : 0x%llx\n",
-					(unsigned long long)sg_addr);
+			ata_port_err(qc->ap, "s/g addr unaligned : 0x%llx\n",
+				     (unsigned long long)sg_addr);
 		if (sg_len & 0x03)
-			ata_port_printk(qc->ap, KERN_ERR,
-					"s/g len unaligned : 0x%x\n", sg_len);
+			ata_port_err(qc->ap, "s/g len unaligned : 0x%x\n",
+				     sg_len);
 
 		if (num_prde == (SATA_FSL_MAX_PRD_DIRECT - 1) &&
 		    sg_next(sg) != NULL) {
@@ -661,8 +660,7 @@ static int sata_fsl_port_start(struct ata_port *ap)
 	sata_fsl_scr_write(&ap->link, SCR_CONTROL, temp);
 
 	sata_fsl_scr_read(&ap->link, SCR_CONTROL, &temp);
-	dev_printk(KERN_WARNING, dev, "scr_control, speed limited to %x\n",
-			temp);
+	dev_warn(dev, "scr_control, speed limited to %x\n", temp);
 #endif
 
 	return 0;
@@ -740,8 +738,7 @@ try_offline_again:
 				 1, 500);
 
 	if (temp & ONLINE) {
-		ata_port_printk(ap, KERN_ERR,
-				"Hardreset failed, not off-lined %d\n", i);
+		ata_port_err(ap, "Hardreset failed, not off-lined %d\n", i);
 
 		/*
 		 * Try to offline controller atleast twice
@@ -777,8 +774,7 @@ try_offline_again:
 	temp = ata_wait_register(ap, hcr_base + HSTATUS, ONLINE, 0, 1, 500);
 
 	if (!(temp & ONLINE)) {
-		ata_port_printk(ap, KERN_ERR,
-				"Hardreset failed, not on-lined\n");
+		ata_port_err(ap, "Hardreset failed, not on-lined\n");
 		goto err;
 	}
 
@@ -794,9 +790,8 @@ try_offline_again:
 
 	temp = ata_wait_register(ap, hcr_base + HSTATUS, 0xFF, 0, 1, 500);
 	if ((!(temp & 0x10)) || ata_link_offline(link)) {
-		ata_port_printk(ap, KERN_WARNING,
-				"No Device OR PHYRDY change,Hstatus = 0x%x\n",
-				ioread32(hcr_base + HSTATUS));
+		ata_port_warn(ap, "No Device OR PHYRDY change,Hstatus = 0x%x\n",
+			      ioread32(hcr_base + HSTATUS));
 		*class = ATA_DEV_NONE;
 		return 0;
 	}
@@ -809,13 +804,12 @@ try_offline_again:
 			500, jiffies_to_msecs(deadline - start_jiffies));
 
 	if ((temp & 0xFF) != 0x18) {
-		ata_port_printk(ap, KERN_WARNING, "No Signature Update\n");
+		ata_port_warn(ap, "No Signature Update\n");
 		*class = ATA_DEV_NONE;
 		goto do_followup_srst;
 	} else {
-		ata_port_printk(ap, KERN_INFO,
-				"Signature Update detected @ %d msecs\n",
-				jiffies_to_msecs(jiffies - start_jiffies));
+		ata_port_info(ap, "Signature Update detected @ %d msecs\n",
+			      jiffies_to_msecs(jiffies - start_jiffies));
 		*class = sata_fsl_dev_classify(ap);
 		return 0;
 	}
@@ -890,7 +884,7 @@ static int sata_fsl_softreset(struct ata_link *link, unsigned int *class,
 
 	temp = ata_wait_register(ap, CQ + hcr_base, 0x1, 0x1, 1, 5000);
 	if (temp & 0x1) {
-		ata_port_printk(ap, KERN_WARNING, "ATA_SRST issue failed\n");
+		ata_port_warn(ap, "ATA_SRST issue failed\n");
 
 		DPRINTK("Softreset@5000,CQ=0x%x,CA=0x%x,CC=0x%x\n",
 			ioread32(CQ + hcr_base),
@@ -1202,8 +1196,7 @@ static irqreturn_t sata_fsl_interrupt(int irq, void *dev_instance)
 	if (ap) {
 		sata_fsl_host_intr(ap);
 	} else {
-		dev_printk(KERN_WARNING, host->dev,
-			   "interrupt on disabled port 0\n");
+		dev_warn(host->dev, "interrupt on disabled port 0\n");
 	}
 
 	iowrite32(interrupt_enables, hcr_base + HSTATUS);
@@ -1317,8 +1310,7 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 	struct ata_port_info pi = sata_fsl_port_info[0];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 
-	dev_printk(KERN_INFO, &ofdev->dev,
-		   "Sata FSL Platform/CSB Driver init\n");
+	dev_info(&ofdev->dev, "Sata FSL Platform/CSB Driver init\n");
 
 	hcr_base = of_iomap(ofdev->dev.of_node, 0);
 	if (!hcr_base)
@@ -1347,7 +1339,7 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 
 	irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
 	if (irq < 0) {
-		dev_printk(KERN_ERR, &ofdev->dev, "invalid irq from platform\n");
+		dev_err(&ofdev->dev, "invalid irq from platform\n");
 		goto error_exit_with_cleanup;
 	}
 	host_priv->irq = irq;
@@ -1422,8 +1414,7 @@ static int sata_fsl_resume(struct platform_device *op)
 
 	ret = sata_fsl_init_controller(host);
 	if (ret) {
-		dev_printk(KERN_ERR, &op->dev,
-			"Error initialize hardware\n");
+		dev_err(&op->dev, "Error initializing hardware\n");
 		return ret;
 	}
 
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 83a4447..5c7d70c 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -396,9 +396,8 @@ static void inic_host_intr(struct ata_port *ap)
 	}
 
  spurious:
-	ata_port_printk(ap, KERN_WARNING, "unhandled interrupt: "
-			"cmd=0x%x irq_stat=0x%x idma_stat=0x%x\n",
-			qc ? qc->tf.command : 0xff, irq_stat, idma_stat);
+	ata_port_warn(ap, "unhandled interrupt: cmd=0x%x irq_stat=0x%x idma_stat=0x%x\n",
+		      qc ? qc->tf.command : 0xff, irq_stat, idma_stat);
 }
 
 static irqreturn_t inic_interrupt(int irq, void *dev_instance)
@@ -619,8 +618,9 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 
 	rc = sata_link_resume(link, timing, deadline);
 	if (rc) {
-		ata_link_printk(link, KERN_WARNING, "failed to resume "
-				"link after reset (errno=%d)\n", rc);
+		ata_link_warn(link,
+			      "failed to resume link after reset (errno=%d)\n",
+			      rc);
 		return rc;
 	}
 
@@ -632,8 +632,9 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 		rc = ata_wait_after_reset(link, deadline, inic_check_ready);
 		/* link occupied, -ENODEV too is an error */
 		if (rc) {
-			ata_link_printk(link, KERN_WARNING, "device not ready "
-					"after hardreset (errno=%d)\n", rc);
+			ata_link_warn(link,
+				      "device not ready after hardreset (errno=%d)\n",
+				      rc);
 			return rc;
 		}
 
@@ -799,7 +800,6 @@ static int inic_pci_device_resume(struct pci_dev *pdev)
 
 static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	const struct ata_port_info *ppi[] = { &inic_port_info, NULL };
 	struct ata_host *host;
 	struct inic_host_priv *hpriv;
@@ -807,8 +807,7 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int mmio_bar;
 	int i, rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* alloc host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, NR_PORTS);
@@ -847,15 +846,13 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Set dma_mask.  This devices doesn't support 64bit addressing. */
 	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "32-bit DMA enable failed\n");
+		dev_err(&pdev->dev, "32-bit DMA enable failed\n");
 		return rc;
 	}
 
 	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "32-bit consistent DMA enable failed\n");
+		dev_err(&pdev->dev, "32-bit consistent DMA enable failed\n");
 		return rc;
 	}
 
@@ -866,15 +863,13 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	rc = pci_set_dma_max_seg_size(pdev, 65536 - 512);
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "failed to set the maximum segment size.\n");
+		dev_err(&pdev->dev, "failed to set the maximum segment size\n");
 		return rc;
 	}
 
 	rc = init_controller(hpriv->mmio_base, hpriv->cached_hctl);
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "failed to initialize controller\n");
+		dev_err(&pdev->dev, "failed to initialize controller\n");
 		return rc;
 	}
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index b52c051..4b6b209 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1190,7 +1190,7 @@ static void mv_wait_for_edma_empty_idle(struct ata_port *ap)
 			break;
 		udelay(per_loop);
 	}
-	/* ata_port_printk(ap, KERN_INFO, "%s: %u+ usecs\n", __func__, i); */
+	/* ata_port_info(ap, "%s: %u+ usecs\n", __func__, i); */
 }
 
 /**
@@ -1228,7 +1228,7 @@ static int mv_stop_edma(struct ata_port *ap)
 	pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
 	mv_wait_for_edma_empty_idle(ap);
 	if (mv_stop_edma_engine(port_mmio)) {
-		ata_port_printk(ap, KERN_ERR, "Unable to stop eDMA\n");
+		ata_port_err(ap, "Unable to stop eDMA\n");
 		err = -EIO;
 	}
 	mv_edma_cfg(ap, 0, 0);
@@ -1382,7 +1382,7 @@ static void mv6_dev_config(struct ata_device *adev)
 	if (adev->flags & ATA_DFLAG_NCQ) {
 		if (sata_pmp_attached(adev->link->ap)) {
 			adev->flags &= ~ATA_DFLAG_NCQ;
-			ata_dev_printk(adev, KERN_INFO,
+			ata_dev_info(adev,
 				"NCQ disabled for command-based switching\n");
 		}
 	}
@@ -2225,9 +2225,8 @@ static unsigned int mv_send_fis(struct ata_port *ap, u32 *fis, int nwords)
 
 	/* See if it worked */
 	if ((ifstat & 0x3000) != 0x1000) {
-		ata_port_printk(ap, KERN_WARNING,
-				"%s transmission error, ifstat=%08x\n",
-				__func__, ifstat);
+		ata_port_warn(ap, "%s transmission error, ifstat=%08x\n",
+			      __func__, ifstat);
 		return AC_ERR_OTHER;
 	}
 	return 0;
@@ -2342,9 +2341,9 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 		 */
 		if (limit_warnings > 0 && (qc->nbytes / qc->sect_size) > 1) {
 			--limit_warnings;
-			ata_link_printk(qc->dev->link, KERN_WARNING, DRV_NAME
-					": attempting PIO w/multiple DRQ: "
-					"this may fail due to h/w errata\n");
+			ata_link_warn(qc->dev->link, DRV_NAME
+				      ": attempting PIO w/multiple DRQ: "
+				      "this may fail due to h/w errata\n");
 		}
 		/* drop through */
 	case ATA_PROT_NODATA:
@@ -2499,20 +2498,20 @@ static int mv_handle_fbs_ncq_dev_err(struct ata_port *ap)
 	}
 	failed_links = hweight16(new_map);
 
-	ata_port_printk(ap, KERN_INFO, "%s: pmp_map=%04x qc_map=%04x "
-			"failed_links=%d nr_active_links=%d\n",
-			__func__, pp->delayed_eh_pmp_map,
-			ap->qc_active, failed_links,
-			ap->nr_active_links);
+	ata_port_info(ap,
+		      "%s: pmp_map=%04x qc_map=%04x failed_links=%d nr_active_links=%d\n",
+		      __func__, pp->delayed_eh_pmp_map,
+		      ap->qc_active, failed_links,
+		      ap->nr_active_links);
 
 	if (ap->nr_active_links <= failed_links && mv_req_q_empty(ap)) {
 		mv_process_crpb_entries(ap, pp);
 		mv_stop_edma(ap);
 		mv_eh_freeze(ap);
-		ata_port_printk(ap, KERN_INFO, "%s: done\n", __func__);
+		ata_port_info(ap, "%s: done\n", __func__);
 		return 1;	/* handled */
 	}
-	ata_port_printk(ap, KERN_INFO, "%s: waiting\n", __func__);
+	ata_port_info(ap, "%s: waiting\n", __func__);
 	return 1;	/* handled */
 }
 
@@ -2554,9 +2553,8 @@ static int mv_handle_dev_err(struct ata_port *ap, u32 edma_err_cause)
 		 * and we cannot handle it here.
 		 */
 		if (edma_err_cause & EDMA_ERR_SELF_DIS) {
-			ata_port_printk(ap, KERN_WARNING,
-				"%s: err_cause=0x%x pp_flags=0x%x\n",
-				__func__, edma_err_cause, pp->pp_flags);
+			ata_port_warn(ap, "%s: err_cause=0x%x pp_flags=0x%x\n",
+				      __func__, edma_err_cause, pp->pp_flags);
 			return 0; /* not handled */
 		}
 		return mv_handle_fbs_ncq_dev_err(ap);
@@ -2567,9 +2565,8 @@ static int mv_handle_dev_err(struct ata_port *ap, u32 edma_err_cause)
 		 * and we cannot handle it here.
 		 */
 		if (!(edma_err_cause & EDMA_ERR_SELF_DIS)) {
-			ata_port_printk(ap, KERN_WARNING,
-				"%s: err_cause=0x%x pp_flags=0x%x\n",
-				__func__, edma_err_cause, pp->pp_flags);
+			ata_port_warn(ap, "%s: err_cause=0x%x pp_flags=0x%x\n",
+				      __func__, edma_err_cause, pp->pp_flags);
 			return 0; /* not handled */
 		}
 		return mv_handle_fbs_non_ncq_dev_err(ap);
@@ -2930,8 +2927,7 @@ static int mv_pci_error(struct ata_host *host, void __iomem *mmio)
 
 	err_cause = readl(mmio + hpriv->irq_cause_offset);
 
-	dev_printk(KERN_ERR, host->dev, "PCI ERROR; PCI IRQ cause=0x%08x\n",
-		   err_cause);
+	dev_err(host->dev, "PCI ERROR; PCI IRQ cause=0x%08x\n", err_cause);
 
 	DPRINTK("All regs @ PCI error\n");
 	mv_dump_all_regs(mmio, -1, to_pci_dev(host->dev));
@@ -3760,8 +3756,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 			hp_flags |= MV_HP_ERRATA_50XXB2;
 			break;
 		default:
-			dev_printk(KERN_WARNING, &pdev->dev,
-			   "Applying 50XXB2 workarounds to unknown rev\n");
+			dev_warn(&pdev->dev,
+				 "Applying 50XXB2 workarounds to unknown rev\n");
 			hp_flags |= MV_HP_ERRATA_50XXB2;
 			break;
 		}
@@ -3780,8 +3776,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 			hp_flags |= MV_HP_ERRATA_50XXB2;
 			break;
 		default:
-			dev_printk(KERN_WARNING, &pdev->dev,
-			   "Applying B2 workarounds to unknown rev\n");
+			dev_warn(&pdev->dev,
+				 "Applying B2 workarounds to unknown rev\n");
 			hp_flags |= MV_HP_ERRATA_50XXB2;
 			break;
 		}
@@ -3801,8 +3797,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 			hp_flags |= MV_HP_ERRATA_60X1C0;
 			break;
 		default:
-			dev_printk(KERN_WARNING, &pdev->dev,
-				   "Applying B2 workarounds to unknown rev\n");
+			dev_warn(&pdev->dev,
+				 "Applying B2 workarounds to unknown rev\n");
 			hp_flags |= MV_HP_ERRATA_60X1B2;
 			break;
 		}
@@ -3851,8 +3847,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 			hp_flags |= MV_HP_ERRATA_60X1C0;
 			break;
 		default:
-			dev_printk(KERN_WARNING, &pdev->dev,
-			   "Applying 60X1C0 workarounds to unknown rev\n");
+			dev_warn(&pdev->dev,
+				 "Applying 60X1C0 workarounds to unknown rev\n");
 			hp_flags |= MV_HP_ERRATA_60X1C0;
 			break;
 		}
@@ -3867,8 +3863,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 		break;
 
 	default:
-		dev_printk(KERN_ERR, host->dev,
-			   "BUG: invalid board index %u\n", board_idx);
+		dev_err(host->dev, "BUG: invalid board index %u\n", board_idx);
 		return 1;
 	}
 
@@ -4023,7 +4018,6 @@ static void mv_conf_mbus_windows(struct mv_host_priv *hpriv,
  */
 static int mv_platform_probe(struct platform_device *pdev)
 {
-	static int printed_version;
 	const struct mv_sata_platform_data *mv_platform_data;
 	const struct ata_port_info *ppi[] =
 	    { &mv_port_info[chip_soc], NULL };
@@ -4032,8 +4026,7 @@ static int mv_platform_probe(struct platform_device *pdev)
 	struct resource *res;
 	int n_ports, rc;
 
-	if (!printed_version++)
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/*
 	 * Simple resource validation ..
@@ -4091,9 +4084,8 @@ static int mv_platform_probe(struct platform_device *pdev)
 	if (rc)
 		goto err;
 
-	dev_printk(KERN_INFO, &pdev->dev,
-		   "slots %u ports %d\n", (unsigned)MV_MAX_Q_DEPTH,
-		   host->n_ports);
+	dev_info(&pdev->dev, "slots %u ports %d\n",
+		 (unsigned)MV_MAX_Q_DEPTH, host->n_ports);
 
 	return ata_host_activate(host, platform_get_irq(pdev, 0), mv_interrupt,
 				 IRQF_SHARED, &mv6_sht);
@@ -4217,22 +4209,21 @@ static int pci_go_64(struct pci_dev *pdev)
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
-				dev_printk(KERN_ERR, &pdev->dev,
-					   "64-bit DMA enable failed\n");
+				dev_err(&pdev->dev,
+					"64-bit DMA enable failed\n");
 				return rc;
 			}
 		}
 	} else {
 		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit DMA enable failed\n");
+			dev_err(&pdev->dev, "32-bit DMA enable failed\n");
 			return rc;
 		}
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit consistent DMA enable failed\n");
+			dev_err(&pdev->dev,
+				"32-bit consistent DMA enable failed\n");
 			return rc;
 		}
 	}
@@ -4276,10 +4267,9 @@ static void mv_print_info(struct ata_host *host)
 	else
 		gen = "?";
 
-	dev_printk(KERN_INFO, &pdev->dev,
-	       "Gen-%s %u slots %u ports %s mode IRQ via %s\n",
-	       gen, (unsigned)MV_MAX_Q_DEPTH, host->n_ports,
-	       scc_s, (MV_HP_FLAG_MSI & hpriv->hp_flags) ? "MSI" : "INTx");
+	dev_info(&pdev->dev, "Gen-%s %u slots %u ports %s mode IRQ via %s\n",
+		 gen, (unsigned)MV_MAX_Q_DEPTH, host->n_ports,
+		 scc_s, (MV_HP_FLAG_MSI & hpriv->hp_flags) ? "MSI" : "INTx");
 }
 
 /**
@@ -4293,15 +4283,13 @@ static void mv_print_info(struct ata_host *host)
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
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* allocate host */
 	n_ports = mv_get_hc_count(ppi[0]->flags) * MV_PORTS_PER_HC;
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index f173ef3..e0bc964 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -620,9 +620,8 @@ static void nv_adma_register_mode(struct ata_port *ap)
 		count++;
 	}
 	if (count == 20)
-		ata_port_printk(ap, KERN_WARNING,
-			"timeout waiting for ADMA IDLE, stat=0x%hx\n",
-			status);
+		ata_port_warn(ap, "timeout waiting for ADMA IDLE, stat=0x%hx\n",
+			      status);
 
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp & ~NV_ADMA_CTL_GO, mmio + NV_ADMA_CTL);
@@ -635,9 +634,9 @@ static void nv_adma_register_mode(struct ata_port *ap)
 		count++;
 	}
 	if (count == 20)
-		ata_port_printk(ap, KERN_WARNING,
-			 "timeout waiting for ADMA LEGACY, stat=0x%hx\n",
-			 status);
+		ata_port_warn(ap,
+			      "timeout waiting for ADMA LEGACY, stat=0x%hx\n",
+			      status);
 
 	pp->flags |= NV_ADMA_PORT_REGISTER_MODE;
 }
@@ -665,7 +664,7 @@ static void nv_adma_mode(struct ata_port *ap)
 		count++;
 	}
 	if (count == 20)
-		ata_port_printk(ap, KERN_WARNING,
+		ata_port_warn(ap,
 			"timeout waiting for ADMA LEGACY clear and IDLE, stat=0x%hx\n",
 			status);
 
@@ -772,10 +771,10 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 
 	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
 	blk_queue_max_segments(sdev->request_queue, sg_tablesize);
-	ata_port_printk(ap, KERN_INFO,
-		"DMA mask 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
-		(unsigned long long)*ap->host->dev->dma_mask,
-		segment_boundary, sg_tablesize);
+	ata_port_info(ap,
+		      "DMA mask 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
+		      (unsigned long long)*ap->host->dev->dma_mask,
+		      segment_boundary, sg_tablesize);
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
@@ -1443,8 +1442,7 @@ static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc)
 	   existing commands. */
 	if (unlikely(qc->tf.protocol == ATA_PROT_NCQ &&
 		     (qc->flags & ATA_QCFLAG_RESULT_TF))) {
-		ata_dev_printk(qc->dev, KERN_ERR,
-			"NCQ w/ RESULT_TF not allowed\n");
+		ata_dev_err(qc->dev, "NCQ w/ RESULT_TF not allowed\n");
 		return AC_ERR_SYSTEM;
 	}
 
@@ -1581,15 +1579,15 @@ static int nv_hardreset(struct ata_link *link, unsigned int *class,
 		int rc;
 
 		if (!(ehc->i.flags & ATA_EHI_QUIET))
-			ata_link_printk(link, KERN_INFO, "nv: skipping "
-					"hardreset on occupied port\n");
+			ata_link_info(link,
+				      "nv: skipping hardreset on occupied port\n");
 
 		/* make sure the link is online */
 		rc = sata_link_resume(link, timing, deadline);
 		/* whine about phy resume failure but proceed */
 		if (rc && rc != -EOPNOTSUPP)
-			ata_link_printk(link, KERN_WARNING, "failed to resume "
-					"link (errno=%d)\n", rc);
+			ata_link_warn(link, "failed to resume link (errno=%d)\n",
+				      rc);
 	}
 
 	/* device signature acquisition is unreliable */
@@ -1686,7 +1684,7 @@ static void nv_adma_error_handler(struct ata_port *ap)
 			u8 cpb_count = readb(mmio + NV_ADMA_CPB_COUNT);
 			u8 next_cpb_idx = readb(mmio + NV_ADMA_NEXT_CPB_IDX);
 
-			ata_port_printk(ap, KERN_ERR,
+			ata_port_err(ap,
 				"EH in ADMA mode, notifier 0x%X "
 				"notifier_error 0x%X gen_ctl 0x%X status 0x%X "
 				"next cpb count 0x%X next cpb idx 0x%x\n",
@@ -1697,7 +1695,7 @@ static void nv_adma_error_handler(struct ata_port *ap)
 				struct nv_adma_cpb *cpb = &pp->cpb[i];
 				if ((ata_tag_valid(ap->link.active_tag) && i == ap->link.active_tag) ||
 				    ap->link.sactive & (1 << i))
-					ata_port_printk(ap, KERN_ERR,
+					ata_port_err(ap,
 						"CPB %d: ctl_flags 0x%x, resp_flags 0x%x\n",
 						i, cpb->ctl_flags, cpb->resp_flags);
 			}
@@ -1799,23 +1797,22 @@ static void nv_swncq_ncq_stop(struct ata_port *ap)
 	u32 sactive;
 	u32 done_mask;
 
-	ata_port_printk(ap, KERN_ERR,
-			"EH in SWNCQ mode,QC:qc_active 0x%X sactive 0x%X\n",
-			ap->qc_active, ap->link.sactive);
-	ata_port_printk(ap, KERN_ERR,
+	ata_port_err(ap, "EH in SWNCQ mode,QC:qc_active 0x%X sactive 0x%X\n",
+		     ap->qc_active, ap->link.sactive);
+	ata_port_err(ap,
 		"SWNCQ:qc_active 0x%X defer_bits 0x%X last_issue_tag 0x%x\n  "
 		"dhfis 0x%X dmafis 0x%X sdbfis 0x%X\n",
 		pp->qc_active, pp->defer_queue.defer_bits, pp->last_issue_tag,
 		pp->dhfis_bits, pp->dmafis_bits, pp->sdbfis_bits);
 
-	ata_port_printk(ap, KERN_ERR, "ATA_REG 0x%X ERR_REG 0x%X\n",
-			ap->ops->sff_check_status(ap),
-			ioread8(ap->ioaddr.error_addr));
+	ata_port_err(ap, "ATA_REG 0x%X ERR_REG 0x%X\n",
+		     ap->ops->sff_check_status(ap),
+		     ioread8(ap->ioaddr.error_addr));
 
 	sactive = readl(pp->sactive_block);
 	done_mask = pp->qc_active ^ sactive;
 
-	ata_port_printk(ap, KERN_ERR, "tag : dhfis dmafis sdbfis sacitve\n");
+	ata_port_err(ap, "tag : dhfis dmafis sdbfis sactive\n");
 	for (i = 0; i < ATA_MAX_QUEUE; i++) {
 		u8 err = 0;
 		if (pp->qc_active & (1 << i))
@@ -1825,13 +1822,13 @@ static void nv_swncq_ncq_stop(struct ata_port *ap)
 		else
 			continue;
 
-		ata_port_printk(ap, KERN_ERR,
-				"tag 0x%x: %01x %01x %01x %01x %s\n", i,
-				(pp->dhfis_bits >> i) & 0x1,
-				(pp->dmafis_bits >> i) & 0x1,
-				(pp->sdbfis_bits >> i) & 0x1,
-				(sactive >> i) & 0x1,
-				(err ? "error! tag doesn't exit" : " "));
+		ata_port_err(ap,
+			     "tag 0x%x: %01x %01x %01x %01x %s\n", i,
+			     (pp->dhfis_bits >> i) & 0x1,
+			     (pp->dmafis_bits >> i) & 0x1,
+			     (pp->sdbfis_bits >> i) & 0x1,
+			     (sactive >> i) & 0x1,
+			     (err ? "error! tag doesn't exit" : " "));
 	}
 
 	nv_swncq_pp_reinit(ap);
@@ -1956,8 +1953,8 @@ static int nv_swncq_slave_config(struct scsi_device *sdev)
 
 	if (strncmp(model_num, "Maxtor", 6) == 0) {
 		ata_scsi_change_queue_depth(sdev, 1, SCSI_QDEPTH_DEFAULT);
-		ata_dev_printk(dev, KERN_NOTICE,
-			"Disabling SWNCQ mode (depth %x)\n", sdev->queue_depth);
+		ata_dev_notice(dev, "Disabling SWNCQ mode (depth %x)\n",
+			       sdev->queue_depth);
 	}
 
 	return rc;
@@ -2356,7 +2353,6 @@ static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance)
 
 static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 	struct nv_pi_priv *ipriv;
 	struct ata_host *host;
@@ -2373,8 +2369,7 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (pci_resource_start(pdev, bar) == 0)
 			return -ENODEV;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -2382,10 +2377,10 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* determine type and allocate host */
 	if (type == CK804 && adma_enabled) {
-		dev_printk(KERN_NOTICE, &pdev->dev, "Using ADMA mode\n");
+		dev_notice(&pdev->dev, "Using ADMA mode\n");
 		type = ADMA;
 	} else if (type == MCP5x && swncq_enabled) {
-		dev_printk(KERN_NOTICE, &pdev->dev, "Using SWNCQ mode\n");
+		dev_notice(&pdev->dev, "Using SWNCQ mode\n");
 		type = SWNCQ;
 	}
 
@@ -2429,7 +2424,7 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		nv_swncq_host_init(host);
 
 	if (msi_enabled) {
-		dev_printk(KERN_NOTICE, &pdev->dev, "Using MSI\n");
+		dev_notice(&pdev->dev, "Using MSI\n");
 		pci_enable_msi(pdev);
 	}
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index a004b1e..000fcc9 100644
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
@@ -1217,7 +1215,7 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host) {
-		dev_printk(KERN_ERR, &pdev->dev, "failed to allocate host\n");
+		dev_err(&pdev->dev, "failed to allocate host\n");
 		return -ENOMEM;
 	}
 	host->iomap = pcim_iomap_table(pdev);
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index c560326..9d1a47b 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -563,21 +563,20 @@ static int qs_set_dma_masks(struct pci_dev *pdev, void __iomem *mmio_base)
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
-				dev_printk(KERN_ERR, &pdev->dev,
-					   "64-bit DMA enable failed\n");
+				dev_err(&pdev->dev,
+					"64-bit DMA enable failed\n");
 				return rc;
 			}
 		}
 	} else {
 		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				"32-bit DMA enable failed\n");
+			dev_err(&pdev->dev, "32-bit DMA enable failed\n");
 			return rc;
 		}
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
+			dev_err(&pdev->dev,
 				"32-bit consistent DMA enable failed\n");
 			return rc;
 		}
@@ -588,14 +587,12 @@ static int qs_set_dma_masks(struct pci_dev *pdev, void __iomem *mmio_base)
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
index b42edaa..98c1d78 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -643,8 +643,8 @@ static void sil_dev_config(struct ata_device *dev)
 	    ((ap->flags & SIL_FLAG_MOD15WRITE) &&
 	     (quirks & SIL_QUIRK_MOD15WRITE))) {
 		if (print_info)
-			ata_dev_printk(dev, KERN_INFO, "applying Seagate "
-				       "errata fix (mod15write workaround)\n");
+			ata_dev_info(dev,
+		"applying Seagate errata fix (mod15write workaround)\n");
 		dev->max_sectors = 15;
 		return;
 	}
@@ -652,8 +652,8 @@ static void sil_dev_config(struct ata_device *dev)
 	/* limit to udma5 */
 	if (quirks & SIL_QUIRK_UDMA5MAX) {
 		if (print_info)
-			ata_dev_printk(dev, KERN_INFO, "applying Maxtor "
-				       "errata fix %s\n", model_num);
+			ata_dev_info(dev, "applying Maxtor errata fix %s\n",
+				     model_num);
 		dev->udma_mask &= ATA_UDMA5;
 		return;
 	}
@@ -676,8 +676,8 @@ static void sil_init_controller(struct ata_host *host)
 			writew(cls << 8 | cls,
 			       mmio_base + sil_port[i].fifo_cfg);
 	} else
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "cache line size not set.  Driver may not function\n");
+		dev_warn(&pdev->dev,
+			 "cache line size not set.  Driver may not function\n");
 
 	/* Apply R_ERR on DMA activate FIS errata workaround */
 	if (host->ports[0]->flags & SIL_FLAG_RERR_ON_DMA_ACT) {
@@ -688,9 +688,8 @@ static void sil_init_controller(struct ata_host *host)
 			if ((tmp & 0x3) != 0x01)
 				continue;
 			if (!cnt)
-				dev_printk(KERN_INFO, &pdev->dev,
-					   "Applying R_ERR on DMA activate "
-					   "FIS errata fix\n");
+				dev_info(&pdev->dev,
+					 "Applying R_ERR on DMA activate FIS errata fix\n");
 			writel(tmp & ~0x3, mmio_base + sil_port[i].sfis_cfg);
 			cnt++;
 		}
@@ -733,7 +732,6 @@ static bool sil_broken_system_poweroff(struct pci_dev *pdev)
 
 static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	int board_id = ent->driver_data;
 	struct ata_port_info pi = sil_port_info[board_id];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
@@ -742,8 +740,7 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int n_ports, rc;
 	unsigned int i;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* allocate host */
 	n_ports = 2;
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 06c564e..55470f3 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -694,7 +694,7 @@ static int sil24_softreset(struct ata_link *link, unsigned int *class,
 	return 0;
 
  err:
-	ata_link_printk(link, KERN_ERR, "softreset failed (%s)\n", reason);
+	ata_link_err(link, "softreset failed (%s)\n", reason);
 	return -EIO;
 }
 
@@ -714,8 +714,8 @@ static int sil24_hardreset(struct ata_link *link, unsigned int *class,
 	 * This happens often after PM DMA CS errata.
 	 */
 	if (pp->do_port_rst) {
-		ata_port_printk(ap, KERN_WARNING, "controller in dubious "
-				"state, performing PORT_RST\n");
+		ata_port_warn(ap,
+			      "controller in dubious state, performing PORT_RST\n");
 
 		writel(PORT_CS_PORT_RST, port + PORT_CTRL_STAT);
 		ata_msleep(ap, 10);
@@ -773,7 +773,7 @@ static int sil24_hardreset(struct ata_link *link, unsigned int *class,
 		goto retry;
 	}
 
-	ata_link_printk(link, KERN_ERR, "hardreset failed (%s)\n", reason);
+	ata_link_err(link, "hardreset failed (%s)\n", reason);
 	return -EIO;
 }
 
@@ -925,7 +925,7 @@ static void sil24_pmp_attach(struct ata_port *ap)
 
 	if (sata_pmp_gscr_vendor(gscr) == 0x11ab &&
 	    sata_pmp_gscr_devid(gscr) == 0x4140) {
-		ata_port_printk(ap, KERN_INFO,
+		ata_port_info(ap,
 			"disabling NCQ support due to sil24-mv4140 quirk\n");
 		ap->flags &= ~ATA_FLAG_NCQ;
 	}
@@ -946,8 +946,7 @@ static int sil24_pmp_hardreset(struct ata_link *link, unsigned int *class,
 
 	rc = sil24_init_port(link->ap);
 	if (rc) {
-		ata_link_printk(link, KERN_ERR,
-				"hardreset failed (port not ready)\n");
+		ata_link_err(link, "hardreset failed (port not ready)\n");
 		return rc;
 	}
 
@@ -1141,8 +1140,8 @@ static inline void sil24_host_intr(struct ata_port *ap)
 
 	/* spurious interrupts are expected if PCIX_IRQ_WOC */
 	if (!(ap->flags & SIL24_FLAG_PCIX_IRQ_WOC) && ata_ratelimit())
-		ata_port_printk(ap, KERN_INFO, "spurious interrupt "
-			"(slot_stat 0x%x active_tag %d sactive 0x%x)\n",
+		ata_port_info(ap,
+			"spurious interrupt (slot_stat 0x%x active_tag %d sactive 0x%x)\n",
 			slot_stat, ap->link.active_tag, ap->link.sactive);
 }
 
@@ -1256,8 +1255,8 @@ static void sil24_init_controller(struct ata_host *host)
 						PORT_CS_PORT_RST,
 						PORT_CS_PORT_RST, 10, 100);
 			if (tmp & PORT_CS_PORT_RST)
-				dev_printk(KERN_ERR, host->dev,
-					   "failed to clear port RST\n");
+				dev_err(host->dev,
+					"failed to clear port RST\n");
 		}
 
 		/* configure port */
@@ -1271,7 +1270,6 @@ static void sil24_init_controller(struct ata_host *host)
 static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	extern int __MARKER__sil24_cmd_block_is_sized_wrongly;
-	static int printed_version;
 	struct ata_port_info pi = sil24_port_info[ent->driver_data];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 	void __iomem * const *iomap;
@@ -1283,8 +1281,7 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (sizeof(union sil24_cmd_block) != PAGE_SIZE)
 		__MARKER__sil24_cmd_block_is_sized_wrongly = 1;
 
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
@@ -1302,9 +1299,8 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pi.flags & SIL24_FLAG_PCIX_IRQ_WOC) {
 		tmp = readl(iomap[SIL24_HOST_BAR] + HOST_CTRL);
 		if (tmp & (HOST_CTRL_TRDY | HOST_CTRL_STOP | HOST_CTRL_DEVSEL))
-			dev_printk(KERN_INFO, &pdev->dev,
-				   "Applying completion IRQ loss on PCI-X "
-				   "errata fix\n");
+			dev_info(&pdev->dev,
+				 "Applying completion IRQ loss on PCI-X errata fix\n");
 		else
 			pi.flags &= ~SIL24_FLAG_PCIX_IRQ_WOC;
 	}
@@ -1322,22 +1318,21 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
-				dev_printk(KERN_ERR, &pdev->dev,
-					   "64-bit DMA enable failed\n");
+				dev_err(&pdev->dev,
+					"64-bit DMA enable failed\n");
 				return rc;
 			}
 		}
 	} else {
 		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit DMA enable failed\n");
+			dev_err(&pdev->dev, "32-bit DMA enable failed\n");
 			return rc;
 		}
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit consistent DMA enable failed\n");
+			dev_err(&pdev->dev,
+				"32-bit consistent DMA enable failed\n");
 			return rc;
 		}
 	}
@@ -1350,7 +1345,7 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	sil24_init_controller(host);
 
 	if (sata_sil24_msi && !pci_enable_msi(pdev)) {
-		dev_printk(KERN_INFO, &pdev->dev, "Using MSI\n");
+		dev_info(&pdev->dev, "Using MSI\n");
 		pci_intx(pdev, 0);
 	}
 
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index cdcc13e..447d9c0 100644
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
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -241,12 +239,12 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			break;
 		}
 		if ((pmr & SIS_PMR_COMBINED) == 0) {
-			dev_printk(KERN_INFO, &pdev->dev,
-				   "Detected SiS 180/181/964 chipset in SATA mode\n");
+			dev_info(&pdev->dev,
+				 "Detected SiS 180/181/964 chipset in SATA mode\n");
 			port2_start = 64;
 		} else {
-			dev_printk(KERN_INFO, &pdev->dev,
-				   "Detected SiS 180/181 chipset in combined mode\n");
+			dev_info(&pdev->dev,
+				 "Detected SiS 180/181 chipset in combined mode\n");
 			port2_start = 0;
 			pi.flags |= ATA_FLAG_SLAVE_POSS;
 		}
@@ -256,24 +254,22 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	case 0x0183:
 		pci_read_config_dword(pdev, 0x6C, &val);
 		if (val & (1L << 31)) {
-			dev_printk(KERN_INFO, &pdev->dev,
-				   "Detected SiS 182/965 chipset\n");
+			dev_info(&pdev->dev, "Detected SiS 182/965 chipset\n");
 			pi.flags |= ATA_FLAG_SLAVE_POSS;
 		} else {
-			dev_printk(KERN_INFO, &pdev->dev,
-				   "Detected SiS 182/965L chipset\n");
+			dev_info(&pdev->dev, "Detected SiS 182/965L chipset\n");
 		}
 		break;
 
 	case 0x1182:
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "Detected SiS 1182/966/680 SATA controller\n");
+		dev_info(&pdev->dev,
+			 "Detected SiS 1182/966/680 SATA controller\n");
 		pi.flags |= ATA_FLAG_SLAVE_POSS;
 		break;
 
 	case 0x1183:
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "Detected SiS 1183/966/966L/968/680 controller in PATA mode\n");
+		dev_info(&pdev->dev,
+			 "Detected SiS 1183/966/966L/968/680 controller in PATA mode\n");
 		ppi[0] = &sis_info133_for_sata;
 		ppi[1] = &sis_info133_for_sata;
 		break;
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
index 235be71..b54ebfc 100644
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
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 54434db..f93e43b 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -360,9 +360,9 @@ static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
 
 	online = (sstatus & 0xf) == 0x3;
 
-	ata_port_printk(ap, KERN_INFO,
-			"SATA link %s 1.5 Gbps (SStatus %X SControl %X)\n",
-			online ? "up" : "down", sstatus, scontrol);
+	ata_port_info(ap,
+		      "SATA link %s 1.5 Gbps (SStatus %X SControl %X)\n",
+		      online ? "up" : "down", sstatus, scontrol);
 
 	/* SStatus is read one more time */
 	svia_scr_read(link, SCR_STATUS, &sstatus);
@@ -469,7 +469,7 @@ static int vt6420_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 
 	rc = pcim_iomap_regions(pdev, 1 << 5, DRV_NAME);
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev, "failed to iomap PCI BAR 5\n");
+		dev_err(&pdev->dev, "failed to iomap PCI BAR 5\n");
 		return rc;
 	}
 
@@ -488,14 +488,14 @@ static int vt6421_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 
 	*r_host = host = ata_host_alloc_pinfo(&pdev->dev, ppi, ARRAY_SIZE(ppi));
 	if (!host) {
-		dev_printk(KERN_ERR, &pdev->dev, "failed to allocate host\n");
+		dev_err(&pdev->dev, "failed to allocate host\n");
 		return -ENOMEM;
 	}
 
 	rc = pcim_iomap_regions(pdev, 0x3f, DRV_NAME);
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev, "failed to request/iomap "
-			   "PCI BARs (errno=%d)\n", rc);
+		dev_err(&pdev->dev, "failed to request/iomap PCI BARs (errno=%d)\n",
+			rc);
 		return rc;
 	}
 	host->iomap = pcim_iomap_table(pdev);
@@ -526,7 +526,7 @@ static int vt8251_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 
 	rc = pcim_iomap_regions(pdev, 1 << 5, DRV_NAME);
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev, "failed to iomap PCI BAR 5\n");
+		dev_err(&pdev->dev, "failed to iomap PCI BAR 5\n");
 		return rc;
 	}
 
@@ -542,15 +542,14 @@ static void svia_configure(struct pci_dev *pdev, int board_id)
 	u8 tmp8;
 
 	pci_read_config_byte(pdev, PCI_INTERRUPT_LINE, &tmp8);
-	dev_printk(KERN_INFO, &pdev->dev, "routed to hard irq line %d\n",
-	       (int) (tmp8 & 0xf0) == 0xf0 ? 0 : tmp8 & 0x0f);
+	dev_info(&pdev->dev, "routed to hard irq line %d\n",
+		 (int) (tmp8 & 0xf0) == 0xf0 ? 0 : tmp8 & 0x0f);
 
 	/* make sure SATA channels are enabled */
 	pci_read_config_byte(pdev, SATA_CHAN_ENAB, &tmp8);
 	if ((tmp8 & ALL_PORTS) != ALL_PORTS) {
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "enabling SATA channels (0x%x)\n",
-			   (int) tmp8);
+		dev_dbg(&pdev->dev, "enabling SATA channels (0x%x)\n",
+			(int)tmp8);
 		tmp8 |= ALL_PORTS;
 		pci_write_config_byte(pdev, SATA_CHAN_ENAB, tmp8);
 	}
@@ -558,9 +557,8 @@ static void svia_configure(struct pci_dev *pdev, int board_id)
 	/* make sure interrupts for each channel sent to us */
 	pci_read_config_byte(pdev, SATA_INT_GATE, &tmp8);
 	if ((tmp8 & ALL_PORTS) != ALL_PORTS) {
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "enabling SATA channel interrupts (0x%x)\n",
-			   (int) tmp8);
+		dev_dbg(&pdev->dev, "enabling SATA channel interrupts (0x%x)\n",
+			(int) tmp8);
 		tmp8 |= ALL_PORTS;
 		pci_write_config_byte(pdev, SATA_INT_GATE, tmp8);
 	}
@@ -568,9 +566,9 @@ static void svia_configure(struct pci_dev *pdev, int board_id)
 	/* make sure native mode is enabled */
 	pci_read_config_byte(pdev, SATA_NATIVE_MODE, &tmp8);
 	if ((tmp8 & NATIVE_MODE_ALL) != NATIVE_MODE_ALL) {
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "enabling SATA channel native mode (0x%x)\n",
-			   (int) tmp8);
+		dev_dbg(&pdev->dev,
+			"enabling SATA channel native mode (0x%x)\n",
+			(int) tmp8);
 		tmp8 |= NATIVE_MODE_ALL;
 		pci_write_config_byte(pdev, SATA_NATIVE_MODE, tmp8);
 	}
@@ -606,15 +604,13 @@ static void svia_configure(struct pci_dev *pdev, int board_id)
 
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
@@ -628,7 +624,7 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < ARRAY_SIZE(svia_bar_sizes); i++)
 		if ((pci_resource_start(pdev, i) == 0) ||
 		    (pci_resource_len(pdev, i) < bar_sizes[i])) {
-			dev_printk(KERN_ERR, &pdev->dev,
+			dev_err(&pdev->dev,
 				"invalid PCI BAR %u (sz 0x%llx, val 0x%llx)\n",
 				i,
 				(unsigned long long)pci_resource_start(pdev, i),
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 7c98737..6135a52 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -273,9 +273,8 @@ static irqreturn_t vsc_sata_interrupt(int irq, void *dev_instance)
 
 	if (unlikely(status == 0xffffffff || status == 0)) {
 		if (status)
-			dev_printk(KERN_ERR, host->dev,
-				": IRQ status == 0xffffffff, "
-				"PCI fault or device removal?\n");
+			dev_err(host->dev,
+				": IRQ status == 0xffffffff, PCI fault or device removal?\n");
 		goto out;
 	}
 
@@ -347,14 +346,12 @@ static int __devinit vsc_sata_init_one(struct pci_dev *pdev,
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
index 5a9926b..efd6f98 100644
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
 
@@ -1244,20 +1254,50 @@ static inline int sata_srst_pmp(struct ata_link *link)
 /*
  * printk helpers
  */
-#define ata_port_printk(ap, lv, fmt, args...) \
-	printk("%sata%u: "fmt, lv, (ap)->print_id , ##args)
-
-#define ata_link_printk(link, lv, fmt, args...) do { \
-	if (sata_pmp_attached((link)->ap) || (link)->ap->slave_link)	\
-		printk("%sata%u.%02u: "fmt, lv, (link)->ap->print_id,	\
-		       (link)->pmp , ##args); \
-	else \
-		printk("%sata%u: "fmt, lv, (link)->ap->print_id , ##args); \
-	} while(0)
-
-#define ata_dev_printk(dev, lv, fmt, args...) \
-	printk("%sata%u.%02u: "fmt, lv, (dev)->link->ap->print_id,	\
-	       (dev)->link->pmp + (dev)->devno , ##args)
+__attribute__((format (printf, 3, 4)))
+int ata_port_printk(const struct ata_port *ap, const char *level,
+		    const char *fmt, ...);
+__attribute__((format (printf, 3, 4)))
+int ata_link_printk(const struct ata_link *link, const char *level,
+		    const char *fmt, ...);
+__attribute__((format (printf, 3, 4)))
+int ata_dev_printk(const struct ata_device *dev, const char *level,
+		   const char *fmt, ...);
+
+#define ata_port_err(ap, fmt, ...)				\
+	ata_port_printk(ap, KERN_ERR, fmt, ##__VA_ARGS__)
+#define ata_port_warn(ap, fmt, ...)				\
+	ata_port_printk(ap, KERN_WARNING, fmt, ##__VA_ARGS__)
+#define ata_port_notice(ap, fmt, ...)				\
+	ata_port_printk(ap, KERN_NOTICE, fmt, ##__VA_ARGS__)
+#define ata_port_info(ap, fmt, ...)				\
+	ata_port_printk(ap, KERN_INFO, fmt, ##__VA_ARGS__)
+#define ata_port_dbg(ap, fmt, ...)				\
+	ata_port_printk(ap, KERN_DEBUG, fmt, ##__VA_ARGS__)
+
+#define ata_link_err(link, fmt, ...)				\
+	ata_link_printk(link, KERN_ERR, fmt, ##__VA_ARGS__)
+#define ata_link_warn(link, fmt, ...)				\
+	ata_link_printk(link, KERN_WARNING, fmt, ##__VA_ARGS__)
+#define ata_link_notice(link, fmt, ...)				\
+	ata_link_printk(link, KERN_NOTICE, fmt, ##__VA_ARGS__)
+#define ata_link_info(link, fmt, ...)				\
+	ata_link_printk(link, KERN_INFO, fmt, ##__VA_ARGS__)
+#define ata_link_dbg(link, fmt, ...)				\
+	ata_link_printk(link, KERN_DEBUG, fmt, ##__VA_ARGS__)
+
+#define ata_dev_err(dev, fmt, ...)				\
+	ata_dev_printk(dev, KERN_ERR, fmt, ##__VA_ARGS__)
+#define ata_dev_warn(dev, fmt, ...)				\
+	ata_dev_printk(dev, KERN_WARNING, fmt, ##__VA_ARGS__)
+#define ata_dev_notice(dev, fmt, ...)				\
+	ata_dev_printk(dev, KERN_NOTICE, fmt, ##__VA_ARGS__)
+#define ata_dev_info(dev, fmt, ...)				\
+	ata_dev_printk(dev, KERN_INFO, fmt, ##__VA_ARGS__)
+#define ata_dev_dbg(dev, fmt, ...)				\
+	ata_dev_printk(dev, KERN_DEBUG, fmt, ##__VA_ARGS__)
+
+void ata_print_version(const struct device *dev, const char *version);
 
 /*
  * ata_eh_info helpers
