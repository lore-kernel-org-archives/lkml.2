Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0HAH5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 03:57:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53842 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0HAH5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 03:57:43 -0400
Subject: [PATCH] of/device: Replace struct of_device with struct of_platform
To: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 01 Aug 2010 01:57:38 -0600
Message-ID: <20100801074831.1099.3318.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_device is just an alias for platform_device, so remove it entirely.  Also
replace to_of_device() with to_platform_device().

This patch was initially generated from the following semantic patch, and then
edited by hand to pick up the bits that coccinelle didn't catch.

@@
@@
-struct of_device
+struct platform_device

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

This patch is *huge*, so rather than posting it and having lists barf at me, I've pushed it out to my git tree.  You can view the branch[1] and the diff[2].

[1] http://git.secretlab.ca/?p=linux-2.6.git;a=shortlog;h=refs/heads/devicetree/of-device-rename
[2] http://git.secretlab.ca/?p=linux-2.6.git;a=commitdiff;h=48465300aab074396bdbad54b4fa01c793e5c987;hp=7fb8f881c54beb05dd4d2c947dada1c636581d87

It is a very mechanical change, only replaces of_device references with platform_device.  I won't push it into linux-next right away because it's sure to cause a truckload of conflicts.  Instead, I'll wait until the merge window settles down, spin it again with all the new driver changes, repost and ask Linus to pull.

If anyone has any problems with this plan, then please let me know.

Cheers,
g.

 drivers/ata/pata_mpc52xx.c                    |    8 ++---
 drivers/ata/pata_of_platform.c                |    4 +-
 drivers/ata/sata_fsl.c                        |    8 ++---
 drivers/atm/fore200e.c                        |   26 +++++++--------
 drivers/block/xsysace.c                       |    4 +-
 drivers/char/hw_random/n2-drv.c               |    4 +-
 drivers/char/hw_random/n2rng.h                |    2 +
 drivers/char/hw_random/pasemi-rng.c           |    4 +-
 drivers/char/ipmi/ipmi_si_intf.c              |    4 +-
 drivers/char/rtc.c                            |    2 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.c    |    4 +-
 drivers/crypto/amcc/crypto4xx_core.c          |    4 +-
 drivers/crypto/amcc/crypto4xx_core.h          |    2 +
 drivers/crypto/n2_core.c                      |   20 ++++++-----
 drivers/crypto/talitos.c                      |    6 ++-
 drivers/dma/fsldma.c                          |    4 +-
 drivers/dma/mpc512x_dma.c                     |    4 +-
 drivers/dma/ppc4xx/adma.c                     |    8 ++---
 drivers/edac/mpc85xx_edac.c                   |   12 +++----
 drivers/edac/ppc4xx_edac.c                    |   12 +++----
 drivers/hwmon/ams/ams.h                       |    2 +
 drivers/hwmon/ultra45_env.c                   |    4 +-
 drivers/i2c/busses/i2c-cpm.c                  |    8 ++---
 drivers/i2c/busses/i2c-ibm_iic.c              |    6 ++-
 drivers/i2c/busses/i2c-mpc.c                  |    4 +-
 drivers/infiniband/hw/ehca/ehca_classes.h     |    2 +
 drivers/infiniband/hw/ehca/ehca_main.c        |    4 +-
 drivers/input/misc/sparcspkr.c                |   10 +++---
 drivers/input/serio/i8042-sparcio.h           |    8 ++---
 drivers/input/serio/xilinx_ps2.c              |    4 +-
 drivers/leds/leds-gpio.c                      |    4 +-
 drivers/macintosh/macio_sysfs.c               |    6 ++-
 drivers/macintosh/smu.c                       |    6 ++-
 drivers/macintosh/therm_adt746x.c             |    2 +
 drivers/macintosh/therm_pm72.c                |    6 ++-
 drivers/macintosh/therm_windtunnel.c          |    6 ++-
 drivers/mmc/host/sdhci-of-core.c              |    8 ++---
 drivers/mtd/maps/physmap_of.c                 |    8 ++---
 drivers/mtd/maps/sun_uflash.c                 |    6 ++-
 drivers/mtd/nand/fsl_elbc_nand.c              |    4 +-
 drivers/mtd/nand/fsl_upm.c                    |    4 +-
 drivers/mtd/nand/mpc5121_nfc.c                |    4 +-
 drivers/mtd/nand/ndfc.c                       |    6 ++-
 drivers/mtd/nand/pasemi_nand.c                |    4 +-
 drivers/mtd/nand/socrates_nand.c              |    4 +-
 drivers/net/can/mscan/mpc5xxx_can.c           |   18 +++++-----
 drivers/net/can/sja1000/sja1000_of_platform.c |    4 +-
 drivers/net/ehea/ehea.h                       |    4 +-
 drivers/net/ehea/ehea_main.c                  |   12 +++----
 drivers/net/fec_mpc52xx.c                     |    8 ++---
 drivers/net/fec_mpc52xx_phy.c                 |    4 +-
 drivers/net/fs_enet/fs_enet-main.c            |    4 +-
 drivers/net/fs_enet/mac-fcc.c                 |    2 +
 drivers/net/fs_enet/mac-fec.c                 |    2 +
 drivers/net/fs_enet/mac-scc.c                 |    2 +
 drivers/net/fs_enet/mii-bitbang.c             |    4 +-
 drivers/net/fs_enet/mii-fec.c                 |    4 +-
 drivers/net/fsl_pq_mdio.c                     |    4 +-
 drivers/net/gianfar.c                         |   10 +++---
 drivers/net/gianfar.h                         |    2 +
 drivers/net/greth.c                           |    4 +-
 drivers/net/ibm_newemac/core.c                |    6 ++-
 drivers/net/ibm_newemac/core.h                |   12 +++----
 drivers/net/ibm_newemac/mal.c                 |    4 +-
 drivers/net/ibm_newemac/mal.h                 |    2 +
 drivers/net/ibm_newemac/rgmii.c               |   18 +++++-----
 drivers/net/ibm_newemac/rgmii.h               |   16 +++++----
 drivers/net/ibm_newemac/tah.c                 |   14 ++++----
 drivers/net/ibm_newemac/tah.h                 |   12 +++----
 drivers/net/ibm_newemac/zmii.c                |   18 +++++-----
 drivers/net/ibm_newemac/zmii.h                |   16 +++++----
 drivers/net/ll_temac_main.c                   |    8 ++---
 drivers/net/myri_sbus.c                       |    4 +-
 drivers/net/myri_sbus.h                       |    2 +
 drivers/net/niu.c                             |    8 ++---
 drivers/net/phy/mdio-gpio.c                   |    4 +-
 drivers/net/sunbmac.c                         |   18 +++++-----
 drivers/net/sunbmac.h                         |    4 +-
 drivers/net/sunhme.c                          |   22 ++++++-------
 drivers/net/sunlance.c                        |   20 ++++++-----
 drivers/net/sunqe.c                           |   16 +++++----
 drivers/net/sunqe.h                           |    4 +-
 drivers/net/ucc_geth.c                        |    8 ++---
 drivers/net/xilinx_emaclite.c                 |    6 ++-
 drivers/parport/parport_sunbpp.c              |    4 +-
 drivers/pcmcia/electra_cf.c                   |    6 ++-
 drivers/pcmcia/m8xx_pcmcia.c                  |    4 +-
 drivers/rtc/rtc-mpc5121.c                     |    4 +-
 drivers/sbus/char/bbc_envctrl.c               |    6 ++-
 drivers/sbus/char/bbc_i2c.c                   |   18 +++++-----
 drivers/sbus/char/bbc_i2c.h                   |   10 +++---
 drivers/sbus/char/display7seg.c               |    4 +-
 drivers/sbus/char/envctrl.c                   |    4 +-
 drivers/sbus/char/flash.c                     |    4 +-
 drivers/sbus/char/uctrl.c                     |    4 +-
 drivers/scsi/qlogicpti.c                      |   14 ++++----
 drivers/scsi/qlogicpti.h                      |    2 +
 drivers/scsi/sun_esp.c                        |   44 +++++++++++++------------
 drivers/serial/apbuart.c                      |    2 +
 drivers/serial/cpm_uart/cpm_uart_core.c       |    4 +-
 drivers/serial/mpc52xx_uart.c                 |    8 ++---
 drivers/serial/nwpserial.c                    |    2 +
 drivers/serial/of_serial.c                    |    6 ++-
 drivers/serial/sunhv.c                        |    4 +-
 drivers/serial/sunsab.c                       |    8 ++---
 drivers/serial/sunsu.c                        |    8 ++---
 drivers/serial/sunzilog.c                     |    6 ++-
 drivers/serial/uartlite.c                     |    4 +-
 drivers/serial/ucc_uart.c                     |    4 +-
 drivers/spi/mpc512x_psc_spi.c                 |    4 +-
 drivers/spi/mpc52xx_psc_spi.c                 |    4 +-
 drivers/spi/mpc52xx_spi.c                     |    4 +-
 drivers/spi/spi_mpc8xxx.c                     |    4 +-
 drivers/spi/spi_ppc4xx.c                      |    4 +-
 drivers/spi/xilinx_spi_of.c                   |    6 ++-
 drivers/usb/gadget/fsl_qe_udc.c               |   10 +++---
 drivers/usb/host/ehci-ppc-of.c                |    6 ++-
 drivers/usb/host/ehci-xilinx-of.c             |    6 ++-
 drivers/usb/host/fhci-hcd.c                   |    4 +-
 drivers/usb/host/isp1760-if.c                 |    4 +-
 drivers/usb/host/ohci-ppc-of.c                |    6 ++-
 drivers/video/bw2.c                           |    4 +-
 drivers/video/cg14.c                          |    6 ++-
 drivers/video/cg3.c                           |    4 +-
 drivers/video/cg6.c                           |    6 ++-
 drivers/video/ffb.c                           |    4 +-
 drivers/video/fsl-diu-fb.c                    |    8 ++---
 drivers/video/leo.c                           |    6 ++-
 drivers/video/mb862xx/mb862xxfb.c             |    4 +-
 drivers/video/p9100.c                         |    4 +-
 drivers/video/platinumfb.c                    |    4 +-
 drivers/video/sunxvr1000.c                    |    4 +-
 drivers/video/tcx.c                           |    6 ++-
 drivers/video/xilinxfb.c                      |    4 +-
 drivers/watchdog/cpwd.c                       |    4 +-
 drivers/watchdog/gef_wdt.c                    |    2 +
 drivers/watchdog/mpc8xxx_wdt.c                |    4 +-
 drivers/watchdog/riowd.c                      |    4 +-
 include/linux/of_device.h                     |    3 --
 sound/aoa/soundbus/core.c                     |    2 +
 sound/aoa/soundbus/soundbus.h                 |    2 +
 sound/aoa/soundbus/sysfs.c                    |    2 +
 sound/soc/fsl/mpc5200_dma.c                   |    4 +-
 sound/soc/fsl/mpc5200_dma.h                   |    4 +-
 sound/soc/fsl/mpc5200_psc_ac97.c              |    4 +-
 sound/soc/fsl/mpc5200_psc_i2s.c               |    4 +-
 sound/soc/fsl/mpc8610_hpcd.c                  |    4 +-
 sound/sparc/amd7930.c                         |    8 ++---
 sound/sparc/cs4231.c                          |   18 +++++-----
 sound/sparc/dbri.c                            |    8 ++---
 150 files changed, 493 insertions(+), 496 deletions(-)

