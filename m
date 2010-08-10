Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab0HJFKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 01:10:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56225 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0HJFKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 01:10:14 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 9 Aug 2010 23:09:53 -0600
X-Google-Sender-Auth: RLxQds_BWXfWCvv68g8wwT8hkPo
Message-ID: <AANLkTin56qEAUYXj4WRT3Gp6XAmDPfPhsa2tKV-=ridc@mail.gmail.com>
Subject: [git pull] of_device-->platform_device mass rename and 2 regression 
	fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Now that you've pulled in most of the linux-next trees, here is the
pull request for the mass rename of of_device to platform_device.  The
only merge conflict left is with the next-spi branch which you haven't
pulled into your tree yet, but the conflict is trivial[1].

It also will cause a build failure on the new sata_dwc_460ex.c driver
which also isn't in your tree yet.  You can grab the fix patch here[1]
when that driver hits your tree, or I can include it in my tree as I
collect regression fixes.

This branch has been build tested on all the important
architectures[2], and been run through linux-next with no new build
failures[3] (as far as I can tell at least).

[1] http://www.gossamer-threads.com/lists/linux/kernel/1260593
[2] http://kisskb.ellerman.id.au/kisskb/branch/13/
[3] http://kisskb.ellerman.id.au/kisskb/branch/9/

The following changes since commit 45d7f32c7a43cbb9592886d38190e379e2eb2226:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../cmetcalf/linux-tile

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-devicetree

Anton Vorontsov (1):
      mmc_spi: Fix unterminated of_match_table

Grant Likely (2):
      of/device: Replace struct of_device with struct platform_device
      of/sparc: fix build regression from of_device changes

 arch/powerpc/platforms/83xx/mpc837x_mds.c     |    2 +-
 arch/powerpc/platforms/83xx/mpc837x_rdb.c     |    2 +-
 arch/powerpc/sysdev/fsl_rio.c                 |    2 +-
 drivers/ata/pata_mpc52xx.c                    |    8 ++--
 drivers/ata/pata_of_platform.c                |    4 +-
 drivers/ata/sata_fsl.c                        |    8 ++--
 drivers/atm/fore200e.c                        |   26 +++++++-------
 drivers/block/xsysace.c                       |    4 +-
 drivers/char/hw_random/n2-drv.c               |    4 +-
 drivers/char/hw_random/n2rng.h                |    2 +-
 drivers/char/hw_random/pasemi-rng.c           |    4 +-
 drivers/char/ipmi/ipmi_si_intf.c              |    4 +-
 drivers/char/rtc.c                            |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c    |    4 +-
 drivers/crypto/amcc/crypto4xx_core.c          |    4 +-
 drivers/crypto/amcc/crypto4xx_core.h          |    2 +-
 drivers/crypto/n2_core.c                      |   26 +++++++-------
 drivers/crypto/talitos.c                      |    6 ++--
 drivers/dma/fsldma.c                          |    4 +-
 drivers/dma/mpc512x_dma.c                     |    4 +-
 drivers/dma/ppc4xx/adma.c                     |    8 ++--
 drivers/edac/mpc85xx_edac.c                   |   12 +++---
 drivers/edac/ppc4xx_edac.c                    |   12 +++---
 drivers/hwmon/ams/ams.h                       |    2 +-
 drivers/hwmon/ultra45_env.c                   |    4 +-
 drivers/i2c/busses/i2c-cpm.c                  |    8 ++--
 drivers/i2c/busses/i2c-ibm_iic.c              |    6 ++--
 drivers/i2c/busses/i2c-mpc.c                  |    4 +-
 drivers/infiniband/hw/ehca/ehca_classes.h     |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c        |    4 +-
 drivers/input/misc/sparcspkr.c                |   10 +++---
 drivers/input/serio/i8042-sparcio.h           |    8 ++--
 drivers/input/serio/xilinx_ps2.c              |    4 +-
 drivers/leds/leds-gpio.c                      |    4 +-
 drivers/macintosh/macio_sysfs.c               |    6 ++--
 drivers/macintosh/smu.c                       |    6 ++--
 drivers/macintosh/therm_adt746x.c             |    2 +-
 drivers/macintosh/therm_pm72.c                |    6 ++--
 drivers/macintosh/therm_windtunnel.c          |    6 ++--
 drivers/media/video/fsl-viu.c                 |    8 ++--
 drivers/mmc/host/mmc_spi.c                    |    1 +
 drivers/mmc/host/sdhci-of-core.c              |    8 ++--
 drivers/mtd/maps/physmap_of.c                 |    8 ++--
 drivers/mtd/maps/sun_uflash.c                 |    6 ++--
 drivers/mtd/nand/fsl_elbc_nand.c              |    4 +-
 drivers/mtd/nand/fsl_upm.c                    |    4 +-
 drivers/mtd/nand/mpc5121_nfc.c                |    4 +-
 drivers/mtd/nand/ndfc.c                       |    6 ++--
 drivers/mtd/nand/pasemi_nand.c                |    4 +-
 drivers/mtd/nand/socrates_nand.c              |    4 +-
 drivers/net/can/mscan/mpc5xxx_can.c           |   18 +++++-----
 drivers/net/can/sja1000/sja1000_of_platform.c |    4 +-
 drivers/net/ehea/ehea.h                       |    4 +-
 drivers/net/ehea/ehea_main.c                  |   12 +++---
 drivers/net/fec_mpc52xx.c                     |    8 ++--
 drivers/net/fec_mpc52xx_phy.c                 |    4 +-
 drivers/net/fs_enet/fs_enet-main.c            |    4 +-
 drivers/net/fs_enet/mac-fcc.c                 |    2 +-
 drivers/net/fs_enet/mac-fec.c                 |    2 +-
 drivers/net/fs_enet/mac-scc.c                 |    2 +-
 drivers/net/fs_enet/mii-bitbang.c             |    4 +-
 drivers/net/fs_enet/mii-fec.c                 |    4 +-
 drivers/net/fsl_pq_mdio.c                     |    4 +-
 drivers/net/gianfar.c                         |   10 +++---
 drivers/net/gianfar.h                         |    2 +-
 drivers/net/greth.c                           |    6 ++--
 drivers/net/greth.h                           |    2 +-
 drivers/net/ibm_newemac/core.c                |    6 ++--
 drivers/net/ibm_newemac/core.h                |   12 +++---
 drivers/net/ibm_newemac/mal.c                 |    4 +-
 drivers/net/ibm_newemac/mal.h                 |    2 +-
 drivers/net/ibm_newemac/rgmii.c               |   18 +++++-----
 drivers/net/ibm_newemac/rgmii.h               |   16 ++++----
 drivers/net/ibm_newemac/tah.c                 |   14 ++++----
 drivers/net/ibm_newemac/tah.h                 |   12 +++---
 drivers/net/ibm_newemac/zmii.c                |   18 +++++-----
 drivers/net/ibm_newemac/zmii.h                |   16 ++++----
 drivers/net/ll_temac_main.c                   |    8 ++--
 drivers/net/myri_sbus.c                       |    4 +-
 drivers/net/myri_sbus.h                       |    2 +-
 drivers/net/niu.c                             |    8 ++--
 drivers/net/phy/mdio-gpio.c                   |    4 +-
 drivers/net/sunbmac.c                         |   18 +++++-----
 drivers/net/sunbmac.h                         |    4 +-
 drivers/net/sunhme.c                          |   22 ++++++------
 drivers/net/sunhme.h                          |    2 +-
 drivers/net/sunlance.c                        |   20 ++++++------
 drivers/net/sunqe.c                           |   16 ++++----
 drivers/net/sunqe.h                           |    4 +-
 drivers/net/ucc_geth.c                        |    8 ++--
 drivers/net/xilinx_emaclite.c                 |    6 ++--
 drivers/of/device.c                           |    2 +-
 drivers/parport/parport_sunbpp.c              |    4 +-
 drivers/pcmcia/electra_cf.c                   |    6 ++--
 drivers/pcmcia/m8xx_pcmcia.c                  |    4 +-
 drivers/rtc/rtc-mpc5121.c                     |    4 +-
 drivers/sbus/char/bbc_envctrl.c               |    6 ++--
 drivers/sbus/char/bbc_i2c.c                   |   18 +++++-----
 drivers/sbus/char/bbc_i2c.h                   |   10 +++---
 drivers/sbus/char/display7seg.c               |    4 +-
 drivers/sbus/char/envctrl.c                   |    4 +-
 drivers/sbus/char/flash.c                     |    4 +-
 drivers/sbus/char/uctrl.c                     |    4 +-
 drivers/scsi/qlogicpti.c                      |   14 ++++----
 drivers/scsi/qlogicpti.h                      |    2 +-
 drivers/scsi/sun_esp.c                        |   44 ++++++++++++------------
 drivers/serial/apbuart.c                      |    2 +-
 drivers/serial/cpm_uart/cpm_uart_core.c       |    4 +-
 drivers/serial/mpc52xx_uart.c                 |    8 ++--
 drivers/serial/nwpserial.c                    |    2 +-
 drivers/serial/of_serial.c                    |    6 ++--
 drivers/serial/sunhv.c                        |    4 +-
 drivers/serial/sunsab.c                       |    8 ++--
 drivers/serial/sunsu.c                        |    8 ++--
 drivers/serial/sunzilog.c                     |    6 ++--
 drivers/serial/uartlite.c                     |    4 +-
 drivers/serial/ucc_uart.c                     |    4 +-
 drivers/spi/mpc512x_psc_spi.c                 |    4 +-
 drivers/spi/mpc52xx_psc_spi.c                 |    4 +-
 drivers/spi/mpc52xx_spi.c                     |    4 +-
 drivers/spi/spi_mpc8xxx.c                     |    4 +-
 drivers/spi/spi_ppc4xx.c                      |    6 ++--
 drivers/spi/xilinx_spi_of.c                   |    6 ++--
 drivers/usb/gadget/fsl_qe_udc.c               |   10 +++---
 drivers/usb/host/ehci-ppc-of.c                |    6 ++--
 drivers/usb/host/ehci-xilinx-of.c             |   12 +++---
 drivers/usb/host/fhci-hcd.c                   |    4 +-
 drivers/usb/host/isp1760-if.c                 |    4 +-
 drivers/usb/host/ohci-ppc-of.c                |    6 ++--
 drivers/video/bw2.c                           |    4 +-
 drivers/video/cg14.c                          |    6 ++--
 drivers/video/cg3.c                           |    4 +-
 drivers/video/cg6.c                           |    6 ++--
 drivers/video/ffb.c                           |    4 +-
 drivers/video/fsl-diu-fb.c                    |    8 ++--
 drivers/video/leo.c                           |    6 ++--
 drivers/video/mb862xx/mb862xxfb.c             |    4 +-
 drivers/video/p9100.c                         |    4 +-
 drivers/video/platinumfb.c                    |    4 +-
 drivers/video/sunxvr1000.c                    |    4 +-
 drivers/video/tcx.c                           |    6 ++--
 drivers/video/xilinxfb.c                      |    4 +-
 drivers/watchdog/cpwd.c                       |    4 +-
 drivers/watchdog/gef_wdt.c                    |    2 +-
 drivers/watchdog/mpc8xxx_wdt.c                |    4 +-
 drivers/watchdog/riowd.c                      |    4 +-
 include/linux/of_device.h                     |   16 ---------
 include/linux/of_platform.h                   |   14 ++++++--
 sound/aoa/soundbus/core.c                     |    2 +-
 sound/aoa/soundbus/soundbus.h                 |    2 +-
 sound/aoa/soundbus/sysfs.c                    |    2 +-
 sound/soc/fsl/mpc5200_dma.c                   |    4 +-
 sound/soc/fsl/mpc5200_dma.h                   |    4 +-
 sound/soc/fsl/mpc5200_psc_ac97.c              |    4 +-
 sound/soc/fsl/mpc5200_psc_i2s.c               |    4 +-
 sound/soc/fsl/mpc8610_hpcd.c                  |    4 +-
 sound/sparc/amd7930.c                         |    8 ++--
 sound/sparc/cs4231.c                          |   18 +++++-----
 sound/sparc/dbri.c                            |    8 ++--
 159 files changed, 523 insertions(+), 530 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
