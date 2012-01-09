Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2AIAdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:33:00 -0500
Received: from havoc.gtf.org ([69.61.125.42]:51441 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab2AIAc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:32:57 -0500
Date: Sun, 8 Jan 2012 19:32:55 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 3.3
Message-ID: <20120109003255.GA6598@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Summary (very little excitement at all this time):

0) Will play around with git signed tags with the next update.

1) PM improvements, including runtime suspend/resume work

2) AHCI DMA engine start/stop changes, intended to improve spec
compliance, thereby making a particular IP block work.  Tested for a
while in linux-next, but nonetheless worth watching for breakage in the
field.

3) other minor bits.

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Please pull 318893e1429a9d50569a0379d1e20b0ecc45c555 from
git://github.com/jgarzik/libata-dev.git upstream-linus

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTwo0xiWzCDIBeCsvAQJrQhAAuhjtG/AG5My8cKj7RS7GIaEEPEsNIoWm
/TbRLUfgJTiAkfiuqF4WqfzL2sGNUDMlMeSbs3P1p4kwLLQN8cSfd+xZVfNm3Q6u
HATts2JBNT8GQvffxXG5Z2JO3VXqlMxpc6TAjx1R+AY09CeT65qJlOzI+Uc7SIny
AZ6q2ETzHPoAMrTMLBCmsWSkXOBuOzHOjoAYDMbFBsVYpn587NjkAYMLrSjuMKVz
ndcmSGS4geEA1zEcQXKjWFmb+w5ZuifXOpVvy+cCyWQN27KebyJyTYiTCaNlFLVC
c1jdpHcElq2fDcdOrREHRjVxeYeUNHLVaTL5O/H5gh9kFOn+EQDySkhhTjpg69tk
44Q1YBQbfeBXCgku2sL0osv3RLjsN782exg2iH7AaV8MTlJBuIrj2p+uTOOwdTEP
CKpIlv9aTcWikbNX69nBXRQ7cKrztfVcMPVKsjblaiIU7O3GYEdziYm8lxPqTksr
rmM3GQSPkwfdFzbVXcY0wIyL3P/WzypQ2CZ8i/F2VpywIdw58hUZ4TG2Csm47ML3
5Hf5kllJR0/lzrJXkwlpEtLR0Ir5rK0CR4YUykj7BL0TGynnNwn+AmHKEeI51Gcy
0t44ZNO9T1ezGDhDKUTzx3SgzhElbkDqzqWCJhYVIbF44F65SBpS3ieeuKAFabE0
zHlKy0fNvT4=
=z+FO
-----END PGP SIGNATURE-----

to receive the following updates:

 drivers/ata/Kconfig            |    2 +-
 drivers/ata/ahci.c             |   26 +++++-
 drivers/ata/ahci_platform.c    |   68 ++++++++++++++
 drivers/ata/libahci.c          |    5 +-
 drivers/ata/libata-core.c      |  188 ++++++++++++++++++++++++++--------------
 drivers/ata/libata-scsi.c      |    3 +-
 drivers/ata/libata-sff.c       |    4 +-
 drivers/ata/libata-transport.c |    5 +
 drivers/ata/libata.h           |    1 +
 drivers/ata/pata_arasan_cf.c   |   12 +---
 drivers/ata/pata_at91.c        |   15 +---
 drivers/ata/pata_bf54x.c       |   20 +----
 drivers/ata/pata_cs5536.c      |   99 +++++++++------------
 drivers/ata/pata_imx.c         |   12 +---
 drivers/ata/pata_ixp4xx_cf.c   |   13 +---
 drivers/ata/pata_mpc52xx.c     |   21 +----
 drivers/ata/pata_of_platform.c |   27 ++----
 drivers/ata/pata_palmld.c      |   13 +---
 drivers/ata/pata_platform.c    |   12 +---
 drivers/ata/pata_pxa.c         |   13 +---
 drivers/ata/pata_rb532_cf.c    |   21 +----
 drivers/ata/sata_dwc_460ex.c   |   13 +---
 drivers/ata/sata_fsl.c         |   14 +---
 drivers/scsi/scsi_error.c      |    5 +-
 drivers/scsi/scsi_pm.c         |   27 ++++++-
 drivers/scsi/sd.c              |    5 +
 include/linux/ahci_platform.h  |    2 +
 include/scsi/scsi_host.h       |    3 +
 28 files changed, 326 insertions(+), 323 deletions(-)

Alessandro Rubini (1):
      ahci: support the STA2X11 I/O Hub

Axel Lin (1):
      SATA/PATA: convert drivers/ata/* to use module_platform_driver()

Bartlomiej Zolnierkiewicz (1):
      pata_cs5536: forward port changes from cs5536

Brian Norris (1):
      ahci: platform support for suspend/resume

Lin Ming (9):
      ata: make ata port as parent device of scsi host
      [SCSI] add flag to skip the runtime PM calls on the host
      [SCSI] check runtime PM status in system PM
      [SCSI] sd: check runtime PM status in sd_shutdown
      ata: add ata port system PM callbacks
      ata: add ata port runtime PM callbacks
      [SCSI] runtime resume parent for child's system-resume
      ata: update ata port's runtime status during system resume
      ata: add ata port hibernate callbacks

Rob Herring (1):
      pata_of_platform: remove direct dependency on OF_IRQ

Sergei Shtylyov (3):
      libata-sff: use ATAPI_{COD|IO}
      libata-core: kill duplicate statement in ata_do_set_mode()
      pata_bf54x: fix BMIDE status register emulation

Tejun Heo (1):
      ahci: start engine only during soft/hard resets

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index cf047c4..6bdedd7 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -820,7 +820,7 @@ config PATA_PLATFORM
 
 config PATA_OF_PLATFORM
 	tristate "OpenFirmware platform device PATA support"
-	depends on PATA_PLATFORM && OF && OF_IRQ
+	depends on PATA_PLATFORM && OF
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems with OpenFirmware
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index cf26222..d07bf03 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -52,7 +52,8 @@
 #define DRV_VERSION	"3.0"
 
 enum {
-	AHCI_PCI_BAR		= 5,
+	AHCI_PCI_BAR_STA2X11	= 0,
+	AHCI_PCI_BAR_STANDARD	= 5,
 };
 
 enum board_ids {
@@ -375,6 +376,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci },		/* SiS 968 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci },		/* SiS 968 */
 
+	/* ST Microelectronics */
+	{ PCI_VDEVICE(STMICRO, 0xCC06), board_ahci },		/* ST ConneXt */
+
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
@@ -622,6 +626,13 @@ static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
 {
 	int rc;
 
+	/*
+	 * If the device fixup already set the dma_mask to some non-standard
+	 * value, don't extend it here. This happens on STA2X11, for example.
+	 */
+	if (pdev->dma_mask && pdev->dma_mask < DMA_BIT_MASK(32))
+		return 0;
+
 	if (using_dac &&
 	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
@@ -1026,6 +1037,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
 	int n_ports, i, rc;
+	int ahci_pci_bar = AHCI_PCI_BAR_STANDARD;
 
 	VPRINTK("ENTER\n");
 
@@ -1057,6 +1069,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_info(&pdev->dev,
 			 "PDC42819 can only drive SATA devices with this driver\n");
 
+	/* The Connext uses non-standard BAR */
+	if (pdev->vendor == PCI_VENDOR_ID_STMICRO && pdev->device == 0xCC06)
+		ahci_pci_bar = AHCI_PCI_BAR_STA2X11;
+
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -1065,7 +1081,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* AHCI controllers often implement SFF compatible interface.
 	 * Grab all PCI BARs just in case.
 	 */
-	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
+	rc = pcim_iomap_regions_request_all(pdev, 1 << ahci_pci_bar, DRV_NAME);
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
@@ -1108,7 +1124,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 
-	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
@@ -1172,8 +1188,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-		ata_port_pbar_desc(ap, AHCI_PCI_BAR, -1, "abar");
-		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
+		ata_port_pbar_desc(ap, ahci_pci_bar, -1, "abar");
+		ata_port_pbar_desc(ap, ahci_pci_bar,
 				   0x100 + ap->port_no * 0x80, "port");
 
 		/* set enclosure management message type */
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 43b8758..48be4e1 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -202,6 +202,71 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int ahci_suspend(struct device *dev)
+{
+	struct ahci_platform_data *pdata = dev_get_platdata(dev);
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl;
+	int rc;
+
+	if (hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
+		dev_err(dev, "firmware update required for suspend/resume\n");
+		return -EIO;
+	}
+
+	/*
+	 * AHCI spec rev1.1 section 8.3.3:
+	 * Software must disable interrupts prior to requesting a
+	 * transition of the HBA to D3 state.
+	 */
+	ctl = readl(mmio + HOST_CTL);
+	ctl &= ~HOST_IRQ_EN;
+	writel(ctl, mmio + HOST_CTL);
+	readl(mmio + HOST_CTL); /* flush */
+
+	rc = ata_host_suspend(host, PMSG_SUSPEND);
+	if (rc)
+		return rc;
+
+	if (pdata && pdata->suspend)
+		return pdata->suspend(dev);
+	return 0;
+}
+
+static int ahci_resume(struct device *dev)
+{
+	struct ahci_platform_data *pdata = dev_get_platdata(dev);
+	struct ata_host *host = dev_get_drvdata(dev);
+	int rc;
+
+	if (pdata && pdata->resume) {
+		rc = pdata->resume(dev);
+		if (rc)
+			return rc;
+	}
+
+	if (dev->power.power_state.event == PM_EVENT_SUSPEND) {
+		rc = ahci_reset_controller(host);
+		if (rc)
+			return rc;
+
+		ahci_init_controller(host);
+	}
+
+	ata_host_resume(host);
+
+	return 0;
+}
+
+static struct dev_pm_ops ahci_pm_ops = {
+	.suspend		= &ahci_suspend,
+	.resume			= &ahci_resume,
+};
+#endif
+
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "calxeda,hb-ahci", },
 	{},
@@ -214,6 +279,9 @@ static struct platform_driver ahci_driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
 		.of_match_table = ahci_of_match,
+#ifdef CONFIG_PM
+		.pm = &ahci_pm_ops,
+#endif
 	},
 	.id_table	= ahci_devtype,
 };
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 3c92dbd..a72bfd0 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -746,9 +746,6 @@ static void ahci_start_port(struct ata_port *ap)
 	/* enable FIS reception */
 	ahci_start_fis_rx(ap);
 
-	/* enable DMA */
-	ahci_start_engine(ap);
-
 	/* turn on LEDs */
 	if (ap->flags & ATA_FLAG_EM) {
 		ata_for_each_link(link, ap, EDGE) {
@@ -2022,7 +2019,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 		ahci_power_down(ap);
 	else {
 		ata_port_err(ap, "%s (%d)\n", emsg, rc);
-		ahci_start_port(ap);
+		ata_port_freeze(ap);
 	}
 
 	return rc;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c04ad68..11c9aea 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -66,6 +66,7 @@
 #include <asm/byteorder.h>
 #include <linux/cdrom.h>
 #include <linux/ratelimit.h>
+#include <linux/pm_runtime.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -3248,10 +3249,10 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 		ata_force_xfermask(dev);
 
 		pio_mask = ata_pack_xfermask(dev->pio_mask, 0, 0);
-		dma_mask = ata_pack_xfermask(0, dev->mwdma_mask, dev->udma_mask);
 
 		if (libata_dma_mask & mode_mask)
-			dma_mask = ata_pack_xfermask(0, dev->mwdma_mask, dev->udma_mask);
+			dma_mask = ata_pack_xfermask(0, dev->mwdma_mask,
+						     dev->udma_mask);
 		else
 			dma_mask = 0;
 
@@ -5234,73 +5235,55 @@ bool ata_link_offline(struct ata_link *link)
 }
 
 #ifdef CONFIG_PM
-static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
+static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
 			       int wait)
 {
+	struct ata_link *link;
 	unsigned long flags;
-	int i, rc;
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-		struct ata_link *link;
+	int rc;
 
-		/* Previous resume operation might still be in
-		 * progress.  Wait for PM_PENDING to clear.
-		 */
-		if (ap->pflags & ATA_PFLAG_PM_PENDING) {
-			ata_port_wait_eh(ap);
-			WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
-		}
+	/* Previous resume operation might still be in
+	 * progress.  Wait for PM_PENDING to clear.
+	 */
+	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
+		ata_port_wait_eh(ap);
+		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
+	}
 
-		/* request PM ops to EH */
-		spin_lock_irqsave(ap->lock, flags);
+	/* request PM ops to EH */
+	spin_lock_irqsave(ap->lock, flags);
 
-		ap->pm_mesg = mesg;
-		if (wait) {
-			rc = 0;
-			ap->pm_result = &rc;
-		}
+	ap->pm_mesg = mesg;
+	if (wait) {
+		rc = 0;
+		ap->pm_result = &rc;
+	}
 
-		ap->pflags |= ATA_PFLAG_PM_PENDING;
-		ata_for_each_link(link, ap, HOST_FIRST) {
-			link->eh_info.action |= action;
-			link->eh_info.flags |= ehi_flags;
-		}
+	ap->pflags |= ATA_PFLAG_PM_PENDING;
+	ata_for_each_link(link, ap, HOST_FIRST) {
+		link->eh_info.action |= action;
+		link->eh_info.flags |= ehi_flags;
+	}
 
-		ata_port_schedule_eh(ap);
+	ata_port_schedule_eh(ap);
 
-		spin_unlock_irqrestore(ap->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
-		/* wait and check result */
-		if (wait) {
-			ata_port_wait_eh(ap);
-			WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
-			if (rc)
-				return rc;
-		}
+	/* wait and check result */
+	if (wait) {
+		ata_port_wait_eh(ap);
+		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
 	}
 
-	return 0;
+	return rc;
 }
 
-/**
- *	ata_host_suspend - suspend host
- *	@host: host to suspend
- *	@mesg: PM message
- *
- *	Suspend @host.  Actual operation is performed by EH.  This
- *	function requests EH to perform PM operations and waits for EH
- *	to finish.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno on failure.
- */
-int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
+#define to_ata_port(d) container_of(d, struct ata_port, tdev)
+
+static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
 {
+	struct ata_port *ap = to_ata_port(dev);
 	unsigned int ehi_flags = ATA_EHI_QUIET;
 	int rc;
 
@@ -5315,31 +5298,108 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 	if (mesg.event == PM_EVENT_SUSPEND)
 		ehi_flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_NO_RECOVERY;
 
-	rc = ata_host_request_pm(host, mesg, 0, ehi_flags, 1);
-	if (rc == 0)
-		host->dev->power.power_state = mesg;
+	rc = ata_port_request_pm(ap, mesg, 0, ehi_flags, 1);
 	return rc;
 }
 
+static int ata_port_suspend(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return ata_port_suspend_common(dev, PMSG_SUSPEND);
+}
+
+static int ata_port_do_freeze(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		pm_runtime_resume(dev);
+
+	return ata_port_suspend_common(dev, PMSG_FREEZE);
+}
+
+static int ata_port_poweroff(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return ata_port_suspend_common(dev, PMSG_HIBERNATE);
+}
+
+static int ata_port_resume_common(struct device *dev)
+{
+	struct ata_port *ap = to_ata_port(dev);
+	int rc;
+
+	rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);
+	return rc;
+}
+
+static int ata_port_resume(struct device *dev)
+{
+	int rc;
+
+	rc = ata_port_resume_common(dev);
+	if (!rc) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return rc;
+}
+
+static int ata_port_runtime_idle(struct device *dev)
+{
+	return pm_runtime_suspend(dev);
+}
+
+static const struct dev_pm_ops ata_port_pm_ops = {
+	.suspend = ata_port_suspend,
+	.resume = ata_port_resume,
+	.freeze = ata_port_do_freeze,
+	.thaw = ata_port_resume,
+	.poweroff = ata_port_poweroff,
+	.restore = ata_port_resume,
+
+	.runtime_suspend = ata_port_suspend,
+	.runtime_resume = ata_port_resume_common,
+	.runtime_idle = ata_port_runtime_idle,
+};
+
+/**
+ *	ata_host_suspend - suspend host
+ *	@host: host to suspend
+ *	@mesg: PM message
+ *
+ *	Suspend @host.  Actual operation is performed by port suspend.
+ */
+int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
+{
+	host->dev->power.power_state = mesg;
+	return 0;
+}
+
 /**
  *	ata_host_resume - resume host
  *	@host: host to resume
  *
- *	Resume @host.  Actual operation is performed by EH.  This
- *	function requests EH to perform PM operations and returns.
- *	Note that all resume operations are performed parallelly.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
+ *	Resume @host.  Actual operation is performed by port resume.
  */
 void ata_host_resume(struct ata_host *host)
 {
-	ata_host_request_pm(host, PMSG_ON, ATA_EH_RESET,
-			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
 }
 #endif
 
+struct device_type ata_port_type = {
+	.name = "ata_port",
+#ifdef CONFIG_PM
+	.pm = &ata_port_pm_ops,
+#endif
+};
+
 /**
  *	ata_dev_init - Initialize an ata_device structure
  *	@dev: Device structure to initialize
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2a5412e..508a60b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3381,6 +3381,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		if (!shost)
 			goto err_alloc;
 
+		shost->eh_noresume = 1;
 		*(struct ata_port **)&shost->hostdata[0] = ap;
 		ap->scsi_host = shost;
 
@@ -3398,7 +3399,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		 */
 		shost->max_host_blocked = 1;
 
-		rc = scsi_add_host(ap->scsi_host, ap->host->dev);
+		rc = scsi_add_host(ap->scsi_host, &ap->tdev);
 		if (rc)
 			goto err_add;
 	}
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 4cadfa2..9691dd0 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -929,11 +929,11 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 	bytes = (bc_hi << 8) | bc_lo;
 
 	/* shall be cleared to zero, indicating xfer of data */
-	if (unlikely(ireason & (1 << 0)))
+	if (unlikely(ireason & ATAPI_COD))
 		goto atapi_check;
 
 	/* make sure transfer direction matches expected */
-	i_write = ((ireason & (1 << 1)) == 0) ? 1 : 0;
+	i_write = ((ireason & ATAPI_IO) == 0) ? 1 : 0;
 	if (unlikely(do_write != i_write))
 		goto atapi_check;
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index ce9dc62..9a7f0ea 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -32,6 +32,7 @@
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -279,6 +280,7 @@ int ata_tport_add(struct device *parent,
 	struct device *dev = &ap->tdev;
 
 	device_initialize(dev);
+	dev->type = &ata_port_type;
 
 	dev->parent = get_device(parent);
 	dev->release = ata_tport_release;
@@ -289,6 +291,9 @@ int ata_tport_add(struct device *parent,
 		goto tport_err;
 	}
 
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	transport_add_device(dev);
 	transport_configure_device(dev);
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 773de97..814486d 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -58,6 +58,7 @@ extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
 extern int libata_allow_tpm;
+extern struct device_type ata_port_type;
 extern struct ata_link *ata_dev_phys_link(struct ata_device *dev);
 extern void ata_force_cbl(struct ata_port *ap);
 extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index e8574bb..048589f 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -963,17 +963,7 @@ static struct platform_driver arasan_cf_driver = {
 	},
 };
 
-static int __init arasan_cf_init(void)
-{
-	return platform_driver_register(&arasan_cf_driver);
-}
-module_init(arasan_cf_init);
-
-static void __exit arasan_cf_exit(void)
-{
-	platform_driver_unregister(&arasan_cf_driver);
-}
-module_exit(arasan_cf_exit);
+module_platform_driver(arasan_cf_driver);
 
 MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
 MODULE_DESCRIPTION("Arasan ATA Compact Flash driver");
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index a76f24a..d56dd45 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -454,20 +454,7 @@ static struct platform_driver pata_at91_driver = {
 	},
 };
 
-static int __init pata_at91_init(void)
-{
-	return platform_driver_register(&pata_at91_driver);
-}
-
-static void __exit pata_at91_exit(void)
-{
-	platform_driver_unregister(&pata_at91_driver);
-}
-
-
-module_init(pata_at91_init);
-module_exit(pata_at91_exit);
-
+module_platform_driver(pata_at91_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Driver for CF in True IDE mode on AT91SAM9260 SoC");
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index bd987bb..d6a4677 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -418,14 +418,6 @@ static void bfin_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 					(tcyc_tdvs<<8 | tdvs));
 				ATAPI_SET_ULTRA_TIM_2(base, (tmli<<8 | tss));
 				ATAPI_SET_ULTRA_TIM_3(base, (trp<<8 | tzah));
-
-				/* Enable host ATAPI Untra DMA interrupts */
-				ATAPI_SET_INT_MASK(base,
-					ATAPI_GET_INT_MASK(base)
-					| UDMAIN_DONE_MASK
-					| UDMAOUT_DONE_MASK
-					| UDMAIN_TERM_MASK
-					| UDMAOUT_TERM_MASK);
 			}
 		}
 	}
@@ -470,10 +462,6 @@ static void bfin_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 			ATAPI_SET_MULTI_TIM_0(base, (tm<<8 | td));
 			ATAPI_SET_MULTI_TIM_1(base, (tkr<<8 | tkw));
 			ATAPI_SET_MULTI_TIM_2(base, (teoc<<8 | th));
-
-			/* Enable host ATAPI Multi DMA interrupts */
-			ATAPI_SET_INT_MASK(base, ATAPI_GET_INT_MASK(base)
-				| MULTI_DONE_MASK | MULTI_TERM_MASK);
 			SSYNC();
 		}
 	}
@@ -1153,15 +1141,11 @@ static unsigned char bfin_bmdma_status(struct ata_port *ap)
 {
 	unsigned char host_stat = 0;
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
-	unsigned short int_status = ATAPI_GET_INT_STATUS(base);
 
-	if (ATAPI_GET_STATUS(base) & (MULTI_XFER_ON|ULTRA_XFER_ON))
+	if (ATAPI_GET_STATUS(base) & (MULTI_XFER_ON | ULTRA_XFER_ON))
 		host_stat |= ATA_DMA_ACTIVE;
-	if (int_status & (MULTI_DONE_INT|UDMAIN_DONE_INT|UDMAOUT_DONE_INT|
-		ATAPI_DEV_INT))
+	if (ATAPI_GET_INT_STATUS(base) & ATAPI_DEV_INT)
 		host_stat |= ATA_DMA_INTR;
-	if (int_status & (MULTI_TERM_INT|UDMAIN_TERM_INT|UDMAOUT_TERM_INT))
-		host_stat |= ATA_DMA_ERR|ATA_DMA_INTR;
 
 	dev_dbg(ap->dev, "ATAPI: host_stat=0x%x\n", host_stat);
 
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 628c8fa..7a402c7 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -1,6 +1,7 @@
 /*
  * pata_cs5536.c	- CS5536 PATA for new ATA layer
  *			  (C) 2007 Martin K. Petersen <mkp@mkp.net>
+ *			  (C) 2011 Bartlomiej Zolnierkiewicz
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -55,24 +56,16 @@ MODULE_PARM_DESC(msr, "Force using MSR to configure IDE function (Default: 0)");
 #define DRV_VERSION	"0.0.8"
 
 enum {
-	CFG			= 0,
-	DTC			= 1,
-	CAST			= 2,
-	ETC			= 3,
-
-	MSR_IDE_BASE		= 0x51300000,
-	MSR_IDE_CFG		= (MSR_IDE_BASE + 0x10),
-	MSR_IDE_DTC		= (MSR_IDE_BASE + 0x12),
-	MSR_IDE_CAST		= (MSR_IDE_BASE + 0x13),
-	MSR_IDE_ETC		= (MSR_IDE_BASE + 0x14),
-
+	MSR_IDE_CFG		= 0x51300010,
 	PCI_IDE_CFG		= 0x40,
-	PCI_IDE_DTC		= 0x48,
-	PCI_IDE_CAST		= 0x4c,
-	PCI_IDE_ETC		= 0x50,
 
-	IDE_CFG_CHANEN		= 0x2,
-	IDE_CFG_CABLE		= 0x10000,
+	CFG			= 0,
+	DTC			= 2,
+	CAST			= 3,
+	ETC			= 4,
+
+	IDE_CFG_CHANEN		= (1 << 1),
+	IDE_CFG_CABLE		= (1 << 17) | (1 << 16),
 
 	IDE_D0_SHIFT		= 24,
 	IDE_D1_SHIFT		= 16,
@@ -84,45 +77,50 @@ enum {
 	IDE_CAST_CMD_MASK	= 0xff,
 	IDE_CAST_CMD_SHIFT	= 24,
 
-	IDE_ETC_NODMA		= 0x03,
-};
-
-static const u32 msr_reg[4] = {
-	MSR_IDE_CFG, MSR_IDE_DTC, MSR_IDE_CAST, MSR_IDE_ETC,
-};
-
-static const u8 pci_reg[4] = {
-	PCI_IDE_CFG, PCI_IDE_DTC, PCI_IDE_CAST, PCI_IDE_ETC,
+	IDE_ETC_UDMA_MASK	= 0xc0,
 };
 
-static inline int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
+static int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
 {
 	if (unlikely(use_msr)) {
 		u32 dummy __maybe_unused;
 
-		rdmsr(msr_reg[reg], *val, dummy);
+		rdmsr(MSR_IDE_CFG + reg, *val, dummy);
 		return 0;
 	}
 
-	return pci_read_config_dword(pdev, pci_reg[reg], val);
+	return pci_read_config_dword(pdev, PCI_IDE_CFG + reg * 4, val);
 }
 
-static inline int cs5536_write(struct pci_dev *pdev, int reg, int val)
+static int cs5536_write(struct pci_dev *pdev, int reg, int val)
 {
 	if (unlikely(use_msr)) {
-		wrmsr(msr_reg[reg], val, 0);
+		wrmsr(MSR_IDE_CFG + reg, val, 0);
 		return 0;
 	}
 
-	return pci_write_config_dword(pdev, pci_reg[reg], val);
+	return pci_write_config_dword(pdev, PCI_IDE_CFG + reg * 4, val);
+}
+
+static void cs5536_program_dtc(struct ata_device *adev, u8 tim)
+{
+	struct pci_dev *pdev = to_pci_dev(adev->link->ap->host->dev);
+	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	u32 dtc;
+
+	cs5536_read(pdev, DTC, &dtc);
+	dtc &= ~(IDE_DRV_MASK << dshift);
+	dtc |= tim << dshift;
+	cs5536_write(pdev, DTC, dtc);
 }
 
 /**
  *	cs5536_cable_detect	-	detect cable type
  *	@ap: Port to detect on
  *
- *	Perform cable detection for ATA66 capable cable. Return a libata
- *	cable type.
+ *	Perform cable detection for ATA66 capable cable.
+ *
+ *	Returns a cable type.
  */
 
 static int cs5536_cable_detect(struct ata_port *ap)
@@ -132,7 +130,7 @@ static int cs5536_cable_detect(struct ata_port *ap)
 
 	cs5536_read(pdev, CFG, &cfg);
 
-	if (cfg & (IDE_CFG_CABLE << ap->port_no))
+	if (cfg & IDE_CFG_CABLE)
 		return ATA_CBL_PATA80;
 	else
 		return ATA_CBL_PATA40;
@@ -162,19 +160,15 @@ static void cs5536_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	struct ata_device *pair = ata_dev_pair(adev);
 	int mode = adev->pio_mode - XFER_PIO_0;
 	int cmdmode = mode;
-	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
 	int cshift = adev->devno ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
-	u32 dtc, cast, etc;
+	u32 cast;
 
 	if (pair)
 		cmdmode = min(mode, pair->pio_mode - XFER_PIO_0);
 
-	cs5536_read(pdev, DTC, &dtc);
-	cs5536_read(pdev, CAST, &cast);
-	cs5536_read(pdev, ETC, &etc);
+	cs5536_program_dtc(adev, drv_timings[mode]);
 
-	dtc &= ~(IDE_DRV_MASK << dshift);
-	dtc |= drv_timings[mode] << dshift;
+	cs5536_read(pdev, CAST, &cast);
 
 	cast &= ~(IDE_CAST_DRV_MASK << cshift);
 	cast |= addr_timings[mode] << cshift;
@@ -182,12 +176,7 @@ static void cs5536_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	cast &= ~(IDE_CAST_CMD_MASK << IDE_CAST_CMD_SHIFT);
 	cast |= cmd_timings[cmdmode] << IDE_CAST_CMD_SHIFT;
 
-	etc &= ~(IDE_DRV_MASK << dshift);
-	etc |= IDE_ETC_NODMA << dshift;
-
-	cs5536_write(pdev, DTC, dtc);
 	cs5536_write(pdev, CAST, cast);
-	cs5536_write(pdev, ETC, etc);
 }
 
 /**
@@ -208,25 +197,21 @@ static void cs5536_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	};
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 dtc, etc;
+	u32 etc;
 	int mode = adev->dma_mode;
 	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
 
-	if (mode >= XFER_UDMA_0) {
-		cs5536_read(pdev, ETC, &etc);
+	cs5536_read(pdev, ETC, &etc);
 
+	if (mode >= XFER_UDMA_0) {
 		etc &= ~(IDE_DRV_MASK << dshift);
 		etc |= udma_timings[mode - XFER_UDMA_0] << dshift;
-
-		cs5536_write(pdev, ETC, etc);
 	} else { /* MWDMA */
-		cs5536_read(pdev, DTC, &dtc);
-
-		dtc &= ~(IDE_DRV_MASK << dshift);
-		dtc |= mwdma_timings[mode - XFER_MW_DMA_0] << dshift;
-
-		cs5536_write(pdev, DTC, dtc);
+		etc &= ~(IDE_ETC_UDMA_MASK << dshift);
+		cs5536_program_dtc(adev, mwdma_timings[mode - XFER_MW_DMA_0]);
 	}
+
+	cs5536_write(pdev, ETC, etc);
 }
 
 static struct scsi_host_template cs5536_sht = {
diff --git a/drivers/ata/pata_imx.c b/drivers/ata/pata_imx.c
index ca9d9ca..c5af97f 100644
--- a/drivers/ata/pata_imx.c
+++ b/drivers/ata/pata_imx.c
@@ -235,17 +235,7 @@ static struct platform_driver pata_imx_driver = {
 	},
 };
 
-static int __init pata_imx_init(void)
-{
-	return platform_driver_register(&pata_imx_driver);
-}
-
-static void __exit pata_imx_exit(void)
-{
-	platform_driver_unregister(&pata_imx_driver);
-}
-module_init(pata_imx_init);
-module_exit(pata_imx_exit);
+module_platform_driver(pata_imx_driver);
 
 MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("low-level driver for iMX PATA");
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 15b6431..badb178 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -205,21 +205,10 @@ static struct platform_driver ixp4xx_pata_platform_driver = {
 	.remove		= __devexit_p(ixp4xx_pata_remove),
 };
 
-static int __init ixp4xx_pata_init(void)
-{
-	return platform_driver_register(&ixp4xx_pata_platform_driver);
-}
-
-static void __exit ixp4xx_pata_exit(void)
-{
-	platform_driver_unregister(&ixp4xx_pata_platform_driver);
-}
+module_platform_driver(ixp4xx_pata_platform_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("low-level driver for ixp4xx Compact Flash PATA");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:" DRV_NAME);
-
-module_init(ixp4xx_pata_init);
-module_exit(ixp4xx_pata_exit);
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 3e17463..00748ae 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -897,26 +897,7 @@ static struct platform_driver mpc52xx_ata_of_platform_driver = {
 	},
 };
 
-
-/* ======================================================================== */
-/* Module                                                                   */
-/* ======================================================================== */
-
-static int __init
-mpc52xx_ata_init(void)
-{
-	printk(KERN_INFO "ata: MPC52xx IDE/ATA libata driver\n");
-	return platform_driver_register(&mpc52xx_ata_of_platform_driver);
-}
-
-static void __exit
-mpc52xx_ata_exit(void)
-{
-	platform_driver_unregister(&mpc52xx_ata_of_platform_driver);
-}
-
-module_init(mpc52xx_ata_init);
-module_exit(mpc52xx_ata_exit);
+module_platform_driver(mpc52xx_ata_of_platform_driver);
 
 MODULE_AUTHOR("Sylvain Munaut <tnt@246tNt.com>");
 MODULE_DESCRIPTION("Freescale MPC52xx IDE/ATA libata driver");
diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index 2a472c5..1654dc2 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -12,8 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/of_platform.h>
+#include <linux/platform_device.h>
 #include <linux/ata_platform.h>
 
 static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
@@ -22,7 +21,7 @@ static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
 	struct device_node *dn = ofdev->dev.of_node;
 	struct resource io_res;
 	struct resource ctl_res;
-	struct resource irq_res;
+	struct resource *irq_res;
 	unsigned int reg_shift = 0;
 	int pio_mode = 0;
 	int pio_mask;
@@ -51,11 +50,9 @@ static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
 		}
 	}
 
-	ret = of_irq_to_resource(dn, 0, &irq_res);
-	if (!ret)
-		irq_res.start = irq_res.end = 0;
-	else
-		irq_res.flags = 0;
+	irq_res = platform_get_resource(ofdev, IORESOURCE_IRQ, 0);
+	if (irq_res)
+		irq_res->flags = 0;
 
 	prop = of_get_property(dn, "reg-shift", NULL);
 	if (prop)
@@ -75,7 +72,7 @@ static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
 	pio_mask = 1 << pio_mode;
 	pio_mask |= (1 << pio_mode) - 1;
 
-	return __pata_platform_probe(&ofdev->dev, &io_res, &ctl_res, &irq_res,
+	return __pata_platform_probe(&ofdev->dev, &io_res, &ctl_res, irq_res,
 				     reg_shift, pio_mask);
 }
 
@@ -101,17 +98,7 @@ static struct platform_driver pata_of_platform_driver = {
 	.remove		= __devexit_p(pata_of_platform_remove),
 };
 
-static int __init pata_of_platform_init(void)
-{
-	return platform_driver_register(&pata_of_platform_driver);
-}
-module_init(pata_of_platform_init);
-
-static void __exit pata_of_platform_exit(void)
-{
-	platform_driver_unregister(&pata_of_platform_driver);
-}
-module_exit(pata_of_platform_exit);
+module_platform_driver(pata_of_platform_driver);
 
 MODULE_DESCRIPTION("OF-platform PATA driver");
 MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
diff --git a/drivers/ata/pata_palmld.c b/drivers/ata/pata_palmld.c
index b86d7e2..5ff31b6 100644
--- a/drivers/ata/pata_palmld.c
+++ b/drivers/ata/pata_palmld.c
@@ -132,20 +132,9 @@ static struct platform_driver palmld_pata_platform_driver = {
 	.remove		= __devexit_p(palmld_pata_remove),
 };
 
-static int __init palmld_pata_init(void)
-{
-	return platform_driver_register(&palmld_pata_platform_driver);
-}
-
-static void __exit palmld_pata_exit(void)
-{
-	platform_driver_unregister(&palmld_pata_platform_driver);
-}
+module_platform_driver(palmld_pata_platform_driver);
 
 MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
 MODULE_DESCRIPTION("PalmLD PATA driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRV_NAME);
-
-module_init(palmld_pata_init);
-module_exit(palmld_pata_exit);
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 2067308..f1848ae 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -256,17 +256,7 @@ static struct platform_driver pata_platform_driver = {
 	},
 };
 
-static int __init pata_platform_init(void)
-{
-	return platform_driver_register(&pata_platform_driver);
-}
-
-static void __exit pata_platform_exit(void)
-{
-	platform_driver_unregister(&pata_platform_driver);
-}
-module_init(pata_platform_init);
-module_exit(pata_platform_exit);
+module_platform_driver(pata_platform_driver);
 
 module_param(pio_mask, int, 0);
 
diff --git a/drivers/ata/pata_pxa.c b/drivers/ata/pata_pxa.c
index b4ede40..0bb0fb7 100644
--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -390,18 +390,7 @@ static struct platform_driver pxa_ata_driver = {
 	},
 };
 
-static int __init pxa_ata_init(void)
-{
-	return platform_driver_register(&pxa_ata_driver);
-}
-
-static void __exit pxa_ata_exit(void)
-{
-	platform_driver_unregister(&pxa_ata_driver);
-}
-
-module_init(pxa_ata_init);
-module_exit(pxa_ata_exit);
+module_platform_driver(pxa_ata_driver);
 
 MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
 MODULE_DESCRIPTION("DMA-capable driver for PATA on PXA CPU");
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index 1b9d10d..9417101 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -188,9 +188,6 @@ static __devexit int rb532_pata_driver_remove(struct platform_device *pdev)
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:" DRV_NAME);
-
 static struct platform_driver rb532_pata_platform_driver = {
 	.probe		= rb532_pata_driver_probe,
 	.remove		= __devexit_p(rb532_pata_driver_remove),
@@ -200,27 +197,13 @@ static struct platform_driver rb532_pata_platform_driver = {
 	},
 };
 
-/* ------------------------------------------------------------------------ */
-
 #define DRV_INFO DRV_DESC " version " DRV_VERSION
 
-static int __init rb532_pata_module_init(void)
-{
-	printk(KERN_INFO DRV_INFO "\n");
-
-	return platform_driver_register(&rb532_pata_platform_driver);
-}
-
-static void __exit rb532_pata_module_exit(void)
-{
-	platform_driver_unregister(&rb532_pata_platform_driver);
-}
+module_platform_driver(rb532_pata_platform_driver);
 
 MODULE_AUTHOR("Gabor Juhos <juhosg at openwrt.org>");
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
-
-module_init(rb532_pata_module_init);
-module_exit(rb532_pata_module_exit);
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 5c42374..69f7cde 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1777,18 +1777,7 @@ static struct platform_driver sata_dwc_driver = {
 	.remove = sata_dwc_remove,
 };
 
-static int __init sata_dwc_init(void)
-{
-	return platform_driver_register(&sata_dwc_driver);
-}
-
-static void __exit sata_dwc_exit(void)
-{
-	platform_driver_unregister(&sata_dwc_driver);
-}
-
-module_init(sata_dwc_init);
-module_exit(sata_dwc_exit);
+module_platform_driver(sata_dwc_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mark Miesfeld <mmiesfeld@amcc.com>");
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 78ae7b6..5a2c95b 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1452,21 +1452,9 @@ static struct platform_driver fsl_sata_driver = {
 #endif
 };
 
-static int __init sata_fsl_init(void)
-{
-	platform_driver_register(&fsl_sata_driver);
-	return 0;
-}
-
-static void __exit sata_fsl_exit(void)
-{
-	platform_driver_unregister(&fsl_sata_driver);
-}
+module_platform_driver(fsl_sata_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ashish Kalra, Freescale Semiconductor");
 MODULE_DESCRIPTION("Freescale 3.0Gbps SATA controller low level driver");
 MODULE_VERSION("1.10");
-
-module_init(sata_fsl_init);
-module_exit(sata_fsl_exit);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index dc6131e..5f84a14 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1812,7 +1812,7 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (scsi_autopm_get_host(shost) != 0) {
+		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				printk(KERN_ERR "Error handler scsi_eh_%d "
 						"unable to autoresume\n",
@@ -1833,7 +1833,8 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		scsi_autopm_put_host(shost);
+		if (!shost->eh_noresume)
+			scsi_autopm_put_host(shost);
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d329f8b..bf8bf79 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -49,8 +49,22 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		/*
+		 * sd is the only high-level SCSI driver to implement runtime
+		 * PM, and sd treats runtime suspend, system suspend, and
+		 * system hibernate identically (but not system freeze).
+		 */
+		if (pm_runtime_suspended(dev)) {
+			if (msg.event == PM_EVENT_SUSPEND ||
+			    msg.event == PM_EVENT_HIBERNATE)
+				return 0;	/* already suspended */
+
+			/* wake up device so that FREEZE will succeed */
+			pm_runtime_resume(dev);
+		}
 		err = scsi_dev_type_suspend(dev, msg);
+	}
 	return err;
 }
 
@@ -58,8 +72,17 @@ static int scsi_bus_resume_common(struct device *dev)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		/*
+		 * Parent device may have runtime suspended as soon as
+		 * it is woken up during the system resume.
+		 *
+		 * Resume it on behalf of child.
+		 */
+		pm_runtime_get_sync(dev->parent);
 		err = scsi_dev_type_resume(dev);
+		pm_runtime_put_sync(dev->parent);
+	}
 
 	if (err == 0) {
 		pm_runtime_disable(dev);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..7b3f807 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -2741,6 +2742,9 @@ static void sd_shutdown(struct device *dev)
 	if (!sdkp)
 		return;         /* this can happen */
 
+	if (pm_runtime_suspended(dev))
+		goto exit;
+
 	if (sdkp->WCE) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp);
@@ -2751,6 +2755,7 @@ static void sd_shutdown(struct device *dev)
 		sd_start_stop_device(sdkp, 0);
 	}
 
+exit:
 	scsi_disk_put(sdkp);
 }
 
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
index be3d9a7..73a2500 100644
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -23,6 +23,8 @@ struct ata_port_info;
 struct ahci_platform_data {
 	int (*init)(struct device *dev, void __iomem *addr);
 	void (*exit)(struct device *dev);
+	int (*suspend)(struct device *dev);
+	int (*resume)(struct device *dev);
 	const struct ata_port_info *ata_port_info;
 	unsigned int force_port_map;
 	unsigned int mask_port_map;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 50266c9..5f7d5b3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -669,6 +669,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
+	/* Don't resume host in EH */
+	unsigned eh_noresume:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
