Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab0E1BTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:19:06 -0400
Received: from havoc.gtf.org ([69.61.125.42]:35338 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab0E1BS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:18:58 -0400
Date: Thu, 27 May 2010 21:18:56 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20100528011856.GA32587@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Finish Tejun's SFF<->BMDMA separation patchset, as mentioned in
   initial 2.6.35 push.  These had been submitted prior to merge
   window open, but had to wait to resolve some patch/merge conflicts.

2) Disable Asynchronous Notification (AN) by default.  Proper use
   is vague, and behavior of firmwares in the field do not match each
   other.

3) add 'dump_id' debugging output helper, to give us better bug reports


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/kernel-parameters.txt |    2 +
 drivers/ata/Kconfig                 |  511 ++++++++++++++++++-----------------
 drivers/ata/Makefile                |   83 ++++---
 drivers/ata/ata_generic.c           |    2 +-
 drivers/ata/ata_piix.c              |    4 +-
 drivers/ata/libata-core.c           |   16 +-
 drivers/ata/libata-sff.c            |  416 ++++++++++++++++++++---------
 drivers/ata/pata_acpi.c             |    2 +-
 drivers/ata/pata_ali.c              |    5 +-
 drivers/ata/pata_amd.c              |    2 +-
 drivers/ata/pata_artop.c            |    2 +-
 drivers/ata/pata_atiixp.c           |    4 +-
 drivers/ata/pata_atp867x.c          |    2 +-
 drivers/ata/pata_bf54x.c            |    2 +-
 drivers/ata/pata_cmd64x.c           |    2 +-
 drivers/ata/pata_cs5520.c           |    2 +-
 drivers/ata/pata_cs5530.c           |    2 +-
 drivers/ata/pata_cs5535.c           |    2 +-
 drivers/ata/pata_cs5536.c           |    2 +-
 drivers/ata/pata_cypress.c          |    2 +-
 drivers/ata/pata_efar.c             |    4 +-
 drivers/ata/pata_hpt366.c           |    2 +-
 drivers/ata/pata_hpt37x.c           |    2 +-
 drivers/ata/pata_hpt3x2n.c          |    2 +-
 drivers/ata/pata_hpt3x3.c           |    2 +-
 drivers/ata/pata_icside.c           |    2 +-
 drivers/ata/pata_it8213.c           |    2 +-
 drivers/ata/pata_it821x.c           |    2 +-
 drivers/ata/pata_jmicron.c          |    2 +-
 drivers/ata/pata_macio.c            |    2 +-
 drivers/ata/pata_marvell.c          |    2 +-
 drivers/ata/pata_mpc52xx.c          |    2 +-
 drivers/ata/pata_netcell.c          |    2 +-
 drivers/ata/pata_ninja32.c          |    2 +-
 drivers/ata/pata_ns87415.c          |    2 +-
 drivers/ata/pata_octeon_cf.c        |   18 --
 drivers/ata/pata_oldpiix.c          |    2 +-
 drivers/ata/pata_optidma.c          |    2 +-
 drivers/ata/pata_pdc2027x.c         |    2 +-
 drivers/ata/pata_pdc202xx_old.c     |    2 +-
 drivers/ata/pata_piccolo.c          |    2 +-
 drivers/ata/pata_radisys.c          |    2 +-
 drivers/ata/pata_rdc.c              |    4 +-
 drivers/ata/pata_sc1200.c           |    2 +-
 drivers/ata/pata_scc.c              |    4 +-
 drivers/ata/pata_sch.c              |    2 +-
 drivers/ata/pata_serverworks.c      |    2 +-
 drivers/ata/pata_sil680.c           |    4 +-
 drivers/ata/pata_sis.c              |    2 +-
 drivers/ata/pata_sl82c105.c         |    2 +-
 drivers/ata/pata_triflex.c          |    2 +-
 drivers/ata/pata_via.c              |    2 +-
 drivers/ata/sata_mv.c               |    4 +-
 drivers/ata/sata_nv.c               |    8 +-
 drivers/ata/sata_qstor.c            |   16 +-
 drivers/ata/sata_sil.c              |    4 +-
 drivers/ata/sata_sis.c              |    4 +-
 drivers/ata/sata_svw.c              |    2 +-
 drivers/ata/sata_uli.c              |    2 +-
 drivers/ata/sata_via.c              |    8 +-
 drivers/ata/sata_vsc.c              |    2 +-
 include/linux/libata.h              |   36 ++-
 62 files changed, 720 insertions(+), 519 deletions(-)

Tejun Heo (8):
      sata_mv: drop unncessary EH callback resetting
      libata-sff: ata_sff_irq_clear() is BMDMA specific
      libata-sff: separate out BMDMA irq handler
      libata-sff: separate out BMDMA init
      libata-sff: kill dummy BMDMA ops from sata_qstor and pata_octeon_cf
      libata-sff: make BMDMA optional
      libata: disable ATAPI AN by default
      libata: implement dump_id force param

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b56ea86..a5c0550 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1252,6 +1252,8 @@ and is between 256 and 4096 characters. It is defined in the file
 			* nohrst, nosrst, norst: suppress hard, soft
                           and both resets.
 
+			* dump_id: dump IDENTIFY data.
+
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index e68541f..73f8833 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -57,6 +57,8 @@ config SATA_PMP
 	  This option adds support for SATA Port Multipliers
 	  (the SATA version of an ethernet hub, or SAS expander).
 
+comment "Controllers with non-SFF native interface"
+
 config SATA_AHCI
 	tristate "AHCI SATA support"
 	depends on PCI
@@ -73,11 +75,12 @@ config SATA_AHCI_PLATFORM
 
 	  If unsure, say N.
 
-config SATA_SIL24
-	tristate "Silicon Image 3124/3132 SATA support"
-	depends on PCI
+config SATA_FSL
+	tristate "Freescale 3.0Gbps SATA support"
+	depends on FSL_SOC
 	help
-	  This option enables support for Silicon Image 3124/3132 Serial ATA.
+	  This option enables support for Freescale 3.0Gbps SATA controller.
+	  It can be found on MPC837x and MPC8315.
 
 	  If unsure, say N.
 
@@ -87,12 +90,11 @@ config SATA_INIC162X
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
-config SATA_FSL
-	tristate "Freescale 3.0Gbps SATA support"
-	depends on FSL_SOC
+config SATA_SIL24
+	tristate "Silicon Image 3124/3132 SATA support"
+	depends on PCI
 	help
-	  This option enables support for Freescale 3.0Gbps SATA controller.
-	  It can be found on MPC837x and MPC8315.
+	  This option enables support for Silicon Image 3124/3132 Serial ATA.
 
 	  If unsure, say N.
 
@@ -116,15 +118,65 @@ config ATA_SFF
 
 if ATA_SFF
 
-config SATA_SVW
-	tristate "ServerWorks Frodo / Apple K2 SATA support"
+comment "SFF controllers with custom DMA interface"
+
+config PDC_ADMA
+	tristate "Pacific Digital ADMA support"
 	depends on PCI
 	help
-	  This option enables support for Broadcom/Serverworks/Apple K2
-	  SATA support.
+	  This option enables support for Pacific Digital ADMA controllers
+
+	  If unsure, say N.
+
+config PATA_MPC52xx
+	tristate "Freescale MPC52xx SoC internal IDE"
+	depends on PPC_MPC52xx && PPC_BESTCOMM
+	select PPC_BESTCOMM_ATA
+	help
+	  This option enables support for integrated IDE controller
+	  of the Freescale MPC52xx SoC.
+
+	  If unsure, say N.
+
+config PATA_OCTEON_CF
+	tristate "OCTEON Boot Bus Compact Flash support"
+	depends on CPU_CAVIUM_OCTEON
+	help
+	  This option enables a polled compact flash driver for use with
+	  compact flash cards attached to the OCTEON boot bus.
+
+	  If unsure, say N.
+
+config SATA_QSTOR
+	tristate "Pacific Digital SATA QStor support"
+	depends on PCI
+	help
+	  This option enables support for Pacific Digital Serial ATA QStor.
+
+	  If unsure, say N.
+
+config SATA_SX4
+	tristate "Promise SATA SX4 support (Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This option enables support for Promise Serial ATA SX4.
 
 	  If unsure, say N.
 
+config ATA_BMDMA
+	bool "ATA BMDMA support"
+	default y
+	help
+	  This option adds support for SFF ATA controllers with BMDMA
+	  capability.  BMDMA stands for bus-master DMA and the
+	  de-facto DMA interface for SFF controllers.
+
+	  If unuser, say Y.
+
+if ATA_BMDMA
+
+comment "SATA SFF controllers with BMDMA"
+
 config ATA_PIIX
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
 	depends on PCI
@@ -152,22 +204,6 @@ config SATA_NV
 
 	  If unsure, say N.
 
-config PDC_ADMA
-	tristate "Pacific Digital ADMA support"
-	depends on PCI
-	help
-	  This option enables support for Pacific Digital ADMA controllers
-
-	  If unsure, say N.
-
-config SATA_QSTOR
-	tristate "Pacific Digital SATA QStor support"
-	depends on PCI
-	help
-	  This option enables support for Pacific Digital Serial ATA QStor.
-
-	  If unsure, say N.
-
 config SATA_PROMISE
 	tristate "Promise SATA TX2/TX4 support"
 	depends on PCI
@@ -176,14 +212,6 @@ config SATA_PROMISE
 
 	  If unsure, say N.
 
-config SATA_SX4
-	tristate "Promise SATA SX4 support (Experimental)"
-	depends on PCI && EXPERIMENTAL
-	help
-	  This option enables support for Promise Serial ATA SX4.
-
-	  If unsure, say N.
-
 config SATA_SIL
 	tristate "Silicon Image SATA support"
 	depends on PCI
@@ -203,6 +231,15 @@ config SATA_SIS
 	  enable the PATA_SIS driver in the config.
 	  If unsure, say N.
 
+config SATA_SVW
+	tristate "ServerWorks Frodo / Apple K2 SATA support"
+	depends on PCI
+	help
+	  This option enables support for Broadcom/Serverworks/Apple K2
+	  SATA support.
+
+	  If unsure, say N.
+
 config SATA_ULI
 	tristate "ULi Electronics SATA support"
 	depends on PCI
@@ -227,14 +264,7 @@ config SATA_VITESSE
 
 	  If unsure, say N.
 
-config PATA_ACPI
-	tristate "ACPI firmware driver for PATA"
-	depends on ATA_ACPI
-	help
-	  This option enables an ACPI method driver which drives
-	  motherboard PATA controller interfaces through the ACPI
-	  firmware in the BIOS. This driver can sometimes handle
-	  otherwise unsupported hardware.
+comment "PATA SFF controllers with BMDMA"
 
 config PATA_ALI
 	tristate "ALi PATA support"
@@ -262,40 +292,30 @@ config PATA_ARTOP
 
 	  If unsure, say N.
 
-config PATA_ATP867X
-	tristate "ARTOP/Acard ATP867X PATA support"
+config PATA_ATIIXP
+	tristate "ATI PATA support"
 	depends on PCI
 	help
-	  This option enables support for ARTOP/Acard ATP867X PATA
-	  controllers.
-
-	  If unsure, say N.
-
-config PATA_AT32
-	tristate "Atmel AVR32 PATA support (Experimental)"
-	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
-	help
-	  This option enables support for the IDE devices on the
-	  Atmel AT32AP platform.
+	  This option enables support for the ATI ATA interfaces
+	  found on the many ATI chipsets.
 
 	  If unsure, say N.
 
-config PATA_ATIIXP
-	tristate "ATI PATA support"
+config PATA_ATP867X
+	tristate "ARTOP/Acard ATP867X PATA support"
 	depends on PCI
 	help
-	  This option enables support for the ATI ATA interfaces
-	  found on the many ATI chipsets.
+	  This option enables support for ARTOP/Acard ATP867X PATA
+	  controllers.
 
 	  If unsure, say N.
 
-config PATA_CMD640_PCI
-	tristate "CMD640 PCI PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+config PATA_BF54X
+	tristate "Blackfin 54x ATAPI support"
+	depends on BF542 || BF548 || BF549
 	help
-	  This option enables support for the CMD640 PCI IDE
-	  interface chip. Only the primary channel is currently
-	  supported.
+	  This option enables support for the built-in ATAPI controller on
+	  Blackfin 54x family chips.
 
 	  If unsure, say N.
 
@@ -362,15 +382,6 @@ config PATA_EFAR
 
 	  If unsure, say N.
 
-config ATA_GENERIC
-	tristate "Generic ATA support"
-	depends on PCI
-	help
-	  This option enables support for generic BIOS configured
-	  ATA controllers via the new ATA layer
-
-	  If unsure, say N.
-
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
 	depends on PCI
@@ -415,12 +426,20 @@ config PATA_HPT3X3_DMA
 	  controllers. Enable with care as there are still some
 	  problems with DMA on this chipset.
 
-config PATA_ISAPNP
-	tristate "ISA Plug and Play PATA support"
-	depends on ISAPNP
+config PATA_ICSIDE
+	tristate "Acorn ICS PATA support"
+	depends on ARM && ARCH_ACORN
 	help
-	  This option enables support for ISA plug & play ATA
-	  controllers such as those found on old soundcards.
+	  On Acorn systems, say Y here if you wish to use the ICS PATA
+	  interface card.  This is not required for ICS partition support.
+	  If you are unsure, say N to this.
+
+config PATA_IT8213
+	tristate "IT8213 PATA support (Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This option enables support for the ITE 821 PATA
+          controllers via the new ATA layer.
 
 	  If unsure, say N.
 
@@ -434,15 +453,6 @@ config PATA_IT821X
 
 	  If unsure, say N.
 
-config PATA_IT8213
-	tristate "IT8213 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
-	help
-	  This option enables support for the ITE 821 PATA
-          controllers via the new ATA layer.
-
-	  If unsure, say N.
-
 config PATA_JMICRON
 	tristate "JMicron PATA support"
 	depends on PCI
@@ -452,23 +462,14 @@ config PATA_JMICRON
 
 	  If unsure, say N.
 
-config PATA_LEGACY
-	tristate "Legacy ISA PATA support (Experimental)"
-	depends on (ISA || PCI)  && EXPERIMENTAL
-	help
-	  This option enables support for ISA/VLB/PCI bus legacy PATA
-	  ports and allows them to be accessed via the new ATA layer.
-
-	  If unsure, say N.
-
-config PATA_TRIFLEX
-	tristate "Compaq Triflex PATA support"
-	depends on PCI
+config PATA_MACIO
+	tristate "Apple PowerMac/PowerBook internal 'MacIO' IDE"
+	depends on PPC_PMAC
 	help
-	  Enable support for the Compaq 'Triflex' IDE controller as found
-	  on many Compaq Pentium-Pro systems, via the new ATA layer.
-
-	  If unsure, say N.
+	  Most IDE capable PowerMacs have IDE busses driven by a variant
+          of this controller which is part of the Apple chipset used on
+          most PowerMac models. Some models have multiple busses using
+          different chipsets, though generally, MacIO is one of them.
 
 config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
@@ -481,32 +482,6 @@ config PATA_MARVELL
 
 	  If unsure, say N.
 
-config PATA_MPC52xx
-	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on PPC_MPC52xx && PPC_BESTCOMM
-	select PPC_BESTCOMM_ATA
-	help
-	  This option enables support for integrated IDE controller
-	  of the Freescale MPC52xx SoC.
-
-	  If unsure, say N.
-
-config PATA_MPIIX
-	tristate "Intel PATA MPIIX support"
-	depends on PCI
-	help
-	  This option enables support for MPIIX PATA support.
-
-	  If unsure, say N.
-
-config PATA_OLDPIIX
-	tristate "Intel PATA old PIIX support"
-	depends on PCI
-	help
-	  This option enables support for early PIIX PATA support.
-
-	  If unsure, say N.
-
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
 	depends on PCI
@@ -525,15 +500,6 @@ config PATA_NINJA32
 
 	  If unsure, say N.
 
-config PATA_NS87410
-	tristate "Nat Semi NS87410 PATA support"
-	depends on PCI
-	help
-	  This option enables support for the National Semiconductor
-	  NS87410 PCI-IDE controller.
-
-	  If unsure, say N.
-
 config PATA_NS87415
 	tristate "Nat Semi NS87415 PATA support"
 	depends on PCI
@@ -543,12 +509,11 @@ config PATA_NS87415
 
 	  If unsure, say N.
 
-config PATA_OPTI
-	tristate "OPTI621/6215 PATA support (Very Experimental)"
-	depends on PCI && EXPERIMENTAL
+config PATA_OLDPIIX
+	tristate "Intel PATA old PIIX support"
+	depends on PCI
 	help
-	  This option enables full PIO support for the early Opti ATA
-	  controllers found on some old motherboards.
+	  This option enables support for early PIIX PATA support.
 
 	  If unsure, say N.
 
@@ -562,24 +527,6 @@ config PATA_OPTIDMA
 
 	  If unsure, say N.
 
-config PATA_PALMLD
-	tristate "Palm LifeDrive PATA support"
-	depends on MACH_PALMLD
-	help
-	  This option enables support for Palm LifeDrive's internal ATA
-	  port via the new ATA layer.
-
-	  If unsure, say N.
-
-config PATA_PCMCIA
-	tristate "PCMCIA PATA support"
-	depends on PCMCIA
-	help
-	  This option enables support for PCMCIA ATA interfaces, including
-	  compact flash card adapters via the new ATA layer.
-
-	  If unsure, say N.
-
 config PATA_PDC2027X
 	tristate "Promise PATA 2027x support"
 	depends on PCI
@@ -597,12 +544,6 @@ config PATA_PDC_OLD
 
 	  If unsure, say N.
 
-config PATA_QDI
-	tristate "QDI VLB PATA support"
-	depends on ISA
-	help
-	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
-
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -612,15 +553,6 @@ config PATA_RADISYS
 
 	  If unsure, say N.
 
-config PATA_RB532
-	tristate "RouterBoard 532 PATA CompactFlash support"
-	depends on MIKROTIK_RB532
-	help
-	  This option enables support for the RouterBoard 532
-	  PATA CompactFlash controller.
-
-	  If unsure, say N.
-
 config PATA_RDC
 	tristate "RDC PATA support"
 	depends on PCI
@@ -631,21 +563,30 @@ config PATA_RDC
 
 	  If unsure, say N.
 
-config PATA_RZ1000
-	tristate "PC Tech RZ1000 PATA support"
+config PATA_SC1200
+	tristate "SC1200 PATA support"
 	depends on PCI
 	help
-	  This option enables basic support for the PC Tech RZ1000/1
-	  PATA controllers via the new ATA layer
+	  This option enables support for the NatSemi/AMD SC1200 SoC
+	  companion chip used with the Geode processor family.
 
 	  If unsure, say N.
 
-config PATA_SC1200
-	tristate "SC1200 PATA support"
+config PATA_SCC
+	tristate "Toshiba's Cell Reference Set IDE support"
+	depends on PCI && PPC_CELLEB
+	help
+	  This option enables support for the built-in IDE controller on
+	  Toshiba Cell Reference Board.
+
+	  If unsure, say N.
+
+config PATA_SCH
+	tristate "Intel SCH PATA support"
 	depends on PCI
 	help
-	  This option enables support for the NatSemi/AMD SC1200 SoC
-	  companion chip used with the Geode processor family.
+	  This option enables support for Intel SCH PATA on the Intel
+	  SCH (US15W, US15L, UL11L) series host controllers.
 
 	  If unsure, say N.
 
@@ -683,6 +624,15 @@ config PATA_TOSHIBA
 
 	  If unsure, say N.
 
+config PATA_TRIFLEX
+	tristate "Compaq Triflex PATA support"
+	depends on PCI
+	help
+	  Enable support for the Compaq 'Triflex' IDE controller as found
+	  on many Compaq Pentium-Pro systems, via the new ATA layer.
+
+	  If unsure, say N.
+
 config PATA_VIA
 	tristate "VIA PATA support"
 	depends on PCI
@@ -701,12 +651,99 @@ config PATA_WINBOND
 
 	  If unsure, say N.
 
-config PATA_WINBOND_VLB
-	tristate "Winbond W83759A VLB PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+endif # ATA_BMDMA
+
+comment "PIO-only SFF controllers"
+
+config PATA_AT32
+	tristate "Atmel AVR32 PATA support (Experimental)"
+	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
 	help
-	  Support for the Winbond W83759A controller on Vesa Local Bus
-	  systems.
+	  This option enables support for the IDE devices on the
+	  Atmel AT32AP platform.
+
+	  If unsure, say N.
+
+config PATA_AT91
+	tristate "PATA support for AT91SAM9260"
+	depends on ARM && ARCH_AT91
+	help
+	  This option enables support for IDE devices on the Atmel AT91SAM9260 SoC.
+
+	  If unsure, say N.
+
+config PATA_CMD640_PCI
+	tristate "CMD640 PCI PATA support (Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This option enables support for the CMD640 PCI IDE
+	  interface chip. Only the primary channel is currently
+	  supported.
+
+	  If unsure, say N.
+
+config PATA_ISAPNP
+	tristate "ISA Plug and Play PATA support"
+	depends on ISAPNP
+	help
+	  This option enables support for ISA plug & play ATA
+	  controllers such as those found on old soundcards.
+
+	  If unsure, say N.
+
+config PATA_IXP4XX_CF
+	tristate "IXP4XX Compact Flash support"
+	depends on ARCH_IXP4XX
+	help
+	  This option enables support for a Compact Flash connected on
+	  the ixp4xx expansion bus. This driver had been written for
+	  Loft/Avila boards in mind but can work with others.
+
+	  If unsure, say N.
+
+config PATA_MPIIX
+	tristate "Intel PATA MPIIX support"
+	depends on PCI
+	help
+	  This option enables support for MPIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_NS87410
+	tristate "Nat Semi NS87410 PATA support"
+	depends on PCI
+	help
+	  This option enables support for the National Semiconductor
+	  NS87410 PCI-IDE controller.
+
+	  If unsure, say N.
+
+config PATA_OPTI
+	tristate "OPTI621/6215 PATA support (Very Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This option enables full PIO support for the early Opti ATA
+	  controllers found on some old motherboards.
+
+	  If unsure, say N.
+
+config PATA_PALMLD
+	tristate "Palm LifeDrive PATA support"
+	depends on MACH_PALMLD
+	help
+	  This option enables support for Palm LifeDrive's internal ATA
+	  port via the new ATA layer.
+
+	  If unsure, say N.
+
+config PATA_PCMCIA
+	tristate "PCMCIA PATA support"
+	depends on PCMCIA
+	help
+	  This option enables support for PCMCIA ATA interfaces, including
+	  compact flash card adapters via the new ATA layer.
+
+	  If unsure, say N.
 
 config HAVE_PATA_PLATFORM
 	bool
@@ -725,14 +762,6 @@ config PATA_PLATFORM
 
 	  If unsure, say N.
 
-config PATA_AT91
-	tristate "PATA support for AT91SAM9260"
-	depends on ARM && ARCH_AT91
-	help
-	  This option enables support for IDE devices on the Atmel AT91SAM9260 SoC.
-
-	  If unsure, say N.
-
 config PATA_OF_PLATFORM
 	tristate "OpenFirmware platform device PATA support"
 	depends on PATA_PLATFORM && PPC_OF
@@ -743,69 +772,65 @@ config PATA_OF_PLATFORM
 
 	  If unsure, say N.
 
-config PATA_ICSIDE
-	tristate "Acorn ICS PATA support"
-	depends on ARM && ARCH_ACORN
+config PATA_QDI
+	tristate "QDI VLB PATA support"
+	depends on ISA
 	help
-	  On Acorn systems, say Y here if you wish to use the ICS PATA
-	  interface card.  This is not required for ICS partition support.
-	  If you are unsure, say N to this.
+	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
 
-config PATA_IXP4XX_CF
-	tristate "IXP4XX Compact Flash support"
-	depends on ARCH_IXP4XX
+config PATA_RB532
+	tristate "RouterBoard 532 PATA CompactFlash support"
+	depends on MIKROTIK_RB532
 	help
-	  This option enables support for a Compact Flash connected on
-	  the ixp4xx expansion bus. This driver had been written for
-	  Loft/Avila boards in mind but can work with others.
+	  This option enables support for the RouterBoard 532
+	  PATA CompactFlash controller.
 
 	  If unsure, say N.
 
-config PATA_OCTEON_CF
-	tristate "OCTEON Boot Bus Compact Flash support"
-	depends on CPU_CAVIUM_OCTEON
+config PATA_RZ1000
+	tristate "PC Tech RZ1000 PATA support"
+	depends on PCI
 	help
-	  This option enables a polled compact flash driver for use with
-	  compact flash cards attached to the OCTEON boot bus.
+	  This option enables basic support for the PC Tech RZ1000/1
+	  PATA controllers via the new ATA layer
 
 	  If unsure, say N.
 
-config PATA_SCC
-	tristate "Toshiba's Cell Reference Set IDE support"
-	depends on PCI && PPC_CELLEB
+config PATA_WINBOND_VLB
+	tristate "Winbond W83759A VLB PATA support (Experimental)"
+	depends on ISA && EXPERIMENTAL
 	help
-	  This option enables support for the built-in IDE controller on
-	  Toshiba Cell Reference Board.
+	  Support for the Winbond W83759A controller on Vesa Local Bus
+	  systems.
 
-	  If unsure, say N.
+comment "Generic fallback / legacy drivers"
 
-config PATA_SCH
-	tristate "Intel SCH PATA support"
-	depends on PCI
+config PATA_ACPI
+	tristate "ACPI firmware driver for PATA"
+	depends on ATA_ACPI && ATA_BMDMA
 	help
-	  This option enables support for Intel SCH PATA on the Intel
-	  SCH (US15W, US15L, UL11L) series host controllers.
-
-	  If unsure, say N.
+	  This option enables an ACPI method driver which drives
+	  motherboard PATA controller interfaces through the ACPI
+	  firmware in the BIOS. This driver can sometimes handle
+	  otherwise unsupported hardware.
 
-config PATA_BF54X
-	tristate "Blackfin 54x ATAPI support"
-	depends on BF542 || BF548 || BF549
+config ATA_GENERIC
+	tristate "Generic ATA support"
+	depends on PCI && ATA_BMDMA
 	help
-	  This option enables support for the built-in ATAPI controller on
-	  Blackfin 54x family chips.
+	  This option enables support for generic BIOS configured
+	  ATA controllers via the new ATA layer
 
 	  If unsure, say N.
 
-config PATA_MACIO
-	tristate "Apple PowerMac/PowerBook internal 'MacIO' IDE"
-	depends on PPC_PMAC
+config PATA_LEGACY
+	tristate "Legacy ISA PATA support (Experimental)"
+	depends on (ISA || PCI) && EXPERIMENTAL
 	help
-	  Most IDE capable PowerMacs have IDE busses driven by a variant
-          of this controller which is part of the Apple chipset used on
-          most PowerMac models. Some models have multiple busses using
-          different chipsets, though generally, MacIO is one of them.
+	  This option enables support for ISA/VLB/PCI bus legacy PATA
+	  ports and allows them to be accessed via the new ATA layer.
 
+	  If unsure, say N.
 
 endif # ATA_SFF
 endif # ATA
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index d0a93c4..7ef89d7 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,33 +1,39 @@
 
 obj-$(CONFIG_ATA)		+= libata.o
 
+# non-SFF interface
 obj-$(CONFIG_SATA_AHCI)		+= ahci.o libahci.o
 obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
-obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
+obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
+obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
+obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
+
+# SFF w/ custom DMA
+obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
+obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52xx.o
+obj-$(CONFIG_PATA_OCTEON_CF)	+= pata_octeon_cf.o
+obj-$(CONFIG_SATA_QSTOR)	+= sata_qstor.o
+obj-$(CONFIG_SATA_SX4)		+= sata_sx4.o
+
+# SFF SATA w/ BMDMA
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
+obj-$(CONFIG_SATA_MV)		+= sata_mv.o
+obj-$(CONFIG_SATA_NV)		+= sata_nv.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
-obj-$(CONFIG_SATA_QSTOR)	+= sata_qstor.o
 obj-$(CONFIG_SATA_SIL)		+= sata_sil.o
-obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
-obj-$(CONFIG_SATA_VIA)		+= sata_via.o
-obj-$(CONFIG_SATA_VITESSE)	+= sata_vsc.o
 obj-$(CONFIG_SATA_SIS)		+= sata_sis.o
-obj-$(CONFIG_SATA_SX4)		+= sata_sx4.o
-obj-$(CONFIG_SATA_NV)		+= sata_nv.o
+obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_SATA_ULI)		+= sata_uli.o
-obj-$(CONFIG_SATA_MV)		+= sata_mv.o
-obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
-obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
-obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
-obj-$(CONFIG_PATA_MACIO)	+= pata_macio.o
+obj-$(CONFIG_SATA_VIA)		+= sata_via.o
+obj-$(CONFIG_SATA_VITESSE)	+= sata_vsc.o
 
+# SFF PATA w/ BMDMA
 obj-$(CONFIG_PATA_ALI)		+= pata_ali.o
 obj-$(CONFIG_PATA_AMD)		+= pata_amd.o
 obj-$(CONFIG_PATA_ARTOP)	+= pata_artop.o
-obj-$(CONFIG_PATA_ATP867X)	+= pata_atp867x.o
-obj-$(CONFIG_PATA_AT32)		+= pata_at32.o
 obj-$(CONFIG_PATA_ATIIXP)	+= pata_atiixp.o
-obj-$(CONFIG_PATA_CMD640_PCI)	+= pata_cmd640.o
+obj-$(CONFIG_PATA_ATP867X)	+= pata_atp867x.o
+obj-$(CONFIG_PATA_BF54X)	+= pata_bf54x.o
 obj-$(CONFIG_PATA_CMD64X)	+= pata_cmd64x.o
 obj-$(CONFIG_PATA_CS5520)	+= pata_cs5520.o
 obj-$(CONFIG_PATA_CS5530)	+= pata_cs5530.o
@@ -39,47 +45,50 @@ obj-$(CONFIG_PATA_HPT366)	+= pata_hpt366.o
 obj-$(CONFIG_PATA_HPT37X)	+= pata_hpt37x.o
 obj-$(CONFIG_PATA_HPT3X2N)	+= pata_hpt3x2n.o
 obj-$(CONFIG_PATA_HPT3X3)	+= pata_hpt3x3.o
-obj-$(CONFIG_PATA_ISAPNP)	+= pata_isapnp.o
-obj-$(CONFIG_PATA_IT821X)	+= pata_it821x.o
+obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
 obj-$(CONFIG_PATA_IT8213)	+= pata_it8213.o
+obj-$(CONFIG_PATA_IT821X)	+= pata_it821x.o
 obj-$(CONFIG_PATA_JMICRON)	+= pata_jmicron.o
+obj-$(CONFIG_PATA_MACIO)	+= pata_macio.o
+obj-$(CONFIG_PATA_MARVELL)	+= pata_marvell.o
 obj-$(CONFIG_PATA_NETCELL)	+= pata_netcell.o
 obj-$(CONFIG_PATA_NINJA32)	+= pata_ninja32.o
-obj-$(CONFIG_PATA_NS87410)	+= pata_ns87410.o
 obj-$(CONFIG_PATA_NS87415)	+= pata_ns87415.o
-obj-$(CONFIG_PATA_OPTI)		+= pata_opti.o
-obj-$(CONFIG_PATA_OPTIDMA)	+= pata_optidma.o
-obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52xx.o
-obj-$(CONFIG_PATA_MARVELL)	+= pata_marvell.o
-obj-$(CONFIG_PATA_MPIIX)	+= pata_mpiix.o
 obj-$(CONFIG_PATA_OLDPIIX)	+= pata_oldpiix.o
-obj-$(CONFIG_PATA_PALMLD)	+= pata_palmld.o
-obj-$(CONFIG_PATA_PCMCIA)	+= pata_pcmcia.o
+obj-$(CONFIG_PATA_OPTIDMA)	+= pata_optidma.o
 obj-$(CONFIG_PATA_PDC2027X)	+= pata_pdc2027x.o
 obj-$(CONFIG_PATA_PDC_OLD)	+= pata_pdc202xx_old.o
-obj-$(CONFIG_PATA_QDI)		+= pata_qdi.o
 obj-$(CONFIG_PATA_RADISYS)	+= pata_radisys.o
-obj-$(CONFIG_PATA_RB532)	+= pata_rb532_cf.o
 obj-$(CONFIG_PATA_RDC)		+= pata_rdc.o
-obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
 obj-$(CONFIG_PATA_SC1200)	+= pata_sc1200.o
+obj-$(CONFIG_PATA_SCC)		+= pata_scc.o
+obj-$(CONFIG_PATA_SCH)		+= pata_sch.o
 obj-$(CONFIG_PATA_SERVERWORKS)	+= pata_serverworks.o
 obj-$(CONFIG_PATA_SIL680)	+= pata_sil680.o
+obj-$(CONFIG_PATA_SIS)		+= pata_sis.o
 obj-$(CONFIG_PATA_TOSHIBA)	+= pata_piccolo.o
+obj-$(CONFIG_PATA_TRIFLEX)	+= pata_triflex.o
 obj-$(CONFIG_PATA_VIA)		+= pata_via.o
 obj-$(CONFIG_PATA_WINBOND)	+= pata_sl82c105.o
-obj-$(CONFIG_PATA_WINBOND_VLB)	+= pata_winbond.o
-obj-$(CONFIG_PATA_SIS)		+= pata_sis.o
-obj-$(CONFIG_PATA_TRIFLEX)	+= pata_triflex.o
+
+# SFF PIO only
+obj-$(CONFIG_PATA_AT32)		+= pata_at32.o
+obj-$(CONFIG_PATA_AT91)		+= pata_at91.o
+obj-$(CONFIG_PATA_CMD640_PCI)	+= pata_cmd640.o
+obj-$(CONFIG_PATA_ISAPNP)	+= pata_isapnp.o
 obj-$(CONFIG_PATA_IXP4XX_CF)	+= pata_ixp4xx_cf.o
-obj-$(CONFIG_PATA_SCC)		+= pata_scc.o
-obj-$(CONFIG_PATA_SCH)		+= pata_sch.o
-obj-$(CONFIG_PATA_BF54X)	+= pata_bf54x.o
-obj-$(CONFIG_PATA_OCTEON_CF)	+= pata_octeon_cf.o
+obj-$(CONFIG_PATA_MPIIX)	+= pata_mpiix.o
+obj-$(CONFIG_PATA_NS87410)	+= pata_ns87410.o
+obj-$(CONFIG_PATA_OPTI)		+= pata_opti.o
+obj-$(CONFIG_PATA_PCMCIA)	+= pata_pcmcia.o
+obj-$(CONFIG_PATA_PALMLD)	+= pata_palmld.o
 obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
-obj-$(CONFIG_PATA_AT91)	+= pata_at91.o
 obj-$(CONFIG_PATA_OF_PLATFORM)	+= pata_of_platform.o
-obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
+obj-$(CONFIG_PATA_QDI)		+= pata_qdi.o
+obj-$(CONFIG_PATA_RB532)	+= pata_rb532_cf.o
+obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
+obj-$(CONFIG_PATA_WINBOND_VLB)	+= pata_winbond.o
+
 # Should be last but two libata driver
 obj-$(CONFIG_PATA_ACPI)		+= pata_acpi.o
 # Should be last but one libata driver
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 33fb614..573158a 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -155,7 +155,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 			return rc;
 		pcim_pin_device(dev);
 	}
-	return ata_pci_sff_init_one(dev, ppi, &generic_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, NULL, 0);
 }
 
 static struct pci_device_id ata_generic[] = {
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ec52fc6..7409f98 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1589,7 +1589,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 		hpriv->map = piix_init_sata_map(pdev, port_info,
 					piix_map_db_table[ent->driver_data]);
 
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 	host->private_data = hpriv;
@@ -1626,7 +1626,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	host->flags |= ATA_HOST_PARALLEL_SCAN;
 
 	pci_set_master(pdev);
-	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &piix_sht);
+	return ata_pci_sff_activate_host(host, ata_bmdma_interrupt, &piix_sht);
 }
 
 static void piix_remove_one(struct pci_dev *pdev)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c47373f..06b7e49 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -160,6 +160,10 @@ int libata_allow_tpm = 0;
 module_param_named(allow_tpm, libata_allow_tpm, int, 0444);
 MODULE_PARM_DESC(allow_tpm, "Permit the use of TPM commands (0=off [default], 1=on)");
 
+static int atapi_an;
+module_param(atapi_an, int, 0444);
+MODULE_PARM_DESC(atapi_an, "Enable ATAPI AN media presence notification (0=0ff [default], 1=on)");
+
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Library module for ATA devices");
 MODULE_LICENSE("GPL");
@@ -2122,6 +2126,14 @@ retry:
 		goto err_out;
 	}
 
+	if (dev->horkage & ATA_HORKAGE_DUMP_ID) {
+		ata_dev_printk(dev, KERN_DEBUG, "dumping IDENTIFY data, "
+			       "class=%d may_fallback=%d tried_spinup=%d\n",
+			       class, may_fallback, tried_spinup);
+		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET,
+			       16, 2, id, ATA_ID_WORDS * sizeof(*id), true);
+	}
+
 	/* Falling back doesn't make sense if ID data was read
 	 * successfully at least once.
 	 */
@@ -2510,7 +2522,8 @@ int ata_dev_configure(struct ata_device *dev)
 		 * to enable ATAPI AN to discern between PHY status
 		 * changed notifications and ATAPI ANs.
 		 */
-		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_atapi_AN(id) &&
+		if (atapi_an &&
+		    (ap->flags & ATA_FLAG_AN) && ata_id_has_atapi_AN(id) &&
 		    (!sata_pmp_attached(ap) ||
 		     sata_scr_read(&ap->link, SCR_NOTIFICATION, &sntf) == 0)) {
 			unsigned int err_mask;
@@ -6372,6 +6385,7 @@ static int __init ata_parse_force_one(char **cur,
 		{ "3.0Gbps",	.spd_limit	= 2 },
 		{ "noncq",	.horkage_on	= ATA_HORKAGE_NONCQ },
 		{ "ncq",	.horkage_off	= ATA_HORKAGE_NONCQ },
+		{ "dump_id",	.horkage_on	= ATA_HORKAGE_DUMP_ID },
 		{ "pio0",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 0) },
 		{ "pio1",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 1) },
 		{ "pio2",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 2) },
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 19ddf92..efa4a18 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -63,7 +63,6 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.sff_tf_read		= ata_sff_tf_read,
 	.sff_exec_command	= ata_sff_exec_command,
 	.sff_data_xfer		= ata_sff_data_xfer,
-	.sff_irq_clear		= ata_sff_irq_clear,
 	.sff_drain_fifo		= ata_sff_drain_fifo,
 
 	.lost_interrupt		= ata_sff_lost_interrupt,
@@ -395,33 +394,12 @@ void ata_sff_irq_on(struct ata_port *ap)
 		ata_sff_set_devctl(ap, ap->ctl);
 	ata_wait_idle(ap);
 
-	ap->ops->sff_irq_clear(ap);
+	if (ap->ops->sff_irq_clear)
+		ap->ops->sff_irq_clear(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sff_irq_on);
 
 /**
- *	ata_sff_irq_clear - Clear PCI IDE BMDMA interrupt.
- *	@ap: Port associated with this ATA transaction.
- *
- *	Clear interrupt and error flags in DMA status register.
- *
- *	May be used as the irq_clear() entry in ata_port_operations.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_sff_irq_clear(struct ata_port *ap)
-{
-	void __iomem *mmio = ap->ioaddr.bmdma_addr;
-
-	if (!mmio)
-		return;
-
-	iowrite8(ioread8(mmio + ATA_DMA_STATUS), mmio + ATA_DMA_STATUS);
-}
-EXPORT_SYMBOL_GPL(ata_sff_irq_clear);
-
-/**
  *	ata_sff_tf_load - send taskfile registers to host controller
  *	@ap: Port to which output is sent
  *	@tf: ATA taskfile register set
@@ -820,11 +798,15 @@ static void atapi_send_cdb(struct ata_port *ap, struct ata_queued_cmd *qc)
 	case ATAPI_PROT_NODATA:
 		ap->hsm_task_state = HSM_ST_LAST;
 		break;
+#ifdef CONFIG_ATA_BMDMA
 	case ATAPI_PROT_DMA:
 		ap->hsm_task_state = HSM_ST_LAST;
 		/* initiate bmdma */
 		ap->ops->bmdma_start(qc);
 		break;
+#endif /* CONFIG_ATA_BMDMA */
+	default:
+		BUG();
 	}
 }
 
@@ -1491,27 +1473,27 @@ bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc)
 }
 EXPORT_SYMBOL_GPL(ata_sff_qc_fill_rtf);
 
-/**
- *	ata_sff_host_intr - Handle host interrupt for given (port, task)
- *	@ap: Port on which interrupt arrived (possibly...)
- *	@qc: Taskfile currently active in engine
- *
- *	Handle host interrupt for given queued command.  Currently,
- *	only DMA interrupts are handled.  All other commands are
- *	handled via polling with interrupts disabled (nIEN bit).
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- *
- *	RETURNS:
- *	One if interrupt was handled, zero if not (shared irq).
- */
-unsigned int ata_sff_host_intr(struct ata_port *ap,
-				      struct ata_queued_cmd *qc)
+static unsigned int ata_sff_idle_irq(struct ata_port *ap)
 {
-	struct ata_eh_info *ehi = &ap->link.eh_info;
-	u8 status, host_stat = 0;
-	bool bmdma_stopped = false;
+	ap->stats.idle_irq++;
+
+#ifdef ATA_IRQ_TRAP
+	if ((ap->stats.idle_irq % 1000) == 0) {
+		ap->ops->sff_check_status(ap);
+		if (ap->ops->sff_irq_clear)
+			ap->ops->sff_irq_clear(ap);
+		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
+		return 1;
+	}
+#endif
+	return 0;	/* irq not handled */
+}
+
+static unsigned int __ata_sff_port_intr(struct ata_port *ap,
+					struct ata_queued_cmd *qc,
+					bool hsmv_on_idle)
+{
+	u8 status;
 
 	VPRINTK("ata%u: protocol %d task_state %d\n",
 		ap->print_id, qc->tf.protocol, ap->hsm_task_state);
@@ -1528,90 +1510,56 @@ unsigned int ata_sff_host_intr(struct ata_port *ap,
 		 * need to check ata_is_atapi(qc->tf.protocol) again.
 		 */
 		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
-			goto idle_irq;
-		break;
-	case HSM_ST_LAST:
-		if (qc->tf.protocol == ATA_PROT_DMA ||
-		    qc->tf.protocol == ATAPI_PROT_DMA) {
-			/* check status of DMA engine */
-			host_stat = ap->ops->bmdma_status(ap);
-			VPRINTK("ata%u: host_stat 0x%X\n",
-				ap->print_id, host_stat);
-
-			/* if it's not our irq... */
-			if (!(host_stat & ATA_DMA_INTR))
-				goto idle_irq;
-
-			/* before we do anything else, clear DMA-Start bit */
-			ap->ops->bmdma_stop(qc);
-			bmdma_stopped = true;
-
-			if (unlikely(host_stat & ATA_DMA_ERR)) {
-				/* error when transfering data to/from memory */
-				qc->err_mask |= AC_ERR_HOST_BUS;
-				ap->hsm_task_state = HSM_ST_ERR;
-			}
-		}
+			return ata_sff_idle_irq(ap);
 		break;
 	case HSM_ST:
+	case HSM_ST_LAST:
 		break;
 	default:
-		goto idle_irq;
+		return ata_sff_idle_irq(ap);
 	}
 
-
 	/* check main status, clearing INTRQ if needed */
 	status = ata_sff_irq_status(ap);
 	if (status & ATA_BUSY) {
-		if (bmdma_stopped) {
+		if (hsmv_on_idle) {
 			/* BMDMA engine is already stopped, we're screwed */
 			qc->err_mask |= AC_ERR_HSM;
 			ap->hsm_task_state = HSM_ST_ERR;
 		} else
-			goto idle_irq;
+			return ata_sff_idle_irq(ap);
 	}
 
 	/* clear irq events */
-	ap->ops->sff_irq_clear(ap);
+	if (ap->ops->sff_irq_clear)
+		ap->ops->sff_irq_clear(ap);
 
 	ata_sff_hsm_move(ap, qc, status, 0);
 
-	if (unlikely(qc->err_mask) && (qc->tf.protocol == ATA_PROT_DMA ||
-				       qc->tf.protocol == ATAPI_PROT_DMA))
-		ata_ehi_push_desc(ehi, "BMDMA stat 0x%x", host_stat);
-
 	return 1;	/* irq handled */
-
-idle_irq:
-	ap->stats.idle_irq++;
-
-#ifdef ATA_IRQ_TRAP
-	if ((ap->stats.idle_irq % 1000) == 0) {
-		ap->ops->sff_check_status(ap);
-		ap->ops->sff_irq_clear(ap);
-		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
-		return 1;
-	}
-#endif
-	return 0;	/* irq not handled */
 }
-EXPORT_SYMBOL_GPL(ata_sff_host_intr);
 
 /**
- *	ata_sff_interrupt - Default ATA host interrupt handler
- *	@irq: irq line (unused)
- *	@dev_instance: pointer to our ata_host information structure
+ *	ata_sff_port_intr - Handle SFF port interrupt
+ *	@ap: Port on which interrupt arrived (possibly...)
+ *	@qc: Taskfile currently active in engine
  *
- *	Default interrupt handler for PCI IDE devices.  Calls
- *	ata_sff_host_intr() for each port that is not disabled.
+ *	Handle port interrupt for given queued command.
  *
  *	LOCKING:
- *	Obtains host lock during operation.
+ *	spin_lock_irqsave(host lock)
  *
  *	RETURNS:
- *	IRQ_NONE or IRQ_HANDLED.
+ *	One if interrupt was handled, zero if not (shared irq).
  */
-irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
+unsigned int ata_sff_port_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
+{
+	return __ata_sff_port_intr(ap, qc, false);
+}
+EXPORT_SYMBOL_GPL(ata_sff_port_intr);
+
+static inline irqreturn_t __ata_sff_interrupt(int irq, void *dev_instance,
+	unsigned int (*port_intr)(struct ata_port *, struct ata_queued_cmd *))
 {
 	struct ata_host *host = dev_instance;
 	bool retried = false;
@@ -1631,7 +1579,7 @@ retry:
 		qc = ata_qc_from_tag(ap, ap->link.active_tag);
 		if (qc) {
 			if (!(qc->tf.flags & ATA_TFLAG_POLLING))
-				handled |= ata_sff_host_intr(ap, qc);
+				handled |= port_intr(ap, qc);
 			else
 				polling |= 1 << i;
 		} else
@@ -1658,7 +1606,8 @@ retry:
 
 			if (idle & (1 << i)) {
 				ap->ops->sff_check_status(ap);
-				ap->ops->sff_irq_clear(ap);
+				if (ap->ops->sff_irq_clear)
+					ap->ops->sff_irq_clear(ap);
 			} else {
 				/* clear INTRQ and check if BUSY cleared */
 				if (!(ap->ops->sff_check_status(ap) & ATA_BUSY))
@@ -1680,6 +1629,25 @@ retry:
 
 	return IRQ_RETVAL(handled);
 }
+
+/**
+ *	ata_sff_interrupt - Default SFF ATA host interrupt handler
+ *	@irq: irq line (unused)
+ *	@dev_instance: pointer to our ata_host information structure
+ *
+ *	Default interrupt handler for PCI IDE devices.  Calls
+ *	ata_sff_port_intr() for each port that is not disabled.
+ *
+ *	LOCKING:
+ *	Obtains host lock during operation.
+ *
+ *	RETURNS:
+ *	IRQ_NONE or IRQ_HANDLED.
+ */
+irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
+{
+	return __ata_sff_interrupt(irq, dev_instance, ata_sff_port_intr);
+}
 EXPORT_SYMBOL_GPL(ata_sff_interrupt);
 
 /**
@@ -1717,7 +1685,7 @@ void ata_sff_lost_interrupt(struct ata_port *ap)
 								status);
 	/* Run the host interrupt logic as if the interrupt had not been
 	   lost */
-	ata_sff_host_intr(ap, qc);
+	ata_sff_port_intr(ap, qc);
 }
 EXPORT_SYMBOL_GPL(ata_sff_lost_interrupt);
 
@@ -1744,7 +1712,8 @@ void ata_sff_freeze(struct ata_port *ap)
 	 */
 	ap->ops->sff_check_status(ap);
 
-	ap->ops->sff_irq_clear(ap);
+	if (ap->ops->sff_irq_clear)
+		ap->ops->sff_irq_clear(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sff_freeze);
 
@@ -1761,7 +1730,8 @@ void ata_sff_thaw(struct ata_port *ap)
 {
 	/* clear & re-enable interrupts */
 	ap->ops->sff_check_status(ap);
-	ap->ops->sff_irq_clear(ap);
+	if (ap->ops->sff_irq_clear)
+		ap->ops->sff_irq_clear(ap);
 	ata_sff_irq_on(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sff_thaw);
@@ -2349,13 +2319,13 @@ int ata_pci_sff_init_host(struct ata_host *host)
 EXPORT_SYMBOL_GPL(ata_pci_sff_init_host);
 
 /**
- *	ata_pci_sff_prepare_host - helper to prepare native PCI ATA host
+ *	ata_pci_sff_prepare_host - helper to prepare PCI PIO-only SFF ATA host
  *	@pdev: target PCI device
  *	@ppi: array of port_info, must be enough for two ports
  *	@r_host: out argument for the initialized ATA host
  *
- *	Helper to allocate ATA host for @pdev, acquire all native PCI
- *	resources and initialize it accordingly in one go.
+ *	Helper to allocate PIO-only SFF ATA host for @pdev, acquire
+ *	all PCI resources and initialize it accordingly in one go.
  *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
@@ -2385,9 +2355,6 @@ int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 	if (rc)
 		goto err_out;
 
-	/* init DMA related stuff */
-	ata_pci_bmdma_init(host);
-
 	devres_remove_group(&pdev->dev, NULL);
 	*r_host = host;
 	return 0;
@@ -2492,8 +2459,21 @@ out:
 }
 EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
 
+static const struct ata_port_info *ata_sff_find_valid_pi(
+					const struct ata_port_info * const *ppi)
+{
+	int i;
+
+	/* look up the first valid port_info */
+	for (i = 0; i < 2 && ppi[i]; i++)
+		if (ppi[i]->port_ops != &ata_dummy_port_ops)
+			return ppi[i];
+
+	return NULL;
+}
+
 /**
- *	ata_pci_sff_init_one - Initialize/register PCI IDE host controller
+ *	ata_pci_sff_init_one - Initialize/register PIO-only PCI IDE controller
  *	@pdev: Controller to be initialized
  *	@ppi: array of port_info, must be enough for two ports
  *	@sht: scsi_host_template to use when registering the host
@@ -2502,11 +2482,7 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
  *
  *	This is a helper function which can be called from a driver's
  *	xxx_init_one() probe function if the hardware uses traditional
- *	IDE taskfile registers.
- *
- *	This function calls pci_enable_device(), reserves its register
- *	regions, sets the dma mask, enables bus master mode, and calls
- *	ata_device_add()
+ *	IDE taskfile registers and is PIO only.
  *
  *	ASSUMPTION:
  *	Nobody makes a single channel controller that appears solely as
@@ -2523,20 +2499,13 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 		 struct scsi_host_template *sht, void *host_priv, int hflag)
 {
 	struct device *dev = &pdev->dev;
-	const struct ata_port_info *pi = NULL;
+	const struct ata_port_info *pi;
 	struct ata_host *host = NULL;
-	int i, rc;
+	int rc;
 
 	DPRINTK("ENTER\n");
 
-	/* look up the first valid port_info */
-	for (i = 0; i < 2 && ppi[i]; i++) {
-		if (ppi[i]->port_ops != &ata_dummy_port_ops) {
-			pi = ppi[i];
-			break;
-		}
-	}
-
+	pi = ata_sff_find_valid_pi(ppi);
 	if (!pi) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "no valid port_info specified\n");
@@ -2557,7 +2526,6 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 	host->private_data = host_priv;
 	host->flags |= hflag;
 
-	pci_set_master(pdev);
 	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
 out:
 	if (rc == 0)
@@ -2571,6 +2539,12 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 
 #endif /* CONFIG_PCI */
 
+/*
+ *	BMDMA support
+ */
+
+#ifdef CONFIG_ATA_BMDMA
+
 const struct ata_port_operations ata_bmdma_port_ops = {
 	.inherits		= &ata_sff_port_ops,
 
@@ -2580,6 +2554,7 @@ const struct ata_port_operations ata_bmdma_port_ops = {
 	.qc_prep		= ata_bmdma_qc_prep,
 	.qc_issue		= ata_bmdma_qc_issue,
 
+	.sff_irq_clear		= ata_bmdma_irq_clear,
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
@@ -2804,6 +2779,75 @@ unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc)
 EXPORT_SYMBOL_GPL(ata_bmdma_qc_issue);
 
 /**
+ *	ata_bmdma_port_intr - Handle BMDMA port interrupt
+ *	@ap: Port on which interrupt arrived (possibly...)
+ *	@qc: Taskfile currently active in engine
+ *
+ *	Handle port interrupt for given queued command.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	One if interrupt was handled, zero if not (shared irq).
+ */
+unsigned int ata_bmdma_port_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
+{
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	u8 host_stat = 0;
+	bool bmdma_stopped = false;
+	unsigned int handled;
+
+	if (ap->hsm_task_state == HSM_ST_LAST && ata_is_dma(qc->tf.protocol)) {
+		/* check status of DMA engine */
+		host_stat = ap->ops->bmdma_status(ap);
+		VPRINTK("ata%u: host_stat 0x%X\n", ap->print_id, host_stat);
+
+		/* if it's not our irq... */
+		if (!(host_stat & ATA_DMA_INTR))
+			return ata_sff_idle_irq(ap);
+
+		/* before we do anything else, clear DMA-Start bit */
+		ap->ops->bmdma_stop(qc);
+		bmdma_stopped = true;
+
+		if (unlikely(host_stat & ATA_DMA_ERR)) {
+			/* error when transfering data to/from memory */
+			qc->err_mask |= AC_ERR_HOST_BUS;
+			ap->hsm_task_state = HSM_ST_ERR;
+		}
+	}
+
+	handled = __ata_sff_port_intr(ap, qc, bmdma_stopped);
+
+	if (unlikely(qc->err_mask) && ata_is_dma(qc->tf.protocol))
+		ata_ehi_push_desc(ehi, "BMDMA stat 0x%x", host_stat);
+
+	return handled;
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_port_intr);
+
+/**
+ *	ata_bmdma_interrupt - Default BMDMA ATA host interrupt handler
+ *	@irq: irq line (unused)
+ *	@dev_instance: pointer to our ata_host information structure
+ *
+ *	Default interrupt handler for PCI IDE devices.  Calls
+ *	ata_bmdma_port_intr() for each port that is not disabled.
+ *
+ *	LOCKING:
+ *	Obtains host lock during operation.
+ *
+ *	RETURNS:
+ *	IRQ_NONE or IRQ_HANDLED.
+ */
+irqreturn_t ata_bmdma_interrupt(int irq, void *dev_instance)
+{
+	return __ata_sff_interrupt(irq, dev_instance, ata_bmdma_port_intr);
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_interrupt);
+
+/**
  *	ata_bmdma_error_handler - Stock error handler for BMDMA controller
  *	@ap: port to handle error for
  *
@@ -2848,7 +2892,8 @@ void ata_bmdma_error_handler(struct ata_port *ap)
 		/* if we're gonna thaw, make sure IRQ is clear */
 		if (thaw) {
 			ap->ops->sff_check_status(ap);
-			ap->ops->sff_irq_clear(ap);
+			if (ap->ops->sff_irq_clear)
+				ap->ops->sff_irq_clear(ap);
 		}
 	}
 
@@ -2882,6 +2927,28 @@ void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
 EXPORT_SYMBOL_GPL(ata_bmdma_post_internal_cmd);
 
 /**
+ *	ata_bmdma_irq_clear - Clear PCI IDE BMDMA interrupt.
+ *	@ap: Port associated with this ATA transaction.
+ *
+ *	Clear interrupt and error flags in DMA status register.
+ *
+ *	May be used as the irq_clear() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_irq_clear(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->ioaddr.bmdma_addr;
+
+	if (!mmio)
+		return;
+
+	iowrite8(ioread8(mmio + ATA_DMA_STATUS), mmio + ATA_DMA_STATUS);
+}
+EXPORT_SYMBOL_GPL(ata_bmdma_irq_clear);
+
+/**
  *	ata_bmdma_setup - Set up PCI IDE BMDMA transaction
  *	@qc: Info associated with this ATA transaction.
  *
@@ -3137,7 +3204,100 @@ void ata_pci_bmdma_init(struct ata_host *host)
 }
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
 
+/**
+ *	ata_pci_bmdma_prepare_host - helper to prepare PCI BMDMA ATA host
+ *	@pdev: target PCI device
+ *	@ppi: array of port_info, must be enough for two ports
+ *	@r_host: out argument for the initialized ATA host
+ *
+ *	Helper to allocate BMDMA ATA host for @pdev, acquire all PCI
+ *	resources and initialize it accordingly in one go.
+ *
+ *	LOCKING:
+ *	Inherited from calling layer (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int ata_pci_bmdma_prepare_host(struct pci_dev *pdev,
+			       const struct ata_port_info * const * ppi,
+			       struct ata_host **r_host)
+{
+	int rc;
+
+	rc = ata_pci_sff_prepare_host(pdev, ppi, r_host);
+	if (rc)
+		return rc;
+
+	ata_pci_bmdma_init(*r_host);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_pci_bmdma_prepare_host);
+
+/**
+ *	ata_pci_bmdma_init_one - Initialize/register BMDMA PCI IDE controller
+ *	@pdev: Controller to be initialized
+ *	@ppi: array of port_info, must be enough for two ports
+ *	@sht: scsi_host_template to use when registering the host
+ *	@host_priv: host private_data
+ *	@hflags: host flags
+ *
+ *	This function is similar to ata_pci_sff_init_one() but also
+ *	takes care of BMDMA initialization.
+ *
+ *	LOCKING:
+ *	Inherited from PCI layer (may sleep).
+ *
+ *	RETURNS:
+ *	Zero on success, negative on errno-based value on error.
+ */
+int ata_pci_bmdma_init_one(struct pci_dev *pdev,
+			   const struct ata_port_info * const * ppi,
+			   struct scsi_host_template *sht, void *host_priv,
+			   int hflags)
+{
+	struct device *dev = &pdev->dev;
+	const struct ata_port_info *pi;
+	struct ata_host *host = NULL;
+	int rc;
+
+	DPRINTK("ENTER\n");
+
+	pi = ata_sff_find_valid_pi(ppi);
+	if (!pi) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "no valid port_info specified\n");
+		return -EINVAL;
+	}
+
+	if (!devres_open_group(dev, NULL, GFP_KERNEL))
+		return -ENOMEM;
+
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		goto out;
+
+	/* prepare and activate BMDMA host */
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
+	if (rc)
+		goto out;
+	host->private_data = host_priv;
+	host->flags |= hflags;
+
+	pci_set_master(pdev);
+	rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
+ out:
+	if (rc == 0)
+		devres_remove_group(&pdev->dev, NULL);
+	else
+		devres_release_group(&pdev->dev, NULL);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ata_pci_bmdma_init_one);
+
 #endif /* CONFIG_PCI */
+#endif /* CONFIG_ATA_BMDMA */
 
 /**
  *	ata_sff_port_init - Initialize SFF/BMDMA ATA port
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 066b9f3..c8d4703 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -260,7 +260,7 @@ static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 			return rc;
 		pcim_pin_device(pdev);
 	}
-	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &pacpi_sht, NULL, 0);
 }
 
 static const struct pci_device_id pacpi_pci_tbl[] = {
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index f306e10..794ec6e 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -583,7 +583,10 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	        	ppi[0] = &info_20_udma;
 	}
 
-	return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL, 0);
+	if (!ppi[0]->mwdma_mask && !ppi[0]->udma_mask)
+		return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL, 0);
+	else
+		return ata_pci_bmdma_init_one(pdev, ppi, &ali_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index d95eca9..620a07c 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -574,7 +574,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* And fire it up */
-	return ata_pci_sff_init_one(pdev, ppi, &amd_sht, hpriv, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &amd_sht, hpriv, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 4d066d6..ba43f0f 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -421,7 +421,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 
 	BUG_ON(ppi[0] == NULL);
 
-	return ata_pci_sff_init_one(pdev, ppi, &artop_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &artop_sht, NULL, 0);
 }
 
 static const struct pci_device_id artop_pci_tbl[] = {
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 44d88b3..4375561 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -246,8 +246,8 @@ static int atiixp_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (!pci_test_config_bits(pdev, &atiixp_enable_bits[i]))
 			ppi[i] = &ata_dummy_port_info;
 
-	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL,
-						ATA_HOST_PARALLEL_SCAN);
+	return ata_pci_bmdma_init_one(pdev, ppi, &atiixp_sht, NULL,
+				      ATA_HOST_PARALLEL_SCAN);
 }
 
 static const struct pci_device_id atiixp[] = {
diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
index bb6e074..9529593 100644
--- a/drivers/ata/pata_atp867x.c
+++ b/drivers/ata/pata_atp867x.c
@@ -525,7 +525,7 @@ static int atp867x_init_one(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	rc = ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	rc = ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				IRQF_SHARED, &atp867x_sht);
 	if (rc)
 		dev_printk(KERN_ERR, &pdev->dev, "failed to activate host\n");
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 6422cfd..9cae65d 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1214,7 +1214,7 @@ static unsigned int bfin_data_xfer(struct ata_device *dev, unsigned char *buf,
  *	bfin_irq_clear - Clear ATAPI interrupt.
  *	@ap: Port associated with this ATA transaction.
  *
- *	Note: Original code is ata_sff_irq_clear().
+ *	Note: Original code is ata_bmdma_irq_clear().
  */
 
 static void bfin_irq_clear(struct ata_port *ap)
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 4c81a71..9f5da1c 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -367,7 +367,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
 
-	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &cmd64x_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 17c5f34..030952f 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -221,7 +221,7 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
 			continue;
 
 		rc = devm_request_irq(&pdev->dev, irq[ap->port_no],
-				      ata_sff_interrupt, 0, DRV_NAME, host);
+				      ata_bmdma_interrupt, 0, DRV_NAME, host);
 		if (rc)
 			return rc;
 
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index e809a42..f792330 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -324,7 +324,7 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ppi[1] = &info_palmax_secondary;
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(pdev, ppi, &cs5530_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &cs5530_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index a02e645..03a9318 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -198,7 +198,7 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	rdmsr(ATAC_CH0D1_PIO, timings, dummy);
 	if (CS5535_BAD_PIO(timings))
 		wrmsr(ATAC_CH0D1_PIO, 0xF7F4F7F4UL, 0);
-	return ata_pci_sff_init_one(dev, ppi, &cs5535_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &cs5535_sht, NULL, 0);
 }
 
 static const struct pci_device_id cs5535[] = {
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 914ae35..21ee23f 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -260,7 +260,7 @@ static int cs5536_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
-	return ata_pci_sff_init_one(dev, ppi, &cs5536_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &cs5536_sht, NULL, 0);
 }
 
 static const struct pci_device_id cs5536[] = {
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 0fcc096..6d915b0 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -138,7 +138,7 @@ static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *i
 	if (PCI_FUNC(pdev->devfn) != 1)
 		return -ENODEV;
 
-	return ata_pci_sff_init_one(pdev, ppi, &cy82c693_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &cy82c693_sht, NULL, 0);
 }
 
 static const struct pci_device_id cy82c693[] = {
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 3bac0e0..a088347 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -277,8 +277,8 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &efar_sht, NULL,
-					ATA_HOST_PARALLEL_SCAN);
+	return ata_pci_bmdma_init_one(pdev, ppi, &efar_sht, NULL,
+				      ATA_HOST_PARALLEL_SCAN);
 }
 
 static const struct pci_device_id efar_pci_tbl[] = {
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 8580eb3..7688868 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -361,7 +361,7 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			break;
 	}
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt36x_sht, hpriv, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &hpt36x_sht, hpriv, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 98b498b..9ae4c08 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -987,7 +987,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt37x_sht, private_data, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &hpt37x_sht, private_data, 0);
 }
 
 static const struct pci_device_id hpt37x[] = {
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 8b95aeb..32f3463 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -548,7 +548,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		outb(inb(iobase + 0x9c) | 0x04, iobase + 0x9c);
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt3x2n_sht, hpriv, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &hpt3x2n_sht, hpriv, 0);
 }
 
 static const struct pci_device_id hpt3x2n[] = {
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index 727a81c..b63d5e2 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -248,7 +248,7 @@ static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ata_port_pbar_desc(ap, 4, offset_cmd[i], "cmd");
 	}
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &hpt3x3_sht);
 }
 
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index b56e8f7..9f2889f 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -470,7 +470,7 @@ static int __devinit pata_icside_add_ports(struct pata_icside_info *info)
 		pata_icside_setup_ioaddr(ap, info->base, info, info->port[i]);
 	}
 
-	return ata_host_activate(host, ec->irq, ata_sff_interrupt, 0,
+	return ata_host_activate(host, ec->irq, ata_bmdma_interrupt, 0,
 				 &pata_icside_sht);
 }
 
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index f971f0d..4d142a2 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -273,7 +273,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &it8213_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &it8213_sht, NULL, 0);
 }
 
 static const struct pci_device_id it8213_pci_tbl[] = {
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 2bd2b00..bf88f71 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -933,7 +933,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		else
 			ppi[0] = &info_smart;
 	}
-	return ata_pci_sff_init_one(pdev, ppi, &it821x_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &it821x_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 565e01e..cb3babb 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -144,7 +144,7 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	return ata_pci_sff_init_one(pdev, ppi, &jmicron_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &jmicron_sht, NULL, 0);
 }
 
 static const struct pci_device_id jmicron_pci_tbl[] = {
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index b5b48e7..76640ac 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -1110,7 +1110,7 @@ static int __devinit pata_macio_common_init(struct pata_macio_priv	*priv,
 
 	/* Start it up */
 	priv->irq = irq;
-	return ata_host_activate(priv->host, irq, ata_sff_interrupt, 0,
+	return ata_host_activate(priv->host, irq, ata_bmdma_interrupt, 0,
 				 &pata_macio_sht);
 }
 
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index e8ca02e..dd38083 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -153,7 +153,7 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 		return -ENODEV;
 	}
 #endif
-	return ata_pci_sff_init_one(pdev, ppi, &marvell_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &marvell_sht, NULL, 0);
 }
 
 static const struct pci_device_id marvell_pci_tbl[] = {
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 36afe2c..f087ab5 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -659,7 +659,7 @@ mpc52xx_ata_init_one(struct device *dev, struct mpc52xx_ata_priv *priv,
 	ata_port_desc(ap, "ata_regs 0x%lx", raw_ata_regs);
 
 	/* activate host */
-	return ata_host_activate(host, priv->ata_irq, ata_sff_interrupt, 0,
+	return ata_host_activate(host, priv->ata_irq, ata_bmdma_interrupt, 0,
 				 &mpc52xx_ata_sht);
 }
 
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index 94f979a..3eb921c 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -82,7 +82,7 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	ata_pci_bmdma_clear_simplex(pdev);
 
 	/* And let the library code do the work */
-	return ata_pci_sff_init_one(pdev, port_info, &netcell_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, port_info, &netcell_sht, NULL, 0);
 }
 
 static const struct pci_device_id netcell_pci_tbl[] = {
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index dd53a66..cc50bd0 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -149,7 +149,7 @@ static int ninja32_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 
 	ninja32_program(base);
 	/* FIXME: Should we disable them at remove ? */
-	return ata_host_activate(host, dev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, dev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &ninja32_sht);
 }
 
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index fdbba2d..605f198 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -380,7 +380,7 @@ static int ns87415_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 
 	ns87415_fixup(pdev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &ns87415_sht, NULL, 0);
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 3001109..06ddd91 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -750,20 +750,6 @@ static void octeon_cf_dev_config(struct ata_device *dev)
 }
 
 /*
- * Trap if driver tries to do standard bmdma commands.  They are not
- * supported.
- */
-static void unreachable_qc(struct ata_queued_cmd *qc)
-{
-	BUG();
-}
-
-static u8 unreachable_port(struct ata_port *ap)
-{
-	BUG();
-}
-
-/*
  * We don't do ATAPI DMA so return 0.
  */
 static int octeon_cf_check_atapi_dma(struct ata_queued_cmd *qc)
@@ -804,10 +790,6 @@ static struct ata_port_operations octeon_cf_ops = {
 	.sff_dev_select		= octeon_cf_dev_select,
 	.sff_irq_on		= octeon_cf_irq_on,
 	.sff_irq_clear		= octeon_cf_irq_clear,
-	.bmdma_setup		= unreachable_qc,
-	.bmdma_start		= unreachable_qc,
-	.bmdma_stop		= unreachable_qc,
-	.bmdma_status		= unreachable_port,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= octeon_cf_set_piomode,
 	.set_dmamode		= octeon_cf_set_dmamode,
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 988ef26..b811c16 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -248,7 +248,7 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &oldpiix_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &oldpiix_sht, NULL, 0);
 }
 
 static const struct pci_device_id oldpiix_pci_tbl[] = {
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 76b7d12..0852cd0 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -429,7 +429,7 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (optiplus_with_udma(dev))
 		ppi[0] = &info_82c700_udma;
 
-	return ata_pci_sff_init_one(dev, ppi, &optidma_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &optidma_sht, NULL, 0);
 }
 
 static const struct pci_device_id optidma[] = {
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 09f1f22..b183511 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -754,7 +754,7 @@ static int __devinit pdc2027x_init_one(struct pci_dev *pdev, const struct pci_de
 		return -EIO;
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &pdc2027x_sht);
 }
 
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index fa1e2f3..c39f213 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -337,7 +337,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 				return -ENODEV;
 		}
 	}
-	return ata_pci_sff_init_one(dev, ppi, &pdc202xx_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &pdc202xx_sht, NULL, 0);
 }
 
 static const struct pci_device_id pdc202xx[] = {
diff --git a/drivers/ata/pata_piccolo.c b/drivers/ata/pata_piccolo.c
index 9816154..cb01bf9 100644
--- a/drivers/ata/pata_piccolo.c
+++ b/drivers/ata/pata_piccolo.c
@@ -95,7 +95,7 @@ static int ata_tosh_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 	/* Just one port for the moment */
-	return ata_pci_sff_init_one(dev, ppi, &tosh_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &tosh_sht, NULL, 0);
 }
 
 static struct pci_device_id ata_tosh[] = {
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index a5fa388..8574b31 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -227,7 +227,7 @@ static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &radisys_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &radisys_sht, NULL, 0);
 }
 
 static const struct pci_device_id radisys_pci_tbl[] = {
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index 37092cf..5fbe9b1 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -344,7 +344,7 @@ static int __devinit rdc_init_one(struct pci_dev *pdev,
 	 */
 	pci_read_config_dword(pdev, 0x54, &hpriv->saved_iocfg);
 
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 	host->private_data = hpriv;
@@ -354,7 +354,7 @@ static int __devinit rdc_init_one(struct pci_dev *pdev,
 	host->flags |= ATA_HOST_PARALLEL_SCAN;
 
 	pci_set_master(pdev);
-	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &rdc_sht);
+	return ata_pci_sff_activate_host(host, ata_bmdma_interrupt, &rdc_sht);
 }
 
 static void rdc_remove_one(struct pci_dev *pdev)
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 6b5b63a..e2c1825 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -237,7 +237,7 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &sc1200_sht, NULL, 0);
 }
 
 static const struct pci_device_id sc1200[] = {
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 6f6193b..d9db3f8 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -875,7 +875,7 @@ static void scc_postreset(struct ata_link *link, unsigned int *classes)
  *	scc_irq_clear - Clear PCI IDE BMDMA interrupt.
  *	@ap: Port associated with this ATA transaction.
  *
- *	Note: Original code is ata_sff_irq_clear().
+ *	Note: Original code is ata_bmdma_irq_clear().
  */
 
 static void scc_irq_clear (struct ata_port *ap)
@@ -1105,7 +1105,7 @@ static int scc_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &scc_sht);
 }
 
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index 86b3d01..e97b32f 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -179,7 +179,7 @@ static int __devinit sch_init_one(struct pci_dev *pdev,
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &sch_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &sch_sht, NULL, 0);
 }
 
 static int __init sch_init(void)
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 43ea389..86dd714 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -460,7 +460,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
 		ata_pci_bmdma_clear_simplex(pdev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &serverworks_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &serverworks_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 43faf10..d3190d7 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -374,11 +374,11 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 	ata_sff_std_ports(&host->ports[1]->ioaddr);
 
 	/* Register & activate */
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &sil680_sht);
 
 use_ioports:
-	return ata_pci_sff_init_one(pdev, ppi, &sil680_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &sil680_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index b670803..60cea13 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -826,7 +826,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	sis_fixup(pdev, chipset);
 
-	return ata_pci_sff_init_one(pdev, ppi, &sis_sht, chipset, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &sis_sht, chipset, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 733b042..98548f6 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -316,7 +316,7 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(dev, 0x40, val);
 
-	return ata_pci_sff_init_one(dev, ppi, &sl82c105_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &sl82c105_sht, NULL, 0);
 }
 
 static const struct pci_device_id sl82c105[] = {
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index 48f5060..0d1f89e 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -201,7 +201,7 @@ static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(dev, ppi, &triflex_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &triflex_sht, NULL, 0);
 }
 
 static const struct pci_device_id triflex[] = {
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 7e3e0a5..5e65988 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -627,7 +627,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* We have established the device type, now fire it up */
-	return ata_pci_sff_init_one(pdev, ppi, &via_sht, (void *)config, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &via_sht, (void *)config, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index f3471bc..a476cd9 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -675,8 +675,6 @@ static struct ata_port_operations mv5_ops = {
 	.freeze			= mv_eh_freeze,
 	.thaw			= mv_eh_thaw,
 	.hardreset		= mv_hardreset,
-	.error_handler		= ata_std_error_handler, /* avoid SFF EH */
-	.post_internal_cmd	= ATA_OP_NULL,
 
 	.scr_read		= mv5_scr_read,
 	.scr_write		= mv5_scr_write,
@@ -2813,7 +2811,7 @@ static void mv_port_intr(struct ata_port *ap, u32 port_cause)
 	} else if (!edma_was_enabled) {
 		struct ata_queued_cmd *qc = mv_get_active_qc(ap);
 		if (qc)
-			ata_sff_host_intr(ap, qc);
+			ata_bmdma_port_intr(ap, qc);
 		else
 			mv_unexpected_intr(ap, edma_was_enabled);
 	}
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index baa8f0d..6fd1147 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -920,7 +920,7 @@ static int nv_host_intr(struct ata_port *ap, u8 irq_stat)
 	}
 
 	/* handle interrupt */
-	return ata_sff_host_intr(ap, qc);
+	return ata_bmdma_port_intr(ap, qc);
 }
 
 static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
@@ -1100,7 +1100,7 @@ static void nv_adma_irq_clear(struct ata_port *ap)
 	u32 notifier_clears[2];
 
 	if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
-		ata_sff_irq_clear(ap);
+		ata_bmdma_irq_clear(ap);
 		return;
 	}
 
@@ -1505,7 +1505,7 @@ static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance)
 
 		qc = ata_qc_from_tag(ap, ap->link.active_tag);
 		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
-			handled += ata_sff_host_intr(ap, qc);
+			handled += ata_bmdma_port_intr(ap, qc);
 		} else {
 			/*
 			 * No request pending?  Clear interrupt status
@@ -2430,7 +2430,7 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ppi[0] = &nv_port_info[type];
 	ipriv = ppi[0]->private_data;
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index d533b3d..daeebf1 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -120,8 +120,6 @@ static void qs_host_stop(struct ata_host *host);
 static void qs_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int qs_qc_issue(struct ata_queued_cmd *qc);
 static int qs_check_atapi_dma(struct ata_queued_cmd *qc);
-static void qs_bmdma_stop(struct ata_queued_cmd *qc);
-static u8 qs_bmdma_status(struct ata_port *ap);
 static void qs_freeze(struct ata_port *ap);
 static void qs_thaw(struct ata_port *ap);
 static int qs_prereset(struct ata_link *link, unsigned long deadline);
@@ -137,8 +135,6 @@ static struct ata_port_operations qs_ata_ops = {
 	.inherits		= &ata_sff_port_ops,
 
 	.check_atapi_dma	= qs_check_atapi_dma,
-	.bmdma_stop		= qs_bmdma_stop,
-	.bmdma_status		= qs_bmdma_status,
 	.qc_prep		= qs_qc_prep,
 	.qc_issue		= qs_qc_issue,
 
@@ -190,16 +186,6 @@ static int qs_check_atapi_dma(struct ata_queued_cmd *qc)
 	return 1;	/* ATAPI DMA not supported */
 }
 
-static void qs_bmdma_stop(struct ata_queued_cmd *qc)
-{
-	/* nothing */
-}
-
-static u8 qs_bmdma_status(struct ata_port *ap)
-{
-	return 0;
-}
-
 static inline void qs_enter_reg_mode(struct ata_port *ap)
 {
 	u8 __iomem *chan = qs_mmio_base(ap->host) + (ap->port_no * 0x4000);
@@ -454,7 +440,7 @@ static inline unsigned int qs_intr_mmio(struct ata_host *host)
 		if (!pp || pp->state != qs_state_mmio)
 			continue;
 		if (!(qc->tf.flags & ATA_TFLAG_POLLING))
-			handled |= ata_sff_host_intr(ap, qc);
+			handled |= ata_sff_port_intr(ap, qc);
 	}
 	return handled;
 }
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 2dda312..3a4f842 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -503,7 +503,7 @@ static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
 		goto err_hsm;
 
 	/* ack bmdma irq events */
-	ata_sff_irq_clear(ap);
+	ata_bmdma_irq_clear(ap);
 
 	/* kick HSM in the ass */
 	ata_sff_hsm_move(ap, qc, status, 0);
@@ -584,7 +584,7 @@ static void sil_thaw(struct ata_port *ap)
 
 	/* clear IRQ */
 	ap->ops->sff_check_status(ap);
-	ata_sff_irq_clear(ap);
+	ata_bmdma_irq_clear(ap);
 
 	/* turn on SATA IRQ if supported */
 	if (!(ap->flags & SIL_FLAG_NO_SATA_IRQ))
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index f8a91bf..2bfe3ae 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -279,7 +279,7 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		break;
 	}
 
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 
@@ -308,7 +308,7 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 	pci_intx(pdev, 1);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &sis_sht);
 }
 
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 101fd6a..7d9db4a 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -502,7 +502,7 @@ static int k2_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *en
 	writel(0x0, mmio_base + K2_SATA_SIM_OFFSET);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &k2_sata_sht);
 }
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index d8dac17..b8578c3 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -242,7 +242,7 @@ static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 	pci_intx(pdev, 1);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &uli_sht);
 }
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 08f6549..101d8c2 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -308,7 +308,7 @@ static void svia_noop_freeze(struct ata_port *ap)
 	 * certain way.  Leave it alone and just clear pending IRQ.
 	 */
 	ap->ops->sff_check_status(ap);
-	ata_sff_irq_clear(ap);
+	ata_bmdma_irq_clear(ap);
 }
 
 /**
@@ -463,7 +463,7 @@ static int vt6420_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 	struct ata_host *host;
 	int rc;
 
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 	*r_host = host;
@@ -520,7 +520,7 @@ static int vt8251_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 	struct ata_host *host;
 	int i, rc;
 
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 	*r_host = host;
@@ -628,7 +628,7 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	svia_configure(pdev);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &svia_sht);
 }
 
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 2107952..b777176 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -245,7 +245,7 @@ static void vsc_port_intr(u8 port_status, struct ata_port *ap)
 
 	qc = ata_qc_from_tag(ap, ap->link.active_tag);
 	if (qc && likely(!(qc->tf.flags & ATA_TFLAG_POLLING)))
-		handled = ata_sff_host_intr(ap, qc);
+		handled = ata_bmdma_port_intr(ap, qc);
 
 	/* We received an interrupt during a polled command,
 	 * or some other spurious condition.  Interrupt reporting
diff --git a/include/linux/libata.h b/include/linux/libata.h
index ee84e7e..3bad270 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -386,6 +386,7 @@ enum {
 	ATA_HORKAGE_1_5_GBPS	= (1 << 13),	/* force 1.5 Gbps */
 	ATA_HORKAGE_NOSETXFER	= (1 << 14),	/* skip SETXFER, SATA only */
 	ATA_HORKAGE_BROKEN_FPDMA_AA	= (1 << 15),	/* skip AA */
+	ATA_HORKAGE_DUMP_ID	= (1 << 16),	/* dump IDENTIFY data */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
@@ -513,7 +514,9 @@ struct ata_ioports {
 	void __iomem		*command_addr;
 	void __iomem		*altstatus_addr;
 	void __iomem		*ctl_addr;
+#ifdef CONFIG_ATA_BMDMA
 	void __iomem		*bmdma_addr;
+#endif /* CONFIG_ATA_BMDMA */
 	void __iomem		*scr_addr;
 };
 #endif /* CONFIG_ATA_SFF */
@@ -721,8 +724,10 @@ struct ata_port {
 	u8			ctl;	/* cache of ATA control register */
 	u8			last_ctl;	/* Cache last written value */
 	struct delayed_work	sff_pio_task;
+#ifdef CONFIG_ATA_BMDMA
 	struct ata_bmdma_prd	*bmdma_prd;	/* BMDMA SG list */
 	dma_addr_t		bmdma_prd_dma;	/* and its DMA mapping */
+#endif /* CONFIG_ATA_BMDMA */
 #endif /* CONFIG_ATA_SFF */
 
 	unsigned int		pio_mask;
@@ -856,10 +861,12 @@ struct ata_port_operations {
 	void (*sff_irq_clear)(struct ata_port *);
 	void (*sff_drain_fifo)(struct ata_queued_cmd *qc);
 
+#ifdef CONFIG_ATA_BMDMA
 	void (*bmdma_setup)(struct ata_queued_cmd *qc);
 	void (*bmdma_start)(struct ata_queued_cmd *qc);
 	void (*bmdma_stop)(struct ata_queued_cmd *qc);
 	u8   (*bmdma_status)(struct ata_port *ap);
+#endif /* CONFIG_ATA_BMDMA */
 #endif /* CONFIG_ATA_SFF */
 
 	ssize_t (*em_show)(struct ata_port *ap, char *buf);
@@ -1555,7 +1562,6 @@ extern void sata_pmp_error_handler(struct ata_port *ap);
 #ifdef CONFIG_ATA_SFF
 
 extern const struct ata_port_operations ata_sff_port_ops;
-extern const struct ata_port_operations ata_bmdma_port_ops;
 extern const struct ata_port_operations ata_bmdma32_port_ops;
 
 /* PIO only, sg_tablesize and dma_boundary limits can be removed */
@@ -1564,11 +1570,6 @@ extern const struct ata_port_operations ata_bmdma32_port_ops;
 	.sg_tablesize		= LIBATA_MAX_PRD,		\
 	.dma_boundary		= ATA_DMA_BOUNDARY
 
-#define ATA_BMDMA_SHT(drv_name)					\
-	ATA_BASE_SHT(drv_name),					\
-	.sg_tablesize		= LIBATA_MAX_PRD,		\
-	.dma_boundary		= ATA_DMA_BOUNDARY
-
 extern void ata_sff_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_sff_check_status(struct ata_port *ap);
 extern void ata_sff_pause(struct ata_port *ap);
@@ -1593,7 +1594,7 @@ extern int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 extern void ata_sff_queue_pio_task(struct ata_port *ap, unsigned long delay);
 extern unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc);
 extern bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc);
-extern unsigned int ata_sff_host_intr(struct ata_port *ap,
+extern unsigned int ata_sff_port_intr(struct ata_port *ap,
 				      struct ata_queued_cmd *qc);
 extern irqreturn_t ata_sff_interrupt(int irq, void *dev_instance);
 extern void ata_sff_lost_interrupt(struct ata_port *ap);
@@ -1625,11 +1626,24 @@ extern int ata_pci_sff_init_one(struct pci_dev *pdev,
 		struct scsi_host_template *sht, void *host_priv, int hflags);
 #endif /* CONFIG_PCI */
 
+#ifdef CONFIG_ATA_BMDMA
+
+extern const struct ata_port_operations ata_bmdma_port_ops;
+
+#define ATA_BMDMA_SHT(drv_name)					\
+	ATA_BASE_SHT(drv_name),					\
+	.sg_tablesize		= LIBATA_MAX_PRD,		\
+	.dma_boundary		= ATA_DMA_BOUNDARY
+
 extern void ata_bmdma_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc);
 extern void ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc);
+extern unsigned int ata_bmdma_port_intr(struct ata_port *ap,
+				      struct ata_queued_cmd *qc);
+extern irqreturn_t ata_bmdma_interrupt(int irq, void *dev_instance);
 extern void ata_bmdma_error_handler(struct ata_port *ap);
 extern void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc);
+extern void ata_bmdma_irq_clear(struct ata_port *ap);
 extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
 extern void ata_bmdma_start(struct ata_queued_cmd *qc);
 extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
@@ -1640,7 +1654,15 @@ extern int ata_bmdma_port_start32(struct ata_port *ap);
 #ifdef CONFIG_PCI
 extern int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev);
 extern void ata_pci_bmdma_init(struct ata_host *host);
+extern int ata_pci_bmdma_prepare_host(struct pci_dev *pdev,
+				      const struct ata_port_info * const * ppi,
+				      struct ata_host **r_host);
+extern int ata_pci_bmdma_init_one(struct pci_dev *pdev,
+				  const struct ata_port_info * const * ppi,
+				  struct scsi_host_template *sht,
+				  void *host_priv, int hflags);
 #endif /* CONFIG_PCI */
+#endif /* CONFIG_ATA_BMDMA */
 
 /**
  *	ata_sff_busy_wait - Wait for a port status register
