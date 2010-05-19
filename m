Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0ESRtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:49:36 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48970 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab0ESRta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:49:30 -0400
Date: Wed, 19 May 2010 13:49:27 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 2.6.35
Message-ID: <20100519174927.GA4903@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Notable changes:

* ahci: "libahci" split out of ahci driver, because several knockoffs have
  emerged that require a fair amount of vendor-specific code
* ahci: uses less power
* ahci: improved enclosure management interface
* PIO command submission uses fewer PIO cycles
* cleanups improving separation between SFF (original IDE interface)
  and BMDMA (PCI IDE DMA).  NOTE:  A few more patches coming down the
  pipe, to finish this off.
* other random minor bits



Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/DocBook/libata.tmpl   |   18 +-
 drivers/ata/Kconfig                 |   20 +-
 drivers/ata/Makefile                |    3 +-
 drivers/ata/ahci.c                  | 2544 +++--------------------------------
 drivers/ata/ahci.h                  |  343 +++++
 drivers/ata/ahci_platform.c         |  192 +++
 drivers/ata/libahci.c               | 2216 ++++++++++++++++++++++++++++++
 drivers/ata/libata-core.c           |  216 +---
 drivers/ata/libata-eh.c             |    6 +-
 drivers/ata/libata-pmp.c            |   32 +-
 drivers/ata/libata-scsi.c           |    3 -
 drivers/ata/libata-sff.c            | 1387 ++++++++++---------
 drivers/ata/libata.h                |   29 +-
 drivers/ata/pata_acpi.c             |    8 +-
 drivers/ata/pata_ali.c              |    2 +-
 drivers/ata/pata_at91.c             |    1 -
 drivers/ata/pata_atiixp.c           |    2 +-
 drivers/ata/pata_bf54x.c            |   87 +-
 drivers/ata/pata_cmd640.c           |   13 +-
 drivers/ata/pata_cs5520.c           |    2 +-
 drivers/ata/pata_cs5530.c           |    4 +-
 drivers/ata/pata_hpt366.c           |    2 +-
 drivers/ata/pata_hpt37x.c           |    4 +-
 drivers/ata/pata_hpt3x2n.c          |    2 +-
 drivers/ata/pata_icside.c           |    5 +-
 drivers/ata/pata_it821x.c           |    6 +-
 drivers/ata/pata_macio.c            |    5 +-
 drivers/ata/pata_mpc52xx.c          |   78 +-
 drivers/ata/pata_ns87415.c          |    2 +-
 drivers/ata/pata_octeon_cf.c        |   12 +-
 drivers/ata/pata_oldpiix.c          |    2 +-
 drivers/ata/pata_pcmcia.c           |    2 +-
 drivers/ata/pata_pdc2027x.c         |    4 +-
 drivers/ata/pata_pdc202xx_old.c     |    2 +-
 drivers/ata/pata_platform.c         |    1 -
 drivers/ata/pata_radisys.c          |    2 +-
 drivers/ata/pata_sc1200.c           |    4 +-
 drivers/ata/pata_scc.c              |   80 +-
 drivers/ata/pata_sch.c              |   12 +-
 drivers/ata/pata_serverworks.c      |    6 +-
 drivers/ata/pata_sil680.c           |   30 +-
 drivers/ata/pata_via.c              |    6 +-
 drivers/ata/pdc_adma.c              |   74 +-
 drivers/ata/sata_inic162x.c         |   25 +-
 drivers/ata/sata_mv.c               |   47 +-
 drivers/ata/sata_nv.c               |  265 ++--
 drivers/ata/sata_promise.c          |   32 +-
 drivers/ata/sata_qstor.c            |   90 +-
 drivers/ata/sata_sil.c              |    9 +-
 drivers/ata/sata_sil24.c            |    9 +-
 drivers/ata/sata_svw.c              |    2 +-
 drivers/ata/sata_sx4.c              |   10 +-
 drivers/ata/sata_uli.c              |    4 +-
 drivers/ata/sata_vsc.c              |   10 +-
 drivers/scsi/ipr.c                  |    6 +-
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 include/linux/ahci_platform.h       |   29 +
 include/linux/ata.h                 |    2 +-
 include/linux/libata.h              |   80 +-
 59 files changed, 4212 insertions(+), 3879 deletions(-)
 create mode 100644 drivers/ata/ahci.h
 create mode 100644 drivers/ata/ahci_platform.c
 create mode 100644 drivers/ata/libahci.c
 create mode 100644 include/linux/ahci_platform.h

Akinobu Mita (1):
      libata: use __ratelimit

Alan Cox (2):
      libata: Remove excess delay in the tf_load path
      pata_sil680: Do our own exec_command posting

Anton Vorontsov (10):
      ahci: Get rid of host->iomap usage
      ahci: Factor out PCI specifics from ahci_save_initial_config()
      ahci: Get rid of pci_dev argument in ahci_save_initial_config()
      ahci: Factor out PCI specifics from ahci_reset_controller()
      ahci: Get rid of pci_dev argument in ahci_port_init()
      ahci: Factor out PCI specifics from ahci_init_controller()
      ahci: Factor out PCI specifics from ahci_print_info()
      ahci: Introduce ahci_set_em_messages()
      ahci: Move generic code into libahci
      ahci: Add platform driver

Grant Grundler (1):
      [libata] Disable R_OK (Early ACK) on SII 3726 PMP

Harry Zhang (2):
      ahci: EM message type auto detect
      ahci: add "em_buffer" attribute for AHCI hosts

Jeff Garzik (1):
      ahci_platform: properly set up EM messaging

Matthew Garrett (1):
      ahci: Turn off DMA engines when there's no device attached

Roman Fietze (1):
      pata_mpc52xx: reduce code size by simple change of constant data types

Sebastian Andrzej Siewior (1):
      libata: don't flush dcache on slab pages

Sergei Shtylyov (6):
      libata-sff: kill unused ata_bus_reset()
      pata_scc: make scc_wait_after_reset() static
      pata_scc: kill useless check in scc_postreset()
      libata: introduce sff_set_devctl() method
      libata: make sff_irq_on() method optional
      pata_cmd640: don't read CFR pointlessly

Tejun Heo (23):
      ahci: clean up board IDs
      ahci: implement AHCI_HFLAG_NO_FPDMA_AA and update NV quirks
      libata: update gfp/slab.h includes
      libata: use longer 0xff wait if parallel scan is enabled
      sata_nv: use ata_pci_sff_activate_host() instead of ata_host_activate()
      pata_sch: use ata_pci_sff_init_one()
      sata_inic162x: inic162x is not dependent on CONFIG_ATA_SFF
      sata_mv: remove unnecessary initialization
      libata-sff: update bmdma host bus error handling
      libata-sff: kill unused prototype and make ata_dev_select() static
      libata: kill ATA_FLAG_DISABLED
      sata_inic162x: kill PORT_PRD_ADDR initialization
      libata-sff: reorder SFF/BMDMA functions
      libata-sff: clean up inheritance in several drivers
      libata-sff: clean up BMDMA initialization
      libata-sff: introduce ata_sff_init/exit() and ata_sff_port_init()
      libata-sff: rename ap->ops->drain_fifo() to sff_drain_fifo()
      libata-sff: ap->[last_]ctl are SFF specific
      libata-sff: port_task is SFF specific
      libata-sff: separate out BMDMA EH
      libata-sff: ata_sff_[dumb_]qc_prep are BMDMA specific
      libata-sff: prd is BMDMA specific
      libata-sff: separate out BMDMA qc_issue

diff --git a/Documentation/DocBook/libata.tmpl b/Documentation/DocBook/libata.tmpl
index ff3e5be..828748c 100644
--- a/Documentation/DocBook/libata.tmpl
+++ b/Documentation/DocBook/libata.tmpl
@@ -81,16 +81,14 @@ void (*port_disable) (struct ata_port *);
 	</programlisting>
 
 	<para>
-	Called from ata_bus_probe() and ata_bus_reset() error paths,
-	as well as when unregistering from the SCSI module (rmmod, hot
-	unplug).
+	Called from ata_bus_probe() error path, as well as when
+	unregistering from the SCSI module (rmmod, hot unplug).
 	This function should do whatever needs to be done to take the
 	port out of use.  In most cases, ata_port_disable() can be used
 	as this hook.
 	</para>
 	<para>
 	Called from ata_bus_probe() on a failed probe.
-	Called from ata_bus_reset() on a failed bus reset.
 	Called from ata_scsi_release().
 	</para>
 
@@ -227,6 +225,18 @@ u8   (*sff_check_altstatus)(struct ata_port *ap);
 
 	</sect2>
 
+	<sect2><title>Write specific ATA shadow register</title>
+	<programlisting>
+void (*sff_set_devctl)(struct ata_port *ap, u8 ctl);
+	</programlisting>
+
+	<para>
+	Write the device control ATA shadow register to the hardware.
+	Most drivers don't need to define this.
+	</para>
+
+	</sect2>
+
 	<sect2><title>Select ATA device on bus</title>
 	<programlisting>
 void (*sff_dev_select)(struct ata_port *ap, unsigned int device);
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 01c52c4..e68541f 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -65,6 +65,14 @@ config SATA_AHCI
 
 	  If unsure, say N.
 
+config SATA_AHCI_PLATFORM
+	tristate "Platform AHCI SATA support"
+	help
+	  This option enables support for Platform AHCI Serial ATA
+	  controllers.
+
+	  If unsure, say N.
+
 config SATA_SIL24
 	tristate "Silicon Image 3124/3132 SATA support"
 	depends on PCI
@@ -73,6 +81,12 @@ config SATA_SIL24
 
 	  If unsure, say N.
 
+config SATA_INIC162X
+	tristate "Initio 162x SATA support"
+	depends on PCI
+	help
+	  This option enables support for Initio 162x Serial ATA.
+
 config SATA_FSL
 	tristate "Freescale 3.0Gbps SATA support"
 	depends on FSL_SOC
@@ -213,12 +227,6 @@ config SATA_VITESSE
 
 	  If unsure, say N.
 
-config SATA_INIC162X
-	tristate "Initio 162x SATA support"
-	depends on PCI
-	help
-	  This option enables support for Initio 162x Serial ATA.
-
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
 	depends on ATA_ACPI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index fc936d4..d0a93c4 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,7 +1,8 @@
 
 obj-$(CONFIG_ATA)		+= libata.o
 
-obj-$(CONFIG_SATA_AHCI)		+= ahci.o
+obj-$(CONFIG_SATA_AHCI)		+= ahci.o libahci.o
+obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5326af2..8ca16f5 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -46,403 +46,48 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
+#include "ahci.h"
 
 #define DRV_NAME	"ahci"
 #define DRV_VERSION	"3.0"
 
-/* Enclosure Management Control */
-#define EM_CTRL_MSG_TYPE              0x000f0000
-
-/* Enclosure Management LED Message Type */
-#define EM_MSG_LED_HBA_PORT           0x0000000f
-#define EM_MSG_LED_PMP_SLOT           0x0000ff00
-#define EM_MSG_LED_VALUE              0xffff0000
-#define EM_MSG_LED_VALUE_ACTIVITY     0x00070000
-#define EM_MSG_LED_VALUE_OFF          0xfff80000
-#define EM_MSG_LED_VALUE_ON           0x00010000
-
-static int ahci_skip_host_reset;
-static int ahci_ignore_sss;
-
-module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
-MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
-
-module_param_named(ignore_sss, ahci_ignore_sss, int, 0444);
-MODULE_PARM_DESC(ignore_sss, "Ignore staggered spinup flag (0=don't ignore, 1=ignore)");
-
-static int ahci_enable_alpm(struct ata_port *ap,
-		enum link_pm policy);
-static void ahci_disable_alpm(struct ata_port *ap);
-static ssize_t ahci_led_show(struct ata_port *ap, char *buf);
-static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
-			      size_t size);
-static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
-					ssize_t size);
-
 enum {
 	AHCI_PCI_BAR		= 5,
-	AHCI_MAX_PORTS		= 32,
-	AHCI_MAX_SG		= 168, /* hardware max is 64K */
-	AHCI_DMA_BOUNDARY	= 0xffffffff,
-	AHCI_MAX_CMDS		= 32,
-	AHCI_CMD_SZ		= 32,
-	AHCI_CMD_SLOT_SZ	= AHCI_MAX_CMDS * AHCI_CMD_SZ,
-	AHCI_RX_FIS_SZ		= 256,
-	AHCI_CMD_TBL_CDB	= 0x40,
-	AHCI_CMD_TBL_HDR_SZ	= 0x80,
-	AHCI_CMD_TBL_SZ		= AHCI_CMD_TBL_HDR_SZ + (AHCI_MAX_SG * 16),
-	AHCI_CMD_TBL_AR_SZ	= AHCI_CMD_TBL_SZ * AHCI_MAX_CMDS,
-	AHCI_PORT_PRIV_DMA_SZ	= AHCI_CMD_SLOT_SZ + AHCI_CMD_TBL_AR_SZ +
-				  AHCI_RX_FIS_SZ,
-	AHCI_PORT_PRIV_FBS_DMA_SZ	= AHCI_CMD_SLOT_SZ +
-					  AHCI_CMD_TBL_AR_SZ +
-					  (AHCI_RX_FIS_SZ * 16),
-	AHCI_IRQ_ON_SG		= (1 << 31),
-	AHCI_CMD_ATAPI		= (1 << 5),
-	AHCI_CMD_WRITE		= (1 << 6),
-	AHCI_CMD_PREFETCH	= (1 << 7),
-	AHCI_CMD_RESET		= (1 << 8),
-	AHCI_CMD_CLR_BUSY	= (1 << 10),
-
-	RX_FIS_D2H_REG		= 0x40,	/* offset of D2H Register FIS data */
-	RX_FIS_SDB		= 0x58, /* offset of SDB FIS data */
-	RX_FIS_UNK		= 0x60, /* offset of Unknown FIS data */
-
-	board_ahci		= 0,
-	board_ahci_vt8251	= 1,
-	board_ahci_ign_iferr	= 2,
-	board_ahci_sb600	= 3,
-	board_ahci_mv		= 4,
-	board_ahci_sb700	= 5, /* for SB700 and SB800 */
-	board_ahci_mcp65	= 6,
-	board_ahci_nopmp	= 7,
-	board_ahci_yesncq	= 8,
-	board_ahci_nosntf	= 9,
-
-	/* global controller registers */
-	HOST_CAP		= 0x00, /* host capabilities */
-	HOST_CTL		= 0x04, /* global host control */
-	HOST_IRQ_STAT		= 0x08, /* interrupt status */
-	HOST_PORTS_IMPL		= 0x0c, /* bitmap of implemented ports */
-	HOST_VERSION		= 0x10, /* AHCI spec. version compliancy */
-	HOST_EM_LOC		= 0x1c, /* Enclosure Management location */
-	HOST_EM_CTL		= 0x20, /* Enclosure Management Control */
-	HOST_CAP2		= 0x24, /* host capabilities, extended */
-
-	/* HOST_CTL bits */
-	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
-	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
-	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
-
-	/* HOST_CAP bits */
-	HOST_CAP_SXS		= (1 << 5),  /* Supports External SATA */
-	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
-	HOST_CAP_CCC		= (1 << 7),  /* Command Completion Coalescing */
-	HOST_CAP_PART		= (1 << 13), /* Partial state capable */
-	HOST_CAP_SSC		= (1 << 14), /* Slumber state capable */
-	HOST_CAP_PIO_MULTI	= (1 << 15), /* PIO multiple DRQ support */
-	HOST_CAP_FBS		= (1 << 16), /* FIS-based switching support */
-	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
-	HOST_CAP_ONLY		= (1 << 18), /* Supports AHCI mode only */
-	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
-	HOST_CAP_LED		= (1 << 25), /* Supports activity LED */
-	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
-	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
-	HOST_CAP_MPS		= (1 << 28), /* Mechanical presence switch */
-	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
-	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
-	HOST_CAP_64		= (1 << 31), /* PCI DAC (64-bit DMA) support */
-
-	/* HOST_CAP2 bits */
-	HOST_CAP2_BOH		= (1 << 0),  /* BIOS/OS handoff supported */
-	HOST_CAP2_NVMHCI	= (1 << 1),  /* NVMHCI supported */
-	HOST_CAP2_APST		= (1 << 2),  /* Automatic partial to slumber */
-
-	/* registers for each SATA port */
-	PORT_LST_ADDR		= 0x00, /* command list DMA addr */
-	PORT_LST_ADDR_HI	= 0x04, /* command list DMA addr hi */
-	PORT_FIS_ADDR		= 0x08, /* FIS rx buf addr */
-	PORT_FIS_ADDR_HI	= 0x0c, /* FIS rx buf addr hi */
-	PORT_IRQ_STAT		= 0x10, /* interrupt status */
-	PORT_IRQ_MASK		= 0x14, /* interrupt enable/disable mask */
-	PORT_CMD		= 0x18, /* port command */
-	PORT_TFDATA		= 0x20,	/* taskfile data */
-	PORT_SIG		= 0x24,	/* device TF signature */
-	PORT_CMD_ISSUE		= 0x38, /* command issue */
-	PORT_SCR_STAT		= 0x28, /* SATA phy register: SStatus */
-	PORT_SCR_CTL		= 0x2c, /* SATA phy register: SControl */
-	PORT_SCR_ERR		= 0x30, /* SATA phy register: SError */
-	PORT_SCR_ACT		= 0x34, /* SATA phy register: SActive */
-	PORT_SCR_NTF		= 0x3c, /* SATA phy register: SNotification */
-	PORT_FBS		= 0x40, /* FIS-based Switching */
-
-	/* PORT_IRQ_{STAT,MASK} bits */
-	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
-	PORT_IRQ_TF_ERR		= (1 << 30), /* task file error */
-	PORT_IRQ_HBUS_ERR	= (1 << 29), /* host bus fatal error */
-	PORT_IRQ_HBUS_DATA_ERR	= (1 << 28), /* host bus data error */
-	PORT_IRQ_IF_ERR		= (1 << 27), /* interface fatal error */
-	PORT_IRQ_IF_NONFATAL	= (1 << 26), /* interface non-fatal error */
-	PORT_IRQ_OVERFLOW	= (1 << 24), /* xfer exhausted available S/G */
-	PORT_IRQ_BAD_PMP	= (1 << 23), /* incorrect port multiplier */
-
-	PORT_IRQ_PHYRDY		= (1 << 22), /* PhyRdy changed */
-	PORT_IRQ_DEV_ILCK	= (1 << 7), /* device interlock */
-	PORT_IRQ_CONNECT	= (1 << 6), /* port connect change status */
-	PORT_IRQ_SG_DONE	= (1 << 5), /* descriptor processed */
-	PORT_IRQ_UNK_FIS	= (1 << 4), /* unknown FIS rx'd */
-	PORT_IRQ_SDB_FIS	= (1 << 3), /* Set Device Bits FIS rx'd */
-	PORT_IRQ_DMAS_FIS	= (1 << 2), /* DMA Setup FIS rx'd */
-	PORT_IRQ_PIOS_FIS	= (1 << 1), /* PIO Setup FIS rx'd */
-	PORT_IRQ_D2H_REG_FIS	= (1 << 0), /* D2H Register FIS rx'd */
-
-	PORT_IRQ_FREEZE		= PORT_IRQ_HBUS_ERR |
-				  PORT_IRQ_IF_ERR |
-				  PORT_IRQ_CONNECT |
-				  PORT_IRQ_PHYRDY |
-				  PORT_IRQ_UNK_FIS |
-				  PORT_IRQ_BAD_PMP,
-	PORT_IRQ_ERROR		= PORT_IRQ_FREEZE |
-				  PORT_IRQ_TF_ERR |
-				  PORT_IRQ_HBUS_DATA_ERR,
-	DEF_PORT_IRQ		= PORT_IRQ_ERROR | PORT_IRQ_SG_DONE |
-				  PORT_IRQ_SDB_FIS | PORT_IRQ_DMAS_FIS |
-				  PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
-
-	/* PORT_CMD bits */
-	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
-	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
-	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
-	PORT_CMD_FBSCP		= (1 << 22), /* FBS Capable Port */
-	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
-	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
-	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
-	PORT_CMD_FIS_RX		= (1 << 4), /* Enable FIS receive DMA engine */
-	PORT_CMD_CLO		= (1 << 3), /* Command list override */
-	PORT_CMD_POWER_ON	= (1 << 2), /* Power up device */
-	PORT_CMD_SPIN_UP	= (1 << 1), /* Spin up device */
-	PORT_CMD_START		= (1 << 0), /* Enable port DMA engine */
-
-	PORT_CMD_ICC_MASK	= (0xf << 28), /* i/f ICC state mask */
-	PORT_CMD_ICC_ACTIVE	= (0x1 << 28), /* Put i/f in active state */
-	PORT_CMD_ICC_PARTIAL	= (0x2 << 28), /* Put i/f in partial state */
-	PORT_CMD_ICC_SLUMBER	= (0x6 << 28), /* Put i/f in slumber state */
-
-	PORT_FBS_DWE_OFFSET	= 16, /* FBS device with error offset */
-	PORT_FBS_ADO_OFFSET	= 12, /* FBS active dev optimization offset */
-	PORT_FBS_DEV_OFFSET	= 8,  /* FBS device to issue offset */
-	PORT_FBS_DEV_MASK	= (0xf << PORT_FBS_DEV_OFFSET),  /* FBS.DEV */
-	PORT_FBS_SDE		= (1 << 2), /* FBS single device error */
-	PORT_FBS_DEC		= (1 << 1), /* FBS device error clear */
-	PORT_FBS_EN		= (1 << 0), /* Enable FBS */
-
-	/* hpriv->flags bits */
-	AHCI_HFLAG_NO_NCQ		= (1 << 0),
-	AHCI_HFLAG_IGN_IRQ_IF_ERR	= (1 << 1), /* ignore IRQ_IF_ERR */
-	AHCI_HFLAG_IGN_SERR_INTERNAL	= (1 << 2), /* ignore SERR_INTERNAL */
-	AHCI_HFLAG_32BIT_ONLY		= (1 << 3), /* force 32bit */
-	AHCI_HFLAG_MV_PATA		= (1 << 4), /* PATA port */
-	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
-	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
-	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
-	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
-	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
-	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
-	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= (1 << 11), /* treat SRST timeout as
-							link offline */
-	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
-
-	/* ap->flags bits */
-
-	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
-					  ATA_FLAG_IPM,
-
-	ICH_MAP				= 0x90, /* ICH MAP register */
-
-	/* em constants */
-	EM_MAX_SLOTS			= 8,
-	EM_MAX_RETRY			= 5,
-
-	/* em_ctl bits */
-	EM_CTL_RST			= (1 << 9), /* Reset */
-	EM_CTL_TM			= (1 << 8), /* Transmit Message */
-	EM_CTL_ALHD			= (1 << 26), /* Activity LED */
-};
-
-struct ahci_cmd_hdr {
-	__le32			opts;
-	__le32			status;
-	__le32			tbl_addr;
-	__le32			tbl_addr_hi;
-	__le32			reserved[4];
-};
-
-struct ahci_sg {
-	__le32			addr;
-	__le32			addr_hi;
-	__le32			reserved;
-	__le32			flags_size;
-};
-
-struct ahci_em_priv {
-	enum sw_activity blink_policy;
-	struct timer_list timer;
-	unsigned long saved_activity;
-	unsigned long activity;
-	unsigned long led_state;
-};
-
-struct ahci_host_priv {
-	unsigned int		flags;		/* AHCI_HFLAG_* */
-	u32			cap;		/* cap to use */
-	u32			cap2;		/* cap2 to use */
-	u32			port_map;	/* port map to use */
-	u32			saved_cap;	/* saved initial cap */
-	u32			saved_cap2;	/* saved initial cap2 */
-	u32			saved_port_map;	/* saved initial port_map */
-	u32 			em_loc; /* enclosure management location */
 };
 
-struct ahci_port_priv {
-	struct ata_link		*active_link;
-	struct ahci_cmd_hdr	*cmd_slot;
-	dma_addr_t		cmd_slot_dma;
-	void			*cmd_tbl;
-	dma_addr_t		cmd_tbl_dma;
-	void			*rx_fis;
-	dma_addr_t		rx_fis_dma;
-	/* for NCQ spurious interrupt analysis */
-	unsigned int		ncq_saw_d2h:1;
-	unsigned int		ncq_saw_dmas:1;
-	unsigned int		ncq_saw_sdb:1;
-	u32 			intr_mask;	/* interrupts to enable */
-	bool			fbs_supported;	/* set iff FBS is supported */
-	bool			fbs_enabled;	/* set iff FBS is enabled */
-	int			fbs_last_dev;	/* save FBS.DEV of last FIS */
-	/* enclosure management info per PM slot */
-	struct ahci_em_priv	em_priv[EM_MAX_SLOTS];
+enum board_ids {
+	/* board IDs by feature in alphabetical order */
+	board_ahci,
+	board_ahci_ign_iferr,
+	board_ahci_nosntf,
+
+	/* board IDs for specific chipsets in alphabetical order */
+	board_ahci_mcp65,
+	board_ahci_mcp77,
+	board_ahci_mcp89,
+	board_ahci_mv,
+	board_ahci_sb600,
+	board_ahci_sb700,	/* for SB700 and SB800 */
+	board_ahci_vt8251,
+
+	/* aliases */
+	board_ahci_mcp_linux	= board_ahci_mcp65,
+	board_ahci_mcp67	= board_ahci_mcp65,
+	board_ahci_mcp73	= board_ahci_mcp65,
+	board_ahci_mcp79	= board_ahci_mcp77,
 };
 
-static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
-static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
-static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
-static int ahci_port_start(struct ata_port *ap);
-static void ahci_port_stop(struct ata_port *ap);
-static int ahci_pmp_qc_defer(struct ata_queued_cmd *qc);
-static void ahci_qc_prep(struct ata_queued_cmd *qc);
-static void ahci_freeze(struct ata_port *ap);
-static void ahci_thaw(struct ata_port *ap);
-static void ahci_enable_fbs(struct ata_port *ap);
-static void ahci_disable_fbs(struct ata_port *ap);
-static void ahci_pmp_attach(struct ata_port *ap);
-static void ahci_pmp_detach(struct ata_port *ap);
-static int ahci_softreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline);
 static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
-static int ahci_hardreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 				unsigned long deadline);
-static void ahci_postreset(struct ata_link *link, unsigned int *class);
-static void ahci_error_handler(struct ata_port *ap);
-static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
-static int ahci_port_resume(struct ata_port *ap);
-static void ahci_dev_config(struct ata_device *dev);
-static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
-			       u32 opts);
 #ifdef CONFIG_PM
-static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
 static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
-static ssize_t ahci_activity_show(struct ata_device *dev, char *buf);
-static ssize_t ahci_activity_store(struct ata_device *dev,
-				   enum sw_activity val);
-static void ahci_init_sw_activity(struct ata_link *link);
-
-static ssize_t ahci_show_host_caps(struct device *dev,
-				   struct device_attribute *attr, char *buf);
-static ssize_t ahci_show_host_cap2(struct device *dev,
-				   struct device_attribute *attr, char *buf);
-static ssize_t ahci_show_host_version(struct device *dev,
-				      struct device_attribute *attr, char *buf);
-static ssize_t ahci_show_port_cmd(struct device *dev,
-				  struct device_attribute *attr, char *buf);
-
-static DEVICE_ATTR(ahci_host_caps, S_IRUGO, ahci_show_host_caps, NULL);
-static DEVICE_ATTR(ahci_host_cap2, S_IRUGO, ahci_show_host_cap2, NULL);
-static DEVICE_ATTR(ahci_host_version, S_IRUGO, ahci_show_host_version, NULL);
-static DEVICE_ATTR(ahci_port_cmd, S_IRUGO, ahci_show_port_cmd, NULL);
-
-static struct device_attribute *ahci_shost_attrs[] = {
-	&dev_attr_link_power_management_policy,
-	&dev_attr_em_message_type,
-	&dev_attr_em_message,
-	&dev_attr_ahci_host_caps,
-	&dev_attr_ahci_host_cap2,
-	&dev_attr_ahci_host_version,
-	&dev_attr_ahci_port_cmd,
-	NULL
-};
-
-static struct device_attribute *ahci_sdev_attrs[] = {
-	&dev_attr_sw_activity,
-	&dev_attr_unload_heads,
-	NULL
-};
-
-static struct scsi_host_template ahci_sht = {
-	ATA_NCQ_SHT(DRV_NAME),
-	.can_queue		= AHCI_MAX_CMDS - 1,
-	.sg_tablesize		= AHCI_MAX_SG,
-	.dma_boundary		= AHCI_DMA_BOUNDARY,
-	.shost_attrs		= ahci_shost_attrs,
-	.sdev_attrs		= ahci_sdev_attrs,
-};
-
-static struct ata_port_operations ahci_ops = {
-	.inherits		= &sata_pmp_port_ops,
-
-	.qc_defer		= ahci_pmp_qc_defer,
-	.qc_prep		= ahci_qc_prep,
-	.qc_issue		= ahci_qc_issue,
-	.qc_fill_rtf		= ahci_qc_fill_rtf,
-
-	.freeze			= ahci_freeze,
-	.thaw			= ahci_thaw,
-	.softreset		= ahci_softreset,
-	.hardreset		= ahci_hardreset,
-	.postreset		= ahci_postreset,
-	.pmp_softreset		= ahci_softreset,
-	.error_handler		= ahci_error_handler,
-	.post_internal_cmd	= ahci_post_internal_cmd,
-	.dev_config		= ahci_dev_config,
-
-	.scr_read		= ahci_scr_read,
-	.scr_write		= ahci_scr_write,
-	.pmp_attach		= ahci_pmp_attach,
-	.pmp_detach		= ahci_pmp_detach,
-
-	.enable_pm		= ahci_enable_alpm,
-	.disable_pm		= ahci_disable_alpm,
-	.em_show		= ahci_led_show,
-	.em_store		= ahci_led_store,
-	.sw_activity_show	= ahci_activity_show,
-	.sw_activity_store	= ahci_activity_store,
-#ifdef CONFIG_PM
-	.port_suspend		= ahci_port_suspend,
-	.port_resume		= ahci_port_resume,
-#endif
-	.port_start		= ahci_port_start,
-	.port_stop		= ahci_port_stop,
-};
 
 static struct ata_port_operations ahci_vt8251_ops = {
 	.inherits		= &ahci_ops,
@@ -463,6 +108,7 @@ static struct ata_port_operations ahci_sb600_ops = {
 #define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
 
 static const struct ata_port_info ahci_port_info[] = {
+	/* by features */
 	[board_ahci] =
 	{
 		.flags		= AHCI_FLAG_COMMON,
@@ -470,81 +116,83 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	[board_ahci_vt8251] =
+	[board_ahci_ign_iferr] =
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_PMP),
+		AHCI_HFLAGS	(AHCI_HFLAG_IGN_IRQ_IF_ERR),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_vt8251_ops,
+		.port_ops	= &ahci_ops,
 	},
-	[board_ahci_ign_iferr] =
+	[board_ahci_nosntf] =
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_IGN_IRQ_IF_ERR),
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_SNTF),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	[board_ahci_sb600] =
+	/* by chipsets */
+	[board_ahci_mcp65] =
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
-				 AHCI_HFLAG_NO_MSI | AHCI_HFLAG_SECT255 |
-				 AHCI_HFLAG_32BIT_ONLY),
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_FPDMA_AA | AHCI_HFLAG_NO_PMP |
+				 AHCI_HFLAG_YES_NCQ),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_sb600_ops,
+		.port_ops	= &ahci_ops,
 	},
-	[board_ahci_mv] =
+	[board_ahci_mcp77] =
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
-				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_FPDMA_AA | AHCI_HFLAG_NO_PMP),
+		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	[board_ahci_sb700] =	/* for SB700 and SB800 */
+	[board_ahci_mcp89] =
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL),
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_FPDMA_AA),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_sb600_ops,
+		.port_ops	= &ahci_ops,
 	},
-	[board_ahci_mcp65] =
+	[board_ahci_mv] =
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
-		.flags		= AHCI_FLAG_COMMON,
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
+				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	[board_ahci_nopmp] =
+	[board_ahci_sb600] =
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP),
+		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
+				 AHCI_HFLAG_NO_MSI | AHCI_HFLAG_SECT255 |
+				 AHCI_HFLAG_32BIT_ONLY),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
+		.port_ops	= &ahci_sb600_ops,
 	},
-	[board_ahci_yesncq] =
+	[board_ahci_sb700] =	/* for SB700 and SB800 */
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
+		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
+		.port_ops	= &ahci_sb600_ops,
 	},
-	[board_ahci_nosntf] =
+	[board_ahci_vt8251] =
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_NO_SNTF),
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
+		.port_ops	= &ahci_vt8251_ops,
 	},
 };
 
@@ -629,82 +277,82 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x045d), board_ahci_mcp65 },	/* MCP65 */
 	{ PCI_VDEVICE(NVIDIA, 0x045e), board_ahci_mcp65 },	/* MCP65 */
 	{ PCI_VDEVICE(NVIDIA, 0x045f), board_ahci_mcp65 },	/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x0550), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0551), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0552), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0553), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0554), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0555), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0556), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0557), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0558), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0580), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x0581), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x0582), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x0583), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x0584), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x0585), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x0586), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x0587), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x0588), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x0589), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x058a), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x058b), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x058c), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x058d), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x058e), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x058f), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f3), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f4), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f5), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f6), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f7), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f8), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f9), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07fa), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07fb), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad0), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad1), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad2), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad3), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad4), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad5), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad6), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad7), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad8), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab4), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab5), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab6), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab7), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0abb), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0abc), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d84), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d85), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d86), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d87), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d88), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d89), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8a), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8b), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8c), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8d), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8e), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8f), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0550), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0551), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0552), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0553), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0554), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0555), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0556), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0557), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0558), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci_mcp67 },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0580), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0581), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0582), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0583), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0584), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0585), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0586), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0587), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0588), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x0589), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058a), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058b), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058c), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058d), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058e), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x058f), board_ahci_mcp_linux },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f3), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f4), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f5), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f6), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f7), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f8), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f9), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fa), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fb), board_ahci_mcp73 },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad0), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad1), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad2), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad3), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad4), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad5), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad6), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad7), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad8), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci_mcp77 },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab4), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab5), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab6), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab7), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abb), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abc), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci_mcp79 },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d84), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d85), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d86), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d87), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d88), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d89), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8a), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8b), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8c), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8d), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8e), board_ahci_mcp89 },	/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8f), board_ahci_mcp89 },	/* MCP89 */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci },		/* SiS 966 */
@@ -737,12 +385,6 @@ static struct pci_driver ahci_pci_driver = {
 #endif
 };
 
-static int ahci_em_messages = 1;
-module_param(ahci_em_messages, int, 0444);
-/* add other LED protocol types when they become supported */
-MODULE_PARM_DESC(ahci_em_messages,
-	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");
-
 #if defined(CONFIG_PATA_MARVELL) || defined(CONFIG_PATA_MARVELL_MODULE)
 static int marvell_enable;
 #else
@@ -752,166 +394,15 @@ module_param(marvell_enable, int, 0644);
 MODULE_PARM_DESC(marvell_enable, "Marvell SATA via AHCI (1 = enabled)");
 
 
-static inline int ahci_nr_ports(u32 cap)
-{
-	return (cap & 0x1f) + 1;
-}
-
-static inline void __iomem *__ahci_port_base(struct ata_host *host,
-					     unsigned int port_no)
-{
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-
-	return mmio + 0x100 + (port_no * 0x80);
-}
-
-static inline void __iomem *ahci_port_base(struct ata_port *ap)
-{
-	return __ahci_port_base(ap->host, ap->port_no);
-}
-
-static void ahci_enable_ahci(void __iomem *mmio)
-{
-	int i;
-	u32 tmp;
-
-	/* turn on AHCI_EN */
-	tmp = readl(mmio + HOST_CTL);
-	if (tmp & HOST_AHCI_EN)
-		return;
-
-	/* Some controllers need AHCI_EN to be written multiple times.
-	 * Try a few times before giving up.
-	 */
-	for (i = 0; i < 5; i++) {
-		tmp |= HOST_AHCI_EN;
-		writel(tmp, mmio + HOST_CTL);
-		tmp = readl(mmio + HOST_CTL);	/* flush && sanity check */
-		if (tmp & HOST_AHCI_EN)
-			return;
-		msleep(10);
-	}
-
-	WARN_ON(1);
-}
-
-static ssize_t ahci_show_host_caps(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct ata_port *ap = ata_shost_to_port(shost);
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-
-	return sprintf(buf, "%x\n", hpriv->cap);
-}
-
-static ssize_t ahci_show_host_cap2(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct ata_port *ap = ata_shost_to_port(shost);
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-
-	return sprintf(buf, "%x\n", hpriv->cap2);
-}
-
-static ssize_t ahci_show_host_version(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct ata_port *ap = ata_shost_to_port(shost);
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
-
-	return sprintf(buf, "%x\n", readl(mmio + HOST_VERSION));
-}
-
-static ssize_t ahci_show_port_cmd(struct device *dev,
-				  struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct ata_port *ap = ata_shost_to_port(shost);
-	void __iomem *port_mmio = ahci_port_base(ap);
-
-	return sprintf(buf, "%x\n", readl(port_mmio + PORT_CMD));
-}
-
-/**
- *	ahci_save_initial_config - Save and fixup initial config values
- *	@pdev: target PCI device
- *	@hpriv: host private area to store config values
- *
- *	Some registers containing configuration info might be setup by
- *	BIOS and might be cleared on reset.  This function saves the
- *	initial values of those registers into @hpriv such that they
- *	can be restored after controller reset.
- *
- *	If inconsistent, config values are fixed up by this function.
- *
- *	LOCKING:
- *	None.
- */
-static void ahci_save_initial_config(struct pci_dev *pdev,
-				     struct ahci_host_priv *hpriv)
+static void ahci_pci_save_initial_config(struct pci_dev *pdev,
+					 struct ahci_host_priv *hpriv)
 {
-	void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
-	u32 cap, cap2, vers, port_map;
-	int i;
-	int mv;
-
-	/* make sure AHCI mode is enabled before accessing CAP */
-	ahci_enable_ahci(mmio);
+	unsigned int force_port_map = 0;
+	unsigned int mask_port_map = 0;
 
-	/* Values prefixed with saved_ are written back to host after
-	 * reset.  Values without are used for driver operation.
-	 */
-	hpriv->saved_cap = cap = readl(mmio + HOST_CAP);
-	hpriv->saved_port_map = port_map = readl(mmio + HOST_PORTS_IMPL);
-
-	/* CAP2 register is only defined for AHCI 1.2 and later */
-	vers = readl(mmio + HOST_VERSION);
-	if ((vers >> 16) > 1 ||
-	   ((vers >> 16) == 1 && (vers & 0xFFFF) >= 0x200))
-		hpriv->saved_cap2 = cap2 = readl(mmio + HOST_CAP2);
-	else
-		hpriv->saved_cap2 = cap2 = 0;
-
-	/* some chips have errata preventing 64bit use */
-	if ((cap & HOST_CAP_64) && (hpriv->flags & AHCI_HFLAG_32BIT_ONLY)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "controller can't do 64bit DMA, forcing 32bit\n");
-		cap &= ~HOST_CAP_64;
-	}
-
-	if ((cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_NO_NCQ)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "controller can't do NCQ, turning off CAP_NCQ\n");
-		cap &= ~HOST_CAP_NCQ;
-	}
-
-	if (!(cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_YES_NCQ)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "controller can do NCQ, turning on CAP_NCQ\n");
-		cap |= HOST_CAP_NCQ;
-	}
-
-	if ((cap & HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "controller can't do PMP, turning off CAP_PMP\n");
-		cap &= ~HOST_CAP_PMP;
-	}
-
-	if ((cap & HOST_CAP_SNTF) && (hpriv->flags & AHCI_HFLAG_NO_SNTF)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "controller can't do SNTF, turning off CAP_SNTF\n");
-		cap &= ~HOST_CAP_SNTF;
-	}
-
-	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361 &&
-	    port_map != 1) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "JMB361 has only one port, port_map 0x%x -> 0x%x\n",
-			   port_map, 1);
-		port_map = 1;
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361) {
+		dev_info(&pdev->dev, "JMB361 has only one port\n");
+		force_port_map = 1;
 	}
 
 	/*
@@ -921,469 +412,25 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 	 */
 	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
 		if (pdev->device == 0x6121)
-			mv = 0x3;
+			mask_port_map = 0x3;
 		else
-			mv = 0xf;
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "MV_AHCI HACK: port_map %x -> %x\n",
-			   port_map,
-			   port_map & mv);
-		dev_printk(KERN_ERR, &pdev->dev,
+			mask_port_map = 0xf;
+		dev_info(&pdev->dev,
 			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
-
-		port_map &= mv;
 	}
 
-	/* cross check port_map and cap.n_ports */
-	if (port_map) {
-		int map_ports = 0;
-
-		for (i = 0; i < AHCI_MAX_PORTS; i++)
-			if (port_map & (1 << i))
-				map_ports++;
-
-		/* If PI has more ports than n_ports, whine, clear
-		 * port_map and let it be generated from n_ports.
-		 */
-		if (map_ports > ahci_nr_ports(cap)) {
-			dev_printk(KERN_WARNING, &pdev->dev,
-				   "implemented port map (0x%x) contains more "
-				   "ports than nr_ports (%u), using nr_ports\n",
-				   port_map, ahci_nr_ports(cap));
-			port_map = 0;
-		}
-	}
-
-	/* fabricate port_map from cap.nr_ports */
-	if (!port_map) {
-		port_map = (1 << ahci_nr_ports(cap)) - 1;
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "forcing PORTS_IMPL to 0x%x\n", port_map);
-
-		/* write the fixed up value to the PI register */
-		hpriv->saved_port_map = port_map;
-	}
-
-	/* record values to use during operation */
-	hpriv->cap = cap;
-	hpriv->cap2 = cap2;
-	hpriv->port_map = port_map;
-}
-
-/**
- *	ahci_restore_initial_config - Restore initial config
- *	@host: target ATA host
- *
- *	Restore initial config stored by ahci_save_initial_config().
- *
- *	LOCKING:
- *	None.
- */
-static void ahci_restore_initial_config(struct ata_host *host)
-{
-	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-
-	writel(hpriv->saved_cap, mmio + HOST_CAP);
-	if (hpriv->saved_cap2)
-		writel(hpriv->saved_cap2, mmio + HOST_CAP2);
-	writel(hpriv->saved_port_map, mmio + HOST_PORTS_IMPL);
-	(void) readl(mmio + HOST_PORTS_IMPL);	/* flush */
-}
-
-static unsigned ahci_scr_offset(struct ata_port *ap, unsigned int sc_reg)
-{
-	static const int offset[] = {
-		[SCR_STATUS]		= PORT_SCR_STAT,
-		[SCR_CONTROL]		= PORT_SCR_CTL,
-		[SCR_ERROR]		= PORT_SCR_ERR,
-		[SCR_ACTIVE]		= PORT_SCR_ACT,
-		[SCR_NOTIFICATION]	= PORT_SCR_NTF,
-	};
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-
-	if (sc_reg < ARRAY_SIZE(offset) &&
-	    (sc_reg != SCR_NOTIFICATION || (hpriv->cap & HOST_CAP_SNTF)))
-		return offset[sc_reg];
-	return 0;
-}
-
-static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
-{
-	void __iomem *port_mmio = ahci_port_base(link->ap);
-	int offset = ahci_scr_offset(link->ap, sc_reg);
-
-	if (offset) {
-		*val = readl(port_mmio + offset);
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
-{
-	void __iomem *port_mmio = ahci_port_base(link->ap);
-	int offset = ahci_scr_offset(link->ap, sc_reg);
-
-	if (offset) {
-		writel(val, port_mmio + offset);
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static void ahci_start_engine(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 tmp;
-
-	/* start DMA */
-	tmp = readl(port_mmio + PORT_CMD);
-	tmp |= PORT_CMD_START;
-	writel(tmp, port_mmio + PORT_CMD);
-	readl(port_mmio + PORT_CMD); /* flush */
-}
-
-static int ahci_stop_engine(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 tmp;
-
-	tmp = readl(port_mmio + PORT_CMD);
-
-	/* check if the HBA is idle */
-	if ((tmp & (PORT_CMD_START | PORT_CMD_LIST_ON)) == 0)
-		return 0;
-
-	/* setting HBA to idle */
-	tmp &= ~PORT_CMD_START;
-	writel(tmp, port_mmio + PORT_CMD);
-
-	/* wait for engine to stop. This could be as long as 500 msec */
-	tmp = ata_wait_register(port_mmio + PORT_CMD,
-				PORT_CMD_LIST_ON, PORT_CMD_LIST_ON, 1, 500);
-	if (tmp & PORT_CMD_LIST_ON)
-		return -EIO;
-
-	return 0;
-}
-
-static void ahci_start_fis_rx(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	struct ahci_port_priv *pp = ap->private_data;
-	u32 tmp;
-
-	/* set FIS registers */
-	if (hpriv->cap & HOST_CAP_64)
-		writel((pp->cmd_slot_dma >> 16) >> 16,
-		       port_mmio + PORT_LST_ADDR_HI);
-	writel(pp->cmd_slot_dma & 0xffffffff, port_mmio + PORT_LST_ADDR);
-
-	if (hpriv->cap & HOST_CAP_64)
-		writel((pp->rx_fis_dma >> 16) >> 16,
-		       port_mmio + PORT_FIS_ADDR_HI);
-	writel(pp->rx_fis_dma & 0xffffffff, port_mmio + PORT_FIS_ADDR);
-
-	/* enable FIS reception */
-	tmp = readl(port_mmio + PORT_CMD);
-	tmp |= PORT_CMD_FIS_RX;
-	writel(tmp, port_mmio + PORT_CMD);
-
-	/* flush */
-	readl(port_mmio + PORT_CMD);
+	ahci_save_initial_config(&pdev->dev, hpriv, force_port_map,
+				 mask_port_map);
 }
 
-static int ahci_stop_fis_rx(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 tmp;
-
-	/* disable FIS reception */
-	tmp = readl(port_mmio + PORT_CMD);
-	tmp &= ~PORT_CMD_FIS_RX;
-	writel(tmp, port_mmio + PORT_CMD);
-
-	/* wait for completion, spec says 500ms, give it 1000 */
-	tmp = ata_wait_register(port_mmio + PORT_CMD, PORT_CMD_FIS_ON,
-				PORT_CMD_FIS_ON, 10, 1000);
-	if (tmp & PORT_CMD_FIS_ON)
-		return -EBUSY;
-
-	return 0;
-}
-
-static void ahci_power_up(struct ata_port *ap)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 cmd;
-
-	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
-
-	/* spin up device */
-	if (hpriv->cap & HOST_CAP_SSS) {
-		cmd |= PORT_CMD_SPIN_UP;
-		writel(cmd, port_mmio + PORT_CMD);
-	}
-
-	/* wake up link */
-	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
-}
-
-static void ahci_disable_alpm(struct ata_port *ap)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 cmd;
-	struct ahci_port_priv *pp = ap->private_data;
-
-	/* IPM bits should be disabled by libata-core */
-	/* get the existing command bits */
-	cmd = readl(port_mmio + PORT_CMD);
-
-	/* disable ALPM and ASP */
-	cmd &= ~PORT_CMD_ASP;
-	cmd &= ~PORT_CMD_ALPE;
-
-	/* force the interface back to active */
-	cmd |= PORT_CMD_ICC_ACTIVE;
-
-	/* write out new cmd value */
-	writel(cmd, port_mmio + PORT_CMD);
-	cmd = readl(port_mmio + PORT_CMD);
-
-	/* wait 10ms to be sure we've come out of any low power state */
-	msleep(10);
-
-	/* clear out any PhyRdy stuff from interrupt status */
-	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
-
-	/* go ahead and clean out PhyRdy Change from Serror too */
-	ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
-
-	/*
- 	 * Clear flag to indicate that we should ignore all PhyRdy
- 	 * state changes
- 	 */
-	hpriv->flags &= ~AHCI_HFLAG_NO_HOTPLUG;
-
-	/*
- 	 * Enable interrupts on Phy Ready.
- 	 */
-	pp->intr_mask |= PORT_IRQ_PHYRDY;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-
-	/*
- 	 * don't change the link pm policy - we can be called
- 	 * just to turn of link pm temporarily
- 	 */
-}
-
-static int ahci_enable_alpm(struct ata_port *ap,
-	enum link_pm policy)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 cmd;
-	struct ahci_port_priv *pp = ap->private_data;
-	u32 asp;
-
-	/* Make sure the host is capable of link power management */
-	if (!(hpriv->cap & HOST_CAP_ALPM))
-		return -EINVAL;
-
-	switch (policy) {
-	case MAX_PERFORMANCE:
-	case NOT_AVAILABLE:
-		/*
- 		 * if we came here with NOT_AVAILABLE,
- 		 * it just means this is the first time we
- 		 * have tried to enable - default to max performance,
- 		 * and let the user go to lower power modes on request.
- 		 */
-		ahci_disable_alpm(ap);
-		return 0;
-	case MIN_POWER:
-		/* configure HBA to enter SLUMBER */
-		asp = PORT_CMD_ASP;
-		break;
-	case MEDIUM_POWER:
-		/* configure HBA to enter PARTIAL */
-		asp = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	/*
- 	 * Disable interrupts on Phy Ready. This keeps us from
- 	 * getting woken up due to spurious phy ready interrupts
-	 * TBD - Hot plug should be done via polling now, is
-	 * that even supported?
- 	 */
-	pp->intr_mask &= ~PORT_IRQ_PHYRDY;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-
-	/*
- 	 * Set a flag to indicate that we should ignore all PhyRdy
- 	 * state changes since these can happen now whenever we
- 	 * change link state
- 	 */
-	hpriv->flags |= AHCI_HFLAG_NO_HOTPLUG;
-
-	/* get the existing command bits */
-	cmd = readl(port_mmio + PORT_CMD);
-
-	/*
- 	 * Set ASP based on Policy
- 	 */
-	cmd |= asp;
-
-	/*
- 	 * Setting this bit will instruct the HBA to aggressively
- 	 * enter a lower power link state when it's appropriate and
- 	 * based on the value set above for ASP
- 	 */
-	cmd |= PORT_CMD_ALPE;
-
-	/* write out new cmd value */
-	writel(cmd, port_mmio + PORT_CMD);
-	cmd = readl(port_mmio + PORT_CMD);
-
-	/* IPM bits should be set by libata-core */
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static void ahci_power_down(struct ata_port *ap)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 cmd, scontrol;
-
-	if (!(hpriv->cap & HOST_CAP_SSS))
-		return;
-
-	/* put device into listen mode, first set PxSCTL.DET to 0 */
-	scontrol = readl(port_mmio + PORT_SCR_CTL);
-	scontrol &= ~0xf;
-	writel(scontrol, port_mmio + PORT_SCR_CTL);
-
-	/* then set PxCMD.SUD to 0 */
-	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
-	cmd &= ~PORT_CMD_SPIN_UP;
-	writel(cmd, port_mmio + PORT_CMD);
-}
-#endif
-
-static void ahci_start_port(struct ata_port *ap)
-{
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ata_link *link;
-	struct ahci_em_priv *emp;
-	ssize_t rc;
-	int i;
-
-	/* enable FIS reception */
-	ahci_start_fis_rx(ap);
-
-	/* enable DMA */
-	ahci_start_engine(ap);
-
-	/* turn on LEDs */
-	if (ap->flags & ATA_FLAG_EM) {
-		ata_for_each_link(link, ap, EDGE) {
-			emp = &pp->em_priv[link->pmp];
-
-			/* EM Transmit bit maybe busy during init */
-			for (i = 0; i < EM_MAX_RETRY; i++) {
-				rc = ahci_transmit_led_message(ap,
-							       emp->led_state,
-							       4);
-				if (rc == -EBUSY)
-					msleep(1);
-				else
-					break;
-			}
-		}
-	}
-
-	if (ap->flags & ATA_FLAG_SW_ACTIVITY)
-		ata_for_each_link(link, ap, EDGE)
-			ahci_init_sw_activity(link);
-
-}
-
-static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
-{
-	int rc;
-
-	/* disable DMA */
-	rc = ahci_stop_engine(ap);
-	if (rc) {
-		*emsg = "failed to stop engine";
-		return rc;
-	}
-
-	/* disable FIS reception */
-	rc = ahci_stop_fis_rx(ap);
-	if (rc) {
-		*emsg = "failed stop FIS RX";
-		return rc;
-	}
-
-	return 0;
-}
-
-static int ahci_reset_controller(struct ata_host *host)
+static int ahci_pci_reset_controller(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
-	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	u32 tmp;
 
-	/* we must be in AHCI mode, before using anything
-	 * AHCI-specific, such as HOST_RESET.
-	 */
-	ahci_enable_ahci(mmio);
-
-	/* global controller reset */
-	if (!ahci_skip_host_reset) {
-		tmp = readl(mmio + HOST_CTL);
-		if ((tmp & HOST_RESET) == 0) {
-			writel(tmp | HOST_RESET, mmio + HOST_CTL);
-			readl(mmio + HOST_CTL); /* flush */
-		}
-
-		/*
-		 * to perform host reset, OS should set HOST_RESET
-		 * and poll until this bit is read to be "0".
-		 * reset must complete within 1 second, or
-		 * the hardware should be considered fried.
-		 */
-		tmp = ata_wait_register(mmio + HOST_CTL, HOST_RESET,
-					HOST_RESET, 10, 1000);
-
-		if (tmp & HOST_RESET) {
-			dev_printk(KERN_ERR, host->dev,
-				   "controller reset failed (0x%x)\n", tmp);
-			return -EIO;
-		}
-
-		/* turn on AHCI mode */
-		ahci_enable_ahci(mmio);
-
-		/* Some registers might be cleared on reset.  Restore
-		 * initial values.
-		 */
-		ahci_restore_initial_config(host);
-	} else
-		dev_printk(KERN_INFO, host->dev,
-			   "skipping global host reset\n");
+	ahci_reset_controller(host);
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
+		struct ahci_host_priv *hpriv = host->private_data;
 		u16 tmp16;
 
 		/* configure PCS */
@@ -1397,267 +444,10 @@ static int ahci_reset_controller(struct ata_host *host)
 	return 0;
 }
 
-static void ahci_sw_activity(struct ata_link *link)
-{
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
-
-	if (!(link->flags & ATA_LFLAG_SW_ACTIVITY))
-		return;
-
-	emp->activity++;
-	if (!timer_pending(&emp->timer))
-		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(10));
-}
-
-static void ahci_sw_activity_blink(unsigned long arg)
-{
-	struct ata_link *link = (struct ata_link *)arg;
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
-	unsigned long led_message = emp->led_state;
-	u32 activity_led_state;
-	unsigned long flags;
-
-	led_message &= EM_MSG_LED_VALUE;
-	led_message |= ap->port_no | (link->pmp << 8);
-
-	/* check to see if we've had activity.  If so,
-	 * toggle state of LED and reset timer.  If not,
-	 * turn LED to desired idle state.
-	 */
-	spin_lock_irqsave(ap->lock, flags);
-	if (emp->saved_activity != emp->activity) {
-		emp->saved_activity = emp->activity;
-		/* get the current LED state */
-		activity_led_state = led_message & EM_MSG_LED_VALUE_ON;
-
-		if (activity_led_state)
-			activity_led_state = 0;
-		else
-			activity_led_state = 1;
-
-		/* clear old state */
-		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
-
-		/* toggle state */
-		led_message |= (activity_led_state << 16);
-		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(100));
-	} else {
-		/* switch to idle */
-		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
-		if (emp->blink_policy == BLINK_OFF)
-			led_message |= (1 << 16);
-	}
-	spin_unlock_irqrestore(ap->lock, flags);
-	ahci_transmit_led_message(ap, led_message, 4);
-}
-
-static void ahci_init_sw_activity(struct ata_link *link)
-{
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
-
-	/* init activity stats, setup timer */
-	emp->saved_activity = emp->activity = 0;
-	setup_timer(&emp->timer, ahci_sw_activity_blink, (unsigned long)link);
-
-	/* check our blink policy and set flag for link if it's enabled */
-	if (emp->blink_policy)
-		link->flags |= ATA_LFLAG_SW_ACTIVITY;
-}
-
-static int ahci_reset_em(struct ata_host *host)
-{
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	u32 em_ctl;
-
-	em_ctl = readl(mmio + HOST_EM_CTL);
-	if ((em_ctl & EM_CTL_TM) || (em_ctl & EM_CTL_RST))
-		return -EINVAL;
-
-	writel(em_ctl | EM_CTL_RST, mmio + HOST_EM_CTL);
-	return 0;
-}
-
-static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
-					ssize_t size)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	struct ahci_port_priv *pp = ap->private_data;
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
-	u32 em_ctl;
-	u32 message[] = {0, 0};
-	unsigned long flags;
-	int pmp;
-	struct ahci_em_priv *emp;
-
-	/* get the slot number from the message */
-	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
-	if (pmp < EM_MAX_SLOTS)
-		emp = &pp->em_priv[pmp];
-	else
-		return -EINVAL;
-
-	spin_lock_irqsave(ap->lock, flags);
-
-	/*
-	 * if we are still busy transmitting a previous message,
-	 * do not allow
-	 */
-	em_ctl = readl(mmio + HOST_EM_CTL);
-	if (em_ctl & EM_CTL_TM) {
-		spin_unlock_irqrestore(ap->lock, flags);
-		return -EBUSY;
-	}
-
-	/*
-	 * create message header - this is all zero except for
-	 * the message size, which is 4 bytes.
-	 */
-	message[0] |= (4 << 8);
-
-	/* ignore 0:4 of byte zero, fill in port info yourself */
-	message[1] = ((state & ~EM_MSG_LED_HBA_PORT) | ap->port_no);
-
-	/* write message to EM_LOC */
-	writel(message[0], mmio + hpriv->em_loc);
-	writel(message[1], mmio + hpriv->em_loc+4);
-
-	/* save off new led state for port/slot */
-	emp->led_state = state;
-
-	/*
-	 * tell hardware to transmit the message
-	 */
-	writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
-
-	spin_unlock_irqrestore(ap->lock, flags);
-	return size;
-}
-
-static ssize_t ahci_led_show(struct ata_port *ap, char *buf)
-{
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ata_link *link;
-	struct ahci_em_priv *emp;
-	int rc = 0;
-
-	ata_for_each_link(link, ap, EDGE) {
-		emp = &pp->em_priv[link->pmp];
-		rc += sprintf(buf, "%lx\n", emp->led_state);
-	}
-	return rc;
-}
-
-static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
-				size_t size)
-{
-	int state;
-	int pmp;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp;
-
-	state = simple_strtoul(buf, NULL, 0);
-
-	/* get the slot number from the message */
-	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
-	if (pmp < EM_MAX_SLOTS)
-		emp = &pp->em_priv[pmp];
-	else
-		return -EINVAL;
-
-	/* mask off the activity bits if we are in sw_activity
-	 * mode, user should turn off sw_activity before setting
-	 * activity led through em_message
-	 */
-	if (emp->blink_policy)
-		state &= ~EM_MSG_LED_VALUE_ACTIVITY;
-
-	return ahci_transmit_led_message(ap, state, size);
-}
-
-static ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
-{
-	struct ata_link *link = dev->link;
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
-	u32 port_led_state = emp->led_state;
-
-	/* save the desired Activity LED behavior */
-	if (val == OFF) {
-		/* clear LFLAG */
-		link->flags &= ~(ATA_LFLAG_SW_ACTIVITY);
-
-		/* set the LED to OFF */
-		port_led_state &= EM_MSG_LED_VALUE_OFF;
-		port_led_state |= (ap->port_no | (link->pmp << 8));
-		ahci_transmit_led_message(ap, port_led_state, 4);
-	} else {
-		link->flags |= ATA_LFLAG_SW_ACTIVITY;
-		if (val == BLINK_OFF) {
-			/* set LED to ON for idle */
-			port_led_state &= EM_MSG_LED_VALUE_OFF;
-			port_led_state |= (ap->port_no | (link->pmp << 8));
-			port_led_state |= EM_MSG_LED_VALUE_ON; /* check this */
-			ahci_transmit_led_message(ap, port_led_state, 4);
-		}
-	}
-	emp->blink_policy = val;
-	return 0;
-}
-
-static ssize_t ahci_activity_show(struct ata_device *dev, char *buf)
-{
-	struct ata_link *link = dev->link;
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
-
-	/* display the saved value of activity behavior for this
-	 * disk.
-	 */
-	return sprintf(buf, "%d\n", emp->blink_policy);
-}
-
-static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
-			   int port_no, void __iomem *mmio,
-			   void __iomem *port_mmio)
-{
-	const char *emsg = NULL;
-	int rc;
-	u32 tmp;
-
-	/* make sure port is not active */
-	rc = ahci_deinit_port(ap, &emsg);
-	if (rc)
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "%s (%d)\n", emsg, rc);
-
-	/* clear SError */
-	tmp = readl(port_mmio + PORT_SCR_ERR);
-	VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
-	writel(tmp, port_mmio + PORT_SCR_ERR);
-
-	/* clear port IRQ */
-	tmp = readl(port_mmio + PORT_IRQ_STAT);
-	VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
-	if (tmp)
-		writel(tmp, port_mmio + PORT_IRQ_STAT);
-
-	writel(1 << port_no, mmio + HOST_IRQ_STAT);
-}
-
-static void ahci_init_controller(struct ata_host *host)
+static void ahci_pci_init_controller(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
 	struct pci_dev *pdev = to_pci_dev(host->dev);
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	int i;
 	void __iomem *port_mmio;
 	u32 tmp;
 	int mv;
@@ -1678,220 +468,7 @@ static void ahci_init_controller(struct ata_host *host)
 			writel(tmp, port_mmio + PORT_IRQ_STAT);
 	}
 
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		port_mmio = ahci_port_base(ap);
-		if (ata_port_is_dummy(ap))
-			continue;
-
-		ahci_port_init(pdev, ap, i, mmio, port_mmio);
-	}
-
-	tmp = readl(mmio + HOST_CTL);
-	VPRINTK("HOST_CTL 0x%x\n", tmp);
-	writel(tmp | HOST_IRQ_EN, mmio + HOST_CTL);
-	tmp = readl(mmio + HOST_CTL);
-	VPRINTK("HOST_CTL 0x%x\n", tmp);
-}
-
-static void ahci_dev_config(struct ata_device *dev)
-{
-	struct ahci_host_priv *hpriv = dev->link->ap->host->private_data;
-
-	if (hpriv->flags & AHCI_HFLAG_SECT255) {
-		dev->max_sectors = 255;
-		ata_dev_printk(dev, KERN_INFO,
-			       "SB600 AHCI: limiting to 255 sectors per cmd\n");
-	}
-}
-
-static unsigned int ahci_dev_classify(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ata_taskfile tf;
-	u32 tmp;
-
-	tmp = readl(port_mmio + PORT_SIG);
-	tf.lbah		= (tmp >> 24)	& 0xff;
-	tf.lbam		= (tmp >> 16)	& 0xff;
-	tf.lbal		= (tmp >> 8)	& 0xff;
-	tf.nsect	= (tmp)		& 0xff;
-
-	return ata_dev_classify(&tf);
-}
-
-static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
-			       u32 opts)
-{
-	dma_addr_t cmd_tbl_dma;
-
-	cmd_tbl_dma = pp->cmd_tbl_dma + tag * AHCI_CMD_TBL_SZ;
-
-	pp->cmd_slot[tag].opts = cpu_to_le32(opts);
-	pp->cmd_slot[tag].status = 0;
-	pp->cmd_slot[tag].tbl_addr = cpu_to_le32(cmd_tbl_dma & 0xffffffff);
-	pp->cmd_slot[tag].tbl_addr_hi = cpu_to_le32((cmd_tbl_dma >> 16) >> 16);
-}
-
-static int ahci_kick_engine(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
-	u32 tmp;
-	int busy, rc;
-
-	/* stop engine */
-	rc = ahci_stop_engine(ap);
-	if (rc)
-		goto out_restart;
-
-	/* need to do CLO?
-	 * always do CLO if PMP is attached (AHCI-1.3 9.2)
-	 */
-	busy = status & (ATA_BUSY | ATA_DRQ);
-	if (!busy && !sata_pmp_attached(ap)) {
-		rc = 0;
-		goto out_restart;
-	}
-
-	if (!(hpriv->cap & HOST_CAP_CLO)) {
-		rc = -EOPNOTSUPP;
-		goto out_restart;
-	}
-
-	/* perform CLO */
-	tmp = readl(port_mmio + PORT_CMD);
-	tmp |= PORT_CMD_CLO;
-	writel(tmp, port_mmio + PORT_CMD);
-
-	rc = 0;
-	tmp = ata_wait_register(port_mmio + PORT_CMD,
-				PORT_CMD_CLO, PORT_CMD_CLO, 1, 500);
-	if (tmp & PORT_CMD_CLO)
-		rc = -EIO;
-
-	/* restart engine */
- out_restart:
-	ahci_start_engine(ap);
-	return rc;
-}
-
-static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
-				struct ata_taskfile *tf, int is_cmd, u16 flags,
-				unsigned long timeout_msec)
-{
-	const u32 cmd_fis_len = 5; /* five dwords */
-	struct ahci_port_priv *pp = ap->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u8 *fis = pp->cmd_tbl;
-	u32 tmp;
-
-	/* prep the command */
-	ata_tf_to_fis(tf, pmp, is_cmd, fis);
-	ahci_fill_cmd_slot(pp, 0, cmd_fis_len | flags | (pmp << 12));
-
-	/* issue & wait */
-	writel(1, port_mmio + PORT_CMD_ISSUE);
-
-	if (timeout_msec) {
-		tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1,
-					1, timeout_msec);
-		if (tmp & 0x1) {
-			ahci_kick_engine(ap);
-			return -EBUSY;
-		}
-	} else
-		readl(port_mmio + PORT_CMD_ISSUE);	/* flush */
-
-	return 0;
-}
-
-static int ahci_do_softreset(struct ata_link *link, unsigned int *class,
-			     int pmp, unsigned long deadline,
-			     int (*check_ready)(struct ata_link *link))
-{
-	struct ata_port *ap = link->ap;
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	const char *reason = NULL;
-	unsigned long now, msecs;
-	struct ata_taskfile tf;
-	int rc;
-
-	DPRINTK("ENTER\n");
-
-	/* prepare for SRST (AHCI-1.1 10.4.1) */
-	rc = ahci_kick_engine(ap);
-	if (rc && rc != -EOPNOTSUPP)
-		ata_link_printk(link, KERN_WARNING,
-				"failed to reset engine (errno=%d)\n", rc);
-
-	ata_tf_init(link->device, &tf);
-
-	/* issue the first D2H Register FIS */
-	msecs = 0;
-	now = jiffies;
-	if (time_after(now, deadline))
-		msecs = jiffies_to_msecs(deadline - now);
-
-	tf.ctl |= ATA_SRST;
-	if (ahci_exec_polled_cmd(ap, pmp, &tf, 0,
-				 AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY, msecs)) {
-		rc = -EIO;
-		reason = "1st FIS failed";
-		goto fail;
-	}
-
-	/* spec says at least 5us, but be generous and sleep for 1ms */
-	msleep(1);
-
-	/* issue the second D2H Register FIS */
-	tf.ctl &= ~ATA_SRST;
-	ahci_exec_polled_cmd(ap, pmp, &tf, 0, 0, 0);
-
-	/* wait for link to become ready */
-	rc = ata_wait_after_reset(link, deadline, check_ready);
-	if (rc == -EBUSY && hpriv->flags & AHCI_HFLAG_SRST_TOUT_IS_OFFLINE) {
-		/*
-		 * Workaround for cases where link online status can't
-		 * be trusted.  Treat device readiness timeout as link
-		 * offline.
-		 */
-		ata_link_printk(link, KERN_INFO,
-				"device not ready, treating as offline\n");
-		*class = ATA_DEV_NONE;
-	} else if (rc) {
-		/* link occupied, -ENODEV too is an error */
-		reason = "device not ready";
-		goto fail;
-	} else
-		*class = ahci_dev_classify(ap);
-
-	DPRINTK("EXIT, class=%u\n", *class);
-	return 0;
-
- fail:
-	ata_link_printk(link, KERN_ERR, "softreset failed (%s)\n", reason);
-	return rc;
-}
-
-static int ahci_check_ready(struct ata_link *link)
-{
-	void __iomem *port_mmio = ahci_port_base(link->ap);
-	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
-
-	return ata_check_ready(status);
-}
-
-static int ahci_softreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline)
-{
-	int pmp = sata_srst_pmp(link);
-
-	DPRINTK("ENTER\n");
-
-	return ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
+	ahci_init_controller(host);
 }
 
 static int ahci_sb600_check_ready(struct ata_link *link)
@@ -1943,38 +520,6 @@ static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
 	return rc;
 }
 
-static int ahci_hardreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline)
-{
-	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
-	struct ata_taskfile tf;
-	bool online;
-	int rc;
-
-	DPRINTK("ENTER\n");
-
-	ahci_stop_engine(ap);
-
-	/* clear D2H reception area to properly wait for D2H FIS */
-	ata_tf_init(link->device, &tf);
-	tf.command = 0x80;
-	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
-
-	rc = sata_link_hardreset(link, timing, deadline, &online,
-				 ahci_check_ready);
-
-	ahci_start_engine(ap);
-
-	if (online)
-		*class = ahci_dev_classify(ap);
-
-	DPRINTK("EXIT, rc=%d, class=%u\n", rc, *class);
-	return rc;
-}
-
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline)
 {
@@ -2043,605 +588,12 @@ static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 	return rc;
 }
 
-static void ahci_postreset(struct ata_link *link, unsigned int *class)
-{
-	struct ata_port *ap = link->ap;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 new_tmp, tmp;
-
-	ata_std_postreset(link, class);
-
-	/* Make sure port's ATAPI bit is set appropriately */
-	new_tmp = tmp = readl(port_mmio + PORT_CMD);
-	if (*class == ATA_DEV_ATAPI)
-		new_tmp |= PORT_CMD_ATAPI;
-	else
-		new_tmp &= ~PORT_CMD_ATAPI;
-	if (new_tmp != tmp) {
-		writel(new_tmp, port_mmio + PORT_CMD);
-		readl(port_mmio + PORT_CMD); /* flush */
-	}
-}
-
-static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
-{
-	struct scatterlist *sg;
-	struct ahci_sg *ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
-	unsigned int si;
-
-	VPRINTK("ENTER\n");
-
-	/*
-	 * Next, the S/G list.
-	 */
-	for_each_sg(qc->sg, sg, qc->n_elem, si) {
-		dma_addr_t addr = sg_dma_address(sg);
-		u32 sg_len = sg_dma_len(sg);
-
-		ahci_sg[si].addr = cpu_to_le32(addr & 0xffffffff);
-		ahci_sg[si].addr_hi = cpu_to_le32((addr >> 16) >> 16);
-		ahci_sg[si].flags_size = cpu_to_le32(sg_len - 1);
-	}
-
-	return si;
-}
-
-static int ahci_pmp_qc_defer(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-
-	if (!sata_pmp_attached(ap) || pp->fbs_enabled)
-		return ata_std_qc_defer(qc);
-	else
-		return sata_pmp_qc_defer_cmd_switch(qc);
-}
-
-static void ahci_qc_prep(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	int is_atapi = ata_is_atapi(qc->tf.protocol);
-	void *cmd_tbl;
-	u32 opts;
-	const u32 cmd_fis_len = 5; /* five dwords */
-	unsigned int n_elem;
-
-	/*
-	 * Fill in command table information.  First, the header,
-	 * a SATA Register - Host to Device command FIS.
-	 */
-	cmd_tbl = pp->cmd_tbl + qc->tag * AHCI_CMD_TBL_SZ;
-
-	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, cmd_tbl);
-	if (is_atapi) {
-		memset(cmd_tbl + AHCI_CMD_TBL_CDB, 0, 32);
-		memcpy(cmd_tbl + AHCI_CMD_TBL_CDB, qc->cdb, qc->dev->cdb_len);
-	}
-
-	n_elem = 0;
-	if (qc->flags & ATA_QCFLAG_DMAMAP)
-		n_elem = ahci_fill_sg(qc, cmd_tbl);
-
-	/*
-	 * Fill in command slot information.
-	 */
-	opts = cmd_fis_len | n_elem << 16 | (qc->dev->link->pmp << 12);
-	if (qc->tf.flags & ATA_TFLAG_WRITE)
-		opts |= AHCI_CMD_WRITE;
-	if (is_atapi)
-		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
-
-	ahci_fill_cmd_slot(pp, qc->tag, opts);
-}
-
-static void ahci_fbs_dec_intr(struct ata_port *ap)
-{
-	struct ahci_port_priv *pp = ap->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 fbs = readl(port_mmio + PORT_FBS);
-	int retries = 3;
-
-	DPRINTK("ENTER\n");
-	BUG_ON(!pp->fbs_enabled);
-
-	/* time to wait for DEC is not specified by AHCI spec,
-	 * add a retry loop for safety.
-	 */
-	writel(fbs | PORT_FBS_DEC, port_mmio + PORT_FBS);
-	fbs = readl(port_mmio + PORT_FBS);
-	while ((fbs & PORT_FBS_DEC) && retries--) {
-		udelay(1);
-		fbs = readl(port_mmio + PORT_FBS);
-	}
-
-	if (fbs & PORT_FBS_DEC)
-		dev_printk(KERN_ERR, ap->host->dev,
-			   "failed to clear device error\n");
-}
-
-static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ata_eh_info *host_ehi = &ap->link.eh_info;
-	struct ata_link *link = NULL;
-	struct ata_queued_cmd *active_qc;
-	struct ata_eh_info *active_ehi;
-	bool fbs_need_dec = false;
-	u32 serror;
-
-	/* determine active link with error */
-	if (pp->fbs_enabled) {
-		void __iomem *port_mmio = ahci_port_base(ap);
-		u32 fbs = readl(port_mmio + PORT_FBS);
-		int pmp = fbs >> PORT_FBS_DWE_OFFSET;
-
-		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links) &&
-		    ata_link_online(&ap->pmp_link[pmp])) {
-			link = &ap->pmp_link[pmp];
-			fbs_need_dec = true;
-		}
-
-	} else
-		ata_for_each_link(link, ap, EDGE)
-			if (ata_link_active(link))
-				break;
-
-	if (!link)
-		link = &ap->link;
-
-	active_qc = ata_qc_from_tag(ap, link->active_tag);
-	active_ehi = &link->eh_info;
-
-	/* record irq stat */
-	ata_ehi_clear_desc(host_ehi);
-	ata_ehi_push_desc(host_ehi, "irq_stat 0x%08x", irq_stat);
-
-	/* AHCI needs SError cleared; otherwise, it might lock up */
-	ahci_scr_read(&ap->link, SCR_ERROR, &serror);
-	ahci_scr_write(&ap->link, SCR_ERROR, serror);
-	host_ehi->serror |= serror;
-
-	/* some controllers set IRQ_IF_ERR on device errors, ignore it */
-	if (hpriv->flags & AHCI_HFLAG_IGN_IRQ_IF_ERR)
-		irq_stat &= ~PORT_IRQ_IF_ERR;
-
-	if (irq_stat & PORT_IRQ_TF_ERR) {
-		/* If qc is active, charge it; otherwise, the active
-		 * link.  There's no active qc on NCQ errors.  It will
-		 * be determined by EH by reading log page 10h.
-		 */
-		if (active_qc)
-			active_qc->err_mask |= AC_ERR_DEV;
-		else
-			active_ehi->err_mask |= AC_ERR_DEV;
-
-		if (hpriv->flags & AHCI_HFLAG_IGN_SERR_INTERNAL)
-			host_ehi->serror &= ~SERR_INTERNAL;
-	}
-
-	if (irq_stat & PORT_IRQ_UNK_FIS) {
-		u32 *unk = (u32 *)(pp->rx_fis + RX_FIS_UNK);
-
-		active_ehi->err_mask |= AC_ERR_HSM;
-		active_ehi->action |= ATA_EH_RESET;
-		ata_ehi_push_desc(active_ehi,
-				  "unknown FIS %08x %08x %08x %08x" ,
-				  unk[0], unk[1], unk[2], unk[3]);
-	}
-
-	if (sata_pmp_attached(ap) && (irq_stat & PORT_IRQ_BAD_PMP)) {
-		active_ehi->err_mask |= AC_ERR_HSM;
-		active_ehi->action |= ATA_EH_RESET;
-		ata_ehi_push_desc(active_ehi, "incorrect PMP");
-	}
-
-	if (irq_stat & (PORT_IRQ_HBUS_ERR | PORT_IRQ_HBUS_DATA_ERR)) {
-		host_ehi->err_mask |= AC_ERR_HOST_BUS;
-		host_ehi->action |= ATA_EH_RESET;
-		ata_ehi_push_desc(host_ehi, "host bus error");
-	}
-
-	if (irq_stat & PORT_IRQ_IF_ERR) {
-		if (fbs_need_dec)
-			active_ehi->err_mask |= AC_ERR_DEV;
-		else {
-			host_ehi->err_mask |= AC_ERR_ATA_BUS;
-			host_ehi->action |= ATA_EH_RESET;
-		}
-
-		ata_ehi_push_desc(host_ehi, "interface fatal error");
-	}
-
-	if (irq_stat & (PORT_IRQ_CONNECT | PORT_IRQ_PHYRDY)) {
-		ata_ehi_hotplugged(host_ehi);
-		ata_ehi_push_desc(host_ehi, "%s",
-			irq_stat & PORT_IRQ_CONNECT ?
-			"connection status changed" : "PHY RDY changed");
-	}
-
-	/* okay, let's hand over to EH */
-
-	if (irq_stat & PORT_IRQ_FREEZE)
-		ata_port_freeze(ap);
-	else if (fbs_need_dec) {
-		ata_link_abort(link);
-		ahci_fbs_dec_intr(ap);
-	} else
-		ata_port_abort(ap);
-}
-
-static void ahci_port_intr(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ata_eh_info *ehi = &ap->link.eh_info;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	int resetting = !!(ap->pflags & ATA_PFLAG_RESETTING);
-	u32 status, qc_active = 0;
-	int rc;
-
-	status = readl(port_mmio + PORT_IRQ_STAT);
-	writel(status, port_mmio + PORT_IRQ_STAT);
-
-	/* ignore BAD_PMP while resetting */
-	if (unlikely(resetting))
-		status &= ~PORT_IRQ_BAD_PMP;
-
-	/* If we are getting PhyRdy, this is
- 	 * just a power state change, we should
- 	 * clear out this, plus the PhyRdy/Comm
- 	 * Wake bits from Serror
- 	 */
-	if ((hpriv->flags & AHCI_HFLAG_NO_HOTPLUG) &&
-		(status & PORT_IRQ_PHYRDY)) {
-		status &= ~PORT_IRQ_PHYRDY;
-		ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
-	}
-
-	if (unlikely(status & PORT_IRQ_ERROR)) {
-		ahci_error_intr(ap, status);
-		return;
-	}
-
-	if (status & PORT_IRQ_SDB_FIS) {
-		/* If SNotification is available, leave notification
-		 * handling to sata_async_notification().  If not,
-		 * emulate it by snooping SDB FIS RX area.
-		 *
-		 * Snooping FIS RX area is probably cheaper than
-		 * poking SNotification but some constrollers which
-		 * implement SNotification, ICH9 for example, don't
-		 * store AN SDB FIS into receive area.
-		 */
-		if (hpriv->cap & HOST_CAP_SNTF)
-			sata_async_notification(ap);
-		else {
-			/* If the 'N' bit in word 0 of the FIS is set,
-			 * we just received asynchronous notification.
-			 * Tell libata about it.
-			 *
-			 * Lack of SNotification should not appear in
-			 * ahci 1.2, so the workaround is unnecessary
-			 * when FBS is enabled.
-			 */
-			if (pp->fbs_enabled)
-				WARN_ON_ONCE(1);
-			else {
-				const __le32 *f = pp->rx_fis + RX_FIS_SDB;
-				u32 f0 = le32_to_cpu(f[0]);
-				if (f0 & (1 << 15))
-					sata_async_notification(ap);
-			}
-		}
-	}
-
-	/* pp->active_link is not reliable once FBS is enabled, both
-	 * PORT_SCR_ACT and PORT_CMD_ISSUE should be checked because
-	 * NCQ and non-NCQ commands may be in flight at the same time.
-	 */
-	if (pp->fbs_enabled) {
-		if (ap->qc_active) {
-			qc_active = readl(port_mmio + PORT_SCR_ACT);
-			qc_active |= readl(port_mmio + PORT_CMD_ISSUE);
-		}
-	} else {
-		/* pp->active_link is valid iff any command is in flight */
-		if (ap->qc_active && pp->active_link->sactive)
-			qc_active = readl(port_mmio + PORT_SCR_ACT);
-		else
-			qc_active = readl(port_mmio + PORT_CMD_ISSUE);
-	}
-
-	rc = ata_qc_complete_multiple(ap, qc_active);
-
-	/* while resetting, invalid completions are expected */
-	if (unlikely(rc < 0 && !resetting)) {
-		ehi->err_mask |= AC_ERR_HSM;
-		ehi->action |= ATA_EH_RESET;
-		ata_port_freeze(ap);
-	}
-}
-
-static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
-{
-	struct ata_host *host = dev_instance;
-	struct ahci_host_priv *hpriv;
-	unsigned int i, handled = 0;
-	void __iomem *mmio;
-	u32 irq_stat, irq_masked;
-
-	VPRINTK("ENTER\n");
-
-	hpriv = host->private_data;
-	mmio = host->iomap[AHCI_PCI_BAR];
-
-	/* sigh.  0xffffffff is a valid return from h/w */
-	irq_stat = readl(mmio + HOST_IRQ_STAT);
-	if (!irq_stat)
-		return IRQ_NONE;
-
-	irq_masked = irq_stat & hpriv->port_map;
-
-	spin_lock(&host->lock);
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap;
-
-		if (!(irq_masked & (1 << i)))
-			continue;
-
-		ap = host->ports[i];
-		if (ap) {
-			ahci_port_intr(ap);
-			VPRINTK("port %u\n", i);
-		} else {
-			VPRINTK("port %u (no irq)\n", i);
-			if (ata_ratelimit())
-				dev_printk(KERN_WARNING, host->dev,
-					"interrupt on disabled port %u\n", i);
-		}
-
-		handled = 1;
-	}
-
-	/* HOST_IRQ_STAT behaves as level triggered latch meaning that
-	 * it should be cleared after all the port events are cleared;
-	 * otherwise, it will raise a spurious interrupt after each
-	 * valid one.  Please read section 10.6.2 of ahci 1.1 for more
-	 * information.
-	 *
-	 * Also, use the unmasked value to clear interrupt as spurious
-	 * pending event on a dummy port might cause screaming IRQ.
-	 */
-	writel(irq_stat, mmio + HOST_IRQ_STAT);
-
-	spin_unlock(&host->lock);
-
-	VPRINTK("EXIT\n");
-
-	return IRQ_RETVAL(handled);
-}
-
-static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ahci_port_priv *pp = ap->private_data;
-
-	/* Keep track of the currently active link.  It will be used
-	 * in completion path to determine whether NCQ phase is in
-	 * progress.
-	 */
-	pp->active_link = qc->dev->link;
-
-	if (qc->tf.protocol == ATA_PROT_NCQ)
-		writel(1 << qc->tag, port_mmio + PORT_SCR_ACT);
-
-	if (pp->fbs_enabled && pp->fbs_last_dev != qc->dev->link->pmp) {
-		u32 fbs = readl(port_mmio + PORT_FBS);
-		fbs &= ~(PORT_FBS_DEV_MASK | PORT_FBS_DEC);
-		fbs |= qc->dev->link->pmp << PORT_FBS_DEV_OFFSET;
-		writel(fbs, port_mmio + PORT_FBS);
-		pp->fbs_last_dev = qc->dev->link->pmp;
-	}
-
-	writel(1 << qc->tag, port_mmio + PORT_CMD_ISSUE);
-
-	ahci_sw_activity(qc->dev->link);
-
-	return 0;
-}
-
-static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
-{
-	struct ahci_port_priv *pp = qc->ap->private_data;
-	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
-
-	if (pp->fbs_enabled)
-		d2h_fis += qc->dev->link->pmp * AHCI_RX_FIS_SZ;
-
-	ata_tf_from_fis(d2h_fis, &qc->result_tf);
-	return true;
-}
-
-static void ahci_freeze(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-
-	/* turn IRQ off */
-	writel(0, port_mmio + PORT_IRQ_MASK);
-}
-
-static void ahci_thaw(struct ata_port *ap)
-{
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 tmp;
-	struct ahci_port_priv *pp = ap->private_data;
-
-	/* clear IRQ */
-	tmp = readl(port_mmio + PORT_IRQ_STAT);
-	writel(tmp, port_mmio + PORT_IRQ_STAT);
-	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
-
-	/* turn IRQ back on */
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-}
-
-static void ahci_error_handler(struct ata_port *ap)
-{
-	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
-		/* restart engine */
-		ahci_stop_engine(ap);
-		ahci_start_engine(ap);
-	}
-
-	sata_pmp_error_handler(ap);
-}
-
-static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-
-	/* make DMA engine forget about the failed command */
-	if (qc->flags & ATA_QCFLAG_FAILED)
-		ahci_kick_engine(ap);
-}
-
-static void ahci_enable_fbs(struct ata_port *ap)
-{
-	struct ahci_port_priv *pp = ap->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 fbs;
-	int rc;
-
-	if (!pp->fbs_supported)
-		return;
-
-	fbs = readl(port_mmio + PORT_FBS);
-	if (fbs & PORT_FBS_EN) {
-		pp->fbs_enabled = true;
-		pp->fbs_last_dev = -1; /* initialization */
-		return;
-	}
-
-	rc = ahci_stop_engine(ap);
-	if (rc)
-		return;
-
-	writel(fbs | PORT_FBS_EN, port_mmio + PORT_FBS);
-	fbs = readl(port_mmio + PORT_FBS);
-	if (fbs & PORT_FBS_EN) {
-		dev_printk(KERN_INFO, ap->host->dev, "FBS is enabled.\n");
-		pp->fbs_enabled = true;
-		pp->fbs_last_dev = -1; /* initialization */
-	} else
-		dev_printk(KERN_ERR, ap->host->dev, "Failed to enable FBS\n");
-
-	ahci_start_engine(ap);
-}
-
-static void ahci_disable_fbs(struct ata_port *ap)
-{
-	struct ahci_port_priv *pp = ap->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 fbs;
-	int rc;
-
-	if (!pp->fbs_supported)
-		return;
-
-	fbs = readl(port_mmio + PORT_FBS);
-	if ((fbs & PORT_FBS_EN) == 0) {
-		pp->fbs_enabled = false;
-		return;
-	}
-
-	rc = ahci_stop_engine(ap);
-	if (rc)
-		return;
-
-	writel(fbs & ~PORT_FBS_EN, port_mmio + PORT_FBS);
-	fbs = readl(port_mmio + PORT_FBS);
-	if (fbs & PORT_FBS_EN)
-		dev_printk(KERN_ERR, ap->host->dev, "Failed to disable FBS\n");
-	else {
-		dev_printk(KERN_INFO, ap->host->dev, "FBS is disabled.\n");
-		pp->fbs_enabled = false;
-	}
-
-	ahci_start_engine(ap);
-}
-
-static void ahci_pmp_attach(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ahci_port_priv *pp = ap->private_data;
-	u32 cmd;
-
-	cmd = readl(port_mmio + PORT_CMD);
-	cmd |= PORT_CMD_PMP;
-	writel(cmd, port_mmio + PORT_CMD);
-
-	ahci_enable_fbs(ap);
-
-	pp->intr_mask |= PORT_IRQ_BAD_PMP;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-}
-
-static void ahci_pmp_detach(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ahci_port_priv *pp = ap->private_data;
-	u32 cmd;
-
-	ahci_disable_fbs(ap);
-
-	cmd = readl(port_mmio + PORT_CMD);
-	cmd &= ~PORT_CMD_PMP;
-	writel(cmd, port_mmio + PORT_CMD);
-
-	pp->intr_mask &= ~PORT_IRQ_BAD_PMP;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-}
-
-static int ahci_port_resume(struct ata_port *ap)
-{
-	ahci_power_up(ap);
-	ahci_start_port(ap);
-
-	if (sata_pmp_attached(ap))
-		ahci_pmp_attach(ap);
-	else
-		ahci_pmp_detach(ap);
-
-	return 0;
-}
-
 #ifdef CONFIG_PM
-static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
-{
-	const char *emsg = NULL;
-	int rc;
-
-	rc = ahci_deinit_port(ap, &emsg);
-	if (rc == 0)
-		ahci_power_down(ap);
-	else {
-		ata_port_printk(ap, KERN_ERR, "%s (%d)\n", emsg, rc);
-		ahci_start_port(ap);
-	}
-
-	return rc;
-}
-
 static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	void __iomem *mmio = hpriv->mmio;
 	u32 ctl;
 
 	if (mesg.event & PM_EVENT_SUSPEND &&
@@ -2675,11 +627,11 @@ static int ahci_pci_device_resume(struct pci_dev *pdev)
 		return rc;
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		rc = ahci_reset_controller(host);
+		rc = ahci_pci_reset_controller(host);
 		if (rc)
 			return rc;
 
-		ahci_init_controller(host);
+		ahci_pci_init_controller(host);
 	}
 
 	ata_host_resume(host);
@@ -2688,92 +640,6 @@ static int ahci_pci_device_resume(struct pci_dev *pdev)
 }
 #endif
 
-static int ahci_port_start(struct ata_port *ap)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	struct device *dev = ap->host->dev;
-	struct ahci_port_priv *pp;
-	void *mem;
-	dma_addr_t mem_dma;
-	size_t dma_sz, rx_fis_sz;
-
-	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
-	if (!pp)
-		return -ENOMEM;
-
-	/* check FBS capability */
-	if ((hpriv->cap & HOST_CAP_FBS) && sata_pmp_supported(ap)) {
-		void __iomem *port_mmio = ahci_port_base(ap);
-		u32 cmd = readl(port_mmio + PORT_CMD);
-		if (cmd & PORT_CMD_FBSCP)
-			pp->fbs_supported = true;
-		else
-			dev_printk(KERN_WARNING, dev,
-				   "The port is not capable of FBS\n");
-	}
-
-	if (pp->fbs_supported) {
-		dma_sz = AHCI_PORT_PRIV_FBS_DMA_SZ;
-		rx_fis_sz = AHCI_RX_FIS_SZ * 16;
-	} else {
-		dma_sz = AHCI_PORT_PRIV_DMA_SZ;
-		rx_fis_sz = AHCI_RX_FIS_SZ;
-	}
-
-	mem = dmam_alloc_coherent(dev, dma_sz, &mem_dma, GFP_KERNEL);
-	if (!mem)
-		return -ENOMEM;
-	memset(mem, 0, dma_sz);
-
-	/*
-	 * First item in chunk of DMA memory: 32-slot command table,
-	 * 32 bytes each in size
-	 */
-	pp->cmd_slot = mem;
-	pp->cmd_slot_dma = mem_dma;
-
-	mem += AHCI_CMD_SLOT_SZ;
-	mem_dma += AHCI_CMD_SLOT_SZ;
-
-	/*
-	 * Second item: Received-FIS area
-	 */
-	pp->rx_fis = mem;
-	pp->rx_fis_dma = mem_dma;
-
-	mem += rx_fis_sz;
-	mem_dma += rx_fis_sz;
-
-	/*
-	 * Third item: data area for storing a single command
-	 * and its scatter-gather table
-	 */
-	pp->cmd_tbl = mem;
-	pp->cmd_tbl_dma = mem_dma;
-
-	/*
-	 * Save off initial list of interrupts to be enabled.
-	 * This could be changed later
-	 */
-	pp->intr_mask = DEF_PORT_IRQ;
-
-	ap->private_data = pp;
-
-	/* engage engines, captain */
-	return ahci_port_resume(ap);
-}
-
-static void ahci_port_stop(struct ata_port *ap)
-{
-	const char *emsg = NULL;
-	int rc;
-
-	/* de-initialize port */
-	rc = ahci_deinit_port(ap, &emsg);
-	if (rc)
-		ata_port_printk(ap, KERN_WARNING, "%s (%d)\n", emsg, rc);
-}
-
 static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
 {
 	int rc;
@@ -2806,31 +672,12 @@ static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
 	return 0;
 }
 
-static void ahci_print_info(struct ata_host *host)
+static void ahci_pci_print_info(struct ata_host *host)
 {
-	struct ahci_host_priv *hpriv = host->private_data;
 	struct pci_dev *pdev = to_pci_dev(host->dev);
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	u32 vers, cap, cap2, impl, speed;
-	const char *speed_s;
 	u16 cc;
 	const char *scc_s;
 
-	vers = readl(mmio + HOST_VERSION);
-	cap = hpriv->cap;
-	cap2 = hpriv->cap2;
-	impl = hpriv->port_map;
-
-	speed = (cap >> 20) & 0xf;
-	if (speed == 1)
-		speed_s = "1.5";
-	else if (speed == 2)
-		speed_s = "3";
-	else if (speed == 3)
-		speed_s = "6";
-	else
-		speed_s = "?";
-
 	pci_read_config_word(pdev, 0x0a, &cc);
 	if (cc == PCI_CLASS_STORAGE_IDE)
 		scc_s = "IDE";
@@ -2841,50 +688,7 @@ static void ahci_print_info(struct ata_host *host)
 	else
 		scc_s = "unknown";
 
-	dev_printk(KERN_INFO, &pdev->dev,
-		"AHCI %02x%02x.%02x%02x "
-		"%u slots %u ports %s Gbps 0x%x impl %s mode\n"
-		,
-
-		(vers >> 24) & 0xff,
-		(vers >> 16) & 0xff,
-		(vers >> 8) & 0xff,
-		vers & 0xff,
-
-		((cap >> 8) & 0x1f) + 1,
-		(cap & 0x1f) + 1,
-		speed_s,
-		impl,
-		scc_s);
-
-	dev_printk(KERN_INFO, &pdev->dev,
-		"flags: "
-		"%s%s%s%s%s%s%s"
-		"%s%s%s%s%s%s%s"
-		"%s%s%s%s%s%s\n"
-		,
-
-		cap & HOST_CAP_64 ? "64bit " : "",
-		cap & HOST_CAP_NCQ ? "ncq " : "",
-		cap & HOST_CAP_SNTF ? "sntf " : "",
-		cap & HOST_CAP_MPS ? "ilck " : "",
-		cap & HOST_CAP_SSS ? "stag " : "",
-		cap & HOST_CAP_ALPM ? "pm " : "",
-		cap & HOST_CAP_LED ? "led " : "",
-		cap & HOST_CAP_CLO ? "clo " : "",
-		cap & HOST_CAP_ONLY ? "only " : "",
-		cap & HOST_CAP_PMP ? "pmp " : "",
-		cap & HOST_CAP_FBS ? "fbs " : "",
-		cap & HOST_CAP_PIO_MULTI ? "pio " : "",
-		cap & HOST_CAP_SSC ? "slum " : "",
-		cap & HOST_CAP_PART ? "part " : "",
-		cap & HOST_CAP_CCC ? "ccc " : "",
-		cap & HOST_CAP_EMS ? "ems " : "",
-		cap & HOST_CAP_SXS ? "sxs " : "",
-		cap2 & HOST_CAP2_APST ? "apst " : "",
-		cap2 & HOST_CAP2_NVMHCI ? "nvmp " : "",
-		cap2 & HOST_CAP2_BOH ? "boh " : ""
-		);
+	ahci_print_info(host, scc_s);
 }
 
 /* On ASUS P5W DH Deluxe, the second port of PCI device 00:1f.2 is
@@ -3308,41 +1112,28 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 
+	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+
 	/* save initial config */
-	ahci_save_initial_config(pdev, hpriv);
+	ahci_pci_save_initial_config(pdev, hpriv);
 
 	/* prepare host */
 	if (hpriv->cap & HOST_CAP_NCQ) {
 		pi.flags |= ATA_FLAG_NCQ;
-		/* Auto-activate optimization is supposed to be supported on
-		   all AHCI controllers indicating NCQ support, but it seems
-		   to be broken at least on some NVIDIA MCP79 chipsets.
-		   Until we get info on which NVIDIA chipsets don't have this
-		   issue, if any, disable AA on all NVIDIA AHCIs. */
-		if (pdev->vendor != PCI_VENDOR_ID_NVIDIA)
+		/*
+		 * Auto-activate optimization is supposed to be
+		 * supported on all AHCI controllers indicating NCQ
+		 * capability, but it seems to be broken on some
+		 * chipsets including NVIDIAs.
+		 */
+		if (!(hpriv->flags & AHCI_HFLAG_NO_FPDMA_AA))
 			pi.flags |= ATA_FLAG_FPDMA_AA;
 	}
 
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;
 
-	if (ahci_em_messages && (hpriv->cap & HOST_CAP_EMS)) {
-		u8 messages;
-		void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
-		u32 em_loc = readl(mmio + HOST_EM_LOC);
-		u32 em_ctl = readl(mmio + HOST_EM_CTL);
-
-		messages = (em_ctl & EM_CTRL_MSG_TYPE) >> 16;
-
-		/* we only support LED message type right now */
-		if ((messages & 0x01) && (ahci_em_messages == 1)) {
-			/* store em_loc */
-			hpriv->em_loc = ((em_loc >> 16) * 4);
-			pi.flags |= ATA_FLAG_EM;
-			if (!(em_ctl & EM_CTL_ALHD))
-				pi.flags |= ATA_FLAG_SW_ACTIVITY;
-		}
-	}
+	ahci_set_em_messages(hpriv, &pi);
 
 	if (ahci_broken_system_poweroff(pdev)) {
 		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN;
@@ -3372,7 +1163,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
 		return -ENOMEM;
-	host->iomap = pcim_iomap_table(pdev);
 	host->private_data = hpriv;
 
 	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
@@ -3395,7 +1185,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		/* set enclosure management message type */
 		if (ap->flags & ATA_FLAG_EM)
-			ap->em_message_type = ahci_em_messages;
+			ap->em_message_type = hpriv->em_msg_type;
 
 
 		/* disabled/not-implemented port */
@@ -3414,12 +1204,12 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = ahci_reset_controller(host);
+	rc = ahci_pci_reset_controller(host);
 	if (rc)
 		return rc;
 
-	ahci_init_controller(host);
-	ahci_print_info(host);
+	ahci_pci_init_controller(host);
+	ahci_pci_print_info(host);
 
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
new file mode 100644
index 0000000..7113c57
--- /dev/null
+++ b/drivers/ata/ahci.h
@@ -0,0 +1,343 @@
+/*
+ *  ahci.h - Common AHCI SATA definitions and declarations
+ *
+ *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *    		    Please ALWAYS copy linux-ide@vger.kernel.org
+ *		    on emails.
+ *
+ *  Copyright 2004-2005 Red Hat, Inc.
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ * libata documentation is available via 'make {ps|pdf}docs',
+ * as Documentation/DocBook/libata.*
+ *
+ * AHCI hardware documentation:
+ * http://www.intel.com/technology/serialata/pdf/rev1_0.pdf
+ * http://www.intel.com/technology/serialata/pdf/rev1_1.pdf
+ *
+ */
+
+#ifndef _AHCI_H
+#define _AHCI_H
+
+#include <linux/libata.h>
+
+/* Enclosure Management Control */
+#define EM_CTRL_MSG_TYPE              0x000f0000
+
+/* Enclosure Management LED Message Type */
+#define EM_MSG_LED_HBA_PORT           0x0000000f
+#define EM_MSG_LED_PMP_SLOT           0x0000ff00
+#define EM_MSG_LED_VALUE              0xffff0000
+#define EM_MSG_LED_VALUE_ACTIVITY     0x00070000
+#define EM_MSG_LED_VALUE_OFF          0xfff80000
+#define EM_MSG_LED_VALUE_ON           0x00010000
+
+enum {
+	AHCI_MAX_PORTS		= 32,
+	AHCI_MAX_SG		= 168, /* hardware max is 64K */
+	AHCI_DMA_BOUNDARY	= 0xffffffff,
+	AHCI_MAX_CMDS		= 32,
+	AHCI_CMD_SZ		= 32,
+	AHCI_CMD_SLOT_SZ	= AHCI_MAX_CMDS * AHCI_CMD_SZ,
+	AHCI_RX_FIS_SZ		= 256,
+	AHCI_CMD_TBL_CDB	= 0x40,
+	AHCI_CMD_TBL_HDR_SZ	= 0x80,
+	AHCI_CMD_TBL_SZ		= AHCI_CMD_TBL_HDR_SZ + (AHCI_MAX_SG * 16),
+	AHCI_CMD_TBL_AR_SZ	= AHCI_CMD_TBL_SZ * AHCI_MAX_CMDS,
+	AHCI_PORT_PRIV_DMA_SZ	= AHCI_CMD_SLOT_SZ + AHCI_CMD_TBL_AR_SZ +
+				  AHCI_RX_FIS_SZ,
+	AHCI_PORT_PRIV_FBS_DMA_SZ	= AHCI_CMD_SLOT_SZ +
+					  AHCI_CMD_TBL_AR_SZ +
+					  (AHCI_RX_FIS_SZ * 16),
+	AHCI_IRQ_ON_SG		= (1 << 31),
+	AHCI_CMD_ATAPI		= (1 << 5),
+	AHCI_CMD_WRITE		= (1 << 6),
+	AHCI_CMD_PREFETCH	= (1 << 7),
+	AHCI_CMD_RESET		= (1 << 8),
+	AHCI_CMD_CLR_BUSY	= (1 << 10),
+
+	RX_FIS_D2H_REG		= 0x40,	/* offset of D2H Register FIS data */
+	RX_FIS_SDB		= 0x58, /* offset of SDB FIS data */
+	RX_FIS_UNK		= 0x60, /* offset of Unknown FIS data */
+
+	/* global controller registers */
+	HOST_CAP		= 0x00, /* host capabilities */
+	HOST_CTL		= 0x04, /* global host control */
+	HOST_IRQ_STAT		= 0x08, /* interrupt status */
+	HOST_PORTS_IMPL		= 0x0c, /* bitmap of implemented ports */
+	HOST_VERSION		= 0x10, /* AHCI spec. version compliancy */
+	HOST_EM_LOC		= 0x1c, /* Enclosure Management location */
+	HOST_EM_CTL		= 0x20, /* Enclosure Management Control */
+	HOST_CAP2		= 0x24, /* host capabilities, extended */
+
+	/* HOST_CTL bits */
+	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
+	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
+	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
+
+	/* HOST_CAP bits */
+	HOST_CAP_SXS		= (1 << 5),  /* Supports External SATA */
+	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
+	HOST_CAP_CCC		= (1 << 7),  /* Command Completion Coalescing */
+	HOST_CAP_PART		= (1 << 13), /* Partial state capable */
+	HOST_CAP_SSC		= (1 << 14), /* Slumber state capable */
+	HOST_CAP_PIO_MULTI	= (1 << 15), /* PIO multiple DRQ support */
+	HOST_CAP_FBS		= (1 << 16), /* FIS-based switching support */
+	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
+	HOST_CAP_ONLY		= (1 << 18), /* Supports AHCI mode only */
+	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
+	HOST_CAP_LED		= (1 << 25), /* Supports activity LED */
+	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
+	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
+	HOST_CAP_MPS		= (1 << 28), /* Mechanical presence switch */
+	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
+	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
+	HOST_CAP_64		= (1 << 31), /* PCI DAC (64-bit DMA) support */
+
+	/* HOST_CAP2 bits */
+	HOST_CAP2_BOH		= (1 << 0),  /* BIOS/OS handoff supported */
+	HOST_CAP2_NVMHCI	= (1 << 1),  /* NVMHCI supported */
+	HOST_CAP2_APST		= (1 << 2),  /* Automatic partial to slumber */
+
+	/* registers for each SATA port */
+	PORT_LST_ADDR		= 0x00, /* command list DMA addr */
+	PORT_LST_ADDR_HI	= 0x04, /* command list DMA addr hi */
+	PORT_FIS_ADDR		= 0x08, /* FIS rx buf addr */
+	PORT_FIS_ADDR_HI	= 0x0c, /* FIS rx buf addr hi */
+	PORT_IRQ_STAT		= 0x10, /* interrupt status */
+	PORT_IRQ_MASK		= 0x14, /* interrupt enable/disable mask */
+	PORT_CMD		= 0x18, /* port command */
+	PORT_TFDATA		= 0x20,	/* taskfile data */
+	PORT_SIG		= 0x24,	/* device TF signature */
+	PORT_CMD_ISSUE		= 0x38, /* command issue */
+	PORT_SCR_STAT		= 0x28, /* SATA phy register: SStatus */
+	PORT_SCR_CTL		= 0x2c, /* SATA phy register: SControl */
+	PORT_SCR_ERR		= 0x30, /* SATA phy register: SError */
+	PORT_SCR_ACT		= 0x34, /* SATA phy register: SActive */
+	PORT_SCR_NTF		= 0x3c, /* SATA phy register: SNotification */
+	PORT_FBS		= 0x40, /* FIS-based Switching */
+
+	/* PORT_IRQ_{STAT,MASK} bits */
+	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
+	PORT_IRQ_TF_ERR		= (1 << 30), /* task file error */
+	PORT_IRQ_HBUS_ERR	= (1 << 29), /* host bus fatal error */
+	PORT_IRQ_HBUS_DATA_ERR	= (1 << 28), /* host bus data error */
+	PORT_IRQ_IF_ERR		= (1 << 27), /* interface fatal error */
+	PORT_IRQ_IF_NONFATAL	= (1 << 26), /* interface non-fatal error */
+	PORT_IRQ_OVERFLOW	= (1 << 24), /* xfer exhausted available S/G */
+	PORT_IRQ_BAD_PMP	= (1 << 23), /* incorrect port multiplier */
+
+	PORT_IRQ_PHYRDY		= (1 << 22), /* PhyRdy changed */
+	PORT_IRQ_DEV_ILCK	= (1 << 7), /* device interlock */
+	PORT_IRQ_CONNECT	= (1 << 6), /* port connect change status */
+	PORT_IRQ_SG_DONE	= (1 << 5), /* descriptor processed */
+	PORT_IRQ_UNK_FIS	= (1 << 4), /* unknown FIS rx'd */
+	PORT_IRQ_SDB_FIS	= (1 << 3), /* Set Device Bits FIS rx'd */
+	PORT_IRQ_DMAS_FIS	= (1 << 2), /* DMA Setup FIS rx'd */
+	PORT_IRQ_PIOS_FIS	= (1 << 1), /* PIO Setup FIS rx'd */
+	PORT_IRQ_D2H_REG_FIS	= (1 << 0), /* D2H Register FIS rx'd */
+
+	PORT_IRQ_FREEZE		= PORT_IRQ_HBUS_ERR |
+				  PORT_IRQ_IF_ERR |
+				  PORT_IRQ_CONNECT |
+				  PORT_IRQ_PHYRDY |
+				  PORT_IRQ_UNK_FIS |
+				  PORT_IRQ_BAD_PMP,
+	PORT_IRQ_ERROR		= PORT_IRQ_FREEZE |
+				  PORT_IRQ_TF_ERR |
+				  PORT_IRQ_HBUS_DATA_ERR,
+	DEF_PORT_IRQ		= PORT_IRQ_ERROR | PORT_IRQ_SG_DONE |
+				  PORT_IRQ_SDB_FIS | PORT_IRQ_DMAS_FIS |
+				  PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
+
+	/* PORT_CMD bits */
+	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
+	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
+	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
+	PORT_CMD_FBSCP		= (1 << 22), /* FBS Capable Port */
+	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
+	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
+	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
+	PORT_CMD_FIS_RX		= (1 << 4), /* Enable FIS receive DMA engine */
+	PORT_CMD_CLO		= (1 << 3), /* Command list override */
+	PORT_CMD_POWER_ON	= (1 << 2), /* Power up device */
+	PORT_CMD_SPIN_UP	= (1 << 1), /* Spin up device */
+	PORT_CMD_START		= (1 << 0), /* Enable port DMA engine */
+
+	PORT_CMD_ICC_MASK	= (0xf << 28), /* i/f ICC state mask */
+	PORT_CMD_ICC_ACTIVE	= (0x1 << 28), /* Put i/f in active state */
+	PORT_CMD_ICC_PARTIAL	= (0x2 << 28), /* Put i/f in partial state */
+	PORT_CMD_ICC_SLUMBER	= (0x6 << 28), /* Put i/f in slumber state */
+
+	PORT_FBS_DWE_OFFSET	= 16, /* FBS device with error offset */
+	PORT_FBS_ADO_OFFSET	= 12, /* FBS active dev optimization offset */
+	PORT_FBS_DEV_OFFSET	= 8,  /* FBS device to issue offset */
+	PORT_FBS_DEV_MASK	= (0xf << PORT_FBS_DEV_OFFSET),  /* FBS.DEV */
+	PORT_FBS_SDE		= (1 << 2), /* FBS single device error */
+	PORT_FBS_DEC		= (1 << 1), /* FBS device error clear */
+	PORT_FBS_EN		= (1 << 0), /* Enable FBS */
+
+	/* hpriv->flags bits */
+	AHCI_HFLAG_NO_NCQ		= (1 << 0),
+	AHCI_HFLAG_IGN_IRQ_IF_ERR	= (1 << 1), /* ignore IRQ_IF_ERR */
+	AHCI_HFLAG_IGN_SERR_INTERNAL	= (1 << 2), /* ignore SERR_INTERNAL */
+	AHCI_HFLAG_32BIT_ONLY		= (1 << 3), /* force 32bit */
+	AHCI_HFLAG_MV_PATA		= (1 << 4), /* PATA port */
+	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
+	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
+	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
+	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
+	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
+	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
+	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= (1 << 11), /* treat SRST timeout as
+							link offline */
+	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
+	AHCI_HFLAG_NO_FPDMA_AA		= (1 << 13), /* no FPDMA AA */
+
+	/* ap->flags bits */
+
+	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
+					  ATA_FLAG_IPM,
+
+	ICH_MAP				= 0x90, /* ICH MAP register */
+
+	/* em constants */
+	EM_MAX_SLOTS			= 8,
+	EM_MAX_RETRY			= 5,
+
+	/* em_ctl bits */
+	EM_CTL_RST		= (1 << 9), /* Reset */
+	EM_CTL_TM		= (1 << 8), /* Transmit Message */
+	EM_CTL_MR		= (1 << 0), /* Message Recieved */
+	EM_CTL_ALHD		= (1 << 26), /* Activity LED */
+	EM_CTL_XMT		= (1 << 25), /* Transmit Only */
+	EM_CTL_SMB		= (1 << 24), /* Single Message Buffer */
+
+	/* em message type */
+	EM_MSG_TYPE_LED		= (1 << 0), /* LED */
+	EM_MSG_TYPE_SAFTE	= (1 << 1), /* SAF-TE */
+	EM_MSG_TYPE_SES2	= (1 << 2), /* SES-2 */
+	EM_MSG_TYPE_SGPIO	= (1 << 3), /* SGPIO */
+};
+
+struct ahci_cmd_hdr {
+	__le32			opts;
+	__le32			status;
+	__le32			tbl_addr;
+	__le32			tbl_addr_hi;
+	__le32			reserved[4];
+};
+
+struct ahci_sg {
+	__le32			addr;
+	__le32			addr_hi;
+	__le32			reserved;
+	__le32			flags_size;
+};
+
+struct ahci_em_priv {
+	enum sw_activity blink_policy;
+	struct timer_list timer;
+	unsigned long saved_activity;
+	unsigned long activity;
+	unsigned long led_state;
+};
+
+struct ahci_port_priv {
+	struct ata_link		*active_link;
+	struct ahci_cmd_hdr	*cmd_slot;
+	dma_addr_t		cmd_slot_dma;
+	void			*cmd_tbl;
+	dma_addr_t		cmd_tbl_dma;
+	void			*rx_fis;
+	dma_addr_t		rx_fis_dma;
+	/* for NCQ spurious interrupt analysis */
+	unsigned int		ncq_saw_d2h:1;
+	unsigned int		ncq_saw_dmas:1;
+	unsigned int		ncq_saw_sdb:1;
+	u32 			intr_mask;	/* interrupts to enable */
+	bool			fbs_supported;	/* set iff FBS is supported */
+	bool			fbs_enabled;	/* set iff FBS is enabled */
+	int			fbs_last_dev;	/* save FBS.DEV of last FIS */
+	/* enclosure management info per PM slot */
+	struct ahci_em_priv	em_priv[EM_MAX_SLOTS];
+};
+
+struct ahci_host_priv {
+	void __iomem *		mmio;		/* bus-independant mem map */
+	unsigned int		flags;		/* AHCI_HFLAG_* */
+	u32			cap;		/* cap to use */
+	u32			cap2;		/* cap2 to use */
+	u32			port_map;	/* port map to use */
+	u32			saved_cap;	/* saved initial cap */
+	u32			saved_cap2;	/* saved initial cap2 */
+	u32			saved_port_map;	/* saved initial port_map */
+	u32 			em_loc; /* enclosure management location */
+	u32			em_buf_sz;	/* EM buffer size in byte */
+	u32			em_msg_type;	/* EM message type */
+};
+
+extern int ahci_ignore_sss;
+
+extern struct scsi_host_template ahci_sht;
+extern struct ata_port_operations ahci_ops;
+
+void ahci_save_initial_config(struct device *dev,
+			      struct ahci_host_priv *hpriv,
+			      unsigned int force_port_map,
+			      unsigned int mask_port_map);
+void ahci_init_controller(struct ata_host *host);
+int ahci_reset_controller(struct ata_host *host);
+
+int ahci_do_softreset(struct ata_link *link, unsigned int *class,
+		      int pmp, unsigned long deadline,
+		      int (*check_ready)(struct ata_link *link));
+
+int ahci_stop_engine(struct ata_port *ap);
+void ahci_start_engine(struct ata_port *ap);
+int ahci_check_ready(struct ata_link *link);
+int ahci_kick_engine(struct ata_port *ap);
+void ahci_set_em_messages(struct ahci_host_priv *hpriv,
+			  struct ata_port_info *pi);
+int ahci_reset_em(struct ata_host *host);
+irqreturn_t ahci_interrupt(int irq, void *dev_instance);
+void ahci_print_info(struct ata_host *host, const char *scc_s);
+
+static inline void __iomem *__ahci_port_base(struct ata_host *host,
+					     unsigned int port_no)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+
+	return mmio + 0x100 + (port_no * 0x80);
+}
+
+static inline void __iomem *ahci_port_base(struct ata_port *ap)
+{
+	return __ahci_port_base(ap->host, ap->port_no);
+}
+
+static inline int ahci_nr_ports(u32 cap)
+{
+	return (cap & 0x1f) + 1;
+}
+
+#endif /* _AHCI_H */
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
new file mode 100644
index 0000000..5e11b16
--- /dev/null
+++ b/drivers/ata/ahci_platform.c
@@ -0,0 +1,192 @@
+/*
+ * AHCI SATA platform driver
+ *
+ * Copyright 2004-2005  Red Hat, Inc.
+ *   Jeff Garzik <jgarzik@pobox.com>
+ * Copyright 2010  MontaVista Software, LLC.
+ *   Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/gfp.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/libata.h>
+#include <linux/ahci_platform.h>
+#include "ahci.h"
+
+static int __init ahci_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ahci_platform_data *pdata = dev->platform_data;
+	struct ata_port_info pi = {
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	};
+	const struct ata_port_info *ppi[] = { &pi, NULL };
+	struct ahci_host_priv *hpriv;
+	struct ata_host *host;
+	struct resource *mem;
+	int irq;
+	int n_ports;
+	int i;
+	int rc;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(dev, "no mmio space\n");
+		return -EINVAL;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(dev, "no irq\n");
+		return -EINVAL;
+	}
+
+	if (pdata && pdata->init) {
+		rc = pdata->init(dev);
+		if (rc)
+			return rc;
+	}
+
+	if (pdata && pdata->ata_port_info)
+		pi = *pdata->ata_port_info;
+
+	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
+	if (!hpriv) {
+		rc = -ENOMEM;
+		goto err0;
+	}
+
+	hpriv->flags |= (unsigned long)pi.private_data;
+
+	hpriv->mmio = devm_ioremap(dev, mem->start, resource_size(mem));
+	if (!hpriv->mmio) {
+		dev_err(dev, "can't map %pR\n", mem);
+		rc = -ENOMEM;
+		goto err0;
+	}
+
+	ahci_save_initial_config(dev, hpriv,
+		pdata ? pdata->force_port_map : 0,
+		pdata ? pdata->mask_port_map  : 0);
+
+	/* prepare host */
+	if (hpriv->cap & HOST_CAP_NCQ)
+		pi.flags |= ATA_FLAG_NCQ;
+
+	if (hpriv->cap & HOST_CAP_PMP)
+		pi.flags |= ATA_FLAG_PMP;
+
+	ahci_set_em_messages(hpriv, &pi);
+
+	/* CAP.NP sometimes indicate the index of the last enabled
+	 * port, at other times, that of the last possible port, so
+	 * determining the maximum port number requires looking at
+	 * both CAP.NP and port_map.
+	 */
+	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
+
+	host = ata_host_alloc_pinfo(dev, ppi, n_ports);
+	if (!host) {
+		rc = -ENOMEM;
+		goto err0;
+	}
+
+	host->private_data = hpriv;
+
+	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
+		host->flags |= ATA_HOST_PARALLEL_SCAN;
+	else
+		printk(KERN_INFO "ahci: SSS flag set, parallel bus scan disabled\n");
+
+	if (pi.flags & ATA_FLAG_EM)
+		ahci_reset_em(host);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		ata_port_desc(ap, "mmio %pR", mem);
+		ata_port_desc(ap, "port 0x%x", 0x100 + ap->port_no * 0x80);
+
+		/* set initial link pm policy */
+		ap->pm_policy = NOT_AVAILABLE;
+
+		/* set enclosure management message type */
+		if (ap->flags & ATA_FLAG_EM)
+			ap->em_message_type = hpriv->em_msg_type;
+
+		/* disabled/not-implemented port */
+		if (!(hpriv->port_map & (1 << i)))
+			ap->ops = &ata_dummy_port_ops;
+	}
+
+	rc = ahci_reset_controller(host);
+	if (rc)
+		goto err0;
+
+	ahci_init_controller(host);
+	ahci_print_info(host, "platform");
+
+	rc = ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
+			       &ahci_sht);
+	if (rc)
+		goto err0;
+
+	return 0;
+err0:
+	if (pdata && pdata->exit)
+		pdata->exit(dev);
+	return rc;
+}
+
+static int __devexit ahci_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ahci_platform_data *pdata = dev->platform_data;
+	struct ata_host *host = dev_get_drvdata(dev);
+
+	ata_host_detach(host);
+
+	if (pdata && pdata->exit)
+		pdata->exit(dev);
+
+	return 0;
+}
+
+static struct platform_driver ahci_driver = {
+	.probe = ahci_probe,
+	.remove = __devexit_p(ahci_remove),
+	.driver = {
+		.name = "ahci",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init ahci_init(void)
+{
+	return platform_driver_probe(&ahci_driver, ahci_probe);
+}
+module_init(ahci_init);
+
+static void __exit ahci_exit(void)
+{
+	platform_driver_unregister(&ahci_driver);
+}
+module_exit(ahci_exit);
+
+MODULE_DESCRIPTION("AHCI SATA platform driver");
+MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ahci");
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
new file mode 100644
index 0000000..1984a6e
--- /dev/null
+++ b/drivers/ata/libahci.c
@@ -0,0 +1,2216 @@
+/*
+ *  libahci.c - Common AHCI SATA low-level routines
+ *
+ *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *    		    Please ALWAYS copy linux-ide@vger.kernel.org
+ *		    on emails.
+ *
+ *  Copyright 2004-2005 Red Hat, Inc.
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ * libata documentation is available via 'make {ps|pdf}docs',
+ * as Documentation/DocBook/libata.*
+ *
+ * AHCI hardware documentation:
+ * http://www.intel.com/technology/serialata/pdf/rev1_0.pdf
+ * http://www.intel.com/technology/serialata/pdf/rev1_1.pdf
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/gfp.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_cmnd.h>
+#include <linux/libata.h>
+#include "ahci.h"
+
+static int ahci_skip_host_reset;
+int ahci_ignore_sss;
+EXPORT_SYMBOL_GPL(ahci_ignore_sss);
+
+module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
+MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
+
+module_param_named(ignore_sss, ahci_ignore_sss, int, 0444);
+MODULE_PARM_DESC(ignore_sss, "Ignore staggered spinup flag (0=don't ignore, 1=ignore)");
+
+static int ahci_enable_alpm(struct ata_port *ap,
+		enum link_pm policy);
+static void ahci_disable_alpm(struct ata_port *ap);
+static ssize_t ahci_led_show(struct ata_port *ap, char *buf);
+static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
+			      size_t size);
+static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
+					ssize_t size);
+
+
+
+static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
+static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
+static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
+static int ahci_port_start(struct ata_port *ap);
+static void ahci_port_stop(struct ata_port *ap);
+static void ahci_qc_prep(struct ata_queued_cmd *qc);
+static int ahci_pmp_qc_defer(struct ata_queued_cmd *qc);
+static void ahci_freeze(struct ata_port *ap);
+static void ahci_thaw(struct ata_port *ap);
+static void ahci_enable_fbs(struct ata_port *ap);
+static void ahci_disable_fbs(struct ata_port *ap);
+static void ahci_pmp_attach(struct ata_port *ap);
+static void ahci_pmp_detach(struct ata_port *ap);
+static int ahci_softreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline);
+static int ahci_hardreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline);
+static void ahci_postreset(struct ata_link *link, unsigned int *class);
+static void ahci_error_handler(struct ata_port *ap);
+static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
+static int ahci_port_resume(struct ata_port *ap);
+static void ahci_dev_config(struct ata_device *dev);
+static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
+			       u32 opts);
+#ifdef CONFIG_PM
+static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
+#endif
+static ssize_t ahci_activity_show(struct ata_device *dev, char *buf);
+static ssize_t ahci_activity_store(struct ata_device *dev,
+				   enum sw_activity val);
+static void ahci_init_sw_activity(struct ata_link *link);
+
+static ssize_t ahci_show_host_caps(struct device *dev,
+				   struct device_attribute *attr, char *buf);
+static ssize_t ahci_show_host_cap2(struct device *dev,
+				   struct device_attribute *attr, char *buf);
+static ssize_t ahci_show_host_version(struct device *dev,
+				      struct device_attribute *attr, char *buf);
+static ssize_t ahci_show_port_cmd(struct device *dev,
+				  struct device_attribute *attr, char *buf);
+static ssize_t ahci_read_em_buffer(struct device *dev,
+				   struct device_attribute *attr, char *buf);
+static ssize_t ahci_store_em_buffer(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t size);
+
+static DEVICE_ATTR(ahci_host_caps, S_IRUGO, ahci_show_host_caps, NULL);
+static DEVICE_ATTR(ahci_host_cap2, S_IRUGO, ahci_show_host_cap2, NULL);
+static DEVICE_ATTR(ahci_host_version, S_IRUGO, ahci_show_host_version, NULL);
+static DEVICE_ATTR(ahci_port_cmd, S_IRUGO, ahci_show_port_cmd, NULL);
+static DEVICE_ATTR(em_buffer, S_IWUSR | S_IRUGO,
+		   ahci_read_em_buffer, ahci_store_em_buffer);
+
+static struct device_attribute *ahci_shost_attrs[] = {
+	&dev_attr_link_power_management_policy,
+	&dev_attr_em_message_type,
+	&dev_attr_em_message,
+	&dev_attr_ahci_host_caps,
+	&dev_attr_ahci_host_cap2,
+	&dev_attr_ahci_host_version,
+	&dev_attr_ahci_port_cmd,
+	&dev_attr_em_buffer,
+	NULL
+};
+
+static struct device_attribute *ahci_sdev_attrs[] = {
+	&dev_attr_sw_activity,
+	&dev_attr_unload_heads,
+	NULL
+};
+
+struct scsi_host_template ahci_sht = {
+	ATA_NCQ_SHT("ahci"),
+	.can_queue		= AHCI_MAX_CMDS - 1,
+	.sg_tablesize		= AHCI_MAX_SG,
+	.dma_boundary		= AHCI_DMA_BOUNDARY,
+	.shost_attrs		= ahci_shost_attrs,
+	.sdev_attrs		= ahci_sdev_attrs,
+};
+EXPORT_SYMBOL_GPL(ahci_sht);
+
+struct ata_port_operations ahci_ops = {
+	.inherits		= &sata_pmp_port_ops,
+
+	.qc_defer		= ahci_pmp_qc_defer,
+	.qc_prep		= ahci_qc_prep,
+	.qc_issue		= ahci_qc_issue,
+	.qc_fill_rtf		= ahci_qc_fill_rtf,
+
+	.freeze			= ahci_freeze,
+	.thaw			= ahci_thaw,
+	.softreset		= ahci_softreset,
+	.hardreset		= ahci_hardreset,
+	.postreset		= ahci_postreset,
+	.pmp_softreset		= ahci_softreset,
+	.error_handler		= ahci_error_handler,
+	.post_internal_cmd	= ahci_post_internal_cmd,
+	.dev_config		= ahci_dev_config,
+
+	.scr_read		= ahci_scr_read,
+	.scr_write		= ahci_scr_write,
+	.pmp_attach		= ahci_pmp_attach,
+	.pmp_detach		= ahci_pmp_detach,
+
+	.enable_pm		= ahci_enable_alpm,
+	.disable_pm		= ahci_disable_alpm,
+	.em_show		= ahci_led_show,
+	.em_store		= ahci_led_store,
+	.sw_activity_show	= ahci_activity_show,
+	.sw_activity_store	= ahci_activity_store,
+#ifdef CONFIG_PM
+	.port_suspend		= ahci_port_suspend,
+	.port_resume		= ahci_port_resume,
+#endif
+	.port_start		= ahci_port_start,
+	.port_stop		= ahci_port_stop,
+};
+EXPORT_SYMBOL_GPL(ahci_ops);
+
+int ahci_em_messages = 1;
+EXPORT_SYMBOL_GPL(ahci_em_messages);
+module_param(ahci_em_messages, int, 0444);
+/* add other LED protocol types when they become supported */
+MODULE_PARM_DESC(ahci_em_messages,
+	"AHCI Enclosure Management Message control (0 = off, 1 = on)");
+
+static void ahci_enable_ahci(void __iomem *mmio)
+{
+	int i;
+	u32 tmp;
+
+	/* turn on AHCI_EN */
+	tmp = readl(mmio + HOST_CTL);
+	if (tmp & HOST_AHCI_EN)
+		return;
+
+	/* Some controllers need AHCI_EN to be written multiple times.
+	 * Try a few times before giving up.
+	 */
+	for (i = 0; i < 5; i++) {
+		tmp |= HOST_AHCI_EN;
+		writel(tmp, mmio + HOST_CTL);
+		tmp = readl(mmio + HOST_CTL);	/* flush && sanity check */
+		if (tmp & HOST_AHCI_EN)
+			return;
+		msleep(10);
+	}
+
+	WARN_ON(1);
+}
+
+static ssize_t ahci_show_host_caps(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+
+	return sprintf(buf, "%x\n", hpriv->cap);
+}
+
+static ssize_t ahci_show_host_cap2(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+
+	return sprintf(buf, "%x\n", hpriv->cap2);
+}
+
+static ssize_t ahci_show_host_version(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+
+	return sprintf(buf, "%x\n", readl(mmio + HOST_VERSION));
+}
+
+static ssize_t ahci_show_port_cmd(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	void __iomem *port_mmio = ahci_port_base(ap);
+
+	return sprintf(buf, "%x\n", readl(port_mmio + PORT_CMD));
+}
+
+static ssize_t ahci_read_em_buffer(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	void __iomem *em_mmio = mmio + hpriv->em_loc;
+	u32 em_ctl, msg;
+	unsigned long flags;
+	size_t count;
+	int i;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if (!(ap->flags & ATA_FLAG_EM) || em_ctl & EM_CTL_XMT ||
+	    !(hpriv->em_msg_type & EM_MSG_TYPE_SGPIO)) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		return -EINVAL;
+	}
+
+	if (!(em_ctl & EM_CTL_MR)) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		return -EAGAIN;
+	}
+
+	if (!(em_ctl & EM_CTL_SMB))
+		em_mmio += hpriv->em_buf_sz;
+
+	count = hpriv->em_buf_sz;
+
+	/* the count should not be larger than PAGE_SIZE */
+	if (count > PAGE_SIZE) {
+		if (printk_ratelimit())
+			ata_port_printk(ap, KERN_WARNING,
+					"EM read buffer size too large: "
+					"buffer size %u, page size %lu\n",
+					hpriv->em_buf_sz, PAGE_SIZE);
+		count = PAGE_SIZE;
+	}
+
+	for (i = 0; i < count; i += 4) {
+		msg = readl(em_mmio + i);
+		buf[i] = msg & 0xff;
+		buf[i + 1] = (msg >> 8) & 0xff;
+		buf[i + 2] = (msg >> 16) & 0xff;
+		buf[i + 3] = (msg >> 24) & 0xff;
+	}
+
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return i;
+}
+
+static ssize_t ahci_store_em_buffer(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t size)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	void __iomem *em_mmio = mmio + hpriv->em_loc;
+	u32 em_ctl, msg;
+	unsigned long flags;
+	int i;
+
+	/* check size validity */
+	if (!(ap->flags & ATA_FLAG_EM) ||
+	    !(hpriv->em_msg_type & EM_MSG_TYPE_SGPIO) ||
+	    size % 4 || size > hpriv->em_buf_sz)
+		return -EINVAL;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if (em_ctl & EM_CTL_TM) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		return -EBUSY;
+	}
+
+	for (i = 0; i < size; i += 4) {
+		msg = buf[i] | buf[i + 1] << 8 |
+		      buf[i + 2] << 16 | buf[i + 3] << 24;
+		writel(msg, em_mmio + i);
+	}
+
+	writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
+
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return size;
+}
+
+/**
+ *	ahci_save_initial_config - Save and fixup initial config values
+ *	@dev: target AHCI device
+ *	@hpriv: host private area to store config values
+ *	@force_port_map: force port map to a specified value
+ *	@mask_port_map: mask out particular bits from port map
+ *
+ *	Some registers containing configuration info might be setup by
+ *	BIOS and might be cleared on reset.  This function saves the
+ *	initial values of those registers into @hpriv such that they
+ *	can be restored after controller reset.
+ *
+ *	If inconsistent, config values are fixed up by this function.
+ *
+ *	LOCKING:
+ *	None.
+ */
+void ahci_save_initial_config(struct device *dev,
+			      struct ahci_host_priv *hpriv,
+			      unsigned int force_port_map,
+			      unsigned int mask_port_map)
+{
+	void __iomem *mmio = hpriv->mmio;
+	u32 cap, cap2, vers, port_map;
+	int i;
+
+	/* make sure AHCI mode is enabled before accessing CAP */
+	ahci_enable_ahci(mmio);
+
+	/* Values prefixed with saved_ are written back to host after
+	 * reset.  Values without are used for driver operation.
+	 */
+	hpriv->saved_cap = cap = readl(mmio + HOST_CAP);
+	hpriv->saved_port_map = port_map = readl(mmio + HOST_PORTS_IMPL);
+
+	/* CAP2 register is only defined for AHCI 1.2 and later */
+	vers = readl(mmio + HOST_VERSION);
+	if ((vers >> 16) > 1 ||
+	   ((vers >> 16) == 1 && (vers & 0xFFFF) >= 0x200))
+		hpriv->saved_cap2 = cap2 = readl(mmio + HOST_CAP2);
+	else
+		hpriv->saved_cap2 = cap2 = 0;
+
+	/* some chips have errata preventing 64bit use */
+	if ((cap & HOST_CAP_64) && (hpriv->flags & AHCI_HFLAG_32BIT_ONLY)) {
+		dev_printk(KERN_INFO, dev,
+			   "controller can't do 64bit DMA, forcing 32bit\n");
+		cap &= ~HOST_CAP_64;
+	}
+
+	if ((cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_NO_NCQ)) {
+		dev_printk(KERN_INFO, dev,
+			   "controller can't do NCQ, turning off CAP_NCQ\n");
+		cap &= ~HOST_CAP_NCQ;
+	}
+
+	if (!(cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_YES_NCQ)) {
+		dev_printk(KERN_INFO, dev,
+			   "controller can do NCQ, turning on CAP_NCQ\n");
+		cap |= HOST_CAP_NCQ;
+	}
+
+	if ((cap & HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
+		dev_printk(KERN_INFO, dev,
+			   "controller can't do PMP, turning off CAP_PMP\n");
+		cap &= ~HOST_CAP_PMP;
+	}
+
+	if ((cap & HOST_CAP_SNTF) && (hpriv->flags & AHCI_HFLAG_NO_SNTF)) {
+		dev_printk(KERN_INFO, dev,
+			   "controller can't do SNTF, turning off CAP_SNTF\n");
+		cap &= ~HOST_CAP_SNTF;
+	}
+
+	if (force_port_map && port_map != force_port_map) {
+		dev_printk(KERN_INFO, dev, "forcing port_map 0x%x -> 0x%x\n",
+			   port_map, force_port_map);
+		port_map = force_port_map;
+	}
+
+	if (mask_port_map) {
+		dev_printk(KERN_ERR, dev, "masking port_map 0x%x -> 0x%x\n",
+			   port_map,
+			   port_map & mask_port_map);
+		port_map &= mask_port_map;
+	}
+
+	/* cross check port_map and cap.n_ports */
+	if (port_map) {
+		int map_ports = 0;
+
+		for (i = 0; i < AHCI_MAX_PORTS; i++)
+			if (port_map & (1 << i))
+				map_ports++;
+
+		/* If PI has more ports than n_ports, whine, clear
+		 * port_map and let it be generated from n_ports.
+		 */
+		if (map_ports > ahci_nr_ports(cap)) {
+			dev_printk(KERN_WARNING, dev,
+				   "implemented port map (0x%x) contains more "
+				   "ports than nr_ports (%u), using nr_ports\n",
+				   port_map, ahci_nr_ports(cap));
+			port_map = 0;
+		}
+	}
+
+	/* fabricate port_map from cap.nr_ports */
+	if (!port_map) {
+		port_map = (1 << ahci_nr_ports(cap)) - 1;
+		dev_printk(KERN_WARNING, dev,
+			   "forcing PORTS_IMPL to 0x%x\n", port_map);
+
+		/* write the fixed up value to the PI register */
+		hpriv->saved_port_map = port_map;
+	}
+
+	/* record values to use during operation */
+	hpriv->cap = cap;
+	hpriv->cap2 = cap2;
+	hpriv->port_map = port_map;
+}
+EXPORT_SYMBOL_GPL(ahci_save_initial_config);
+
+/**
+ *	ahci_restore_initial_config - Restore initial config
+ *	@host: target ATA host
+ *
+ *	Restore initial config stored by ahci_save_initial_config().
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void ahci_restore_initial_config(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+
+	writel(hpriv->saved_cap, mmio + HOST_CAP);
+	if (hpriv->saved_cap2)
+		writel(hpriv->saved_cap2, mmio + HOST_CAP2);
+	writel(hpriv->saved_port_map, mmio + HOST_PORTS_IMPL);
+	(void) readl(mmio + HOST_PORTS_IMPL);	/* flush */
+}
+
+static unsigned ahci_scr_offset(struct ata_port *ap, unsigned int sc_reg)
+{
+	static const int offset[] = {
+		[SCR_STATUS]		= PORT_SCR_STAT,
+		[SCR_CONTROL]		= PORT_SCR_CTL,
+		[SCR_ERROR]		= PORT_SCR_ERR,
+		[SCR_ACTIVE]		= PORT_SCR_ACT,
+		[SCR_NOTIFICATION]	= PORT_SCR_NTF,
+	};
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+
+	if (sc_reg < ARRAY_SIZE(offset) &&
+	    (sc_reg != SCR_NOTIFICATION || (hpriv->cap & HOST_CAP_SNTF)))
+		return offset[sc_reg];
+	return 0;
+}
+
+static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	int offset = ahci_scr_offset(link->ap, sc_reg);
+
+	if (offset) {
+		*val = readl(port_mmio + offset);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	int offset = ahci_scr_offset(link->ap, sc_reg);
+
+	if (offset) {
+		writel(val, port_mmio + offset);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int ahci_is_device_present(void __iomem *port_mmio)
+{
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xff;
+
+	/* Make sure PxTFD.STS.BSY and PxTFD.STS.DRQ are 0 */
+	if (status & (ATA_BUSY | ATA_DRQ))
+		return 0;
+
+	/* Make sure PxSSTS.DET is 3h */
+	status = readl(port_mmio + PORT_SCR_STAT) & 0xf;
+	if (status != 3)
+		return 0;
+	return 1;
+}
+
+void ahci_start_engine(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 tmp;
+
+	if (!ahci_is_device_present(port_mmio))
+		return;
+
+	/* start DMA */
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp |= PORT_CMD_START;
+	writel(tmp, port_mmio + PORT_CMD);
+	readl(port_mmio + PORT_CMD); /* flush */
+}
+EXPORT_SYMBOL_GPL(ahci_start_engine);
+
+int ahci_stop_engine(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 tmp;
+
+	tmp = readl(port_mmio + PORT_CMD);
+
+	/* check if the HBA is idle */
+	if ((tmp & (PORT_CMD_START | PORT_CMD_LIST_ON)) == 0)
+		return 0;
+
+	/* setting HBA to idle */
+	tmp &= ~PORT_CMD_START;
+	writel(tmp, port_mmio + PORT_CMD);
+
+	/* wait for engine to stop. This could be as long as 500 msec */
+	tmp = ata_wait_register(port_mmio + PORT_CMD,
+				PORT_CMD_LIST_ON, PORT_CMD_LIST_ON, 1, 500);
+	if (tmp & PORT_CMD_LIST_ON)
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_stop_engine);
+
+static void ahci_start_fis_rx(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 tmp;
+
+	/* set FIS registers */
+	if (hpriv->cap & HOST_CAP_64)
+		writel((pp->cmd_slot_dma >> 16) >> 16,
+		       port_mmio + PORT_LST_ADDR_HI);
+	writel(pp->cmd_slot_dma & 0xffffffff, port_mmio + PORT_LST_ADDR);
+
+	if (hpriv->cap & HOST_CAP_64)
+		writel((pp->rx_fis_dma >> 16) >> 16,
+		       port_mmio + PORT_FIS_ADDR_HI);
+	writel(pp->rx_fis_dma & 0xffffffff, port_mmio + PORT_FIS_ADDR);
+
+	/* enable FIS reception */
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp |= PORT_CMD_FIS_RX;
+	writel(tmp, port_mmio + PORT_CMD);
+
+	/* flush */
+	readl(port_mmio + PORT_CMD);
+}
+
+static int ahci_stop_fis_rx(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 tmp;
+
+	/* disable FIS reception */
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp &= ~PORT_CMD_FIS_RX;
+	writel(tmp, port_mmio + PORT_CMD);
+
+	/* wait for completion, spec says 500ms, give it 1000 */
+	tmp = ata_wait_register(port_mmio + PORT_CMD, PORT_CMD_FIS_ON,
+				PORT_CMD_FIS_ON, 10, 1000);
+	if (tmp & PORT_CMD_FIS_ON)
+		return -EBUSY;
+
+	return 0;
+}
+
+static void ahci_power_up(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+
+	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
+
+	/* spin up device */
+	if (hpriv->cap & HOST_CAP_SSS) {
+		cmd |= PORT_CMD_SPIN_UP;
+		writel(cmd, port_mmio + PORT_CMD);
+	}
+
+	/* wake up link */
+	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
+}
+
+static void ahci_disable_alpm(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/* IPM bits should be disabled by libata-core */
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* disable ALPM and ASP */
+	cmd &= ~PORT_CMD_ASP;
+	cmd &= ~PORT_CMD_ALPE;
+
+	/* force the interface back to active */
+	cmd |= PORT_CMD_ICC_ACTIVE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* wait 10ms to be sure we've come out of any low power state */
+	msleep(10);
+
+	/* clear out any PhyRdy stuff from interrupt status */
+	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
+
+	/* go ahead and clean out PhyRdy Change from Serror too */
+	ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
+
+	/*
+	 * Clear flag to indicate that we should ignore all PhyRdy
+	 * state changes
+	 */
+	hpriv->flags &= ~AHCI_HFLAG_NO_HOTPLUG;
+
+	/*
+	 * Enable interrupts on Phy Ready.
+	 */
+	pp->intr_mask |= PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+	 * don't change the link pm policy - we can be called
+	 * just to turn of link pm temporarily
+	 */
+}
+
+static int ahci_enable_alpm(struct ata_port *ap,
+	enum link_pm policy)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 asp;
+
+	/* Make sure the host is capable of link power management */
+	if (!(hpriv->cap & HOST_CAP_ALPM))
+		return -EINVAL;
+
+	switch (policy) {
+	case MAX_PERFORMANCE:
+	case NOT_AVAILABLE:
+		/*
+		 * if we came here with NOT_AVAILABLE,
+		 * it just means this is the first time we
+		 * have tried to enable - default to max performance,
+		 * and let the user go to lower power modes on request.
+		 */
+		ahci_disable_alpm(ap);
+		return 0;
+	case MIN_POWER:
+		/* configure HBA to enter SLUMBER */
+		asp = PORT_CMD_ASP;
+		break;
+	case MEDIUM_POWER:
+		/* configure HBA to enter PARTIAL */
+		asp = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Disable interrupts on Phy Ready. This keeps us from
+	 * getting woken up due to spurious phy ready interrupts
+	 * TBD - Hot plug should be done via polling now, is
+	 * that even supported?
+	 */
+	pp->intr_mask &= ~PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+	 * Set a flag to indicate that we should ignore all PhyRdy
+	 * state changes since these can happen now whenever we
+	 * change link state
+	 */
+	hpriv->flags |= AHCI_HFLAG_NO_HOTPLUG;
+
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/*
+	 * Set ASP based on Policy
+	 */
+	cmd |= asp;
+
+	/*
+	 * Setting this bit will instruct the HBA to aggressively
+	 * enter a lower power link state when it's appropriate and
+	 * based on the value set above for ASP
+	 */
+	cmd |= PORT_CMD_ALPE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* IPM bits should be set by libata-core */
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static void ahci_power_down(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd, scontrol;
+
+	if (!(hpriv->cap & HOST_CAP_SSS))
+		return;
+
+	/* put device into listen mode, first set PxSCTL.DET to 0 */
+	scontrol = readl(port_mmio + PORT_SCR_CTL);
+	scontrol &= ~0xf;
+	writel(scontrol, port_mmio + PORT_SCR_CTL);
+
+	/* then set PxCMD.SUD to 0 */
+	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
+	cmd &= ~PORT_CMD_SPIN_UP;
+	writel(cmd, port_mmio + PORT_CMD);
+}
+#endif
+
+static void ahci_start_port(struct ata_port *ap)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ata_link *link;
+	struct ahci_em_priv *emp;
+	ssize_t rc;
+	int i;
+
+	/* enable FIS reception */
+	ahci_start_fis_rx(ap);
+
+	/* enable DMA */
+	ahci_start_engine(ap);
+
+	/* turn on LEDs */
+	if (ap->flags & ATA_FLAG_EM) {
+		ata_for_each_link(link, ap, EDGE) {
+			emp = &pp->em_priv[link->pmp];
+
+			/* EM Transmit bit maybe busy during init */
+			for (i = 0; i < EM_MAX_RETRY; i++) {
+				rc = ahci_transmit_led_message(ap,
+							       emp->led_state,
+							       4);
+				if (rc == -EBUSY)
+					msleep(1);
+				else
+					break;
+			}
+		}
+	}
+
+	if (ap->flags & ATA_FLAG_SW_ACTIVITY)
+		ata_for_each_link(link, ap, EDGE)
+			ahci_init_sw_activity(link);
+
+}
+
+static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
+{
+	int rc;
+
+	/* disable DMA */
+	rc = ahci_stop_engine(ap);
+	if (rc) {
+		*emsg = "failed to stop engine";
+		return rc;
+	}
+
+	/* disable FIS reception */
+	rc = ahci_stop_fis_rx(ap);
+	if (rc) {
+		*emsg = "failed stop FIS RX";
+		return rc;
+	}
+
+	return 0;
+}
+
+int ahci_reset_controller(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 tmp;
+
+	/* we must be in AHCI mode, before using anything
+	 * AHCI-specific, such as HOST_RESET.
+	 */
+	ahci_enable_ahci(mmio);
+
+	/* global controller reset */
+	if (!ahci_skip_host_reset) {
+		tmp = readl(mmio + HOST_CTL);
+		if ((tmp & HOST_RESET) == 0) {
+			writel(tmp | HOST_RESET, mmio + HOST_CTL);
+			readl(mmio + HOST_CTL); /* flush */
+		}
+
+		/*
+		 * to perform host reset, OS should set HOST_RESET
+		 * and poll until this bit is read to be "0".
+		 * reset must complete within 1 second, or
+		 * the hardware should be considered fried.
+		 */
+		tmp = ata_wait_register(mmio + HOST_CTL, HOST_RESET,
+					HOST_RESET, 10, 1000);
+
+		if (tmp & HOST_RESET) {
+			dev_printk(KERN_ERR, host->dev,
+				   "controller reset failed (0x%x)\n", tmp);
+			return -EIO;
+		}
+
+		/* turn on AHCI mode */
+		ahci_enable_ahci(mmio);
+
+		/* Some registers might be cleared on reset.  Restore
+		 * initial values.
+		 */
+		ahci_restore_initial_config(host);
+	} else
+		dev_printk(KERN_INFO, host->dev,
+			   "skipping global host reset\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_reset_controller);
+
+static void ahci_sw_activity(struct ata_link *link)
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+
+	if (!(link->flags & ATA_LFLAG_SW_ACTIVITY))
+		return;
+
+	emp->activity++;
+	if (!timer_pending(&emp->timer))
+		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(10));
+}
+
+static void ahci_sw_activity_blink(unsigned long arg)
+{
+	struct ata_link *link = (struct ata_link *)arg;
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+	unsigned long led_message = emp->led_state;
+	u32 activity_led_state;
+	unsigned long flags;
+
+	led_message &= EM_MSG_LED_VALUE;
+	led_message |= ap->port_no | (link->pmp << 8);
+
+	/* check to see if we've had activity.  If so,
+	 * toggle state of LED and reset timer.  If not,
+	 * turn LED to desired idle state.
+	 */
+	spin_lock_irqsave(ap->lock, flags);
+	if (emp->saved_activity != emp->activity) {
+		emp->saved_activity = emp->activity;
+		/* get the current LED state */
+		activity_led_state = led_message & EM_MSG_LED_VALUE_ON;
+
+		if (activity_led_state)
+			activity_led_state = 0;
+		else
+			activity_led_state = 1;
+
+		/* clear old state */
+		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
+
+		/* toggle state */
+		led_message |= (activity_led_state << 16);
+		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(100));
+	} else {
+		/* switch to idle */
+		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
+		if (emp->blink_policy == BLINK_OFF)
+			led_message |= (1 << 16);
+	}
+	spin_unlock_irqrestore(ap->lock, flags);
+	ahci_transmit_led_message(ap, led_message, 4);
+}
+
+static void ahci_init_sw_activity(struct ata_link *link)
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+
+	/* init activity stats, setup timer */
+	emp->saved_activity = emp->activity = 0;
+	setup_timer(&emp->timer, ahci_sw_activity_blink, (unsigned long)link);
+
+	/* check our blink policy and set flag for link if it's enabled */
+	if (emp->blink_policy)
+		link->flags |= ATA_LFLAG_SW_ACTIVITY;
+}
+
+int ahci_reset_em(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 em_ctl;
+
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if ((em_ctl & EM_CTL_TM) || (em_ctl & EM_CTL_RST))
+		return -EINVAL;
+
+	writel(em_ctl | EM_CTL_RST, mmio + HOST_EM_CTL);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_reset_em);
+
+static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
+					ssize_t size)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 em_ctl;
+	u32 message[] = {0, 0};
+	unsigned long flags;
+	int pmp;
+	struct ahci_em_priv *emp;
+
+	/* get the slot number from the message */
+	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
+	if (pmp < EM_MAX_SLOTS)
+		emp = &pp->em_priv[pmp];
+	else
+		return -EINVAL;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	/*
+	 * if we are still busy transmitting a previous message,
+	 * do not allow
+	 */
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if (em_ctl & EM_CTL_TM) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		return -EBUSY;
+	}
+
+	if (hpriv->em_msg_type & EM_MSG_TYPE_LED) {
+		/*
+		 * create message header - this is all zero except for
+		 * the message size, which is 4 bytes.
+		 */
+		message[0] |= (4 << 8);
+
+		/* ignore 0:4 of byte zero, fill in port info yourself */
+		message[1] = ((state & ~EM_MSG_LED_HBA_PORT) | ap->port_no);
+
+		/* write message to EM_LOC */
+		writel(message[0], mmio + hpriv->em_loc);
+		writel(message[1], mmio + hpriv->em_loc+4);
+
+		/*
+		 * tell hardware to transmit the message
+		 */
+		writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
+	}
+
+	/* save off new led state for port/slot */
+	emp->led_state = state;
+
+	spin_unlock_irqrestore(ap->lock, flags);
+	return size;
+}
+
+static ssize_t ahci_led_show(struct ata_port *ap, char *buf)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ata_link *link;
+	struct ahci_em_priv *emp;
+	int rc = 0;
+
+	ata_for_each_link(link, ap, EDGE) {
+		emp = &pp->em_priv[link->pmp];
+		rc += sprintf(buf, "%lx\n", emp->led_state);
+	}
+	return rc;
+}
+
+static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
+				size_t size)
+{
+	int state;
+	int pmp;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp;
+
+	state = simple_strtoul(buf, NULL, 0);
+
+	/* get the slot number from the message */
+	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
+	if (pmp < EM_MAX_SLOTS)
+		emp = &pp->em_priv[pmp];
+	else
+		return -EINVAL;
+
+	/* mask off the activity bits if we are in sw_activity
+	 * mode, user should turn off sw_activity before setting
+	 * activity led through em_message
+	 */
+	if (emp->blink_policy)
+		state &= ~EM_MSG_LED_VALUE_ACTIVITY;
+
+	return ahci_transmit_led_message(ap, state, size);
+}
+
+static ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
+{
+	struct ata_link *link = dev->link;
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+	u32 port_led_state = emp->led_state;
+
+	/* save the desired Activity LED behavior */
+	if (val == OFF) {
+		/* clear LFLAG */
+		link->flags &= ~(ATA_LFLAG_SW_ACTIVITY);
+
+		/* set the LED to OFF */
+		port_led_state &= EM_MSG_LED_VALUE_OFF;
+		port_led_state |= (ap->port_no | (link->pmp << 8));
+		ahci_transmit_led_message(ap, port_led_state, 4);
+	} else {
+		link->flags |= ATA_LFLAG_SW_ACTIVITY;
+		if (val == BLINK_OFF) {
+			/* set LED to ON for idle */
+			port_led_state &= EM_MSG_LED_VALUE_OFF;
+			port_led_state |= (ap->port_no | (link->pmp << 8));
+			port_led_state |= EM_MSG_LED_VALUE_ON; /* check this */
+			ahci_transmit_led_message(ap, port_led_state, 4);
+		}
+	}
+	emp->blink_policy = val;
+	return 0;
+}
+
+static ssize_t ahci_activity_show(struct ata_device *dev, char *buf)
+{
+	struct ata_link *link = dev->link;
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+
+	/* display the saved value of activity behavior for this
+	 * disk.
+	 */
+	return sprintf(buf, "%d\n", emp->blink_policy);
+}
+
+static void ahci_port_init(struct device *dev, struct ata_port *ap,
+			   int port_no, void __iomem *mmio,
+			   void __iomem *port_mmio)
+{
+	const char *emsg = NULL;
+	int rc;
+	u32 tmp;
+
+	/* make sure port is not active */
+	rc = ahci_deinit_port(ap, &emsg);
+	if (rc)
+		dev_warn(dev, "%s (%d)\n", emsg, rc);
+
+	/* clear SError */
+	tmp = readl(port_mmio + PORT_SCR_ERR);
+	VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
+	writel(tmp, port_mmio + PORT_SCR_ERR);
+
+	/* clear port IRQ */
+	tmp = readl(port_mmio + PORT_IRQ_STAT);
+	VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
+	if (tmp)
+		writel(tmp, port_mmio + PORT_IRQ_STAT);
+
+	writel(1 << port_no, mmio + HOST_IRQ_STAT);
+}
+
+void ahci_init_controller(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	int i;
+	void __iomem *port_mmio;
+	u32 tmp;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		port_mmio = ahci_port_base(ap);
+		if (ata_port_is_dummy(ap))
+			continue;
+
+		ahci_port_init(host->dev, ap, i, mmio, port_mmio);
+	}
+
+	tmp = readl(mmio + HOST_CTL);
+	VPRINTK("HOST_CTL 0x%x\n", tmp);
+	writel(tmp | HOST_IRQ_EN, mmio + HOST_CTL);
+	tmp = readl(mmio + HOST_CTL);
+	VPRINTK("HOST_CTL 0x%x\n", tmp);
+}
+EXPORT_SYMBOL_GPL(ahci_init_controller);
+
+static void ahci_dev_config(struct ata_device *dev)
+{
+	struct ahci_host_priv *hpriv = dev->link->ap->host->private_data;
+
+	if (hpriv->flags & AHCI_HFLAG_SECT255) {
+		dev->max_sectors = 255;
+		ata_dev_printk(dev, KERN_INFO,
+			       "SB600 AHCI: limiting to 255 sectors per cmd\n");
+	}
+}
+
+static unsigned int ahci_dev_classify(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ata_taskfile tf;
+	u32 tmp;
+
+	tmp = readl(port_mmio + PORT_SIG);
+	tf.lbah		= (tmp >> 24)	& 0xff;
+	tf.lbam		= (tmp >> 16)	& 0xff;
+	tf.lbal		= (tmp >> 8)	& 0xff;
+	tf.nsect	= (tmp)		& 0xff;
+
+	return ata_dev_classify(&tf);
+}
+
+static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
+			       u32 opts)
+{
+	dma_addr_t cmd_tbl_dma;
+
+	cmd_tbl_dma = pp->cmd_tbl_dma + tag * AHCI_CMD_TBL_SZ;
+
+	pp->cmd_slot[tag].opts = cpu_to_le32(opts);
+	pp->cmd_slot[tag].status = 0;
+	pp->cmd_slot[tag].tbl_addr = cpu_to_le32(cmd_tbl_dma & 0xffffffff);
+	pp->cmd_slot[tag].tbl_addr_hi = cpu_to_le32((cmd_tbl_dma >> 16) >> 16);
+}
+
+int ahci_kick_engine(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+	u32 tmp;
+	int busy, rc;
+
+	/* stop engine */
+	rc = ahci_stop_engine(ap);
+	if (rc)
+		goto out_restart;
+
+	/* need to do CLO?
+	 * always do CLO if PMP is attached (AHCI-1.3 9.2)
+	 */
+	busy = status & (ATA_BUSY | ATA_DRQ);
+	if (!busy && !sata_pmp_attached(ap)) {
+		rc = 0;
+		goto out_restart;
+	}
+
+	if (!(hpriv->cap & HOST_CAP_CLO)) {
+		rc = -EOPNOTSUPP;
+		goto out_restart;
+	}
+
+	/* perform CLO */
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp |= PORT_CMD_CLO;
+	writel(tmp, port_mmio + PORT_CMD);
+
+	rc = 0;
+	tmp = ata_wait_register(port_mmio + PORT_CMD,
+				PORT_CMD_CLO, PORT_CMD_CLO, 1, 500);
+	if (tmp & PORT_CMD_CLO)
+		rc = -EIO;
+
+	/* restart engine */
+ out_restart:
+	ahci_start_engine(ap);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ahci_kick_engine);
+
+static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
+				struct ata_taskfile *tf, int is_cmd, u16 flags,
+				unsigned long timeout_msec)
+{
+	const u32 cmd_fis_len = 5; /* five dwords */
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u8 *fis = pp->cmd_tbl;
+	u32 tmp;
+
+	/* prep the command */
+	ata_tf_to_fis(tf, pmp, is_cmd, fis);
+	ahci_fill_cmd_slot(pp, 0, cmd_fis_len | flags | (pmp << 12));
+
+	/* issue & wait */
+	writel(1, port_mmio + PORT_CMD_ISSUE);
+
+	if (timeout_msec) {
+		tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1,
+					1, timeout_msec);
+		if (tmp & 0x1) {
+			ahci_kick_engine(ap);
+			return -EBUSY;
+		}
+	} else
+		readl(port_mmio + PORT_CMD_ISSUE);	/* flush */
+
+	return 0;
+}
+
+int ahci_do_softreset(struct ata_link *link, unsigned int *class,
+		      int pmp, unsigned long deadline,
+		      int (*check_ready)(struct ata_link *link))
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	const char *reason = NULL;
+	unsigned long now, msecs;
+	struct ata_taskfile tf;
+	int rc;
+
+	DPRINTK("ENTER\n");
+
+	/* prepare for SRST (AHCI-1.1 10.4.1) */
+	rc = ahci_kick_engine(ap);
+	if (rc && rc != -EOPNOTSUPP)
+		ata_link_printk(link, KERN_WARNING,
+				"failed to reset engine (errno=%d)\n", rc);
+
+	ata_tf_init(link->device, &tf);
+
+	/* issue the first D2H Register FIS */
+	msecs = 0;
+	now = jiffies;
+	if (time_after(now, deadline))
+		msecs = jiffies_to_msecs(deadline - now);
+
+	tf.ctl |= ATA_SRST;
+	if (ahci_exec_polled_cmd(ap, pmp, &tf, 0,
+				 AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY, msecs)) {
+		rc = -EIO;
+		reason = "1st FIS failed";
+		goto fail;
+	}
+
+	/* spec says at least 5us, but be generous and sleep for 1ms */
+	msleep(1);
+
+	/* issue the second D2H Register FIS */
+	tf.ctl &= ~ATA_SRST;
+	ahci_exec_polled_cmd(ap, pmp, &tf, 0, 0, 0);
+
+	/* wait for link to become ready */
+	rc = ata_wait_after_reset(link, deadline, check_ready);
+	if (rc == -EBUSY && hpriv->flags & AHCI_HFLAG_SRST_TOUT_IS_OFFLINE) {
+		/*
+		 * Workaround for cases where link online status can't
+		 * be trusted.  Treat device readiness timeout as link
+		 * offline.
+		 */
+		ata_link_printk(link, KERN_INFO,
+				"device not ready, treating as offline\n");
+		*class = ATA_DEV_NONE;
+	} else if (rc) {
+		/* link occupied, -ENODEV too is an error */
+		reason = "device not ready";
+		goto fail;
+	} else
+		*class = ahci_dev_classify(ap);
+
+	DPRINTK("EXIT, class=%u\n", *class);
+	return 0;
+
+ fail:
+	ata_link_printk(link, KERN_ERR, "softreset failed (%s)\n", reason);
+	return rc;
+}
+
+int ahci_check_ready(struct ata_link *link)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+
+	return ata_check_ready(status);
+}
+EXPORT_SYMBOL_GPL(ahci_check_ready);
+
+static int ahci_softreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline)
+{
+	int pmp = sata_srst_pmp(link);
+
+	DPRINTK("ENTER\n");
+
+	return ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
+}
+EXPORT_SYMBOL_GPL(ahci_do_softreset);
+
+static int ahci_hardreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline)
+{
+	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	struct ata_taskfile tf;
+	bool online;
+	int rc;
+
+	DPRINTK("ENTER\n");
+
+	ahci_stop_engine(ap);
+
+	/* clear D2H reception area to properly wait for D2H FIS */
+	ata_tf_init(link->device, &tf);
+	tf.command = 0x80;
+	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
+
+	rc = sata_link_hardreset(link, timing, deadline, &online,
+				 ahci_check_ready);
+
+	ahci_start_engine(ap);
+
+	if (online)
+		*class = ahci_dev_classify(ap);
+
+	DPRINTK("EXIT, rc=%d, class=%u\n", rc, *class);
+	return rc;
+}
+
+static void ahci_postreset(struct ata_link *link, unsigned int *class)
+{
+	struct ata_port *ap = link->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 new_tmp, tmp;
+
+	ata_std_postreset(link, class);
+
+	/* Make sure port's ATAPI bit is set appropriately */
+	new_tmp = tmp = readl(port_mmio + PORT_CMD);
+	if (*class == ATA_DEV_ATAPI)
+		new_tmp |= PORT_CMD_ATAPI;
+	else
+		new_tmp &= ~PORT_CMD_ATAPI;
+	if (new_tmp != tmp) {
+		writel(new_tmp, port_mmio + PORT_CMD);
+		readl(port_mmio + PORT_CMD); /* flush */
+	}
+}
+
+static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
+{
+	struct scatterlist *sg;
+	struct ahci_sg *ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
+	unsigned int si;
+
+	VPRINTK("ENTER\n");
+
+	/*
+	 * Next, the S/G list.
+	 */
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		dma_addr_t addr = sg_dma_address(sg);
+		u32 sg_len = sg_dma_len(sg);
+
+		ahci_sg[si].addr = cpu_to_le32(addr & 0xffffffff);
+		ahci_sg[si].addr_hi = cpu_to_le32((addr >> 16) >> 16);
+		ahci_sg[si].flags_size = cpu_to_le32(sg_len - 1);
+	}
+
+	return si;
+}
+
+static int ahci_pmp_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+
+	if (!sata_pmp_attached(ap) || pp->fbs_enabled)
+		return ata_std_qc_defer(qc);
+	else
+		return sata_pmp_qc_defer_cmd_switch(qc);
+}
+
+static void ahci_qc_prep(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	int is_atapi = ata_is_atapi(qc->tf.protocol);
+	void *cmd_tbl;
+	u32 opts;
+	const u32 cmd_fis_len = 5; /* five dwords */
+	unsigned int n_elem;
+
+	/*
+	 * Fill in command table information.  First, the header,
+	 * a SATA Register - Host to Device command FIS.
+	 */
+	cmd_tbl = pp->cmd_tbl + qc->tag * AHCI_CMD_TBL_SZ;
+
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, cmd_tbl);
+	if (is_atapi) {
+		memset(cmd_tbl + AHCI_CMD_TBL_CDB, 0, 32);
+		memcpy(cmd_tbl + AHCI_CMD_TBL_CDB, qc->cdb, qc->dev->cdb_len);
+	}
+
+	n_elem = 0;
+	if (qc->flags & ATA_QCFLAG_DMAMAP)
+		n_elem = ahci_fill_sg(qc, cmd_tbl);
+
+	/*
+	 * Fill in command slot information.
+	 */
+	opts = cmd_fis_len | n_elem << 16 | (qc->dev->link->pmp << 12);
+	if (qc->tf.flags & ATA_TFLAG_WRITE)
+		opts |= AHCI_CMD_WRITE;
+	if (is_atapi)
+		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
+
+	ahci_fill_cmd_slot(pp, qc->tag, opts);
+}
+
+static void ahci_fbs_dec_intr(struct ata_port *ap)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 fbs = readl(port_mmio + PORT_FBS);
+	int retries = 3;
+
+	DPRINTK("ENTER\n");
+	BUG_ON(!pp->fbs_enabled);
+
+	/* time to wait for DEC is not specified by AHCI spec,
+	 * add a retry loop for safety.
+	 */
+	writel(fbs | PORT_FBS_DEC, port_mmio + PORT_FBS);
+	fbs = readl(port_mmio + PORT_FBS);
+	while ((fbs & PORT_FBS_DEC) && retries--) {
+		udelay(1);
+		fbs = readl(port_mmio + PORT_FBS);
+	}
+
+	if (fbs & PORT_FBS_DEC)
+		dev_printk(KERN_ERR, ap->host->dev,
+			   "failed to clear device error\n");
+}
+
+static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ata_eh_info *host_ehi = &ap->link.eh_info;
+	struct ata_link *link = NULL;
+	struct ata_queued_cmd *active_qc;
+	struct ata_eh_info *active_ehi;
+	bool fbs_need_dec = false;
+	u32 serror;
+
+	/* determine active link with error */
+	if (pp->fbs_enabled) {
+		void __iomem *port_mmio = ahci_port_base(ap);
+		u32 fbs = readl(port_mmio + PORT_FBS);
+		int pmp = fbs >> PORT_FBS_DWE_OFFSET;
+
+		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links) &&
+		    ata_link_online(&ap->pmp_link[pmp])) {
+			link = &ap->pmp_link[pmp];
+			fbs_need_dec = true;
+		}
+
+	} else
+		ata_for_each_link(link, ap, EDGE)
+			if (ata_link_active(link))
+				break;
+
+	if (!link)
+		link = &ap->link;
+
+	active_qc = ata_qc_from_tag(ap, link->active_tag);
+	active_ehi = &link->eh_info;
+
+	/* record irq stat */
+	ata_ehi_clear_desc(host_ehi);
+	ata_ehi_push_desc(host_ehi, "irq_stat 0x%08x", irq_stat);
+
+	/* AHCI needs SError cleared; otherwise, it might lock up */
+	ahci_scr_read(&ap->link, SCR_ERROR, &serror);
+	ahci_scr_write(&ap->link, SCR_ERROR, serror);
+	host_ehi->serror |= serror;
+
+	/* some controllers set IRQ_IF_ERR on device errors, ignore it */
+	if (hpriv->flags & AHCI_HFLAG_IGN_IRQ_IF_ERR)
+		irq_stat &= ~PORT_IRQ_IF_ERR;
+
+	if (irq_stat & PORT_IRQ_TF_ERR) {
+		/* If qc is active, charge it; otherwise, the active
+		 * link.  There's no active qc on NCQ errors.  It will
+		 * be determined by EH by reading log page 10h.
+		 */
+		if (active_qc)
+			active_qc->err_mask |= AC_ERR_DEV;
+		else
+			active_ehi->err_mask |= AC_ERR_DEV;
+
+		if (hpriv->flags & AHCI_HFLAG_IGN_SERR_INTERNAL)
+			host_ehi->serror &= ~SERR_INTERNAL;
+	}
+
+	if (irq_stat & PORT_IRQ_UNK_FIS) {
+		u32 *unk = (u32 *)(pp->rx_fis + RX_FIS_UNK);
+
+		active_ehi->err_mask |= AC_ERR_HSM;
+		active_ehi->action |= ATA_EH_RESET;
+		ata_ehi_push_desc(active_ehi,
+				  "unknown FIS %08x %08x %08x %08x" ,
+				  unk[0], unk[1], unk[2], unk[3]);
+	}
+
+	if (sata_pmp_attached(ap) && (irq_stat & PORT_IRQ_BAD_PMP)) {
+		active_ehi->err_mask |= AC_ERR_HSM;
+		active_ehi->action |= ATA_EH_RESET;
+		ata_ehi_push_desc(active_ehi, "incorrect PMP");
+	}
+
+	if (irq_stat & (PORT_IRQ_HBUS_ERR | PORT_IRQ_HBUS_DATA_ERR)) {
+		host_ehi->err_mask |= AC_ERR_HOST_BUS;
+		host_ehi->action |= ATA_EH_RESET;
+		ata_ehi_push_desc(host_ehi, "host bus error");
+	}
+
+	if (irq_stat & PORT_IRQ_IF_ERR) {
+		if (fbs_need_dec)
+			active_ehi->err_mask |= AC_ERR_DEV;
+		else {
+			host_ehi->err_mask |= AC_ERR_ATA_BUS;
+			host_ehi->action |= ATA_EH_RESET;
+		}
+
+		ata_ehi_push_desc(host_ehi, "interface fatal error");
+	}
+
+	if (irq_stat & (PORT_IRQ_CONNECT | PORT_IRQ_PHYRDY)) {
+		ata_ehi_hotplugged(host_ehi);
+		ata_ehi_push_desc(host_ehi, "%s",
+			irq_stat & PORT_IRQ_CONNECT ?
+			"connection status changed" : "PHY RDY changed");
+	}
+
+	/* okay, let's hand over to EH */
+
+	if (irq_stat & PORT_IRQ_FREEZE)
+		ata_port_freeze(ap);
+	else if (fbs_need_dec) {
+		ata_link_abort(link);
+		ahci_fbs_dec_intr(ap);
+	} else
+		ata_port_abort(ap);
+}
+
+static void ahci_port_intr(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	int resetting = !!(ap->pflags & ATA_PFLAG_RESETTING);
+	u32 status, qc_active = 0;
+	int rc;
+
+	status = readl(port_mmio + PORT_IRQ_STAT);
+	writel(status, port_mmio + PORT_IRQ_STAT);
+
+	/* ignore BAD_PMP while resetting */
+	if (unlikely(resetting))
+		status &= ~PORT_IRQ_BAD_PMP;
+
+	/* If we are getting PhyRdy, this is
+	 * just a power state change, we should
+	 * clear out this, plus the PhyRdy/Comm
+	 * Wake bits from Serror
+	 */
+	if ((hpriv->flags & AHCI_HFLAG_NO_HOTPLUG) &&
+		(status & PORT_IRQ_PHYRDY)) {
+		status &= ~PORT_IRQ_PHYRDY;
+		ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
+	}
+
+	if (unlikely(status & PORT_IRQ_ERROR)) {
+		ahci_error_intr(ap, status);
+		return;
+	}
+
+	if (status & PORT_IRQ_SDB_FIS) {
+		/* If SNotification is available, leave notification
+		 * handling to sata_async_notification().  If not,
+		 * emulate it by snooping SDB FIS RX area.
+		 *
+		 * Snooping FIS RX area is probably cheaper than
+		 * poking SNotification but some constrollers which
+		 * implement SNotification, ICH9 for example, don't
+		 * store AN SDB FIS into receive area.
+		 */
+		if (hpriv->cap & HOST_CAP_SNTF)
+			sata_async_notification(ap);
+		else {
+			/* If the 'N' bit in word 0 of the FIS is set,
+			 * we just received asynchronous notification.
+			 * Tell libata about it.
+			 *
+			 * Lack of SNotification should not appear in
+			 * ahci 1.2, so the workaround is unnecessary
+			 * when FBS is enabled.
+			 */
+			if (pp->fbs_enabled)
+				WARN_ON_ONCE(1);
+			else {
+				const __le32 *f = pp->rx_fis + RX_FIS_SDB;
+				u32 f0 = le32_to_cpu(f[0]);
+				if (f0 & (1 << 15))
+					sata_async_notification(ap);
+			}
+		}
+	}
+
+	/* pp->active_link is not reliable once FBS is enabled, both
+	 * PORT_SCR_ACT and PORT_CMD_ISSUE should be checked because
+	 * NCQ and non-NCQ commands may be in flight at the same time.
+	 */
+	if (pp->fbs_enabled) {
+		if (ap->qc_active) {
+			qc_active = readl(port_mmio + PORT_SCR_ACT);
+			qc_active |= readl(port_mmio + PORT_CMD_ISSUE);
+		}
+	} else {
+		/* pp->active_link is valid iff any command is in flight */
+		if (ap->qc_active && pp->active_link->sactive)
+			qc_active = readl(port_mmio + PORT_SCR_ACT);
+		else
+			qc_active = readl(port_mmio + PORT_CMD_ISSUE);
+	}
+
+
+	rc = ata_qc_complete_multiple(ap, qc_active);
+
+	/* while resetting, invalid completions are expected */
+	if (unlikely(rc < 0 && !resetting)) {
+		ehi->err_mask |= AC_ERR_HSM;
+		ehi->action |= ATA_EH_RESET;
+		ata_port_freeze(ap);
+	}
+}
+
+irqreturn_t ahci_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct ahci_host_priv *hpriv;
+	unsigned int i, handled = 0;
+	void __iomem *mmio;
+	u32 irq_stat, irq_masked;
+
+	VPRINTK("ENTER\n");
+
+	hpriv = host->private_data;
+	mmio = hpriv->mmio;
+
+	/* sigh.  0xffffffff is a valid return from h/w */
+	irq_stat = readl(mmio + HOST_IRQ_STAT);
+	if (!irq_stat)
+		return IRQ_NONE;
+
+	irq_masked = irq_stat & hpriv->port_map;
+
+	spin_lock(&host->lock);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap;
+
+		if (!(irq_masked & (1 << i)))
+			continue;
+
+		ap = host->ports[i];
+		if (ap) {
+			ahci_port_intr(ap);
+			VPRINTK("port %u\n", i);
+		} else {
+			VPRINTK("port %u (no irq)\n", i);
+			if (ata_ratelimit())
+				dev_printk(KERN_WARNING, host->dev,
+					"interrupt on disabled port %u\n", i);
+		}
+
+		handled = 1;
+	}
+
+	/* HOST_IRQ_STAT behaves as level triggered latch meaning that
+	 * it should be cleared after all the port events are cleared;
+	 * otherwise, it will raise a spurious interrupt after each
+	 * valid one.  Please read section 10.6.2 of ahci 1.1 for more
+	 * information.
+	 *
+	 * Also, use the unmasked value to clear interrupt as spurious
+	 * pending event on a dummy port might cause screaming IRQ.
+	 */
+	writel(irq_stat, mmio + HOST_IRQ_STAT);
+
+	spin_unlock(&host->lock);
+
+	VPRINTK("EXIT\n");
+
+	return IRQ_RETVAL(handled);
+}
+EXPORT_SYMBOL_GPL(ahci_interrupt);
+
+static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/* Keep track of the currently active link.  It will be used
+	 * in completion path to determine whether NCQ phase is in
+	 * progress.
+	 */
+	pp->active_link = qc->dev->link;
+
+	if (qc->tf.protocol == ATA_PROT_NCQ)
+		writel(1 << qc->tag, port_mmio + PORT_SCR_ACT);
+
+	if (pp->fbs_enabled && pp->fbs_last_dev != qc->dev->link->pmp) {
+		u32 fbs = readl(port_mmio + PORT_FBS);
+		fbs &= ~(PORT_FBS_DEV_MASK | PORT_FBS_DEC);
+		fbs |= qc->dev->link->pmp << PORT_FBS_DEV_OFFSET;
+		writel(fbs, port_mmio + PORT_FBS);
+		pp->fbs_last_dev = qc->dev->link->pmp;
+	}
+
+	writel(1 << qc->tag, port_mmio + PORT_CMD_ISSUE);
+
+	ahci_sw_activity(qc->dev->link);
+
+	return 0;
+}
+
+static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
+{
+	struct ahci_port_priv *pp = qc->ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+
+	if (pp->fbs_enabled)
+		d2h_fis += qc->dev->link->pmp * AHCI_RX_FIS_SZ;
+
+	ata_tf_from_fis(d2h_fis, &qc->result_tf);
+	return true;
+}
+
+static void ahci_freeze(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+
+	/* turn IRQ off */
+	writel(0, port_mmio + PORT_IRQ_MASK);
+}
+
+static void ahci_thaw(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 tmp;
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/* clear IRQ */
+	tmp = readl(port_mmio + PORT_IRQ_STAT);
+	writel(tmp, port_mmio + PORT_IRQ_STAT);
+	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
+
+	/* turn IRQ back on */
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+}
+
+static void ahci_error_handler(struct ata_port *ap)
+{
+	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
+		/* restart engine */
+		ahci_stop_engine(ap);
+		ahci_start_engine(ap);
+	}
+
+	sata_pmp_error_handler(ap);
+}
+
+static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+
+	/* make DMA engine forget about the failed command */
+	if (qc->flags & ATA_QCFLAG_FAILED)
+		ahci_kick_engine(ap);
+}
+
+static void ahci_enable_fbs(struct ata_port *ap)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 fbs;
+	int rc;
+
+	if (!pp->fbs_supported)
+		return;
+
+	fbs = readl(port_mmio + PORT_FBS);
+	if (fbs & PORT_FBS_EN) {
+		pp->fbs_enabled = true;
+		pp->fbs_last_dev = -1; /* initialization */
+		return;
+	}
+
+	rc = ahci_stop_engine(ap);
+	if (rc)
+		return;
+
+	writel(fbs | PORT_FBS_EN, port_mmio + PORT_FBS);
+	fbs = readl(port_mmio + PORT_FBS);
+	if (fbs & PORT_FBS_EN) {
+		dev_printk(KERN_INFO, ap->host->dev, "FBS is enabled.\n");
+		pp->fbs_enabled = true;
+		pp->fbs_last_dev = -1; /* initialization */
+	} else
+		dev_printk(KERN_ERR, ap->host->dev, "Failed to enable FBS\n");
+
+	ahci_start_engine(ap);
+}
+
+static void ahci_disable_fbs(struct ata_port *ap)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 fbs;
+	int rc;
+
+	if (!pp->fbs_supported)
+		return;
+
+	fbs = readl(port_mmio + PORT_FBS);
+	if ((fbs & PORT_FBS_EN) == 0) {
+		pp->fbs_enabled = false;
+		return;
+	}
+
+	rc = ahci_stop_engine(ap);
+	if (rc)
+		return;
+
+	writel(fbs & ~PORT_FBS_EN, port_mmio + PORT_FBS);
+	fbs = readl(port_mmio + PORT_FBS);
+	if (fbs & PORT_FBS_EN)
+		dev_printk(KERN_ERR, ap->host->dev, "Failed to disable FBS\n");
+	else {
+		dev_printk(KERN_INFO, ap->host->dev, "FBS is disabled.\n");
+		pp->fbs_enabled = false;
+	}
+
+	ahci_start_engine(ap);
+}
+
+static void ahci_pmp_attach(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 cmd;
+
+	cmd = readl(port_mmio + PORT_CMD);
+	cmd |= PORT_CMD_PMP;
+	writel(cmd, port_mmio + PORT_CMD);
+
+	ahci_enable_fbs(ap);
+
+	pp->intr_mask |= PORT_IRQ_BAD_PMP;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+}
+
+static void ahci_pmp_detach(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 cmd;
+
+	ahci_disable_fbs(ap);
+
+	cmd = readl(port_mmio + PORT_CMD);
+	cmd &= ~PORT_CMD_PMP;
+	writel(cmd, port_mmio + PORT_CMD);
+
+	pp->intr_mask &= ~PORT_IRQ_BAD_PMP;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+}
+
+static int ahci_port_resume(struct ata_port *ap)
+{
+	ahci_power_up(ap);
+	ahci_start_port(ap);
+
+	if (sata_pmp_attached(ap))
+		ahci_pmp_attach(ap);
+	else
+		ahci_pmp_detach(ap);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
+{
+	const char *emsg = NULL;
+	int rc;
+
+	rc = ahci_deinit_port(ap, &emsg);
+	if (rc == 0)
+		ahci_power_down(ap);
+	else {
+		ata_port_printk(ap, KERN_ERR, "%s (%d)\n", emsg, rc);
+		ahci_start_port(ap);
+	}
+
+	return rc;
+}
+#endif
+
+static int ahci_port_start(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct device *dev = ap->host->dev;
+	struct ahci_port_priv *pp;
+	void *mem;
+	dma_addr_t mem_dma;
+	size_t dma_sz, rx_fis_sz;
+
+	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
+	if (!pp)
+		return -ENOMEM;
+
+	/* check FBS capability */
+	if ((hpriv->cap & HOST_CAP_FBS) && sata_pmp_supported(ap)) {
+		void __iomem *port_mmio = ahci_port_base(ap);
+		u32 cmd = readl(port_mmio + PORT_CMD);
+		if (cmd & PORT_CMD_FBSCP)
+			pp->fbs_supported = true;
+		else
+			dev_printk(KERN_WARNING, dev,
+				   "The port is not capable of FBS\n");
+	}
+
+	if (pp->fbs_supported) {
+		dma_sz = AHCI_PORT_PRIV_FBS_DMA_SZ;
+		rx_fis_sz = AHCI_RX_FIS_SZ * 16;
+	} else {
+		dma_sz = AHCI_PORT_PRIV_DMA_SZ;
+		rx_fis_sz = AHCI_RX_FIS_SZ;
+	}
+
+	mem = dmam_alloc_coherent(dev, dma_sz, &mem_dma, GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+	memset(mem, 0, dma_sz);
+
+	/*
+	 * First item in chunk of DMA memory: 32-slot command table,
+	 * 32 bytes each in size
+	 */
+	pp->cmd_slot = mem;
+	pp->cmd_slot_dma = mem_dma;
+
+	mem += AHCI_CMD_SLOT_SZ;
+	mem_dma += AHCI_CMD_SLOT_SZ;
+
+	/*
+	 * Second item: Received-FIS area
+	 */
+	pp->rx_fis = mem;
+	pp->rx_fis_dma = mem_dma;
+
+	mem += rx_fis_sz;
+	mem_dma += rx_fis_sz;
+
+	/*
+	 * Third item: data area for storing a single command
+	 * and its scatter-gather table
+	 */
+	pp->cmd_tbl = mem;
+	pp->cmd_tbl_dma = mem_dma;
+
+	/*
+	 * Save off initial list of interrupts to be enabled.
+	 * This could be changed later
+	 */
+	pp->intr_mask = DEF_PORT_IRQ;
+
+	ap->private_data = pp;
+
+	/* engage engines, captain */
+	return ahci_port_resume(ap);
+}
+
+static void ahci_port_stop(struct ata_port *ap)
+{
+	const char *emsg = NULL;
+	int rc;
+
+	/* de-initialize port */
+	rc = ahci_deinit_port(ap, &emsg);
+	if (rc)
+		ata_port_printk(ap, KERN_WARNING, "%s (%d)\n", emsg, rc);
+}
+
+void ahci_print_info(struct ata_host *host, const char *scc_s)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 vers, cap, cap2, impl, speed;
+	const char *speed_s;
+
+	vers = readl(mmio + HOST_VERSION);
+	cap = hpriv->cap;
+	cap2 = hpriv->cap2;
+	impl = hpriv->port_map;
+
+	speed = (cap >> 20) & 0xf;
+	if (speed == 1)
+		speed_s = "1.5";
+	else if (speed == 2)
+		speed_s = "3";
+	else if (speed == 3)
+		speed_s = "6";
+	else
+		speed_s = "?";
+
+	dev_info(host->dev,
+		"AHCI %02x%02x.%02x%02x "
+		"%u slots %u ports %s Gbps 0x%x impl %s mode\n"
+		,
+
+		(vers >> 24) & 0xff,
+		(vers >> 16) & 0xff,
+		(vers >> 8) & 0xff,
+		vers & 0xff,
+
+		((cap >> 8) & 0x1f) + 1,
+		(cap & 0x1f) + 1,
+		speed_s,
+		impl,
+		scc_s);
+
+	dev_info(host->dev,
+		"flags: "
+		"%s%s%s%s%s%s%s"
+		"%s%s%s%s%s%s%s"
+		"%s%s%s%s%s%s\n"
+		,
+
+		cap & HOST_CAP_64 ? "64bit " : "",
+		cap & HOST_CAP_NCQ ? "ncq " : "",
+		cap & HOST_CAP_SNTF ? "sntf " : "",
+		cap & HOST_CAP_MPS ? "ilck " : "",
+		cap & HOST_CAP_SSS ? "stag " : "",
+		cap & HOST_CAP_ALPM ? "pm " : "",
+		cap & HOST_CAP_LED ? "led " : "",
+		cap & HOST_CAP_CLO ? "clo " : "",
+		cap & HOST_CAP_ONLY ? "only " : "",
+		cap & HOST_CAP_PMP ? "pmp " : "",
+		cap & HOST_CAP_FBS ? "fbs " : "",
+		cap & HOST_CAP_PIO_MULTI ? "pio " : "",
+		cap & HOST_CAP_SSC ? "slum " : "",
+		cap & HOST_CAP_PART ? "part " : "",
+		cap & HOST_CAP_CCC ? "ccc " : "",
+		cap & HOST_CAP_EMS ? "ems " : "",
+		cap & HOST_CAP_SXS ? "sxs " : "",
+		cap2 & HOST_CAP2_APST ? "apst " : "",
+		cap2 & HOST_CAP2_NVMHCI ? "nvmp " : "",
+		cap2 & HOST_CAP2_BOH ? "boh " : ""
+		);
+}
+EXPORT_SYMBOL_GPL(ahci_print_info);
+
+void ahci_set_em_messages(struct ahci_host_priv *hpriv,
+			  struct ata_port_info *pi)
+{
+	u8 messages;
+	void __iomem *mmio = hpriv->mmio;
+	u32 em_loc = readl(mmio + HOST_EM_LOC);
+	u32 em_ctl = readl(mmio + HOST_EM_CTL);
+
+	if (!ahci_em_messages || !(hpriv->cap & HOST_CAP_EMS))
+		return;
+
+	messages = (em_ctl & EM_CTRL_MSG_TYPE) >> 16;
+
+	if (messages) {
+		/* store em_loc */
+		hpriv->em_loc = ((em_loc >> 16) * 4);
+		hpriv->em_buf_sz = ((em_loc & 0xff) * 4);
+		hpriv->em_msg_type = messages;
+		pi->flags |= ATA_FLAG_EM;
+		if (!(em_ctl & EM_CTL_ALHD))
+			pi->flags |= ATA_FLAG_SW_ACTIVITY;
+	}
+}
+EXPORT_SYMBOL_GPL(ahci_set_em_messages);
+
+MODULE_AUTHOR("Jeff Garzik");
+MODULE_DESCRIPTION("Common AHCI SATA low-level routines");
+MODULE_LICENSE("GPL");
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 49cffb6..c47373f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -65,6 +65,7 @@
 #include <linux/libata.h>
 #include <asm/byteorder.h>
 #include <linux/cdrom.h>
+#include <linux/ratelimit.h>
 
 #include "libata.h"
 
@@ -96,7 +97,6 @@ static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
 unsigned int ata_print_id = 1;
-static struct workqueue_struct *ata_wq;
 
 struct workqueue_struct *ata_aux_wq;
 
@@ -1685,52 +1685,6 @@ unsigned long ata_id_xfermask(const u16 *id)
 	return ata_pack_xfermask(pio_mask, mwdma_mask, udma_mask);
 }
 
-/**
- *	ata_pio_queue_task - Queue port_task
- *	@ap: The ata_port to queue port_task for
- *	@data: data for @fn to use
- *	@delay: delay time in msecs for workqueue function
- *
- *	Schedule @fn(@data) for execution after @delay jiffies using
- *	port_task.  There is one port_task per port and it's the
- *	user(low level driver)'s responsibility to make sure that only
- *	one task is active at any given time.
- *
- *	libata core layer takes care of synchronization between
- *	port_task and EH.  ata_pio_queue_task() may be ignored for EH
- *	synchronization.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-void ata_pio_queue_task(struct ata_port *ap, void *data, unsigned long delay)
-{
-	ap->port_task_data = data;
-
-	/* may fail if ata_port_flush_task() in progress */
-	queue_delayed_work(ata_wq, &ap->port_task, msecs_to_jiffies(delay));
-}
-
-/**
- *	ata_port_flush_task - Flush port_task
- *	@ap: The ata_port to flush port_task for
- *
- *	After this function completes, port_task is guranteed not to
- *	be running or scheduled.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- */
-void ata_port_flush_task(struct ata_port *ap)
-{
-	DPRINTK("ENTER\n");
-
-	cancel_rearming_delayed_work(&ap->port_task);
-
-	if (ata_msg_ctl(ap))
-		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __func__);
-}
-
 static void ata_qc_complete_internal(struct ata_queued_cmd *qc)
 {
 	struct completion *waiting = qc->private_data;
@@ -1852,7 +1806,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 
 	rc = wait_for_completion_timeout(&wait, msecs_to_jiffies(timeout));
 
-	ata_port_flush_task(ap);
+	ata_sff_flush_pio_task(ap);
 
 	if (!rc) {
 		spin_lock_irqsave(ap->lock, flags);
@@ -1906,22 +1860,6 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	ap->qc_active = preempted_qc_active;
 	ap->nr_active_links = preempted_nr_active_links;
 
-	/* XXX - Some LLDDs (sata_mv) disable port on command failure.
-	 * Until those drivers are fixed, we detect the condition
-	 * here, fail the command with AC_ERR_SYSTEM and reenable the
-	 * port.
-	 *
-	 * Note that this doesn't change any behavior as internal
-	 * command failure results in disabling the device in the
-	 * higher layer for LLDDs without new reset/EH callbacks.
-	 *
-	 * Kill the following code as soon as those drivers are fixed.
-	 */
-	if (ap->flags & ATA_FLAG_DISABLED) {
-		err_mask |= AC_ERR_SYSTEM;
-		ata_port_probe(ap);
-	}
-
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	if ((err_mask & AC_ERR_TIMEOUT) && auto_timeout)
@@ -2767,8 +2705,6 @@ int ata_bus_probe(struct ata_port *ap)
 	int rc;
 	struct ata_device *dev;
 
-	ata_port_probe(ap);
-
 	ata_for_each_dev(dev, &ap->link, ALL)
 		tries[dev->devno] = ATA_PROBE_MAX_TRIES;
 
@@ -2796,8 +2732,7 @@ int ata_bus_probe(struct ata_port *ap)
 	ap->ops->phy_reset(ap);
 
 	ata_for_each_dev(dev, &ap->link, ALL) {
-		if (!(ap->flags & ATA_FLAG_DISABLED) &&
-		    dev->class != ATA_DEV_UNKNOWN)
+		if (dev->class != ATA_DEV_UNKNOWN)
 			classes[dev->devno] = dev->class;
 		else
 			classes[dev->devno] = ATA_DEV_NONE;
@@ -2805,8 +2740,6 @@ int ata_bus_probe(struct ata_port *ap)
 		dev->class = ATA_DEV_UNKNOWN;
 	}
 
-	ata_port_probe(ap);
-
 	/* read IDENTIFY page and configure devices. We have to do the identify
 	   specific sequence bass-ackwards so that PDIAG- is released by
 	   the slave device */
@@ -2856,8 +2789,6 @@ int ata_bus_probe(struct ata_port *ap)
 	ata_for_each_dev(dev, &ap->link, ENABLED)
 		return 0;
 
-	/* no device present, disable port */
-	ata_port_disable(ap);
 	return -ENODEV;
 
  fail:
@@ -2889,22 +2820,6 @@ int ata_bus_probe(struct ata_port *ap)
 }
 
 /**
- *	ata_port_probe - Mark port as enabled
- *	@ap: Port for which we indicate enablement
- *
- *	Modify @ap data structure such that the system
- *	thinks that the entire port is enabled.
- *
- *	LOCKING: host lock, or some other form of
- *	serialization.
- */
-
-void ata_port_probe(struct ata_port *ap)
-{
-	ap->flags &= ~ATA_FLAG_DISABLED;
-}
-
-/**
  *	sata_print_link_status - Print SATA link status
  *	@link: SATA link to printk link status about
  *
@@ -2951,26 +2866,6 @@ struct ata_device *ata_dev_pair(struct ata_device *adev)
 }
 
 /**
- *	ata_port_disable - Disable port.
- *	@ap: Port to be disabled.
- *
- *	Modify @ap data structure such that the system
- *	thinks that the entire port is disabled, and should
- *	never attempt to probe or communicate with devices
- *	on this port.
- *
- *	LOCKING: host lock, or some other form of
- *	serialization.
- */
-
-void ata_port_disable(struct ata_port *ap)
-{
-	ap->link.device[0].class = ATA_DEV_NONE;
-	ap->link.device[1].class = ATA_DEV_NONE;
-	ap->flags |= ATA_FLAG_DISABLED;
-}
-
-/**
  *	sata_down_spd_limit - adjust SATA spd limit downward
  *	@link: Link to adjust SATA spd limit for
  *	@spd_limit: Additional limit
@@ -3631,9 +3526,15 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 		   int (*check_ready)(struct ata_link *link))
 {
 	unsigned long start = jiffies;
-	unsigned long nodev_deadline = ata_deadline(start, ATA_TMOUT_FF_WAIT);
+	unsigned long nodev_deadline;
 	int warned = 0;
 
+	/* choose which 0xff timeout to use, read comment in libata.h */
+	if (link->ap->host->flags & ATA_HOST_PARALLEL_SCAN)
+		nodev_deadline = ata_deadline(start, ATA_TMOUT_FF_WAIT_LONG);
+	else
+		nodev_deadline = ata_deadline(start, ATA_TMOUT_FF_WAIT);
+
 	/* Slave readiness can't be tested separately from master.  On
 	 * M/S emulation configuration, this function should be called
 	 * only on the master and it will handle both master and slave.
@@ -3651,12 +3552,12 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 		if (ready > 0)
 			return 0;
 
-		/* -ENODEV could be transient.  Ignore -ENODEV if link
+		/*
+		 * -ENODEV could be transient.  Ignore -ENODEV if link
 		 * is online.  Also, some SATA devices take a long
-		 * time to clear 0xff after reset.  For example,
-		 * HHD424020F7SV00 iVDR needs >= 800ms while Quantum
-		 * GoVault needs even more than that.  Wait for
-		 * ATA_TMOUT_FF_WAIT on -ENODEV if link isn't offline.
+		 * time to clear 0xff after reset.  Wait for
+		 * ATA_TMOUT_FF_WAIT[_LONG] on -ENODEV if link isn't
+		 * offline.
 		 *
 		 * Note that some PATA controllers (pata_ali) explode
 		 * if status register is read more than once when
@@ -5558,30 +5459,6 @@ void ata_host_resume(struct ata_host *host)
 #endif
 
 /**
- *	ata_port_start - Set port up for dma.
- *	@ap: Port to initialize
- *
- *	Called just after data structures for each port are
- *	initialized.  Allocates space for PRD table.
- *
- *	May be used as the port_start() entry in ata_port_operations.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-int ata_port_start(struct ata_port *ap)
-{
-	struct device *dev = ap->dev;
-
-	ap->prd = dmam_alloc_coherent(dev, ATA_PRD_TBL_SZ, &ap->prd_dma,
-				      GFP_KERNEL);
-	if (!ap->prd)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/**
  *	ata_dev_init - Initialize an ata_device structure
  *	@dev: Device structure to initialize
  *
@@ -5709,12 +5586,9 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 
 	ap->pflags |= ATA_PFLAG_INITIALIZING;
 	ap->lock = &host->lock;
-	ap->flags = ATA_FLAG_DISABLED;
 	ap->print_id = -1;
-	ap->ctl = ATA_DEVCTL_OBS;
 	ap->host = host;
 	ap->dev = host->dev;
-	ap->last_ctl = 0xFF;
 
 #if defined(ATA_VERBOSE_DEBUG)
 	/* turn on all debugging levels */
@@ -5725,11 +5599,6 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap->msg_enable = ATA_MSG_DRV | ATA_MSG_ERR | ATA_MSG_WARN;
 #endif
 
-#ifdef CONFIG_ATA_SFF
-	INIT_DELAYED_WORK(&ap->port_task, ata_pio_task);
-#else
-	INIT_DELAYED_WORK(&ap->port_task, NULL);
-#endif
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
 	INIT_LIST_HEAD(&ap->eh_done_q);
@@ -5747,6 +5616,8 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap->stats.unhandled_irq = 1;
 	ap->stats.idle_irq = 1;
 #endif
+	ata_sff_port_init(ap);
+
 	return ap;
 }
 
@@ -6138,8 +6009,6 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 		struct ata_eh_info *ehi = &ap->link.eh_info;
 		unsigned long flags;
 
-		ata_port_probe(ap);
-
 		/* kick EH for boot probing */
 		spin_lock_irqsave(ap->lock, flags);
 
@@ -6663,62 +6532,43 @@ static void __init ata_parse_force_param(void)
 
 static int __init ata_init(void)
 {
-	ata_parse_force_param();
+	int rc = -ENOMEM;
 
-	/*
-	 * FIXME: In UP case, there is only one workqueue thread and if you
-	 * have more than one PIO device, latency is bloody awful, with
-	 * occasional multi-second "hiccups" as one PIO device waits for
-	 * another.  It's an ugly wart that users DO occasionally complain
-	 * about; luckily most users have at most one PIO polled device.
-	 */
-	ata_wq = create_workqueue("ata");
-	if (!ata_wq)
-		goto free_force_tbl;
+	ata_parse_force_param();
 
 	ata_aux_wq = create_singlethread_workqueue("ata_aux");
 	if (!ata_aux_wq)
-		goto free_wq;
+		goto fail;
+
+	rc = ata_sff_init();
+	if (rc)
+		goto fail;
 
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
 
-free_wq:
-	destroy_workqueue(ata_wq);
-free_force_tbl:
+fail:
 	kfree(ata_force_tbl);
-	return -ENOMEM;
+	if (ata_aux_wq)
+		destroy_workqueue(ata_aux_wq);
+	return rc;
 }
 
 static void __exit ata_exit(void)
 {
+	ata_sff_exit();
 	kfree(ata_force_tbl);
-	destroy_workqueue(ata_wq);
 	destroy_workqueue(ata_aux_wq);
 }
 
 subsys_initcall(ata_init);
 module_exit(ata_exit);
 
-static unsigned long ratelimit_time;
-static DEFINE_SPINLOCK(ata_ratelimit_lock);
+static DEFINE_RATELIMIT_STATE(ratelimit, HZ / 5, 1);
 
 int ata_ratelimit(void)
 {
-	int rc;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ata_ratelimit_lock, flags);
-
-	if (time_after(jiffies, ratelimit_time)) {
-		rc = 1;
-		ratelimit_time = jiffies + (HZ/5);
-	} else
-		rc = 0;
-
-	spin_unlock_irqrestore(&ata_ratelimit_lock, flags);
-
-	return rc;
+	return __ratelimit(&ratelimit);
 }
 
 /**
@@ -6826,11 +6676,9 @@ EXPORT_SYMBOL_GPL(ata_xfer_mode2mask);
 EXPORT_SYMBOL_GPL(ata_xfer_mode2shift);
 EXPORT_SYMBOL_GPL(ata_mode_string);
 EXPORT_SYMBOL_GPL(ata_id_xfermask);
-EXPORT_SYMBOL_GPL(ata_port_start);
 EXPORT_SYMBOL_GPL(ata_do_set_mode);
 EXPORT_SYMBOL_GPL(ata_std_qc_defer);
 EXPORT_SYMBOL_GPL(ata_noop_qc_prep);
-EXPORT_SYMBOL_GPL(ata_port_probe);
 EXPORT_SYMBOL_GPL(ata_dev_disable);
 EXPORT_SYMBOL_GPL(sata_set_spd);
 EXPORT_SYMBOL_GPL(ata_wait_after_reset);
@@ -6842,7 +6690,6 @@ EXPORT_SYMBOL_GPL(sata_std_hardreset);
 EXPORT_SYMBOL_GPL(ata_std_postreset);
 EXPORT_SYMBOL_GPL(ata_dev_classify);
 EXPORT_SYMBOL_GPL(ata_dev_pair);
-EXPORT_SYMBOL_GPL(ata_port_disable);
 EXPORT_SYMBOL_GPL(ata_ratelimit);
 EXPORT_SYMBOL_GPL(ata_wait_register);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
@@ -6864,7 +6711,6 @@ EXPORT_SYMBOL_GPL(ata_id_c_string);
 EXPORT_SYMBOL_GPL(ata_do_dev_read_id);
 EXPORT_SYMBOL_GPL(ata_scsi_simulate);
 
-EXPORT_SYMBOL_GPL(ata_pio_queue_task);
 EXPORT_SYMBOL_GPL(ata_pio_need_iordy);
 EXPORT_SYMBOL_GPL(ata_timing_find_mode);
 EXPORT_SYMBOL_GPL(ata_timing_compute);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 228740f..f77a673 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -550,8 +550,8 @@ void ata_scsi_error(struct Scsi_Host *host)
 
 	DPRINTK("ENTER\n");
 
-	/* synchronize with port task */
-	ata_port_flush_task(ap);
+	/* make sure sff pio task is not running */
+	ata_sff_flush_pio_task(ap);
 
 	/* synchronize with host lock and sort out timeouts */
 
@@ -3684,7 +3684,7 @@ void ata_std_error_handler(struct ata_port *ap)
 	ata_reset_fn_t hardreset = ops->hardreset;
 
 	/* ignore built-in hardreset if SCR access is not available */
-	if (ata_is_builtin_hardreset(hardreset) && !sata_scr_valid(&ap->link))
+	if (hardreset == sata_std_hardreset && !sata_scr_valid(&ap->link))
 		hardreset = NULL;
 
 	ata_do_eh(ap, ops->prereset, ops->softreset, hardreset, ops->postreset);
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 00305f4..224faab 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -231,10 +231,14 @@ static const char *sata_pmp_spec_rev_str(const u32 *gscr)
 	return "<unknown>";
 }
 
+#define PMP_GSCR_SII_POL 129
+
 static int sata_pmp_configure(struct ata_device *dev, int print_info)
 {
 	struct ata_port *ap = dev->link->ap;
 	u32 *gscr = dev->gscr;
+	u16 vendor = sata_pmp_gscr_vendor(gscr);
+	u16 devid = sata_pmp_gscr_devid(gscr);
 	unsigned int err_mask = 0;
 	const char *reason;
 	int nr_ports, rc;
@@ -260,12 +264,34 @@ static int sata_pmp_configure(struct ata_device *dev, int print_info)
 		goto fail;
 	}
 
+	/* Disable sending Early R_OK.
+	 * With "cached read" HDD testing and multiple ports busy on a SATA
+	 * host controller, 3726 PMP will very rarely drop a deferred
+	 * R_OK that was intended for the host. Symptom will be all
+	 * 5 drives under test will timeout, get reset, and recover.
+	 */
+	if (vendor == 0x1095 && devid == 0x3726) {
+		u32 reg;
+
+		err_mask = sata_pmp_read(&ap->link, PMP_GSCR_SII_POL, &reg);
+		if (err_mask) {
+			rc = -EIO;
+			reason = "failed to read Sil3726 Private Register";
+			goto fail;
+		}
+		reg &= ~0x1;
+		err_mask = sata_pmp_write(&ap->link, PMP_GSCR_SII_POL, reg);
+		if (err_mask) {
+			rc = -EIO;
+			reason = "failed to write Sil3726 Private Register";
+			goto fail;
+		}
+	}
+
 	if (print_info) {
 		ata_dev_printk(dev, KERN_INFO, "Port Multiplier %s, "
 			       "0x%04x:0x%04x r%d, %d ports, feat 0x%x/0x%x\n",
-			       sata_pmp_spec_rev_str(gscr),
-			       sata_pmp_gscr_vendor(gscr),
-			       sata_pmp_gscr_devid(gscr),
+			       sata_pmp_spec_rev_str(gscr), vendor, devid,
 			       sata_pmp_gscr_rev(gscr),
 			       nr_ports, gscr[SATA_PMP_GSCR_FEAT_EN],
 			       gscr[SATA_PMP_GSCR_FEAT]);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0088cde..cfa9dd3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3345,9 +3345,6 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 	struct ata_link *link;
 	struct ata_device *dev;
 
-	if (ap->flags & ATA_FLAG_DISABLED)
-		return;
-
  repeat:
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ENABLED) {
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index e3877b6..19ddf92 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -40,10 +40,12 @@
 
 #include "libata.h"
 
+static struct workqueue_struct *ata_sff_wq;
+
 const struct ata_port_operations ata_sff_port_ops = {
 	.inherits		= &ata_base_port_ops,
 
-	.qc_prep		= ata_sff_qc_prep,
+	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= ata_sff_qc_issue,
 	.qc_fill_rtf		= ata_sff_qc_fill_rtf,
 
@@ -53,9 +55,7 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.softreset		= ata_sff_softreset,
 	.hardreset		= sata_sff_hardreset,
 	.postreset		= ata_sff_postreset,
-	.drain_fifo		= ata_sff_drain_fifo,
 	.error_handler		= ata_sff_error_handler,
-	.post_internal_cmd	= ata_sff_post_internal_cmd,
 
 	.sff_dev_select		= ata_sff_dev_select,
 	.sff_check_status	= ata_sff_check_status,
@@ -63,178 +63,13 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.sff_tf_read		= ata_sff_tf_read,
 	.sff_exec_command	= ata_sff_exec_command,
 	.sff_data_xfer		= ata_sff_data_xfer,
-	.sff_irq_on		= ata_sff_irq_on,
 	.sff_irq_clear		= ata_sff_irq_clear,
+	.sff_drain_fifo		= ata_sff_drain_fifo,
 
 	.lost_interrupt		= ata_sff_lost_interrupt,
-
-	.port_start		= ata_sff_port_start,
 };
 EXPORT_SYMBOL_GPL(ata_sff_port_ops);
 
-const struct ata_port_operations ata_bmdma_port_ops = {
-	.inherits		= &ata_sff_port_ops,
-
-	.mode_filter		= ata_bmdma_mode_filter,
-
-	.bmdma_setup		= ata_bmdma_setup,
-	.bmdma_start		= ata_bmdma_start,
-	.bmdma_stop		= ata_bmdma_stop,
-	.bmdma_status		= ata_bmdma_status,
-};
-EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
-
-const struct ata_port_operations ata_bmdma32_port_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-
-	.sff_data_xfer		= ata_sff_data_xfer32,
-	.port_start		= ata_sff_port_start32,
-};
-EXPORT_SYMBOL_GPL(ata_bmdma32_port_ops);
-
-/**
- *	ata_fill_sg - Fill PCI IDE PRD table
- *	@qc: Metadata associated with taskfile to be transferred
- *
- *	Fill PCI IDE PRD (scatter-gather) table with segments
- *	associated with the current disk command.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- *
- */
-static void ata_fill_sg(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg;
-	unsigned int si, pi;
-
-	pi = 0;
-	for_each_sg(qc->sg, sg, qc->n_elem, si) {
-		u32 addr, offset;
-		u32 sg_len, len;
-
-		/* determine if physical DMA addr spans 64K boundary.
-		 * Note h/w doesn't support 64-bit, so we unconditionally
-		 * truncate dma_addr_t to u32.
-		 */
-		addr = (u32) sg_dma_address(sg);
-		sg_len = sg_dma_len(sg);
-
-		while (sg_len) {
-			offset = addr & 0xffff;
-			len = sg_len;
-			if ((offset + sg_len) > 0x10000)
-				len = 0x10000 - offset;
-
-			ap->prd[pi].addr = cpu_to_le32(addr);
-			ap->prd[pi].flags_len = cpu_to_le32(len & 0xffff);
-			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
-
-			pi++;
-			sg_len -= len;
-			addr += len;
-		}
-	}
-
-	ap->prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
-}
-
-/**
- *	ata_fill_sg_dumb - Fill PCI IDE PRD table
- *	@qc: Metadata associated with taskfile to be transferred
- *
- *	Fill PCI IDE PRD (scatter-gather) table with segments
- *	associated with the current disk command. Perform the fill
- *	so that we avoid writing any length 64K records for
- *	controllers that don't follow the spec.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- *
- */
-static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg;
-	unsigned int si, pi;
-
-	pi = 0;
-	for_each_sg(qc->sg, sg, qc->n_elem, si) {
-		u32 addr, offset;
-		u32 sg_len, len, blen;
-
-		/* determine if physical DMA addr spans 64K boundary.
-		 * Note h/w doesn't support 64-bit, so we unconditionally
-		 * truncate dma_addr_t to u32.
-		 */
-		addr = (u32) sg_dma_address(sg);
-		sg_len = sg_dma_len(sg);
-
-		while (sg_len) {
-			offset = addr & 0xffff;
-			len = sg_len;
-			if ((offset + sg_len) > 0x10000)
-				len = 0x10000 - offset;
-
-			blen = len & 0xffff;
-			ap->prd[pi].addr = cpu_to_le32(addr);
-			if (blen == 0) {
-				/* Some PATA chipsets like the CS5530 can't
-				   cope with 0x0000 meaning 64K as the spec
-				   says */
-				ap->prd[pi].flags_len = cpu_to_le32(0x8000);
-				blen = 0x8000;
-				ap->prd[++pi].addr = cpu_to_le32(addr + 0x8000);
-			}
-			ap->prd[pi].flags_len = cpu_to_le32(blen);
-			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
-
-			pi++;
-			sg_len -= len;
-			addr += len;
-		}
-	}
-
-	ap->prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
-}
-
-/**
- *	ata_sff_qc_prep - Prepare taskfile for submission
- *	@qc: Metadata associated with taskfile to be prepared
- *
- *	Prepare ATA taskfile for submission.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_sff_qc_prep(struct ata_queued_cmd *qc)
-{
-	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
-
-	ata_fill_sg(qc);
-}
-EXPORT_SYMBOL_GPL(ata_sff_qc_prep);
-
-/**
- *	ata_sff_dumb_qc_prep - Prepare taskfile for submission
- *	@qc: Metadata associated with taskfile to be prepared
- *
- *	Prepare ATA taskfile for submission.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_sff_dumb_qc_prep(struct ata_queued_cmd *qc)
-{
-	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
-
-	ata_fill_sg_dumb(qc);
-}
-EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
-
 /**
  *	ata_sff_check_status - Read device status reg & clear interrupt
  *	@ap: port where the device is
@@ -446,6 +281,27 @@ int ata_sff_wait_ready(struct ata_link *link, unsigned long deadline)
 EXPORT_SYMBOL_GPL(ata_sff_wait_ready);
 
 /**
+ *	ata_sff_set_devctl - Write device control reg
+ *	@ap: port where the device is
+ *	@ctl: value to write
+ *
+ *	Writes ATA taskfile device control register.
+ *
+ *	Note: may NOT be used as the sff_set_devctl() entry in
+ *	ata_port_operations.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+static void ata_sff_set_devctl(struct ata_port *ap, u8 ctl)
+{
+	if (ap->ops->sff_set_devctl)
+		ap->ops->sff_set_devctl(ap, ctl);
+	else
+		iowrite8(ctl, ap->ioaddr.ctl_addr);
+}
+
+/**
  *	ata_sff_dev_select - Select device 0/1 on ATA bus
  *	@ap: ATA channel to manipulate
  *	@device: ATA device (numbered from zero) to select
@@ -491,7 +347,7 @@ EXPORT_SYMBOL_GPL(ata_sff_dev_select);
  *	LOCKING:
  *	caller.
  */
-void ata_dev_select(struct ata_port *ap, unsigned int device,
+static void ata_dev_select(struct ata_port *ap, unsigned int device,
 			   unsigned int wait, unsigned int can_sleep)
 {
 	if (ata_msg_probe(ap))
@@ -517,24 +373,29 @@ void ata_dev_select(struct ata_port *ap, unsigned int device,
  *	Enable interrupts on a legacy IDE device using MMIO or PIO,
  *	wait for idle, clear any pending interrupts.
  *
+ *	Note: may NOT be used as the sff_irq_on() entry in
+ *	ata_port_operations.
+ *
  *	LOCKING:
  *	Inherited from caller.
  */
-u8 ata_sff_irq_on(struct ata_port *ap)
+void ata_sff_irq_on(struct ata_port *ap)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
-	u8 tmp;
+
+	if (ap->ops->sff_irq_on) {
+		ap->ops->sff_irq_on(ap);
+		return;
+	}
 
 	ap->ctl &= ~ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
-	if (ioaddr->ctl_addr)
-		iowrite8(ap->ctl, ioaddr->ctl_addr);
-	tmp = ata_wait_idle(ap);
+	if (ap->ops->sff_set_devctl || ioaddr->ctl_addr)
+		ata_sff_set_devctl(ap, ap->ctl);
+	ata_wait_idle(ap);
 
 	ap->ops->sff_irq_clear(ap);
-
-	return tmp;
 }
 EXPORT_SYMBOL_GPL(ata_sff_irq_on);
 
@@ -579,7 +440,6 @@ void ata_sff_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 		if (ioaddr->ctl_addr)
 			iowrite8(tf->ctl, ioaddr->ctl_addr);
 		ap->last_ctl = tf->ctl;
-		ata_wait_idle(ap);
 	}
 
 	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
@@ -615,8 +475,6 @@ void ata_sff_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 		iowrite8(tf->device, ioaddr->device_addr);
 		VPRINTK("device 0x%X\n", tf->device);
 	}
-
-	ata_wait_idle(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sff_tf_load);
 
@@ -894,7 +752,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 				       do_write);
 	}
 
-	if (!do_write)
+	if (!do_write && !PageSlab(page))
 		flush_dcache_page(page);
 
 	qc->curbytes += qc->sect_size;
@@ -1165,7 +1023,7 @@ static void ata_hsm_qc_complete(struct ata_queued_cmd *qc, int in_wq)
 			qc = ata_qc_from_tag(ap, qc->tag);
 			if (qc) {
 				if (likely(!(qc->err_mask & AC_ERR_HSM))) {
-					ap->ops->sff_irq_on(ap);
+					ata_sff_irq_on(ap);
 					ata_qc_complete(qc);
 				} else
 					ata_port_freeze(ap);
@@ -1181,7 +1039,7 @@ static void ata_hsm_qc_complete(struct ata_queued_cmd *qc, int in_wq)
 	} else {
 		if (in_wq) {
 			spin_lock_irqsave(ap->lock, flags);
-			ap->ops->sff_irq_on(ap);
+			ata_sff_irq_on(ap);
 			ata_qc_complete(qc);
 			spin_unlock_irqrestore(ap->lock, flags);
 		} else
@@ -1293,7 +1151,7 @@ fsm_start:
 		if (in_wq)
 			spin_unlock_irqrestore(ap->lock, flags);
 
-		/* if polling, ata_pio_task() handles the rest.
+		/* if polling, ata_sff_pio_task() handles the rest.
 		 * otherwise, interrupt handler takes over from here.
 		 */
 		break;
@@ -1458,14 +1316,38 @@ fsm_start:
 }
 EXPORT_SYMBOL_GPL(ata_sff_hsm_move);
 
-void ata_pio_task(struct work_struct *work)
+void ata_sff_queue_pio_task(struct ata_port *ap, unsigned long delay)
+{
+	/* may fail if ata_sff_flush_pio_task() in progress */
+	queue_delayed_work(ata_sff_wq, &ap->sff_pio_task,
+			   msecs_to_jiffies(delay));
+}
+EXPORT_SYMBOL_GPL(ata_sff_queue_pio_task);
+
+void ata_sff_flush_pio_task(struct ata_port *ap)
+{
+	DPRINTK("ENTER\n");
+
+	cancel_rearming_delayed_work(&ap->sff_pio_task);
+	ap->hsm_task_state = HSM_ST_IDLE;
+
+	if (ata_msg_ctl(ap))
+		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __func__);
+}
+
+static void ata_sff_pio_task(struct work_struct *work)
 {
 	struct ata_port *ap =
-		container_of(work, struct ata_port, port_task.work);
-	struct ata_queued_cmd *qc = ap->port_task_data;
+		container_of(work, struct ata_port, sff_pio_task.work);
+	struct ata_queued_cmd *qc;
 	u8 status;
 	int poll_next;
 
+	/* qc can be NULL if timeout occurred */
+	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+	if (!qc)
+		return;
+
 fsm_start:
 	WARN_ON_ONCE(ap->hsm_task_state == HSM_ST_IDLE);
 
@@ -1481,7 +1363,7 @@ fsm_start:
 		msleep(2);
 		status = ata_sff_busy_wait(ap, ATA_BUSY, 10);
 		if (status & ATA_BUSY) {
-			ata_pio_queue_task(ap, qc, ATA_SHORT_PAUSE);
+			ata_sff_queue_pio_task(ap, ATA_SHORT_PAUSE);
 			return;
 		}
 	}
@@ -1497,15 +1379,11 @@ fsm_start:
 }
 
 /**
- *	ata_sff_qc_issue - issue taskfile to device in proto-dependent manner
+ *	ata_sff_qc_issue - issue taskfile to a SFF controller
  *	@qc: command to issue to device
  *
- *	Using various libata functions and hooks, this function
- *	starts an ATA command.  ATA commands are grouped into
- *	classes called "protocols", and issuing each type of protocol
- *	is slightly different.
- *
- *	May be used as the qc_issue() entry in ata_port_operations.
+ *	This function issues a PIO or NODATA command to a SFF
+ *	controller.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
@@ -1520,23 +1398,8 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 	/* Use polling pio if the LLD doesn't handle
 	 * interrupt driven pio and atapi CDB interrupt.
 	 */
-	if (ap->flags & ATA_FLAG_PIO_POLLING) {
-		switch (qc->tf.protocol) {
-		case ATA_PROT_PIO:
-		case ATA_PROT_NODATA:
-		case ATAPI_PROT_PIO:
-		case ATAPI_PROT_NODATA:
-			qc->tf.flags |= ATA_TFLAG_POLLING;
-			break;
-		case ATAPI_PROT_DMA:
-			if (qc->dev->flags & ATA_DFLAG_CDB_INTR)
-				/* see ata_dma_blacklisted() */
-				BUG();
-			break;
-		default:
-			break;
-		}
-	}
+	if (ap->flags & ATA_FLAG_PIO_POLLING)
+		qc->tf.flags |= ATA_TFLAG_POLLING;
 
 	/* select the device */
 	ata_dev_select(ap, qc->dev->devno, 1, 0);
@@ -1551,17 +1414,8 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		ap->hsm_task_state = HSM_ST_LAST;
 
 		if (qc->tf.flags & ATA_TFLAG_POLLING)
-			ata_pio_queue_task(ap, qc, 0);
-
-		break;
-
-	case ATA_PROT_DMA:
-		WARN_ON_ONCE(qc->tf.flags & ATA_TFLAG_POLLING);
+			ata_sff_queue_pio_task(ap, 0);
 
-		ap->ops->sff_tf_load(ap, &qc->tf);  /* load tf registers */
-		ap->ops->bmdma_setup(qc);	    /* set up bmdma */
-		ap->ops->bmdma_start(qc);	    /* initiate bmdma */
-		ap->hsm_task_state = HSM_ST_LAST;
 		break;
 
 	case ATA_PROT_PIO:
@@ -1573,20 +1427,21 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		if (qc->tf.flags & ATA_TFLAG_WRITE) {
 			/* PIO data out protocol */
 			ap->hsm_task_state = HSM_ST_FIRST;
-			ata_pio_queue_task(ap, qc, 0);
+			ata_sff_queue_pio_task(ap, 0);
 
-			/* always send first data block using
-			 * the ata_pio_task() codepath.
+			/* always send first data block using the
+			 * ata_sff_pio_task() codepath.
 			 */
 		} else {
 			/* PIO data in protocol */
 			ap->hsm_task_state = HSM_ST;
 
 			if (qc->tf.flags & ATA_TFLAG_POLLING)
-				ata_pio_queue_task(ap, qc, 0);
+				ata_sff_queue_pio_task(ap, 0);
 
-			/* if polling, ata_pio_task() handles the rest.
-			 * otherwise, interrupt handler takes over from here.
+			/* if polling, ata_sff_pio_task() handles the
+			 * rest.  otherwise, interrupt handler takes
+			 * over from here.
 			 */
 		}
 
@@ -1604,19 +1459,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		/* send cdb by polling if no cdb interrupt */
 		if ((!(qc->dev->flags & ATA_DFLAG_CDB_INTR)) ||
 		    (qc->tf.flags & ATA_TFLAG_POLLING))
-			ata_pio_queue_task(ap, qc, 0);
-		break;
-
-	case ATAPI_PROT_DMA:
-		WARN_ON_ONCE(qc->tf.flags & ATA_TFLAG_POLLING);
-
-		ap->ops->sff_tf_load(ap, &qc->tf);  /* load tf registers */
-		ap->ops->bmdma_setup(qc);	    /* set up bmdma */
-		ap->hsm_task_state = HSM_ST_FIRST;
-
-		/* send cdb by polling if no cdb interrupt */
-		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
-			ata_pio_queue_task(ap, qc, 0);
+			ata_sff_queue_pio_task(ap, 0);
 		break;
 
 	default:
@@ -1728,7 +1571,7 @@ unsigned int ata_sff_host_intr(struct ata_port *ap,
 			goto idle_irq;
 	}
 
-	/* ack bmdma irq events */
+	/* clear irq events */
 	ap->ops->sff_irq_clear(ap);
 
 	ata_sff_hsm_move(ap, qc, status, 0);
@@ -1785,9 +1628,6 @@ retry:
 		struct ata_port *ap = host->ports[i];
 		struct ata_queued_cmd *qc;
 
-		if (unlikely(ap->flags & ATA_FLAG_DISABLED))
-			continue;
-
 		qc = ata_qc_from_tag(ap, ap->link.active_tag);
 		if (qc) {
 			if (!(qc->tf.flags & ATA_TFLAG_POLLING))
@@ -1862,11 +1702,8 @@ void ata_sff_lost_interrupt(struct ata_port *ap)
 
 	/* Only one outstanding command per SFF channel */
 	qc = ata_qc_from_tag(ap, ap->link.active_tag);
-	/* Check we have a live one.. */
-	if (qc == NULL ||  !(qc->flags & ATA_QCFLAG_ACTIVE))
-		return;
-	/* We cannot lose an interrupt on a polled command */
-	if (qc->tf.flags & ATA_TFLAG_POLLING)
+	/* We cannot lose an interrupt on a non-existent or polled command */
+	if (!qc || qc->tf.flags & ATA_TFLAG_POLLING)
 		return;
 	/* See if the controller thinks it is still busy - if so the command
 	   isn't a lost IRQ but is still in progress */
@@ -1888,20 +1725,18 @@ EXPORT_SYMBOL_GPL(ata_sff_lost_interrupt);
  *	ata_sff_freeze - Freeze SFF controller port
  *	@ap: port to freeze
  *
- *	Freeze BMDMA controller port.
+ *	Freeze SFF controller port.
  *
  *	LOCKING:
  *	Inherited from caller.
  */
 void ata_sff_freeze(struct ata_port *ap)
 {
-	struct ata_ioports *ioaddr = &ap->ioaddr;
-
 	ap->ctl |= ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
-	if (ioaddr->ctl_addr)
-		iowrite8(ap->ctl, ioaddr->ctl_addr);
+	if (ap->ops->sff_set_devctl || ap->ioaddr.ctl_addr)
+		ata_sff_set_devctl(ap, ap->ctl);
 
 	/* Under certain circumstances, some controllers raise IRQ on
 	 * ATA_NIEN manipulation.  Also, many controllers fail to mask
@@ -1927,7 +1762,7 @@ void ata_sff_thaw(struct ata_port *ap)
 	/* clear & re-enable interrupts */
 	ap->ops->sff_check_status(ap);
 	ap->ops->sff_irq_clear(ap);
-	ap->ops->sff_irq_on(ap);
+	ata_sff_irq_on(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sff_thaw);
 
@@ -2301,8 +2136,8 @@ void ata_sff_postreset(struct ata_link *link, unsigned int *classes)
 	}
 
 	/* set up device control */
-	if (ap->ioaddr.ctl_addr) {
-		iowrite8(ap->ctl, ap->ioaddr.ctl_addr);
+	if (ap->ops->sff_set_devctl || ap->ioaddr.ctl_addr) {
+		ata_sff_set_devctl(ap, ap->ctl);
 		ap->last_ctl = ap->ctl;
 	}
 }
@@ -2342,7 +2177,7 @@ void ata_sff_drain_fifo(struct ata_queued_cmd *qc)
 EXPORT_SYMBOL_GPL(ata_sff_drain_fifo);
 
 /**
- *	ata_sff_error_handler - Stock error handler for BMDMA controller
+ *	ata_sff_error_handler - Stock error handler for SFF controller
  *	@ap: port to handle error for
  *
  *	Stock error handler for SFF controller.  It can handle both
@@ -2359,62 +2194,32 @@ void ata_sff_error_handler(struct ata_port *ap)
 	ata_reset_fn_t hardreset = ap->ops->hardreset;
 	struct ata_queued_cmd *qc;
 	unsigned long flags;
-	int thaw = 0;
 
 	qc = __ata_qc_from_tag(ap, ap->link.active_tag);
 	if (qc && !(qc->flags & ATA_QCFLAG_FAILED))
 		qc = NULL;
 
-	/* reset PIO HSM and stop DMA engine */
 	spin_lock_irqsave(ap->lock, flags);
 
-	ap->hsm_task_state = HSM_ST_IDLE;
-
-	if (ap->ioaddr.bmdma_addr &&
-	    qc && (qc->tf.protocol == ATA_PROT_DMA ||
-		   qc->tf.protocol == ATAPI_PROT_DMA)) {
-		u8 host_stat;
-
-		host_stat = ap->ops->bmdma_status(ap);
-
-		/* BMDMA controllers indicate host bus error by
-		 * setting DMA_ERR bit and timing out.  As it wasn't
-		 * really a timeout event, adjust error mask and
-		 * cancel frozen state.
-		 */
-		if (qc->err_mask == AC_ERR_TIMEOUT
-						&& (host_stat & ATA_DMA_ERR)) {
-			qc->err_mask = AC_ERR_HOST_BUS;
-			thaw = 1;
-		}
-
-		ap->ops->bmdma_stop(qc);
-	}
-
-	ata_sff_sync(ap);		/* FIXME: We don't need this */
-	ap->ops->sff_check_status(ap);
-	ap->ops->sff_irq_clear(ap);
-	/* We *MUST* do FIFO draining before we issue a reset as several
-	 * devices helpfully clear their internal state and will lock solid
-	 * if we touch the data port post reset. Pass qc in case anyone wants
-	 *  to do different PIO/DMA recovery or has per command fixups
+	/*
+	 * We *MUST* do FIFO draining before we issue a reset as
+	 * several devices helpfully clear their internal state and
+	 * will lock solid if we touch the data port post reset. Pass
+	 * qc in case anyone wants to do different PIO/DMA recovery or
+	 * has per command fixups
 	 */
-	if (ap->ops->drain_fifo)
-		ap->ops->drain_fifo(qc);
+	if (ap->ops->sff_drain_fifo)
+		ap->ops->sff_drain_fifo(qc);
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (thaw)
-		ata_eh_thaw_port(ap);
-
-	/* PIO and DMA engines have been stopped, perform recovery */
-
-	/* Ignore ata_sff_softreset if ctl isn't accessible and
-	 * built-in hardresets if SCR access isn't available.
-	 */
+	/* ignore ata_sff_softreset if ctl isn't accessible */
 	if (softreset == ata_sff_softreset && !ap->ioaddr.ctl_addr)
 		softreset = NULL;
-	if (ata_is_builtin_hardreset(hardreset) && !sata_scr_valid(&ap->link))
+
+	/* ignore built-in hardresets if SCR access is not available */
+	if ((hardreset == sata_std_hardreset ||
+	     hardreset == sata_sff_hardreset) && !sata_scr_valid(&ap->link))
 		hardreset = NULL;
 
 	ata_do_eh(ap, ap->ops->prereset, softreset, hardreset,
@@ -2423,73 +2228,6 @@ void ata_sff_error_handler(struct ata_port *ap)
 EXPORT_SYMBOL_GPL(ata_sff_error_handler);
 
 /**
- *	ata_sff_post_internal_cmd - Stock post_internal_cmd for SFF controller
- *	@qc: internal command to clean up
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- */
-void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	unsigned long flags;
-
-	spin_lock_irqsave(ap->lock, flags);
-
-	ap->hsm_task_state = HSM_ST_IDLE;
-
-	if (ap->ioaddr.bmdma_addr)
-		ap->ops->bmdma_stop(qc);
-
-	spin_unlock_irqrestore(ap->lock, flags);
-}
-EXPORT_SYMBOL_GPL(ata_sff_post_internal_cmd);
-
-/**
- *	ata_sff_port_start - Set port up for dma.
- *	@ap: Port to initialize
- *
- *	Called just after data structures for each port are
- *	initialized.  Allocates space for PRD table if the device
- *	is DMA capable SFF.
- *
- *	May be used as the port_start() entry in ata_port_operations.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-int ata_sff_port_start(struct ata_port *ap)
-{
-	if (ap->ioaddr.bmdma_addr)
-		return ata_port_start(ap);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ata_sff_port_start);
-
-/**
- *	ata_sff_port_start32 - Set port up for dma.
- *	@ap: Port to initialize
- *
- *	Called just after data structures for each port are
- *	initialized.  Allocates space for PRD table if the device
- *	is DMA capable SFF.
- *
- *	May be used as the port_start() entry in ata_port_operations for
- *	devices that are capable of 32bit PIO.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-int ata_sff_port_start32(struct ata_port *ap)
-{
-	ap->pflags |= ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE;
-	if (ap->ioaddr.bmdma_addr)
-		return ata_port_start(ap);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ata_sff_port_start32);
-
-/**
  *	ata_sff_std_ports - initialize ioaddr with standard port offsets.
  *	@ioaddr: IO address structure to be initialized
  *
@@ -2515,302 +2253,8 @@ void ata_sff_std_ports(struct ata_ioports *ioaddr)
 }
 EXPORT_SYMBOL_GPL(ata_sff_std_ports);
 
-unsigned long ata_bmdma_mode_filter(struct ata_device *adev,
-				    unsigned long xfer_mask)
-{
-	/* Filter out DMA modes if the device has been configured by
-	   the BIOS as PIO only */
-
-	if (adev->link->ap->ioaddr.bmdma_addr == NULL)
-		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
-	return xfer_mask;
-}
-EXPORT_SYMBOL_GPL(ata_bmdma_mode_filter);
-
-/**
- *	ata_bmdma_setup - Set up PCI IDE BMDMA transaction
- *	@qc: Info associated with this ATA transaction.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_bmdma_setup(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
-	u8 dmactl;
-
-	/* load PRD table addr. */
-	mb();	/* make sure PRD table writes are visible to controller */
-	iowrite32(ap->prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
-
-	/* specify data direction, triple-check start bit is clear */
-	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	dmactl &= ~(ATA_DMA_WR | ATA_DMA_START);
-	if (!rw)
-		dmactl |= ATA_DMA_WR;
-	iowrite8(dmactl, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	/* issue r/w command */
-	ap->ops->sff_exec_command(ap, &qc->tf);
-}
-EXPORT_SYMBOL_GPL(ata_bmdma_setup);
-
-/**
- *	ata_bmdma_start - Start a PCI IDE BMDMA transaction
- *	@qc: Info associated with this ATA transaction.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_bmdma_start(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	u8 dmactl;
-
-	/* start host DMA transaction */
-	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	/* Strictly, one may wish to issue an ioread8() here, to
-	 * flush the mmio write.  However, control also passes
-	 * to the hardware at this point, and it will interrupt
-	 * us when we are to resume control.  So, in effect,
-	 * we don't care when the mmio write flushes.
-	 * Further, a read of the DMA status register _immediately_
-	 * following the write may not be what certain flaky hardware
-	 * is expected, so I think it is best to not add a readb()
-	 * without first all the MMIO ATA cards/mobos.
-	 * Or maybe I'm just being paranoid.
-	 *
-	 * FIXME: The posting of this write means I/O starts are
-	 * unneccessarily delayed for MMIO
-	 */
-}
-EXPORT_SYMBOL_GPL(ata_bmdma_start);
-
-/**
- *	ata_bmdma_stop - Stop PCI IDE BMDMA transfer
- *	@qc: Command we are ending DMA for
- *
- *	Clears the ATA_DMA_START flag in the dma control register
- *
- *	May be used as the bmdma_stop() entry in ata_port_operations.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_bmdma_stop(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	void __iomem *mmio = ap->ioaddr.bmdma_addr;
-
-	/* clear start/stop bit */
-	iowrite8(ioread8(mmio + ATA_DMA_CMD) & ~ATA_DMA_START,
-		 mmio + ATA_DMA_CMD);
-
-	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_dma_pause(ap);
-}
-EXPORT_SYMBOL_GPL(ata_bmdma_stop);
-
-/**
- *	ata_bmdma_status - Read PCI IDE BMDMA status
- *	@ap: Port associated with this ATA transaction.
- *
- *	Read and return BMDMA status register.
- *
- *	May be used as the bmdma_status() entry in ata_port_operations.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-u8 ata_bmdma_status(struct ata_port *ap)
-{
-	return ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
-}
-EXPORT_SYMBOL_GPL(ata_bmdma_status);
-
-/**
- *	ata_bus_reset - reset host port and associated ATA channel
- *	@ap: port to reset
- *
- *	This is typically the first time we actually start issuing
- *	commands to the ATA channel.  We wait for BSY to clear, then
- *	issue EXECUTE DEVICE DIAGNOSTIC command, polling for its
- *	result.  Determine what devices, if any, are on the channel
- *	by looking at the device 0/1 error register.  Look at the signature
- *	stored in each device's taskfile registers, to determine if
- *	the device is ATA or ATAPI.
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *	Obtains host lock.
- *
- *	SIDE EFFECTS:
- *	Sets ATA_FLAG_DISABLED if bus reset fails.
- *
- *	DEPRECATED:
- *	This function is only for drivers which still use old EH and
- *	will be removed soon.
- */
-void ata_bus_reset(struct ata_port *ap)
-{
-	struct ata_device *device = ap->link.device;
-	struct ata_ioports *ioaddr = &ap->ioaddr;
-	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
-	u8 err;
-	unsigned int dev0, dev1 = 0, devmask = 0;
-	int rc;
-
-	DPRINTK("ENTER, host %u, port %u\n", ap->print_id, ap->port_no);
-
-	/* determine if device 0/1 are present */
-	if (ap->flags & ATA_FLAG_SATA_RESET)
-		dev0 = 1;
-	else {
-		dev0 = ata_devchk(ap, 0);
-		if (slave_possible)
-			dev1 = ata_devchk(ap, 1);
-	}
-
-	if (dev0)
-		devmask |= (1 << 0);
-	if (dev1)
-		devmask |= (1 << 1);
-
-	/* select device 0 again */
-	ap->ops->sff_dev_select(ap, 0);
-
-	/* issue bus reset */
-	if (ap->flags & ATA_FLAG_SRST) {
-		rc = ata_bus_softreset(ap, devmask,
-				       ata_deadline(jiffies, 40000));
-		if (rc && rc != -ENODEV)
-			goto err_out;
-	}
-
-	/*
-	 * determine by signature whether we have ATA or ATAPI devices
-	 */
-	device[0].class = ata_sff_dev_classify(&device[0], dev0, &err);
-	if ((slave_possible) && (err != 0x81))
-		device[1].class = ata_sff_dev_classify(&device[1], dev1, &err);
-
-	/* is double-select really necessary? */
-	if (device[1].class != ATA_DEV_NONE)
-		ap->ops->sff_dev_select(ap, 1);
-	if (device[0].class != ATA_DEV_NONE)
-		ap->ops->sff_dev_select(ap, 0);
-
-	/* if no devices were detected, disable this port */
-	if ((device[0].class == ATA_DEV_NONE) &&
-	    (device[1].class == ATA_DEV_NONE))
-		goto err_out;
-
-	if (ap->flags & (ATA_FLAG_SATA_RESET | ATA_FLAG_SRST)) {
-		/* set up device control for ATA_FLAG_SATA_RESET */
-		iowrite8(ap->ctl, ioaddr->ctl_addr);
-		ap->last_ctl = ap->ctl;
-	}
-
-	DPRINTK("EXIT\n");
-	return;
-
-err_out:
-	ata_port_printk(ap, KERN_ERR, "disabling port\n");
-	ata_port_disable(ap);
-
-	DPRINTK("EXIT\n");
-}
-EXPORT_SYMBOL_GPL(ata_bus_reset);
-
 #ifdef CONFIG_PCI
 
-/**
- *	ata_pci_bmdma_clear_simplex -	attempt to kick device out of simplex
- *	@pdev: PCI device
- *
- *	Some PCI ATA devices report simplex mode but in fact can be told to
- *	enter non simplex mode. This implements the necessary logic to
- *	perform the task on such devices. Calling it on other devices will
- *	have -undefined- behaviour.
- */
-int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev)
-{
-	unsigned long bmdma = pci_resource_start(pdev, 4);
-	u8 simplex;
-
-	if (bmdma == 0)
-		return -ENOENT;
-
-	simplex = inb(bmdma + 0x02);
-	outb(simplex & 0x60, bmdma + 0x02);
-	simplex = inb(bmdma + 0x02);
-	if (simplex & 0x80)
-		return -EOPNOTSUPP;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ata_pci_bmdma_clear_simplex);
-
-/**
- *	ata_pci_bmdma_init - acquire PCI BMDMA resources and init ATA host
- *	@host: target ATA host
- *
- *	Acquire PCI BMDMA resources and initialize @host accordingly.
- *
- *	LOCKING:
- *	Inherited from calling layer (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno otherwise.
- */
-int ata_pci_bmdma_init(struct ata_host *host)
-{
-	struct device *gdev = host->dev;
-	struct pci_dev *pdev = to_pci_dev(gdev);
-	int i, rc;
-
-	/* No BAR4 allocation: No DMA */
-	if (pci_resource_start(pdev, 4) == 0)
-		return 0;
-
-	/* TODO: If we get no DMA mask we should fall back to PIO */
-	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
-	if (rc)
-		return rc;
-	rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
-	if (rc)
-		return rc;
-
-	/* request and iomap DMA region */
-	rc = pcim_iomap_regions(pdev, 1 << 4, dev_driver_string(gdev));
-	if (rc) {
-		dev_printk(KERN_ERR, gdev, "failed to request/iomap BAR4\n");
-		return -ENOMEM;
-	}
-	host->iomap = pcim_iomap_table(pdev);
-
-	for (i = 0; i < 2; i++) {
-		struct ata_port *ap = host->ports[i];
-		void __iomem *bmdma = host->iomap[4] + 8 * i;
-
-		if (ata_port_is_dummy(ap))
-			continue;
-
-		ap->ioaddr.bmdma_addr = bmdma;
-		if ((!(ap->flags & ATA_FLAG_IGN_SIMPLEX)) &&
-		    (ioread8(bmdma + 2) & 0x80))
-			host->flags |= ATA_HOST_SIMPLEX;
-
-		ata_port_desc(ap, "bmdma 0x%llx",
-		    (unsigned long long)pci_resource_start(pdev, 4) + 8 * i);
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
-
 static int ata_resources_present(struct pci_dev *pdev, int port)
 {
 	int i;
@@ -2942,21 +2386,12 @@ int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 		goto err_out;
 
 	/* init DMA related stuff */
-	rc = ata_pci_bmdma_init(host);
-	if (rc)
-		goto err_bmdma;
+	ata_pci_bmdma_init(host);
 
 	devres_remove_group(&pdev->dev, NULL);
 	*r_host = host;
 	return 0;
 
-err_bmdma:
-	/* This is necessary because PCI and iomap resources are
-	 * merged and releasing the top group won't release the
-	 * acquired resources if some of those have been acquired
-	 * before entering this function.
-	 */
-	pcim_iounmap_regions(pdev, 0xf);
 err_out:
 	devres_release_group(&pdev->dev, NULL);
 	return rc;
@@ -3135,3 +2570,609 @@ out:
 EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 
 #endif /* CONFIG_PCI */
+
+const struct ata_port_operations ata_bmdma_port_ops = {
+	.inherits		= &ata_sff_port_ops,
+
+	.error_handler		= ata_bmdma_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+
+	.qc_prep		= ata_bmdma_qc_prep,
+	.qc_issue		= ata_bmdma_qc_issue,
+
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+
+	.port_start		= ata_bmdma_port_start,
+};
+EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
+
+const struct ata_port_operations ata_bmdma32_port_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+
+	.sff_data_xfer		= ata_sff_data_xfer32,
+	.port_start		= ata_bmdma_port_start32,
+};
+EXPORT_SYMBOL_GPL(ata_bmdma32_port_ops);
+
+/**
+ *	ata_bmdma_fill_sg - Fill PCI IDE PRD table
+ *	@qc: Metadata associated with taskfile to be transferred
+ *
+ *	Fill PCI IDE PRD (scatter-gather) table with segments
+ *	associated with the current disk command.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ */
+static void ata_bmdma_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_bmdma_prd *prd = ap->bmdma_prd;
+	struct scatterlist *sg;
+	unsigned int si, pi;
+
+	pi = 0;
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		u32 addr, offset;
+		u32 sg_len, len;
+
+		/* determine if physical DMA addr spans 64K boundary.
+		 * Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		addr = (u32) sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		while (sg_len) {
+			offset = addr & 0xffff;
+			len = sg_len;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			prd[pi].addr = cpu_to_le32(addr);
+			prd[pi].flags_len = cpu_to_le32(len & 0xffff);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
+
+			pi++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+}
+
+/**
+ *	ata_bmdma_fill_sg_dumb - Fill PCI IDE PRD table
+ *	@qc: Metadata associated with taskfile to be transferred
+ *
+ *	Fill PCI IDE PRD (scatter-gather) table with segments
+ *	associated with the current disk command. Perform the fill
+ *	so that we avoid writing any length 64K records for
+ *	controllers that don't follow the spec.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ */
+static void ata_bmdma_fill_sg_dumb(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_bmdma_prd *prd = ap->bmdma_prd;
+	struct scatterlist *sg;
+	unsigned int si, pi;
+
+	pi = 0;
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		u32 addr, offset;
+		u32 sg_len, len, blen;
+
+		/* determine if physical DMA addr spans 64K boundary.
+		 * Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		addr = (u32) sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		while (sg_len) {
+			offset = addr & 0xffff;
+			len = sg_len;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			blen = len & 0xffff;
+			prd[pi].addr = cpu_to_le32(addr);
+			if (blen == 0) {
+				/* Some PATA chipsets like the CS5530 can't
+				   cope with 0x0000 meaning 64K as the spec
+				   says */
+				prd[pi].flags_len = cpu_to_le32(0x8000);
+				blen = 0x8000;
+				prd[++pi].addr = cpu_to_le32(addr + 0x8000);
+			}
+			prd[pi].flags_len = cpu_to_le32(blen);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
+
+			pi++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+}
+
+/**
+ *	ata_bmdma_qc_prep - Prepare taskfile for submission
+ *	@qc: Metadata associated with taskfile to be prepared
+ *
+ *	Prepare ATA taskfile for submission.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	ata_bmdma_fill_sg(qc);
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_qc_prep);
+
+/**
+ *	ata_bmdma_dumb_qc_prep - Prepare taskfile for submission
+ *	@qc: Metadata associated with taskfile to be prepared
+ *
+ *	Prepare ATA taskfile for submission.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	ata_bmdma_fill_sg_dumb(qc);
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_dumb_qc_prep);
+
+/**
+ *	ata_bmdma_qc_issue - issue taskfile to a BMDMA controller
+ *	@qc: command to issue to device
+ *
+ *	This function issues a PIO, NODATA or DMA command to a
+ *	SFF/BMDMA controller.  PIO and NODATA are handled by
+ *	ata_sff_qc_issue().
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	Zero on success, AC_ERR_* mask on failure
+ */
+unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+
+	/* see ata_dma_blacklisted() */
+	BUG_ON((ap->flags & ATA_FLAG_PIO_POLLING) &&
+	       qc->tf.protocol == ATAPI_PROT_DMA);
+
+	/* defer PIO handling to sff_qc_issue */
+	if (!ata_is_dma(qc->tf.protocol))
+		return ata_sff_qc_issue(qc);
+
+	/* select the device */
+	ata_dev_select(ap, qc->dev->devno, 1, 0);
+
+	/* start the command */
+	switch (qc->tf.protocol) {
+	case ATA_PROT_DMA:
+		WARN_ON_ONCE(qc->tf.flags & ATA_TFLAG_POLLING);
+
+		ap->ops->sff_tf_load(ap, &qc->tf);  /* load tf registers */
+		ap->ops->bmdma_setup(qc);	    /* set up bmdma */
+		ap->ops->bmdma_start(qc);	    /* initiate bmdma */
+		ap->hsm_task_state = HSM_ST_LAST;
+		break;
+
+	case ATAPI_PROT_DMA:
+		WARN_ON_ONCE(qc->tf.flags & ATA_TFLAG_POLLING);
+
+		ap->ops->sff_tf_load(ap, &qc->tf);  /* load tf registers */
+		ap->ops->bmdma_setup(qc);	    /* set up bmdma */
+		ap->hsm_task_state = HSM_ST_FIRST;
+
+		/* send cdb by polling if no cdb interrupt */
+		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
+			ata_sff_queue_pio_task(ap, 0);
+		break;
+
+	default:
+		WARN_ON(1);
+		return AC_ERR_SYSTEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_qc_issue);
+
+/**
+ *	ata_bmdma_error_handler - Stock error handler for BMDMA controller
+ *	@ap: port to handle error for
+ *
+ *	Stock error handler for BMDMA controller.  It can handle both
+ *	PATA and SATA controllers.  Most BMDMA controllers should be
+ *	able to use this EH as-is or with some added handling before
+ *	and after.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ */
+void ata_bmdma_error_handler(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+	unsigned long flags;
+	bool thaw = false;
+
+	qc = __ata_qc_from_tag(ap, ap->link.active_tag);
+	if (qc && !(qc->flags & ATA_QCFLAG_FAILED))
+		qc = NULL;
+
+	/* reset PIO HSM and stop DMA engine */
+	spin_lock_irqsave(ap->lock, flags);
+
+	if (qc && ata_is_dma(qc->tf.protocol)) {
+		u8 host_stat;
+
+		host_stat = ap->ops->bmdma_status(ap);
+
+		/* BMDMA controllers indicate host bus error by
+		 * setting DMA_ERR bit and timing out.  As it wasn't
+		 * really a timeout event, adjust error mask and
+		 * cancel frozen state.
+		 */
+		if (qc->err_mask == AC_ERR_TIMEOUT && (host_stat & ATA_DMA_ERR)) {
+			qc->err_mask = AC_ERR_HOST_BUS;
+			thaw = true;
+		}
+
+		ap->ops->bmdma_stop(qc);
+
+		/* if we're gonna thaw, make sure IRQ is clear */
+		if (thaw) {
+			ap->ops->sff_check_status(ap);
+			ap->ops->sff_irq_clear(ap);
+		}
+	}
+
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	if (thaw)
+		ata_eh_thaw_port(ap);
+
+	ata_sff_error_handler(ap);
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_error_handler);
+
+/**
+ *	ata_bmdma_post_internal_cmd - Stock post_internal_cmd for BMDMA
+ *	@qc: internal command to clean up
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ */
+void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	unsigned long flags;
+
+	if (ata_is_dma(qc->tf.protocol)) {
+		spin_lock_irqsave(ap->lock, flags);
+		ap->ops->bmdma_stop(qc);
+		spin_unlock_irqrestore(ap->lock, flags);
+	}
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_post_internal_cmd);
+
+/**
+ *	ata_bmdma_setup - Set up PCI IDE BMDMA transaction
+ *	@qc: Info associated with this ATA transaction.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_setup(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
+	u8 dmactl;
+
+	/* load PRD table addr. */
+	mb();	/* make sure PRD table writes are visible to controller */
+	iowrite32(ap->bmdma_prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
+
+	/* specify data direction, triple-check start bit is clear */
+	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+	dmactl &= ~(ATA_DMA_WR | ATA_DMA_START);
+	if (!rw)
+		dmactl |= ATA_DMA_WR;
+	iowrite8(dmactl, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+
+	/* issue r/w command */
+	ap->ops->sff_exec_command(ap, &qc->tf);
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_setup);
+
+/**
+ *	ata_bmdma_start - Start a PCI IDE BMDMA transaction
+ *	@qc: Info associated with this ATA transaction.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_start(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	u8 dmactl;
+
+	/* start host DMA transaction */
+	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+
+	/* Strictly, one may wish to issue an ioread8() here, to
+	 * flush the mmio write.  However, control also passes
+	 * to the hardware at this point, and it will interrupt
+	 * us when we are to resume control.  So, in effect,
+	 * we don't care when the mmio write flushes.
+	 * Further, a read of the DMA status register _immediately_
+	 * following the write may not be what certain flaky hardware
+	 * is expected, so I think it is best to not add a readb()
+	 * without first all the MMIO ATA cards/mobos.
+	 * Or maybe I'm just being paranoid.
+	 *
+	 * FIXME: The posting of this write means I/O starts are
+	 * unneccessarily delayed for MMIO
+	 */
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_start);
+
+/**
+ *	ata_bmdma_stop - Stop PCI IDE BMDMA transfer
+ *	@qc: Command we are ending DMA for
+ *
+ *	Clears the ATA_DMA_START flag in the dma control register
+ *
+ *	May be used as the bmdma_stop() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_stop(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *mmio = ap->ioaddr.bmdma_addr;
+
+	/* clear start/stop bit */
+	iowrite8(ioread8(mmio + ATA_DMA_CMD) & ~ATA_DMA_START,
+		 mmio + ATA_DMA_CMD);
+
+	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
+	ata_sff_dma_pause(ap);
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_stop);
+
+/**
+ *	ata_bmdma_status - Read PCI IDE BMDMA status
+ *	@ap: Port associated with this ATA transaction.
+ *
+ *	Read and return BMDMA status register.
+ *
+ *	May be used as the bmdma_status() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+u8 ata_bmdma_status(struct ata_port *ap)
+{
+	return ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_status);
+
+
+/**
+ *	ata_bmdma_port_start - Set port up for bmdma.
+ *	@ap: Port to initialize
+ *
+ *	Called just after data structures for each port are
+ *	initialized.  Allocates space for PRD table.
+ *
+ *	May be used as the port_start() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+int ata_bmdma_port_start(struct ata_port *ap)
+{
+	if (ap->mwdma_mask || ap->udma_mask) {
+		ap->bmdma_prd =
+			dmam_alloc_coherent(ap->host->dev, ATA_PRD_TBL_SZ,
+					    &ap->bmdma_prd_dma, GFP_KERNEL);
+		if (!ap->bmdma_prd)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_port_start);
+
+/**
+ *	ata_bmdma_port_start32 - Set port up for dma.
+ *	@ap: Port to initialize
+ *
+ *	Called just after data structures for each port are
+ *	initialized.  Enables 32bit PIO and allocates space for PRD
+ *	table.
+ *
+ *	May be used as the port_start() entry in ata_port_operations for
+ *	devices that are capable of 32bit PIO.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+int ata_bmdma_port_start32(struct ata_port *ap)
+{
+	ap->pflags |= ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE;
+	return ata_bmdma_port_start(ap);
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_port_start32);
+
+#ifdef CONFIG_PCI
+
+/**
+ *	ata_pci_bmdma_clear_simplex -	attempt to kick device out of simplex
+ *	@pdev: PCI device
+ *
+ *	Some PCI ATA devices report simplex mode but in fact can be told to
+ *	enter non simplex mode. This implements the necessary logic to
+ *	perform the task on such devices. Calling it on other devices will
+ *	have -undefined- behaviour.
+ */
+int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev)
+{
+	unsigned long bmdma = pci_resource_start(pdev, 4);
+	u8 simplex;
+
+	if (bmdma == 0)
+		return -ENOENT;
+
+	simplex = inb(bmdma + 0x02);
+	outb(simplex & 0x60, bmdma + 0x02);
+	simplex = inb(bmdma + 0x02);
+	if (simplex & 0x80)
+		return -EOPNOTSUPP;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_pci_bmdma_clear_simplex);
+
+static void ata_bmdma_nodma(struct ata_host *host, const char *reason)
+{
+	int i;
+
+	dev_printk(KERN_ERR, host->dev, "BMDMA: %s, falling back to PIO\n",
+		   reason);
+
+	for (i = 0; i < 2; i++) {
+		host->ports[i]->mwdma_mask = 0;
+		host->ports[i]->udma_mask = 0;
+	}
+}
+
+/**
+ *	ata_pci_bmdma_init - acquire PCI BMDMA resources and init ATA host
+ *	@host: target ATA host
+ *
+ *	Acquire PCI BMDMA resources and initialize @host accordingly.
+ *
+ *	LOCKING:
+ *	Inherited from calling layer (may sleep).
+ */
+void ata_pci_bmdma_init(struct ata_host *host)
+{
+	struct device *gdev = host->dev;
+	struct pci_dev *pdev = to_pci_dev(gdev);
+	int i, rc;
+
+	/* No BAR4 allocation: No DMA */
+	if (pci_resource_start(pdev, 4) == 0) {
+		ata_bmdma_nodma(host, "BAR4 is zero");
+		return;
+	}
+
+	/*
+	 * Some controllers require BMDMA region to be initialized
+	 * even if DMA is not in use to clear IRQ status via
+	 * ->sff_irq_clear method.  Try to initialize bmdma_addr
+	 * regardless of dma masks.
+	 */
+	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		ata_bmdma_nodma(host, "failed to set dma mask");
+	if (!rc) {
+		rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
+		if (rc)
+			ata_bmdma_nodma(host,
+					"failed to set consistent dma mask");
+	}
+
+	/* request and iomap DMA region */
+	rc = pcim_iomap_regions(pdev, 1 << 4, dev_driver_string(gdev));
+	if (rc) {
+		ata_bmdma_nodma(host, "failed to request/iomap BAR4");
+		return;
+	}
+	host->iomap = pcim_iomap_table(pdev);
+
+	for (i = 0; i < 2; i++) {
+		struct ata_port *ap = host->ports[i];
+		void __iomem *bmdma = host->iomap[4] + 8 * i;
+
+		if (ata_port_is_dummy(ap))
+			continue;
+
+		ap->ioaddr.bmdma_addr = bmdma;
+		if ((!(ap->flags & ATA_FLAG_IGN_SIMPLEX)) &&
+		    (ioread8(bmdma + 2) & 0x80))
+			host->flags |= ATA_HOST_SIMPLEX;
+
+		ata_port_desc(ap, "bmdma 0x%llx",
+		    (unsigned long long)pci_resource_start(pdev, 4) + 8 * i);
+	}
+}
+EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
+
+#endif /* CONFIG_PCI */
+
+/**
+ *	ata_sff_port_init - Initialize SFF/BMDMA ATA port
+ *	@ap: Port to initialize
+ *
+ *	Called on port allocation to initialize SFF/BMDMA specific
+ *	fields.
+ *
+ *	LOCKING:
+ *	None.
+ */
+void ata_sff_port_init(struct ata_port *ap)
+{
+	INIT_DELAYED_WORK(&ap->sff_pio_task, ata_sff_pio_task);
+	ap->ctl = ATA_DEVCTL_OBS;
+	ap->last_ctl = 0xFF;
+}
+
+int __init ata_sff_init(void)
+{
+	/*
+	 * FIXME: In UP case, there is only one workqueue thread and if you
+	 * have more than one PIO device, latency is bloody awful, with
+	 * occasional multi-second "hiccups" as one PIO device waits for
+	 * another.  It's an ugly wart that users DO occasionally complain
+	 * about; luckily most users have at most one PIO polled device.
+	 */
+	ata_sff_wq = create_workqueue("ata_sff");
+	if (!ata_sff_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void __exit ata_sff_exit(void)
+{
+	destroy_workqueue(ata_sff_wq);
+}
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 823e630..4b84ed6 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -38,17 +38,6 @@ struct ata_scsi_args {
 	void			(*done)(struct scsi_cmnd *);
 };
 
-static inline int ata_is_builtin_hardreset(ata_reset_fn_t reset)
-{
-	if (reset == sata_std_hardreset)
-		return 1;
-#ifdef CONFIG_ATA_SFF
-	if (reset == sata_sff_hardreset)
-		return 1;
-#endif
-	return 0;
-}
-
 /* libata-core.c */
 enum {
 	/* flags for ata_dev_read_id() */
@@ -79,7 +68,6 @@ extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
 			   unsigned int tag);
 extern u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev);
-extern void ata_port_flush_task(struct ata_port *ap);
 extern unsigned ata_exec_internal(struct ata_device *dev,
 				  struct ata_taskfile *tf, const u8 *cdb,
 				  int dma_dir, void *buf, unsigned int buflen,
@@ -202,10 +190,19 @@ static inline int sata_pmp_attach(struct ata_device *dev)
 
 /* libata-sff.c */
 #ifdef CONFIG_ATA_SFF
-extern void ata_dev_select(struct ata_port *ap, unsigned int device,
-                           unsigned int wait, unsigned int can_sleep);
-extern u8 ata_irq_on(struct ata_port *ap);
-extern void ata_pio_task(struct work_struct *work);
+extern void ata_sff_flush_pio_task(struct ata_port *ap);
+extern void ata_sff_port_init(struct ata_port *ap);
+extern int ata_sff_init(void);
+extern void ata_sff_exit(void);
+#else /* CONFIG_ATA_SFF */
+static inline void ata_sff_flush_pio_task(struct ata_port *ap)
+{ }
+static inline void ata_sff_port_init(struct ata_port *ap)
+{ }
+static inline int ata_sff_init(void)
+{ return 0; }
+static inline void ata_sff_exit(void)
+{ }
 #endif /* CONFIG_ATA_SFF */
 
 #endif /* __LIBATA_H__ */
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 1ea2be0..066b9f3 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -101,7 +101,7 @@ static unsigned long pacpi_discover_modes(struct ata_port *ap, struct ata_device
 static unsigned long pacpi_mode_filter(struct ata_device *adev, unsigned long mask)
 {
 	struct pata_acpi *acpi = adev->link->ap->private_data;
-	return ata_bmdma_mode_filter(adev, mask & acpi->mask[adev->devno]);
+	return mask & acpi->mask[adev->devno];
 }
 
 /**
@@ -172,7 +172,7 @@ static unsigned int pacpi_qc_issue(struct ata_queued_cmd *qc)
 	struct pata_acpi *acpi = ap->private_data;
 
 	if (acpi->gtm.flags & 0x10)
-		return ata_sff_qc_issue(qc);
+		return ata_bmdma_qc_issue(qc);
 
 	if (adev != acpi->last) {
 		pacpi_set_piomode(ap, adev);
@@ -180,7 +180,7 @@ static unsigned int pacpi_qc_issue(struct ata_queued_cmd *qc)
 			pacpi_set_dmamode(ap, adev);
 		acpi->last = adev;
 	}
-	return ata_sff_qc_issue(qc);
+	return ata_bmdma_qc_issue(qc);
 }
 
 /**
@@ -205,7 +205,7 @@ static int pacpi_port_start(struct ata_port *ap)
 		return -ENOMEM;
 	acpi->mask[0] = pacpi_discover_modes(ap, &ap->link.device[0]);
 	acpi->mask[1] = pacpi_discover_modes(ap, &ap->link.device[1]);
-	ret = ata_sff_port_start(ap);
+	ret = ata_bmdma_port_start(ap);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index dc61b72..f306e10 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -124,7 +124,7 @@ static unsigned long ali_20_filter(struct ata_device *adev, unsigned long mask)
 	ata_id_c_string(adev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 	if (strstr(model_num, "WDC"))
 		return mask &= ~ATA_MASK_UDMA;
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index c6a946a..0da0dcc 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -202,7 +202,6 @@ static struct ata_port_operations pata_at91_port_ops = {
 	.sff_data_xfer	= pata_at91_data_xfer_noirq,
 	.set_piomode	= pata_at91_set_piomode,
 	.cable_detect	= ata_cable_40wire,
-	.port_start	= ATA_OP_NULL,
 };
 
 static int __devinit pata_at91_probe(struct platform_device *pdev)
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index cbaf2ed..44d88b3 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -217,7 +217,7 @@ static struct scsi_host_template atiixp_sht = {
 static struct ata_port_operations atiixp_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
-	.qc_prep 	= ata_sff_dumb_qc_prep,
+	.qc_prep 	= ata_bmdma_dumb_qc_prep,
 	.bmdma_start 	= atiixp_bmdma_start,
 	.bmdma_stop	= atiixp_bmdma_stop,
 
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 02c81f1..6422cfd 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -821,6 +821,18 @@ static void bfin_dev_select(struct ata_port *ap, unsigned int device)
 }
 
 /**
+ *	bfin_set_devctl - Write device control reg
+ *	@ap: port where the device is
+ *	@ctl: value to write
+ */
+
+static u8 bfin_set_devctl(struct ata_port *ap, u8 ctl)
+{
+	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
+	write_atapi_register(base, ATA_REG_CTRL, ctl);
+}
+
+/**
  *	bfin_bmdma_setup - Set up IDE DMA transaction
  *	@qc: Info associated with this ATA transaction.
  *
@@ -1216,56 +1228,6 @@ static void bfin_irq_clear(struct ata_port *ap)
 }
 
 /**
- *	bfin_irq_on - Enable interrupts on a port.
- *	@ap: Port on which interrupts are enabled.
- *
- *	Note: Original code is ata_sff_irq_on().
- */
-
-static unsigned char bfin_irq_on(struct ata_port *ap)
-{
-	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
-	u8 tmp;
-
-	dev_dbg(ap->dev, "in atapi irq on\n");
-	ap->ctl &= ~ATA_NIEN;
-	ap->last_ctl = ap->ctl;
-
-	write_atapi_register(base, ATA_REG_CTRL, ap->ctl);
-	tmp = ata_wait_idle(ap);
-
-	bfin_irq_clear(ap);
-
-	return tmp;
-}
-
-/**
- *	bfin_freeze - Freeze DMA controller port
- *	@ap: port to freeze
- *
- *	Note: Original code is ata_sff_freeze().
- */
-
-static void bfin_freeze(struct ata_port *ap)
-{
-	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
-
-	dev_dbg(ap->dev, "in atapi dma freeze\n");
-	ap->ctl |= ATA_NIEN;
-	ap->last_ctl = ap->ctl;
-
-	write_atapi_register(base, ATA_REG_CTRL, ap->ctl);
-
-	/* Under certain circumstances, some controllers raise IRQ on
-	 * ATA_NIEN manipulation.  Also, many controllers fail to mask
-	 * previously pending IRQ on ATA_NIEN assertion.  Clear it.
-	 */
-	ap->ops->sff_check_status(ap);
-
-	bfin_irq_clear(ap);
-}
-
-/**
  *	bfin_thaw - Thaw DMA controller port
  *	@ap: port to thaw
  *
@@ -1276,7 +1238,7 @@ void bfin_thaw(struct ata_port *ap)
 {
 	dev_dbg(ap->dev, "in atapi dma thaw\n");
 	bfin_check_status(ap);
-	bfin_irq_on(ap);
+	ata_sff_irq_on(ap);
 }
 
 /**
@@ -1293,7 +1255,7 @@ static void bfin_postreset(struct ata_link *link, unsigned int *classes)
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 
 	/* re-enable interrupts */
-	bfin_irq_on(ap);
+	ata_sff_irq_on(ap);
 
 	/* is double-select really necessary? */
 	if (classes[0] != ATA_DEV_NONE)
@@ -1438,18 +1400,12 @@ static irqreturn_t bfin_ata_interrupt(int irq, void *dev_instance)
 	spin_lock_irqsave(&host->lock, flags);
 
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap;
+		struct ata_port *ap = host->ports[i];
+		struct ata_queued_cmd *qc;
 
-		ap = host->ports[i];
-		if (ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct ata_queued_cmd *qc;
-
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
-			    (qc->flags & ATA_QCFLAG_ACTIVE))
-				handled |= bfin_ata_host_intr(ap, qc);
-		}
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)))
+			handled |= bfin_ata_host_intr(ap, qc);
 	}
 
 	spin_unlock_irqrestore(&host->lock, flags);
@@ -1465,7 +1421,7 @@ static struct scsi_host_template bfin_sht = {
 };
 
 static struct ata_port_operations bfin_pata_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 
 	.set_piomode		= bfin_set_piomode,
 	.set_dmamode		= bfin_set_dmamode,
@@ -1476,6 +1432,7 @@ static struct ata_port_operations bfin_pata_ops = {
 	.sff_check_status	= bfin_check_status,
 	.sff_check_altstatus	= bfin_check_altstatus,
 	.sff_dev_select		= bfin_dev_select,
+	.sff_set_devctl		= bfin_set_devctl,
 
 	.bmdma_setup		= bfin_bmdma_setup,
 	.bmdma_start		= bfin_bmdma_start,
@@ -1485,13 +1442,11 @@ static struct ata_port_operations bfin_pata_ops = {
 
 	.qc_prep		= ata_noop_qc_prep,
 
-	.freeze			= bfin_freeze,
 	.thaw			= bfin_thaw,
 	.softreset		= bfin_softreset,
 	.postreset		= bfin_postreset,
 
 	.sff_irq_clear		= bfin_irq_clear,
-	.sff_irq_on		= bfin_irq_on,
 
 	.port_start		= bfin_port_start,
 	.port_stop		= bfin_port_stop,
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 45896b3..e5f289f 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -153,24 +153,20 @@ static int cmd640_port_start(struct ata_port *ap)
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct cmd640_reg *timing;
 
-	int ret = ata_sff_port_start(ap);
-	if (ret < 0)
-		return ret;
-
 	timing = devm_kzalloc(&pdev->dev, sizeof(struct cmd640_reg), GFP_KERNEL);
 	if (timing == NULL)
 		return -ENOMEM;
 	timing->last = -1;	/* Force a load */
 	ap->private_data = timing;
-	return ret;
+	return 0;
 }
 
 static struct scsi_host_template cmd640_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
+	ATA_PIO_SHT(DRV_NAME),
 };
 
 static struct ata_port_operations cmd640_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_sff_port_ops,
 	/* In theory xfer_noirq is not needed once we kill the prefetcher */
 	.sff_data_xfer	= ata_sff_data_xfer_noirq,
 	.qc_issue	= cmd640_qc_issue,
@@ -181,13 +177,10 @@ static struct ata_port_operations cmd640_port_ops = {
 
 static void cmd640_hardware_init(struct pci_dev *pdev)
 {
-	u8 r;
 	u8 ctrl;
 
 	/* CMD640 detected, commiserations */
 	pci_write_config_byte(pdev, 0x5B, 0x00);
-	/* Get version info */
-	pci_read_config_byte(pdev, CFR, &r);
 	/* PIO0 command cycles */
 	pci_write_config_byte(pdev, CMDTIM, 0);
 	/* 512 byte bursts (sector) */
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 95ebdac..17c5f34 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -110,7 +110,7 @@ static struct scsi_host_template cs5520_sht = {
 
 static struct ata_port_operations cs5520_port_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	.qc_prep		= ata_sff_dumb_qc_prep,
+	.qc_prep		= ata_bmdma_dumb_qc_prep,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= cs5520_set_piomode,
 };
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 738ad2e..e809a42 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -156,7 +156,7 @@ static unsigned int cs5530_qc_issue(struct ata_queued_cmd *qc)
 		    	cs5530_set_dmamode(ap, adev);
 	}
 
-	return ata_sff_qc_issue(qc);
+	return ata_bmdma_qc_issue(qc);
 }
 
 static struct scsi_host_template cs5530_sht = {
@@ -167,7 +167,7 @@ static struct scsi_host_template cs5530_sht = {
 static struct ata_port_operations cs5530_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
-	.qc_prep 	= ata_sff_dumb_qc_prep,
+	.qc_prep 	= ata_bmdma_dumb_qc_prep,
 	.qc_issue	= cs5530_qc_issue,
 
 	.cable_detect	= ata_cable_40wire,
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index af49bfb..8580eb3 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -182,7 +182,7 @@ static unsigned long hpt366_filter(struct ata_device *adev, unsigned long mask)
 	} else if (adev->class == ATA_DEV_ATAPI)
 		mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
 
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 static int hpt36x_cable_detect(struct ata_port *ap)
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 8839307..98b498b 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -282,7 +282,7 @@ static unsigned long hpt370_filter(struct ata_device *adev, unsigned long mask)
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
 			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
@@ -298,7 +298,7 @@ static unsigned long hpt370a_filter(struct ata_device *adev, unsigned long mask)
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
 			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 01457b2..8b95aeb 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -320,7 +320,7 @@ static unsigned int hpt3x2n_qc_issue(struct ata_queued_cmd *qc)
 
 		hpt3x2n_set_clock(ap, dpll ? 0x21 : 0x23);
 	}
-	return ata_sff_qc_issue(qc);
+	return ata_bmdma_qc_issue(qc);
 }
 
 static struct scsi_host_template hpt3x2n_sht = {
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index fa812e2..b56e8f7 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -321,7 +321,7 @@ static void pata_icside_postreset(struct ata_link *link, unsigned int *classes)
 }
 
 static struct ata_port_operations pata_icside_port_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 	/* no need to build any PRD tables for DMA */
 	.qc_prep		= ata_noop_qc_prep,
 	.sff_data_xfer		= ata_sff_data_xfer_noirq,
@@ -333,7 +333,8 @@ static struct ata_port_operations pata_icside_port_ops = {
 	.cable_detect		= ata_cable_40wire,
 	.set_dmamode		= pata_icside_set_dmamode,
 	.postreset		= pata_icside_postreset,
-	.post_internal_cmd	= pata_icside_bmdma_stop,
+
+	.port_start		= ATA_OP_NULL,	/* don't need PRD table */
 };
 
 static void __devinit
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 5cb286f..2bd2b00 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -430,7 +430,7 @@ static unsigned int it821x_smart_qc_issue(struct ata_queued_cmd *qc)
 		case 0xFC:	/* Internal 'report rebuild state' */
 		/* Arguably should just no-op this one */
 		case ATA_CMD_SET_FEATURES:
-			return ata_sff_qc_issue(qc);
+			return ata_bmdma_qc_issue(qc);
 	}
 	printk(KERN_DEBUG "it821x: can't process command 0x%02X\n", qc->tf.command);
 	return AC_ERR_DEV;
@@ -448,7 +448,7 @@ static unsigned int it821x_smart_qc_issue(struct ata_queued_cmd *qc)
 static unsigned int it821x_passthru_qc_issue(struct ata_queued_cmd *qc)
 {
 	it821x_passthru_dev_select(qc->ap, qc->dev->devno);
-	return ata_sff_qc_issue(qc);
+	return ata_bmdma_qc_issue(qc);
 }
 
 /**
@@ -739,7 +739,7 @@ static int it821x_port_start(struct ata_port *ap)
 	struct it821x_dev *itdev;
 	u8 conf;
 
-	int ret = ata_sff_port_start(ap);
+	int ret = ata_bmdma_port_start(ap);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 211b643..25df50f 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -720,6 +720,8 @@ static int pata_macio_port_start(struct ata_port *ap)
 	if (priv->dma_table_cpu == NULL) {
 		dev_err(priv->dev, "Unable to allocate DMA command list\n");
 		ap->ioaddr.bmdma_addr = NULL;
+		ap->mwdma_mask = 0;
+		ap->udma_mask = 0;
 	}
 	return 0;
 }
@@ -917,7 +919,7 @@ static struct scsi_host_template pata_macio_sht = {
 };
 
 static struct ata_port_operations pata_macio_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 
 	.freeze			= pata_macio_freeze,
 	.set_piomode		= pata_macio_set_timings,
@@ -925,7 +927,6 @@ static struct ata_port_operations pata_macio_ops = {
 	.cable_detect		= pata_macio_cable_detect,
 	.sff_dev_select		= pata_macio_dev_select,
 	.qc_prep		= pata_macio_qc_prep,
-	.mode_filter		= ata_bmdma_mode_filter,
 	.bmdma_setup		= pata_macio_bmdma_setup,
 	.bmdma_start		= pata_macio_bmdma_start,
 	.bmdma_stop		= pata_macio_bmdma_stop,
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 9f5b053..96b11b6 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -64,13 +64,13 @@ struct mpc52xx_ata_priv {
 
 
 /* ATAPI-4 PIO specs (in ns) */
-static const int ataspec_t0[5]    = {600, 383, 240, 180, 120};
-static const int ataspec_t1[5]    = { 70,  50,  30,  30,  25};
-static const int ataspec_t2_8[5]  = {290, 290, 290,  80,  70};
-static const int ataspec_t2_16[5] = {165, 125, 100,  80,  70};
-static const int ataspec_t2i[5]   = {  0,   0,   0,  70,  25};
-static const int ataspec_t4[5]    = { 30,  20,  15,  10,  10};
-static const int ataspec_ta[5]    = { 35,  35,  35,  35,  35};
+static const u16 ataspec_t0[5]		= {600, 383, 240, 180, 120};
+static const u16 ataspec_t1[5]		= { 70,  50,  30,  30,  25};
+static const u16 ataspec_t2_8[5]	= {290, 290, 290,  80,  70};
+static const u16 ataspec_t2_16[5]	= {165, 125, 100,  80,  70};
+static const u16 ataspec_t2i[5]		= {  0,   0,   0,  70,  25};
+static const u16 ataspec_t4[5]		= { 30,  20,  15,  10,  10};
+static const u16 ataspec_ta[5]		= { 35,  35,  35,  35,  35};
 
 #define CALC_CLKCYC(c,v) ((((v)+(c)-1)/(c)))
 
@@ -78,13 +78,13 @@ static const int ataspec_ta[5]    = { 35,  35,  35,  35,  35};
 
 /* ATAPI-4 MDMA specs (in clocks) */
 struct mdmaspec {
-	u32 t0M;
-	u32 td;
-	u32 th;
-	u32 tj;
-	u32 tkw;
-	u32 tm;
-	u32 tn;
+	u8 t0M;
+	u8 td;
+	u8 th;
+	u8 tj;
+	u8 tkw;
+	u8 tm;
+	u8 tn;
 };
 
 static const struct mdmaspec mdmaspec66[3] = {
@@ -101,23 +101,23 @@ static const struct mdmaspec mdmaspec132[3] = {
 
 /* ATAPI-4 UDMA specs (in clocks) */
 struct udmaspec {
-	u32 tcyc;
-	u32 t2cyc;
-	u32 tds;
-	u32 tdh;
-	u32 tdvs;
-	u32 tdvh;
-	u32 tfs;
-	u32 tli;
-	u32 tmli;
-	u32 taz;
-	u32 tzah;
-	u32 tenv;
-	u32 tsr;
-	u32 trfs;
-	u32 trp;
-	u32 tack;
-	u32 tss;
+	u8 tcyc;
+	u8 t2cyc;
+	u8 tds;
+	u8 tdh;
+	u8 tdvs;
+	u8 tdvh;
+	u8 tfs;
+	u8 tli;
+	u8 tmli;
+	u8 taz;
+	u8 tzah;
+	u8 tenv;
+	u8 tsr;
+	u8 trfs;
+	u8 trp;
+	u8 tack;
+	u8 tss;
 };
 
 static const struct udmaspec udmaspec66[6] = {
@@ -270,7 +270,7 @@ mpc52xx_ata_compute_pio_timings(struct mpc52xx_ata_priv *priv, int dev, int pio)
 {
 	struct mpc52xx_ata_timings *timing = &priv->timings[dev];
 	unsigned int ipb_period = priv->ipb_period;
-	unsigned int t0, t1, t2_8, t2_16, t2i, t4, ta;
+	u32 t0, t1, t2_8, t2_16, t2i, t4, ta;
 
 	if ((pio < 0) || (pio > 4))
 		return -EINVAL;
@@ -299,8 +299,8 @@ mpc52xx_ata_compute_mdma_timings(struct mpc52xx_ata_priv *priv, int dev,
 	if (speed < 0 || speed > 2)
 		return -EINVAL;
 
-	t->mdma1 = (s->t0M << 24) | (s->td << 16) | (s->tkw << 8) | (s->tm);
-	t->mdma2 = (s->th << 24) | (s->tj << 16) | (s->tn << 8);
+	t->mdma1 = ((u32)s->t0M << 24) | ((u32)s->td << 16) | ((u32)s->tkw << 8) | s->tm;
+	t->mdma2 = ((u32)s->th << 24) | ((u32)s->tj << 16) | ((u32)s->tn << 8);
 	t->using_udma = 0;
 
 	return 0;
@@ -316,11 +316,11 @@ mpc52xx_ata_compute_udma_timings(struct mpc52xx_ata_priv *priv, int dev,
 	if (speed < 0 || speed > 2)
 		return -EINVAL;
 
-	t->udma1 = (s->t2cyc << 24) | (s->tcyc << 16) | (s->tds << 8) | s->tdh;
-	t->udma2 = (s->tdvs << 24) | (s->tdvh << 16) | (s->tfs << 8) | s->tli;
-	t->udma3 = (s->tmli << 24) | (s->taz << 16) | (s->tenv << 8) | s->tsr;
-	t->udma4 = (s->tss << 24) | (s->trfs << 16) | (s->trp << 8) | s->tack;
-	t->udma5 = (s->tzah << 24);
+	t->udma1 = ((u32)s->t2cyc << 24) | ((u32)s->tcyc << 16) | ((u32)s->tds << 8) | s->tdh;
+	t->udma2 = ((u32)s->tdvs << 24) | ((u32)s->tdvh << 16) | ((u32)s->tfs << 8) | s->tli;
+	t->udma3 = ((u32)s->tmli << 24) | ((u32)s->taz << 16) | ((u32)s->tenv << 8) | s->tsr;
+	t->udma4 = ((u32)s->tss << 24) | ((u32)s->trfs << 16) | ((u32)s->trp << 8) | s->tack;
+	t->udma5 = (u32)s->tzah << 24;
 	t->using_udma = 1;
 
 	return 0;
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index 830431f..fdbba2d 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -126,7 +126,7 @@ static void ns87415_bmdma_setup(struct ata_queued_cmd *qc)
 
 	/* load PRD table addr. */
 	mb();	/* make sure PRD table writes are visible to controller */
-	iowrite32(ap->prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
+	iowrite32(ap->bmdma_prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
 
 	/* specify data direction, triple-check start bit is clear */
 	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 005a444..3001109 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -489,9 +489,8 @@ static void octeon_cf_exec_command16(struct ata_port *ap,
 	ata_wait_idle(ap);
 }
 
-static u8 octeon_cf_irq_on(struct ata_port *ap)
+static void octeon_cf_irq_on(struct ata_port *ap)
 {
-	return 0;
 }
 
 static void octeon_cf_irq_clear(struct ata_port *ap)
@@ -655,9 +654,6 @@ static irqreturn_t octeon_cf_interrupt(int irq, void *dev_instance)
 		ap = host->ports[i];
 		ocd = ap->dev->platform_data;
 
-		if (ap->flags & ATA_FLAG_DISABLED)
-			continue;
-
 		ocd = ap->dev->platform_data;
 		cf_port = ap->private_data;
 		dma_int.u64 =
@@ -667,8 +663,7 @@ static irqreturn_t octeon_cf_interrupt(int irq, void *dev_instance)
 
 		qc = ata_qc_from_tag(ap, ap->link.active_tag);
 
-		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
-		    (qc->flags & ATA_QCFLAG_ACTIVE)) {
+		if (qc && !(qc->tf.flags & ATA_TFLAG_POLLING)) {
 			if (dma_int.s.done && !dma_cfg.s.en) {
 				if (!sg_is_last(qc->cursg)) {
 					qc->cursg = sg_next(qc->cursg);
@@ -738,8 +733,7 @@ static void octeon_cf_delayed_finish(struct work_struct *work)
 		goto out;
 	}
 	qc = ata_qc_from_tag(ap, ap->link.active_tag);
-	if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
-	    (qc->flags & ATA_QCFLAG_ACTIVE))
+	if (qc && !(qc->tf.flags & ATA_TFLAG_POLLING))
 		octeon_cf_dma_finished(ap, qc);
 out:
 	spin_unlock_irqrestore(&host->lock, flags);
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 5f6aba7..988ef26 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -200,7 +200,7 @@ static unsigned int oldpiix_qc_issue(struct ata_queued_cmd *qc)
 		if (ata_dma_enabled(adev))
 			oldpiix_set_dmamode(ap, adev);
 	}
-	return ata_sff_qc_issue(qc);
+	return ata_bmdma_qc_issue(qc);
 }
 
 
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index d94b8f0..ef37438 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -175,7 +175,7 @@ static struct ata_port_operations pcmcia_8bit_port_ops = {
 	.sff_data_xfer	= ata_data_xfer_8bit,
 	.cable_detect	= ata_cable_40wire,
 	.set_mode	= pcmcia_set_mode_8bit,
-	.drain_fifo	= pcmcia_8bit_drain_fifo,
+	.sff_drain_fifo	= pcmcia_8bit_drain_fifo,
 };
 
 
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index ca5cad0..09f1f22 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -265,7 +265,7 @@ static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long
 	struct ata_device *pair = ata_dev_pair(adev);
 
 	if (adev->class != ATA_DEV_ATA || adev->devno == 0 || pair == NULL)
-		return ata_bmdma_mode_filter(adev, mask);
+		return mask;
 
 	/* Check for slave of a Maxtor at UDMA6 */
 	ata_id_c_string(pair->id, model_num, ATA_ID_PROD,
@@ -274,7 +274,7 @@ static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long
 	if (strstr(model_num, "Maxtor") == NULL && pair->dma_mode == XFER_UDMA_6)
 		mask &= ~ (1 << (6 + ATA_SHIFT_UDMA));
 
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 9ac0897..fa1e2f3 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -249,7 +249,7 @@ static int pdc2026x_port_start(struct ata_port *ap)
 		u8 burst = ioread8(bmdma + 0x1f);
 		iowrite8(burst | 0x01, bmdma + 0x1f);
 	}
-	return ata_sff_port_start(ap);
+	return ata_bmdma_port_start(ap);
 }
 
 /**
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 3f6ebc6..50400fa 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -53,7 +53,6 @@ static struct ata_port_operations pata_platform_port_ops = {
 	.sff_data_xfer		= ata_sff_data_xfer_noirq,
 	.cable_detect		= ata_cable_unknown,
 	.set_mode		= pata_platform_set_mode,
-	.port_start		= ATA_OP_NULL,
 };
 
 static void pata_platform_setup_port(struct ata_ioports *ioaddr,
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index fc96022..a5fa388 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -179,7 +179,7 @@ static unsigned int radisys_qc_issue(struct ata_queued_cmd *qc)
 				radisys_set_piomode(ap, adev);
 		}
 	}
-	return ata_sff_qc_issue(qc);
+	return ata_bmdma_qc_issue(qc);
 }
 
 
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index dfecc6f..6b5b63a 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -174,7 +174,7 @@ static unsigned int sc1200_qc_issue(struct ata_queued_cmd *qc)
 		    	sc1200_set_dmamode(ap, adev);
 	}
 
-	return ata_sff_qc_issue(qc);
+	return ata_bmdma_qc_issue(qc);
 }
 
 /**
@@ -209,7 +209,7 @@ static struct scsi_host_template sc1200_sht = {
 
 static struct ata_port_operations sc1200_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
-	.qc_prep 	= ata_sff_dumb_qc_prep,
+	.qc_prep 	= ata_bmdma_dumb_qc_prep,
 	.qc_issue	= sc1200_qc_issue,
 	.qc_defer	= sc1200_qc_defer,
 	.cable_detect	= ata_cable_40wire,
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 4257d6b..6f6193b 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -265,7 +265,7 @@ unsigned long scc_mode_filter(struct ata_device *adev, unsigned long mask)
 		printk(KERN_INFO "%s: limit ATAPI UDMA to UDMA4\n", DRV_NAME);
 		mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
@@ -416,6 +416,17 @@ static void scc_dev_select (struct ata_port *ap, unsigned int device)
 }
 
 /**
+ *	scc_set_devctl - Write device control reg
+ *	@ap: port where the device is
+ *	@ctl: value to write
+ */
+
+static void scc_set_devctl(struct ata_port *ap, u8 ctl)
+{
+	out_be32(ap->ioaddr.ctl_addr, ctl);
+}
+
+/**
  *	scc_bmdma_setup - Set up PCI IDE BMDMA transaction
  *	@qc: Info associated with this ATA transaction.
  *
@@ -430,7 +441,7 @@ static void scc_bmdma_setup (struct ata_queued_cmd *qc)
 	void __iomem *mmio = ap->ioaddr.bmdma_addr;
 
 	/* load PRD table addr */
-	out_be32(mmio + SCC_DMA_TABLE_OFS, ap->prd_dma);
+	out_be32(mmio + SCC_DMA_TABLE_OFS, ap->bmdma_prd_dma);
 
 	/* specify data direction, triple-check start bit is clear */
 	dmactl = in_be32(mmio + SCC_DMA_CMD);
@@ -501,8 +512,8 @@ static unsigned int scc_devchk (struct ata_port *ap,
  *	Note: Original code is ata_sff_wait_after_reset
  */
 
-int scc_wait_after_reset(struct ata_link *link, unsigned int devmask,
-			 unsigned long deadline)
+static int scc_wait_after_reset(struct ata_link *link, unsigned int devmask,
+				unsigned long deadline)
 {
 	struct ata_port *ap = link->ap;
 	struct ata_ioports *ioaddr = &ap->ioaddr;
@@ -817,54 +828,6 @@ static unsigned int scc_data_xfer (struct ata_device *dev, unsigned char *buf,
 }
 
 /**
- *	scc_irq_on - Enable interrupts on a port.
- *	@ap: Port on which interrupts are enabled.
- *
- *	Note: Original code is ata_sff_irq_on().
- */
-
-static u8 scc_irq_on (struct ata_port *ap)
-{
-	struct ata_ioports *ioaddr = &ap->ioaddr;
-	u8 tmp;
-
-	ap->ctl &= ~ATA_NIEN;
-	ap->last_ctl = ap->ctl;
-
-	out_be32(ioaddr->ctl_addr, ap->ctl);
-	tmp = ata_wait_idle(ap);
-
-	ap->ops->sff_irq_clear(ap);
-
-	return tmp;
-}
-
-/**
- *	scc_freeze - Freeze BMDMA controller port
- *	@ap: port to freeze
- *
- *	Note: Original code is ata_sff_freeze().
- */
-
-static void scc_freeze (struct ata_port *ap)
-{
-	struct ata_ioports *ioaddr = &ap->ioaddr;
-
-	ap->ctl |= ATA_NIEN;
-	ap->last_ctl = ap->ctl;
-
-	out_be32(ioaddr->ctl_addr, ap->ctl);
-
-	/* Under certain circumstances, some controllers raise IRQ on
-	 * ATA_NIEN manipulation.  Also, many controllers fail to mask
-	 * previously pending IRQ on ATA_NIEN assertion.  Clear it.
-	 */
-	ap->ops->sff_check_status(ap);
-
-	ap->ops->sff_irq_clear(ap);
-}
-
-/**
  *	scc_pata_prereset - prepare for reset
  *	@ap: ATA port to be reset
  *	@deadline: deadline jiffies for the operation
@@ -903,8 +866,7 @@ static void scc_postreset(struct ata_link *link, unsigned int *classes)
 	}
 
 	/* set up device control */
-	if (ap->ioaddr.ctl_addr)
-		out_be32(ap->ioaddr.ctl_addr, ap->ctl);
+	out_be32(ap->ioaddr.ctl_addr, ap->ctl);
 
 	DPRINTK("EXIT\n");
 }
@@ -930,7 +892,7 @@ static void scc_irq_clear (struct ata_port *ap)
  *	scc_port_start - Set port up for dma.
  *	@ap: Port to initialize
  *
- *	Allocate space for PRD table using ata_port_start().
+ *	Allocate space for PRD table using ata_bmdma_port_start().
  *	Set PRD table address for PTERADD. (PRD Transfer End Read)
  */
 
@@ -939,11 +901,11 @@ static int scc_port_start (struct ata_port *ap)
 	void __iomem *mmio = ap->ioaddr.bmdma_addr;
 	int rc;
 
-	rc = ata_port_start(ap);
+	rc = ata_bmdma_port_start(ap);
 	if (rc)
 		return rc;
 
-	out_be32(mmio + SCC_DMA_PTERADD, ap->prd_dma);
+	out_be32(mmio + SCC_DMA_PTERADD, ap->bmdma_prd_dma);
 	return 0;
 }
 
@@ -978,6 +940,7 @@ static struct ata_port_operations scc_pata_ops = {
 	.sff_check_status	= scc_check_status,
 	.sff_check_altstatus	= scc_check_altstatus,
 	.sff_dev_select		= scc_dev_select,
+	.sff_set_devctl		= scc_set_devctl,
 
 	.bmdma_setup		= scc_bmdma_setup,
 	.bmdma_start		= scc_bmdma_start,
@@ -985,14 +948,11 @@ static struct ata_port_operations scc_pata_ops = {
 	.bmdma_status		= scc_bmdma_status,
 	.sff_data_xfer		= scc_data_xfer,
 
-	.freeze			= scc_freeze,
 	.prereset		= scc_pata_prereset,
 	.softreset		= scc_softreset,
 	.postreset		= scc_postreset,
-	.post_internal_cmd	= scc_bmdma_stop,
 
 	.sff_irq_clear		= scc_irq_clear,
-	.sff_irq_on		= scc_irq_on,
 
 	.port_start		= scc_port_start,
 	.port_stop		= scc_port_stop,
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index 99cceb4..86b3d01 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -174,22 +174,12 @@ static int __devinit sch_init_one(struct pci_dev *pdev,
 {
 	static int printed_version;
 	const struct ata_port_info *ppi[] = { &sch_port_info, NULL };
-	struct ata_host *host;
-	int rc;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	/* enable device and prepare host */
-	rc = pcim_enable_device(pdev);
-	if (rc)
-		return rc;
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
-	if (rc)
-		return rc;
-	pci_set_master(pdev);
-	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &sch_sht);
+	return ata_pci_sff_init_one(pdev, ppi, &sch_sht, NULL, 0);
 }
 
 static int __init sch_init(void)
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 9524d54..43ea389 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -198,7 +198,7 @@ static unsigned long serverworks_osb4_filter(struct ata_device *adev, unsigned l
 {
 	if (adev->class == ATA_DEV_ATA)
 		mask &= ~ATA_MASK_UDMA;
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 
@@ -218,7 +218,7 @@ static unsigned long serverworks_csb_filter(struct ata_device *adev, unsigned lo
 
 	/* Disk, UDMA */
 	if (adev->class != ATA_DEV_ATA)
-		return ata_bmdma_mode_filter(adev, mask);
+		return mask;
 
 	/* Actually do need to check */
 	ata_id_c_string(adev->id, model_num, ATA_ID_PROD, sizeof(model_num));
@@ -227,7 +227,7 @@ static unsigned long serverworks_csb_filter(struct ata_device *adev, unsigned lo
 		if (!strcmp(p, model_num))
 			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index c6c589c..43faf10 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -190,15 +190,37 @@ static void sil680_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	pci_write_config_word(pdev, ua, ultra);
 }
 
+/**
+ *	sil680_sff_exec_command - issue ATA command to host controller
+ *	@ap: port to which command is being issued
+ *	@tf: ATA taskfile register set
+ *
+ *	Issues ATA command, with proper synchronization with interrupt
+ *	handler / other threads. Use our MMIO space for PCI posting to avoid
+ *	a hideously slow cycle all the way to the device.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void sil680_sff_exec_command(struct ata_port *ap,
+					const struct ata_taskfile *tf)
+{
+	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+	iowrite8(tf->command, ap->ioaddr.command_addr);
+	ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+}
+
 static struct scsi_host_template sil680_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
+
 static struct ata_port_operations sil680_port_ops = {
-	.inherits	= &ata_bmdma32_port_ops,
-	.cable_detect	= sil680_cable_detect,
-	.set_piomode	= sil680_set_piomode,
-	.set_dmamode	= sil680_set_dmamode,
+	.inherits		= &ata_bmdma32_port_ops,
+	.sff_exec_command	= sil680_sff_exec_command,
+	.cable_detect		= sil680_cable_detect,
+	.set_piomode		= sil680_set_piomode,
+	.set_dmamode		= sil680_set_dmamode,
 };
 
 /**
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 741e7cb..7e3e0a5 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -355,7 +355,7 @@ static unsigned long via_mode_filter(struct ata_device *dev, unsigned long mask)
 			mask &= ~ ATA_MASK_UDMA;
 		}
 	}
-	return ata_bmdma_mode_filter(dev, mask);
+	return mask;
 }
 
 /**
@@ -417,8 +417,6 @@ static void via_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 			tf->lbam,
 			tf->lbah);
 	}
-
-	ata_wait_idle(ap);
 }
 
 static int via_port_start(struct ata_port *ap)
@@ -426,7 +424,7 @@ static int via_port_start(struct ata_port *ap)
 	struct via_port *vp;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
-	int ret = ata_sff_port_start(ap);
+	int ret = ata_bmdma_port_start(ap);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 5904cfd..adbe042 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -324,10 +324,8 @@ static void adma_qc_prep(struct ata_queued_cmd *qc)
 	VPRINTK("ENTER\n");
 
 	adma_enter_reg_mode(qc->ap);
-	if (qc->tf.protocol != ATA_PROT_DMA) {
-		ata_sff_qc_prep(qc);
+	if (qc->tf.protocol != ATA_PROT_DMA)
 		return;
-	}
 
 	buf[i++] = 0;	/* Response flags */
 	buf[i++] = 0;	/* reserved */
@@ -442,8 +440,6 @@ static inline unsigned int adma_intr_pkt(struct ata_host *host)
 			continue;
 		handled = 1;
 		adma_enter_reg_mode(ap);
-		if (ap->flags & ATA_FLAG_DISABLED)
-			continue;
 		pp = ap->private_data;
 		if (!pp || pp->state != adma_state_pkt)
 			continue;
@@ -484,42 +480,38 @@ static inline unsigned int adma_intr_mmio(struct ata_host *host)
 	unsigned int handled = 0, port_no;
 
 	for (port_no = 0; port_no < host->n_ports; ++port_no) {
-		struct ata_port *ap;
-		ap = host->ports[port_no];
-		if (ap && (!(ap->flags & ATA_FLAG_DISABLED))) {
-			struct ata_queued_cmd *qc;
-			struct adma_port_priv *pp = ap->private_data;
-			if (!pp || pp->state != adma_state_mmio)
+		struct ata_port *ap = host->ports[port_no];
+		struct adma_port_priv *pp = ap->private_data;
+		struct ata_queued_cmd *qc;
+
+		if (!pp || pp->state != adma_state_mmio)
+			continue;
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
+
+			/* check main status, clearing INTRQ */
+			u8 status = ata_sff_check_status(ap);
+			if ((status & ATA_BUSY))
 				continue;
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
-
-				/* check main status, clearing INTRQ */
-				u8 status = ata_sff_check_status(ap);
-				if ((status & ATA_BUSY))
-					continue;
-				DPRINTK("ata%u: protocol %d (dev_stat 0x%X)\n",
-					ap->print_id, qc->tf.protocol, status);
-
-				/* complete taskfile transaction */
-				pp->state = adma_state_idle;
-				qc->err_mask |= ac_err_mask(status);
-				if (!qc->err_mask)
-					ata_qc_complete(qc);
-				else {
-					struct ata_eh_info *ehi =
-						&ap->link.eh_info;
-					ata_ehi_clear_desc(ehi);
-					ata_ehi_push_desc(ehi,
-						"status 0x%02X", status);
-
-					if (qc->err_mask == AC_ERR_DEV)
-						ata_port_abort(ap);
-					else
-						ata_port_freeze(ap);
-				}
-				handled = 1;
+			DPRINTK("ata%u: protocol %d (dev_stat 0x%X)\n",
+				ap->print_id, qc->tf.protocol, status);
+
+			/* complete taskfile transaction */
+			pp->state = adma_state_idle;
+			qc->err_mask |= ac_err_mask(status);
+			if (!qc->err_mask)
+				ata_qc_complete(qc);
+			else {
+				struct ata_eh_info *ehi = &ap->link.eh_info;
+				ata_ehi_clear_desc(ehi);
+				ata_ehi_push_desc(ehi, "status 0x%02X", status);
+
+				if (qc->err_mask == AC_ERR_DEV)
+					ata_port_abort(ap);
+				else
+					ata_port_freeze(ap);
 			}
+			handled = 1;
 		}
 	}
 	return handled;
@@ -562,11 +554,7 @@ static int adma_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
 	struct adma_port_priv *pp;
-	int rc;
 
-	rc = ata_port_start(ap);
-	if (rc)
-		return rc;
 	adma_enter_reg_mode(ap);
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 27dc6c8..a36149e 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -415,22 +415,11 @@ static irqreturn_t inic_interrupt(int irq, void *dev_instance)
 
 	spin_lock(&host->lock);
 
-	for (i = 0; i < NR_PORTS; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		if (!(host_irq_stat & (HIRQ_PORT0 << i)))
-			continue;
-
-		if (likely(ap && !(ap->flags & ATA_FLAG_DISABLED))) {
-			inic_host_intr(ap);
+	for (i = 0; i < NR_PORTS; i++)
+		if (host_irq_stat & (HIRQ_PORT0 << i)) {
+			inic_host_intr(host->ports[i]);
 			handled++;
-		} else {
-			if (ata_ratelimit())
-				dev_printk(KERN_ERR, host->dev, "interrupt "
-					   "from disabled port %d (0x%x)\n",
-					   i, host_irq_stat);
 		}
-	}
 
 	spin_unlock(&host->lock);
 
@@ -679,8 +668,7 @@ static void init_port(struct ata_port *ap)
 	memset(pp->pkt, 0, sizeof(struct inic_pkt));
 	memset(pp->cpb_tbl, 0, IDMA_CPB_TBL_SIZE);
 
-	/* setup PRD and CPB lookup table addresses */
-	writel(ap->prd_dma, port_base + PORT_PRD_ADDR);
+	/* setup CPB lookup table addresses */
 	writel(pp->cpb_tbl_dma, port_base + PORT_CPB_CPBLAR);
 }
 
@@ -694,7 +682,6 @@ static int inic_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
 	struct inic_port_priv *pp;
-	int rc;
 
 	/* alloc and initialize private data */
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
@@ -703,10 +690,6 @@ static int inic_port_start(struct ata_port *ap)
 	ap->private_data = pp;
 
 	/* Alloc resources */
-	rc = ata_port_start(ap);
-	if (rc)
-		return rc;
-
 	pp->pkt = dmam_alloc_coherent(dev, sizeof(struct inic_pkt),
 				      &pp->pkt_dma, GFP_KERNEL);
 	if (!pp->pkt)
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 71cc0d4..f3471bc 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -686,16 +686,27 @@ static struct ata_port_operations mv5_ops = {
 };
 
 static struct ata_port_operations mv6_ops = {
-	.inherits		= &mv5_ops,
+	.inherits		= &ata_bmdma_port_ops,
+
+	.lost_interrupt		= ATA_OP_NULL,
+
+	.qc_defer		= mv_qc_defer,
+	.qc_prep		= mv_qc_prep,
+	.qc_issue		= mv_qc_issue,
+
 	.dev_config             = mv6_dev_config,
-	.scr_read		= mv_scr_read,
-	.scr_write		= mv_scr_write,
 
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+	.hardreset		= mv_hardreset,
+	.softreset		= mv_softreset,
 	.pmp_hardreset		= mv_pmp_hardreset,
 	.pmp_softreset		= mv_softreset,
-	.softreset		= mv_softreset,
 	.error_handler		= mv_pmp_error_handler,
 
+	.scr_read		= mv_scr_read,
+	.scr_write		= mv_scr_write,
+
 	.sff_check_status	= mv_sff_check_status,
 	.sff_irq_clear		= mv_sff_irq_clear,
 	.check_atapi_dma	= mv_check_atapi_dma,
@@ -703,6 +714,9 @@ static struct ata_port_operations mv6_ops = {
 	.bmdma_start		= mv_bmdma_start,
 	.bmdma_stop		= mv_bmdma_stop,
 	.bmdma_status		= mv_bmdma_status,
+
+	.port_start		= mv_port_start,
+	.port_stop		= mv_port_stop,
 };
 
 static struct ata_port_operations mv_iie_ops = {
@@ -2248,7 +2262,7 @@ static unsigned int mv_qc_issue_fis(struct ata_queued_cmd *qc)
 	}
 
 	if (qc->tf.flags & ATA_TFLAG_POLLING)
-		ata_pio_queue_task(ap, qc, 0);
+		ata_sff_queue_pio_task(ap, 0);
 	return 0;
 }
 
@@ -2344,7 +2358,7 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 		if (IS_GEN_II(hpriv))
 			return mv_qc_issue_fis(qc);
 	}
-	return ata_sff_qc_issue(qc);
+	return ata_bmdma_qc_issue(qc);
 }
 
 static struct ata_queued_cmd *mv_get_active_qc(struct ata_port *ap)
@@ -2355,13 +2369,9 @@ static struct ata_queued_cmd *mv_get_active_qc(struct ata_port *ap)
 	if (pp->pp_flags & MV_PP_FLAG_NCQ_EN)
 		return NULL;
 	qc = ata_qc_from_tag(ap, ap->link.active_tag);
-	if (qc) {
-		if (qc->tf.flags & ATA_TFLAG_POLLING)
-			qc = NULL;
-		else if (!(qc->flags & ATA_QCFLAG_ACTIVE))
-			qc = NULL;
-	}
-	return qc;
+	if (qc && !(qc->tf.flags & ATA_TFLAG_POLLING))
+		return qc;
+	return NULL;
 }
 
 static void mv_pmp_error_handler(struct ata_port *ap)
@@ -2546,9 +2556,7 @@ static void mv_unexpected_intr(struct ata_port *ap, int edma_was_enabled)
 	char *when = "idle";
 
 	ata_ehi_clear_desc(ehi);
-	if (ap->flags & ATA_FLAG_DISABLED) {
-		when = "disabled";
-	} else if (edma_was_enabled) {
+	if (edma_was_enabled) {
 		when = "EDMA enabled";
 	} else {
 		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->link.active_tag);
@@ -2782,10 +2790,6 @@ static void mv_port_intr(struct ata_port *ap, u32 port_cause)
 	struct mv_port_priv *pp;
 	int edma_was_enabled;
 
-	if (ap->flags & ATA_FLAG_DISABLED) {
-		mv_unexpected_intr(ap, 0);
-		return;
-	}
 	/*
 	 * Grab a snapshot of the EDMA_EN flag setting,
 	 * so that we have a consistent view for this port,
@@ -3656,9 +3660,6 @@ static void mv_port_init(struct ata_ioports *port,  void __iomem *port_mmio)
 	/* special case: control/altstatus doesn't have ATA_REG_ address */
 	port->altstatus_addr = port->ctl_addr = shd_base + SHD_CTL_AST;
 
-	/* unused: */
-	port->cmd_addr = port->bmdma_addr = port->scr_addr = NULL;
-
 	/* Clear any currently outstanding port interrupt conditions */
 	serr = port_mmio + mv_scr_offset(SCR_ERROR);
 	writelfl(readl(serr), serr);
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 2a98b09..baa8f0d 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -272,7 +272,7 @@ enum ncq_saw_flag_list {
 };
 
 struct nv_swncq_port_priv {
-	struct ata_prd	*prd;	 /* our SG list */
+	struct ata_bmdma_prd *prd;	 /* our SG list */
 	dma_addr_t	prd_dma; /* and its DMA mapping */
 	void __iomem	*sactive_block;
 	void __iomem	*irq_block;
@@ -933,107 +933,108 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
+		struct nv_adma_port_priv *pp = ap->private_data;
+		void __iomem *mmio = pp->ctl_block;
+		u16 status;
+		u32 gen_ctl;
+		u32 notifier, notifier_error;
+
 		notifier_clears[i] = 0;
 
-		if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct nv_adma_port_priv *pp = ap->private_data;
-			void __iomem *mmio = pp->ctl_block;
-			u16 status;
-			u32 gen_ctl;
-			u32 notifier, notifier_error;
-
-			/* if ADMA is disabled, use standard ata interrupt handler */
-			if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
-				u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
-					>> (NV_INT_PORT_SHIFT * i);
-				handled += nv_host_intr(ap, irq_stat);
-				continue;
-			}
+		/* if ADMA is disabled, use standard ata interrupt handler */
+		if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
+			u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
+				>> (NV_INT_PORT_SHIFT * i);
+			handled += nv_host_intr(ap, irq_stat);
+			continue;
+		}
 
-			/* if in ATA register mode, check for standard interrupts */
-			if (pp->flags & NV_ADMA_PORT_REGISTER_MODE) {
-				u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
-					>> (NV_INT_PORT_SHIFT * i);
-				if (ata_tag_valid(ap->link.active_tag))
-					/** NV_INT_DEV indication seems unreliable at times
-					    at least in ADMA mode. Force it on always when a
-					    command is active, to prevent losing interrupts. */
-					irq_stat |= NV_INT_DEV;
-				handled += nv_host_intr(ap, irq_stat);
-			}
+		/* if in ATA register mode, check for standard interrupts */
+		if (pp->flags & NV_ADMA_PORT_REGISTER_MODE) {
+			u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
+				>> (NV_INT_PORT_SHIFT * i);
+			if (ata_tag_valid(ap->link.active_tag))
+				/** NV_INT_DEV indication seems unreliable
+				    at times at least in ADMA mode. Force it
+				    on always when a command is active, to
+				    prevent losing interrupts. */
+				irq_stat |= NV_INT_DEV;
+			handled += nv_host_intr(ap, irq_stat);
+		}
+
+		notifier = readl(mmio + NV_ADMA_NOTIFIER);
+		notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
+		notifier_clears[i] = notifier | notifier_error;
+
+		gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
+
+		if (!NV_ADMA_CHECK_INTR(gen_ctl, ap->port_no) && !notifier &&
+		    !notifier_error)
+			/* Nothing to do */
+			continue;
+
+		status = readw(mmio + NV_ADMA_STAT);
+
+		/*
+		 * Clear status. Ensure the controller sees the
+		 * clearing before we start looking at any of the CPB
+		 * statuses, so that any CPB completions after this
+		 * point in the handler will raise another interrupt.
+		 */
+		writew(status, mmio + NV_ADMA_STAT);
+		readw(mmio + NV_ADMA_STAT); /* flush posted write */
+		rmb();
+
+		handled++; /* irq handled if we got here */
 
-			notifier = readl(mmio + NV_ADMA_NOTIFIER);
-			notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
-			notifier_clears[i] = notifier | notifier_error;
-
-			gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
-
-			if (!NV_ADMA_CHECK_INTR(gen_ctl, ap->port_no) && !notifier &&
-			    !notifier_error)
-				/* Nothing to do */
-				continue;
-
-			status = readw(mmio + NV_ADMA_STAT);
-
-			/* Clear status. Ensure the controller sees the clearing before we start
-			   looking at any of the CPB statuses, so that any CPB completions after
-			   this point in the handler will raise another interrupt. */
-			writew(status, mmio + NV_ADMA_STAT);
-			readw(mmio + NV_ADMA_STAT); /* flush posted write */
-			rmb();
-
-			handled++; /* irq handled if we got here */
-
-			/* freeze if hotplugged or controller error */
-			if (unlikely(status & (NV_ADMA_STAT_HOTPLUG |
-					       NV_ADMA_STAT_HOTUNPLUG |
-					       NV_ADMA_STAT_TIMEOUT |
-					       NV_ADMA_STAT_SERROR))) {
-				struct ata_eh_info *ehi = &ap->link.eh_info;
-
-				ata_ehi_clear_desc(ehi);
-				__ata_ehi_push_desc(ehi, "ADMA status 0x%08x: ", status);
-				if (status & NV_ADMA_STAT_TIMEOUT) {
-					ehi->err_mask |= AC_ERR_SYSTEM;
-					ata_ehi_push_desc(ehi, "timeout");
-				} else if (status & NV_ADMA_STAT_HOTPLUG) {
-					ata_ehi_hotplugged(ehi);
-					ata_ehi_push_desc(ehi, "hotplug");
-				} else if (status & NV_ADMA_STAT_HOTUNPLUG) {
-					ata_ehi_hotplugged(ehi);
-					ata_ehi_push_desc(ehi, "hot unplug");
-				} else if (status & NV_ADMA_STAT_SERROR) {
-					/* let libata analyze SError and figure out the cause */
-					ata_ehi_push_desc(ehi, "SError");
-				} else
-					ata_ehi_push_desc(ehi, "unknown");
-				ata_port_freeze(ap);
-				continue;
+		/* freeze if hotplugged or controller error */
+		if (unlikely(status & (NV_ADMA_STAT_HOTPLUG |
+				       NV_ADMA_STAT_HOTUNPLUG |
+				       NV_ADMA_STAT_TIMEOUT |
+				       NV_ADMA_STAT_SERROR))) {
+			struct ata_eh_info *ehi = &ap->link.eh_info;
+
+			ata_ehi_clear_desc(ehi);
+			__ata_ehi_push_desc(ehi, "ADMA status 0x%08x: ", status);
+			if (status & NV_ADMA_STAT_TIMEOUT) {
+				ehi->err_mask |= AC_ERR_SYSTEM;
+				ata_ehi_push_desc(ehi, "timeout");
+			} else if (status & NV_ADMA_STAT_HOTPLUG) {
+				ata_ehi_hotplugged(ehi);
+				ata_ehi_push_desc(ehi, "hotplug");
+			} else if (status & NV_ADMA_STAT_HOTUNPLUG) {
+				ata_ehi_hotplugged(ehi);
+				ata_ehi_push_desc(ehi, "hot unplug");
+			} else if (status & NV_ADMA_STAT_SERROR) {
+				/* let EH analyze SError and figure out cause */
+				ata_ehi_push_desc(ehi, "SError");
+			} else
+				ata_ehi_push_desc(ehi, "unknown");
+			ata_port_freeze(ap);
+			continue;
+		}
+
+		if (status & (NV_ADMA_STAT_DONE |
+			      NV_ADMA_STAT_CPBERR |
+			      NV_ADMA_STAT_CMD_COMPLETE)) {
+			u32 check_commands = notifier_clears[i];
+			int pos, error = 0;
+
+			if (status & NV_ADMA_STAT_CPBERR) {
+				/* check all active commands */
+				if (ata_tag_valid(ap->link.active_tag))
+					check_commands = 1 <<
+						ap->link.active_tag;
+				else
+					check_commands = ap->link.sactive;
 			}
 
-			if (status & (NV_ADMA_STAT_DONE |
-				      NV_ADMA_STAT_CPBERR |
-				      NV_ADMA_STAT_CMD_COMPLETE)) {
-				u32 check_commands = notifier_clears[i];
-				int pos, error = 0;
-
-				if (status & NV_ADMA_STAT_CPBERR) {
-					/* Check all active commands */
-					if (ata_tag_valid(ap->link.active_tag))
-						check_commands = 1 <<
-							ap->link.active_tag;
-					else
-						check_commands = ap->
-							link.sactive;
-				}
-
-				/** Check CPBs for completed commands */
-				while ((pos = ffs(check_commands)) && !error) {
-					pos--;
-					error = nv_adma_check_cpb(ap, pos,
+			/* check CPBs for completed commands */
+			while ((pos = ffs(check_commands)) && !error) {
+				pos--;
+				error = nv_adma_check_cpb(ap, pos,
 						notifier_error & (1 << pos));
-					check_commands &= ~(1 << pos);
-				}
+				check_commands &= ~(1 << pos);
 			}
 		}
 	}
@@ -1130,7 +1131,7 @@ static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc)
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
 	if (pp->flags & NV_ADMA_PORT_REGISTER_MODE)
-		ata_sff_post_internal_cmd(qc);
+		ata_bmdma_post_internal_cmd(qc);
 }
 
 static int nv_adma_port_start(struct ata_port *ap)
@@ -1155,7 +1156,8 @@ static int nv_adma_port_start(struct ata_port *ap)
 	if (rc)
 		return rc;
 
-	rc = ata_port_start(ap);
+	/* we might fallback to bmdma, allocate bmdma resources */
+	rc = ata_bmdma_port_start(ap);
 	if (rc)
 		return rc;
 
@@ -1407,7 +1409,7 @@ static void nv_adma_qc_prep(struct ata_queued_cmd *qc)
 		BUG_ON(!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) &&
 			(qc->flags & ATA_QCFLAG_DMAMAP));
 		nv_adma_register_mode(qc->ap);
-		ata_sff_qc_prep(qc);
+		ata_bmdma_qc_prep(qc);
 		return;
 	}
 
@@ -1466,7 +1468,7 @@ static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc)
 		BUG_ON(!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) &&
 			(qc->flags & ATA_QCFLAG_DMAMAP));
 		nv_adma_register_mode(qc->ap);
-		return ata_sff_qc_issue(qc);
+		return ata_bmdma_qc_issue(qc);
 	} else
 		nv_adma_mode(qc->ap);
 
@@ -1498,22 +1500,19 @@ static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance)
 	spin_lock_irqsave(&host->lock, flags);
 
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap;
-
-		ap = host->ports[i];
-		if (ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct ata_queued_cmd *qc;
+		struct ata_port *ap = host->ports[i];
+		struct ata_queued_cmd *qc;
 
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)))
-				handled += ata_sff_host_intr(ap, qc);
-			else
-				// No request pending?  Clear interrupt status
-				// anyway, in case there's one pending.
-				ap->ops->sff_check_status(ap);
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
+			handled += ata_sff_host_intr(ap, qc);
+		} else {
+			/*
+			 * No request pending?  Clear interrupt status
+			 * anyway, in case there's one pending.
+			 */
+			ap->ops->sff_check_status(ap);
 		}
-
 	}
 
 	spin_unlock_irqrestore(&host->lock, flags);
@@ -1526,11 +1525,7 @@ static irqreturn_t nv_do_interrupt(struct ata_host *host, u8 irq_stat)
 	int i, handled = 0;
 
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		if (ap && !(ap->flags & ATA_FLAG_DISABLED))
-			handled += nv_host_intr(ap, irq_stat);
-
+		handled += nv_host_intr(host->ports[i], irq_stat);
 		irq_stat >>= NV_INT_PORT_SHIFT;
 	}
 
@@ -1744,7 +1739,7 @@ static void nv_adma_error_handler(struct ata_port *ap)
 		readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 	}
 
-	ata_sff_error_handler(ap);
+	ata_bmdma_error_handler(ap);
 }
 
 static void nv_swncq_qc_to_dq(struct ata_port *ap, struct ata_queued_cmd *qc)
@@ -1870,7 +1865,7 @@ static void nv_swncq_error_handler(struct ata_port *ap)
 		ehc->i.action |= ATA_EH_RESET;
 	}
 
-	ata_sff_error_handler(ap);
+	ata_bmdma_error_handler(ap);
 }
 
 #ifdef CONFIG_PM
@@ -1991,7 +1986,8 @@ static int nv_swncq_port_start(struct ata_port *ap)
 	struct nv_swncq_port_priv *pp;
 	int rc;
 
-	rc = ata_port_start(ap);
+	/* we might fallback to bmdma, allocate bmdma resources */
+	rc = ata_bmdma_port_start(ap);
 	if (rc)
 		return rc;
 
@@ -2016,7 +2012,7 @@ static int nv_swncq_port_start(struct ata_port *ap)
 static void nv_swncq_qc_prep(struct ata_queued_cmd *qc)
 {
 	if (qc->tf.protocol != ATA_PROT_NCQ) {
-		ata_sff_qc_prep(qc);
+		ata_bmdma_qc_prep(qc);
 		return;
 	}
 
@@ -2031,7 +2027,7 @@ static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
 	struct nv_swncq_port_priv *pp = ap->private_data;
-	struct ata_prd *prd;
+	struct ata_bmdma_prd *prd;
 	unsigned int si, idx;
 
 	prd = pp->prd + ATA_MAX_PRD * qc->tag;
@@ -2092,7 +2088,7 @@ static unsigned int nv_swncq_qc_issue(struct ata_queued_cmd *qc)
 	struct nv_swncq_port_priv *pp = ap->private_data;
 
 	if (qc->tf.protocol != ATA_PROT_NCQ)
-		return ata_sff_qc_issue(qc);
+		return ata_bmdma_qc_issue(qc);
 
 	DPRINTK("Enter\n");
 
@@ -2380,16 +2376,14 @@ static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance)
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-		if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-			if (ap->link.sactive) {
-				nv_swncq_host_interrupt(ap, (u16)irq_stat);
-				handled = 1;
-			} else {
-				if (irq_stat)	/* reserve Hotplug */
-					nv_swncq_irq_clear(ap, 0xfff0);
+		if (ap->link.sactive) {
+			nv_swncq_host_interrupt(ap, (u16)irq_stat);
+			handled = 1;
+		} else {
+			if (irq_stat)	/* reserve Hotplug */
+				nv_swncq_irq_clear(ap, 0xfff0);
 
-				handled += nv_host_intr(ap, (u8)irq_stat);
-			}
+			handled += nv_host_intr(ap, (u8)irq_stat);
 		}
 		irq_stat >>= NV_INT_PORT_SHIFT_MCP55;
 	}
@@ -2479,8 +2473,7 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ipriv->irq_handler,
-				 IRQF_SHARED, ipriv->sht);
+	return ata_pci_sff_activate_host(host, ipriv->irq_handler, ipriv->sht);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 5356ec0..f03ad48 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -333,7 +333,8 @@ static int pdc_common_port_start(struct ata_port *ap)
 	struct pdc_port_priv *pp;
 	int rc;
 
-	rc = ata_port_start(ap);
+	/* we use the same prd table as bmdma, allocate it */
+	rc = ata_bmdma_port_start(ap);
 	if (rc)
 		return rc;
 
@@ -499,7 +500,7 @@ static int pdc_sata_scr_write(struct ata_link *link,
 static void pdc_atapi_pkt(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	dma_addr_t sg_table = ap->prd_dma;
+	dma_addr_t sg_table = ap->bmdma_prd_dma;
 	unsigned int cdb_len = qc->dev->cdb_len;
 	u8 *cdb = qc->cdb;
 	struct pdc_port_priv *pp = ap->private_data;
@@ -587,6 +588,7 @@ static void pdc_atapi_pkt(struct ata_queued_cmd *qc)
 static void pdc_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
+	struct ata_bmdma_prd *prd = ap->bmdma_prd;
 	struct scatterlist *sg;
 	const u32 SG_COUNT_ASIC_BUG = 41*4;
 	unsigned int si, idx;
@@ -613,8 +615,8 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 			if ((offset + sg_len) > 0x10000)
 				len = 0x10000 - offset;
 
-			ap->prd[idx].addr = cpu_to_le32(addr);
-			ap->prd[idx].flags_len = cpu_to_le32(len & 0xffff);
+			prd[idx].addr = cpu_to_le32(addr);
+			prd[idx].flags_len = cpu_to_le32(len & 0xffff);
 			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
 
 			idx++;
@@ -623,27 +625,27 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 		}
 	}
 
-	len = le32_to_cpu(ap->prd[idx - 1].flags_len);
+	len = le32_to_cpu(prd[idx - 1].flags_len);
 
 	if (len > SG_COUNT_ASIC_BUG) {
 		u32 addr;
 
 		VPRINTK("Splitting last PRD.\n");
 
-		addr = le32_to_cpu(ap->prd[idx - 1].addr);
-		ap->prd[idx - 1].flags_len = cpu_to_le32(len - SG_COUNT_ASIC_BUG);
+		addr = le32_to_cpu(prd[idx - 1].addr);
+		prd[idx - 1].flags_len = cpu_to_le32(len - SG_COUNT_ASIC_BUG);
 		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx - 1, addr, SG_COUNT_ASIC_BUG);
 
 		addr = addr + len - SG_COUNT_ASIC_BUG;
 		len = SG_COUNT_ASIC_BUG;
-		ap->prd[idx].addr = cpu_to_le32(addr);
-		ap->prd[idx].flags_len = cpu_to_le32(len);
+		prd[idx].addr = cpu_to_le32(addr);
+		prd[idx].flags_len = cpu_to_le32(len);
 		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
 
 		idx++;
 	}
 
-	ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+	prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
 
 static void pdc_qc_prep(struct ata_queued_cmd *qc)
@@ -658,7 +660,7 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
 		pdc_fill_sg(qc);
 		/*FALLTHROUGH*/
 	case ATA_PROT_NODATA:
-		i = pdc_pkt_header(&qc->tf, qc->ap->prd_dma,
+		i = pdc_pkt_header(&qc->tf, qc->ap->bmdma_prd_dma,
 				   qc->dev->devno, pp->pkt);
 		if (qc->tf.flags & ATA_TFLAG_LBA48)
 			i = pdc_prep_lba48(&qc->tf, pp->pkt, i);
@@ -838,7 +840,7 @@ static void pdc_error_handler(struct ata_port *ap)
 	if (!(ap->pflags & ATA_PFLAG_FROZEN))
 		pdc_reset_port(ap);
 
-	ata_std_error_handler(ap);
+	ata_sff_error_handler(ap);
 }
 
 static void pdc_post_internal_cmd(struct ata_queued_cmd *qc)
@@ -984,8 +986,7 @@ static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 		/* check for a plug or unplug event */
 		ata_no = pdc_port_no_to_ata_no(i, is_sataii_tx4);
 		tmp = hotplug_status & (0x11 << ata_no);
-		if (tmp && ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
+		if (tmp) {
 			struct ata_eh_info *ehi = &ap->link.eh_info;
 			ata_ehi_clear_desc(ehi);
 			ata_ehi_hotplugged(ehi);
@@ -997,8 +998,7 @@ static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 
 		/* check for a packet interrupt */
 		tmp = mask & (1 << (i + 1));
-		if (tmp && ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
+		if (tmp) {
 			struct ata_queued_cmd *qc;
 
 			qc = ata_qc_from_tag(ap, ap->link.active_tag);
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 92ba45e..d533b3d 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -147,7 +147,6 @@ static struct ata_port_operations qs_ata_ops = {
 	.prereset		= qs_prereset,
 	.softreset		= ATA_OP_NULL,
 	.error_handler		= qs_error_handler,
-	.post_internal_cmd	= ATA_OP_NULL,
 	.lost_interrupt		= ATA_OP_NULL,
 
 	.scr_read		= qs_scr_read,
@@ -255,7 +254,7 @@ static int qs_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 static void qs_error_handler(struct ata_port *ap)
 {
 	qs_enter_reg_mode(ap);
-	ata_std_error_handler(ap);
+	ata_sff_error_handler(ap);
 }
 
 static int qs_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
@@ -304,10 +303,8 @@ static void qs_qc_prep(struct ata_queued_cmd *qc)
 	VPRINTK("ENTER\n");
 
 	qs_enter_reg_mode(qc->ap);
-	if (qc->tf.protocol != ATA_PROT_DMA) {
-		ata_sff_qc_prep(qc);
+	if (qc->tf.protocol != ATA_PROT_DMA)
 		return;
-	}
 
 	nelem = qs_fill_sg(qc);
 
@@ -404,26 +401,24 @@ static inline unsigned int qs_intr_pkt(struct ata_host *host)
 			u8 sHST = sff1 & 0x3f;	/* host status */
 			unsigned int port_no = (sff1 >> 8) & 0x03;
 			struct ata_port *ap = host->ports[port_no];
+			struct qs_port_priv *pp = ap->private_data;
+			struct ata_queued_cmd *qc;
 
 			DPRINTK("SFF=%08x%08x: sCHAN=%u sHST=%d sDST=%02x\n",
 					sff1, sff0, port_no, sHST, sDST);
 			handled = 1;
-			if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-				struct ata_queued_cmd *qc;
-				struct qs_port_priv *pp = ap->private_data;
-				if (!pp || pp->state != qs_state_pkt)
-					continue;
-				qc = ata_qc_from_tag(ap, ap->link.active_tag);
-				if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
-					switch (sHST) {
-					case 0: /* successful CPB */
-					case 3: /* device error */
-						qs_enter_reg_mode(qc->ap);
-						qs_do_or_die(qc, sDST);
-						break;
-					default:
-						break;
-					}
+			if (!pp || pp->state != qs_state_pkt)
+				continue;
+			qc = ata_qc_from_tag(ap, ap->link.active_tag);
+			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
+				switch (sHST) {
+				case 0: /* successful CPB */
+				case 3: /* device error */
+					qs_enter_reg_mode(qc->ap);
+					qs_do_or_die(qc, sDST);
+					break;
+				default:
+					break;
 				}
 			}
 		}
@@ -436,33 +431,30 @@ static inline unsigned int qs_intr_mmio(struct ata_host *host)
 	unsigned int handled = 0, port_no;
 
 	for (port_no = 0; port_no < host->n_ports; ++port_no) {
-		struct ata_port *ap;
-		ap = host->ports[port_no];
-		if (ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct ata_queued_cmd *qc;
-			struct qs_port_priv *pp;
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (!qc || !(qc->flags & ATA_QCFLAG_ACTIVE)) {
-				/*
-				 * The qstor hardware generates spurious
-				 * interrupts from time to time when switching
-				 * in and out of packet mode.
-				 * There's no obvious way to know if we're
-				 * here now due to that, so just ack the irq
-				 * and pretend we knew it was ours.. (ugh).
-				 * This does not affect packet mode.
-				 */
-				ata_sff_check_status(ap);
-				handled = 1;
-				continue;
-			}
-			pp = ap->private_data;
-			if (!pp || pp->state != qs_state_mmio)
-				continue;
-			if (!(qc->tf.flags & ATA_TFLAG_POLLING))
-				handled |= ata_sff_host_intr(ap, qc);
+		struct ata_port *ap = host->ports[port_no];
+		struct qs_port_priv *pp = ap->private_data;
+		struct ata_queued_cmd *qc;
+
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (!qc) {
+			/*
+			 * The qstor hardware generates spurious
+			 * interrupts from time to time when switching
+			 * in and out of packet mode.  There's no
+			 * obvious way to know if we're here now due
+			 * to that, so just ack the irq and pretend we
+			 * knew it was ours.. (ugh).  This does not
+			 * affect packet mode.
+			 */
+			ata_sff_check_status(ap);
+			handled = 1;
+			continue;
 		}
+
+		if (!pp || pp->state != qs_state_mmio)
+			continue;
+		if (!(qc->tf.flags & ATA_TFLAG_POLLING))
+			handled |= ata_sff_host_intr(ap, qc);
 	}
 	return handled;
 }
@@ -509,11 +501,7 @@ static int qs_port_start(struct ata_port *ap)
 	void __iomem *mmio_base = qs_mmio_base(ap->host);
 	void __iomem *chan = mmio_base + (ap->port_no * 0x4000);
 	u64 addr;
-	int rc;
 
-	rc = ata_port_start(ap);
-	if (rc)
-		return rc;
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
 		return -ENOMEM;
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 3cb69d5..2dda312 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -284,7 +284,7 @@ static void sil_bmdma_setup(struct ata_queued_cmd *qc)
 	void __iomem *bmdma = ap->ioaddr.bmdma_addr;
 
 	/* load PRD table addr. */
-	iowrite32(ap->prd_dma, bmdma + ATA_DMA_TABLE_OFS);
+	iowrite32(ap->bmdma_prd_dma, bmdma + ATA_DMA_TABLE_OFS);
 
 	/* issue r/w command */
 	ap->ops->sff_exec_command(ap, &qc->tf);
@@ -311,10 +311,10 @@ static void sil_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct scatterlist *sg;
 	struct ata_port *ap = qc->ap;
-	struct ata_prd *prd, *last_prd = NULL;
+	struct ata_bmdma_prd *prd, *last_prd = NULL;
 	unsigned int si;
 
-	prd = &ap->prd[0];
+	prd = &ap->bmdma_prd[0];
 	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		/* Note h/w doesn't support 64-bit, so we unconditionally
 		 * truncate dma_addr_t to u32.
@@ -532,9 +532,6 @@ static irqreturn_t sil_interrupt(int irq, void *dev_instance)
 		struct ata_port *ap = host->ports[i];
 		u32 bmdma2 = readl(mmio_base + sil_port[ap->port_no].bmdma2);
 
-		if (unlikely(ap->flags & ATA_FLAG_DISABLED))
-			continue;
-
 		/* turn off SATA_IRQ if not supported */
 		if (ap->flags & SIL_FLAG_NO_SATA_IRQ)
 			bmdma2 &= ~SIL_DMA_SATA_IRQ;
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 433b6b8..e925051 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1160,13 +1160,8 @@ static irqreturn_t sil24_interrupt(int irq, void *dev_instance)
 
 	for (i = 0; i < host->n_ports; i++)
 		if (status & (1 << i)) {
-			struct ata_port *ap = host->ports[i];
-			if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-				sil24_host_intr(ap);
-				handled++;
-			} else
-				printk(KERN_ERR DRV_NAME
-				       ": interrupt from disabled port %d\n", i);
+			sil24_host_intr(host->ports[i]);
+			handled++;
 		}
 
 	spin_unlock(&host->lock);
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 7257f2d..101fd6a 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -224,7 +224,7 @@ static void k2_bmdma_setup_mmio(struct ata_queued_cmd *qc)
 
 	/* load PRD table addr. */
 	mb();	/* make sure PRD table writes are visible to controller */
-	writel(ap->prd_dma, mmio + ATA_DMA_TABLE_OFS);
+	writel(ap->bmdma_prd_dma, mmio + ATA_DMA_TABLE_OFS);
 
 	/* specify data direction, triple-check start bit is clear */
 	dmactl = readb(mmio + ATA_DMA_CMD);
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 232468f..bedd518 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -302,11 +302,6 @@ static int pdc_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
 	struct pdc_port_priv *pp;
-	int rc;
-
-	rc = ata_port_start(ap);
-	if (rc)
-		return rc;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
@@ -840,8 +835,7 @@ static irqreturn_t pdc20621_interrupt(int irq, void *dev_instance)
 			ap = host->ports[port_no];
 		tmp = mask & (1 << i);
 		VPRINTK("seq %u, port_no %u, ap %p, tmp %x\n", i, port_no, ap, tmp);
-		if (tmp && ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
+		if (tmp && ap) {
 			struct ata_queued_cmd *qc;
 
 			qc = ata_qc_from_tag(ap, ap->link.active_tag);
@@ -927,7 +921,7 @@ static void pdc_error_handler(struct ata_port *ap)
 	if (!(ap->pflags & ATA_PFLAG_FROZEN))
 		pdc_reset_port(ap);
 
-	ata_std_error_handler(ap);
+	ata_sff_error_handler(ap);
 }
 
 static void pdc_post_internal_cmd(struct ata_queued_cmd *qc)
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 011e098..d8dac17 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -181,9 +181,7 @@ static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = ata_pci_bmdma_init(host);
-	if (rc)
-		return rc;
+	ata_pci_bmdma_init(host);
 
 	iomap = host->iomap;
 
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 8b2a278..2107952 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -284,14 +284,8 @@ static irqreturn_t vsc_sata_interrupt(int irq, void *dev_instance)
 	for (i = 0; i < host->n_ports; i++) {
 		u8 port_status = (status >> (8 * i)) & 0xff;
 		if (port_status) {
-			struct ata_port *ap = host->ports[i];
-
-			if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-				vsc_port_intr(port_status, ap);
-				handled++;
-			} else
-				dev_printk(KERN_ERR, host->dev,
-					"interrupt from disabled port %d\n", i);
+			vsc_port_intr(port_status, host->ports[i]);
+			handled++;
 		}
 	}
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 520461b..b90c118 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4295,7 +4295,7 @@ static void ipr_slave_destroy(struct scsi_device *sdev)
 	res = (struct ipr_resource_entry *) sdev->hostdata;
 	if (res) {
 		if (res->sata_port)
-			ata_port_disable(res->sata_port->ap);
+			res->sata_port->ap->link.device[0].class = ATA_DEV_NONE;
 		sdev->hostdata = NULL;
 		res->sdev = NULL;
 		res->sata_port = NULL;
@@ -5751,13 +5751,13 @@ static void ipr_ata_phy_reset(struct ata_port *ap)
 	rc = ipr_device_reset(ioa_cfg, res);
 
 	if (rc) {
-		ata_port_disable(ap);
+		ap->link.device[0].class = ATA_DEV_NONE;
 		goto out_unlock;
 	}
 
 	ap->link.device[0].class = res->ata_class;
 	if (ap->link.device[0].class == ATA_DEV_UNKNOWN)
-		ata_port_disable(ap);
+		ap->link.device[0].class = ATA_DEV_NONE;
 
 out_unlock:
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 8228350..b71b6d4 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -818,7 +818,7 @@ void sas_slave_destroy(struct scsi_device *scsi_dev)
 	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 
 	if (dev_is_sata(dev))
-		ata_port_disable(dev->sata_dev.ap);
+		dev->sata_dev.ap->link.device[0].class = ATA_DEV_NONE;
 }
 
 int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth,
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
new file mode 100644
index 0000000..f7dd576
--- /dev/null
+++ b/include/linux/ahci_platform.h
@@ -0,0 +1,29 @@
+/*
+ * AHCI SATA platform driver
+ *
+ * Copyright 2004-2005  Red Hat, Inc.
+ *   Jeff Garzik <jgarzik@pobox.com>
+ * Copyright 2010  MontaVista Software, LLC.
+ *   Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ */
+
+#ifndef _AHCI_PLATFORM_H
+#define _AHCI_PLATFORM_H
+
+struct device;
+struct ata_port_info;
+
+struct ahci_platform_data {
+	int (*init)(struct device *dev);
+	void (*exit)(struct device *dev);
+	const struct ata_port_info *ata_port_info;
+	unsigned int force_port_map;
+	unsigned int mask_port_map;
+};
+
+#endif /* _AHCI_PLATFORM_H */
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 700c5b9..fe6e681 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -467,7 +467,7 @@ enum ata_ioctls {
 
 /* core structures */
 
-struct ata_prd {
+struct ata_bmdma_prd {
 	__le32			addr;
 	__le32			flags_len;
 };
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b2f2003..ee84e7e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -202,12 +202,6 @@ enum {
 	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
 					      * led */
 
-	/* The following flag belongs to ap->pflags but is kept in
-	 * ap->flags because it's referenced in many LLDs and will be
-	 * removed in not-too-distant future.
-	 */
-	ATA_FLAG_DISABLED	= (1 << 23), /* port is disabled, ignore it */
-
 	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
 
 
@@ -256,12 +250,13 @@ enum {
 	ATA_TMOUT_INTERNAL_QUICK = 5000,
 	ATA_TMOUT_MAX_PARK	= 30000,
 
-	/* FIXME: GoVault needs 2s but we can't afford that without
-	 * parallel probing.  800ms is enough for iVDR disk
-	 * HHD424020F7SV00.  Increase to 2secs when parallel probing
-	 * is in place.
+	/*
+	 * GoVault needs 2s and iVDR disk HHD424020F7SV00 800ms.  2s
+	 * is too much without parallel probing.  Use 2s if parallel
+	 * probing is available, 800ms otherwise.
 	 */
-	ATA_TMOUT_FF_WAIT	=  800,
+	ATA_TMOUT_FF_WAIT_LONG	=  2000,
+	ATA_TMOUT_FF_WAIT	=   800,
 
 	/* Spec mandates to wait for ">= 2ms" before checking status
 	 * after reset.  We wait 150ms, because that was the magic
@@ -721,15 +716,15 @@ struct ata_port {
 	unsigned int		print_id; /* user visible unique port ID */
 	unsigned int		port_no; /* 0 based port no. inside the host */
 
-	struct ata_prd		*prd;	 /* our SG list */
-	dma_addr_t		prd_dma; /* and its DMA mapping */
-
 #ifdef CONFIG_ATA_SFF
 	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
-#endif /* CONFIG_ATA_SFF */
-
 	u8			ctl;	/* cache of ATA control register */
 	u8			last_ctl;	/* Cache last written value */
+	struct delayed_work	sff_pio_task;
+	struct ata_bmdma_prd	*bmdma_prd;	/* BMDMA SG list */
+	dma_addr_t		bmdma_prd_dma;	/* and its DMA mapping */
+#endif /* CONFIG_ATA_SFF */
+
 	unsigned int		pio_mask;
 	unsigned int		mwdma_mask;
 	unsigned int		udma_mask;
@@ -751,8 +746,6 @@ struct ata_port {
 	struct ata_host		*host;
 	struct device 		*dev;
 
-	void			*port_task_data;
-	struct delayed_work	port_task;
 	struct delayed_work	hotplug_task;
 	struct work_struct	scsi_rescan_task;
 
@@ -849,6 +842,7 @@ struct ata_port_operations {
 	 * SFF / taskfile oriented ops
 	 */
 	void (*sff_dev_select)(struct ata_port *ap, unsigned int device);
+	void (*sff_set_devctl)(struct ata_port *ap, u8 ctl);
 	u8   (*sff_check_status)(struct ata_port *ap);
 	u8   (*sff_check_altstatus)(struct ata_port *ap);
 	void (*sff_tf_load)(struct ata_port *ap, const struct ata_taskfile *tf);
@@ -857,16 +851,15 @@ struct ata_port_operations {
 				 const struct ata_taskfile *tf);
 	unsigned int (*sff_data_xfer)(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
-	u8   (*sff_irq_on)(struct ata_port *);
+	void (*sff_irq_on)(struct ata_port *);
 	bool (*sff_irq_check)(struct ata_port *);
 	void (*sff_irq_clear)(struct ata_port *);
+	void (*sff_drain_fifo)(struct ata_queued_cmd *qc);
 
 	void (*bmdma_setup)(struct ata_queued_cmd *qc);
 	void (*bmdma_start)(struct ata_queued_cmd *qc);
 	void (*bmdma_stop)(struct ata_queued_cmd *qc);
 	u8   (*bmdma_status)(struct ata_port *ap);
-
-	void (*drain_fifo)(struct ata_queued_cmd *qc);
 #endif /* CONFIG_ATA_SFF */
 
 	ssize_t (*em_show)(struct ata_port *ap, char *buf);
@@ -935,7 +928,6 @@ static inline int ata_port_is_dummy(struct ata_port *ap)
 	return ap->ops == &ata_dummy_port_ops;
 }
 
-extern void ata_port_probe(struct ata_port *);
 extern int sata_set_spd(struct ata_link *link);
 extern int ata_std_prereset(struct ata_link *link, unsigned long deadline);
 extern int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
@@ -950,7 +942,6 @@ extern int sata_link_hardreset(struct ata_link *link,
 extern int sata_std_hardreset(struct ata_link *link, unsigned int *class,
 			      unsigned long deadline);
 extern void ata_std_postreset(struct ata_link *link, unsigned int *classes);
-extern void ata_port_disable(struct ata_port *);
 
 extern struct ata_host *ata_host_alloc(struct device *dev, int max_ports);
 extern struct ata_host *ata_host_alloc_pinfo(struct device *dev,
@@ -1006,7 +997,6 @@ extern unsigned long ata_xfer_mode2mask(u8 xfer_mode);
 extern int ata_xfer_mode2shift(unsigned long xfer_mode);
 extern const char *ata_mode_string(unsigned long xfer_mask);
 extern unsigned long ata_id_xfermask(const u16 *id);
-extern int ata_port_start(struct ata_port *ap);
 extern int ata_std_qc_defer(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
@@ -1039,9 +1029,6 @@ extern int ata_cable_sata(struct ata_port *ap);
 extern int ata_cable_ignore(struct ata_port *ap);
 extern int ata_cable_unknown(struct ata_port *ap);
 
-extern void ata_pio_queue_task(struct ata_port *ap, void *data,
-			       unsigned long delay);
-
 /* Timing helpers */
 extern unsigned int ata_pio_need_iordy(const struct ata_device *);
 extern const struct ata_timing *ata_timing_find_mode(u8 xfer_mode);
@@ -1443,7 +1430,11 @@ static inline void ata_tf_init(struct ata_device *dev, struct ata_taskfile *tf)
 {
 	memset(tf, 0, sizeof(*tf));
 
+#ifdef CONFIG_ATA_SFF
 	tf->ctl = dev->link->ap->ctl;
+#else
+	tf->ctl = ATA_DEVCTL_OBS;
+#endif
 	if (dev->devno == 0)
 		tf->device = ATA_DEVICE_OBS;
 	else
@@ -1578,8 +1569,6 @@ extern const struct ata_port_operations ata_bmdma32_port_ops;
 	.sg_tablesize		= LIBATA_MAX_PRD,		\
 	.dma_boundary		= ATA_DMA_BOUNDARY
 
-extern void ata_sff_qc_prep(struct ata_queued_cmd *qc);
-extern void ata_sff_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sff_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_sff_check_status(struct ata_port *ap);
 extern void ata_sff_pause(struct ata_port *ap);
@@ -1597,10 +1586,11 @@ extern unsigned int ata_sff_data_xfer32(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
 extern unsigned int ata_sff_data_xfer_noirq(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
-extern u8 ata_sff_irq_on(struct ata_port *ap);
+extern void ata_sff_irq_on(struct ata_port *ap);
 extern void ata_sff_irq_clear(struct ata_port *ap);
 extern int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 			    u8 status, int in_wq);
+extern void ata_sff_queue_pio_task(struct ata_port *ap, unsigned long delay);
 extern unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc);
 extern bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc);
 extern unsigned int ata_sff_host_intr(struct ata_port *ap,
@@ -1621,21 +1611,8 @@ extern int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
 extern void ata_sff_postreset(struct ata_link *link, unsigned int *classes);
 extern void ata_sff_drain_fifo(struct ata_queued_cmd *qc);
 extern void ata_sff_error_handler(struct ata_port *ap);
-extern void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc);
-extern int ata_sff_port_start(struct ata_port *ap);
-extern int ata_sff_port_start32(struct ata_port *ap);
 extern void ata_sff_std_ports(struct ata_ioports *ioaddr);
-extern unsigned long ata_bmdma_mode_filter(struct ata_device *dev,
-					   unsigned long xfer_mask);
-extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
-extern void ata_bmdma_start(struct ata_queued_cmd *qc);
-extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
-extern u8 ata_bmdma_status(struct ata_port *ap);
-extern void ata_bus_reset(struct ata_port *ap);
-
 #ifdef CONFIG_PCI
-extern int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev);
-extern int ata_pci_bmdma_init(struct ata_host *host);
 extern int ata_pci_sff_init_host(struct ata_host *host);
 extern int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 				    const struct ata_port_info * const * ppi,
@@ -1648,6 +1625,23 @@ extern int ata_pci_sff_init_one(struct pci_dev *pdev,
 		struct scsi_host_template *sht, void *host_priv, int hflags);
 #endif /* CONFIG_PCI */
 
+extern void ata_bmdma_qc_prep(struct ata_queued_cmd *qc);
+extern unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc);
+extern void ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc);
+extern void ata_bmdma_error_handler(struct ata_port *ap);
+extern void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc);
+extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
+extern void ata_bmdma_start(struct ata_queued_cmd *qc);
+extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
+extern u8 ata_bmdma_status(struct ata_port *ap);
+extern int ata_bmdma_port_start(struct ata_port *ap);
+extern int ata_bmdma_port_start32(struct ata_port *ap);
+
+#ifdef CONFIG_PCI
+extern int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev);
+extern void ata_pci_bmdma_init(struct ata_host *host);
+#endif /* CONFIG_PCI */
+
 /**
  *	ata_sff_busy_wait - Wait for a port status register
  *	@ap: Port to wait for.
