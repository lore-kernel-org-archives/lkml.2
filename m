Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab0DELQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 07:16:30 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:55228 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab0DELQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 07:16:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:date:user-agent:mime-version:to:cc:message-id
         :content-type:content-transfer-encoding;
        b=o0BH+1tGEDVKV1PPXp4iqd2329TYs+uQwJ1W+c2guvB/s5J0zRKcOAZRgq+OXSessh
         xQE9CYKcKz17wZn2MPN4+1GE6pZqfasTtiU7dW3jcbg7uZk2CjkQevmL8rJSYGAFbkus
         agGT4c6BQ++YNMJU8uuKIlDG0d3dSSZ/KBhP0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [announce] atang tree has been rebased on top of 2.6.33
Date: Mon, 5 Apr 2010 12:12:17 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-Id: <201004051312.17105.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes:
- whole tree has been re-based on top of 2.6.33 kernel
- individual patches adding 32-bit PIO support to PATA drivers
  have been combined together
- duplicated ata_timing_* EXPORT_SYMBOLs have been removed

( As a net result the total number of patches kept in atang tree
  has decreased from 261 to 224. )


The standalone patch for vanilla 2.6.33 is now also available at:

  http://www.kernel.org/pub/linux/kernel/people/bart/atang/patch-2.6.33-atang1.bz2


atang tree highlights:

* Support for more ATA controllers (SIL3x12 SATA on IXP425 platform,
  Cirrus Logic's EP93xx PATA, Altera CompactFlash PATA and Samsung
  S3C PATA)

* Enhanced SSD detection so block layer optimizations can be applied
  to many more SSD devices

* Fix to make SATA Asynchronous Notification work on distributions
  using HAL (-> almost all current distributions)

* Fix for Promise PATA UDMA problems

* ide2libata framework

* Various bug fixes, cleanups & other improvements for both libata/ide
  subsystems (please see the ChangeLog below for details)


The following changes since commit 60b341b778cc2929df16c0a504c91621b3c6a4ad:
  Linus Torvalds (1):
        Linux 2.6.33

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v5.0

Bartlomiej Zolnierkiewicz (203):
      ata_piix: unify code for programming PIO and MWDMA timings
      libata: make ata_sff_data_xfer_noirq() work with 32-bit PIO
      libata: add 32-bit PIO support to PATA drivers (part 1)
      libata: add 32-bit PIO support to PATA drivers (part 2)
      pata_sch: add 32-bit PIO support
      pata_artop: fix chipsets naming
      pata_artop: add Power Management support
      pata_artop: unify ->prereset methods
      pata_artop: remove dead 34MHz PCI clock support
      pata_atiixp: no need to program PIO timings for MWDMA
      pata_atiixp: add MWDMA0 support
      pata_atiixp: remove custom BMDMA methods
      pata_atiixp: add proper ->prereset method
      pata_efar: fix register naming used in efar_set_piomode()
      pata_efar: unify code for programming PIO and MWDMA timings
      pata_cmd64x: add enablebits checking
      pata_cmd64x: add cmd64x_fixup()
      pata_cs5535: no need to program PIO0 timings during device init
      pata_hpt366: add enablebits checking
      pata_hpt366: add hpt36x_find_mode() helper
      pata_hpt3x2n: add enablebits checking
      pata_it8213: add UDMA100 and UDMA133 support
      pata_it8213: fix register naming used in it8213_set_piomode()
      pata_it8213: unify code for programming PIO and MWDMA timings
      pata_legacy: do not probe extra ports automatically if PCI is not present
      pata_legacy: unify QDI ->set_piomode methods
      pata_legacy: use PIO mask defines
      libata: remove no longer needed pata_qdi driver
      libata: remove no longer needed pata_winbond driver
      pata_oldpiix: unify code for programming PIO and MWDMA timings
      pata_pdc2027x: add Power Management support
      pata_pdc202xx_old: Power Management fix
      pata_radisys: unify code for programming PIO and MWDMA timings
      pata_rdc: unify code for programming PIO and MWDMA timings
      pata_scc: add proper cable detection method
      pata_serverworks: use standard cable detection methods
      pata_serverworks: add serverworks_fixup()
      pata_sl82c105: add Power Management support
      pata_via: add via_fixup()
      libata: add ata_mwdma_to_pio() inline helper
      libata: add ->init_host method
      pata_cmd640: document known issues
      pata_cypress: document known issues
      pata_pdc202xx_old: document known issues
      icside: bring back ->maskproc method
      scc_pata: fix module unloading
      add PATA host controller support for Cirrus Logic's EP93xx CPUs (v2)
      libata: fix CFA handling in ide_timing_compute()
      pata_ali: documentation fixes
      pata_ali: cleanup ali_set_piomode()
      pata_amd: remove bogus code from timing_setup()
      pata_atiixp: remove superfluous wrapper function
      pata_atiixp: add locking for parallel scanning
      pata_atiixp: enable parallel scan
      pata_cmd64x: fix PIO setup
      pata_cmd64x: fix handling of address setup timings
      pata_cmd64x: cmd648_bmdma_stop() fix
      pata_cmd64x: remove unused definitions
      pata_cs5520: convert to use ->init_host method
      pata_cs5535: use correct values for PIO1 and PIO2 data timings
      pata_cypress: fix PIO timings underclocking
      pata_efar: always program master_data before slave_data
      pata_efar: fix secondary port support
      pata_efar: add locking for parallel scanning
      pata_efar: enable parallel scan
      pata_serverworks: fix PIO setup for the second channel
      pata_serverworks: fix error message
      pata_serverworks: cleanup cable detection
      pata_via: fix address setup timings underlocking
      pata_via: store UDMA masks in via_isa_bridges table
      ide: fix for ide_timing quantisation errors
      ide: use standard timing for XFER_PIO_SLOW mode in ide_timing_compute()
      alim15x3: fix PIO timings calculations
      alim15x3: add ali_fifo_control() helper
      alim15x3: remove superfluous locking from ali_set_pio_mode()
      alim15x3: cleanup ali_cable_detect()
      amd74xx: don't change UDMA settings when programming PIO timings
      cmd64x: fix PIO and MWDMA timings calculations
      cmd64x: remove superfluous checks from cmd64x_set_dma_mode()
      cy82c693: fix PIO timings calculations
      cy82c693: remove stale driver history
      opti621: remove stale driver history
      pdc202xx_old: add ->init_hwif method
      serverworks: cleanup svwks_udma_filter()
      serverworks: add missing pci_dev_put() call
      via82cxxx: vx855 is a single channel controller
      ide: add SATA cable detection support
      via82cxxx: fix SATA cable detection
      via82cxxx: workaround h/w bugs
      via82cxxx: add support for vt8261 and future chips
      via82cxxx: add support for VT6415 PCIE PATA IDE Host Controller
      via82cxxx: fix UDMA settings programming
      ide: add drive->pio_mode field
      ide: add drive->dma_mode field
      ide: change ->set_pio_mode method parameters
      ide: change ->set_dma_mode method parameters
      ide-timings: use ->pio_mode value to determine fastest PIO speed
      alim15x3: fix handling of address setup timings
      alim15x3: fix handling of command timings
      alim15x3: fix handling of DMA timings
      alim15x3: fix handling of UDMA enable bit
      amd74xx: use ->pio_mode value to determine pair device speed
      cmd64x: fix handling of address setup timings
      cs5535: use ->pio_mode value to determine pair device speed
      cs5536: use ->pio_mode value to determine pair device speed
      it821x: use ->pio_mode value to determine pair device speed
      palm_bk3710: use ->pio_mode value to determine pair device speed
      siimage: use ->pio_mode value to determine pair device speed
      tx493xide: use ->pio_mode value to determine pair device speed
      via82cxxx: use ->pio_mode value to determine pair device speed
      ide: make ide_get_best_pio_mode() static
      libata: ata_timing_compute() fixup
      ide: ide_timing_compute() fixup
      piix: add new short cable IDs
      libata: CodingStyle fixes for ATA timings code
      libata: move ATA timings code to ata-timings.c
      ata: make ATA timings code independent of libata
      ata: enable XFER_PIO_SLOW mode in ata_timing table
      ide: switch to generic ATA timings code
      pata_pcmcia: move IDs table to pata_pcmcia.h
      ide-cs: use pata_pcmcia.h
      ata_piix: factor out short cable detection code to ich_short_ata40()
      ata_piix: move short cable handling to ata_piix.h
      piix: use ata_piix.h
      pata_ali: move short cable handling to pata_ali.h
      alim15x3: use pata_ali.h
      pata_sis: move short cable handling to pata_sis.h
      sis5513: use pata_sis.h
      pata_via: move short cable handling to pata_via.h
      via82cxxx: use pata_via.h
      ide: split host->dev table
      ide: add hwif->port_no field
      ide: add hwif->udma_mask field
      ide: add hwif->private_data field
      ide: add drive->devno field
      ide: add drive->class field
      ide: change ->cable_detect method return type to 'int'
      it8213: always program control bits
      piix: always program control bits
      slc90e66: always program control bits
      add ide2libata header file
      ata_piix: move code to be re-used by ide2libata to ata_piix.h
      piix: convert to ide2libata
      pata_ali: move code to be re-used by ide2libata to pata_ali.h
      alim15x3: convert to ide2libata
      pata_amd: move code to be re-used by ide2libata to pata_amd.h
      amd74xx: convert to ide2libata
      pata_artop: move code to be re-used by ide2libata to pata_artop.h
      aec62xx: convert to ide2libata
      pata_atiixp: move code to be re-used by ide2libata to pata_atiixp.h
      atiixp: convert to ide2libata
      pata_cmd64x: documentation fix
      pata_cmd64x: move code to be re-used by ide2libata to pata_cmd64x.h
      pata_cmd64x: convert to ide2libata
      pata_cs5520: move code to be re-used by ide2libata to pata_cs5520.h
      cs5520: convert to ide2libata
      pata_cs5530: move code to be re-used by ide2libata to pata_cs5530.h
      cs5530: convert to ide2libata
      pata_cs5535: move code to be re-used by ide2libata to pata_cs5535.h
      cs5535: convert to ide2libata
      pata_cypress: move code to be re-used by ide2libata to pata_cypress.h
      cy82c693: convert to ide2libata
      pata_efar: move code to be re-used by ide2libata to pata_efar.h
      slc90e66: convert to ide2libata
      pata_it8213: move code to be re-used by ide2libata to pata_it8213.h
      it8213: convert to ide2libata
      pata_it821x: move code to be re-used by ide2libata to pata_it821x.h
      it821x: convert to ide2libata
      pata_pdc202xx_old: move code to be re-used by ide2libata to pata_pdc202xx_old.h
      pdc202xx_old: convert to ide2libata
      pata_sc1200: move code to be re-used by ide2libata to pata_sc1200.h
      sc1200: convert to ide2libata
      pata_serverworks: move cable handling to pata_serverworks.h
      serverworks: convert to ide2libata
      pata_sl82c105: move code to be re-used by ide2libata to pata_sl82c105.h
      sl82c105: convert to ide2libata
      pata_triflex: move code to be re-used by ide2libata to pata_triflex.h
      triflex: convert to ide2libata
      pata_via: factor out code for finding ISA bridge
      pata_via: move code to be re-used by ide2libata to pata_via.h
      via82cxxx: convert to ide2libata
      pata_cs5536: forward port changes from cs5536
      pata_sil680: CodingStyle fixes
      siimage: cleanup I/O helpers
      piix: move documentation to ata_piix.h
      ide2libata: add missing credits
      pata_cs5536: move code to be re-used by ide2libata to pata_cs5536.h
      cs5536: convert to ide2libata
      pata_sil680: move code to be re-used by ide2libata to pata_sil680.h
      siimage: convert to ide2libata
      pata_opti: move code to be re-used by ide2libata to pata_opti.h
      opti621: convert to ide2libata
      ide: remove obsolete /proc/ide/hdx/ settings
      ide: remove obsolete /proc/ide/ interface
      move host drivers for VLB IDE controllers to staging/out
      ide: remove hwif_chipset_t type
      pata_pdc202xx_old: fix UDMA mode for Promise UDMA33 cards
      pata_pdc202xx_old: fix UDMA mode for PDC2026x chipsets
      pata_pdc202xx_old: update documentation
      libata: pass host flags into __ata_pci_sff_init_one() helper
      pata_oldpiix: add locking for parallel scanning
      pata_oldpiix: enable parallel scan
      libata: enhanced SSD detection

H Hartley Sweeten (1):
      arm/ep93xx: platform support for EP93xx IDE

Krzysztof Halasa (1):
      sata_sil: IXP425 workaround

Mikulas Patocka (1):
      via82cxxx: don't use UDMA on VIA UDMA33 controller with Transcend SSD

Robert Hancock (1):
      scsi: properly export media change notification capability in block device flags

Russell King (1):
      Fix Promise UDMA33 IDE driver (pdc202xx_old)

Sergei Shtylyov (6):
      hpt366: add debounce delay to cable_detect() method
      pata_hpt3x2n: always stretch UltraDMA timing
      pata_hpt{37x|3x2n}: unify mode programming
      pata_hpt366: remove redundant code
      pata_hpt{37x|3x2n}: improve timing register documentation
      pata_hpt366: remove irrelevant TODO

Thomas Abraham (8):
      S3C64XX: Add physical address definition for Compact Flash controller.
      S3C64XX: Add MEM_SYS_CFG register definition.
      S3C64XX: Add IDE controller register definitions.
      S3C64XX: Add clock source definition for IDE controller.
      S3C64XX: Add platform data and driver resources for IDE controller driver.
      S3C6410: Add platform data for S3C IDE controller driver
      S3C64XX: Include IDE device code in compilation.
      drivers/staging: Add Samsung S3C IDE controller driver

Thomas Chou (1):
      drivers/staging: New PATA driver for Altera CompactFlash.

Wolfram Sang (1):
      ide/ide-cs: fix order of releasing resources

 arch/arm/mach-ep93xx/core.c                     |   85 +++
 arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h |    1 +
 arch/arm/mach-ep93xx/include/mach/platform.h    |    3 +
 arch/arm/mach-s3c6400/include/mach/map.h        |    4 +
 arch/arm/mach-s3c6410/mach-smdk6410.c           |   14 +-
 arch/arm/plat-s3c/include/plat/devs.h           |    1 +
 arch/arm/plat-s3c/include/plat/ide.h            |   36 +
 arch/arm/plat-s3c/include/plat/regs-ide.h       |   56 ++
 arch/arm/plat-s3c64xx/Makefile                  |    1 +
 arch/arm/plat-s3c64xx/clock.c                   |    6 +
 arch/arm/plat-s3c64xx/dev-ide.c                 |   88 +++
 arch/arm/plat-s3c64xx/include/plat/regs-clock.h |    3 +
 drivers/ata/Kconfig                             |   32 +-
 drivers/ata/Makefile                            |    5 +-
 drivers/ata/ata-timings.c                       |  178 +++++
 drivers/ata/ata_piix.c                          |  353 +----------
 drivers/ata/ata_piix.h                          |  324 +++++++++
 drivers/ata/libata-core.c                       |  177 +-----
 drivers/ata/libata-scsi.c                       |   18 +-
 drivers/ata/libata-sff.c                        |   14 +-
 drivers/ata/pata_ali.c                          |  294 +--------
 drivers/ata/pata_ali.h                          |  326 +++++++++
 drivers/ata/pata_amd.c                          |  139 +----
 drivers/ata/pata_amd.h                          |   94 +++
 drivers/ata/pata_artop.c                        |  330 ++--------
 drivers/ata/pata_artop.h                        |  293 ++++++++
 drivers/ata/pata_at32.c                         |    8 +-
 drivers/ata/pata_at91.c                         |   18 +-
 drivers/ata/pata_atiixp.c                       |  200 +-----
 drivers/ata/pata_atiixp.h                       |  116 ++++
 drivers/ata/pata_atp867x.c                      |    5 +-
 drivers/ata/pata_cmd640.c                       |   36 +-
 drivers/ata/pata_cmd64x.c                       |  260 +-------
 drivers/ata/pata_cmd64x.h                       |  246 +++++++
 drivers/ata/pata_cs5520.c                       |  115 +---
 drivers/ata/pata_cs5520.h                       |   60 ++
 drivers/ata/pata_cs5530.c                       |  205 +------
 drivers/ata/pata_cs5530.h                       |  185 +++++
 drivers/ata/pata_cs5535.c                       |  127 +----
 drivers/ata/pata_cs5535.h                       |  114 ++++
 drivers/ata/pata_cs5536.c                       |  191 +------
 drivers/ata/pata_cs5536.h                       |  195 ++++++
 drivers/ata/pata_cypress.c                      |   91 +---
 drivers/ata/pata_cypress.h                      |  108 +++
 drivers/ata/pata_efar.c                         |  179 +-----
 drivers/ata/pata_efar.h                         |  161 +++++
 drivers/ata/pata_ep93xx.c                       |  776 +++++++++++++++++++++
 drivers/ata/pata_hpt366.c                       |  120 ++--
 drivers/ata/pata_hpt37x.c                       |  172 +++---
 drivers/ata/pata_hpt3x2n.c                      |  129 ++--
 drivers/ata/pata_hpt3x3.c                       |   32 +-
 drivers/ata/pata_icside.c                       |    4 +-
 drivers/ata/pata_it8213.c                       |  189 +-----
 drivers/ata/pata_it8213.h                       |  157 +++++
 drivers/ata/pata_it821x.c                       |  354 +----------
 drivers/ata/pata_it821x.h                       |  337 ++++++++++
 drivers/ata/pata_jmicron.c                      |    2 +-
 drivers/ata/pata_legacy.c                       |  176 ++---
 drivers/ata/pata_ninja32.c                      |   30 +-
 drivers/ata/pata_ns87410.c                      |    7 +-
 drivers/ata/pata_ns87415.c                      |   34 +-
 drivers/ata/pata_octeon_cf.c                    |    4 +-
 drivers/ata/pata_oldpiix.c                      |  106 +--
 drivers/ata/pata_opti.c                         |   92 +---
 drivers/ata/pata_opti.h                         |  141 ++++
 drivers/ata/pata_pcmcia.c                       |   67 +--
 drivers/ata/pata_pcmcia.h                       |   66 ++
 drivers/ata/pata_pdc2027x.c                     |   24 +-
 drivers/ata/pata_pdc202xx_old.c                 |  153 ++---
 drivers/ata/pata_pdc202xx_old.h                 |  121 ++++
 drivers/ata/pata_qdi.c                          |  366 ----------
 drivers/ata/pata_radisys.c                      |   74 +--
 drivers/ata/pata_rdc.c                          |  106 +--
 drivers/ata/pata_rz1000.c                       |    2 +
 drivers/ata/pata_sc1200.c                       |  110 +---
 drivers/ata/pata_sc1200.h                       |  112 +++
 drivers/ata/pata_scc.c                          |   14 +-
 drivers/ata/pata_sch.c                          |    2 +-
 drivers/ata/pata_serverworks.c                  |  336 +---------
 drivers/ata/pata_serverworks.h                  |  303 +++++++++
 drivers/ata/pata_sil680.c                       |  228 +-------
 drivers/ata/pata_sil680.h                       |  284 ++++++++
 drivers/ata/pata_sis.c                          |   34 +-
 drivers/ata/pata_sis.h                          |   30 +
 drivers/ata/pata_sl82c105.c                     |  112 +---
 drivers/ata/pata_sl82c105.h                     |  110 +++
 drivers/ata/pata_triflex.c                      |   74 +--
 drivers/ata/pata_triflex.h                      |   69 ++
 drivers/ata/pata_via.c                          |  334 +---------
 drivers/ata/pata_via.h                          |  269 ++++++++
 drivers/ata/pata_winbond.c                      |  282 --------
 drivers/ata/sata_sil.c                          |   50 +-
 drivers/ide/Kconfig                             |   84 +---
 drivers/ide/Makefile                            |   15 -
 drivers/ide/aec62xx.c                           |  175 +-----
 drivers/ide/alim15x3.c                          |  286 +--------
 drivers/ide/amd74xx.c                           |   92 +--
 drivers/ide/at91_ide.c                          |   15 +-
 drivers/ide/atiixp.c                            |  128 +----
 drivers/ide/au1xxx-ide.c                        |   10 +-
 drivers/ide/buddha.c                            |    1 -
 drivers/ide/cmd640.c                            |    8 +-
 drivers/ide/cmd64x.c                            |  228 +------
 drivers/ide/cs5520.c                            |   50 +--
 drivers/ide/cs5530.c                            |  152 +----
 drivers/ide/cs5535.c                            |  145 +----
 drivers/ide/cs5536.c                            |  187 +-----
 drivers/ide/cy82c693.c                          |  236 +-------
 drivers/ide/delkin_cb.c                         |    1 -
 drivers/ide/falconide.c                         |    1 -
 drivers/ide/gayle.c                             |    1 -
 drivers/ide/hpt366.c                            |   29 +-
 drivers/ide/icside.c                            |   69 ++-
 drivers/ide/ide-cd.c                            |   54 --
 drivers/ide/ide-cs.c                            |   92 +---
 drivers/ide/ide-devsets.c                       |    6 +-
 drivers/ide/ide-disk.c                          |    3 -
 drivers/ide/ide-disk.h                          |    9 -
 drivers/ide/ide-disk_proc.c                     |  174 -----
 drivers/ide/ide-dma.c                           |    2 +-
 drivers/ide/ide-floppy.c                        |    3 -
 drivers/ide/ide-floppy.h                        |    9 -
 drivers/ide/ide-floppy_proc.c                   |   45 --
 drivers/ide/ide-gd.c                            |   18 -
 drivers/ide/ide-generic.c                       |    1 -
 drivers/ide/ide-h8300.c                         |    1 -
 drivers/ide/ide-iops.c                          |    2 +-
 drivers/ide/ide-pnp.c                           |    1 -
 drivers/ide/ide-probe.c                         |   16 +-
 drivers/ide/ide-proc.c                          |  789 ----------------------
 drivers/ide/ide-tape.c                          |   98 ---
 drivers/ide/ide-timings.c                       |  211 ------
 drivers/ide/ide-xfer-mode.c                     |   43 +-
 drivers/ide/ide.c                               |    8 +-
 drivers/ide/ide_platform.c                      |    1 -
 drivers/ide/it8172.c                            |   14 +-
 drivers/ide/it8213.c                            |  144 +----
 drivers/ide/it821x.c                            |  377 +----------
 drivers/ide/jmicron.c                           |    8 +-
 drivers/ide/macide.c                            |    1 -
 drivers/ide/opti621.c                           |  185 +-----
 drivers/ide/palm_bk3710.c                       |   22 +-
 drivers/ide/pdc202xx_new.c                      |   12 +-
 drivers/ide/pdc202xx_old.c                      |  101 +---
 drivers/ide/piix.c                              |  266 +-------
 drivers/ide/pmac.c                              |   18 +-
 drivers/ide/q40ide.c                            |    1 -
 drivers/ide/rapide.c                            |    1 -
 drivers/ide/sc1200.c                            |  121 +----
 drivers/ide/scc_pata.c                          |   27 +-
 drivers/ide/serverworks.c                       |  311 +--------
 drivers/ide/setup-pci.c                         |    6 +-
 drivers/ide/sgiioc4.c                           |    3 +-
 drivers/ide/siimage.c                           |  342 +---------
 drivers/ide/sis5513.c                           |   35 +-
 drivers/ide/sl82c105.c                          |  113 +---
 drivers/ide/slc90e66.c                          |  119 +---
 drivers/ide/tc86c001.c                          |   11 +-
 drivers/ide/triflex.c                           |   61 +--
 drivers/ide/tx4938ide.c                         |   10 +-
 drivers/ide/tx4939ide.c                         |   13 +-
 drivers/ide/via82cxxx.c                         |  349 +++-------
 drivers/scsi/sd.c                               |    2 +
 drivers/scsi/sr.c                               |    2 +
 drivers/staging/Kconfig                         |    6 +
 drivers/staging/Makefile                        |    3 +
 drivers/staging/ide-vlb/Kconfig                 |   69 ++
 drivers/staging/ide-vlb/Makefile                |    7 +
 drivers/staging/ide-vlb/TODO                    |    5 +
 drivers/{ide => staging/ide-vlb}/ali14xx.c      |    6 +-
 drivers/{ide => staging/ide-vlb}/dtc2278.c      |    5 +-
 drivers/{ide => staging/ide-vlb}/ht6560b.c      |   23 +-
 drivers/{ide => staging/ide-vlb}/ide-4drives.c  |    1 -
 drivers/{ide => staging/ide-vlb}/qd65xx.c       |   15 +-
 drivers/{ide => staging/ide-vlb}/qd65xx.h       |    0
 drivers/{ide => staging/ide-vlb}/umc8672.c      |    6 +-
 drivers/staging/pata_altera_cf/Kconfig          |   11 +
 drivers/staging/pata_altera_cf/Makefile         |    1 +
 drivers/staging/pata_altera_cf/TODO             |    5 +
 drivers/staging/pata_altera_cf/pata_altera_cf.c |  582 ++++++++++++++++
 drivers/staging/s3c-ide/Kconfig                 |    8 +
 drivers/staging/s3c-ide/Makefile                |    1 +
 drivers/staging/s3c-ide/TODO                    |    6 +
 drivers/staging/s3c-ide/s3c-ide.c               |  822 +++++++++++++++++++++++
 include/linux/ata.h                             |   54 ++
 include/linux/ide.h                             |  163 +----
 include/linux/ide2libata.h                      |   17 +
 include/linux/libata.h                          |   52 +--
 188 files changed, 8584 insertions(+), 11547 deletions(-)
 create mode 100644 arch/arm/plat-s3c/include/plat/ide.h
 create mode 100644 arch/arm/plat-s3c/include/plat/regs-ide.h
 create mode 100644 arch/arm/plat-s3c64xx/dev-ide.c
 create mode 100644 drivers/ata/ata-timings.c
 create mode 100644 drivers/ata/ata_piix.h
 create mode 100644 drivers/ata/pata_ali.h
 create mode 100644 drivers/ata/pata_amd.h
 create mode 100644 drivers/ata/pata_artop.h
 create mode 100644 drivers/ata/pata_atiixp.h
 create mode 100644 drivers/ata/pata_cmd64x.h
 create mode 100644 drivers/ata/pata_cs5520.h
 create mode 100644 drivers/ata/pata_cs5530.h
 create mode 100644 drivers/ata/pata_cs5535.h
 create mode 100644 drivers/ata/pata_cs5536.h
 create mode 100644 drivers/ata/pata_cypress.h
 create mode 100644 drivers/ata/pata_efar.h
 create mode 100644 drivers/ata/pata_ep93xx.c
 create mode 100644 drivers/ata/pata_it8213.h
 create mode 100644 drivers/ata/pata_it821x.h
 create mode 100644 drivers/ata/pata_opti.h
 create mode 100644 drivers/ata/pata_pcmcia.h
 create mode 100644 drivers/ata/pata_pdc202xx_old.h
 delete mode 100644 drivers/ata/pata_qdi.c
 create mode 100644 drivers/ata/pata_sc1200.h
 create mode 100644 drivers/ata/pata_serverworks.h
 create mode 100644 drivers/ata/pata_sil680.h
 create mode 100644 drivers/ata/pata_sis.h
 create mode 100644 drivers/ata/pata_sl82c105.h
 create mode 100644 drivers/ata/pata_triflex.h
 create mode 100644 drivers/ata/pata_via.h
 delete mode 100644 drivers/ata/pata_winbond.c
 delete mode 100644 drivers/ide/ide-disk_proc.c
 delete mode 100644 drivers/ide/ide-floppy_proc.c
 delete mode 100644 drivers/ide/ide-proc.c
 delete mode 100644 drivers/ide/ide-timings.c
 create mode 100644 drivers/staging/ide-vlb/Kconfig
 create mode 100644 drivers/staging/ide-vlb/Makefile
 create mode 100644 drivers/staging/ide-vlb/TODO
 rename drivers/{ide => staging/ide-vlb}/ali14xx.c (97%)
 rename drivers/{ide => staging/ide-vlb}/dtc2278.c (97%)
 rename drivers/{ide => staging/ide-vlb}/ht6560b.c (98%)
 rename drivers/{ide => staging/ide-vlb}/ide-4drives.c (98%)
 rename drivers/{ide => staging/ide-vlb}/qd65xx.c (96%)
 rename drivers/{ide => staging/ide-vlb}/qd65xx.h (100%)
 rename drivers/{ide => staging/ide-vlb}/umc8672.c (97%)
 create mode 100644 drivers/staging/pata_altera_cf/Kconfig
 create mode 100644 drivers/staging/pata_altera_cf/Makefile
 create mode 100644 drivers/staging/pata_altera_cf/TODO
 create mode 100644 drivers/staging/pata_altera_cf/pata_altera_cf.c
 create mode 100644 drivers/staging/s3c-ide/Kconfig
 create mode 100644 drivers/staging/s3c-ide/Makefile
 create mode 100644 drivers/staging/s3c-ide/TODO
 create mode 100644 drivers/staging/s3c-ide/s3c-ide.c
 create mode 100644 include/linux/ide2libata.h
