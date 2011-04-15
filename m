Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1DOWwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:52:53 -0400
Received: from mail.perches.com ([173.55.12.10]:4722 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab1DOWwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:52:50 -0400
From: Joe Perches <joe@perches.com>
To: Jeff Garzik <jgarzik@pobox.com>, Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ata: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Fri, 15 Apr 2011 15:51:58 -0700
Message-Id: <497440622277223dfbebd2439b842fff73bd7bc8.1302907497.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302907496.git.joe@perches.com>
References: <cover.1302907496.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saves a bit of text as the call takes fewer args.

Coalesce a few formats.
Convert a few bare printks to pr_cont.

$ size drivers/ata/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 558429	  73893	 117864	 750186	  b726a	drivers/ata/built-in.o.allyesconfig.new
 559574	  73893	 117888	 751355	  b76fb	drivers/ata/built-in.o.allyesconfig.old
 149567	  14689	   4220	 168476	  2921c	drivers/ata/built-in.o.defconfig.new
 149851	  14689	   4220	 168760	  29338	drivers/ata/built-in.o.defconfig.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/acard-ahci.c     |   23 ++++++--------
 drivers/ata/ahci.c           |   44 ++++++++++++-------------
 drivers/ata/ata_piix.c       |   39 ++++++++++++-----------
 drivers/ata/libahci.c        |   71 +++++++++++++++++------------------------
 drivers/ata/libata-core.c    |   13 +++----
 drivers/ata/libata-sff.c     |   20 +++++-------
 drivers/ata/pata_amd.c       |    2 +-
 drivers/ata/pata_atp867x.c   |   11 +++---
 drivers/ata/pata_cs5520.c    |    3 +-
 drivers/ata/pata_ixp4xx_cf.c |    2 +-
 drivers/ata/pata_macio.c     |    5 ++-
 drivers/ata/pata_ns87410.c   |    2 +-
 drivers/ata/pata_pdc2027x.c  |    2 +-
 drivers/ata/pata_sl82c105.c  |    6 ++-
 drivers/ata/pdc_adma.c       |    6 +--
 drivers/ata/sata_fsl.c       |   14 +++-----
 drivers/ata/sata_inic162x.c  |   12 ++-----
 drivers/ata/sata_mv.c        |   49 +++++++++++++----------------
 drivers/ata/sata_nv.c        |    6 ++--
 drivers/ata/sata_promise.c   |    2 +-
 drivers/ata/sata_qstor.c     |    9 ++---
 drivers/ata/sata_sil.c       |    9 ++---
 drivers/ata/sata_sil24.c     |   22 ++++++-------
 drivers/ata/sata_sis.c       |   24 ++++++--------
 drivers/ata/sata_uli.c       |    2 +-
 drivers/ata/sata_via.c       |   16 +++++-----
 drivers/ata/sata_vsc.c       |    5 +--
 27 files changed, 189 insertions(+), 230 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 339c210..06a23be 100644
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
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 39d829c..70eda40 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -623,8 +623,8 @@ static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 
 	if (mesg.event & PM_EVENT_SUSPEND &&
 	    hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "BIOS update required for suspend/resume\n");
+		dev_err(&pdev->dev,
+			"BIOS update required for suspend/resume\n");
 		return -EIO;
 	}
 
@@ -675,22 +675,21 @@ static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
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
@@ -753,8 +752,8 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
 	    dmi_check_system(sysids)) {
 		struct ata_port *ap = host->ports[1];
 
-		dev_printk(KERN_INFO, &pdev->dev, "enabling ASUS P5W DH "
-			   "Deluxe on-board SIMG4726 workaround\n");
+		dev_info(&pdev->dev,
+			 "enabling ASUS P5W DH Deluxe on-board SIMG4726 workaround\n");
 
 		ap->ops = &ahci_p5wdh_ops;
 		ap->link.flags |= ATA_LFLAG_NO_SRST | ATA_LFLAG_ASSUME_ATA;
@@ -825,14 +824,14 @@ static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
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
 
@@ -1035,9 +1034,8 @@ static void ahci_gtf_filter_workaround(struct ata_host *host)
 		return;
 
 	filter = (unsigned long)dmi->driver_data;
-	dev_printk(KERN_INFO, host->dev,
-		   "applying extra ACPI _GTF filter 0x%x for %s\n",
-		   filter, dmi->ident);
+	dev_info(host->dev, "applying extra ACPI _GTF filter 0x%x for %s\n",
+		 filter, dmi->ident);
 
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
@@ -1093,8 +1091,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * that for SAS drives they're out of luck.
 	 */
 	if (pdev->vendor == PCI_VENDOR_ID_PROMISE)
-		dev_printk(KERN_INFO, &pdev->dev, "PDC42819 "
-			   "can only drive SATA devices with this driver\n");
+		dev_info(&pdev->dev,
+			 "PDC42819 can only drive SATA devices with this driver\n");
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
@@ -1120,8 +1118,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -1178,8 +1176,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (ahci_broken_suspend(pdev)) {
 		hpriv->flags |= AHCI_HFLAG_NO_SUSPEND;
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "BIOS update required for suspend/resume\n");
+		dev_warn(&pdev->dev,
+			 "BIOS update required for suspend/resume\n");
 	}
 
 	if (ahci_broken_online(pdev)) {
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 0bc3fd6..86cf97e 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1217,8 +1217,9 @@ static int piix_pci_device_resume(struct pci_dev *pdev)
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
 
@@ -1295,9 +1296,11 @@ static int __devinit piix_check_450nx_errata(struct pci_dev *ata_dev)
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
 
@@ -1330,37 +1333,36 @@ static const int *__devinit piix_init_sata_map(struct pci_dev *pdev,
 
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
@@ -1390,8 +1392,8 @@ static bool piix_no_sidpr(struct ata_host *host)
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL && pdev->device == 0x2920 &&
 	    pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG &&
 	    pdev->subsystem_device == 0xb049) {
-		dev_printk(KERN_WARNING, host->dev,
-			   "Samsung DB-P70 detected, disabling SIDPR\n");
+		dev_warn(host->dev,
+			 "Samsung DB-P70 detected, disabling SIDPR\n");
 		return true;
 	}
 
@@ -1443,8 +1445,8 @@ static int __devinit piix_init_sidpr(struct ata_host *host)
 		piix_sidpr_scr_read(link0, SCR_CONTROL, &scontrol);
 
 		if ((scontrol & 0xf00) != 0x300) {
-			dev_printk(KERN_INFO, host->dev, "SCR access via "
-				   "SIDPR is available but doesn't work\n");
+			dev_info(host->dev,
+				 "SCR access via SIDPR is available but doesn't work\n");
 			return 0;
 		}
 	}
@@ -1493,8 +1495,7 @@ static void piix_iocfg_bit18_quirk(struct ata_host *host)
 	 * affected systems.
 	 */
 	if (hpriv->saved_iocfg & (1 << 18)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "applying IOCFG bit18 quirk\n");
+		dev_info(&pdev->dev, "applying IOCFG bit18 quirk\n");
 		pci_write_config_dword(pdev, PIIX_IOCFG,
 				       hpriv->saved_iocfg & ~(1 << 18));
 	}
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 26d4523..18a4d53 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -388,51 +388,46 @@ void ahci_save_initial_config(struct device *dev,
 
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
-		dev_printk(KERN_ERR, dev, "masking port_map 0x%x -> 0x%x\n",
-			   port_map,
-			   port_map & mask_port_map);
+		dev_err(dev, "masking port_map 0x%x -> 0x%x\n",
+			port_map,
+			port_map & mask_port_map);
 		port_map &= mask_port_map;
 	}
 
@@ -448,10 +443,9 @@ void ahci_save_initial_config(struct device *dev,
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
@@ -459,8 +453,7 @@ void ahci_save_initial_config(struct device *dev,
 	/* fabricate port_map from cap.nr_ports */
 	if (!port_map) {
 		port_map = (1 << ahci_nr_ports(cap)) - 1;
-		dev_printk(KERN_WARNING, dev,
-			   "forcing PORTS_IMPL to 0x%x\n", port_map);
+		dev_warn(dev, "forcing PORTS_IMPL to 0x%x\n", port_map);
 
 		/* write the fixed up value to the PI register */
 		hpriv->saved_port_map = port_map;
@@ -800,8 +793,8 @@ int ahci_reset_controller(struct ata_host *host)
 					HOST_RESET, 10, 1000);
 
 		if (tmp & HOST_RESET) {
-			dev_printk(KERN_ERR, host->dev,
-				   "controller reset failed (0x%x)\n", tmp);
+			dev_err(host->dev, "controller reset failed (0x%x)\n",
+				tmp);
 			return -EIO;
 		}
 
@@ -813,8 +806,7 @@ int ahci_reset_controller(struct ata_host *host)
 		 */
 		ahci_restore_initial_config(host);
 	} else
-		dev_printk(KERN_INFO, host->dev,
-			   "skipping global host reset\n");
+		dev_info(host->dev, "skipping global host reset\n");
 
 	return 0;
 }
@@ -1452,8 +1444,7 @@ static void ahci_fbs_dec_intr(struct ata_port *ap)
 	}
 
 	if (fbs & PORT_FBS_DEC)
-		dev_printk(KERN_ERR, ap->host->dev,
-			   "failed to clear device error\n");
+		dev_err(ap->host->dev, "failed to clear device error\n");
 }
 
 static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
@@ -1691,8 +1682,8 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
 			if (ata_ratelimit())
-				dev_printk(KERN_WARNING, host->dev,
-					"interrupt on disabled port %u\n", i);
+				dev_warn(host->dev,
+					 "interrupt on disabled port %u\n", i);
 		}
 
 		handled = 1;
@@ -1843,11 +1834,11 @@ static void ahci_enable_fbs(struct ata_port *ap)
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
@@ -1875,9 +1866,9 @@ static void ahci_disable_fbs(struct ata_port *ap)
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
 
@@ -1968,14 +1959,12 @@ static int ahci_port_start(struct ata_port *ap)
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
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 423c0a6..4e4801e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5840,9 +5840,9 @@ int ata_host_start(struct ata_host *host)
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
@@ -5964,8 +5964,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 	/* host must have been started */
 	if (!(host->flags & ATA_HOST_STARTED)) {
-		dev_printk(KERN_ERR, host->dev,
-			   "BUG: trying to register unstarted host\n");
+		dev_err(host->dev, "BUG: trying to register unstarted host\n");
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -6235,8 +6234,8 @@ int ata_pci_device_do_resume(struct pci_dev *pdev)
 
 	rc = pcim_enable_device(pdev);
 	if (rc) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "failed to enable device after resume (%d)\n", rc);
+		dev_err(&pdev->dev,
+			"failed to enable device after resume (%d)\n", rc);
 		return rc;
 	}
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index f8380ce..a49f315 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2316,9 +2316,9 @@ int ata_pci_sff_init_host(struct ata_host *host)
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
@@ -2340,7 +2340,7 @@ int ata_pci_sff_init_host(struct ata_host *host)
 	}
 
 	if (!mask) {
-		dev_printk(KERN_ERR, gdev, "no available native port\n");
+		dev_err(gdev, "no available native port\n");
 		return -ENODEV;
 	}
 
@@ -2375,8 +2375,7 @@ int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
 	if (!host) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "failed to allocate ATA host\n");
+		dev_err(&pdev->dev, "failed to allocate ATA host\n");
 		rc = -ENOMEM;
 		goto err_out;
 	}
@@ -2537,8 +2536,7 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 
 	pi = ata_sff_find_valid_pi(ppi);
 	if (!pi) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "no valid port_info specified\n");
+		dev_err(&pdev->dev, "no valid port_info specified\n");
 		return -EINVAL;
 	}
 
@@ -3159,8 +3157,7 @@ static void ata_bmdma_nodma(struct ata_host *host, const char *reason)
 {
 	int i;
 
-	dev_printk(KERN_ERR, host->dev, "BMDMA: %s, falling back to PIO\n",
-		   reason);
+	dev_err(host->dev, "BMDMA: %s, falling back to PIO\n", reason);
 
 	for (i = 0; i < 2; i++) {
 		host->ports[i]->mwdma_mask = 0;
@@ -3292,8 +3289,7 @@ int ata_pci_bmdma_init_one(struct pci_dev *pdev,
 
 	pi = ata_sff_find_valid_pi(ppi);
 	if (!pi) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "no valid port_info specified\n");
+		dev_err(&pdev->dev, "no valid port_info specified\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index b0975a5..b741e0f 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -60,7 +60,7 @@ static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offse
 		UT = T / 2;
 
 	if (ata_timing_compute(adev, speed, &at, T, UT) < 0) {
-		dev_printk(KERN_ERR, &pdev->dev, "unknown mode %d.\n", speed);
+		dev_err(&pdev->dev, "unknown mode %d\n", speed);
 		return;
 	}
 
diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
index 9529593..bcbf998 100644
--- a/drivers/ata/pata_atp867x.c
+++ b/drivers/ata/pata_atp867x.c
@@ -470,7 +470,7 @@ static int atp867x_ata_pci_sff_init_host(struct ata_host *host)
 	}
 
 	if (!mask) {
-		dev_printk(KERN_ERR, gdev, "no available native port\n");
+		dev_err(gdev, "no available native port\n");
 		return -ENODEV;
 	}
 
@@ -500,7 +500,7 @@ static int atp867x_init_one(struct pci_dev *pdev,
 	int rc;
 
 	if (!printed_version++)
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+		dev_info(&pdev->dev, "version " DRV_VERSION "\n");
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -511,15 +511,14 @@ static int atp867x_init_one(struct pci_dev *pdev,
 
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
 
@@ -528,7 +527,7 @@ static int atp867x_init_one(struct pci_dev *pdev,
 	rc = ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				IRQF_SHARED, &atp867x_sht);
 	if (rc)
-		dev_printk(KERN_ERR, &pdev->dev, "failed to activate host\n");
+		dev_err(&pdev->dev, "failed to activate host\n");
 
 err_out:
 	return rc;
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
 
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index f6b3f99..ee26835 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -181,7 +181,7 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 
 	ixp4xx_setup_port(ap, data, cs0->start, cs1->start);
 
-	dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+	dev_info(&pdev->dev, "version " DRV_VERSION "\n");
 
 	/* activate host */
 	return ata_host_activate(host, irq, ata_sff_interrupt, 0, &ixp4xx_sht);
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 46f589e..d39c10b 100644
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
 
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 9765ace..c8cdd6d 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -655,7 +655,7 @@ static int pdc_hardware_init(struct ata_host *host, unsigned int board_idx)
 	 */
 	pll_clock = pdc_detect_pll_input_clock(host);
 
-	dev_printk(KERN_INFO, host->dev, "PLL input clock %ld kHz\n", pll_clock/1000);
+	dev_info(host->dev, "PLL input clock %ld kHz\n", pll_clock/1000);
 
 	/* Adjust PLL control register */
 	pdc_adjust_pll(host, pll_clock, board_idx);
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
 
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 1111712..fdad56c 100644
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
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 35a71d8..1cc70e3 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -661,8 +661,7 @@ static int sata_fsl_port_start(struct ata_port *ap)
 	sata_fsl_scr_write(&ap->link, SCR_CONTROL, temp);
 
 	sata_fsl_scr_read(&ap->link, SCR_CONTROL, &temp);
-	dev_printk(KERN_WARNING, dev, "scr_control, speed limited to %x\n",
-			temp);
+	dev_warn(dev, "scr_control, speed limited to %x\n", temp);
 #endif
 
 	return 0;
@@ -1202,8 +1201,7 @@ static irqreturn_t sata_fsl_interrupt(int irq, void *dev_instance)
 	if (ap) {
 		sata_fsl_host_intr(ap);
 	} else {
-		dev_printk(KERN_WARNING, host->dev,
-			   "interrupt on disabled port 0\n");
+		dev_warn(host->dev, "interrupt on disabled port 0\n");
 	}
 
 	iowrite32(interrupt_enables, hcr_base + HSTATUS);
@@ -1317,8 +1315,7 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 	struct ata_port_info pi = sata_fsl_port_info[0];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 
-	dev_printk(KERN_INFO, &ofdev->dev,
-		   "Sata FSL Platform/CSB Driver init\n");
+	dev_info(&ofdev->dev, "Sata FSL Platform/CSB Driver init\n");
 
 	hcr_base = of_iomap(ofdev->dev.of_node, 0);
 	if (!hcr_base)
@@ -1347,7 +1344,7 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 
 	irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
 	if (irq < 0) {
-		dev_printk(KERN_ERR, &ofdev->dev, "invalid irq from platform\n");
+		dev_err(&ofdev->dev, "invalid irq from platform\n");
 		goto error_exit_with_cleanup;
 	}
 	host_priv->irq = irq;
@@ -1422,8 +1419,7 @@ static int sata_fsl_resume(struct platform_device *op)
 
 	ret = sata_fsl_init_controller(host);
 	if (ret) {
-		dev_printk(KERN_ERR, &op->dev,
-			"Error initialize hardware\n");
+		dev_err(&op->dev, "Error initializing hardware\n");
 		return ret;
 	}
 
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 83a4447..83019e6 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -847,15 +847,13 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
 
@@ -866,15 +864,13 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
index b52c051..bea717a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2930,8 +2930,7 @@ static int mv_pci_error(struct ata_host *host, void __iomem *mmio)
 
 	err_cause = readl(mmio + hpriv->irq_cause_offset);
 
-	dev_printk(KERN_ERR, host->dev, "PCI ERROR; PCI IRQ cause=0x%08x\n",
-		   err_cause);
+	dev_err(host->dev, "PCI ERROR; PCI IRQ cause=0x%08x\n", err_cause);
 
 	DPRINTK("All regs @ PCI error\n");
 	mv_dump_all_regs(mmio, -1, to_pci_dev(host->dev));
@@ -3760,8 +3759,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
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
@@ -3780,8 +3779,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
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
@@ -3801,8 +3800,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
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
@@ -3851,8 +3850,8 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
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
@@ -3867,8 +3866,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 		break;
 
 	default:
-		dev_printk(KERN_ERR, host->dev,
-			   "BUG: invalid board index %u\n", board_idx);
+		dev_err(host->dev, "BUG: invalid board index %u\n", board_idx);
 		return 1;
 	}
 
@@ -4033,7 +4031,7 @@ static int mv_platform_probe(struct platform_device *pdev)
 	int n_ports, rc;
 
 	if (!printed_version++)
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+		dev_info(&pdev->dev, "version " DRV_VERSION "\n");
 
 	/*
 	 * Simple resource validation ..
@@ -4091,9 +4089,8 @@ static int mv_platform_probe(struct platform_device *pdev)
 	if (rc)
 		goto err;
 
-	dev_printk(KERN_INFO, &pdev->dev,
-		   "slots %u ports %d\n", (unsigned)MV_MAX_Q_DEPTH,
-		   host->n_ports);
+	dev_info(&pdev->dev, "slots %u ports %d\n",
+		 (unsigned)MV_MAX_Q_DEPTH, host->n_ports);
 
 	return ata_host_activate(host, platform_get_irq(pdev, 0), mv_interrupt,
 				 IRQF_SHARED, &mv6_sht);
@@ -4217,22 +4214,21 @@ static int pci_go_64(struct pci_dev *pdev)
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
@@ -4276,10 +4272,9 @@ static void mv_print_info(struct ata_host *host)
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
@@ -4301,7 +4296,7 @@ static int mv_pci_init_one(struct pci_dev *pdev,
 	int n_ports, port, rc;
 
 	if (!printed_version++)
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+		dev_info(&pdev->dev, "version " DRV_VERSION "\n");
 
 	/* allocate host */
 	n_ports = mv_get_hc_count(ppi[0]->flags) * MV_PORTS_PER_HC;
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index f173ef3..f215e10 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -2382,10 +2382,10 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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
 
@@ -2429,7 +2429,7 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		nv_swncq_host_init(host);
 
 	if (msi_enabled) {
-		dev_printk(KERN_NOTICE, &pdev->dev, "Using MSI\n");
+		dev_notice(&pdev->dev, "Using MSI\n");
 		pci_enable_msi(pdev);
 	}
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index a004b1e..2ad51f9 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -1217,7 +1217,7 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host) {
-		dev_printk(KERN_ERR, &pdev->dev, "failed to allocate host\n");
+		dev_err(&pdev->dev, "failed to allocate host\n");
 		return -ENOMEM;
 	}
 	host->iomap = pcim_iomap_table(pdev);
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index c560326..5702561 100644
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
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index b42edaa..fe16ee8 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
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
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 06c564e..164d52e 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1256,8 +1256,8 @@ static void sil24_init_controller(struct ata_host *host)
 						PORT_CS_PORT_RST,
 						PORT_CS_PORT_RST, 10, 100);
 			if (tmp & PORT_CS_PORT_RST)
-				dev_printk(KERN_ERR, host->dev,
-					   "failed to clear port RST\n");
+				dev_err(host->dev,
+					"failed to clear port RST\n");
 		}
 
 		/* configure port */
@@ -1302,9 +1302,8 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -1322,22 +1321,21 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -1350,7 +1348,7 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	sil24_init_controller(host);
 
 	if (sata_sil24_msi && !pci_enable_msi(pdev)) {
-		dev_printk(KERN_INFO, &pdev->dev, "Using MSI\n");
+		dev_info(&pdev->dev, "Using MSI\n");
 		pci_intx(pdev, 0);
 	}
 
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index cdcc13e..ae040de 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -203,7 +203,7 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int i, rc;
 
 	if (!printed_version++)
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+		dev_info(&pdev->dev, "version " DRV_VERSION "\n");
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -241,12 +241,12 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -256,24 +256,22 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 235be71..3072fd3 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -155,7 +155,7 @@ static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int n_ports, rc;
 
 	if (!printed_version++)
-		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+		dev_info(&pdev->dev, "version " DRV_VERSION "\n");
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 54434db..9b43ccb 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
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
 
@@ -542,8 +542,8 @@ static void svia_configure(struct pci_dev *pdev, int board_id)
 	u8 tmp8;
 
 	pci_read_config_byte(pdev, PCI_INTERRUPT_LINE, &tmp8);
-	dev_printk(KERN_INFO, &pdev->dev, "routed to hard irq line %d\n",
-	       (int) (tmp8 & 0xf0) == 0xf0 ? 0 : tmp8 & 0x0f);
+	dev_info(&pdev->dev, "routed to hard irq line %d\n",
+		 (int) (tmp8 & 0xf0) == 0xf0 ? 0 : tmp8 & 0x0f);
 
 	/* make sure SATA channels are enabled */
 	pci_read_config_byte(pdev, SATA_CHAN_ENAB, &tmp8);
@@ -628,7 +628,7 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < ARRAY_SIZE(svia_bar_sizes); i++)
 		if ((pci_resource_start(pdev, i) == 0) ||
 		    (pci_resource_len(pdev, i) < bar_sizes[i])) {
-			dev_printk(KERN_ERR, &pdev->dev,
+			dev_err(&pdev->dev,
 				"invalid PCI BAR %u (sz 0x%llx, val 0x%llx)\n",
 				i,
 				(unsigned long long)pci_resource_start(pdev, i),
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 7c98737..dcd57b0 100644
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
 
-- 
1.7.4.2.g597a6.dirty

