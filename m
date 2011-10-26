Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1JZUla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:41:30 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42349 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab1JZUl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:41:27 -0400
X-Greylist: delayed 1130 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 16:41:26 EDT
Date: Wed, 26 Oct 2011 16:22:35 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates, GPG signed (but see admin notes)
Message-ID: <20111026202235.GA20928@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


changes, nothing major:

1) many minor PATA fixes and cleanups from Bart Z

2) pata_legacy has supported QDI PATA for a while, so we may
   eliminate pata_qdi driver as duplicate. (Bart Z, acked by Alan)

3) add power management support to several PATA drivers (Bart Z)

4) other minor PATA, SATA driver fixes and cleanups (various)

5) fix ATAPI device + Sandybridge issue (Intel, Canonical)

6) make pata_of_platform work again on !PPC -- though note we hope to replace
   this with pata_platform + DT (patch by Grant L exists)

7) core bug fix from Tejun: garbage data could be transferred to an
   ATAPI device as padding,  Presumably, as this is padding, the bytes are
   irrelevant -- but at least one nutty device wants padding == zeroes.

administrivia notes:

1) This entire pull request is GPG-signed by a new GPG key 01782B2F
   (jgarzik@pobox.com, AF8B E07C 7049 F3A2 6B23  9D53 25B3 0832 0178 2B2F),
   created for new kernel.org interactions.  However, not being at KS, I've
   only gotten Andre Hedrick to sign this new key so far.  In addition to
   pgp.mit.edu keyserver, my pubkey is published on my personal website at
   http://yyz.us/publickey.txt

2) The GPG wrapping causes all '^-' lines to become '^- -'.  This does NOT
   reflect the true 'git diff' output, of course.

   For this reason, I am tempted to modify my new, GPG-signed pull request
   template as follows, for subsequent pull requests:

	---<begin GPG signed text>---

   	pull req description

	"Please pull from $branch\n$url $branch"

	"Top of tree is $sha1_commit"

	---<end GPG signed text>---

	diffstat
	diff

   That ensures that the critical part -- sha1 commit for top of tree --
   is GPG signed, while the diff will be outside the signed area and therefore
   not mangled by wrapping.


Please pull from 'upstream-linus' branch of
git://github.com/jgarzik/libata-dev.git upstream-linus

ToT commit a0da19149f589e3e6fd5bab527b3326368ab92bc

to receive the following updates:

 drivers/ata/Kconfig            |    3 +-
 drivers/ata/Makefile           |    1 -
 drivers/ata/ahci_platform.c    |   44 ++++-
 drivers/ata/ata_piix.c         |  153 ++++++++---------
 drivers/ata/libata-core.c      |    2 +-
 drivers/ata/libata-eh.c        |    5 +-
 drivers/ata/libata-sff.c       |  117 ++++++--------
 drivers/ata/pata_ali.c         |    2 +-
 drivers/ata/pata_arasan_cf.c   |    6 +-
 drivers/ata/pata_artop.c       |  107 +++++++------
 drivers/ata/pata_at91.c        |    5 +-
 drivers/ata/pata_atiixp.c      |   35 +++-
 drivers/ata/pata_cmd64x.c      |   44 +++---
 drivers/ata/pata_cs5535.c      |   16 +--
 drivers/ata/pata_efar.c        |   22 ++--
 drivers/ata/pata_hpt366.c      |   35 +++-
 drivers/ata/pata_it8213.c      |   24 ++--
 drivers/ata/pata_legacy.c      |  129 +++++----------
 drivers/ata/pata_mpc52xx.c     |    2 +-
 drivers/ata/pata_of_platform.c |    6 +-
 drivers/ata/pata_pdc2027x.c    |   30 ++++
 drivers/ata/pata_qdi.c         |  366 ----------------------------------------
 drivers/ata/pata_rdc.c         |   16 ++
 drivers/ata/pata_sc1200.c      |   14 +-
 drivers/ata/pata_scc.c         |   14 +--
 drivers/ata/pata_serverworks.c |  127 +++++---------
 drivers/ata/pata_sil680.c      |   94 ++++++-----
 drivers/ata/pata_sis.c         |  154 +++++++++++------
 drivers/ata/pata_sl82c105.c    |   37 ++++-
 drivers/ata/pata_via.c         |   49 +++---
 drivers/ata/sata_mv.c          |   16 +-
 drivers/ata/sata_sil24.c       |    4 +-
 32 files changed, 692 insertions(+), 987 deletions(-)
 delete mode 100644 drivers/ata/pata_qdi.c

Bartlomiej Zolnierkiewicz (34):
      pata_sil680: documentation fixes
      pata_sil680: constify tables
      pata_sil680: minor CodingStyle fixups
      pata_sc1200: fix DRV_NAME
      pata_cs5535: fix DRV_NAME
      libata: reduce ata_pci_[sff,bmdma]_init_one() size
      pata_sc1200: do not use c99 style comments
      pata_artop: unify ->prereset methods
      pata_hpt366: add hpt36x_find_mode() helper
      pata_cmd64x: add cmd64x_fixup()
      pata_cs5535: no need to program PIO0 timings during device init
      pata_ali: fix "Satelite" typo
      pata_cmd64x: documentation fix
      pata_serverworks: use standard cable detection methods
      pata_serverworks: cleanup cable detection
      pata_serverworks: add serverworks_fixup()
      pata_atiixp: add proper ->prereset method
      pata_scc: add proper cable detection method
      libata: ata_timing_compute() fixup
      pata_via: add via_fixup()
      pata_rdc: parallel scanning needs an extra locking
      pata_it8213: add UDMA100 and UDMA133 support
      pata_it8213: fix register naming used in it8213_set_piomode()
      libata: remove no longer needed pata_qdi driver
      pata_legacy: unify QDI ->set_piomode methods
      pata_legacy: use PIO mask defines
      pata_pdc2027x: add Power Management support
      pata_sl82c105: add Power Management support
      pata_artop: add Power Management support
      libata: make ata_sff_data_xfer_noirq() work with 32-bit PIO
      ata_piix: SITRE handling fix
      ata_piix: unify code for programming PIO and MWDMA timings
      pata_rdc: add Power Management support
      pata_efar: fix register naming used in efar_set_piomode()

Dan McGee (5):
      pata_sis: extract a sis_port_base() method
      pata_sis: add mode_filter method for certain sis5513 chipsets
      pata_sis: enable MWDMA for UDMA 133 chipset
      pata_sis: mark most const data static as well
      pata_sis: code style cleanups for consistency

Joe Perches (1):
      sata_sil24: Use const

Ming Lei (1):
      ata_piix: make DVD Drive recognisable on systems with Intel Sandybridge chipsets(v2)

Pawel Moll (1):
      ata: Make pata_of_platform.c compile again and work on non-PPC platforms

Richard Zhu (1):
      [libata] ahci_platform: Add the board_ids and pi refer to different features

Sergei Shtylyov (5):
      sata_mv: release clock on ata_host_activate() failure
      sata_mv: use {platform|pci}_get_drvdata()
      libata-eh: ata_eh_followup_srst_needed() does not need 'classes' parameter
      pata_at91: call clk_put() on ata_host_activate() failure
      pata_arasan_cf: remove bogus to_platform_device() calls

Tejun Heo (1):
      libata: clear PIO pad area

Yong Zhang (1):
      ata: irq: Remove IRQF_DISABLED

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 5987e0b..6bdedd7 100644
- --- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -820,7 +820,7 @@ config PATA_PLATFORM
 
 config PATA_OF_PLATFORM
 	tristate "OpenFirmware platform device PATA support"
- -	depends on PATA_PLATFORM && PPC_OF
+	depends on PATA_PLATFORM && OF
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems with OpenFirmware
@@ -831,6 +831,7 @@ config PATA_OF_PLATFORM
 config PATA_QDI
 	tristate "QDI VLB PATA support"
 	depends on ISA
+	select PATA_LEGACY
 	help
 	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
 
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 9550d69..6ece5b7 100644
- --- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -88,7 +88,6 @@ obj-$(CONFIG_PATA_PCMCIA)	+= pata_pcmcia.o
 obj-$(CONFIG_PATA_PALMLD)	+= pata_palmld.o
 obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
 obj-$(CONFIG_PATA_OF_PLATFORM)	+= pata_of_platform.o
- -obj-$(CONFIG_PATA_QDI)		+= pata_qdi.o
 obj-$(CONFIG_PATA_RB532)	+= pata_rb532_cf.o
 obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
 obj-$(CONFIG_PATA_SAMSUNG_CF)	+= pata_samsung_cf.o
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 6fef1fa..c03277d 100644
- --- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -23,6 +23,41 @@
 #include <linux/ahci_platform.h>
 #include "ahci.h"
 
+enum ahci_type {
+	AHCI,		/* standard platform ahci */
+	IMX53_AHCI,	/* ahci on i.mx53 */
+};
+
+static struct platform_device_id ahci_devtype[] = {
+	{
+		.name = "ahci",
+		.driver_data = AHCI,
+	}, {
+		.name = "imx53-ahci",
+		.driver_data = IMX53_AHCI,
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(platform, ahci_devtype);
+
+
+static const struct ata_port_info ahci_port_info[] = {
+	/* by features */
+	[AHCI] = {
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
+	[IMX53_AHCI] = {
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_pmp_retry_srst_ops,
+	},
+};
+
 static struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT("ahci_platform"),
 };
@@ -31,12 +66,8 @@ static int __init ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_platform_data *pdata = dev->platform_data;
- -	struct ata_port_info pi = {
- -		.flags		= AHCI_FLAG_COMMON,
- -		.pio_mask	= ATA_PIO4,
- -		.udma_mask	= ATA_UDMA6,
- -		.port_ops	= &ahci_ops,
- -	};
+	const struct platform_device_id *id = platform_get_device_id(pdev);
+	struct ata_port_info pi = ahci_port_info[id->driver_data];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
@@ -177,6 +208,7 @@ static struct platform_driver ahci_driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
 	},
+	.id_table	= ahci_devtype,
 };
 
 static int __init ahci_init(void)
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 43107e9..69ac373 100644
- --- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -113,6 +113,8 @@ enum {
 	PIIX_PATA_FLAGS		= ATA_FLAG_SLAVE_POSS,
 	PIIX_SATA_FLAGS		= ATA_FLAG_SATA | PIIX_FLAG_CHECKINTR,
 
+	PIIX_FLAG_PIO16		= (1 << 30), /*support 16bit PIO only*/
+
 	PIIX_80C_PRI		= (1 << 5) | (1 << 4),
 	PIIX_80C_SEC		= (1 << 7) | (1 << 6),
 
@@ -147,6 +149,7 @@ enum piix_controller_ids {
 	ich8m_apple_sata,	/* locks up on second port enable */
 	tolapai_sata,
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
+	ich8_sata_snb,
 };
 
 struct piix_map_db {
@@ -177,6 +180,7 @@ static int piix_sidpr_scr_write(struct ata_link *link,
 static int piix_sidpr_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			      unsigned hints);
 static bool piix_irq_check(struct ata_port *ap);
+static int piix_port_start(struct ata_port *ap);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int piix_pci_device_resume(struct pci_dev *pdev);
@@ -298,21 +302,21 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (CPT) */
- -	{ 0x8086, 0x1c00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ 0x8086, 0x1c00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (CPT) */
- -	{ 0x8086, 0x1c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ 0x8086, 0x1c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (CPT) */
 	{ 0x8086, 0x1c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (CPT) */
 	{ 0x8086, 0x1c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (PBG) */
- -	{ 0x8086, 0x1d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ 0x8086, 0x1d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (PBG) */
 	{ 0x8086, 0x1d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Panther Point) */
- -	{ 0x8086, 0x1e00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ 0x8086, 0x1e00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Panther Point) */
- -	{ 0x8086, 0x1e01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ 0x8086, 0x1e01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Panther Point) */
 	{ 0x8086, 0x1e08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Panther Point) */
@@ -338,6 +342,7 @@ static struct scsi_host_template piix_sht = {
 static struct ata_port_operations piix_sata_ops = {
 	.inherits		= &ata_bmdma32_port_ops,
 	.sff_irq_check		= piix_irq_check,
+	.port_start		= piix_port_start,
 };
 
 static struct ata_port_operations piix_pata_ops = {
@@ -478,6 +483,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[ich8_2port_sata]	= &ich8_2port_map_db,
 	[ich8m_apple_sata]	= &ich8m_apple_map_db,
 	[tolapai_sata]		= &tolapai_map_db,
+	[ich8_sata_snb]		= &ich8_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -606,6 +612,19 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_vmw_ops,
 	},
 
+	/*
+	 * some Sandybridge chipsets have broken 32 mode up to now,
+	 * see https://bugzilla.kernel.org/show_bug.cgi?id=40592
+	 */
+	[ich8_sata_snb] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -649,6 +668,14 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0, }
 };
 
+static int piix_port_start(struct ata_port *ap)
+{
+	if (!(ap->flags & PIIX_FLAG_PIO16))
+		ap->pflags |= ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE;
+
+	return ata_bmdma_port_start(ap);
+}
+
 /**
  *	ich_pata_cable_detect - Probe host controller cable detect info
  *	@ap: Port for which cable detect info is desired
@@ -704,22 +731,11 @@ static int piix_pata_prereset(struct ata_link *link, unsigned long deadline)
 
 static DEFINE_SPINLOCK(piix_lock);
 
- -/**
- - *	piix_set_piomode - Initialize host controller PATA PIO timings
- - *	@ap: Port whose timings we are configuring
- - *	@adev: um
- - *
- - *	Set PIO mode for device, in host controller PCI config space.
- - *
- - *	LOCKING:
- - *	None (inherited from caller).
- - */
- -
- -static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
+			     u8 pio)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned long flags;
- -	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	unsigned int is_slave	= (adev->devno != 0);
 	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
 	unsigned int slave_port	= 0x44;
@@ -744,10 +760,16 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		control |= 1;	/* TIME1 enable */
 	if (ata_pio_need_iordy(adev))
 		control |= 2;	/* IE enable */
- -
 	/* Intel specifies that the PPE functionality is for disk only */
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE enable */
+	/*
+	 * If the drive MWDMA is faster than it can do PIO then
+	 * we must force PIO into PIO0
+	 */
+	if (adev->pio_mode < XFER_PIO_0 + pio)
+		/* Enable DMA timing only */
+		control |= 8;	/* PIO cycles in PIO0 */
 
 	spin_lock_irqsave(&piix_lock, flags);
 
@@ -759,8 +781,6 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	if (is_slave) {
 		/* clear TIME1|IE1|PPE1|DTE1 */
 		master_data &= 0xff0f;
- -		/* Enable SITRE (separate slave timing register) */
- -		master_data |= 0x4000;
 		/* enable PPE1, IE1 and TIME1 as needed */
 		master_data |= (control << 4);
 		pci_read_config_byte(dev, slave_port, &slave_data);
@@ -778,6 +798,9 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 			(timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
 	}
+
+	/* Enable SITRE (separate slave timing register) */
+	master_data |= 0x4000;
 	pci_write_config_word(dev, master_port, master_data);
 	if (is_slave)
 		pci_write_config_byte(dev, slave_port, slave_data);
@@ -795,6 +818,22 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
+ *	piix_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Drive in question
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	piix_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0);
+}
+
+/**
  *	do_pata_set_dmamode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Drive in question
@@ -810,31 +849,20 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned long flags;
- -	u8 master_port		= ap->port_no ? 0x42 : 0x40;
- -	u16 master_data;
 	u8 speed		= adev->dma_mode;
 	int devid		= adev->devno + 2 * ap->port_no;
 	u8 udma_enable		= 0;
 
- -	static const	 /* ISP  RTC */
- -	u8 timings[][2]	= { { 0, 0 },
- -			    { 0, 0 },
- -			    { 1, 0 },
- -			    { 2, 1 },
- -			    { 2, 3 }, };
- -
- -	spin_lock_irqsave(&piix_lock, flags);
- -
- -	pci_read_config_word(dev, master_port, &master_data);
- -	if (ap->udma_mask)
- -		pci_read_config_byte(dev, 0x48, &udma_enable);
- -
 	if (speed >= XFER_UDMA_0) {
- -		unsigned int udma = adev->dma_mode - XFER_UDMA_0;
+		unsigned int udma = speed - XFER_UDMA_0;
 		u16 udma_timing;
 		u16 ideconf;
 		int u_clock, u_speed;
 
+		spin_lock_irqsave(&piix_lock, flags);
+
+		pci_read_config_byte(dev, 0x48, &udma_enable);
+
 		/*
 		 * UDMA is handled by a combination of clock switching and
 		 * selection of dividers
@@ -867,56 +895,21 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
 			   performance (WR_PingPong_En) */
 			pci_write_config_word(dev, 0x54, ideconf);
 		}
+
+		pci_write_config_byte(dev, 0x48, udma_enable);
+
+		spin_unlock_irqrestore(&piix_lock, flags);
 	} else {
- -		/*
- -		 * MWDMA is driven by the PIO timings. We must also enable
- -		 * IORDY unconditionally along with TIME1. PPE has already
- -		 * been set when the PIO timing was set.
- -		 */
- -		unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
- -		unsigned int control;
- -		u8 slave_data;
+		/* MWDMA is driven by the PIO timings. */
+		unsigned int mwdma = speed - XFER_MW_DMA_0;
 		const unsigned int needed_pio[3] = {
 			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
 		};
 		int pio = needed_pio[mwdma] - XFER_PIO_0;
 
- -		control = 3;	/* IORDY|TIME1 */
- -
- -		/* If the drive MWDMA is faster than it can do PIO then
- -		   we must force PIO into PIO0 */
- -
- -		if (adev->pio_mode < needed_pio[mwdma])
- -			/* Enable DMA timing only */
- -			control |= 8;	/* PIO cycles in PIO0 */
- -
- -		if (adev->devno) {	/* Slave */
- -			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
- -			master_data |= control << 4;
- -			pci_read_config_byte(dev, 0x44, &slave_data);
- -			slave_data &= (ap->port_no ? 0x0f : 0xf0);
- -			/* Load the matching timing */
- -			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
- -			pci_write_config_byte(dev, 0x44, slave_data);
- -		} else { 	/* Master */
- -			master_data &= 0xCCF4;	/* Mask out IORDY|TIME1|DMAONLY
- -						   and master timing bits */
- -			master_data |= control;
- -			master_data |=
- -				(timings[pio][0] << 12) |
- -				(timings[pio][1] << 8);
- -		}
- -
- -		if (ap->udma_mask)
- -			udma_enable &= ~(1 << devid);
- -
- -		pci_write_config_word(dev, master_port, master_data);
+		/* XFER_PIO_0 is never used currently */
+		piix_set_timings(ap, adev, pio);
 	}
- -	/* Don't scribble on 0x48 if the controller does not support UDMA */
- -	if (ap->udma_mask)
- -		pci_write_config_byte(dev, 0x48, udma_enable);
- -
- -	spin_unlock_irqrestore(&piix_lock, flags);
 }
 
 /**
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4a3a5ae..32fc41c 100644
- --- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2938,7 +2938,7 @@ int ata_timing_compute(struct ata_device *adev, unsigned short speed,
 	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
 		memset(&p, 0, sizeof(p));
 
- -		if (speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
+		if (speed >= XFER_PIO_0 && speed < XFER_SW_DMA_0) {
 			if (speed <= XFER_PIO_2)
 				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
 			else if ((speed <= XFER_PIO_4) ||
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index ed16fbe..c021186 100644
- --- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2532,8 +2532,7 @@ static int ata_do_reset(struct ata_link *link, ata_reset_fn_t reset,
 	return reset(link, classes, deadline);
 }
 
- -static int ata_eh_followup_srst_needed(struct ata_link *link,
- -				       int rc, const unsigned int *classes)
+static int ata_eh_followup_srst_needed(struct ata_link *link, int rc)
 {
 	if ((link->flags & ATA_LFLAG_NO_SRST) || ata_link_offline(link))
 		return 0;
@@ -2726,7 +2725,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 		/* perform follow-up SRST if necessary */
 		if (reset == hardreset &&
- -		    ata_eh_followup_srst_needed(link, rc, classes)) {
+		    ata_eh_followup_srst_needed(link, rc)) {
 			reset = softreset;
 
 			if (!reset) {
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index c24127d..239bfa6 100644
- --- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -569,7 +569,7 @@ unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,
 
 	/* Transfer trailing byte, if any. */
 	if (unlikely(buflen & 0x01)) {
- -		unsigned char pad[2];
+		unsigned char pad[2] = { };
 
 		/* Point buf to the tail of buffer */
 		buf += buflen - 1;
@@ -628,7 +628,7 @@ unsigned int ata_sff_data_xfer32(struct ata_device *dev, unsigned char *buf,
 
 	/* Transfer trailing bytes, if any */
 	if (unlikely(slop)) {
- -		unsigned char pad[4];
+		unsigned char pad[4] = { };
 
 		/* Point buf to the tail of buffer */
 		buf += buflen - slop;
@@ -678,7 +678,7 @@ unsigned int ata_sff_data_xfer_noirq(struct ata_device *dev, unsigned char *buf,
 	unsigned int consumed;
 
 	local_irq_save(flags);
- -	consumed = ata_sff_data_xfer(dev, buf, buflen, rw);
+	consumed = ata_sff_data_xfer32(dev, buf, buflen, rw);
 	local_irq_restore(flags);
 
 	return consumed;
@@ -2507,31 +2507,10 @@ static const struct ata_port_info *ata_sff_find_valid_pi(
 	return NULL;
 }
 
- -/**
- - *	ata_pci_sff_init_one - Initialize/register PIO-only PCI IDE controller
- - *	@pdev: Controller to be initialized
- - *	@ppi: array of port_info, must be enough for two ports
- - *	@sht: scsi_host_template to use when registering the host
- - *	@host_priv: host private_data
- - *	@hflag: host flags
- - *
- - *	This is a helper function which can be called from a driver's
- - *	xxx_init_one() probe function if the hardware uses traditional
- - *	IDE taskfile registers and is PIO only.
- - *
- - *	ASSUMPTION:
- - *	Nobody makes a single channel controller that appears solely as
- - *	the secondary legacy port on PCI.
- - *
- - *	LOCKING:
- - *	Inherited from PCI layer (may sleep).
- - *
- - *	RETURNS:
- - *	Zero on success, negative on errno-based value on error.
- - */
- -int ata_pci_sff_init_one(struct pci_dev *pdev,
- -		 const struct ata_port_info * const *ppi,
- -		 struct scsi_host_template *sht, void *host_priv, int hflag)
+static int ata_pci_init_one(struct pci_dev *pdev,
+		const struct ata_port_info * const *ppi,
+		struct scsi_host_template *sht, void *host_priv,
+		int hflags, bool bmdma)
 {
 	struct device *dev = &pdev->dev;
 	const struct ata_port_info *pi;
@@ -2553,14 +2532,22 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 	if (rc)
 		goto out;
 
- -	/* prepare and activate SFF host */
- -	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	if (bmdma)
+		/* prepare and activate BMDMA host */
+		rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
+	else
+		/* prepare and activate SFF host */
+		rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
 	if (rc)
 		goto out;
 	host->private_data = host_priv;
- -	host->flags |= hflag;
+	host->flags |= hflags;
 
- -	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
+	if (bmdma) {
+		pci_set_master(pdev);
+		rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
+	} else
+		rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
 out:
 	if (rc == 0)
 		devres_remove_group(&pdev->dev, NULL);
@@ -2569,6 +2556,35 @@ out:
 
 	return rc;
 }
+
+/**
+ *	ata_pci_sff_init_one - Initialize/register PIO-only PCI IDE controller
+ *	@pdev: Controller to be initialized
+ *	@ppi: array of port_info, must be enough for two ports
+ *	@sht: scsi_host_template to use when registering the host
+ *	@host_priv: host private_data
+ *	@hflag: host flags
+ *
+ *	This is a helper function which can be called from a driver's
+ *	xxx_init_one() probe function if the hardware uses traditional
+ *	IDE taskfile registers and is PIO only.
+ *
+ *	ASSUMPTION:
+ *	Nobody makes a single channel controller that appears solely as
+ *	the secondary legacy port on PCI.
+ *
+ *	LOCKING:
+ *	Inherited from PCI layer (may sleep).
+ *
+ *	RETURNS:
+ *	Zero on success, negative on errno-based value on error.
+ */
+int ata_pci_sff_init_one(struct pci_dev *pdev,
+		 const struct ata_port_info * const *ppi,
+		 struct scsi_host_template *sht, void *host_priv, int hflag)
+{
+	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflag, 0);
+}
 EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 
 #endif /* CONFIG_PCI */
@@ -3286,42 +3302,7 @@ int ata_pci_bmdma_init_one(struct pci_dev *pdev,
 			   struct scsi_host_template *sht, void *host_priv,
 			   int hflags)
 {
- -	struct device *dev = &pdev->dev;
- -	const struct ata_port_info *pi;
- -	struct ata_host *host = NULL;
- -	int rc;
- -
- -	DPRINTK("ENTER\n");
- -
- -	pi = ata_sff_find_valid_pi(ppi);
- -	if (!pi) {
- -		dev_err(&pdev->dev, "no valid port_info specified\n");
- -		return -EINVAL;
- -	}
- -
- -	if (!devres_open_group(dev, NULL, GFP_KERNEL))
- -		return -ENOMEM;
- -
- -	rc = pcim_enable_device(pdev);
- -	if (rc)
- -		goto out;
- -
- -	/* prepare and activate BMDMA host */
- -	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
- -	if (rc)
- -		goto out;
- -	host->private_data = host_priv;
- -	host->flags |= hflags;
- -
- -	pci_set_master(pdev);
- -	rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
- - out:
- -	if (rc == 0)
- -		devres_remove_group(&pdev->dev, NULL);
- -	else
- -		devres_release_group(&pdev->dev, NULL);
- -
- -	return rc;
+	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflags, 1);
 }
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_init_one);
 
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index cadd679..61da069 100644
- --- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -56,7 +56,7 @@ static const struct dmi_system_id cable_dmi_table[] = {
 		},
 	},
 	{
- -		.ident = "Toshiba Satelite S1800-814",
+		.ident = "Toshiba Satellite S1800-814",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "S1800-814"),
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 719bb73..e8574bb 100644
- --- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -922,8 +922,7 @@ static int __devexit arasan_cf_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int arasan_cf_suspend(struct device *dev)
 {
- -	struct platform_device *pdev = to_platform_device(dev);
- -	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ata_host *host = dev_get_drvdata(dev);
 	struct arasan_cf_dev *acdev = host->ports[0]->private_data;
 
 	if (acdev->dma_chan) {
@@ -937,8 +936,7 @@ static int arasan_cf_suspend(struct device *dev)
 
 static int arasan_cf_resume(struct device *dev)
 {
- -	struct platform_device *pdev = to_platform_device(dev);
- -	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ata_host *host = dev_get_drvdata(dev);
 	struct arasan_cf_dev *acdev = host->ports[0]->private_data;
 
 	cf_init(acdev);
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 78a93b6..4b8b22e 100644
- --- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -2,7 +2,7 @@
  *    pata_artop.c - ARTOP ATA controller driver
  *
  *	(C) 2006 Red Hat
- - *	(C) 2007 Bartlomiej Zolnierkiewicz
+ *	(C) 2007,2011 Bartlomiej Zolnierkiewicz
  *
  *    Based in part on drivers/ide/pci/aec62xx.c
  *	Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
@@ -28,7 +28,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_artop"
- -#define DRV_VERSION	"0.4.5"
+#define DRV_VERSION	"0.4.6"
 
 /*
  *	The ARTOP has 33 Mhz and "over clocked" timing tables. Until we
@@ -39,31 +39,15 @@
 
 static int clock = 0;
 
- -static int artop6210_pre_reset(struct ata_link *link, unsigned long deadline)
- -{
- -	struct ata_port *ap = link->ap;
- -	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
- -	const struct pci_bits artop_enable_bits[] = {
- -		{ 0x4AU, 1U, 0x02UL, 0x02UL },	/* port 0 */
- -		{ 0x4AU, 1U, 0x04UL, 0x04UL },	/* port 1 */
- -	};
- -
- -	if (!pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
- -		return -ENOENT;
- -
- -	return ata_sff_prereset(link, deadline);
- -}
- -
 /**
- - *	artop6260_pre_reset	-	check for 40/80 pin
+ *	artop62x0_pre_reset	-	probe begin
  *	@link: link
  *	@deadline: deadline jiffies for the operation
  *
- - *	The ARTOP hardware reports the cable detect bits in register 0x49.
  *	Nothing complicated needed here.
  */
 
- -static int artop6260_pre_reset(struct ata_link *link, unsigned long deadline)
+static int artop62x0_pre_reset(struct ata_link *link, unsigned long deadline)
 {
 	static const struct pci_bits artop_enable_bits[] = {
 		{ 0x4AU, 1U, 0x02UL, 0x02UL },	/* port 0 */
@@ -73,7 +57,7 @@ static int artop6260_pre_reset(struct ata_link *link, unsigned long deadline)
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
- -	/* Odd numbered device ids are the units with enable bits (the -R cards) */
+	/* Odd numbered device ids are the units with enable bits. */
 	if ((pdev->device & 1) &&
 	    !pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
 		return -ENOENT;
@@ -317,7 +301,7 @@ static struct ata_port_operations artop6210_ops = {
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= artop6210_set_piomode,
 	.set_dmamode		= artop6210_set_dmamode,
- -	.prereset		= artop6210_pre_reset,
+	.prereset		= artop62x0_pre_reset,
 	.qc_defer		= artop6210_qc_defer,
 };
 
@@ -326,9 +310,36 @@ static struct ata_port_operations artop6260_ops = {
 	.cable_detect		= artop6260_cable_detect,
 	.set_piomode		= artop6260_set_piomode,
 	.set_dmamode		= artop6260_set_dmamode,
- -	.prereset		= artop6260_pre_reset,
+	.prereset		= artop62x0_pre_reset,
 };
 
+static void atp8xx_fixup(struct pci_dev *pdev)
+{
+	if (pdev->device == 0x0005)
+		/* BIOS may have left us in UDMA, clear it before libata probe */
+		pci_write_config_byte(pdev, 0x54, 0);
+	else if (pdev->device == 0x0008 || pdev->device == 0x0009) {
+		u8 reg;
+
+		/* Mac systems come up with some registers not set as we
+		   will need them */
+
+		/* Clear reset & test bits */
+		pci_read_config_byte(pdev, 0x49, &reg);
+		pci_write_config_byte(pdev, 0x49, reg & ~0x30);
+
+		/* PCI latency must be > 0x80 for burst mode, tweak it
+		 * if required.
+		 */
+		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &reg);
+		if (reg <= 0x80)
+			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x90);
+
+		/* Enable IRQ output and burst mode */
+		pci_read_config_byte(pdev, 0x4a, &reg);
+		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
+	}
+}
 
 /**
  *	artop_init_one - Register ARTOP ATA PCI device with kernel services
@@ -383,42 +394,22 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
- -	if (id->driver_data == 0) {	/* 6210 variant */
+	if (id->driver_data == 0)	/* 6210 variant */
 		ppi[0] = &info_6210;
- -		/* BIOS may have left us in UDMA, clear it before libata probe */
- -		pci_write_config_byte(pdev, 0x54, 0);
- -	}
 	else if (id->driver_data == 1)	/* 6260 */
 		ppi[0] = &info_626x;
 	else if (id->driver_data == 2)	{ /* 6280 or 6280 + fast */
 		unsigned long io = pci_resource_start(pdev, 4);
- -		u8 reg;
 
 		ppi[0] = &info_628x;
 		if (inb(io) & 0x10)
 			ppi[0] = &info_628x_fast;
- -		/* Mac systems come up with some registers not set as we
- -		   will need them */
- -
- -		/* Clear reset & test bits */
- -		pci_read_config_byte(pdev, 0x49, &reg);
- -		pci_write_config_byte(pdev, 0x49, reg & ~ 0x30);
- -
- -		/* PCI latency must be > 0x80 for burst mode, tweak it
- -		 * if required.
- -		 */
- -		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &reg);
- -		if (reg <= 0x80)
- -			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x90);
- -
- -		/* Enable IRQ output and burst mode */
- -		pci_read_config_byte(pdev, 0x4a, &reg);
- -		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
- -
 	}
 
 	BUG_ON(ppi[0] == NULL);
 
+	atp8xx_fixup(pdev);
+
 	return ata_pci_bmdma_init_one(pdev, ppi, &artop_sht, NULL, 0);
 }
 
@@ -432,11 +423,32 @@ static const struct pci_device_id artop_pci_tbl[] = {
 	{ }	/* terminate list */
 };
 
+#ifdef CONFIG_PM
+static int atp8xx_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	atp8xx_fixup(pdev);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static struct pci_driver artop_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= artop_pci_tbl,
 	.probe			= artop_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= atp8xx_reinit_one,
+#endif
 };
 
 static int __init artop_init(void)
@@ -452,9 +464,8 @@ static void __exit artop_exit(void)
 module_init(artop_init);
 module_exit(artop_exit);
 
- -MODULE_AUTHOR("Alan Cox");
+MODULE_AUTHOR("Alan Cox, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("SCSI low-level driver for ARTOP PATA");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, artop_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
- -
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 960c725..c6d1409 100644
- --- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -414,10 +414,13 @@ static int __devinit pata_at91_probe(struct platform_device *pdev)
 
 	host->private_data = info;
 
- -	return ata_host_activate(host, irq ? gpio_to_irq(irq) : 0,
+	ret = ata_host_activate(host, irq ? gpio_to_irq(irq) : 0,
 			irq ? ata_sff_interrupt : NULL,
 			irq_flags, &pata_at91_sht);
 
+	if (!ret)
+		return 0;
+
 err_put:
 	clk_put(info->mck);
 	return ret;
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 4375561..be1aa14 100644
- --- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -49,6 +49,31 @@ static int atiixp_cable_detect(struct ata_port *ap)
 static DEFINE_SPINLOCK(atiixp_lock);
 
 /**
+ *	atiixp_prereset	-	perform reset handling
+ *	@link: ATA link
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Reset sequence checking enable bits to see which ports are
+ *	active.
+ */
+
+static int atiixp_prereset(struct ata_link *link, unsigned long deadline)
+{
+	static const struct pci_bits atiixp_enable_bits[] = {
+		{ 0x48, 1, 0x01, 0x00 },
+		{ 0x48, 1, 0x08, 0x00 }
+	};
+
+	struct ata_port *ap = link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	if (!pci_test_config_bits(pdev, &atiixp_enable_bits[ap->port_no]))
+		return -ENOENT;
+
+	return ata_sff_prereset(link, deadline);
+}
+
+/**
  *	atiixp_set_pio_timing	-	set initial PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
@@ -221,6 +246,7 @@ static struct ata_port_operations atiixp_port_ops = {
 	.bmdma_start 	= atiixp_bmdma_start,
 	.bmdma_stop	= atiixp_bmdma_stop,
 
+	.prereset	= atiixp_prereset,
 	.cable_detect	= atiixp_cable_detect,
 	.set_piomode	= atiixp_set_piomode,
 	.set_dmamode	= atiixp_set_dmamode,
@@ -235,16 +261,7 @@ static int atiixp_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &atiixp_port_ops
 	};
- -	static const struct pci_bits atiixp_enable_bits[] = {
- -		{ 0x48, 1, 0x01, 0x00 },
- -		{ 0x48, 1, 0x08, 0x00 }
- -	};
 	const struct ata_port_info *ppi[] = { &info, &info };
- -	int i;
- -
- -	for (i = 0; i < 2; i++)
- -		if (!pci_test_config_bits(pdev, &atiixp_enable_bits[i]))
- -			ppi[i] = &ata_dummy_port_info;
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &atiixp_sht, NULL,
 				      ATA_HOST_PARALLEL_SCAN);
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 7bafc16..e1fb39a 100644
- --- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -82,7 +82,7 @@ static int cmd648_cable_detect(struct ata_port *ap)
 }
 
 /**
- - *	cmd64x_set_piomode	-	set PIO and MWDMA timing
+ *	cmd64x_set_timing	-	set PIO and MWDMA timing
  *	@ap: ATA interface
  *	@adev: ATA device
  *	@mode: mode
@@ -288,6 +288,22 @@ static struct ata_port_operations cmd648_port_ops = {
 	.cable_detect	= cmd648_cable_detect,
 };
 
+static void cmd64x_fixup(struct pci_dev *pdev)
+{
+	u8 mrdmode;
+
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
+	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
+	mrdmode &= ~0x30;	/* IRQ set up */
+	mrdmode |= 0x02;	/* Memory read line enable */
+	pci_write_config_byte(pdev, MRDMODE, mrdmode);
+
+	/* PPC specific fixup copied from old driver */
+#ifdef CONFIG_PPC
+	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
+#endif
+}
+
 static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info cmd_info[6] = {
@@ -336,7 +352,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		&cmd_info[id->driver_data],
 		NULL
 	};
- -	u8 mrdmode, reg;
+	u8 reg;
 	int rc;
 	struct pci_dev *bridge = pdev->bus->self;
 	/* mobility split bridges don't report enabled ports correctly */
@@ -368,11 +384,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			cntrl_ch0_ok = 0;
 	}
 
- -	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
- -	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
- -	mrdmode &= ~ 0x30;	/* IRQ set up */
- -	mrdmode |= 0x02;	/* Memory read line enable */
- -	pci_write_config_byte(pdev, MRDMODE, mrdmode);
+	cmd64x_fixup(pdev);
 
 	/* check for enabled ports */
 	pci_read_config_byte(pdev, CNTRL, &reg);
@@ -388,13 +400,6 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ppi[1] = &ata_dummy_port_info;
 	}
 
- -	/* Force PIO 0 here.. */
- -
- -	/* PPC specific fixup copied from old driver */
- -#ifdef CONFIG_PPC
- -	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
- -#endif
- -
 	return ata_pci_bmdma_init_one(pdev, ppi, &cmd64x_sht, NULL, 0);
 }
 
@@ -402,21 +407,14 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 static int cmd64x_reinit_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
- -	u8 mrdmode;
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
 	if (rc)
 		return rc;
 
- -	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
- -	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
- -	mrdmode &= ~ 0x30;	/* IRQ set up */
- -	mrdmode |= 0x02;	/* Memory read line enable */
- -	pci_write_config_byte(pdev, MRDMODE, mrdmode);
- -#ifdef CONFIG_PPC
- -	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
- -#endif
+	cmd64x_fixup(pdev);
+
 	ata_host_resume(host);
 	return 0;
 }
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 03a9318..a0b4640 100644
- --- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -38,7 +38,7 @@
 #include <linux/libata.h>
 #include <asm/msr.h>
 
- -#define DRV_NAME	"cs5535"
+#define DRV_NAME	"pata_cs5535"
 #define DRV_VERSION	"0.2.12"
 
 /*
@@ -67,8 +67,6 @@
 
 #define CS5535_CABLE_DETECT    0x48
 
- -#define CS5535_BAD_PIO(timings) ( (timings&~0x80000000UL)==0x00009172 )
- -
 /**
  *	cs5535_cable_detect	-	detect cable type
  *	@ap: Port to detect on
@@ -188,16 +186,6 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
- -	u32 timings, dummy;
- -
- -	/* Check the BIOS set the initial timing clock. If not set the
- -	   timings for PIO0 */
- -	rdmsr(ATAC_CH0D0_PIO, timings, dummy);
- -	if (CS5535_BAD_PIO(timings))
- -		wrmsr(ATAC_CH0D0_PIO, 0xF7F4F7F4UL, 0);
- -	rdmsr(ATAC_CH0D1_PIO, timings, dummy);
- -	if (CS5535_BAD_PIO(timings))
- -		wrmsr(ATAC_CH0D1_PIO, 0xF7F4F7F4UL, 0);
 	return ata_pci_bmdma_init_one(dev, ppi, &cs5535_sht, NULL, 0);
 }
 
@@ -230,7 +218,7 @@ static void __exit cs5535_exit(void)
 }
 
 MODULE_AUTHOR("Alan Cox, Jens Altmann, Wolfgan Zuleger, Alexander Kiausch");
- -MODULE_DESCRIPTION("low-level driver for the NS/AMD 5530");
+MODULE_DESCRIPTION("low-level driver for the NS/AMD 5535");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, cs5535);
 MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index aca47e4..f0243ed 100644
- --- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -73,7 +73,7 @@ static DEFINE_SPINLOCK(efar_lock);
 /**
  *	efar_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
- - *	@adev: um
+ *	@adev: Device to program
  *
  *	Set PIO mode for device, in host controller PCI config space.
  *
@@ -85,9 +85,9 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
- -	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
+	unsigned int master_port = ap->port_no ? 0x42 : 0x40;
 	unsigned long flags;
- -	u16 idetm_data;
+	u16 master_data;
 	u8 udma_enable;
 	int control = 0;
 
@@ -113,20 +113,20 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 	spin_lock_irqsave(&efar_lock, flags);
 
- -	pci_read_config_word(dev, idetm_port, &idetm_data);
+	pci_read_config_word(dev, master_port, &master_data);
 
 	/* Set PPE, IE, and TIME as appropriate */
 	if (adev->devno == 0) {
- -		idetm_data &= 0xCCF0;
- -		idetm_data |= control;
- -		idetm_data |= (timings[pio][0] << 12) |
+		master_data &= 0xCCF0;
+		master_data |= control;
+		master_data |= (timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
 	} else {
 		int shift = 4 * ap->port_no;
 		u8 slave_data;
 
- -		idetm_data &= 0xFF0F;
- -		idetm_data |= (control << 4);
+		master_data &= 0xFF0F;
+		master_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
@@ -135,8 +135,8 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
- -	idetm_data |= 0x4000;	/* Ensure SITRE is set */
- -	pci_write_config_word(dev, idetm_port, idetm_data);
+	master_data |= 0x4000;	/* Ensure SITRE is set */
+	pci_write_config_word(dev, master_port, master_data);
 
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 6c77d68..42cffd3 100644
- --- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -111,6 +111,28 @@ static const struct hpt_clock hpt366_25[] = {
 	{	0,		0x01208585	}
 };
 
+/**
+ *	hpt36x_find_mode	-	find the hpt36x timing
+ *	@ap: ATA port
+ *	@speed: transfer mode
+ *
+ *	Return the 32bit register programming information for this channel
+ *	that matches the speed provided.
+ */
+
+static u32 hpt36x_find_mode(struct ata_port *ap, int speed)
+{
+	struct hpt_clock *clocks = ap->host->private_data;
+
+	while (clocks->xfer_mode) {
+		if (clocks->xfer_mode == speed)
+			return clocks->timing;
+		clocks++;
+	}
+	BUG();
+	return 0xffffffffU;	/* silence compiler warning */
+}
+
 static const char * const bad_ata33[] = {
 	"Maxtor 92720U8", "Maxtor 92040U6", "Maxtor 91360U4", "Maxtor 91020U3",
 	"Maxtor 90845U3", "Maxtor 90650U2",
@@ -210,10 +232,9 @@ static int hpt36x_cable_detect(struct ata_port *ap)
 static void hpt366_set_mode(struct ata_port *ap, struct ata_device *adev,
 			    u8 mode)
 {
- -	struct hpt_clock *clocks = ap->host->private_data;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr = 0x40 + 4 * adev->devno;
- -	u32 mask, reg;
+	u32 mask, reg, t;
 
 	/* determine timing mask and find matching clock entry */
 	if (mode < XFER_MW_DMA_0)
@@ -223,13 +244,7 @@ static void hpt366_set_mode(struct ata_port *ap, struct ata_device *adev,
 	else
 		mask = 0x30070000;
 
- -	while (clocks->xfer_mode) {
- -		if (clocks->xfer_mode == mode)
- -			break;
- -		clocks++;
- -	}
- -	if (!clocks->xfer_mode)
- -		BUG();
+	t = hpt36x_find_mode(ap, mode);
 
 	/*
 	 * Combine new mode bits with old config bits and disable
@@ -237,7 +252,7 @@ static void hpt366_set_mode(struct ata_port *ap, struct ata_device *adev,
 	 * problems handling I/O errors later.
 	 */
 	pci_read_config_dword(pdev, addr, &reg);
- -	reg = ((reg & ~mask) | (clocks->timing & mask)) & ~0xc0000000;
+	reg = ((reg & ~mask) | (t & mask)) & ~0xc0000000;
 	pci_write_config_dword(pdev, addr, reg);
 }
 
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 998af0e..cf9164d 100644
- --- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -76,8 +76,8 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
- -	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
- -	u16 idetm_data;
+	unsigned int master_port = ap->port_no ? 0x42 : 0x40;
+	u16 master_data;
 	int control = 0;
 
 	/*
@@ -100,19 +100,19 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->class != ATA_DEV_ATA)
 		control |= 4;	/* PPE */
 
- -	pci_read_config_word(dev, idetm_port, &idetm_data);
+	pci_read_config_word(dev, master_port, &master_data);
 
 	/* Set PPE, IE, and TIME as appropriate */
 	if (adev->devno == 0) {
- -		idetm_data &= 0xCCF0;
- -		idetm_data |= control;
- -		idetm_data |= (timings[pio][0] << 12) |
+		master_data &= 0xCCF0;
+		master_data |= control;
+		master_data |= (timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
 	} else {
 		u8 slave_data;
 
- -		idetm_data &= 0xFF0F;
- -		idetm_data |= (control << 4);
+		master_data &= 0xFF0F;
+		master_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
@@ -121,8 +121,8 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
- -	idetm_data |= 0x4000;	/* Ensure SITRE is set */
- -	pci_write_config_word(dev, idetm_port, idetm_data);
+	master_data |= 0x4000;	/* Ensure SITRE is set */
+	pci_write_config_word(dev, master_port, master_data);
 }
 
 /**
@@ -163,7 +163,7 @@ static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 		/* Clocks follow the PIIX style */
 		u_speed = min(2 - (udma & 1), udma);
- -		if (udma == 5)
+		if (udma > 4)
 			u_clock = 0x1000;	/* 100Mhz */
 		else if (udma > 2)
 			u_clock = 1;		/* 66Mhz */
@@ -262,7 +262,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA12_ONLY,
- -		.udma_mask 	= ATA_UDMA4, /* FIXME: want UDMA 100? */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &it8213_ops,
 	};
 	/* Current IT8213 stuff is single port */
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index d960f8e..35aca7d 100644
- --- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -79,15 +79,6 @@ static int all;
 module_param(all, int, 0444);
 MODULE_PARM_DESC(all, "Grab all legacy port devices, even if PCI(0=off, 1=on)");
 
- -struct legacy_data {
- -	unsigned long timing;
- -	u8 clock[2];
- -	u8 last;
- -	int fast;
- -	struct platform_device *platform_dev;
- -
- -};
- -
 enum controller {
 	BIOS = 0,
 	SNOOP = 1,
@@ -104,6 +95,14 @@ enum controller {
 	UNKNOWN = -1
 };
 
+struct legacy_data {
+	unsigned long timing;
+	u8 clock[2];
+	u8 last;
+	int fast;
+	enum controller type;
+	struct platform_device *platform_dev;
+};
 
 struct legacy_probe {
 	unsigned char *name;
@@ -137,11 +136,17 @@ static int ht6560a;		/* HT 6560A on primary 1, second 2, both 3 */
 static int ht6560b;		/* HT 6560A on primary 1, second 2, both 3 */
 static int opti82c611a;		/* Opti82c611A on primary 1, sec 2, both 3 */
 static int opti82c46x;		/* Opti 82c465MV present(pri/sec autodetect) */
- -static int qdi;			/* Set to probe QDI controllers */
 static int autospeed;		/* Chip present which snoops speed changes */
 static int pio_mask = ATA_PIO4;	/* PIO range for autospeed devices */
 static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
 
+/* Set to probe QDI controllers */
+#ifdef CONFIG_PATA_QDI_MODULE
+static int qdi = 1;
+#else
+static int qdi;
+#endif
+
 #ifdef CONFIG_PATA_WINBOND_VLB_MODULE
 static int winbond = 1;		/* Set to probe Winbond controllers,
 					give I/O port if non standard */
@@ -631,40 +636,20 @@ static struct ata_port_operations opti82c46x_port_ops = {
 	.qc_issue	= opti82c46x_qc_issue,
 };
 
- -static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
- -{
- -	struct ata_timing t;
- -	struct legacy_data *ld_qdi = ap->host->private_data;
- -	int active, recovery;
- -	u8 timing;
- -
- -	/* Get the timing data in cycles */
- -	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
- -
- -	if (ld_qdi->fast) {
- -		active = 8 - clamp_val(t.active, 1, 8);
- -		recovery = 18 - clamp_val(t.recover, 3, 18);
- -	} else {
- -		active = 9 - clamp_val(t.active, 2, 9);
- -		recovery = 15 - clamp_val(t.recover, 0, 15);
- -	}
- -	timing = (recovery << 4) | active | 0x08;
- -
- -	ld_qdi->clock[adev->devno] = timing;
- -
- -	outb(timing, ld_qdi->timing);
- -}
- -
 /**
- - *	qdi6580dp_set_piomode		-	PIO setup for dual channel
+ *	qdi65x0_set_piomode		-	PIO setup for QDI65x0
  *	@ap: Port
  *	@adev: Device
  *
+ *	In single channel mode the 6580 has one clock per device and we can
+ *	avoid the requirement to clock switch. We also have to load the timing
+ *	into the right clock according to whether we are master or slave.
+ *
  *	In dual channel mode the 6580 has one clock per channel and we have
  *	to software clockswitch in qc_issue.
  */
 
- -static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void qdi65x0_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ata_timing t;
 	struct legacy_data *ld_qdi = ap->host->private_data;
@@ -682,47 +667,15 @@ static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
- -
 	ld_qdi->clock[adev->devno] = timing;
 
- -	outb(timing, ld_qdi->timing + 2 * ap->port_no);
- -	/* Clear the FIFO */
- -	if (adev->class != ATA_DEV_ATA)
- -		outb(0x5F, (ld_qdi->timing & 0xFFF0) + 3);
- -}
- -
- -/**
- - *	qdi6580_set_piomode		-	PIO setup for single channel
- - *	@ap: Port
- - *	@adev: Device
- - *
- - *	In single channel mode the 6580 has one clock per device and we can
- - *	avoid the requirement to clock switch. We also have to load the timing
- - *	into the right clock according to whether we are master or slave.
- - */
- -
- -static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
- -{
- -	struct ata_timing t;
- -	struct legacy_data *ld_qdi = ap->host->private_data;
- -	int active, recovery;
- -	u8 timing;
- -
- -	/* Get the timing data in cycles */
- -	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+	if (ld_qdi->type == QDI6580)
+		outb(timing, ld_qdi->timing + 2 * adev->devno);
+	else
+		outb(timing, ld_qdi->timing + 2 * ap->port_no);
 
- -	if (ld_qdi->fast) {
- -		active = 8 - clamp_val(t.active, 1, 8);
- -		recovery = 18 - clamp_val(t.recover, 3, 18);
- -	} else {
- -		active = 9 - clamp_val(t.active, 2, 9);
- -		recovery = 15 - clamp_val(t.recover, 0, 15);
- -	}
- -	timing = (recovery << 4) | active | 0x08;
- -	ld_qdi->clock[adev->devno] = timing;
- -	outb(timing, ld_qdi->timing + 2 * adev->devno);
 	/* Clear the FIFO */
- -	if (adev->class != ATA_DEV_ATA)
+	if (ld_qdi->type != QDI6500 && adev->class != ATA_DEV_ATA)
 		outb(0x5F, (ld_qdi->timing & 0xFFF0) + 3);
 }
 
@@ -789,20 +742,20 @@ static int qdi_port(struct platform_device *dev,
 
 static struct ata_port_operations qdi6500_port_ops = {
 	.inherits	= &legacy_base_port_ops,
- -	.set_piomode	= qdi6500_set_piomode,
+	.set_piomode	= qdi65x0_set_piomode,
 	.qc_issue	= qdi_qc_issue,
 	.sff_data_xfer	= vlb32_data_xfer,
 };
 
 static struct ata_port_operations qdi6580_port_ops = {
 	.inherits	= &legacy_base_port_ops,
- -	.set_piomode	= qdi6580_set_piomode,
+	.set_piomode	= qdi65x0_set_piomode,
 	.sff_data_xfer	= vlb32_data_xfer,
 };
 
 static struct ata_port_operations qdi6580dp_port_ops = {
 	.inherits	= &legacy_base_port_ops,
- -	.set_piomode	= qdi6580dp_set_piomode,
+	.set_piomode	= qdi65x0_set_piomode,
 	.qc_issue	= qdi_qc_issue,
 	.sff_data_xfer	= vlb32_data_xfer,
 };
@@ -879,29 +832,29 @@ static struct ata_port_operations winbond_port_ops = {
 };
 
 static struct legacy_controller controllers[] = {
- -	{"BIOS",	&legacy_port_ops, 	0x1F,
+	{"BIOS",	&legacy_port_ops, 	ATA_PIO4,
 			ATA_FLAG_NO_IORDY,	0,			NULL },
- -	{"Snooping", 	&simple_port_ops, 	0x1F,
+	{"Snooping", 	&simple_port_ops, 	ATA_PIO4,
 			0,			0,			NULL },
- -	{"PDC20230",	&pdc20230_port_ops,	0x7,
+	{"PDC20230",	&pdc20230_port_ops,	ATA_PIO2,
 			ATA_FLAG_NO_IORDY,
 			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,	NULL },
- -	{"HT6560A",	&ht6560a_port_ops,	0x07,
+	{"HT6560A",	&ht6560a_port_ops,	ATA_PIO2,
 			ATA_FLAG_NO_IORDY,	0,			NULL },
- -	{"HT6560B",	&ht6560b_port_ops,	0x1F,
+	{"HT6560B",	&ht6560b_port_ops,	ATA_PIO4,
 			ATA_FLAG_NO_IORDY,	0,			NULL },
- -	{"OPTI82C611A",	&opti82c611a_port_ops,	0x0F,
+	{"OPTI82C611A",	&opti82c611a_port_ops,	ATA_PIO3,
 			0,			0,			NULL },
- -	{"OPTI82C46X",	&opti82c46x_port_ops,	0x0F,
+	{"OPTI82C46X",	&opti82c46x_port_ops,	ATA_PIO3,
 			0,			0,			NULL },
- -	{"QDI6500",	&qdi6500_port_ops,	0x07,
+	{"QDI6500",	&qdi6500_port_ops,	ATA_PIO2,
 			ATA_FLAG_NO_IORDY,
 			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,    qdi_port },
- -	{"QDI6580",	&qdi6580_port_ops,	0x1F,
+	{"QDI6580",	&qdi6580_port_ops,	ATA_PIO4,
 			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE, qdi_port },
- -	{"QDI6580DP",	&qdi6580dp_port_ops,	0x1F,
+	{"QDI6580DP",	&qdi6580dp_port_ops,	ATA_PIO4,
 			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE, qdi_port },
- -	{"W83759A",	&winbond_port_ops,	0x1F,
+	{"W83759A",	&winbond_port_ops,	ATA_PIO4,
 			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,
 								winbond_port }
 };
@@ -1022,6 +975,7 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 	ctrl_addr = devm_ioport_map(&pdev->dev, io + 0x0206, 1);
 	if (!io_addr || !ctrl_addr)
 		goto fail;
+	ld->type = probe->type;
 	if (controller->setup)
 		if (controller->setup(pdev, probe, ld) < 0)
 			goto fail;
@@ -1306,6 +1260,7 @@ MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for legacy ATA");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("pata_qdi");
 MODULE_ALIAS("pata_winbond");
 
 module_param(probe_all, int, 0);
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 2fcac51..3e17463 100644
- --- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -780,7 +780,7 @@ mpc52xx_ata_probe(struct platform_device *op)
 	}
 
 	task_irq = bcom_get_task_irq(dmatsk);
- -	ret = request_irq(task_irq, &mpc52xx_ata_task_irq, IRQF_DISABLED,
+	ret = request_irq(task_irq, &mpc52xx_ata_task_irq, 0,
 				"ATA task", priv);
 	if (ret) {
 		dev_err(&op->dev, "error requesting DMA IRQ\n");
diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index f305400..a72ab0d 100644
- --- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -11,6 +11,8 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/ata_platform.h>
 
@@ -57,11 +59,11 @@ static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
 
 	prop = of_get_property(dn, "reg-shift", NULL);
 	if (prop)
- -		reg_shift = *prop;
+		reg_shift = be32_to_cpup(prop);
 
 	prop = of_get_property(dn, "pio-mode", NULL);
 	if (prop) {
- -		pio_mode = *prop;
+		pio_mode = be32_to_cpup(prop);
 		if (pio_mode > 6) {
 			dev_err(&ofdev->dev, "invalid pio-mode\n");
 			return -EINVAL;
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index b1511f3..7d63f24 100644
- --- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -63,6 +63,7 @@ enum {
 };
 
 static int pdc2027x_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static int pdc2027x_reinit_one(struct pci_dev *pdev);
 static int pdc2027x_prereset(struct ata_link *link, unsigned long deadline);
 static void pdc2027x_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void pdc2027x_set_dmamode(struct ata_port *ap, struct ata_device *adev);
@@ -126,6 +127,10 @@ static struct pci_driver pdc2027x_pci_driver = {
 	.id_table		= pdc2027x_pci_tbl,
 	.probe			= pdc2027x_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= pdc2027x_reinit_one,
+#endif
 };
 
 static struct scsi_host_template pdc2027x_sht = {
@@ -754,6 +759,31 @@ static int __devinit pdc2027x_init_one(struct pci_dev *pdev, const struct pci_de
 				 IRQF_SHARED, &pdc2027x_sht);
 }
 
+#ifdef CONFIG_PM
+static int pdc2027x_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	unsigned int board_idx;
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	if (pdev->device == PCI_DEVICE_ID_PROMISE_20268 ||
+	    pdev->device == PCI_DEVICE_ID_PROMISE_20270)
+		board_idx = PDC_UDMA_100;
+	else
+		board_idx = PDC_UDMA_133;
+
+	if (pdc_hardware_init(host, board_idx))
+		return -EIO;
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 /**
  * pdc2027x_init - Called after this module is loaded into the kernel.
  */
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
deleted file mode 100644
index 45879dc..0000000
- --- a/drivers/ata/pata_qdi.c
+++ /dev/null
@@ -1,366 +0,0 @@
- -/*
- - *    pata_qdi.c - QDI VLB ATA controllers
- - *	(C) 2006 Red Hat
- - *
- - * This driver mostly exists as a proof of concept for non PCI devices under
- - * libata. While the QDI6580 was 'neat' in 1993 it is no longer terribly
- - * useful.
- - *
- - * Tuning code written from the documentation at
- - * http://www.ryston.cz/petr/vlb/qd6500.html
- - * http://www.ryston.cz/petr/vlb/qd6580.html
- - *
- - * Probe code based on drivers/ide/legacy/qd65xx.c
- - * Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
- - * Samuel Thibault <samuel.thibault@ens-lyon.org>
- - */
- -
- -#include <linux/kernel.h>
- -#include <linux/module.h>
- -#include <linux/pci.h>
- -#include <linux/init.h>
- -#include <linux/blkdev.h>
- -#include <linux/delay.h>
- -#include <scsi/scsi_host.h>
- -#include <linux/libata.h>
- -#include <linux/platform_device.h>
- -
- -#define DRV_NAME "pata_qdi"
- -#define DRV_VERSION "0.3.1"
- -
- -#define NR_HOST 4	/* Two 6580s */
- -
- -struct qdi_data {
- -	unsigned long timing;
- -	u8 clock[2];
- -	u8 last;
- -	int fast;
- -	struct platform_device *platform_dev;
- -
- -};
- -
- -static struct ata_host *qdi_host[NR_HOST];
- -static struct qdi_data qdi_data[NR_HOST];
- -static int nr_qdi_host;
- -
- -#ifdef MODULE
- -static int probe_qdi = 1;
- -#else
- -static int probe_qdi;
- -#endif
- -
- -static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
- -{
- -	struct ata_timing t;
- -	struct qdi_data *qdi = ap->host->private_data;
- -	int active, recovery;
- -	u8 timing;
- -
- -	/* Get the timing data in cycles */
- -	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
- -
- -	if (qdi->fast) {
- -		active = 8 - clamp_val(t.active, 1, 8);
- -		recovery = 18 - clamp_val(t.recover, 3, 18);
- -	} else {
- -		active = 9 - clamp_val(t.active, 2, 9);
- -		recovery = 15 - clamp_val(t.recover, 0, 15);
- -	}
- -	timing = (recovery << 4) | active | 0x08;
- -
- -	qdi->clock[adev->devno] = timing;
- -
- -	outb(timing, qdi->timing);
- -}
- -
- -static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
- -{
- -	struct ata_timing t;
- -	struct qdi_data *qdi = ap->host->private_data;
- -	int active, recovery;
- -	u8 timing;
- -
- -	/* Get the timing data in cycles */
- -	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
- -
- -	if (qdi->fast) {
- -		active = 8 - clamp_val(t.active, 1, 8);
- -		recovery = 18 - clamp_val(t.recover, 3, 18);
- -	} else {
- -		active = 9 - clamp_val(t.active, 2, 9);
- -		recovery = 15 - clamp_val(t.recover, 0, 15);
- -	}
- -	timing = (recovery << 4) | active | 0x08;
- -
- -	qdi->clock[adev->devno] = timing;
- -
- -	outb(timing, qdi->timing);
- -
- -	/* Clear the FIFO */
- -	if (adev->class != ATA_DEV_ATA)
- -		outb(0x5F, (qdi->timing & 0xFFF0) + 3);
- -}
- -
- -/**
- - *	qdi_qc_issue		-	command issue
- - *	@qc: command pending
- - *
- - *	Called when the libata layer is about to issue a command. We wrap
- - *	this interface so that we can load the correct ATA timings.
- - */
- -
- -static unsigned int qdi_qc_issue(struct ata_queued_cmd *qc)
- -{
- -	struct ata_port *ap = qc->ap;
- -	struct ata_device *adev = qc->dev;
- -	struct qdi_data *qdi = ap->host->private_data;
- -
- -	if (qdi->clock[adev->devno] != qdi->last) {
- -		if (adev->pio_mode) {
- -			qdi->last = qdi->clock[adev->devno];
- -			outb(qdi->clock[adev->devno], qdi->timing);
- -		}
- -	}
- -	return ata_sff_qc_issue(qc);
- -}
- -
- -static unsigned int qdi_data_xfer(struct ata_device *dev, unsigned char *buf,
- -				  unsigned int buflen, int rw)
- -{
- -	if (ata_id_has_dword_io(dev->id)) {
- -		struct ata_port *ap = dev->link->ap;
- -		int slop = buflen & 3;
- -
- -		if (rw == READ)
- -			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
- -		else
- -			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
- -
- -		if (unlikely(slop)) {
- -			__le32 pad;
- -			if (rw == READ) {
- -				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
- -				memcpy(buf + buflen - slop, &pad, slop);
- -			} else {
- -				memcpy(&pad, buf + buflen - slop, slop);
- -				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
- -			}
- -			buflen += 4 - slop;
- -		}
- -	} else
- -		buflen = ata_sff_data_xfer(dev, buf, buflen, rw);
- -
- -	return buflen;
- -}
- -
- -static struct scsi_host_template qdi_sht = {
- -	ATA_PIO_SHT(DRV_NAME),
- -};
- -
- -static struct ata_port_operations qdi6500_port_ops = {
- -	.inherits	= &ata_sff_port_ops,
- -	.qc_issue	= qdi_qc_issue,
- -	.sff_data_xfer	= qdi_data_xfer,
- -	.cable_detect	= ata_cable_40wire,
- -	.set_piomode	= qdi6500_set_piomode,
- -};
- -
- -static struct ata_port_operations qdi6580_port_ops = {
- -	.inherits	= &qdi6500_port_ops,
- -	.set_piomode	= qdi6580_set_piomode,
- -};
- -
- -/**
- - *	qdi_init_one		-	attach a qdi interface
- - *	@type: Type to display
- - *	@io: I/O port start
- - *	@irq: interrupt line
- - *	@fast: True if on a > 33Mhz VLB
- - *
- - *	Register an ISA bus IDE interface. Such interfaces are PIO and we
- - *	assume do not support IRQ sharing.
- - */
- -
- -static __init int qdi_init_one(unsigned long port, int type, unsigned long io, int irq, int fast)
- -{
- -	unsigned long ctl = io + 0x206;
- -	struct platform_device *pdev;
- -	struct ata_host *host;
- -	struct ata_port *ap;
- -	void __iomem *io_addr, *ctl_addr;
- -	int ret;
- -
- -	/*
- -	 *	Fill in a probe structure first of all
- -	 */
- -
- -	pdev = platform_device_register_simple(DRV_NAME, nr_qdi_host, NULL, 0);
- -	if (IS_ERR(pdev))
- -		return PTR_ERR(pdev);
- -
- -	ret = -ENOMEM;
- -	io_addr = devm_ioport_map(&pdev->dev, io, 8);
- -	ctl_addr = devm_ioport_map(&pdev->dev, ctl, 1);
- -	if (!io_addr || !ctl_addr)
- -		goto fail;
- -
- -	ret = -ENOMEM;
- -	host = ata_host_alloc(&pdev->dev, 1);
- -	if (!host)
- -		goto fail;
- -	ap = host->ports[0];
- -
- -	if (type == 6580) {
- -		ap->ops = &qdi6580_port_ops;
- -		ap->pio_mask = ATA_PIO4;
- -		ap->flags |= ATA_FLAG_SLAVE_POSS;
- -	} else {
- -		ap->ops = &qdi6500_port_ops;
- -		ap->pio_mask = ATA_PIO2; /* Actually PIO3 !IORDY is possible */
- -		ap->flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_IORDY;
- -	}
- -
- -	ap->ioaddr.cmd_addr = io_addr;
- -	ap->ioaddr.altstatus_addr = ctl_addr;
- -	ap->ioaddr.ctl_addr = ctl_addr;
- -	ata_sff_std_ports(&ap->ioaddr);
- -
- -	ata_port_desc(ap, "cmd %lx ctl %lx", io, ctl);
- -
- -	/*
- -	 *	Hook in a private data structure per channel
- -	 */
- -	ap->private_data = &qdi_data[nr_qdi_host];
- -
- -	qdi_data[nr_qdi_host].timing = port;
- -	qdi_data[nr_qdi_host].fast = fast;
- -	qdi_data[nr_qdi_host].platform_dev = pdev;
- -
- -	printk(KERN_INFO DRV_NAME": qd%d at 0x%lx.\n", type, io);
- -
- -	/* activate */
- -	ret = ata_host_activate(host, irq, ata_sff_interrupt, 0, &qdi_sht);
- -	if (ret)
- -		goto fail;
- -
- -	qdi_host[nr_qdi_host++] = dev_get_drvdata(&pdev->dev);
- -	return 0;
- -
- - fail:
- -	platform_device_unregister(pdev);
- -	return ret;
- -}
- -
- -/**
- - *	qdi_init		-	attach qdi interfaces
- - *
- - *	Attach qdi IDE interfaces by scanning the ports it may occupy.
- - */
- -
- -static __init int qdi_init(void)
- -{
- -	unsigned long flags;
- -	static const unsigned long qd_port[2] = { 0x30, 0xB0 };
- -	static const unsigned long ide_port[2] = { 0x170, 0x1F0 };
- -	static const int ide_irq[2] = { 14, 15 };
- -
- -	int ct = 0;
- -	int i;
- -
- -	if (probe_qdi == 0)
- -		return -ENODEV;
- -
- -	/*
- - 	 *	Check each possible QD65xx base address
- -	 */
- -
- -	for (i = 0; i < 2; i++) {
- -		unsigned long port = qd_port[i];
- -		u8 r, res;
- -
- -
- -		if (request_region(port, 2, "pata_qdi")) {
- -			/* Check for a card */
- -			local_irq_save(flags);
- -			r = inb_p(port);
- -			outb_p(0x19, port);
- -			res = inb_p(port);
- -			outb_p(r, port);
- -			local_irq_restore(flags);
- -
- -			/* Fail */
- -			if (res == 0x19)
- -			{
- -				release_region(port, 2);
- -				continue;
- -			}
- -
- -			/* Passes the presence test */
- -			r = inb_p(port + 1);	/* Check port agrees with port set */
- -			if ((r & 2) >> 1 != i) {
- -				release_region(port, 2);
- -				continue;
- -			}
- -
- -			/* Check card type */
- -			if ((r & 0xF0) == 0xC0) {
- -				/* QD6500: single channel */
- -				if (r & 8) {
- -					/* Disabled ? */
- -					release_region(port, 2);
- -					continue;
- -				}
- -				if (qdi_init_one(port, 6500, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04) == 0)
- -					ct++;
- -			}
- -			if (((r & 0xF0) == 0xA0) || (r & 0xF0) == 0x50) {
- -				/* QD6580: dual channel */
- -				if (!request_region(port + 2 , 2, "pata_qdi"))
- -				{
- -					release_region(port, 2);
- -					continue;
- -				}
- -				res = inb(port + 3);
- -				if (res & 1) {
- -					/* Single channel mode */
- -					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04) == 0)
- -						ct++;
- -				} else {
- -					/* Dual channel mode */
- -					if (qdi_init_one(port, 6580, 0x1F0, 14, r & 0x04) == 0)
- -						ct++;
- -					if (qdi_init_one(port + 2, 6580, 0x170, 15, r & 0x04) == 0)
- -						ct++;
- -				}
- -			}
- -		}
- -	}
- -	if (ct != 0)
- -		return 0;
- -	return -ENODEV;
- -}
- -
- -static __exit void qdi_exit(void)
- -{
- -	int i;
- -
- -	for (i = 0; i < nr_qdi_host; i++) {
- -		ata_host_detach(qdi_host[i]);
- -		/* Free the control resource. The 6580 dual channel has the resources
- -		 * claimed as a pair of 2 byte resources so we need no special cases...
- -		 */
- -		release_region(qdi_data[i].timing, 2);
- -		platform_device_unregister(qdi_data[i].platform_dev);
- -	}
- -}
- -
- -MODULE_AUTHOR("Alan Cox");
- -MODULE_DESCRIPTION("low-level driver for qdi ATA");
- -MODULE_LICENSE("GPL");
- -MODULE_VERSION(DRV_VERSION);
- -
- -module_init(qdi_init);
- -module_exit(qdi_exit);
- -
- -module_param(probe_qdi, int, 0);
- -
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index 4d318f8..e6a2dd7 100644
- --- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -86,6 +86,8 @@ static int rdc_pata_prereset(struct ata_link *link, unsigned long deadline)
 	return ata_sff_prereset(link, deadline);
 }
 
+static DEFINE_SPINLOCK(rdc_lock);
+
 /**
  *	rdc_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
@@ -101,6 +103,7 @@ static void rdc_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	unsigned int is_slave	= (adev->devno != 0);
 	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
 	unsigned int slave_port	= 0x44;
@@ -124,6 +127,8 @@ static void rdc_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE enable */
 
+	spin_lock_irqsave(&rdc_lock, flags);
+
 	/* PIO configuration clears DTE unconditionally.  It will be
 	 * programmed in set_dmamode which is guaranteed to be called
 	 * after set_piomode if any DMA mode is available.
@@ -161,6 +166,8 @@ static void rdc_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
 	pci_write_config_byte(dev, 0x48, udma_enable);
+
+	spin_unlock_irqrestore(&rdc_lock, flags);
 }
 
 /**
@@ -177,6 +184,7 @@ static void rdc_set_piomode(struct ata_port *ap, struct ata_device *adev)
 static void rdc_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	u8 master_port		= ap->port_no ? 0x42 : 0x40;
 	u16 master_data;
 	u8 speed		= adev->dma_mode;
@@ -190,6 +198,8 @@ static void rdc_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 			    { 2, 1 },
 			    { 2, 3 }, };
 
+	spin_lock_irqsave(&rdc_lock, flags);
+
 	pci_read_config_word(dev, master_port, &master_data);
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 
@@ -271,6 +281,8 @@ static void rdc_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 		pci_write_config_word(dev, master_port, master_data);
 	}
 	pci_write_config_byte(dev, 0x48, udma_enable);
+
+	spin_unlock_irqrestore(&rdc_lock, flags);
 }
 
 static struct ata_port_operations rdc_pata_ops = {
@@ -375,6 +387,10 @@ static struct pci_driver rdc_pci_driver = {
 	.id_table		= rdc_pci_tbl,
 	.probe			= rdc_init_one,
 	.remove			= rdc_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= ata_pci_device_resume,
+#endif
 };
 
 
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index e2c1825..c0e603a 100644
- --- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -38,7 +38,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 
- -#define DRV_NAME	"sc1200"
+#define DRV_NAME	"pata_sc1200"
 #define DRV_VERSION	"0.2.6"
 
 #define SC1200_REV_A	0x00
@@ -86,10 +86,14 @@ static int sc1200_clock(void)
 static void sc1200_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	static const u32 pio_timings[4][5] = {
- -		{0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010},	// format0  33Mhz
- -		{0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010},	// format1, 33Mhz
- -		{0xfaa3f4f3, 0xc23232b2, 0x513101c1, 0x31213121, 0x10211021},	// format1, 48Mhz
- -		{0xfff4fff4, 0xf35353d3, 0x814102f1, 0x42314231, 0x11311131}	// format1, 66Mhz
+		/* format0, 33Mhz */
+		{ 0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010 },
+		/* format1, 33Mhz */
+		{ 0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010 },
+		/* format1, 48Mhz */
+		{ 0xfaa3f4f3, 0xc23232b2, 0x513101c1, 0x31213121, 0x10211021 },
+		/* format1, 66Mhz */
+		{ 0xfff4fff4, 0xf35353d3, 0x814102f1, 0x42314231, 0x11311131 }
 	};
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index eb748e3..e265f83 100644
- --- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -826,18 +826,6 @@ static unsigned int scc_data_xfer (struct ata_device *dev, unsigned char *buf,
 }
 
 /**
- - *	scc_pata_prereset - prepare for reset
- - *	@ap: ATA port to be reset
- - *	@deadline: deadline jiffies for the operation
- - */
- -
- -static int scc_pata_prereset(struct ata_link *link, unsigned long deadline)
- -{
- -	link->ap->cbl = ATA_CBL_PATA80;
- -	return ata_sff_prereset(link, deadline);
- -}
- -
- -/**
  *	scc_postreset - standard postreset callback
  *	@ap: the target ata_port
  *	@classes: classes of attached devices
@@ -946,7 +934,7 @@ static struct ata_port_operations scc_pata_ops = {
 	.bmdma_status		= scc_bmdma_status,
 	.sff_data_xfer		= scc_data_xfer,
 
- -	.prereset		= scc_pata_prereset,
+	.cable_detect		= ata_cable_80wire,
 	.softreset		= scc_softreset,
 	.postreset		= scc_postreset,
 
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 86dd714..71eaf38 100644
- --- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -58,31 +58,15 @@ static const char *csb_bad_ata100[] = {
 };
 
 /**
- - *	dell_cable	-	Dell serverworks cable detection
+ *	oem_cable	-	Dell/Sun serverworks cable detection
  *	@ap: ATA port to do cable detect
  *
- - *	Dell hide the 40/80 pin select for their interfaces in the top two
- - *	bits of the subsystem ID.
+ *	Dell PowerEdge and Sun Cobalt 'Alpine' hide the 40/80 pin select
+ *	for their interfaces in the top two bits of the subsystem ID.
  */
 
- -static int dell_cable(struct ata_port *ap) {
- -	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
- -
- -	if (pdev->subsystem_device & (1 << (ap->port_no + 14)))
- -		return ATA_CBL_PATA80;
- -	return ATA_CBL_PATA40;
- -}
- -
- -/**
- - *	sun_cable	-	Sun Cobalt 'Alpine' cable detection
- - *	@ap: ATA port to do cable select
- - *
- - *	Cobalt CSB5 IDE hides the 40/80pin in the top two bits of the
- - *	subsystem ID the same as dell. We could use one function but we may
- - *	need to extend the Dell one in future
- - */
- -
- -static int sun_cable(struct ata_port *ap) {
+static int oem_cable(struct ata_port *ap)
+{
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	if (pdev->subsystem_device & (1 << (ap->port_no + 14)))
@@ -90,49 +74,21 @@ static int sun_cable(struct ata_port *ap) {
 	return ATA_CBL_PATA40;
 }
 
- -/**
- - *	osb4_cable	-	OSB4 cable detect
- - *	@ap: ATA port to check
- - *
- - *	The OSB4 isn't UDMA66 capable so this is easy
- - */
- -
- -static int osb4_cable(struct ata_port *ap) {
- -	return ATA_CBL_PATA40;
- -}
- -
- -/**
- - *	csb_cable	-	CSB5/6 cable detect
- - *	@ap: ATA port to check
- - *
- - *	Serverworks default arrangement is to use the drive side detection
- - *	only.
- - */
- -
- -static int csb_cable(struct ata_port *ap) {
- -	return ATA_CBL_PATA_UNK;
- -}
- -
 struct sv_cable_table {
 	int device;
 	int subvendor;
 	int (*cable_detect)(struct ata_port *ap);
 };
 
- -/*
- - *	Note that we don't copy the old serverworks code because the old
- - *	code contains obvious mistakes
- - */
- -
 static struct sv_cable_table cable_detect[] = {
- -	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, PCI_VENDOR_ID_DELL, dell_cable },
- -	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE, PCI_VENDOR_ID_DELL, dell_cable },
- -	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, PCI_VENDOR_ID_SUN,  sun_cable },
- -	{ PCI_DEVICE_ID_SERVERWORKS_OSB4IDE, PCI_ANY_ID, osb4_cable },
- -	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, PCI_ANY_ID, csb_cable },
- -	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE, PCI_ANY_ID, csb_cable },
- -	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2, PCI_ANY_ID, csb_cable },
- -	{ PCI_DEVICE_ID_SERVERWORKS_HT1000IDE, PCI_ANY_ID, csb_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_DELL, oem_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_VENDOR_ID_DELL, oem_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_SUN,  oem_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_OSB4IDE,   PCI_ANY_ID, ata_cable_40wire  },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2,  PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_HT1000IDE, PCI_ANY_ID, ata_cable_unknown },
 	{ }
 };
 
@@ -393,6 +349,31 @@ static void serverworks_fixup_ht1000(struct pci_dev *pdev)
 	pci_write_config_byte(pdev, 0x5A, btr);
 }
 
+static int serverworks_fixup(struct pci_dev *pdev)
+{
+	int rc = 0;
+
+	/* Force master latency timer to 64 PCI clocks */
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
+
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_SERVERWORKS_OSB4IDE:
+		rc = serverworks_fixup_osb4(pdev);
+		break;
+	case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
+		ata_pci_bmdma_clear_simplex(pdev);
+		/* fall through */
+	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE:
+	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2:
+		rc = serverworks_fixup_csb(pdev);
+		break;
+	case PCI_DEVICE_ID_SERVERWORKS_HT1000IDE:
+		serverworks_fixup_ht1000(pdev);
+		break;
+	}
+
+	return rc;
+}
 
 static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -430,13 +411,12 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 	if (rc)
 		return rc;
 
- -	/* Force master latency timer to 64 PCI clocks */
- -	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
+	rc = serverworks_fixup(pdev);
 
 	/* OSB4 : South Bridge and IDE */
 	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
 		/* Select non UDMA capable OSB4 if we can't do fixups */
- -		if ( serverworks_fixup_osb4(pdev) < 0)
+		if (rc < 0)
 			ppi[0] = &info[1];
 	}
 	/* setup CSB5/CSB6 : South Bridge and IDE option RAID */
@@ -446,19 +426,13 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 
 		 /* If the returned btr is the newer revision then
 		    select the right info block */
- -		 if (serverworks_fixup_csb(pdev) == 3)
+		 if (rc == 3)
 		 	ppi[0] = &info[3];
 
 		/* Is this the 3rd channel CSB6 IDE ? */
 		if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2)
 			ppi[1] = &ata_dummy_port_info;
 	}
- -	/* setup HT1000E */
- -	else if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_HT1000IDE)
- -		serverworks_fixup_ht1000(pdev);
- -
- -	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
- -		ata_pci_bmdma_clear_simplex(pdev);
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &serverworks_sht, NULL, 0);
 }
@@ -473,24 +447,7 @@ static int serverworks_reinit_one(struct pci_dev *pdev)
 	if (rc)
 		return rc;
 
- -	/* Force master latency timer to 64 PCI clocks */
- -	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
- -
- -	switch (pdev->device) {
- -		case PCI_DEVICE_ID_SERVERWORKS_OSB4IDE:
- -			serverworks_fixup_osb4(pdev);
- -			break;
- -		case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
- -			ata_pci_bmdma_clear_simplex(pdev);
- -			/* fall through */
- -		case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE:
- -		case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2:
- -			serverworks_fixup_csb(pdev);
- -			break;
- -		case PCI_DEVICE_ID_SERVERWORKS_HT1000IDE:
- -			serverworks_fixup_ht1000(pdev);
- -			break;
- -	}
+	(void)serverworks_fixup(pdev);
 
 	ata_host_resume(host);
 	return 0;
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 31f759b..b92eacf 100644
- --- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -38,11 +38,12 @@
 
 /**
  *	sil680_selreg		-	return register base
- - *	@hwif: interface
+ *	@ap: ATA interface
  *	@r: config offset
  *
- - *	Turn a config register offset into the right address in either
- - *	PCI space or MMIO space to access the control register in question
+ *	Turn a config register offset into the right address in PCI space
+ *	to access the control register in question.
+ *
  *	Thankfully this is a configuration operation so isn't performance
  *	criticial.
  */
@@ -56,12 +57,12 @@ static unsigned long sil680_selreg(struct ata_port *ap, int r)
 
 /**
  *	sil680_seldev		-	return register base
- - *	@hwif: interface
+ *	@ap: ATA interface
  *	@r: config offset
  *
- - *	Turn a config register offset into the right address in either
- - *	PCI space or MMIO space to access the control register in question
- - *	including accounting for the unit shift.
+ *	Turn a config register offset into the right address in PCI space
+ *	to access the control register in question including accounting for
+ *	the unit shift.
  */
 
 static unsigned long sil680_seldev(struct ata_port *ap, struct ata_device *adev, int r)
@@ -81,7 +82,8 @@ static unsigned long sil680_seldev(struct ata_port *ap, struct ata_device *adev,
  *	space for us.
  */
 
- -static int sil680_cable_detect(struct ata_port *ap) {
+static int sil680_cable_detect(struct ata_port *ap)
+{
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned long addr = sil680_selreg(ap, 0);
 	u8 ata66;
@@ -93,7 +95,7 @@ static int sil680_cable_detect(struct ata_port *ap) {
 }
 
 /**
- - *	sil680_set_piomode	-	set initial PIO mode data
+ *	sil680_set_piomode	-	set PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *
@@ -104,8 +106,12 @@ static int sil680_cable_detect(struct ata_port *ap) {
 
 static void sil680_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
- -	static u16 speed_p[5] = { 0x328A, 0x2283, 0x1104, 0x10C3, 0x10C1 };
- -	static u16 speed_t[5] = { 0x328A, 0x2283, 0x1281, 0x10C3, 0x10C1 };
+	static const u16 speed_p[5] = {
+		0x328A, 0x2283, 0x1104, 0x10C3, 0x10C1
+	};
+	static const u16 speed_t[5] = {
+		0x328A, 0x2283, 0x1281, 0x10C3, 0x10C1
+	};
 
 	unsigned long tfaddr = sil680_selreg(ap, 0x02);
 	unsigned long addr = sil680_seldev(ap, adev, 0x04);
@@ -140,22 +146,23 @@ static void sil680_set_piomode(struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
- - *	sil680_set_dmamode	-	set initial DMA mode data
+ *	sil680_set_dmamode	-	set DMA mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *
- - *	Program the MWDMA/UDMA modes for the sil680 k
- - *	chipset. The MWDMA mode values are pulled from a lookup table
+ *	Program the MWDMA/UDMA modes for the sil680 chipset.
+ *
+ *	The MWDMA mode values are pulled from a lookup table
  *	while the chipset uses mode number for UDMA.
  */
 
 static void sil680_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
- -	static u8 ultra_table[2][7] = {
+	static const u8 ultra_table[2][7] = {
 		{ 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01, 0xFF },	/* 100MHz */
 		{ 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 },	/* 133Mhz */
 	};
- -	static u16 dma_table[3] = { 0x2208, 0x10C2, 0x10C1 };
+	static const u16 dma_table[3] = { 0x2208, 0x10C2, 0x10C1 };
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned long ma = sil680_seldev(ap, adev, 0x08);
@@ -175,7 +182,7 @@ static void sil680_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	mode &= ~(0x03 << port_shift);
 
 	/* Extract scsc */
- -	scsc = (scsc & 0x30) ? 1: 0;
+	scsc = (scsc & 0x30) ? 1 : 0;
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		multi = 0x10C1;
@@ -248,7 +255,7 @@ static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 {
 	u8 tmpbyte	= 0;
 
- -        /* FIXME: double check */
+	/* FIXME: double check */
 	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE,
 			      pdev->revision ? 1 : 255);
 
@@ -266,22 +273,22 @@ static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
 #endif
 
- -	switch(tmpbyte & 0x30) {
- -		case 0x00:
- -			/* 133 clock attempt to force it on */
- -			pci_write_config_byte(pdev, 0x8A, tmpbyte|0x10);
- -			break;
- -		case 0x30:
- -			/* if clocking is disabled */
- -			/* 133 clock attempt to force it on */
- -			pci_write_config_byte(pdev, 0x8A, tmpbyte & ~0x20);
- -			break;
- -		case 0x10:
- -			/* 133 already */
- -			break;
- -		case 0x20:
- -			/* BIOS set PCI x2 clocking */
- -			break;
+	switch (tmpbyte & 0x30) {
+	case 0x00:
+		/* 133 clock attempt to force it on */
+		pci_write_config_byte(pdev, 0x8A, tmpbyte|0x10);
+		break;
+	case 0x30:
+		/* if clocking is disabled */
+		/* 133 clock attempt to force it on */
+		pci_write_config_byte(pdev, 0x8A, tmpbyte & ~0x20);
+		break;
+	case 0x10:
+		/* 133 already */
+		break;
+	case 0x20:
+		/* BIOS set PCI x2 clocking */
+		break;
 	}
 
 	pci_read_config_byte(pdev,   0x8A, &tmpbyte);
@@ -299,12 +306,19 @@ static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 	pci_write_config_dword(pdev, 0xB8, 0x43924392);
 	pci_write_config_dword(pdev, 0xBC, 0x40094009);
 
- -	switch(tmpbyte & 0x30) {
- -		case 0x00: printk(KERN_INFO "sil680: 100MHz clock.\n");break;
- -		case 0x10: printk(KERN_INFO "sil680: 133MHz clock.\n");break;
- -		case 0x20: printk(KERN_INFO "sil680: Using PCI clock.\n");break;
- -		/* This last case is _NOT_ ok */
- -		case 0x30: printk(KERN_ERR "sil680: Clock disabled ?\n");
+	switch (tmpbyte & 0x30) {
+	case 0x00:
+		printk(KERN_INFO "sil680: 100MHz clock.\n");
+		break;
+	case 0x10:
+		printk(KERN_INFO "sil680: 133MHz clock.\n");
+		break;
+	case 0x20:
+		printk(KERN_INFO "sil680: Using PCI clock.\n");
+		break;
+	/* This last case is _NOT_ ok */
+	case 0x30:
+		printk(KERN_ERR "sil680: Clock disabled ?\n");
 	}
 	return tmpbyte & 0x30;
 }
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 533f2ae..b0edc7d 100644
- --- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -55,7 +55,7 @@ static const struct sis_laptop sis_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
 	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
- -	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
+	{ 0x5513, 0x1071, 0x8640 },	/* EasyNote K5305 */
 	/* end marker */
 	{ 0, }
 };
@@ -76,7 +76,7 @@ static int sis_short_ata40(struct pci_dev *dev)
 }
 
 /**
- - *	sis_old_port_base		-	return PCI configuration base for dev
+ *	sis_old_port_base - return PCI configuration base for dev
  *	@adev: device
  *
  *	Returns the base of the PCI configuration registers for this port
@@ -85,11 +85,34 @@ static int sis_short_ata40(struct pci_dev *dev)
 
 static int sis_old_port_base(struct ata_device *adev)
 {
- -	return  0x40 + (4 * adev->link->ap->port_no) +  (2 * adev->devno);
+	return 0x40 + (4 * adev->link->ap->port_no) + (2 * adev->devno);
 }
 
 /**
- - *	sis_133_cable_detect	-	check for 40/80 pin
+ *	sis_port_base - return PCI configuration base for dev
+ *	@adev: device
+ *
+ *	Returns the base of the PCI configuration registers for this port
+ *	number.
+ */
+
+static int sis_port_base(struct ata_device *adev)
+{
+	struct ata_port *ap = adev->link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int port = 0x40;
+	u32 reg54;
+
+	/* If bit 30 is set then the registers are mapped at 0x70 not 0x40 */
+	pci_read_config_dword(pdev, 0x54, &reg54);
+	if (reg54 & 0x40000000)
+		port = 0x70;
+
+	return port + (8 * ap->port_no) + (4 * adev->devno);
+}
+
+/**
+ *	sis_133_cable_detect - check for 40/80 pin
  *	@ap: Port
  *	@deadline: deadline jiffies for the operation
  *
@@ -110,7 +133,7 @@ static int sis_133_cable_detect(struct ata_port *ap)
 }
 
 /**
- - *	sis_66_cable_detect	-	check for 40/80 pin
+ *	sis_66_cable_detect - check for 40/80 pin
  *	@ap: Port
  *
  *	Perform cable detection on the UDMA66, UDMA100 and early UDMA133
@@ -132,7 +155,7 @@ static int sis_66_cable_detect(struct ata_port *ap)
 
 
 /**
- - *	sis_pre_reset		-	probe begin
+ *	sis_pre_reset - probe begin
  *	@link: ATA link
  *	@deadline: deadline jiffies for the operation
  *
@@ -160,7 +183,7 @@ static int sis_pre_reset(struct ata_link *link, unsigned long deadline)
 
 
 /**
- - *	sis_set_fifo	-	Set RWP fifo bits for this device
+ *	sis_set_fifo - Set RWP fifo bits for this device
  *	@ap: Port
  *	@adev: Device
  *
@@ -203,13 +226,13 @@ static void sis_set_fifo(struct ata_port *ap, struct ata_device *adev)
 
 static void sis_old_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
- -	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int port = sis_old_port_base(adev);
 	u8 t1, t2;
 	int speed = adev->pio_mode - XFER_PIO_0;
 
- -	const u8 active[]   = { 0x00, 0x07, 0x04, 0x03, 0x01 };
- -	const u8 recovery[] = { 0x00, 0x06, 0x04, 0x03, 0x03 };
+	static const u8 active[]   = { 0x00, 0x07, 0x04, 0x03, 0x01 };
+	static const u8 recovery[] = { 0x00, 0x06, 0x04, 0x03, 0x03 };
 
 	sis_set_fifo(ap, adev);
 
@@ -240,11 +263,11 @@ static void sis_old_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
- -	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int port = sis_old_port_base(adev);
 	int speed = adev->pio_mode - XFER_PIO_0;
 
- -	const u8 actrec[] = { 0x00, 0x67, 0x44, 0x33, 0x31 };
+	static const u8 actrec[] = { 0x00, 0x67, 0x44, 0x33, 0x31 };
 
 	sis_set_fifo(ap, adev);
 
@@ -265,20 +288,19 @@ static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
- -	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
- -	int port = 0x40;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int port;
 	u32 t1;
- -	u32 reg54;
 	int speed = adev->pio_mode - XFER_PIO_0;
 
- -	const u32 timing133[] = {
+	static const u32 timing133[] = {
 		0x28269000,	/* Recovery << 24 | Act << 16 | Ini << 12 */
 		0x0C266000,
 		0x04263000,
 		0x0C0A3000,
 		0x05093000
 	};
- -	const u32 timing100[] = {
+	static const u32 timing100[] = {
 		0x1E1C6000,	/* Recovery << 24 | Act << 16 | Ini << 12 */
 		0x091C4000,
 		0x031C2000,
@@ -288,12 +310,7 @@ static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 	sis_set_fifo(ap, adev);
 
- -	/* If bit 14 is set then the registers are mapped at 0x70 not 0x40 */
- -	pci_read_config_dword(pdev, 0x54, &reg54);
- -	if (reg54 & 0x40000000)
- -		port = 0x70;
- -	port += 8 * ap->port_no +  4 * adev->devno;
- -
+	port = sis_port_base(adev);
 	pci_read_config_dword(pdev, port, &t1);
 	t1 &= 0xC0C00FFF;	/* Mask out timing */
 
@@ -319,13 +336,13 @@ static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
- -	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
- -	const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
- -	const u16 udma_bits[]  = { 0xE000, 0xC000, 0xA000 };
+	static const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
+	static const u16 udma_bits[]  = { 0xE000, 0xC000, 0xA000 };
 
 	pci_read_config_word(pdev, drive_pci, &timing);
 
@@ -358,14 +375,14 @@ static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
- -	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
 	/* MWDMA 0-2 and UDMA 0-5 */
- -	const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
- -	const u16 udma_bits[]  = { 0xF000, 0xD000, 0xB000, 0xA000, 0x9000, 0x8000 };
+	static const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
+	static const u16 udma_bits[]  = { 0xF000, 0xD000, 0xB000, 0xA000, 0x9000, 0x8000 };
 
 	pci_read_config_word(pdev, drive_pci, &timing);
 
@@ -397,12 +414,12 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_100_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
- -	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
 	u8 timing;
 
- -	const u8 udma_bits[]  = { 0x8B, 0x87, 0x85, 0x83, 0x82, 0x81};
+	static const u8 udma_bits[]  = { 0x8B, 0x87, 0x85, 0x83, 0x82, 0x81};
 
 	pci_read_config_byte(pdev, drive_pci + 1, &timing);
 
@@ -431,7 +448,7 @@ static void sis_100_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 static void sis_133_early_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
- -	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
 	u8 timing;
@@ -464,32 +481,34 @@ static void sis_133_early_set_dmamode (struct ata_port *ap, struct ata_device *a
 
 static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
- -	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
- -	int speed = adev->dma_mode - XFER_MW_DMA_0;
- -	int port = 0x40;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int port;
 	u32 t1;
- -	u32 reg54;
- -
- -	/* bits 4- cycle time 8 - cvs time */
- -	static const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
- -	static const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
- -
- -	/* If bit 14 is set then the registers are mapped at 0x70 not 0x40 */
- -	pci_read_config_dword(pdev, 0x54, &reg54);
- -	if (reg54 & 0x40000000)
- -		port = 0x70;
- -	port += (8 * ap->port_no) +  (4 * adev->devno);
 
+	port = sis_port_base(adev);
 	pci_read_config_dword(pdev, port, &t1);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
+		/* Recovery << 24 | Act << 16 | Ini << 12, like PIO modes */
+		static const u32 timing_u100[] = { 0x19154000, 0x06072000, 0x04062000 };
+		static const u32 timing_u133[] = { 0x221C6000, 0x0C0A3000, 0x05093000 };
+		int speed = adev->dma_mode - XFER_MW_DMA_0;
+
+		t1 &= 0xC0C00FFF;
+		/* disable UDMA */
 		t1 &= ~0x00000004;
- -		/* FIXME: need data sheet to add MWDMA here. Also lacking on
- -		   ide/pci driver */
+		if (t1 & 0x08)
+			t1 |= timing_u133[speed];
+		else
+			t1 |= timing_u100[speed];
 	} else {
- -		speed = adev->dma_mode - XFER_UDMA_0;
- -		/* if & 8 no UDMA133 - need info for ... */
+		/* bits 4- cycle time 8 - cvs time */
+		static const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
+		static const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
+		int speed = adev->dma_mode - XFER_UDMA_0;
+
 		t1 &= ~0x00000FF0;
+		/* enable UDMA */
 		t1 |= 0x00000004;
 		if (t1 & 0x08)
 			t1 |= timing_u133[speed];
@@ -499,6 +518,27 @@ static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	pci_write_config_dword(pdev, port, t1);
 }
 
+/**
+ *	sis_133_mode_filter - mode selection filter
+ *	@adev: ATA device
+ *
+ *	Block UDMA6 on devices that do not support it.
+ */
+
+static unsigned long sis_133_mode_filter(struct ata_device *adev, unsigned long mask)
+{
+	struct ata_port *ap = adev->link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int port = sis_port_base(adev);
+	u32 t1;
+
+	pci_read_config_dword(pdev, port, &t1);
+	/* if ATA133 is disabled, mask it out */
+	if (!(t1 & 0x08))
+		mask &= ~(0xC0 << ATA_SHIFT_UDMA);
+	return mask;
+}
+
 static struct scsi_host_template sis_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -520,6 +560,7 @@ static struct ata_port_operations sis_133_ops = {
 	.set_piomode		= sis_133_set_piomode,
 	.set_dmamode		= sis_133_set_dmamode,
 	.cable_detect		= sis_133_cable_detect,
+	.mode_filter		= sis_133_mode_filter,
 };
 
 static struct ata_port_operations sis_133_early_ops = {
@@ -588,7 +629,7 @@ static const struct ata_port_info sis_info100_early = {
 static const struct ata_port_info sis_info133 = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
- -	/* No MWDMA */
+	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_133_ops,
 };
@@ -669,7 +710,7 @@ static void sis_fixup(struct pci_dev *pdev, struct sis_chipset *sis)
  *	@pdev: PCI device to register
  *	@ent: Entry in sis_pci_tbl matching with @pdev
  *
- - *	Called from kernel PCI layer.  We probe for combined mode (sigh),
+ *	Called from kernel PCI layer. We probe for combined mode (sigh),
  *	and then hand over control to libata, for it to do the rest.
  *
  *	LOCKING:
@@ -769,17 +810,20 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		switch(trueid) {
 		case 0x5518:	/* SIS 962/963 */
+			dev_info(&pdev->dev,
+				 "SiS 962/963 MuTIOL IDE UDMA133 controller\n");
 			chipset = &sis133;
 			if ((idemisc & 0x40000000) == 0) {
 				pci_write_config_dword(pdev, 0x54, idemisc | 0x40000000);
- -				printk(KERN_INFO "SIS5513: Switching to 5513 register mapping\n");
+				dev_info(&pdev->dev,
+					 "Switching to 5513 register mapping\n");
 			}
 			break;
 		case 0x0180:	/* SIS 965/965L */
- -			chipset =  &sis133;
+			chipset = &sis133;
 			break;
 		case 0x1180:	/* SIS 966/966L */
- -			chipset =  &sis133;
+			chipset = &sis133;
 			break;
 		}
 	}
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index c06ce8c..24cf200 100644
- --- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -1,6 +1,7 @@
 /*
  * pata_sl82c105.c 	- SL82C105 PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
+ *			  (C) 2011 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/sl82c105.c
  * 		SL82C105/Winbond 553 IDE driver
@@ -289,6 +290,14 @@ static int sl82c105_bridge_revision(struct pci_dev *pdev)
 	return bridge->revision;
 }
 
+static void sl82c105_fixup(struct pci_dev *pdev)
+{
+	u32 val;
+
+	pci_read_config_dword(pdev, 0x40, &val);
+	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
+	pci_write_config_dword(pdev, 0x40, val);
+}
 
 static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
@@ -306,7 +315,6 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	/* for now use only the first port */
 	const struct ata_port_info *ppi[] = { &info_early,
 					       NULL };
- -	u32 val;
 	int rev;
 	int rc;
 
@@ -325,13 +333,28 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	else
 		ppi[0] = &info_dma;
 
- -	pci_read_config_dword(dev, 0x40, &val);
- -	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
- -	pci_write_config_dword(dev, 0x40, val);
+	sl82c105_fixup(dev);
 
 	return ata_pci_bmdma_init_one(dev, ppi, &sl82c105_sht, NULL, 0);
 }
 
+#ifdef CONFIG_PM
+static int sl82c105_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	sl82c105_fixup(pdev);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static const struct pci_device_id sl82c105[] = {
 	{ PCI_VDEVICE(WINBOND, PCI_DEVICE_ID_WINBOND_82C105), },
 
@@ -342,7 +365,11 @@ static struct pci_driver sl82c105_pci_driver = {
 	.name 		= DRV_NAME,
 	.id_table	= sl82c105,
 	.probe 		= sl82c105_init_one,
- -	.remove		= ata_pci_remove_one
+	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend	= ata_pci_device_suspend,
+	.resume		= sl82c105_reinit_one,
+#endif
 };
 
 static int __init sl82c105_init(void)
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 8e9f504..255f336 100644
- --- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -509,6 +509,27 @@ static void via_config_fifo(struct pci_dev *pdev, unsigned int flags)
 	}
 }
 
+static void via_fixup(struct pci_dev *pdev, const struct via_isa_bridge *config)
+{
+	u32 timing;
+
+	/* Initialise the FIFO for the enabled channels. */
+	via_config_fifo(pdev, config->flags);
+
+	if (config->udma_mask == ATA_UDMA4) {
+		/* The 66 MHz devices require we enable the clock */
+		pci_read_config_dword(pdev, 0x50, &timing);
+		timing |= 0x80008;
+		pci_write_config_dword(pdev, 0x50, timing);
+	}
+	if (config->flags & VIA_BAD_CLK66) {
+		/* Disable the 66MHz clock on problem devices */
+		pci_read_config_dword(pdev, 0x50, &timing);
+		timing &= ~0x80008;
+		pci_write_config_dword(pdev, 0x50, timing);
+	}
+}
+
 /**
  *	via_init_one		-	discovery callback
  *	@pdev: PCI device
@@ -570,7 +591,6 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct pci_dev *isa;
 	const struct via_isa_bridge *config;
 	u8 enable;
- -	u32 timing;
 	unsigned long flags = id->driver_data;
 	int rc;
 
@@ -609,9 +629,6 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			return -ENODEV;
 	}
 
- -	/* Initialise the FIFO for the enabled channels. */
- -	via_config_fifo(pdev, config->flags);
- -
 	/* Clock set up */
 	switch (config->udma_mask) {
 	case 0x00:
@@ -637,12 +654,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENODEV;
  	}
 
- -	if (config->flags & VIA_BAD_CLK66) {
- -		/* Disable the 66MHz clock on problem devices */
- -		pci_read_config_dword(pdev, 0x50, &timing);
- -		timing &= ~0x80008;
- -		pci_write_config_dword(pdev, 0x50, timing);
- -	}
+	via_fixup(pdev, config);
 
 	/* We have established the device type, now fire it up */
 	return ata_pci_bmdma_init_one(pdev, ppi, &via_sht, (void *)config, 0);
@@ -661,29 +673,14 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static int via_reinit_one(struct pci_dev *pdev)
 {
- -	u32 timing;
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
- -	const struct via_isa_bridge *config = host->private_data;
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
 	if (rc)
 		return rc;
 
- -	via_config_fifo(pdev, config->flags);
- -
- -	if (config->udma_mask == ATA_UDMA4) {
- -		/* The 66 MHz devices require we enable the clock */
- -		pci_read_config_dword(pdev, 0x50, &timing);
- -		timing |= 0x80008;
- -		pci_write_config_dword(pdev, 0x50, timing);
- -	}
- -	if (config->flags & VIA_BAD_CLK66) {
- -		/* Disable the 66MHz clock on problem devices */
- -		pci_read_config_dword(pdev, 0x50, &timing);
- -		timing &= ~0x80008;
- -		pci_write_config_dword(pdev, 0x50, timing);
- -	}
+	via_fixup(pdev, host->private_data);
 
 	ata_host_resume(host);
 	return 0;
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 4b6b209..0b8b8b4 100644
- --- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4087,8 +4087,11 @@ static int mv_platform_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "slots %u ports %d\n",
 		 (unsigned)MV_MAX_Q_DEPTH, host->n_ports);
 
- -	return ata_host_activate(host, platform_get_irq(pdev, 0), mv_interrupt,
- -				 IRQF_SHARED, &mv6_sht);
+	rc = ata_host_activate(host, platform_get_irq(pdev, 0), mv_interrupt,
+			       IRQF_SHARED, &mv6_sht);
+	if (!rc)
+		return 0;
+
 err:
 #if defined(CONFIG_HAVE_CLK)
 	if (!IS_ERR(hpriv->clk)) {
@@ -4110,8 +4113,7 @@ err:
  */
 static int __devexit mv_platform_remove(struct platform_device *pdev)
 {
- -	struct device *dev = &pdev->dev;
- -	struct ata_host *host = dev_get_drvdata(dev);
+	struct ata_host *host = platform_get_drvdata(pdev);
 #if defined(CONFIG_HAVE_CLK)
 	struct mv_host_priv *hpriv = host->private_data;
 #endif
@@ -4129,7 +4131,7 @@ static int __devexit mv_platform_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int mv_platform_suspend(struct platform_device *pdev, pm_message_t state)
 {
- -	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ata_host *host = platform_get_drvdata(pdev);
 	if (host)
 		return ata_host_suspend(host, state);
 	else
@@ -4138,7 +4140,7 @@ static int mv_platform_suspend(struct platform_device *pdev, pm_message_t state)
 
 static int mv_platform_resume(struct platform_device *pdev)
 {
- -	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ata_host *host = platform_get_drvdata(pdev);
 	int ret;
 
 	if (host) {
@@ -4353,7 +4355,7 @@ static int mv_pci_init_one(struct pci_dev *pdev,
 #ifdef CONFIG_PM
 static int mv_pci_device_resume(struct pci_dev *pdev)
 {
- -	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ata_host *host = pci_get_drvdata(pdev);
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 55470f3..1e91406 100644
- --- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -268,7 +268,7 @@ union sil24_cmd_block {
 	struct sil24_atapi_block atapi;
 };
 
- -static struct sil24_cerr_info {
+static const struct sil24_cerr_info {
 	unsigned int err_mask, action;
 	const char *desc;
 } sil24_cerr_db[] = {
@@ -1019,7 +1019,7 @@ static void sil24_error_intr(struct ata_port *ap)
 
 	/* deal with command error */
 	if (irq_stat & PORT_IRQ_ERROR) {
- -		struct sil24_cerr_info *ci = NULL;
+		const struct sil24_cerr_info *ci = NULL;
 		unsigned int err_mask = 0, action = 0;
 		u32 context, cerr;
 		int pmp;
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTqhrjCWzCDIBeCsvAQJ1Ww/+P9ZBEwQNcucxdt1MkF3h4Nd9jy+jf3Ha
8Pj0l2mvzaP4veGfM8kq51ptKI5rTpeuiRNvZw7S/uTR3WqNXcUpJrVex7anvv/s
tLU17JxfQbsB9Sbo3929X0xbeYXizR+wJRPYr/4sy8ukkGsEBbSEqmiSAiL+vZ68
e/RRBSi8t1InVRzlQ6riCDRSC0unYfBNKN8BjY6TiFziBFeZjsXpTo0oSVq4bq12
eAz134scTZBDmnbXYxq8FvOip2Oe2rUPF8HFkCkAQgnlXAfUZXacyNqG3lcOytib
AAwnPgbiemVjEwDhG6Lf2B8b3Q3EMFU79x+h9BXmibSkKo0lgyOSRrvyyWF2KJ1c
ZWZAZE3f4JR6jMtrMZjyaawLnvTZqrRLFJkONEQLFF7d02oDnIPq8Ie+5CpZ8HOh
KwtWVRFr+7L2iY/dUWo/WG9MtLrgxglA08PvojZPPkEXyX8A2W6EzQRc5g8aBJca
jLrjXEJ8l9C5BtQl+WQQwsLOLJumKBC7WN3YDyTapddVQEY4CKXIG/nSQlOz84y7
yKXpye4T+/IR7NmxllFcYI9mPpf5jvX642ZsZJXOfKE9UV1p8OqYq775CDzguPU4
Njx8LGb4PlK6wubDgMdX8svJH5rWa77sEyFkNK6tKdrxsAvYgXohnZr+AI18tJtu
lPmrRSR6ESA=
=a7fj
-----END PGP SIGNATURE-----
