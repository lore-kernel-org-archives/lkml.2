Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1COIVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:21:37 -0400
Received: from havoc.gtf.org ([69.61.125.42]:50393 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab1COIV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:21:26 -0400
X-Greylist: delayed 1144 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Mar 2011 04:21:25 EDT
Date: Tue, 15 Mar 2011 04:02:06 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 2.6.39
Message-ID: <20110315080206.GA15694@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Notable hotplug fix from Tejun (going straight to @stable...)

2) libata EH improvements for SAS (some of these might come via
   James' tree also)

3) bool-ify linux/ata.h

4) new driver pata_arasan_cf

5) other minor fixes, cleanups and enhancements.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 MAINTAINERS                         |    7 +
 drivers/ata/Kconfig                 |   18 +
 drivers/ata/Makefile                |    1 +
 drivers/ata/ahci.c                  |    8 +-
 drivers/ata/ahci.h                  |    6 +-
 drivers/ata/ata_generic.c           |    2 +-
 drivers/ata/ata_piix.c              |    2 +-
 drivers/ata/libata-acpi.c           |    3 +-
 drivers/ata/libata-core.c           |   54 +-
 drivers/ata/libata-eh.c             |   60 ++-
 drivers/ata/libata-scsi.c           |   15 +-
 drivers/ata/libata-sff.c            |   17 +-
 drivers/ata/libata.h                |    1 +
 drivers/ata/pata_acpi.c             |    2 +-
 drivers/ata/pata_arasan_cf.c        |  983 +++++++++++++++++++++++++++++++++++
 drivers/ata/pata_at32.c             |    2 +-
 drivers/ata/pata_bf54x.c            |    4 +-
 drivers/ata/pata_hpt366.c           |    7 +-
 drivers/ata/pata_hpt37x.c           |   23 +-
 drivers/ata/pata_hpt3x2n.c          |   13 +-
 drivers/ata/pata_hpt3x3.c           |    2 +-
 drivers/ata/pata_it821x.c           |    4 +-
 drivers/ata/pata_ixp4xx_cf.c        |    2 +-
 drivers/ata/pata_macio.c            |    3 +-
 drivers/ata/pata_marvell.c          |    2 +-
 drivers/ata/pata_ninja32.c          |    2 +-
 drivers/ata/pata_octeon_cf.c        |    3 +-
 drivers/ata/pata_palmld.c           |    2 +-
 drivers/ata/pata_pcmcia.c           |    2 +-
 drivers/ata/pata_pdc2027x.c         |    6 +-
 drivers/ata/pata_pxa.c              |    1 -
 drivers/ata/pata_rb532_cf.c         |    1 -
 drivers/ata/pata_samsung_cf.c       |    1 -
 drivers/ata/pata_scc.c              |    2 +-
 drivers/ata/pata_sis.c              |    2 +-
 drivers/ata/pdc_adma.c              |    4 +-
 drivers/ata/sata_dwc_460ex.c        |   75 ++-
 drivers/ata/sata_fsl.c              |   22 +-
 drivers/ata/sata_mv.c               |    3 +-
 drivers/ata/sata_nv.c               |   14 +-
 drivers/ata/sata_promise.c          |    4 +-
 drivers/ata/sata_qstor.c            |    3 +-
 drivers/ata/sata_sil.c              |    3 +-
 drivers/ata/sata_sil24.c            |    3 +-
 drivers/ata/sata_sis.c              |    2 +-
 drivers/ata/sata_svw.c              |   12 +-
 drivers/ata/sata_sx4.c              |    5 +-
 drivers/ata/sata_uli.c              |    3 +-
 drivers/ata/sata_via.c              |    9 +-
 drivers/ata/sata_vsc.c              |    3 +-
 drivers/scsi/ipr.c                  |    9 +-
 drivers/scsi/libsas/sas_ata.c       |   94 +++-
 drivers/scsi/libsas/sas_scsi_host.c |   14 +-
 include/linux/ata.h                 |  163 +++---
 include/linux/libata.h              |   10 +-
 include/linux/pata_arasan_cf_data.h |   49 ++
 include/scsi/sas_ata.h              |   22 +
 57 files changed, 1521 insertions(+), 268 deletions(-)
 create mode 100644 drivers/ata/pata_arasan_cf.c
 create mode 100644 include/linux/pata_arasan_cf_data.h

Hannes Reinecke (2):
      libata: Include WWN ID in inquiry VPD emulation
      libata: Use 'bool' return value for ata_id_XXX

James Bottomley (5):
      libata: plumb sas port scan into standard libata paths
      libata: fix locking for sas paths
      libata: fix eh locking
      libata: separate error handler into usable components
      libsas: convert to libata new error handler

Jeff Garzik (2):
      [libata] trivial: trim trailing whitespace for drivers/ata/*.[ch]
      pata_arasan_cf: fix printk format string warning

Joe Perches (1):
      ata: pata: Convert pr_*(DRV_NAME ...) to pr_fmt/pr_<level>

Per Jessen (1):
      ahci: recognize Marvell 88se9125 PCIe SATA 6.0 Gb/s controller

Prabhakar Kushwaha (2):
      sata_fsl: Fix wrong Device Error Register usage
      sata_fsl: Update RX_WATER_MARK for TRANSCFG

Sergei Shtylyov (10):
      sata_dwc_460ex: use ATA_PIO4
      sata_dwc_460ex: fix compilation errors/warnings
      sata_dwc_460ex: fix return value of dma_dwc_xfer_setup()
      sata_dwc_460ex: fix misuse of ata_get_cmd_descript()
      sata_dwc_460ex: add debugging options
      ipr/sas_ata: use mode mask macros from <linux/ata.h>
      libata: remove ATA_FLAG_{SRST|SATA_RESET}
      libata: remove ATA_FLAG_MMIO
      libata: remove ATA_FLAG_NO_LEGACY
      libata: remove ATA_FLAG_LPM

Seth Heasley (1):
      ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller

Tejun Heo (2):
      libata: fix hotplug for drivers which don't implement LPM
      ahci: add another PCI ID for marvell

Viresh Kumar (3):
      libata-sff: add ata_sff_queue_work() & ata_sff_queue_delayed_work()
      pata_arasan_cf: Adding support for arasan compact flash host controller
      ata/pata_arasan_cf: fill dma chan->private from pdata->dma_priv

diff --git a/MAINTAINERS b/MAINTAINERS
index 8afba63..3f4b3f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -557,6 +557,13 @@ S:	Maintained
 F:	drivers/net/appletalk/
 F:	net/appletalk/
 
+ARASAN COMPACT FLASH PATA CONTROLLER
+M:	Viresh Kumar <viresh.kumar@st.com>
+L:	linux-ide@vger.kernel.org
+S:	Maintained
+F:	include/linux/pata_arasan_cf_data.h
+F:	drivers/ata/pata_arasan_cf.c
+
 ARC FRAMEBUFFER DRIVER
 M:	Jaya Kumar <jayalk@intworks.biz>
 S:	Maintained
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index c2328ae..75afa75 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -202,6 +202,18 @@ config SATA_DWC
 
 	  If unsure, say N.
 
+config SATA_DWC_DEBUG
+	bool "Debugging driver version"
+	depends on SATA_DWC
+	help
+	  This option enables debugging output in the driver.
+
+config SATA_DWC_VDEBUG
+	bool "Verbose debug output"
+	depends on SATA_DWC_DEBUG
+	help
+	  This option enables the taskfile dumping and NCQ debugging.
+
 config SATA_MV
 	tristate "Marvell SATA support"
 	help
@@ -299,6 +311,12 @@ config PATA_AMD
 
 	  If unsure, say N.
 
+config PATA_ARASAN_CF
+	tristate "ARASAN CompactFlash PATA Controller Support"
+	select DMA_ENGINE
+	help
+	  Say Y here to support the ARASAN CompactFlash PATA controller
+
 config PATA_ARTOP
 	tristate "ARTOP 6210/6260 PATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 27291aa..8ac64e1 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
+obj-$(CONFIG_PATA_ARASAN_CF)	+= pata_arasan_cf.o
 obj-$(CONFIG_PATA_OCTEON_CF)	+= pata_octeon_cf.o
 obj-$(CONFIG_SATA_QSTOR)	+= sata_qstor.o
 obj-$(CONFIG_SATA_SX4)		+= sata_sx4.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index b8d96ce..e62f693 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -175,8 +175,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
 				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
@@ -260,6 +259,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
 	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2826), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
@@ -383,6 +383,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .class = PCI_CLASS_STORAGE_SATA_AHCI,
 	  .class_mask = 0xffffff,
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
+	{ PCI_DEVICE(0x1b4b, 0x9125),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
+	{ PCI_DEVICE(0x1b4b, 0x91a3),
+	  .driver_data = board_ahci_yes_fbs },
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 3e606c3..ccaf081 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -213,10 +213,8 @@ enum {
 
 	/* ap->flags bits */
 
-	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
-					  ATA_FLAG_LPM,
+	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA |
+					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN,
 
 	ICH_MAP				= 0x90, /* ICH MAP register */
 
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 6981f76..721d38b 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -237,7 +237,7 @@ static struct pci_device_id ata_generic[] = {
 #endif
 	/* Intel, IDE class device */
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 
+	  PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL,
 	  .driver_data = ATA_GEN_INTEL_IDER },
 	/* Must come last. If you add entries adjust this table appropriately */
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL),
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6cb14ca..cdec4ab 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -230,7 +230,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 
 	/* SATA ports */
-	
+
 	/* 82801EB (ICH5) */
 	{ 0x8086, 0x24d1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich5_sata },
 	/* 82801EB (ICH5) */
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 8b5ea39..a791b8ce 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -660,8 +660,7 @@ static int ata_acpi_filter_tf(struct ata_device *dev,
  * @dev: target ATA device
  * @gtf: raw ATA taskfile register set (0x1f1 - 0x1f7)
  *
- * Outputs ATA taskfile to standard ATA host controller using MMIO
- * or PIO as indicated by the ATA_FLAG_MMIO flag.
+ * Outputs ATA taskfile to standard ATA host controller.
  * Writes the control, feature, nsect, lbal, lbam, and lbah registers.
  * Optionally (ATA_TFLAG_LBA48) writes hob_feature, hob_nsect,
  * hob_lbal, hob_lbam, and hob_lbah.
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d4e52e2..b91e19c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4210,7 +4210,7 @@ static int glob_match (const char *text, const char *pattern)
 		return 0;  /* End of both strings: match */
 	return 1;  /* No match */
 }
- 
+
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev)
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
@@ -5479,7 +5479,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
 	if (!ap)
 		return NULL;
-	
+
 	ap->pflags |= ATA_PFLAG_INITIALIZING;
 	ap->lock = &host->lock;
 	ap->print_id = -1;
@@ -5887,21 +5887,9 @@ void ata_host_init(struct ata_host *host, struct device *dev,
 	host->ops = ops;
 }
 
-
-static void async_port_probe(void *data, async_cookie_t cookie)
+int ata_port_probe(struct ata_port *ap)
 {
-	int rc;
-	struct ata_port *ap = data;
-
-	/*
-	 * If we're not allowed to scan this host in parallel,
-	 * we need to wait until all previous scans have completed
-	 * before going further.
-	 * Jeff Garzik says this is only within a controller, so we
-	 * don't need to wait for port 0, only for later ports.
-	 */
-	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN) && ap->port_no != 0)
-		async_synchronize_cookie(cookie);
+	int rc = 0;
 
 	/* probe */
 	if (ap->ops->error_handler) {
@@ -5927,23 +5915,33 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 		DPRINTK("ata%u: bus probe begin\n", ap->print_id);
 		rc = ata_bus_probe(ap);
 		DPRINTK("ata%u: bus probe end\n", ap->print_id);
-
-		if (rc) {
-			/* FIXME: do something useful here?
-			 * Current libata behavior will
-			 * tear down everything when
-			 * the module is removed
-			 * or the h/w is unplugged.
-			 */
-		}
 	}
+	return rc;
+}
+
+
+static void async_port_probe(void *data, async_cookie_t cookie)
+{
+	struct ata_port *ap = data;
+
+	/*
+	 * If we're not allowed to scan this host in parallel,
+	 * we need to wait until all previous scans have completed
+	 * before going further.
+	 * Jeff Garzik says this is only within a controller, so we
+	 * don't need to wait for port 0, only for later ports.
+	 */
+	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN) && ap->port_no != 0)
+		async_synchronize_cookie(cookie);
+
+	(void)ata_port_probe(ap);
 
 	/* in order to keep device order, we need to synchronize at this point */
 	async_synchronize_cookie(cookie);
 
 	ata_scsi_scan_host(ap, 1);
-
 }
+
 /**
  *	ata_host_register - register initialized ATA host
  *	@host: ATA host to register
@@ -5983,7 +5981,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	for (i = 0; i < host->n_ports; i++)
 		host->ports[i]->print_id = ata_print_id++;
 
-	
+
 	/* Create associated sysfs transport objects  */
 	for (i = 0; i < host->n_ports; i++) {
 		rc = ata_tport_add(host->dev,host->ports[i]);
@@ -6471,7 +6469,7 @@ static int __init ata_init(void)
 		ata_sff_exit();
 		rc = -ENOMEM;
 		goto err_out;
-	}		
+	}
 
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 17a6378..df3f314 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -587,11 +587,43 @@ static void ata_eh_unload(struct ata_port *ap)
 void ata_scsi_error(struct Scsi_Host *host)
 {
 	struct ata_port *ap = ata_shost_to_port(host);
-	int i;
 	unsigned long flags;
+	LIST_HEAD(eh_work_q);
 
 	DPRINTK("ENTER\n");
 
+	spin_lock_irqsave(host->host_lock, flags);
+	list_splice_init(&host->eh_cmd_q, &eh_work_q);
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	ata_scsi_cmd_error_handler(host, ap, &eh_work_q);
+
+	/* If we timed raced normal completion and there is nothing to
+	   recover nr_timedout == 0 why exactly are we doing error recovery ? */
+	ata_scsi_port_error_handler(host, ap);
+
+	/* finish or retry handled scmd's and clean up */
+	WARN_ON(host->host_failed || !list_empty(&eh_work_q));
+
+	DPRINTK("EXIT\n");
+}
+
+/**
+ * ata_scsi_cmd_error_handler - error callback for a list of commands
+ * @host:	scsi host containing the port
+ * @ap:		ATA port within the host
+ * @eh_work_q:	list of commands to process
+ *
+ * process the given list of commands and return those finished to the
+ * ap->eh_done_q.  This function is the first part of the libata error
+ * handler which processes a given list of failed commands.
+ */
+void ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap,
+				struct list_head *eh_work_q)
+{
+	int i;
+	unsigned long flags;
+
 	/* make sure sff pio task is not running */
 	ata_sff_flush_pio_task(ap);
 
@@ -627,7 +659,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 		if (ap->ops->lost_interrupt)
 			ap->ops->lost_interrupt(ap);
 
-		list_for_each_entry_safe(scmd, tmp, &host->eh_cmd_q, eh_entry) {
+		list_for_each_entry_safe(scmd, tmp, eh_work_q, eh_entry) {
 			struct ata_queued_cmd *qc;
 
 			for (i = 0; i < ATA_MAX_QUEUE; i++) {
@@ -671,8 +703,20 @@ void ata_scsi_error(struct Scsi_Host *host)
 	} else
 		spin_unlock_wait(ap->lock);
 
-	/* If we timed raced normal completion and there is nothing to
-	   recover nr_timedout == 0 why exactly are we doing error recovery ? */
+}
+EXPORT_SYMBOL(ata_scsi_cmd_error_handler);
+
+/**
+ * ata_scsi_port_error_handler - recover the port after the commands
+ * @host:	SCSI host containing the port
+ * @ap:		the ATA port
+ *
+ * Handle the recovery of the port @ap after all the commands
+ * have been recovered.
+ */
+void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
+{
+	unsigned long flags;
 
 	/* invoke error handler */
 	if (ap->ops->error_handler) {
@@ -761,9 +805,6 @@ void ata_scsi_error(struct Scsi_Host *host)
 		ap->ops->eng_timeout(ap);
 	}
 
-	/* finish or retry handled scmd's and clean up */
-	WARN_ON(host->host_failed || !list_empty(&host->eh_cmd_q));
-
 	scsi_eh_flush_done_q(&ap->eh_done_q);
 
 	/* clean up */
@@ -784,9 +825,8 @@ void ata_scsi_error(struct Scsi_Host *host)
 	wake_up_all(&ap->eh_wait_q);
 
 	spin_unlock_irqrestore(ap->lock, flags);
-
-	DPRINTK("EXIT\n");
 }
+EXPORT_SYMBOL_GPL(ata_scsi_port_error_handler);
 
 /**
  *	ata_port_wait_eh - Wait for the currently pending EH to complete
@@ -1618,7 +1658,7 @@ static void ata_eh_analyze_serror(struct ata_link *link)
 	 * host links.  For disabled PMP links, only N bit is
 	 * considered as X bit is left at 1 for link plugging.
 	 */
-	if (link->lpm_policy != ATA_LPM_MAX_POWER)
+	if (link->lpm_policy > ATA_LPM_MAX_POWER)
 		hotplug_mask = 0;	/* hotplug doesn't work w/ LPM */
 	else if (!(link->flags & ATA_LFLAG_DISABLED) || ata_is_host_link(link))
 		hotplug_mask = SERR_PHYRDY_CHG | SERR_DEV_XCHG;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 600f635..a834199 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2056,6 +2056,17 @@ static unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf)
 		      ATA_ID_SERNO_LEN);
 	num += ATA_ID_SERNO_LEN;
 
+	if (ata_id_has_wwn(args->id)) {
+		/* SAT defined lu world wide name */
+		/* piv=0, assoc=lu, code_set=binary, designator=NAA */
+		rbuf[num + 0] = 1;
+		rbuf[num + 1] = 3;
+		rbuf[num + 3] = ATA_ID_WWN_LEN;
+		num += 4;
+		ata_id_string(args->id, (unsigned char *) rbuf + num,
+			      ATA_ID_WWN, ATA_ID_WWN_LEN);
+		num += ATA_ID_WWN_LEN;
+	}
 	rbuf[3] = num - 4;    /* page len (assume less than 256 bytes) */
 	return 0;
 }
@@ -3759,7 +3770,7 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 		return NULL;
 
 	ap->port_no = 0;
-	ap->lock = shost->host_lock;
+	ap->lock = &host->lock;
 	ap->pio_mask = port_info->pio_mask;
 	ap->mwdma_mask = port_info->mwdma_mask;
 	ap->udma_mask = port_info->udma_mask;
@@ -3821,7 +3832,7 @@ int ata_sas_port_init(struct ata_port *ap)
 
 	if (!rc) {
 		ap->print_id = ata_print_id++;
-		rc = ata_bus_probe(ap);
+		rc = ata_port_probe(ap);
 	}
 
 	return rc;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index af6141b..cf7acbc 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1302,6 +1302,18 @@ fsm_start:
 }
 EXPORT_SYMBOL_GPL(ata_sff_hsm_move);
 
+void ata_sff_queue_work(struct work_struct *work)
+{
+	queue_work(ata_sff_wq, work);
+}
+EXPORT_SYMBOL_GPL(ata_sff_queue_work);
+
+void ata_sff_queue_delayed_work(struct delayed_work *dwork, unsigned long delay)
+{
+	queue_delayed_work(ata_sff_wq, dwork, delay);
+}
+EXPORT_SYMBOL_GPL(ata_sff_queue_delayed_work);
+
 void ata_sff_queue_pio_task(struct ata_link *link, unsigned long delay)
 {
 	struct ata_port *ap = link->ap;
@@ -1311,8 +1323,7 @@ void ata_sff_queue_pio_task(struct ata_link *link, unsigned long delay)
 	ap->sff_pio_task_link = link;
 
 	/* may fail if ata_sff_flush_pio_task() in progress */
-	queue_delayed_work(ata_sff_wq, &ap->sff_pio_task,
-			   msecs_to_jiffies(delay));
+	ata_sff_queue_delayed_work(&ap->sff_pio_task, msecs_to_jiffies(delay));
 }
 EXPORT_SYMBOL_GPL(ata_sff_queue_pio_task);
 
@@ -1336,7 +1347,7 @@ static void ata_sff_pio_task(struct work_struct *work)
 	u8 status;
 	int poll_next;
 
-	BUG_ON(ap->sff_pio_task_link == NULL); 
+	BUG_ON(ap->sff_pio_task_link == NULL);
 	/* qc can be NULL if timeout occurred */
 	qc = ata_qc_from_tag(ap, link->active_tag);
 	if (!qc) {
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index a9be110..773de97 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -103,6 +103,7 @@ extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern const char *sata_spd_string(unsigned int spd);
+extern int ata_port_probe(struct ata_port *ap);
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index c8d4703..91949d9 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -245,7 +245,7 @@ static struct ata_port_operations pacpi_ops = {
 static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
new file mode 100644
index 0000000..65cee74
--- /dev/null
+++ b/drivers/ata/pata_arasan_cf.c
@@ -0,0 +1,983 @@
+/*
+ * drivers/ata/pata_arasan_cf.c
+ *
+ * Arasan Compact Flash host controller source file
+ *
+ * Copyright (C) 2011 ST Microelectronics
+ * Viresh Kumar <viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+/*
+ * The Arasan CompactFlash Device Controller IP core has three basic modes of
+ * operation: PC card ATA using I/O mode, PC card ATA using memory mode, PC card
+ * ATA using true IDE modes. This driver supports only True IDE mode currently.
+ *
+ * Arasan CF Controller shares global irq register with Arasan XD Controller.
+ *
+ * Tested on arch/arm/mach-spear13xx
+ */
+
+#include <linux/ata.h>
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/libata.h>
+#include <linux/module.h>
+#include <linux/pata_arasan_cf_data.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+#define DRIVER_NAME	"arasan_cf"
+#define TIMEOUT		msecs_to_jiffies(3000)
+
+/* Registers */
+/* CompactFlash Interface Status */
+#define CFI_STS			0x000
+	#define STS_CHG				(1)
+	#define BIN_AUDIO_OUT			(1 << 1)
+	#define CARD_DETECT1			(1 << 2)
+	#define CARD_DETECT2			(1 << 3)
+	#define INP_ACK				(1 << 4)
+	#define CARD_READY			(1 << 5)
+	#define IO_READY			(1 << 6)
+	#define B16_IO_PORT_SEL			(1 << 7)
+/* IRQ */
+#define IRQ_STS			0x004
+/* Interrupt Enable */
+#define IRQ_EN			0x008
+	#define CARD_DETECT_IRQ			(1)
+	#define STATUS_CHNG_IRQ			(1 << 1)
+	#define MEM_MODE_IRQ			(1 << 2)
+	#define IO_MODE_IRQ			(1 << 3)
+	#define TRUE_IDE_MODE_IRQ		(1 << 8)
+	#define PIO_XFER_ERR_IRQ		(1 << 9)
+	#define BUF_AVAIL_IRQ			(1 << 10)
+	#define XFER_DONE_IRQ			(1 << 11)
+	#define IGNORED_IRQS	(STATUS_CHNG_IRQ | MEM_MODE_IRQ | IO_MODE_IRQ |\
+					TRUE_IDE_MODE_IRQ)
+	#define TRUE_IDE_IRQS	(CARD_DETECT_IRQ | PIO_XFER_ERR_IRQ |\
+					BUF_AVAIL_IRQ | XFER_DONE_IRQ)
+/* Operation Mode */
+#define OP_MODE			0x00C
+	#define CARD_MODE_MASK			(0x3)
+	#define MEM_MODE			(0x0)
+	#define IO_MODE				(0x1)
+	#define TRUE_IDE_MODE			(0x2)
+
+	#define CARD_TYPE_MASK			(1 << 2)
+	#define CF_CARD				(0)
+	#define CF_PLUS_CARD			(1 << 2)
+
+	#define CARD_RESET			(1 << 3)
+	#define CFHOST_ENB			(1 << 4)
+	#define OUTPUTS_TRISTATE		(1 << 5)
+	#define ULTRA_DMA_ENB			(1 << 8)
+	#define MULTI_WORD_DMA_ENB		(1 << 9)
+	#define DRQ_BLOCK_SIZE_MASK		(0x3 << 11)
+	#define DRQ_BLOCK_SIZE_512		(0)
+	#define DRQ_BLOCK_SIZE_1024		(1 << 11)
+	#define DRQ_BLOCK_SIZE_2048		(2 << 11)
+	#define DRQ_BLOCK_SIZE_4096		(3 << 11)
+/* CF Interface Clock Configuration */
+#define CLK_CFG			0x010
+	#define CF_IF_CLK_MASK			(0XF)
+/* CF Timing Mode Configuration */
+#define TM_CFG			0x014
+	#define MEM_MODE_TIMING_MASK		(0x3)
+	#define MEM_MODE_TIMING_250NS		(0x0)
+	#define MEM_MODE_TIMING_120NS		(0x1)
+	#define MEM_MODE_TIMING_100NS		(0x2)
+	#define MEM_MODE_TIMING_80NS		(0x3)
+
+	#define IO_MODE_TIMING_MASK		(0x3 << 2)
+	#define IO_MODE_TIMING_250NS		(0x0 << 2)
+	#define IO_MODE_TIMING_120NS		(0x1 << 2)
+	#define IO_MODE_TIMING_100NS		(0x2 << 2)
+	#define IO_MODE_TIMING_80NS		(0x3 << 2)
+
+	#define TRUEIDE_PIO_TIMING_MASK		(0x7 << 4)
+	#define TRUEIDE_PIO_TIMING_SHIFT	4
+
+	#define TRUEIDE_MWORD_DMA_TIMING_MASK	(0x7 << 7)
+	#define TRUEIDE_MWORD_DMA_TIMING_SHIFT	7
+
+	#define ULTRA_DMA_TIMING_MASK		(0x7 << 10)
+	#define ULTRA_DMA_TIMING_SHIFT		10
+/* CF Transfer Address */
+#define XFER_ADDR		0x014
+	#define XFER_ADDR_MASK			(0x7FF)
+	#define MAX_XFER_COUNT			0x20000u
+/* Transfer Control */
+#define XFER_CTR		0x01C
+	#define XFER_COUNT_MASK			(0x3FFFF)
+	#define ADDR_INC_DISABLE		(1 << 24)
+	#define XFER_WIDTH_MASK			(1 << 25)
+	#define XFER_WIDTH_8B			(0)
+	#define XFER_WIDTH_16B			(1 << 25)
+
+	#define MEM_TYPE_MASK			(1 << 26)
+	#define MEM_TYPE_COMMON			(0)
+	#define MEM_TYPE_ATTRIBUTE		(1 << 26)
+
+	#define MEM_IO_XFER_MASK		(1 << 27)
+	#define MEM_XFER			(0)
+	#define IO_XFER				(1 << 27)
+
+	#define DMA_XFER_MODE			(1 << 28)
+
+	#define AHB_BUS_NORMAL_PIO_OPRTN	(~(1 << 29))
+	#define XFER_DIR_MASK			(1 << 30)
+	#define XFER_READ			(0)
+	#define XFER_WRITE			(1 << 30)
+
+	#define XFER_START			(1 << 31)
+/* Write Data Port */
+#define WRITE_PORT		0x024
+/* Read Data Port */
+#define READ_PORT		0x028
+/* ATA Data Port */
+#define ATA_DATA_PORT		0x030
+	#define ATA_DATA_PORT_MASK		(0xFFFF)
+/* ATA Error/Features */
+#define ATA_ERR_FTR		0x034
+/* ATA Sector Count */
+#define ATA_SC			0x038
+/* ATA Sector Number */
+#define ATA_SN			0x03C
+/* ATA Cylinder Low */
+#define ATA_CL			0x040
+/* ATA Cylinder High */
+#define ATA_CH			0x044
+/* ATA Select Card/Head */
+#define ATA_SH			0x048
+/* ATA Status-Command */
+#define ATA_STS_CMD		0x04C
+/* ATA Alternate Status/Device Control */
+#define ATA_ASTS_DCTR		0x050
+/* Extended Write Data Port 0x200-0x3FC */
+#define EXT_WRITE_PORT		0x200
+/* Extended Read Data Port 0x400-0x5FC */
+#define EXT_READ_PORT		0x400
+	#define FIFO_SIZE	0x200u
+/* Global Interrupt Status */
+#define GIRQ_STS		0x800
+/* Global Interrupt Status enable */
+#define GIRQ_STS_EN		0x804
+/* Global Interrupt Signal enable */
+#define GIRQ_SGN_EN		0x808
+	#define GIRQ_CF		(1)
+	#define GIRQ_XD		(1 << 1)
+
+/* Compact Flash Controller Dev Structure */
+struct arasan_cf_dev {
+	/* pointer to ata_host structure */
+	struct ata_host *host;
+	/* clk structure, only if HAVE_CLK is defined */
+#ifdef CONFIG_HAVE_CLK
+	struct clk *clk;
+#endif
+
+	/* physical base address of controller */
+	dma_addr_t pbase;
+	/* virtual base address of controller */
+	void __iomem *vbase;
+	/* irq number*/
+	int irq;
+
+	/* status to be updated to framework regarding DMA transfer */
+	u8 dma_status;
+	/* Card is present or Not */
+	u8 card_present;
+
+	/* dma specific */
+	/* Completion for transfer complete interrupt from controller */
+	struct completion cf_completion;
+	/* Completion for DMA transfer complete. */
+	struct completion dma_completion;
+	/* Dma channel allocated */
+	struct dma_chan *dma_chan;
+	/* Mask for DMA transfers */
+	dma_cap_mask_t mask;
+	/* dma channel private data */
+	void *dma_priv;
+	/* DMA transfer work */
+	struct work_struct work;
+	/* DMA delayed finish work */
+	struct delayed_work dwork;
+	/* qc to be transferred using DMA */
+	struct ata_queued_cmd *qc;
+};
+
+static struct scsi_host_template arasan_cf_sht = {
+	ATA_BASE_SHT(DRIVER_NAME),
+	.sg_tablesize = SG_NONE,
+	.dma_boundary = 0xFFFFFFFFUL,
+};
+
+static void cf_dumpregs(struct arasan_cf_dev *acdev)
+{
+	struct device *dev = acdev->host->dev;
+
+	dev_dbg(dev, ": =========== REGISTER DUMP ===========");
+	dev_dbg(dev, ": CFI_STS: %x", readl(acdev->vbase + CFI_STS));
+	dev_dbg(dev, ": IRQ_STS: %x", readl(acdev->vbase + IRQ_STS));
+	dev_dbg(dev, ": IRQ_EN: %x", readl(acdev->vbase + IRQ_EN));
+	dev_dbg(dev, ": OP_MODE: %x", readl(acdev->vbase + OP_MODE));
+	dev_dbg(dev, ": CLK_CFG: %x", readl(acdev->vbase + CLK_CFG));
+	dev_dbg(dev, ": TM_CFG: %x", readl(acdev->vbase + TM_CFG));
+	dev_dbg(dev, ": XFER_CTR: %x", readl(acdev->vbase + XFER_CTR));
+	dev_dbg(dev, ": GIRQ_STS: %x", readl(acdev->vbase + GIRQ_STS));
+	dev_dbg(dev, ": GIRQ_STS_EN: %x", readl(acdev->vbase + GIRQ_STS_EN));
+	dev_dbg(dev, ": GIRQ_SGN_EN: %x", readl(acdev->vbase + GIRQ_SGN_EN));
+	dev_dbg(dev, ": =====================================");
+}
+
+/* Enable/Disable global interrupts shared between CF and XD ctrlr. */
+static void cf_ginterrupt_enable(struct arasan_cf_dev *acdev, bool enable)
+{
+	/* enable should be 0 or 1 */
+	writel(enable, acdev->vbase + GIRQ_STS_EN);
+	writel(enable, acdev->vbase + GIRQ_SGN_EN);
+}
+
+/* Enable/Disable CF interrupts */
+static inline void
+cf_interrupt_enable(struct arasan_cf_dev *acdev, u32 mask, bool enable)
+{
+	u32 val = readl(acdev->vbase + IRQ_EN);
+	/* clear & enable/disable irqs */
+	if (enable) {
+		writel(mask, acdev->vbase + IRQ_STS);
+		writel(val | mask, acdev->vbase + IRQ_EN);
+	} else
+		writel(val & ~mask, acdev->vbase + IRQ_EN);
+}
+
+static inline void cf_card_reset(struct arasan_cf_dev *acdev)
+{
+	u32 val = readl(acdev->vbase + OP_MODE);
+
+	writel(val | CARD_RESET, acdev->vbase + OP_MODE);
+	udelay(200);
+	writel(val & ~CARD_RESET, acdev->vbase + OP_MODE);
+}
+
+static inline void cf_ctrl_reset(struct arasan_cf_dev *acdev)
+{
+	writel(readl(acdev->vbase + OP_MODE) & ~CFHOST_ENB,
+			acdev->vbase + OP_MODE);
+	writel(readl(acdev->vbase + OP_MODE) | CFHOST_ENB,
+			acdev->vbase + OP_MODE);
+}
+
+static void cf_card_detect(struct arasan_cf_dev *acdev, bool hotplugged)
+{
+	struct ata_port *ap = acdev->host->ports[0];
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	u32 val = readl(acdev->vbase + CFI_STS);
+
+	/* Both CD1 & CD2 should be low if card inserted completely */
+	if (!(val & (CARD_DETECT1 | CARD_DETECT2))) {
+		if (acdev->card_present)
+			return;
+		acdev->card_present = 1;
+		cf_card_reset(acdev);
+	} else {
+		if (!acdev->card_present)
+			return;
+		acdev->card_present = 0;
+	}
+
+	if (hotplugged) {
+		ata_ehi_hotplugged(ehi);
+		ata_port_freeze(ap);
+	}
+}
+
+static int cf_init(struct arasan_cf_dev *acdev)
+{
+	struct arasan_cf_pdata *pdata = dev_get_platdata(acdev->host->dev);
+	unsigned long flags;
+	int ret = 0;
+
+#ifdef CONFIG_HAVE_CLK
+	ret = clk_enable(acdev->clk);
+	if (ret) {
+		dev_dbg(acdev->host->dev, "clock enable failed");
+		return ret;
+	}
+#endif
+
+	spin_lock_irqsave(&acdev->host->lock, flags);
+	/* configure CF interface clock */
+	writel((pdata->cf_if_clk <= CF_IF_CLK_200M) ? pdata->cf_if_clk :
+			CF_IF_CLK_166M, acdev->vbase + CLK_CFG);
+
+	writel(TRUE_IDE_MODE | CFHOST_ENB, acdev->vbase + OP_MODE);
+	cf_interrupt_enable(acdev, CARD_DETECT_IRQ, 1);
+	cf_ginterrupt_enable(acdev, 1);
+	spin_unlock_irqrestore(&acdev->host->lock, flags);
+
+	return ret;
+}
+
+static void cf_exit(struct arasan_cf_dev *acdev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&acdev->host->lock, flags);
+	cf_ginterrupt_enable(acdev, 0);
+	cf_interrupt_enable(acdev, TRUE_IDE_IRQS, 0);
+	cf_card_reset(acdev);
+	writel(readl(acdev->vbase + OP_MODE) & ~CFHOST_ENB,
+			acdev->vbase + OP_MODE);
+	spin_unlock_irqrestore(&acdev->host->lock, flags);
+#ifdef CONFIG_HAVE_CLK
+	clk_disable(acdev->clk);
+#endif
+}
+
+static void dma_callback(void *dev)
+{
+	struct arasan_cf_dev *acdev = (struct arasan_cf_dev *) dev;
+
+	complete(&acdev->dma_completion);
+}
+
+static bool filter(struct dma_chan *chan, void *slave)
+{
+	chan->private = slave;
+	return true;
+}
+
+static inline void dma_complete(struct arasan_cf_dev *acdev)
+{
+	struct ata_queued_cmd *qc = acdev->qc;
+	unsigned long flags;
+
+	acdev->qc = NULL;
+	ata_sff_interrupt(acdev->irq, acdev->host);
+
+	spin_lock_irqsave(&acdev->host->lock, flags);
+	if (unlikely(qc->err_mask) && ata_is_dma(qc->tf.protocol))
+		ata_ehi_push_desc(&qc->ap->link.eh_info, "DMA Failed: Timeout");
+	spin_unlock_irqrestore(&acdev->host->lock, flags);
+}
+
+static inline int wait4buf(struct arasan_cf_dev *acdev)
+{
+	if (!wait_for_completion_timeout(&acdev->cf_completion, TIMEOUT)) {
+		u32 rw = acdev->qc->tf.flags & ATA_TFLAG_WRITE;
+
+		dev_err(acdev->host->dev, "%s TimeOut", rw ? "write" : "read");
+		return -ETIMEDOUT;
+	}
+
+	/* Check if PIO Error interrupt has occured */
+	if (acdev->dma_status & ATA_DMA_ERR)
+		return -EAGAIN;
+
+	return 0;
+}
+
+static int
+dma_xfer(struct arasan_cf_dev *acdev, dma_addr_t src, dma_addr_t dest, u32 len)
+{
+	struct dma_async_tx_descriptor *tx;
+	struct dma_chan *chan = acdev->dma_chan;
+	dma_cookie_t cookie;
+	unsigned long flags = DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP |
+		DMA_COMPL_SKIP_DEST_UNMAP;
+	int ret = 0;
+
+	tx = chan->device->device_prep_dma_memcpy(chan, dest, src, len, flags);
+	if (!tx) {
+		dev_err(acdev->host->dev, "device_prep_dma_memcpy failed\n");
+		return -EAGAIN;
+	}
+
+	tx->callback = dma_callback;
+	tx->callback_param = acdev;
+	cookie = tx->tx_submit(tx);
+
+	ret = dma_submit_error(cookie);
+	if (ret) {
+		dev_err(acdev->host->dev, "dma_submit_error\n");
+		return ret;
+	}
+
+	chan->device->device_issue_pending(chan);
+
+	/* Wait for DMA to complete */
+	if (!wait_for_completion_timeout(&acdev->dma_completion, TIMEOUT)) {
+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+		dev_err(acdev->host->dev, "wait_for_completion_timeout\n");
+		return -ETIMEDOUT;
+	}
+
+	return ret;
+}
+
+static int sg_xfer(struct arasan_cf_dev *acdev, struct scatterlist *sg)
+{
+	dma_addr_t dest = 0, src = 0;
+	u32 xfer_cnt, sglen, dma_len, xfer_ctr;
+	u32 write = acdev->qc->tf.flags & ATA_TFLAG_WRITE;
+	unsigned long flags;
+	int ret = 0;
+
+	sglen = sg_dma_len(sg);
+	if (write) {
+		src = sg_dma_address(sg);
+		dest = acdev->pbase + EXT_WRITE_PORT;
+	} else {
+		dest = sg_dma_address(sg);
+		src = acdev->pbase + EXT_READ_PORT;
+	}
+
+	/*
+	 * For each sg:
+	 * MAX_XFER_COUNT data will be transferred before we get transfer
+	 * complete interrupt. Inbetween after FIFO_SIZE data
+	 * buffer available interrupt will be generated. At this time we will
+	 * fill FIFO again: max FIFO_SIZE data.
+	 */
+	while (sglen) {
+		xfer_cnt = min(sglen, MAX_XFER_COUNT);
+		spin_lock_irqsave(&acdev->host->lock, flags);
+		xfer_ctr = readl(acdev->vbase + XFER_CTR) &
+			~XFER_COUNT_MASK;
+		writel(xfer_ctr | xfer_cnt | XFER_START,
+				acdev->vbase + XFER_CTR);
+		spin_unlock_irqrestore(&acdev->host->lock, flags);
+
+		/* continue dma xfers untill current sg is completed */
+		while (xfer_cnt) {
+			/* wait for read to complete */
+			if (!write) {
+				ret = wait4buf(acdev);
+				if (ret)
+					goto fail;
+			}
+
+			/* read/write FIFO in chunk of FIFO_SIZE */
+			dma_len = min(xfer_cnt, FIFO_SIZE);
+			ret = dma_xfer(acdev, src, dest, dma_len);
+			if (ret) {
+				dev_err(acdev->host->dev, "dma failed");
+				goto fail;
+			}
+
+			if (write)
+				src += dma_len;
+			else
+				dest += dma_len;
+
+			sglen -= dma_len;
+			xfer_cnt -= dma_len;
+
+			/* wait for write to complete */
+			if (write) {
+				ret = wait4buf(acdev);
+				if (ret)
+					goto fail;
+			}
+		}
+	}
+
+fail:
+	spin_lock_irqsave(&acdev->host->lock, flags);
+	writel(readl(acdev->vbase + XFER_CTR) & ~XFER_START,
+			acdev->vbase + XFER_CTR);
+	spin_unlock_irqrestore(&acdev->host->lock, flags);
+
+	return ret;
+}
+
+/*
+ * This routine uses External DMA controller to read/write data to FIFO of CF
+ * controller. There are two xfer related interrupt supported by CF controller:
+ * - buf_avail: This interrupt is generated as soon as we have buffer of 512
+ *	bytes available for reading or empty buffer available for writing.
+ * - xfer_done: This interrupt is generated on transfer of "xfer_size" amount of
+ *	data to/from FIFO. xfer_size is programmed in XFER_CTR register.
+ *
+ * Max buffer size = FIFO_SIZE = 512 Bytes.
+ * Max xfer_size = MAX_XFER_COUNT = 256 KB.
+ */
+static void data_xfer(struct work_struct *work)
+{
+	struct arasan_cf_dev *acdev = container_of(work, struct arasan_cf_dev,
+			work);
+	struct ata_queued_cmd *qc = acdev->qc;
+	struct scatterlist *sg;
+	unsigned long flags;
+	u32 temp;
+	int ret = 0;
+
+	/* request dma channels */
+	/* dma_request_channel may sleep, so calling from process context */
+	acdev->dma_chan = dma_request_channel(acdev->mask, filter,
+			acdev->dma_priv);
+	if (!acdev->dma_chan) {
+		dev_err(acdev->host->dev, "Unable to get dma_chan\n");
+		goto chan_request_fail;
+	}
+
+	for_each_sg(qc->sg, sg, qc->n_elem, temp) {
+		ret = sg_xfer(acdev, sg);
+		if (ret)
+			break;
+	}
+
+	dma_release_channel(acdev->dma_chan);
+
+	/* data xferred successfully */
+	if (!ret) {
+		u32 status;
+
+		spin_lock_irqsave(&acdev->host->lock, flags);
+		status = ioread8(qc->ap->ioaddr.altstatus_addr);
+		spin_unlock_irqrestore(&acdev->host->lock, flags);
+		if (status & (ATA_BUSY | ATA_DRQ)) {
+			ata_sff_queue_delayed_work(&acdev->dwork, 1);
+			return;
+		}
+
+		goto sff_intr;
+	}
+
+	cf_dumpregs(acdev);
+
+chan_request_fail:
+	spin_lock_irqsave(&acdev->host->lock, flags);
+	/* error when transfering data to/from memory */
+	qc->err_mask |= AC_ERR_HOST_BUS;
+	qc->ap->hsm_task_state = HSM_ST_ERR;
+
+	cf_ctrl_reset(acdev);
+	spin_unlock_irqrestore(qc->ap->lock, flags);
+sff_intr:
+	dma_complete(acdev);
+}
+
+static void delayed_finish(struct work_struct *work)
+{
+	struct arasan_cf_dev *acdev = container_of(work, struct arasan_cf_dev,
+			dwork.work);
+	struct ata_queued_cmd *qc = acdev->qc;
+	unsigned long flags;
+	u8 status;
+
+	spin_lock_irqsave(&acdev->host->lock, flags);
+	status = ioread8(qc->ap->ioaddr.altstatus_addr);
+	spin_unlock_irqrestore(&acdev->host->lock, flags);
+
+	if (status & (ATA_BUSY | ATA_DRQ))
+		ata_sff_queue_delayed_work(&acdev->dwork, 1);
+	else
+		dma_complete(acdev);
+}
+
+static irqreturn_t arasan_cf_interrupt(int irq, void *dev)
+{
+	struct arasan_cf_dev *acdev = ((struct ata_host *)dev)->private_data;
+	unsigned long flags;
+	u32 irqsts;
+
+	irqsts = readl(acdev->vbase + GIRQ_STS);
+	if (!(irqsts & GIRQ_CF))
+		return IRQ_NONE;
+
+	spin_lock_irqsave(&acdev->host->lock, flags);
+	irqsts = readl(acdev->vbase + IRQ_STS);
+	writel(irqsts, acdev->vbase + IRQ_STS);		/* clear irqs */
+	writel(GIRQ_CF, acdev->vbase + GIRQ_STS);	/* clear girqs */
+
+	/* handle only relevant interrupts */
+	irqsts &= ~IGNORED_IRQS;
+
+	if (irqsts & CARD_DETECT_IRQ) {
+		cf_card_detect(acdev, 1);
+		spin_unlock_irqrestore(&acdev->host->lock, flags);
+		return IRQ_HANDLED;
+	}
+
+	if (irqsts & PIO_XFER_ERR_IRQ) {
+		acdev->dma_status = ATA_DMA_ERR;
+		writel(readl(acdev->vbase + XFER_CTR) & ~XFER_START,
+				acdev->vbase + XFER_CTR);
+		spin_unlock_irqrestore(&acdev->host->lock, flags);
+		complete(&acdev->cf_completion);
+		dev_err(acdev->host->dev, "pio xfer err irq\n");
+		return IRQ_HANDLED;
+	}
+
+	spin_unlock_irqrestore(&acdev->host->lock, flags);
+
+	if (irqsts & BUF_AVAIL_IRQ) {
+		complete(&acdev->cf_completion);
+		return IRQ_HANDLED;
+	}
+
+	if (irqsts & XFER_DONE_IRQ) {
+		struct ata_queued_cmd *qc = acdev->qc;
+
+		/* Send Complete only for write */
+		if (qc->tf.flags & ATA_TFLAG_WRITE)
+			complete(&acdev->cf_completion);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void arasan_cf_freeze(struct ata_port *ap)
+{
+	struct arasan_cf_dev *acdev = ap->host->private_data;
+
+	/* stop transfer and reset controller */
+	writel(readl(acdev->vbase + XFER_CTR) & ~XFER_START,
+			acdev->vbase + XFER_CTR);
+	cf_ctrl_reset(acdev);
+	acdev->dma_status = ATA_DMA_ERR;
+
+	ata_sff_dma_pause(ap);
+	ata_sff_freeze(ap);
+}
+
+void arasan_cf_error_handler(struct ata_port *ap)
+{
+	struct arasan_cf_dev *acdev = ap->host->private_data;
+
+	/*
+	 * DMA transfers using an external DMA controller may be scheduled.
+	 * Abort them before handling error. Refer data_xfer() for further
+	 * details.
+	 */
+	cancel_work_sync(&acdev->work);
+	cancel_delayed_work_sync(&acdev->dwork);
+	return ata_sff_error_handler(ap);
+}
+
+static void arasan_cf_dma_start(struct arasan_cf_dev *acdev)
+{
+	u32 xfer_ctr = readl(acdev->vbase + XFER_CTR) & ~XFER_DIR_MASK;
+	u32 write = acdev->qc->tf.flags & ATA_TFLAG_WRITE;
+
+	xfer_ctr |= write ? XFER_WRITE : XFER_READ;
+	writel(xfer_ctr, acdev->vbase + XFER_CTR);
+
+	acdev->qc->ap->ops->sff_exec_command(acdev->qc->ap, &acdev->qc->tf);
+	ata_sff_queue_work(&acdev->work);
+}
+
+unsigned int arasan_cf_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct arasan_cf_dev *acdev = ap->host->private_data;
+
+	/* defer PIO handling to sff_qc_issue */
+	if (!ata_is_dma(qc->tf.protocol))
+		return ata_sff_qc_issue(qc);
+
+	/* select the device */
+	ata_wait_idle(ap);
+	ata_sff_dev_select(ap, qc->dev->devno);
+	ata_wait_idle(ap);
+
+	/* start the command */
+	switch (qc->tf.protocol) {
+	case ATA_PROT_DMA:
+		WARN_ON_ONCE(qc->tf.flags & ATA_TFLAG_POLLING);
+
+		ap->ops->sff_tf_load(ap, &qc->tf);
+		acdev->dma_status = 0;
+		acdev->qc = qc;
+		arasan_cf_dma_start(acdev);
+		ap->hsm_task_state = HSM_ST_LAST;
+		break;
+
+	default:
+		WARN_ON(1);
+		return AC_ERR_SYSTEM;
+	}
+
+	return 0;
+}
+
+static void arasan_cf_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct arasan_cf_dev *acdev = ap->host->private_data;
+	u8 pio = adev->pio_mode - XFER_PIO_0;
+	unsigned long flags;
+	u32 val;
+
+	/* Arasan ctrl supports Mode0 -> Mode6 */
+	if (pio > 6) {
+		dev_err(ap->dev, "Unknown PIO mode\n");
+		return;
+	}
+
+	spin_lock_irqsave(&acdev->host->lock, flags);
+	val = readl(acdev->vbase + OP_MODE) &
+		~(ULTRA_DMA_ENB | MULTI_WORD_DMA_ENB | DRQ_BLOCK_SIZE_MASK);
+	writel(val, acdev->vbase + OP_MODE);
+	val = readl(acdev->vbase + TM_CFG) & ~TRUEIDE_PIO_TIMING_MASK;
+	val |= pio << TRUEIDE_PIO_TIMING_SHIFT;
+	writel(val, acdev->vbase + TM_CFG);
+
+	cf_interrupt_enable(acdev, BUF_AVAIL_IRQ | XFER_DONE_IRQ, 0);
+	cf_interrupt_enable(acdev, PIO_XFER_ERR_IRQ, 1);
+	spin_unlock_irqrestore(&acdev->host->lock, flags);
+}
+
+static void arasan_cf_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct arasan_cf_dev *acdev = ap->host->private_data;
+	u32 opmode, tmcfg, dma_mode = adev->dma_mode;
+	unsigned long flags;
+
+	spin_lock_irqsave(&acdev->host->lock, flags);
+	opmode = readl(acdev->vbase + OP_MODE) &
+		~(MULTI_WORD_DMA_ENB | ULTRA_DMA_ENB);
+	tmcfg = readl(acdev->vbase + TM_CFG);
+
+	if ((dma_mode >= XFER_UDMA_0) && (dma_mode <= XFER_UDMA_6)) {
+		opmode |= ULTRA_DMA_ENB;
+		tmcfg &= ~ULTRA_DMA_TIMING_MASK;
+		tmcfg |= (dma_mode - XFER_UDMA_0) << ULTRA_DMA_TIMING_SHIFT;
+	} else if ((dma_mode >= XFER_MW_DMA_0) && (dma_mode <= XFER_MW_DMA_4)) {
+		opmode |= MULTI_WORD_DMA_ENB;
+		tmcfg &= ~TRUEIDE_MWORD_DMA_TIMING_MASK;
+		tmcfg |= (dma_mode - XFER_MW_DMA_0) <<
+			TRUEIDE_MWORD_DMA_TIMING_SHIFT;
+	} else {
+		dev_err(ap->dev, "Unknown DMA mode\n");
+		spin_unlock_irqrestore(&acdev->host->lock, flags);
+		return;
+	}
+
+	writel(opmode, acdev->vbase + OP_MODE);
+	writel(tmcfg, acdev->vbase + TM_CFG);
+	writel(DMA_XFER_MODE, acdev->vbase + XFER_CTR);
+
+	cf_interrupt_enable(acdev, PIO_XFER_ERR_IRQ, 0);
+	cf_interrupt_enable(acdev, BUF_AVAIL_IRQ | XFER_DONE_IRQ, 1);
+	spin_unlock_irqrestore(&acdev->host->lock, flags);
+}
+
+static struct ata_port_operations arasan_cf_ops = {
+	.inherits = &ata_sff_port_ops,
+	.freeze = arasan_cf_freeze,
+	.error_handler = arasan_cf_error_handler,
+	.qc_issue = arasan_cf_qc_issue,
+	.set_piomode = arasan_cf_set_piomode,
+	.set_dmamode = arasan_cf_set_dmamode,
+};
+
+static int __devinit arasan_cf_probe(struct platform_device *pdev)
+{
+	struct arasan_cf_dev *acdev;
+	struct arasan_cf_pdata *pdata = dev_get_platdata(&pdev->dev);
+	struct ata_host *host;
+	struct ata_port *ap;
+	struct resource *res;
+	irq_handler_t irq_handler = NULL;
+	int ret = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
+
+	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
+				DRIVER_NAME)) {
+		dev_warn(&pdev->dev, "Failed to get memory region resource\n");
+		return -ENOENT;
+	}
+
+	acdev = devm_kzalloc(&pdev->dev, sizeof(*acdev), GFP_KERNEL);
+	if (!acdev) {
+		dev_warn(&pdev->dev, "kzalloc fail\n");
+		return -ENOMEM;
+	}
+
+	/* if irq is 0, support only PIO */
+	acdev->irq = platform_get_irq(pdev, 0);
+	if (acdev->irq)
+		irq_handler = arasan_cf_interrupt;
+	else
+		pdata->quirk |= CF_BROKEN_MWDMA | CF_BROKEN_UDMA;
+
+	acdev->pbase = res->start;
+	acdev->vbase = devm_ioremap_nocache(&pdev->dev, res->start,
+			resource_size(res));
+	if (!acdev->vbase) {
+		dev_warn(&pdev->dev, "ioremap fail\n");
+		return -ENOMEM;
+	}
+
+#ifdef CONFIG_HAVE_CLK
+	acdev->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(acdev->clk)) {
+		dev_warn(&pdev->dev, "Clock not found\n");
+		return PTR_ERR(acdev->clk);
+	}
+#endif
+
+	/* allocate host */
+	host = ata_host_alloc(&pdev->dev, 1);
+	if (!host) {
+		ret = -ENOMEM;
+		dev_warn(&pdev->dev, "alloc host fail\n");
+		goto free_clk;
+	}
+
+	ap = host->ports[0];
+	host->private_data = acdev;
+	acdev->host = host;
+	ap->ops = &arasan_cf_ops;
+	ap->pio_mask = ATA_PIO6;
+	ap->mwdma_mask = ATA_MWDMA4;
+	ap->udma_mask = ATA_UDMA6;
+
+	init_completion(&acdev->cf_completion);
+	init_completion(&acdev->dma_completion);
+	INIT_WORK(&acdev->work, data_xfer);
+	INIT_DELAYED_WORK(&acdev->dwork, delayed_finish);
+	dma_cap_set(DMA_MEMCPY, acdev->mask);
+	acdev->dma_priv = pdata->dma_priv;
+
+	/* Handle platform specific quirks */
+	if (pdata->quirk) {
+		if (pdata->quirk & CF_BROKEN_PIO) {
+			ap->ops->set_piomode = NULL;
+			ap->pio_mask = 0;
+		}
+		if (pdata->quirk & CF_BROKEN_MWDMA)
+			ap->mwdma_mask = 0;
+		if (pdata->quirk & CF_BROKEN_UDMA)
+			ap->udma_mask = 0;
+	}
+	ap->flags |= ATA_FLAG_PIO_POLLING | ATA_FLAG_NO_ATAPI;
+
+	ap->ioaddr.cmd_addr = acdev->vbase + ATA_DATA_PORT;
+	ap->ioaddr.data_addr = acdev->vbase + ATA_DATA_PORT;
+	ap->ioaddr.error_addr = acdev->vbase + ATA_ERR_FTR;
+	ap->ioaddr.feature_addr = acdev->vbase + ATA_ERR_FTR;
+	ap->ioaddr.nsect_addr = acdev->vbase + ATA_SC;
+	ap->ioaddr.lbal_addr = acdev->vbase + ATA_SN;
+	ap->ioaddr.lbam_addr = acdev->vbase + ATA_CL;
+	ap->ioaddr.lbah_addr = acdev->vbase + ATA_CH;
+	ap->ioaddr.device_addr = acdev->vbase + ATA_SH;
+	ap->ioaddr.status_addr = acdev->vbase + ATA_STS_CMD;
+	ap->ioaddr.command_addr = acdev->vbase + ATA_STS_CMD;
+	ap->ioaddr.altstatus_addr = acdev->vbase + ATA_ASTS_DCTR;
+	ap->ioaddr.ctl_addr = acdev->vbase + ATA_ASTS_DCTR;
+
+	ata_port_desc(ap, "phy_addr %llx virt_addr %p",
+		      (unsigned long long) res->start, acdev->vbase);
+
+	ret = cf_init(acdev);
+	if (ret)
+		goto free_clk;
+
+	cf_card_detect(acdev, 0);
+
+	return ata_host_activate(host, acdev->irq, irq_handler, 0,
+			&arasan_cf_sht);
+
+free_clk:
+#ifdef CONFIG_HAVE_CLK
+	clk_put(acdev->clk);
+#endif
+	return ret;
+}
+
+static int __devexit arasan_cf_remove(struct platform_device *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct arasan_cf_dev *acdev = host->ports[0]->private_data;
+
+	ata_host_detach(host);
+	cf_exit(acdev);
+#ifdef CONFIG_HAVE_CLK
+	clk_put(acdev->clk);
+#endif
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int arasan_cf_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct arasan_cf_dev *acdev = host->ports[0]->private_data;
+
+	if (acdev->dma_chan) {
+		acdev->dma_chan->device->device_control(acdev->dma_chan,
+				DMA_TERMINATE_ALL, 0);
+		dma_release_channel(acdev->dma_chan);
+	}
+	cf_exit(acdev);
+	return ata_host_suspend(host, PMSG_SUSPEND);
+}
+
+static int arasan_cf_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct arasan_cf_dev *acdev = host->ports[0]->private_data;
+
+	cf_init(acdev);
+	ata_host_resume(host);
+
+	return 0;
+}
+
+static const struct dev_pm_ops arasan_cf_pm_ops = {
+	.suspend	= arasan_cf_suspend,
+	.resume		= arasan_cf_resume,
+};
+#endif
+
+static struct platform_driver arasan_cf_driver = {
+	.probe		= arasan_cf_probe,
+	.remove		= __devexit_p(arasan_cf_remove),
+	.driver		= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm		= &arasan_cf_pm_ops,
+#endif
+	},
+};
+
+static int __init arasan_cf_init(void)
+{
+	return platform_driver_register(&arasan_cf_driver);
+}
+module_init(arasan_cf_init);
+
+static void __exit arasan_cf_exit(void)
+{
+	platform_driver_unregister(&arasan_cf_driver);
+}
+module_exit(arasan_cf_exit);
+
+MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_DESCRIPTION("Arasan ATA Compact Flash driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/drivers/ata/pata_at32.c b/drivers/ata/pata_at32.c
index 66ce6a5..36f189c 100644
--- a/drivers/ata/pata_at32.c
+++ b/drivers/ata/pata_at32.c
@@ -194,7 +194,7 @@ static int __init pata_at32_init_one(struct device *dev,
 	/* Setup ATA bindings */
 	ap->ops	     = &at32_port_ops;
 	ap->pio_mask = PIO_MASK;
-	ap->flags   |= ATA_FLAG_MMIO | ATA_FLAG_SLAVE_POSS;
+	ap->flags   |= ATA_FLAG_SLAVE_POSS;
 
 	/*
 	 * Since all 8-bit taskfile transfers has to go on the lower
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 7aed5c7..e0b58b8 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1454,9 +1454,7 @@ static struct ata_port_operations bfin_pata_ops = {
 
 static struct ata_port_info bfin_port_info[] = {
 	{
-		.flags		= ATA_FLAG_SLAVE_POSS
-				| ATA_FLAG_MMIO
-				| ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= 0,
 		.udma_mask	= 0,
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 538ec38..6c77d68 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -14,6 +14,7 @@
  *	Look into engine reset on timeout errors. Should not be required.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -25,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt366"
-#define DRV_VERSION	"0.6.10"
+#define DRV_VERSION	"0.6.11"
 
 struct hpt_clock {
 	u8	xfer_mode;
@@ -160,8 +161,8 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
 
 	while (list[i] != NULL) {
 		if (!strcmp(list[i], model_num)) {
-			pr_warning(DRV_NAME ": %s is not supported for %s.\n",
-				   modestr, list[i]);
+			pr_warn("%s is not supported for %s\n",
+				modestr, list[i]);
 			return 1;
 		}
 		i++;
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 4c5b518..9620636 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -14,6 +14,8 @@
  *	Look into engine reset on timeout errors. Should not be	required.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -24,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.22"
+#define DRV_VERSION	"0.6.23"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -229,8 +231,8 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
 
 	while (list[i] != NULL) {
 		if (!strcmp(list[i], model_num)) {
-			pr_warning(DRV_NAME ": %s is not supported for %s.\n",
-				   modestr, list[i]);
+			pr_warn("%s is not supported for %s\n",
+				modestr, list[i]);
 			return 1;
 		}
 		i++;
@@ -863,8 +865,8 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			chip_table = &hpt372;
 			break;
 		default:
-			pr_err(DRV_NAME ": Unknown HPT366 subtype, "
-			       "please report (%d).\n", rev);
+			pr_err("Unknown HPT366 subtype, please report (%d)\n",
+			       rev);
 			return -ENODEV;
 		}
 		break;
@@ -904,8 +906,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			*ppi = &info_hpt374_fn1;
 		break;
 	default:
-		pr_err(DRV_NAME ": PCI table is bogus, please report (%d).\n",
-		       dev->device);
+		pr_err("PCI table is bogus, please report (%d)\n", dev->device);
 		return -ENODEV;
 	}
 	/* Ok so this is a chip we support */
@@ -953,7 +954,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		u8 sr;
 		u32 total = 0;
 
-		pr_warning(DRV_NAME ": BIOS has not set timing clocks.\n");
+		pr_warn("BIOS has not set timing clocks\n");
 
 		/* This is the process the HPT371 BIOS is reported to use */
 		for (i = 0; i < 128; i++) {
@@ -1009,7 +1010,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 					       (f_high << 16) | f_low | 0x100);
 		}
 		if (adjust == 8) {
-			pr_err(DRV_NAME ": DPLL did not stabilize!\n");
+			pr_err("DPLL did not stabilize!\n");
 			return -ENODEV;
 		}
 		if (dpll == 3)
@@ -1017,7 +1018,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		else
 			private_data = (void *)hpt37x_timings_50;
 
-		pr_info(DRV_NAME ": bus clock %dMHz, using %dMHz DPLL.\n",
+		pr_info("bus clock %dMHz, using %dMHz DPLL\n",
 			MHz[clock_slot], MHz[dpll]);
 	} else {
 		private_data = (void *)chip_table->clocks[clock_slot];
@@ -1032,7 +1033,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		if (clock_slot < 2 && ppi[0] == &info_hpt370a)
 			ppi[0] = &info_hpt370a_33;
 
-		pr_info(DRV_NAME ": %s using %dMHz bus clock.\n",
+		pr_info("%s using %dMHz bus clock\n",
 			chip_table->name, MHz[clock_slot]);
 	}
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index eca68ca..765f136 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -15,6 +15,8 @@
  *	Work out best PLL policy
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -25,7 +27,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.14"
+#define DRV_VERSION	"0.3.15"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -418,7 +420,7 @@ static int hpt3x2n_pci_clock(struct pci_dev *pdev)
 		u16 sr;
 		u32 total = 0;
 
-		pr_warning(DRV_NAME ": BIOS clock data not set.\n");
+		pr_warn("BIOS clock data not set\n");
 
 		/* This is the process the HPT371 BIOS is reported to use */
 		for (i = 0; i < 128; i++) {
@@ -528,8 +530,7 @@ hpt372n:
 		ppi[0] = &info_hpt372n;
 		break;
 	default:
-		pr_err(DRV_NAME ": PCI table is bogus, please report (%d).\n",
-		       dev->device);
+		pr_err("PCI table is bogus, please report (%d)\n", dev->device);
 		return -ENODEV;
 	}
 
@@ -578,11 +579,11 @@ hpt372n:
 		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
 	}
 	if (adjust == 8) {
-		pr_err(DRV_NAME ": DPLL did not stabilize!\n");
+		pr_err("DPLL did not stabilize!\n");
 		return -ENODEV;
 	}
 
-	pr_info(DRV_NAME ": bus clock %dMHz, using 66MHz DPLL.\n", pci_mhz);
+	pr_info("bus clock %dMHz, using 66MHz DPLL\n", pci_mhz);
 
 	/*
 	 * Set our private data up. We only need a few flags
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index b63d5e2..24d7df8 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -151,7 +151,7 @@ static struct ata_port_operations hpt3x3_port_ops = {
 	.check_atapi_dma= hpt3x3_atapi_dma,
 	.freeze		= hpt3x3_freeze,
 #endif
-	
+
 };
 
 /**
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index aa0e0c5..2d15f25 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -616,7 +616,7 @@ static void it821x_display_disk(int n, u8 *buf)
 	if (buf[52] > 4)	/* No Disk */
 		return;
 
-	ata_id_c_string((u16 *)buf, id, 0, 41); 
+	ata_id_c_string((u16 *)buf, id, 0, 41);
 
 	if (buf[51]) {
 		mode = ffs(buf[51]);
@@ -910,7 +910,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	rc = pcim_enable_device(pdev);
 	if (rc)
 		return rc;
-		
+
 	if (pdev->vendor == PCI_VENDOR_ID_RDC) {
 		/* Deal with Vortex86SX */
 		if (pdev->revision == 0x11)
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index ba54b08..5253b27 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -177,7 +177,7 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 
 	ap->ops	= &ixp4xx_port_ops;
 	ap->pio_mask = ATA_PIO4;
-	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI;
+	ap->flags |= ATA_FLAG_NO_ATAPI;
 
 	ixp4xx_setup_port(ap, data, cs0->start, cs1->start);
 
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 75b49d0..46f589e 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -1053,8 +1053,7 @@ static int __devinit pata_macio_common_init(struct pata_macio_priv	*priv,
 	/* Allocate libata host for 1 port */
 	memset(&pinfo, 0, sizeof(struct ata_port_info));
 	pmac_macio_calc_timing_masks(priv, &pinfo);
-	pinfo.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_MMIO |
-				  ATA_FLAG_NO_LEGACY;
+	pinfo.flags		= ATA_FLAG_SLAVE_POSS;
 	pinfo.port_ops		= &pata_macio_ops;
 	pinfo.private_data	= priv;
 
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index dd38083..75a6a0c 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -38,7 +38,7 @@ static int marvell_pata_active(struct pci_dev *pdev)
 
 	/* We don't yet know how to do this for other devices */
 	if (pdev->device != 0x6145)
-		return 1;	
+		return 1;
 
 	barp = pci_iomap(pdev, 5, 0x10);
 	if (barp == NULL)
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index cc50bd0..e277a14 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -165,7 +165,7 @@ static int ninja32_reinit_one(struct pci_dev *pdev)
 		return rc;
 	ninja32_program(host->iomap[0]);
 	ata_host_resume(host);
-	return 0;			
+	return 0;
 }
 #endif
 
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index fa1b95a..220ddc9 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -848,8 +848,7 @@ static int __devinit octeon_cf_probe(struct platform_device *pdev)
 	cf_port->ap = ap;
 	ap->ops = &octeon_cf_ops;
 	ap->pio_mask = ATA_PIO6;
-	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY
-		  | ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING;
+	ap->flags |= ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING;
 
 	base = cs0 + ocd->base_region_bias;
 	if (!ocd->is16bit) {
diff --git a/drivers/ata/pata_palmld.c b/drivers/ata/pata_palmld.c
index 11fb4cc..a2a73d9 100644
--- a/drivers/ata/pata_palmld.c
+++ b/drivers/ata/pata_palmld.c
@@ -85,7 +85,7 @@ static __devinit int palmld_pata_probe(struct platform_device *pdev)
 	ap = host->ports[0];
 	ap->ops	= &palmld_port_ops;
 	ap->pio_mask = ATA_PIO4;
-	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY | ATA_FLAG_PIO_POLLING;
+	ap->flags |= ATA_FLAG_PIO_POLLING;
 
 	/* memory mapping voodoo */
 	ap->ioaddr.cmd_addr = mem + 0x10;
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 8062921..29af660 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -124,7 +124,7 @@ static unsigned int ata_data_xfer_8bit(struct ata_device *dev,
  *	reset will recover the device.
  *
  */
- 
+
 static void pcmcia_8bit_drain_fifo(struct ata_queued_cmd *qc)
 {
 	int count;
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index b183511..9765ace 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -150,8 +150,7 @@ static struct ata_port_operations pdc2027x_pata133_ops = {
 static struct ata_port_info pdc2027x_port_info[] = {
 	/* PDC_UDMA_100 */
 	{
-		.flags		= ATA_FLAG_NO_LEGACY | ATA_FLAG_SLAVE_POSS |
-		                  ATA_FLAG_MMIO,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -159,8 +158,7 @@ static struct ata_port_info pdc2027x_port_info[] = {
 	},
 	/* PDC_UDMA_133 */
 	{
-		.flags		= ATA_FLAG_NO_LEGACY | ATA_FLAG_SLAVE_POSS |
-                        	  ATA_FLAG_MMIO,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
diff --git a/drivers/ata/pata_pxa.c b/drivers/ata/pata_pxa.c
index 1898c6e..b4ede40 100644
--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -292,7 +292,6 @@ static int __devinit pxa_ata_probe(struct platform_device *pdev)
 	ap->ops		= &pxa_ata_port_ops;
 	ap->pio_mask	= ATA_PIO4;
 	ap->mwdma_mask	= ATA_MWDMA2;
-	ap->flags	= ATA_FLAG_MMIO;
 
 	ap->ioaddr.cmd_addr	= devm_ioremap(&pdev->dev, cmd_res->start,
 						resource_size(cmd_res));
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index 0ffd631..baeaf938 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -91,7 +91,6 @@ static void rb532_pata_setup_ports(struct ata_host *ah)
 
 	ap->ops		= &rb532_pata_port_ops;
 	ap->pio_mask	= ATA_PIO4;
-	ap->flags	= ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO;
 
 	ap->ioaddr.cmd_addr	= info->iobase + RB500_CF_REG_BASE;
 	ap->ioaddr.ctl_addr	= info->iobase + RB500_CF_REG_CTRL;
diff --git a/drivers/ata/pata_samsung_cf.c b/drivers/ata/pata_samsung_cf.c
index 8a51d67..c446ae6 100644
--- a/drivers/ata/pata_samsung_cf.c
+++ b/drivers/ata/pata_samsung_cf.c
@@ -531,7 +531,6 @@ static int __init pata_s3c_probe(struct platform_device *pdev)
 	}
 
 	ap = host->ports[0];
-	ap->flags |= ATA_FLAG_MMIO;
 	ap->pio_mask = ATA_PIO4;
 
 	if (cpu_type == TYPE_S3C64XX) {
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 093715c..88ea9b6 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -959,7 +959,7 @@ static struct ata_port_operations scc_pata_ops = {
 
 static struct ata_port_info scc_port_info[] = {
 	{
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		/* No MWDMA */
 		.udma_mask	= ATA_UDMA6,
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 60cea13..c04abc3 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -593,7 +593,7 @@ static const struct ata_port_info sis_info133 = {
 	.port_ops	= &sis_133_ops,
 };
 const struct ata_port_info sis_info133_for_sata = {
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
 	/* No MWDMA */
 	.udma_mask	= ATA_UDMA6,
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index adbe042..1111712 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -166,9 +166,7 @@ static struct ata_port_operations adma_ata_ops = {
 static struct ata_port_info adma_port_info[] = {
 	/* board_1841_idx */
 	{
-		.flags		= ATA_FLAG_SLAVE_POSS |
-				  ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO |
-				  ATA_FLAG_PIO_POLLING,
+		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= ATA_PIO4_ONLY,
 		.udma_mask	= ATA_UDMA4,
 		.port_ops	= &adma_ata_ops,
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 6cf57c5..712ab5a 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -40,8 +40,11 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 
+/* These two are defined in "libata.h" */
+#undef	DRV_NAME
+#undef	DRV_VERSION
 #define DRV_NAME        "sata-dwc"
-#define DRV_VERSION     "1.0"
+#define DRV_VERSION     "1.3"
 
 /* SATA DMA driver Globals */
 #define DMA_NUM_CHANS		1
@@ -333,11 +336,47 @@ static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
 			      void __iomem *addr, int dir);
 static void dma_dwc_xfer_start(int dma_ch);
 
+static const char *get_prot_descript(u8 protocol)
+{
+	switch ((enum ata_tf_protocols)protocol) {
+	case ATA_PROT_NODATA:
+		return "ATA no data";
+	case ATA_PROT_PIO:
+		return "ATA PIO";
+	case ATA_PROT_DMA:
+		return "ATA DMA";
+	case ATA_PROT_NCQ:
+		return "ATA NCQ";
+	case ATAPI_PROT_NODATA:
+		return "ATAPI no data";
+	case ATAPI_PROT_PIO:
+		return "ATAPI PIO";
+	case ATAPI_PROT_DMA:
+		return "ATAPI DMA";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *get_dma_dir_descript(int dma_dir)
+{
+	switch ((enum dma_data_direction)dma_dir) {
+	case DMA_BIDIRECTIONAL:
+		return "bidirectional";
+	case DMA_TO_DEVICE:
+		return "to device";
+	case DMA_FROM_DEVICE:
+		return "from device";
+	default:
+		return "none";
+	}
+}
+
 static void sata_dwc_tf_dump(struct ata_taskfile *tf)
 {
 	dev_vdbg(host_pvt.dwc_dev, "taskfile cmd: 0x%02x protocol: %s flags:"
-		"0x%lx device: %x\n", tf->command, ata_get_cmd_descript\
-		(tf->protocol), tf->flags, tf->device);
+		"0x%lx device: %x\n", tf->command,
+		get_prot_descript(tf->protocol), tf->flags, tf->device);
 	dev_vdbg(host_pvt.dwc_dev, "feature: 0x%02x nsect: 0x%x lbal: 0x%x "
 		"lbam: 0x%x lbah: 0x%x\n", tf->feature, tf->nsect, tf->lbal,
 		 tf->lbam, tf->lbah);
@@ -715,7 +754,7 @@ static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
 	/* Program the CTL register with src enable / dst enable */
 	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].ctl.low),
 		 DMA_CTL_LLP_SRCEN | DMA_CTL_LLP_DSTEN);
-	return 0;
+	return dma_ch;
 }
 
 /*
@@ -967,7 +1006,7 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
 		}
 
 		dev_dbg(ap->dev, "%s non-NCQ cmd interrupt, protocol: %s\n",
-			__func__, ata_get_cmd_descript(qc->tf.protocol));
+			__func__, get_prot_descript(qc->tf.protocol));
 DRVSTILLBUSY:
 		if (ata_is_dma(qc->tf.protocol)) {
 			/*
@@ -1057,7 +1096,7 @@ DRVSTILLBUSY:
 
 		/* Process completed command */
 		dev_dbg(ap->dev, "%s NCQ command, protocol: %s\n", __func__,
-			ata_get_cmd_descript(qc->tf.protocol));
+			get_prot_descript(qc->tf.protocol));
 		if (ata_is_dma(qc->tf.protocol)) {
 			host_pvt.dma_interrupt_count++;
 			if (hsdevp->dma_pending[tag] == \
@@ -1142,8 +1181,8 @@ static void sata_dwc_dma_xfer_complete(struct ata_port *ap, u32 check_status)
 	if (tag > 0) {
 		dev_info(ap->dev, "%s tag=%u cmd=0x%02x dma dir=%s proto=%s "
 			 "dmacr=0x%08x\n", __func__, qc->tag, qc->tf.command,
-			 ata_get_cmd_descript(qc->dma_dir),
-			 ata_get_cmd_descript(qc->tf.protocol),
+			 get_dma_dir_descript(qc->dma_dir),
+			 get_prot_descript(qc->tf.protocol),
 			 in_le32(&(hsdev->sata_dwc_regs->dmacr)));
 	}
 #endif
@@ -1354,7 +1393,7 @@ static void sata_dwc_exec_command_by_tag(struct ata_port *ap,
 	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
 
 	dev_dbg(ap->dev, "%s cmd(0x%02x): %s tag=%d\n", __func__, tf->command,
-		ata_get_cmd_descript(tf), tag);
+		ata_get_cmd_descript(tf->command), tag);
 
 	spin_lock_irqsave(&ap->host->lock, flags);
 	hsdevp->cmd_issued[tag] = cmd_issued;
@@ -1413,7 +1452,7 @@ static void sata_dwc_bmdma_start_by_tag(struct ata_queued_cmd *qc, u8 tag)
 
 	dev_dbg(ap->dev, "%s qc=%p tag: %x cmd: 0x%02x dma_dir: %s "
 		"start_dma? %x\n", __func__, qc, tag, qc->tf.command,
-		ata_get_cmd_descript(qc->dma_dir), start_dma);
+		get_dma_dir_descript(qc->dma_dir), start_dma);
 	sata_dwc_tf_dump(&(qc->tf));
 
 	if (start_dma) {
@@ -1462,10 +1501,9 @@ static void sata_dwc_qc_prep_by_tag(struct ata_queued_cmd *qc, u8 tag)
 	int dma_chan;
 	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
 	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
-	int err;
 
 	dev_dbg(ap->dev, "%s: port=%d dma dir=%s n_elem=%d\n",
-		__func__, ap->port_no, ata_get_cmd_descript(qc->dma_dir),
+		__func__, ap->port_no, get_dma_dir_descript(qc->dma_dir),
 		 qc->n_elem);
 
 	dma_chan = dma_dwc_xfer_setup(sg, qc->n_elem, hsdevp->llit[tag],
@@ -1474,7 +1512,7 @@ static void sata_dwc_qc_prep_by_tag(struct ata_queued_cmd *qc, u8 tag)
 				      dmadr), qc->dma_dir);
 	if (dma_chan < 0) {
 		dev_err(ap->dev, "%s: dma_dwc_xfer_setup returns err %d\n",
-			__func__, err);
+			__func__, dma_chan);
 		return;
 	}
 	hsdevp->dma_chan[tag] = dma_chan;
@@ -1491,8 +1529,8 @@ static unsigned int sata_dwc_qc_issue(struct ata_queued_cmd *qc)
 		dev_info(ap->dev, "%s ap id=%d cmd(0x%02x)=%s qc tag=%d "
 			 "prot=%s ap active_tag=0x%08x ap sactive=0x%08x\n",
 			 __func__, ap->print_id, qc->tf.command,
-			 ata_get_cmd_descript(&qc->tf),
-			 qc->tag, ata_get_cmd_descript(qc->tf.protocol),
+			 ata_get_cmd_descript(qc->tf.command),
+			 qc->tag, get_prot_descript(qc->tf.protocol),
 			 ap->link.active_tag, ap->link.sactive);
 #endif
 
@@ -1533,7 +1571,7 @@ static void sata_dwc_qc_prep(struct ata_queued_cmd *qc)
 #ifdef DEBUG_NCQ
 	if (qc->tag > 0)
 		dev_info(qc->ap->dev, "%s: qc->tag=%d ap->active_tag=0x%08x\n",
-			 __func__, tag, qc->ap->link.active_tag);
+			 __func__, qc->tag, qc->ap->link.active_tag);
 
 	return ;
 #endif
@@ -1580,9 +1618,8 @@ static struct ata_port_operations sata_dwc_ops = {
 
 static const struct ata_port_info sata_dwc_port_info[] = {
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_NCQ,
-		.pio_mask	= 0x1f,	/* pio 0-4 */
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NCQ,
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &sata_dwc_ops,
 	},
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index b0214d0..7f9eab3 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -33,8 +33,7 @@ enum {
 	SATA_FSL_MAX_PRD_USABLE	= SATA_FSL_MAX_PRD - 1,
 	SATA_FSL_MAX_PRD_DIRECT	= 16,	/* Direct PRDT entries */
 
-	SATA_FSL_HOST_FLAGS	= (ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+	SATA_FSL_HOST_FLAGS	= (ATA_FLAG_SATA | ATA_FLAG_PIO_DMA |
 				ATA_FLAG_PMP | ATA_FLAG_NCQ | ATA_FLAG_AN),
 
 	SATA_FSL_MAX_CMDS	= SATA_FSL_QUEUE_DEPTH,
@@ -186,6 +185,11 @@ enum {
 	COMMANDSTAT = 0x20,
 };
 
+/* TRANSCFG (transport-layer) configuration control */
+enum {
+	TRANSCFG_RX_WATER_MARK = (1 << 4),
+};
+
 /* PHY (link-layer) configuration control */
 enum {
 	PHY_BIST_ENABLE = 0x01,
@@ -1040,12 +1044,15 @@ static void sata_fsl_error_intr(struct ata_port *ap)
 
 		/* find out the offending link and qc */
 		if (ap->nr_pmp_links) {
+			unsigned int dev_num;
+
 			dereg = ioread32(hcr_base + DE);
 			iowrite32(dereg, hcr_base + DE);
 			iowrite32(cereg, hcr_base + CE);
 
-			if (dereg < ap->nr_pmp_links) {
-				link = &ap->pmp_link[dereg];
+			dev_num = ffs(dereg) - 1;
+			if (dev_num < ap->nr_pmp_links && dereg != 0) {
+				link = &ap->pmp_link[dev_num];
 				ehi = &link->eh_info;
 				qc = ata_qc_from_tag(ap, link->active_tag);
 				/*
@@ -1303,6 +1310,7 @@ static int sata_fsl_probe(struct platform_device *ofdev,
 	struct sata_fsl_host_priv *host_priv = NULL;
 	int irq;
 	struct ata_host *host;
+	u32 temp;
 
 	struct ata_port_info pi = sata_fsl_port_info[0];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
@@ -1317,6 +1325,12 @@ static int sata_fsl_probe(struct platform_device *ofdev,
 	ssr_base = hcr_base + 0x100;
 	csr_base = hcr_base + 0x140;
 
+	if (!of_device_is_compatible(ofdev->dev.of_node, "fsl,mpc8315-sata")) {
+		temp = ioread32(csr_base + TRANSCFG);
+		temp = temp & 0xffffffe0;
+		iowrite32(temp | TRANSCFG_RX_WATER_MARK, csr_base + TRANSCFG);
+	}
+
 	DPRINTK("@reset i/o = 0x%x\n", ioread32(csr_base + TRANSCFG));
 	DPRINTK("sizeof(cmd_desc) = %d\n", sizeof(struct command_desc));
 	DPRINTK("sizeof(#define cmd_desc) = %d\n", SATA_FSL_CMD_DESC_SIZE);
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index bf74a36..cd40651 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -160,8 +160,7 @@ enum {
 	/* Host Flags */
 	MV_FLAG_DUAL_HC		= (1 << 30),  /* two SATA Host Controllers */
 
-	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
+	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_PIO_POLLING,
 
 	MV_GEN_I_FLAGS		= MV_COMMON_FLAGS | ATA_FLAG_NO_ATAPI,
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 7254e25..42344e3 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -539,7 +539,7 @@ struct nv_pi_priv {
 static const struct ata_port_info nv_port_info[] = {
 	/* generic */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -548,7 +548,7 @@ static const struct ata_port_info nv_port_info[] = {
 	},
 	/* nforce2/3 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -557,7 +557,7 @@ static const struct ata_port_info nv_port_info[] = {
 	},
 	/* ck804 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -566,8 +566,7 @@ static const struct ata_port_info nv_port_info[] = {
 	},
 	/* ADMA */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_NCQ,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NCQ,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -576,7 +575,7 @@ static const struct ata_port_info nv_port_info[] = {
 	},
 	/* MCP5x */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -585,8 +584,7 @@ static const struct ata_port_info nv_port_info[] = {
 	},
 	/* SWNCQ */
 	{
-		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_NCQ,
+		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NCQ,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index f03ad48..a004b1e 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -134,9 +134,7 @@ enum {
 	PDC_IRQ_DISABLE		= (1 << 10),
 	PDC_RESET		= (1 << 11), /* HDMA reset */
 
-	PDC_COMMON_FLAGS	= ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO |
-				  ATA_FLAG_PIO_POLLING,
+	PDC_COMMON_FLAGS	= ATA_FLAG_PIO_POLLING,
 
 	/* ap->flags bits */
 	PDC_FLAG_GEN_II		= (1 << 24),
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index daeebf1..c560326 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -155,8 +155,7 @@ static struct ata_port_operations qs_ata_ops = {
 static const struct ata_port_info qs_port_info[] = {
 	/* board_2068_idx */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= ATA_PIO4_ONLY,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &qs_ata_ops,
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 3a4f842..b42edaa 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -61,8 +61,7 @@ enum {
 	SIL_FLAG_RERR_ON_DMA_ACT = (1 << 29),
 	SIL_FLAG_MOD15WRITE	= (1 << 30),
 
-	SIL_DFL_PORT_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO,
+	SIL_DFL_PORT_FLAGS	= ATA_FLAG_SATA,
 
 	/*
 	 * Controller IDs
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index af41c6f..06c564e 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -244,8 +244,7 @@ enum {
 	BID_SIL3131		= 2,
 
 	/* host flags */
-	SIL24_COMMON_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+	SIL24_COMMON_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA |
 				  ATA_FLAG_NCQ | ATA_FLAG_ACPI_SATA |
 				  ATA_FLAG_AN | ATA_FLAG_PMP,
 	SIL24_FLAG_PCIX_IRQ_WOC	= (1 << 24), /* IRQ loss errata on PCI-X */
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 2bfe3ae..cdcc13e 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -96,7 +96,7 @@ static struct ata_port_operations sis_ops = {
 };
 
 static const struct ata_port_info sis_port_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SATA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 7d9db4a..35eabcf 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -359,8 +359,7 @@ static struct ata_port_operations k2_sata_ops = {
 static const struct ata_port_info k2_port_info[] = {
 	/* chip_svw4 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | K2_FLAG_NO_ATAPI_DMA,
+		.flags		= ATA_FLAG_SATA | K2_FLAG_NO_ATAPI_DMA,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
@@ -368,8 +367,7 @@ static const struct ata_port_info k2_port_info[] = {
 	},
 	/* chip_svw8 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | K2_FLAG_NO_ATAPI_DMA |
+		.flags		= ATA_FLAG_SATA | K2_FLAG_NO_ATAPI_DMA |
 				  K2_FLAG_SATA_8_PORTS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -378,8 +376,7 @@ static const struct ata_port_info k2_port_info[] = {
 	},
 	/* chip_svw42 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | K2_FLAG_BAR_POS_3,
+		.flags		= ATA_FLAG_SATA | K2_FLAG_BAR_POS_3,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
@@ -387,8 +384,7 @@ static const struct ata_port_info k2_port_info[] = {
 	},
 	/* chip_svw43 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index bedd518..8fd3b72 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -273,9 +273,8 @@ static struct ata_port_operations pdc_20621_ops = {
 static const struct ata_port_info pdc_port_info[] = {
 	/* board_20621 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_SRST | ATA_FLAG_MMIO |
-				  ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_ATAPI |
+				  ATA_FLAG_PIO_POLLING,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index b8578c3..235be71 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -88,8 +88,7 @@ static struct ata_port_operations uli_ops = {
 };
 
 static const struct ata_port_info uli_port_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-			  ATA_FLAG_IGN_SIMPLEX,
+	.flags		= ATA_FLAG_SATA | ATA_FLAG_IGN_SIMPLEX,
 	.pio_mask       = ATA_PIO4,
 	.udma_mask      = ATA_UDMA6,
 	.port_ops       = &uli_ops,
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 8b677bb..21242c5 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -148,7 +148,7 @@ static struct ata_port_operations vt8251_ops = {
 };
 
 static const struct ata_port_info vt6420_port_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SATA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
@@ -156,7 +156,7 @@ static const struct ata_port_info vt6420_port_info = {
 };
 
 static struct ata_port_info vt6421_sport_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SATA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
@@ -164,7 +164,7 @@ static struct ata_port_info vt6421_sport_info = {
 };
 
 static struct ata_port_info vt6421_pport_info = {
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
 	/* No MWDMA */
 	.udma_mask	= ATA_UDMA6,
@@ -172,8 +172,7 @@ static struct ata_port_info vt6421_pport_info = {
 };
 
 static struct ata_port_info vt8251_port_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_SLAVE_POSS |
-			  ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SATA | ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index e079cf2..7c98737 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -340,8 +340,7 @@ static int __devinit vsc_sata_init_one(struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
 {
 	static const struct ata_port_info pi = {
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 9c5c8be..d841e98 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6219,11 +6219,10 @@ static struct ata_port_operations ipr_sata_ops = {
 };
 
 static struct ata_port_info sata_port_info = {
-	.flags	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_SATA_RESET |
-	ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
-	.pio_mask	= 0x10, /* pio4 */
-	.mwdma_mask = 0x07,
-	.udma_mask	= 0x7f, /* udma0-6 */
+	.flags		= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA,
+	.pio_mask	= ATA_PIO4_ONLY,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &ipr_sata_ops
 };
 
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index e1a395b..4d3b704 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -238,37 +238,43 @@ static bool sas_ata_qc_fill_rtf(struct ata_queued_cmd *qc)
 	return true;
 }
 
-static void sas_ata_phy_reset(struct ata_port *ap)
+static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
+			       unsigned long deadline)
 {
+	struct ata_port *ap = link->ap;
 	struct domain_device *dev = ap->private_data;
 	struct sas_internal *i =
 		to_sas_internal(dev->port->ha->core.shost->transportt);
 	int res = TMF_RESP_FUNC_FAILED;
+	int ret = 0;
 
 	if (i->dft->lldd_I_T_nexus_reset)
 		res = i->dft->lldd_I_T_nexus_reset(dev);
 
-	if (res != TMF_RESP_FUNC_COMPLETE)
+	if (res != TMF_RESP_FUNC_COMPLETE) {
 		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __func__);
+		ret = -EAGAIN;
+	}
 
 	switch (dev->sata_dev.command_set) {
 		case ATA_COMMAND_SET:
 			SAS_DPRINTK("%s: Found ATA device.\n", __func__);
-			ap->link.device[0].class = ATA_DEV_ATA;
+			*class = ATA_DEV_ATA;
 			break;
 		case ATAPI_COMMAND_SET:
 			SAS_DPRINTK("%s: Found ATAPI device.\n", __func__);
-			ap->link.device[0].class = ATA_DEV_ATAPI;
+			*class = ATA_DEV_ATAPI;
 			break;
 		default:
 			SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
 				    __func__,
 				    dev->sata_dev.command_set);
-			ap->link.device[0].class = ATA_DEV_UNKNOWN;
+			*class = ATA_DEV_UNKNOWN;
 			break;
 	}
 
 	ap->cbl = ATA_CBL_SATA;
+	return ret;
 }
 
 static void sas_ata_post_internal(struct ata_queued_cmd *qc)
@@ -349,7 +355,11 @@ static int sas_ata_scr_read(struct ata_link *link, unsigned int sc_reg_in,
 }
 
 static struct ata_port_operations sas_sata_ops = {
-	.phy_reset		= sas_ata_phy_reset,
+	.prereset		= ata_std_prereset,
+	.softreset		= NULL,
+	.hardreset		= sas_ata_hard_reset,
+	.postreset		= ata_std_postreset,
+	.error_handler		= ata_std_error_handler,
 	.post_internal_cmd	= sas_ata_post_internal,
 	.qc_defer               = ata_std_qc_defer,
 	.qc_prep		= ata_noop_qc_prep,
@@ -362,10 +372,9 @@ static struct ata_port_operations sas_sata_ops = {
 };
 
 static struct ata_port_info sata_port_info = {
-	.flags = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_SATA_RESET |
-		ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ,
-	.pio_mask = 0x1f, /* PIO0-4 */
-	.mwdma_mask = 0x07, /* MWDMA0-2 */
+	.flags = ATA_FLAG_SATA | ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ,
+	.pio_mask = ATA_PIO4,
+	.mwdma_mask = ATA_MWDMA2,
 	.udma_mask = ATA_UDMA6,
 	.port_ops = &sas_sata_ops
 };
@@ -781,3 +790,68 @@ int sas_discover_sata(struct domain_device *dev)
 
 	return res;
 }
+
+void sas_ata_strategy_handler(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost) {
+		struct domain_device *ddev = sdev_to_domain_dev(sdev);
+		struct ata_port *ap = ddev->sata_dev.ap;
+
+		if (!dev_is_sata(ddev))
+			continue;
+		
+		ata_port_printk(ap, KERN_DEBUG, "sas eh calling libata port error handler");
+		ata_scsi_port_error_handler(shost, ap);
+	}
+}
+
+int sas_ata_timed_out(struct scsi_cmnd *cmd, struct sas_task *task,
+		      enum blk_eh_timer_return *rtn)
+{
+	struct domain_device *ddev = cmd_to_domain_dev(cmd);
+
+	if (!dev_is_sata(ddev) || task)
+		return 0;
+
+	/* we're a sata device with no task, so this must be a libata
+	 * eh timeout.  Ideally should hook into libata timeout
+	 * handling, but there's no point, it just wants to activate
+	 * the eh thread */
+	*rtn = BLK_EH_NOT_HANDLED;
+	return 1;
+}
+
+int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
+	       struct list_head *done_q)
+{
+	int rtn = 0;
+	struct scsi_cmnd *cmd, *n;
+	struct ata_port *ap;
+
+	do {
+		LIST_HEAD(sata_q);
+
+		ap = NULL;
+		
+		list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
+			struct domain_device *ddev = cmd_to_domain_dev(cmd);
+
+			if (!dev_is_sata(ddev) || TO_SAS_TASK(cmd))
+				continue;
+			if(ap && ap != ddev->sata_dev.ap)
+				continue;
+			ap = ddev->sata_dev.ap;
+			rtn = 1;
+			list_move(&cmd->eh_entry, &sata_q);
+		}
+
+		if (!list_empty(&sata_q)) {
+			ata_port_printk(ap, KERN_DEBUG,"sas eh calling libata cmd error handler\n");
+			ata_scsi_cmd_error_handler(shost, ap, &sata_q);
+		}
+	} while (ap);
+
+	return rtn;
+}
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 9a7aaf5..67758ea 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -663,11 +663,16 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 	 * scsi_unjam_host does, but we skip scsi_eh_abort_cmds because any
 	 * command we see here has no sas_task and is thus unknown to the HA.
 	 */
-	if (!scsi_eh_get_sense(&eh_work_q, &ha->eh_done_q))
-		scsi_eh_ready_devs(shost, &eh_work_q, &ha->eh_done_q);
+	if (!sas_ata_eh(shost, &eh_work_q, &ha->eh_done_q))
+		if (!scsi_eh_get_sense(&eh_work_q, &ha->eh_done_q))
+			scsi_eh_ready_devs(shost, &eh_work_q, &ha->eh_done_q);
 
 out:
+	/* now link into libata eh --- if we have any ata devices */
+	sas_ata_strategy_handler(shost);
+
 	scsi_eh_flush_done_q(&ha->eh_done_q);
+
 	SAS_DPRINTK("--- Exit %s\n", __func__);
 	return;
 }
@@ -676,6 +681,11 @@ enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
 {
 	struct sas_task *task = TO_SAS_TASK(cmd);
 	unsigned long flags;
+	enum blk_eh_timer_return rtn; 
+
+	if (sas_ata_timed_out(cmd, task, &rtn))
+		return rtn;
+	
 
 	if (!task) {
 		cmd->request->timeout /= 2;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 0c4929f..32df2b6 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -89,6 +89,7 @@ enum {
 	ATA_ID_SPG		= 98,
 	ATA_ID_LBA_CAPACITY_2	= 100,
 	ATA_ID_SECTOR_SIZE	= 106,
+	ATA_ID_WWN		= 108,
 	ATA_ID_LOGICAL_SECTOR_SIZE	= 117,	/* and 118 */
 	ATA_ID_LAST_LUN		= 126,
 	ATA_ID_DLF		= 128,
@@ -103,6 +104,7 @@ enum {
 	ATA_ID_SERNO_LEN	= 20,
 	ATA_ID_FW_REV_LEN	= 8,
 	ATA_ID_PROD_LEN		= 40,
+	ATA_ID_WWN_LEN		= 8,
 
 	ATA_PCI_CTL_OFS		= 2,
 
@@ -598,42 +600,42 @@ static inline bool ata_id_has_dipm(const u16 *id)
 }
 
 
-static inline int ata_id_has_fua(const u16 *id)
+static inline bool ata_id_has_fua(const u16 *id)
 {
 	if ((id[ATA_ID_CFSSE] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	return id[ATA_ID_CFSSE] & (1 << 6);
 }
 
-static inline int ata_id_has_flush(const u16 *id)
+static inline bool ata_id_has_flush(const u16 *id)
 {
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 12);
 }
 
-static inline int ata_id_flush_enabled(const u16 *id)
+static inline bool ata_id_flush_enabled(const u16 *id)
 {
 	if (ata_id_has_flush(id) == 0)
-		return 0;
+		return false;
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	return id[ATA_ID_CFS_ENABLE_2] & (1 << 12);
 }
 
-static inline int ata_id_has_flush_ext(const u16 *id)
+static inline bool ata_id_has_flush_ext(const u16 *id)
 {
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 13);
 }
 
-static inline int ata_id_flush_ext_enabled(const u16 *id)
+static inline bool ata_id_flush_ext_enabled(const u16 *id)
 {
 	if (ata_id_has_flush_ext(id) == 0)
-		return 0;
+		return false;
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	/*
 	 * some Maxtor disks have bit 13 defined incorrectly
 	 * so check bit 10 too
@@ -686,64 +688,64 @@ static inline u16 ata_id_logical_sector_offset(const u16 *id,
 	return 0;
 }
 
-static inline int ata_id_has_lba48(const u16 *id)
+static inline bool ata_id_has_lba48(const u16 *id)
 {
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	if (!ata_id_u64(id, ATA_ID_LBA_CAPACITY_2))
-		return 0;
+		return false;
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 10);
 }
 
-static inline int ata_id_lba48_enabled(const u16 *id)
+static inline bool ata_id_lba48_enabled(const u16 *id)
 {
 	if (ata_id_has_lba48(id) == 0)
-		return 0;
+		return false;
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	return id[ATA_ID_CFS_ENABLE_2] & (1 << 10);
 }
 
-static inline int ata_id_hpa_enabled(const u16 *id)
+static inline bool ata_id_hpa_enabled(const u16 *id)
 {
 	/* Yes children, word 83 valid bits cover word 82 data */
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	/* And 87 covers 85-87 */
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	/* Check command sets enabled as well as supported */
 	if ((id[ATA_ID_CFS_ENABLE_1] & (1 << 10)) == 0)
-		return 0;
+		return false;
 	return id[ATA_ID_COMMAND_SET_1] & (1 << 10);
 }
 
-static inline int ata_id_has_wcache(const u16 *id)
+static inline bool ata_id_has_wcache(const u16 *id)
 {
 	/* Yes children, word 83 valid bits cover word 82 data */
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	return id[ATA_ID_COMMAND_SET_1] & (1 << 5);
 }
 
-static inline int ata_id_has_pm(const u16 *id)
+static inline bool ata_id_has_pm(const u16 *id)
 {
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	return id[ATA_ID_COMMAND_SET_1] & (1 << 3);
 }
 
-static inline int ata_id_rahead_enabled(const u16 *id)
+static inline bool ata_id_rahead_enabled(const u16 *id)
 {
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	return id[ATA_ID_CFS_ENABLE_1] & (1 << 6);
 }
 
-static inline int ata_id_wcache_enabled(const u16 *id)
+static inline bool ata_id_wcache_enabled(const u16 *id)
 {
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	return id[ATA_ID_CFS_ENABLE_1] & (1 << 5);
 }
 
@@ -773,7 +775,7 @@ static inline unsigned int ata_id_major_version(const u16 *id)
 	return mver;
 }
 
-static inline int ata_id_is_sata(const u16 *id)
+static inline bool ata_id_is_sata(const u16 *id)
 {
 	/*
 	 * See if word 93 is 0 AND drive is at least ATA-5 compatible
@@ -782,37 +784,40 @@ static inline int ata_id_is_sata(const u16 *id)
 	 * 0x0000 and 0xffff along with the earlier ATA revisions...
 	 */
 	if (id[ATA_ID_HW_CONFIG] == 0 && (short)id[ATA_ID_MAJOR_VER] >= 0x0020)
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
-static inline int ata_id_has_tpm(const u16 *id)
+static inline bool ata_id_has_tpm(const u16 *id)
 {
 	/* The TPM bits are only valid on ATA8 */
 	if (ata_id_major_version(id) < 8)
-		return 0;
+		return false;
 	if ((id[48] & 0xC000) != 0x4000)
-		return 0;
+		return false;
 	return id[48] & (1 << 0);
 }
 
-static inline int ata_id_has_dword_io(const u16 *id)
+static inline bool ata_id_has_dword_io(const u16 *id)
 {
 	/* ATA 8 reuses this flag for "trusted" computing */
 	if (ata_id_major_version(id) > 7)
-		return 0;
-	if (id[ATA_ID_DWORD_IO] & (1 << 0))
-		return 1;
-	return 0;
+		return false;
+	return id[ATA_ID_DWORD_IO] & (1 << 0);
 }
 
-static inline int ata_id_has_unload(const u16 *id)
+static inline bool ata_id_has_unload(const u16 *id)
 {
 	if (ata_id_major_version(id) >= 7 &&
 	    (id[ATA_ID_CFSSE] & 0xC000) == 0x4000 &&
 	    id[ATA_ID_CFSSE] & (1 << 13))
-		return 1;
-	return 0;
+		return true;
+	return false;
+}
+
+static inline bool ata_id_has_wwn(const u16 *id)
+{
+	return (id[ATA_ID_CSF_DEFAULT] & 0xC100) == 0x4100;
 }
 
 static inline int ata_id_form_factor(const u16 *id)
@@ -843,25 +848,25 @@ static inline int ata_id_rotation_rate(const u16 *id)
 	return val;
 }
 
-static inline int ata_id_has_trim(const u16 *id)
+static inline bool ata_id_has_trim(const u16 *id)
 {
 	if (ata_id_major_version(id) >= 7 &&
 	    (id[ATA_ID_DATA_SET_MGMT] & 1))
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
-static inline int ata_id_has_zero_after_trim(const u16 *id)
+static inline bool ata_id_has_zero_after_trim(const u16 *id)
 {
 	/* DSM supported, deterministic read, and read zero after trim set */
 	if (ata_id_has_trim(id) &&
 	    (id[ATA_ID_ADDITIONAL_SUPP] & 0x4020) == 0x4020)
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
-static inline int ata_id_current_chs_valid(const u16 *id)
+static inline bool ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
 	   has not been issued to the device then the values of
@@ -873,11 +878,11 @@ static inline int ata_id_current_chs_valid(const u16 *id)
 		id[ATA_ID_CUR_SECTORS];    /* sectors in current translation */
 }
 
-static inline int ata_id_is_cfa(const u16 *id)
+static inline bool ata_id_is_cfa(const u16 *id)
 {
 	if ((id[ATA_ID_CONFIG] == 0x848A) ||	/* Traditional CF */
 	    (id[ATA_ID_CONFIG] == 0x844A))	/* Delkin Devices CF */
-		return 1;
+		return true;
 	/*
 	 * CF specs don't require specific value in the word 0 anymore and yet
 	 * they forbid to report the ATA version in the word 80 and require the
@@ -886,44 +891,40 @@ static inline int ata_id_is_cfa(const u16 *id)
 	 * and while those that don't indicate CFA feature support need some
 	 * sort of quirk list, it seems impractical for the ones that do...
 	 */
-	if ((id[ATA_ID_COMMAND_SET_2] & 0xC004) == 0x4004)
-		return 1;
-	return 0;
+	return (id[ATA_ID_COMMAND_SET_2] & 0xC004) == 0x4004;
 }
 
-static inline int ata_id_is_ssd(const u16 *id)
+static inline bool ata_id_is_ssd(const u16 *id)
 {
 	return id[ATA_ID_ROT_SPEED] == 0x01;
 }
 
-static inline int ata_id_pio_need_iordy(const u16 *id, const u8 pio)
+static inline bool ata_id_pio_need_iordy(const u16 *id, const u8 pio)
 {
 	/* CF spec. r4.1 Table 22 says no IORDY on PIO5 and PIO6. */
 	if (pio > 4 && ata_id_is_cfa(id))
-		return 0;
+		return false;
 	/* For PIO3 and higher it is mandatory. */
 	if (pio > 2)
-		return 1;
+		return true;
 	/* Turn it on when possible. */
-	if (ata_id_has_iordy(id))
-		return 1;
-	return 0;
+	return ata_id_has_iordy(id);
 }
 
-static inline int ata_drive_40wire(const u16 *dev_id)
+static inline bool ata_drive_40wire(const u16 *dev_id)
 {
 	if (ata_id_is_sata(dev_id))
-		return 0;	/* SATA */
+		return false;	/* SATA */
 	if ((dev_id[ATA_ID_HW_CONFIG] & 0xE000) == 0x6000)
-		return 0;	/* 80 wire */
-	return 1;
+		return false;	/* 80 wire */
+	return true;
 }
 
-static inline int ata_drive_40wire_relaxed(const u16 *dev_id)
+static inline bool ata_drive_40wire_relaxed(const u16 *dev_id)
 {
 	if ((dev_id[ATA_ID_HW_CONFIG] & 0x2000) == 0x2000)
-		return 0;	/* 80 wire */
-	return 1;
+		return false;	/* 80 wire */
+	return true;
 }
 
 static inline int atapi_cdb_len(const u16 *dev_id)
@@ -936,12 +937,12 @@ static inline int atapi_cdb_len(const u16 *dev_id)
 	}
 }
 
-static inline int atapi_command_packet_set(const u16 *dev_id)
+static inline bool atapi_command_packet_set(const u16 *dev_id)
 {
 	return (dev_id[ATA_ID_CONFIG] >> 8) & 0x1f;
 }
 
-static inline int atapi_id_dmadir(const u16 *dev_id)
+static inline bool atapi_id_dmadir(const u16 *dev_id)
 {
 	return ata_id_major_version(dev_id) >= 7 && (dev_id[62] & 0x8000);
 }
@@ -954,13 +955,13 @@ static inline int atapi_id_dmadir(const u16 *dev_id)
  *
  * It is called only once for each device.
  */
-static inline int ata_id_is_lba_capacity_ok(u16 *id)
+static inline bool ata_id_is_lba_capacity_ok(u16 *id)
 {
 	unsigned long lba_sects, chs_sects, head, tail;
 
 	/* No non-LBA info .. so valid! */
 	if (id[ATA_ID_CYLS] == 0)
-		return 1;
+		return true;
 
 	lba_sects = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
 
@@ -975,13 +976,13 @@ static inline int ata_id_is_lba_capacity_ok(u16 *id)
 	    id[ATA_ID_SECTORS] == 63 &&
 	    (id[ATA_ID_HEADS] == 15 || id[ATA_ID_HEADS] == 16) &&
 	    (lba_sects >= 16383 * 63 * id[ATA_ID_HEADS]))
-		return 1;
+		return true;
 
 	chs_sects = id[ATA_ID_CYLS] * id[ATA_ID_HEADS] * id[ATA_ID_SECTORS];
 
 	/* perform a rough sanity check on lba_sects: within 10% is OK */
 	if (lba_sects - chs_sects < chs_sects/10)
-		return 1;
+		return true;
 
 	/* some drives have the word order reversed */
 	head = (lba_sects >> 16) & 0xffff;
@@ -990,10 +991,10 @@ static inline int ata_id_is_lba_capacity_ok(u16 *id)
 
 	if (lba_sects - chs_sects < chs_sects/10) {
 		*(__le32 *)&id[ATA_ID_LBA_CAPACITY] = __cpu_to_le32(lba_sects);
-		return 1;	/* LBA capacity is (now) good */
+		return true;	/* LBA capacity is (now) good */
 	}
 
-	return 0;	/* LBA capacity value may be bad */
+	return false;	/* LBA capacity value may be bad */
 }
 
 static inline void ata_id_to_hd_driveid(u16 *id)
@@ -1051,19 +1052,19 @@ static inline int is_multi_taskfile(struct ata_taskfile *tf)
 	       (tf->command == ATA_CMD_WRITE_MULTI_FUA_EXT);
 }
 
-static inline int ata_ok(u8 status)
+static inline bool ata_ok(u8 status)
 {
 	return ((status & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ | ATA_ERR))
 			== ATA_DRDY);
 }
 
-static inline int lba_28_ok(u64 block, u32 n_block)
+static inline bool lba_28_ok(u64 block, u32 n_block)
 {
 	/* check the ending block number: must be LESS THAN 0x0fffffff */
 	return ((block + n_block) < ((1 << 28) - 1)) && (n_block <= 256);
 }
 
-static inline int lba_48_ok(u64 block, u32 n_block)
+static inline bool lba_48_ok(u64 block, u32 n_block)
 {
 	/* check the ending block number */
 	return ((block + n_block - 1) < ((u64)1 << 48)) && (n_block <= 65536);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c9c5d7a..c71f469 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -179,10 +179,6 @@ enum {
 	ATA_FLAG_SLAVE_POSS	= (1 << 0), /* host supports slave dev */
 					    /* (doesn't imply presence) */
 	ATA_FLAG_SATA		= (1 << 1),
-	ATA_FLAG_NO_LEGACY	= (1 << 2), /* no legacy mode check */
-	ATA_FLAG_MMIO		= (1 << 3), /* use MMIO, not PIO */
-	ATA_FLAG_SRST		= (1 << 4), /* (obsolete) use ATA SRST, not E.D.D. */
-	ATA_FLAG_SATA_RESET	= (1 << 5), /* (obsolete) use COMRESET */
 	ATA_FLAG_NO_ATAPI	= (1 << 6), /* No ATAPI support */
 	ATA_FLAG_PIO_DMA	= (1 << 7), /* PIO cmds via DMA */
 	ATA_FLAG_PIO_LBA48	= (1 << 8), /* Host DMA engine is LBA28 only */
@@ -198,7 +194,6 @@ enum {
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
 	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */
 	ATA_FLAG_PMP		= (1 << 19), /* controller supports PMP */
-	ATA_FLAG_LPM		= (1 << 20), /* driver can handle LPM */
 	ATA_FLAG_EM		= (1 << 21), /* driver supports enclosure
 					      * management */
 	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
@@ -1050,6 +1045,8 @@ extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth, int reason);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
+extern void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap);
+extern void ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap, struct list_head *eh_q);
 
 extern int ata_cable_40wire(struct ata_port *ap);
 extern int ata_cable_80wire(struct ata_port *ap);
@@ -1613,6 +1610,9 @@ extern void ata_sff_irq_on(struct ata_port *ap);
 extern void ata_sff_irq_clear(struct ata_port *ap);
 extern int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 			    u8 status, int in_wq);
+extern void ata_sff_queue_work(struct work_struct *work);
+extern void ata_sff_queue_delayed_work(struct delayed_work *dwork,
+		unsigned long delay);
 extern void ata_sff_queue_pio_task(struct ata_link *link, unsigned long delay);
 extern unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc);
 extern bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc);
diff --git a/include/linux/pata_arasan_cf_data.h b/include/linux/pata_arasan_cf_data.h
new file mode 100644
index 0000000..a6ee9aa
--- /dev/null
+++ b/include/linux/pata_arasan_cf_data.h
@@ -0,0 +1,49 @@
+/*
+ * include/linux/pata_arasan_cf_data.h
+ *
+ * Arasan Compact Flash host controller platform data header file
+ *
+ * Copyright (C) 2011 ST Microelectronics
+ * Viresh Kumar <viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _PATA_ARASAN_CF_DATA_H
+#define _PATA_ARASAN_CF_DATA_H
+
+#include <linux/platform_device.h>
+
+struct arasan_cf_pdata {
+	u8 cf_if_clk;
+	#define CF_IF_CLK_100M			(0x0)
+	#define CF_IF_CLK_75M			(0x1)
+	#define CF_IF_CLK_66M			(0x2)
+	#define CF_IF_CLK_50M			(0x3)
+	#define CF_IF_CLK_40M			(0x4)
+	#define CF_IF_CLK_33M			(0x5)
+	#define CF_IF_CLK_25M			(0x6)
+	#define CF_IF_CLK_125M			(0x7)
+	#define CF_IF_CLK_150M			(0x8)
+	#define CF_IF_CLK_166M			(0x9)
+	#define CF_IF_CLK_200M			(0xA)
+	/*
+	 * Platform specific incapabilities of CF controller is handled via
+	 * quirks
+	 */
+	u32 quirk;
+	#define CF_BROKEN_PIO			(1)
+	#define CF_BROKEN_MWDMA			(1 << 1)
+	#define CF_BROKEN_UDMA			(1 << 2)
+	/* This is platform specific data for the DMA controller */
+	void *dma_priv;
+};
+
+static inline void
+set_arasan_cf_pdata(struct platform_device *pdev, struct arasan_cf_pdata *data)
+{
+	pdev->dev.platform_data = data;
+}
+#endif /* _PATA_ARASAN_CF_DATA_H */
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index c583193..9c159f7 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -39,6 +39,11 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 			       struct scsi_target *starget);
 
 void sas_ata_task_abort(struct sas_task *task);
+void sas_ata_strategy_handler(struct Scsi_Host *shost);
+int sas_ata_timed_out(struct scsi_cmnd *cmd, struct sas_task *task,
+		      enum blk_eh_timer_return *rtn);
+int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
+	       struct list_head *done_q);
 
 #else
 
@@ -55,6 +60,23 @@ static inline int sas_ata_init_host_and_port(struct domain_device *found_dev,
 static inline void sas_ata_task_abort(struct sas_task *task)
 {
 }
+
+static inline void sas_ata_strategy_handler(struct Scsi_Host *shost)
+{
+}
+
+static inline int sas_ata_timed_out(struct scsi_cmnd *cmd,
+				    struct sas_task *task,
+				    enum blk_eh_timer_return *rtn)
+{
+	return 0;
+}
+static inline int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
+			     struct list_head *done_q)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* _SAS_ATA_H_ */
