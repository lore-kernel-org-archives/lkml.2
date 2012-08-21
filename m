Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2HUPMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:12:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2HUPL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:11:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 3/4] ARM: treewide: scripted conversion to mach-*/*.h
Date: Tue, 21 Aug 2012 17:11:19 +0200
Message-Id: <1345561880-13231-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1345561880-13231-1-git-send-email-arnd@arndb.de>
References: <1345561880-13231-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:AW0qm5SA42UGVbi0nA1rkSF8LzzCvZwZEBnGJRlch0n
 6dzc33eNwlsCv+8L2jATk1ZnUUDRQ3R226/MxIKQp73H2EokzP
 td8uuAwXxHkyRLiIiazMhBU7gkQ8rkmMPNj2lhTkylgBcX6YWd
 9jx14a9lofhXs7W+cnuMtsmIkJ/kOrbibznsjNK+OQZeK09md9
 EKnt05xr8L00e4Na4sKamM+SxdcwKDJi2hal7iR/asJLZheOyu
 PcOg0IPP67GEIg1qxTIUBpfunMjrAc0h6bRoqW8eJl+SPTAhxO
 4XQMfCk6Cvkx2I5N/9NZ+UyxPU9DrTFQ0kqMGFkUx3b9RdeSfn
 w2hw1NCMa0SlgaIK7o6B+bA8iWU1tPam774PJY9JeICAvcz/93
 qegxbyWpMZJXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While converting all machine specific headers from
automatically detect the right machine and platform
name in most cases. This script uses a number of
information sources for this:

* any arch/arm/mach-*/ directory uses its own headers,
  with a few exceptions, same for plat-*/
* each mach-*/ directory belongs to at most one plat-*
  directory holding header files
* for any header below mach/* that exists in only one
  machine, we know that the users belong to that machine
* some driver directories or files are manually listed
  here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
===========================================================

fixup()
{
 echo fixup "$1 $2 $3"
 git ls-files $1 | xargs sed -i "s:^\(#.*include <\)$2/:\1$3/:g"
}

fixup arch/arm/mach-s3c2410 mach mach-s3c24xx
fixup arch/arm/mach-s3c2412 mach mach-s3c24xx
fixup arch/arm/mach-s3c2440 mach mach-s3c24xx

fixup arch/arm/plat-mxc mach mach-imx
fixup arch/arm/plat-s3c24xx mach mach-s3c24xx
fixup arch/arm/plat-s3c24xx plat plat-samsung

for i in arch/arm/mach-*; do
	fixup "$i" mach "${i##*/}"
done

for i in arch/arm/plat-* ; do
	fixup "$i" plat "${i##*/}"
done

fixup arch/arm/mach-spear3xx plat plat-spear
fixup arch/arm/mach-spear6xx plat plat-spear
fixup arch/arm/mach-spear13xx plat plat-spear
fixup arch/arm/mach-pxa plat plat-pxa
fixup arch/arm/mach-mmp plat plat-pxa
fixup arch/arm/mach-orion5x plat plat-orion
fixup arch/arm/mach-kirkwood plat plat-orion
fixup arch/arm/mach-mv78xx0 plat plat-orion
fixup arch/arm/mach-dove plat plat-orion
fixup arch/arm/mach-nomadik plat plat-nomadik
fixup arch/arm/mach-ux500 plat plat-nomadik
fixup arch/arm/mach-s3c2410 plat plat-samsung
fixup arch/arm/mach-s3c2412 plat plat-samsung
fixup arch/arm/mach-s3c2440 plat plat-samsung
fixup arch/arm/mach-s3c24xx plat plat-samsung
fixup arch/arm/mach-s3c64xx plat plat-samsung
fixup arch/arm/mach-s5p64x0 plat plat-samsung
fixup arch/arm/mach-s5pc100 plat plat-samsung
fixup arch/arm/mach-s5pv210 plat plat-samsung
fixup arch/arm/mach-exynos plat plat-samsung
fixup arch/arm/mach-omap1 plat plat-omap
fixup arch/arm/mach-omap2 plat plat-omap
fixup arch/arm/mach-versatile plat plat-versatile
fixup arch/arm/mach-integrator plat plat-versatile
fixup arch/arm/mach-realview plat plat-versatile
fixup arch/arm/mach-vexpress plat plat-versatile
fixup arch/arm/mach-zynq plat plat-versatile

fixup drivers/video/omap plat plat-omap
fixup drivers/video/omap2 plat plat-omap
fixup drivers/video/exynos plat plat-samsung
fixup drivers/char/hw_random/omap\* plat plat-omap
fixup drivers/cpufreq/omap\* plat plat-omap
fixup drivers/crypto/omap\* plat plat-omap
fixup drivers/media/video/omap\* plat plat-omap
fixup drivers/input/keyboard/omap\* plat plat-omap
fixup drivers/mmc/host/omap\* plat plat-omap
fixup drivers/mtd/*nand/omap\* plat plat-omap
fixup drivers/spi/spi-omap\* plat plat-omap
fixup drivers/tty/serial/omap\* plat plat-omap
fixup drivers/usb/gadget/omap\* plat plat-omap
fixup drivers/usb/musb/*omap\* plat plat-omap
fixup drivers/dma/omap-dma.c plat plat-omap
fixup drivers/staging/omapdrm plat plat-omap
fixup drivers/staging/tidspbridge/ plat plat-omap
fixup drivers/input/keyboard/spear-keyboard.c plat plat-spear
fixup drivers/cpufreq/exynos-cpufreq.c plat plat-samsung
fixup drivers/crypto/s5p-sss.c plat plat-samsung
fixup drivers/i2c/busses/i2c-nomadik.c plat plat-nomadik
fixup drivers/mtd/nand/s3c2410.c plat plat-samsung
fixup drivers/tty/serial/samsung.c plat plat-samsung
fixup drivers/usb/gadget/s3c-hsotg.c plat plat-samsung
fixup drivers/gpio/gpio-samsung.c plat plat-samsung
fixup sound/soc/samsung plat plat-samsung
fixup sound/soc/omap plat plat-omap
fixup sound/soc/pxa plat plat-pxa
fixup sound/soc/kirkwood/ plat plat-orion
fixup sound/soc/fsl/imx*.[ch] plat plat-mxc

fixup drivers/video/omap mach mach-omap1
fixup drivers/video/omap2 mach mach-omap2
fixup drivers/video/exynos mach mach-exynos
fixup drivers/media/video/davinci mach mach-davinci

fixup sound/soc/omap/osk5912.c mach mach-omap1
fixup sound/soc/omap mach mach-omap2
fixup sound/soc/pxa mach mach-pxa
fixup sound/soc/davinci mach mach-davinci
fixup sound/soc/ep93xx mach mach-ep93xx
fixup sound/soc/kirkwood/ mach mach-kirkwood
fixup sound/soc/fsl/imx*.[ch] mach mach-imx
fixup sound/soc/mxs mach mach-mxs
fixup sound/soc/tegra mach mach-tegra
fixup sound/soc/nuc900 mach mach-w90x900
fixup sound/arm/pxa\* mach mach-pxa
fixup sound/atmel/ac97c.c mach mach-at91
fixup sound/oss/waveartist.c mach mach-footbridge
fixup sound/oss/vidc\* mach mach-rpc
fixup sound/soc/atmel/ mach mach-at91
fixup sound/soc/ux500/ mach mach-ux500

fixup include/linux/spi/pxa2xx_spi.h mach mach-pxa
fixup include/linux/mfd/dbx500-prcmu.h mach mach-ux500

find_unique_mach()
{
  {
    # find files in other architectures using mach/*.h
    git ls-files | grep /mach/[^/]*.h | while read i ;
	do echo ${i##*/}
    done
    # find files we've already renamed in ARM
    for i in arch/arm/mach-*/include/mach-*/ ; do
	git ls-files "$i" | sed -e "s:^$i::g"
    done
  } | sort | uniq -c | grep -w 1  | cut -f 2- -d\1
}
rename_unique_mach()
{
  ALLFILES=`git grep -l "^#include.*<mach/"`
  ALLINCLUDES=`git grep "^#include.*<mach/" ${ALLFILES}`
  find_unique_mach | while read i ; do
    echo "$ALLINCLUDES" | if grep -q "#include.*<mach/$i>" &&
		[ -e arch/arm/mach-*/include/mach-*/"$i" ] ; then
       MACH=`ls arch/arm/mach-*/include/mach-*/$i | cut -f 3 -d /`
       THESEFILES=`git grep -l "^#include.*<mach/$i>" ${ALLFILES}`
       echo mach/$i
       for j in ${THESEFILES} ; do
	  fixup $j mach ${MACH}
       done
    fi
  done
}

find_unique_plat()
{
  {
    # all plat/*.h files are already renamed
    for i in arch/arm/plat-*/include/plat-*/ ; do
	git ls-files "$i" | sed -e "s:^$i::g"
    done
  } | sort | uniq -c | grep -w 1  | cut -f 2- -d\1
}
rename_unique_plat()
{
  ALLFILES=`git grep -l "#include.*<plat/"`
  if [ "" != "${ALLFILES}" ] ; then
    find_unique_plat | while read i ; do
      PLAT=`ls arch/arm/plat-*/include/plat-*/$i | cut -f 3 -d /`
      THESEFILES=`git grep -l "^#include.*<plat/$i>" ${ALLFILES}`
      echo plat/$i
       for j in ${THESEFILES} ; do
          fixup $j plat ${PLAT}
       done
    done
  fi
}

rename_unique_mach
rename_unique_plat# Please enter the commit message for your changes. Lines starting
---
 Documentation/spi/ep93xx_spi                       |    2 +-
 arch/arm/boot/compressed/head-shmobile.S           |    2 +-
 arch/arm/boot/compressed/sdhi-shmobile.c           |    2 +-
 arch/arm/mach-at91/at91rm9200.c                    |   10 ++--
 arch/arm/mach-at91/at91rm9200_devices.c            |    8 ++--
 arch/arm/mach-at91/at91rm9200_time.c               |    2 +-
 arch/arm/mach-at91/at91sam9260.c                   |   12 ++---
 arch/arm/mach-at91/at91sam9260_devices.c           |   14 +++---
 arch/arm/mach-at91/at91sam9261.c                   |   10 ++--
 arch/arm/mach-at91/at91sam9261_devices.c           |   10 ++--
 arch/arm/mach-at91/at91sam9263.c                   |    8 ++--
 arch/arm/mach-at91/at91sam9263_devices.c           |   10 ++--
 arch/arm/mach-at91/at91sam926x_time.c              |    2 +-
 arch/arm/mach-at91/at91sam9_alt_reset.S            |    6 +--
 arch/arm/mach-at91/at91sam9g45.c                   |    8 ++--
 arch/arm/mach-at91/at91sam9g45_devices.c           |   16 +++----
 arch/arm/mach-at91/at91sam9g45_reset.S             |    6 +--
 arch/arm/mach-at91/at91sam9n12.c                   |    8 ++--
 arch/arm/mach-at91/at91sam9rl.c                    |   12 ++---
 arch/arm/mach-at91/at91sam9rl_devices.c            |   12 ++---
 arch/arm/mach-at91/at91sam9x5.c                    |    8 ++--
 arch/arm/mach-at91/at91x40.c                       |    8 ++--
 arch/arm/mach-at91/at91x40_time.c                  |    4 +-
 arch/arm/mach-at91/board-1arm.c                    |    8 ++--
 arch/arm/mach-at91/board-afeb-9260v1.c             |    6 +--
 arch/arm/mach-at91/board-cam60.c                   |    8 ++--
 arch/arm/mach-at91/board-carmeva.c                 |    6 +--
 arch/arm/mach-at91/board-cpu9krea.c                |   12 ++---
 arch/arm/mach-at91/board-cpuat91.c                 |   12 ++---
 arch/arm/mach-at91/board-csb337.c                  |    6 +--
 arch/arm/mach-at91/board-csb637.c                  |    6 +--
 arch/arm/mach-at91/board-dt.c                      |    4 +-
 arch/arm/mach-at91/board-eb01.c                    |    6 +--
 arch/arm/mach-at91/board-eb9200.c                  |    6 +--
 arch/arm/mach-at91/board-ecbat91.c                 |    8 ++--
 arch/arm/mach-at91/board-eco920.c                  |   10 ++--
 arch/arm/mach-at91/board-flexibity.c               |    6 +--
 arch/arm/mach-at91/board-foxg20.c                  |    8 ++--
 arch/arm/mach-at91/board-gsia18s.c                 |   10 ++--
 arch/arm/mach-at91/board-kafa.c                    |    8 ++--
 arch/arm/mach-at91/board-kb9202.c                  |   12 ++---
 arch/arm/mach-at91/board-neocore926.c              |    8 ++--
 arch/arm/mach-at91/board-pcontrol-g20.c            |    8 ++--
 arch/arm/mach-at91/board-picotux200.c              |   10 ++--
 arch/arm/mach-at91/board-qil-a9260.c               |   10 ++--
 arch/arm/mach-at91/board-rm9200dk.c                |   10 ++--
 arch/arm/mach-at91/board-rm9200ek.c                |   10 ++--
 arch/arm/mach-at91/board-rsi-ews.c                 |    6 +--
 arch/arm/mach-at91/board-sam9-l9260.c              |    8 ++--
 arch/arm/mach-at91/board-sam9260ek.c               |   12 ++---
 arch/arm/mach-at91/board-sam9261ek.c               |   12 ++---
 arch/arm/mach-at91/board-sam9263ek.c               |   12 ++---
 arch/arm/mach-at91/board-sam9g20ek.c               |   10 ++--
 arch/arm/mach-at91/board-sam9m10g45ek.c            |   12 ++---
 arch/arm/mach-at91/board-sam9rlek.c                |   10 ++--
 arch/arm/mach-at91/board-snapper9260.c             |    8 ++--
 arch/arm/mach-at91/board-stamp9g20.c               |    6 +--
 arch/arm/mach-at91/board-usb-a926x.c               |   10 ++--
 arch/arm/mach-at91/board-yl-9200.c                 |   12 ++---
 arch/arm/mach-at91/clock.c                         |    6 +--
 arch/arm/mach-at91/cpuidle.c                       |    2 +-
 arch/arm/mach-at91/gpio.c                          |    4 +-
 arch/arm/mach-at91/include/mach-at91/at91_ramc.h   |    6 +--
 .../arm/mach-at91/include/mach-at91/at91sam9_smc.h |    2 +-
 arch/arm/mach-at91/include/mach-at91/atmel-mci.h   |    2 +-
 arch/arm/mach-at91/include/mach-at91/debug-macro.S |    4 +-
 arch/arm/mach-at91/include/mach-at91/hardware.h    |   18 ++++----
 arch/arm/mach-at91/include/mach-at91/memory.h      |    2 +-
 arch/arm/mach-at91/include/mach-at91/timex.h       |    2 +-
 arch/arm/mach-at91/include/mach-at91/uncompress.h  |    6 +--
 arch/arm/mach-at91/irq.c                           |    4 +-
 arch/arm/mach-at91/leds.c                          |    2 +-
 arch/arm/mach-at91/pm.c                            |   10 ++--
 arch/arm/mach-at91/pm.h                            |    4 +-
 arch/arm/mach-at91/pm_slowclock.S                  |    6 +--
 arch/arm/mach-at91/sam9_smc.c                      |    2 +-
 arch/arm/mach-at91/setup.c                         |   10 ++--
 arch/arm/mach-bcmring/arch.c                       |   10 ++--
 arch/arm/mach-bcmring/clock.c                      |    8 ++--
 arch/arm/mach-bcmring/clock.h                      |    2 +-
 arch/arm/mach-bcmring/core.c                       |   10 ++--
 arch/arm/mach-bcmring/csp/chipc/chipcHw.c          |    4 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c     |    4 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c    |    4 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c      |    2 +-
 arch/arm/mach-bcmring/csp/dmac/dmacHw.c            |    6 +--
 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c      |    4 +-
 arch/arm/mach-bcmring/csp/tmr/tmrHw.c              |    2 +-
 arch/arm/mach-bcmring/dma.c                        |    4 +-
 arch/arm/mach-bcmring/include/csp/dmacHw.h         |    2 +-
 arch/arm/mach-bcmring/include/csp/intcHw.h         |    2 +-
 arch/arm/mach-bcmring/include/csp/reg.h            |    2 +-
 .../include/mach-bcmring/csp/cap_inline.h          |    2 +-
 .../include/mach-bcmring/csp/chipcHw_def.h         |    2 +-
 .../include/mach-bcmring/csp/chipcHw_inline.h      |    4 +-
 .../include/mach-bcmring/csp/chipcHw_reg.h         |    4 +-
 .../include/mach-bcmring/csp/ddrcReg.h             |    2 +-
 .../include/mach-bcmring/csp/dmacHw_reg.h          |    2 +-
 .../mach-bcmring/include/mach-bcmring/csp/hw_cfg.h |    4 +-
 .../include/mach-bcmring/csp/intcHw_reg.h          |    2 +-
 .../mach-bcmring/include/mach-bcmring/csp/mm_io.h  |    2 +-
 .../include/mach-bcmring/csp/secHw_def.h           |    4 +-
 .../include/mach-bcmring/csp/tmrHw_reg.h           |    4 +-
 arch/arm/mach-bcmring/include/mach-bcmring/dma.h   |    2 +-
 .../include/mach-bcmring/entry-macro.S             |    6 +--
 .../mach-bcmring/include/mach-bcmring/hardware.h   |    2 +-
 .../mach-bcmring/include/mach-bcmring/reg_nand.h   |    2 +-
 .../mach-bcmring/include/mach-bcmring/reg_umi.h    |    2 +-
 .../mach-bcmring/include/mach-bcmring/uncompress.h |    2 +-
 arch/arm/mach-bcmring/irq.c                        |    6 +--
 arch/arm/mach-bcmring/mm.c                         |    4 +-
 arch/arm/mach-bcmring/timer.c                      |    2 +-
 arch/arm/mach-clps711x/autcpu12.c                  |    4 +-
 arch/arm/mach-clps711x/cdb89712.c                  |    2 +-
 arch/arm/mach-clps711x/ceiva.c                     |    2 +-
 arch/arm/mach-clps711x/common.c                    |    2 +-
 arch/arm/mach-clps711x/edb7211-mm.c                |    2 +-
 arch/arm/mach-clps711x/fortunet.c                  |    2 +-
 .../include/mach-clps711x/debug-macro.S            |    2 +-
 .../include/mach-clps711x/entry-macro.S            |    2 +-
 .../mach-clps711x/include/mach-clps711x/hardware.h |    2 +-
 .../include/mach-clps711x/uncompress.h             |    2 +-
 arch/arm/mach-clps711x/p720t-leds.c                |    2 +-
 arch/arm/mach-clps711x/p720t.c                     |    4 +-
 arch/arm/mach-cns3xxx/cns3420vb.c                  |    4 +-
 arch/arm/mach-cns3xxx/core.c                       |    2 +-
 arch/arm/mach-cns3xxx/devices.c                    |    6 +--
 arch/arm/mach-cns3xxx/include/mach-cns3xxx/irqs.h  |    2 +-
 .../mach-cns3xxx/include/mach-cns3xxx/uncompress.h |    2 +-
 arch/arm/mach-cns3xxx/pcie.c                       |    2 +-
 arch/arm/mach-cns3xxx/pm.c                         |    4 +-
 arch/arm/mach-davinci/aemif.c                      |    2 +-
 arch/arm/mach-davinci/board-da830-evm.c            |   14 +++---
 arch/arm/mach-davinci/board-da850-evm.c            |   12 ++---
 arch/arm/mach-davinci/board-dm355-evm.c            |   10 ++--
 arch/arm/mach-davinci/board-dm355-leopard.c        |   10 ++--
 arch/arm/mach-davinci/board-dm365-evm.c            |   14 +++---
 arch/arm/mach-davinci/board-dm644x-evm.c           |   16 +++----
 arch/arm/mach-davinci/board-dm646x-evm.c           |   14 +++---
 arch/arm/mach-davinci/board-mityomapl138.c         |   12 ++---
 arch/arm/mach-davinci/board-neuros-osd2.c          |   14 +++---
 arch/arm/mach-davinci/board-omapl138-hawk.c        |    6 +--
 arch/arm/mach-davinci/board-sffsdr.c               |   10 ++--
 arch/arm/mach-davinci/board-tnetv107x-evm.c        |   10 ++--
 arch/arm/mach-davinci/cdce949.c                    |    4 +-
 arch/arm/mach-davinci/clock.c                      |    8 ++--
 arch/arm/mach-davinci/common.c                     |    4 +-
 arch/arm/mach-davinci/cp_intc.c                    |    4 +-
 arch/arm/mach-davinci/cpufreq.c                    |    6 +--
 arch/arm/mach-davinci/cpuidle.c                    |    4 +-
 arch/arm/mach-davinci/da830.c                      |   14 +++---
 arch/arm/mach-davinci/da850.c                      |   18 ++++----
 arch/arm/mach-davinci/davinci.h                    |    6 +--
 arch/arm/mach-davinci/devices-da8xx.c              |   10 ++--
 arch/arm/mach-davinci/devices-tnetv107x.c          |    8 ++--
 arch/arm/mach-davinci/devices.c                    |   16 +++----
 arch/arm/mach-davinci/dm355.c                      |   22 ++++-----
 arch/arm/mach-davinci/dm365.c                      |   24 +++++-----
 arch/arm/mach-davinci/dm644x.c                     |   20 ++++----
 arch/arm/mach-davinci/dm646x.c                     |   20 ++++----
 arch/arm/mach-davinci/dma.c                        |    2 +-
 arch/arm/mach-davinci/include/mach-davinci/asp.h   |    4 +-
 .../mach-davinci/include/mach-davinci/cdce949.h    |    2 +-
 .../mach-davinci/include/mach-davinci/cputype.h    |    2 +-
 arch/arm/mach-davinci/include/mach-davinci/da8xx.h |   16 +++----
 .../include/mach-davinci/debug-macro.S             |    2 +-
 .../include/mach-davinci/entry-macro.S             |    2 +-
 .../include/mach-davinci/gpio-davinci.h            |    4 +-
 .../arm/mach-davinci/include/mach-davinci/serial.h |    2 +-
 arch/arm/mach-davinci/include/mach-davinci/spi.h   |    2 +-
 .../mach-davinci/include/mach-davinci/tnetv107x.h  |    6 +--
 .../mach-davinci/include/mach-davinci/uncompress.h |    2 +-
 arch/arm/mach-davinci/irq.c                        |    6 +--
 arch/arm/mach-davinci/mux.c                        |    4 +-
 arch/arm/mach-davinci/mux.h                        |    2 +-
 arch/arm/mach-davinci/pm.c                         |    6 +--
 arch/arm/mach-davinci/psc.c                        |    4 +-
 arch/arm/mach-davinci/serial.c                     |    4 +-
 arch/arm/mach-davinci/sleep.S                      |    4 +-
 arch/arm/mach-davinci/sram.c                       |    4 +-
 arch/arm/mach-davinci/time.c                       |    6 +--
 arch/arm/mach-davinci/tnetv107x.c                  |   18 ++++----
 arch/arm/mach-davinci/usb.c                        |    8 ++--
 arch/arm/mach-dove/addr-map.c                      |    4 +-
 arch/arm/mach-dove/cm-a510.c                       |    2 +-
 arch/arm/mach-dove/common.c                        |   12 ++---
 arch/arm/mach-dove/dove-db-setup.c                 |    2 +-
 arch/arm/mach-dove/include/mach-dove/bridge-regs.h |    2 +-
 arch/arm/mach-dove/include/mach-dove/debug-macro.S |    2 +-
 arch/arm/mach-dove/include/mach-dove/entry-macro.S |    2 +-
 arch/arm/mach-dove/include/mach-dove/gpio.h        |    2 +-
 arch/arm/mach-dove/include/mach-dove/pm.h          |    2 +-
 arch/arm/mach-dove/include/mach-dove/uncompress.h  |    2 +-
 arch/arm/mach-dove/irq.c                           |    6 +--
 arch/arm/mach-dove/mpp.c                           |    4 +-
 arch/arm/mach-dove/pcie.c                          |    8 ++--
 arch/arm/mach-ebsa110/core.c                       |    2 +-
 arch/arm/mach-ebsa110/io.c                         |    2 +-
 arch/arm/mach-ebsa110/leds.c                       |    2 +-
 arch/arm/mach-ep93xx/adssphere.c                   |    2 +-
 arch/arm/mach-ep93xx/clock.c                       |    2 +-
 arch/arm/mach-ep93xx/core.c                        |   10 ++--
 arch/arm/mach-ep93xx/crunch-bits.S                 |    2 +-
 arch/arm/mach-ep93xx/dma.c                         |    4 +-
 arch/arm/mach-ep93xx/edb93xx.c                     |    8 ++--
 arch/arm/mach-ep93xx/gesbc9312.c                   |    2 +-
 .../mach-ep93xx/include/mach-ep93xx/debug-macro.S  |    2 +-
 .../mach-ep93xx/include/mach-ep93xx/gpio-ep93xx.h  |    2 +-
 .../arm/mach-ep93xx/include/mach-ep93xx/hardware.h |    2 +-
 .../mach-ep93xx/include/mach-ep93xx/uncompress.h   |    2 +-
 arch/arm/mach-ep93xx/micro9.c                      |    2 +-
 arch/arm/mach-ep93xx/simone.c                      |    6 +--
 arch/arm/mach-ep93xx/snappercl15.c                 |    6 +--
 arch/arm/mach-ep93xx/soc.h                         |    2 +-
 arch/arm/mach-ep93xx/ts72xx.c                      |    4 +-
 arch/arm/mach-ep93xx/vision_ep9307.c               |    8 ++--
 arch/arm/mach-exynos/clock-exynos4.c               |   22 ++++-----
 arch/arm/mach-exynos/clock-exynos4210.c            |   24 +++++-----
 arch/arm/mach-exynos/clock-exynos4212.c            |   24 +++++-----
 arch/arm/mach-exynos/clock-exynos5.c               |   22 ++++-----
 arch/arm/mach-exynos/common.c                      |   34 +++++++-------
 arch/arm/mach-exynos/cpuidle.c                     |    6 +--
 arch/arm/mach-exynos/dev-ahci.c                    |    8 ++--
 arch/arm/mach-exynos/dev-audio.c                   |   12 ++---
 arch/arm/mach-exynos/dev-drm.c                     |    2 +-
 arch/arm/mach-exynos/dev-dwmci.c                   |    4 +-
 arch/arm/mach-exynos/dev-ohci.c                    |   10 ++--
 arch/arm/mach-exynos/dev-sysmmu.c                  |    8 ++--
 arch/arm/mach-exynos/dev-uart.c                    |    6 +--
 arch/arm/mach-exynos/dma.c                         |   12 ++---
 arch/arm/mach-exynos/hotplug.c                     |    2 +-
 .../mach-exynos/include/mach-exynos/debug-macro.S  |    4 +-
 arch/arm/mach-exynos/include/mach-exynos/dma.h     |    2 +-
 arch/arm/mach-exynos/include/mach-exynos/irqs.h    |    2 +-
 arch/arm/mach-exynos/include/mach-exynos/map.h     |    4 +-
 arch/arm/mach-exynos/include/mach-exynos/pm-core.h |    2 +-
 .../mach-exynos/include/mach-exynos/regs-clock.h   |    6 +--
 .../mach-exynos/include/mach-exynos/regs-gpio.h    |    4 +-
 .../arm/mach-exynos/include/mach-exynos/regs-irq.h |    2 +-
 .../arm/mach-exynos/include/mach-exynos/regs-mct.h |    2 +-
 .../arm/mach-exynos/include/mach-exynos/regs-mem.h |    2 +-
 .../arm/mach-exynos/include/mach-exynos/regs-pmu.h |    2 +-
 .../mach-exynos/include/mach-exynos/uncompress.h   |    4 +-
 arch/arm/mach-exynos/mach-armlex4210.c             |   16 +++----
 arch/arm/mach-exynos/mach-exynos4-dt.c             |    6 +--
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    6 +--
 arch/arm/mach-exynos/mach-nuri.c                   |   34 +++++++-------
 arch/arm/mach-exynos/mach-origen.c                 |   30 ++++++------
 arch/arm/mach-exynos/mach-smdk4x12.c               |   28 ++++++------
 arch/arm/mach-exynos/mach-smdkv310.c               |   34 +++++++-------
 arch/arm/mach-exynos/mach-universal_c210.c         |   32 ++++++-------
 arch/arm/mach-exynos/mct.c                         |    8 ++--
 arch/arm/mach-exynos/platsmp.c                     |    8 ++--
 arch/arm/mach-exynos/pm.c                          |   22 ++++-----
 arch/arm/mach-exynos/pm_domains.c                  |    4 +-
 arch/arm/mach-exynos/pmu.c                         |    4 +-
 arch/arm/mach-exynos/setup-fimc.c                  |    4 +-
 arch/arm/mach-exynos/setup-fimd0.c                 |    6 +--
 arch/arm/mach-exynos/setup-i2c0.c                  |    6 +--
 arch/arm/mach-exynos/setup-i2c1.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c2.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c3.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c4.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c5.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c6.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c7.c                  |    4 +-
 arch/arm/mach-exynos/setup-keypad.c                |    2 +-
 arch/arm/mach-exynos/setup-sdhci-gpio.c            |    6 +--
 arch/arm/mach-exynos/setup-spi.c                   |    2 +-
 arch/arm/mach-exynos/setup-usb-phy.c               |    8 ++--
 arch/arm/mach-footbridge/ebsa285-leds.c            |    2 +-
 .../include/mach-footbridge/debug-macro.S          |    2 +-
 .../include/mach-footbridge/entry-macro.S          |    4 +-
 arch/arm/mach-footbridge/isa-irq.c                 |    2 +-
 arch/arm/mach-footbridge/netwinder-leds.c          |    2 +-
 arch/arm/mach-gemini/board-nas4220b.c              |    4 +-
 arch/arm/mach-gemini/devices.c                     |    6 +--
 arch/arm/mach-gemini/gpio.c                        |    4 +-
 .../mach-gemini/include/mach-gemini/debug-macro.S  |    2 +-
 .../mach-gemini/include/mach-gemini/entry-macro.S  |    2 +-
 arch/arm/mach-gemini/include/mach-gemini/gpio.h    |    2 +-
 arch/arm/mach-gemini/include/mach-gemini/system.h  |    4 +-
 .../mach-gemini/include/mach-gemini/uncompress.h   |    2 +-
 arch/arm/mach-gemini/irq.c                         |    2 +-
 arch/arm/mach-gemini/mm.c                          |    2 +-
 arch/arm/mach-gemini/time.c                        |    4 +-
 arch/arm/mach-h720x/common.c                       |    4 +-
 arch/arm/mach-h720x/cpu-h7201.c                    |    4 +-
 arch/arm/mach-h720x/cpu-h7202.c                    |    4 +-
 arch/arm/mach-h720x/h7201-eval.c                   |    2 +-
 arch/arm/mach-h720x/h7202-eval.c                   |    4 +-
 .../mach-h720x/include/mach-h720x/debug-macro.S    |    2 +-
 .../arm/mach-h720x/include/mach-h720x/uncompress.h |    2 +-
 arch/arm/mach-imx/clk-imx1.c                       |    4 +-
 arch/arm/mach-imx/clk-imx21.c                      |    4 +-
 arch/arm/mach-imx/clk-imx25.c                      |    6 +--
 arch/arm/mach-imx/clk-imx27.c                      |    4 +-
 arch/arm/mach-imx/clk-imx31.c                      |    6 +--
 arch/arm/mach-imx/clk-imx35.c                      |    4 +-
 arch/arm/mach-imx/clk-imx51-imx53.c                |    4 +-
 arch/arm/mach-imx/clk-imx6q.c                      |    2 +-
 arch/arm/mach-imx/clk-pllv1.c                      |    6 +--
 arch/arm/mach-imx/clk.h                            |    2 +-
 arch/arm/mach-imx/cpu-imx25.c                      |    4 +-
 arch/arm/mach-imx/cpu-imx27.c                      |    2 +-
 arch/arm/mach-imx/cpu-imx31.c                      |    6 +--
 arch/arm/mach-imx/cpu-imx35.c                      |    4 +-
 arch/arm/mach-imx/cpu-imx5.c                       |    2 +-
 arch/arm/mach-imx/cpu_op-mx51.c                    |    2 +-
 arch/arm/mach-imx/devices-imx1.h                   |    4 +-
 arch/arm/mach-imx/devices-imx21.h                  |    4 +-
 arch/arm/mach-imx/devices-imx25.h                  |    4 +-
 arch/arm/mach-imx/devices-imx27.h                  |    4 +-
 arch/arm/mach-imx/devices-imx31.h                  |    4 +-
 arch/arm/mach-imx/devices-imx35.h                  |    4 +-
 arch/arm/mach-imx/devices-imx50.h                  |    4 +-
 arch/arm/mach-imx/devices-imx51.h                  |    4 +-
 arch/arm/mach-imx/devices-imx53.h                  |    4 +-
 arch/arm/mach-imx/ehci-imx25.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx27.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx31.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx35.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx5.c                      |    4 +-
 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c       |    6 +--
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c     |    8 ++--
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c     |    6 +--
 arch/arm/mach-imx/eukrea_mbimxsd51-baseboard.c     |    6 +--
 arch/arm/mach-imx/hotplug.c                        |    2 +-
 arch/arm/mach-imx/imx27-dt.c                       |    4 +-
 arch/arm/mach-imx/imx31-dt.c                       |    4 +-
 arch/arm/mach-imx/imx51-dt.c                       |    4 +-
 arch/arm/mach-imx/imx53-dt.c                       |    4 +-
 arch/arm/mach-imx/include/mach-imx/debug-macro.S   |    2 +-
 .../arm/mach-imx/include/mach-imx/devices-common.h |   32 ++++++-------
 arch/arm/mach-imx/include/mach-imx/dma-mx1-mx2.h   |    2 +-
 arch/arm/mach-imx/include/mach-imx/hardware.h      |   26 +++++------
 arch/arm/mach-imx/include/mach-imx/iomux-mx1.h     |    2 +-
 arch/arm/mach-imx/include/mach-imx/iomux-mx21.h    |    4 +-
 arch/arm/mach-imx/include/mach-imx/iomux-mx25.h    |    2 +-
 arch/arm/mach-imx/include/mach-imx/iomux-mx27.h    |    4 +-
 arch/arm/mach-imx/include/mach-imx/iomux-mx35.h    |    2 +-
 arch/arm/mach-imx/include/mach-imx/iomux-mx50.h    |    2 +-
 arch/arm/mach-imx/include/mach-imx/iomux-mx51.h    |    2 +-
 arch/arm/mach-imx/include/mach-imx/iomux-mx53.h    |    2 +-
 arch/arm/mach-imx/iomux-imx31.c                    |    4 +-
 arch/arm/mach-imx/lluart.c                         |    2 +-
 arch/arm/mach-imx/mach-apf9328.c                   |    6 +--
 arch/arm/mach-imx/mach-armadillo5x0.c              |    8 ++--
 arch/arm/mach-imx/mach-bug.c                       |    6 +--
 arch/arm/mach-imx/mach-cpuimx27.c                  |   10 ++--
 arch/arm/mach-imx/mach-cpuimx35.c                  |    8 ++--
 arch/arm/mach-imx/mach-cpuimx51sd.c                |    8 ++--
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c           |   10 ++--
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |    6 +--
 arch/arm/mach-imx/mach-imx27ipcam.c                |    6 +--
 arch/arm/mach-imx/mach-imx27lite.c                 |    6 +--
 arch/arm/mach-imx/mach-imx6q.c                     |    6 +--
 arch/arm/mach-imx/mach-kzm_arm11_01.c              |    8 ++--
 arch/arm/mach-imx/mach-mx1ads.c                    |    6 +--
 arch/arm/mach-imx/mach-mx21ads.c                   |    6 +--
 arch/arm/mach-imx/mach-mx25_3ds.c                  |    8 ++--
 arch/arm/mach-imx/mach-mx27_3ds.c                  |   10 ++--
 arch/arm/mach-imx/mach-mx27ads.c                   |    6 +--
 arch/arm/mach-imx/mach-mx31_3ds.c                  |   10 ++--
 arch/arm/mach-imx/mach-mx31ads.c                   |    4 +-
 arch/arm/mach-imx/mach-mx31lilly.c                 |   10 ++--
 arch/arm/mach-imx/mach-mx31lite.c                  |   10 ++--
 arch/arm/mach-imx/mach-mx31moboard.c               |   12 ++---
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    8 ++--
 arch/arm/mach-imx/mach-mx50_rdp.c                  |    6 +--
 arch/arm/mach-imx/mach-mx51_3ds.c                  |    8 ++--
 arch/arm/mach-imx/mach-mx51_babbage.c              |    6 +--
 arch/arm/mach-imx/mach-mx51_efikamx.c              |    6 +--
 arch/arm/mach-imx/mach-mx51_efikasb.c              |    8 ++--
 arch/arm/mach-imx/mach-mx53_ard.c                  |    6 +--
 arch/arm/mach-imx/mach-mx53_evk.c                  |    6 +--
 arch/arm/mach-imx/mach-mx53_loco.c                 |    6 +--
 arch/arm/mach-imx/mach-mx53_smd.c                  |    6 +--
 arch/arm/mach-imx/mach-mxt_td60.c                  |    6 +--
 arch/arm/mach-imx/mach-pca100.c                    |    8 ++--
 arch/arm/mach-imx/mach-pcm037.c                    |    8 ++--
 arch/arm/mach-imx/mach-pcm037_eet.c                |    4 +-
 arch/arm/mach-imx/mach-pcm038.c                    |   10 ++--
 arch/arm/mach-imx/mach-pcm043.c                    |    8 ++--
 arch/arm/mach-imx/mach-qong.c                      |    6 +--
 arch/arm/mach-imx/mach-scb9328.c                   |    6 +--
 arch/arm/mach-imx/mach-vpr200.c                    |    6 +--
 arch/arm/mach-imx/mm-imx1.c                        |    6 +--
 arch/arm/mach-imx/mm-imx21.c                       |    8 ++--
 arch/arm/mach-imx/mm-imx25.c                       |   10 ++--
 arch/arm/mach-imx/mm-imx27.c                       |    8 ++--
 arch/arm/mach-imx/mm-imx3.c                        |    8 ++--
 arch/arm/mach-imx/mm-imx5.c                        |    8 ++--
 arch/arm/mach-imx/mx1-camera-fiq-ksym.c            |    2 +-
 arch/arm/mach-imx/mx31lilly-db.c                   |    8 ++--
 arch/arm/mach-imx/mx31lite-db.c                    |    8 ++--
 arch/arm/mach-imx/mx31moboard-devboard.c           |    8 ++--
 arch/arm/mach-imx/mx31moboard-marxbot.c            |    8 ++--
 arch/arm/mach-imx/mx31moboard-smartbot.c           |   10 ++--
 arch/arm/mach-imx/mx51_efika.c                     |    8 ++--
 arch/arm/mach-imx/pcm970-baseboard.c               |    6 +--
 arch/arm/mach-imx/platsmp.c                        |    4 +-
 arch/arm/mach-imx/pm-imx27.c                       |    2 +-
 arch/arm/mach-imx/pm-imx3.c                        |    6 +--
 arch/arm/mach-imx/pm-imx5.c                        |    6 +--
 arch/arm/mach-imx/pm-imx6q.c                       |    4 +-
 arch/arm/mach-integrator/core.c                    |    8 ++--
 arch/arm/mach-integrator/cpu.c                     |    4 +-
 arch/arm/mach-integrator/impd1.c                   |    4 +-
 arch/arm/mach-integrator/integrator_ap.c           |   10 ++--
 arch/arm/mach-integrator/integrator_cp.c           |   16 +++----
 arch/arm/mach-integrator/leds.c                    |    6 +--
 arch/arm/mach-integrator/lm.c                      |    2 +-
 arch/arm/mach-integrator/pci.c                     |    2 +-
 arch/arm/mach-integrator/pci_v3.c                  |    6 +--
 arch/arm/mach-iop13xx/include/mach-iop13xx/adma.h  |    2 +-
 .../arm/mach-iop13xx/include/mach-iop13xx/memory.h |    2 +-
 arch/arm/mach-iop13xx/include/mach-iop13xx/pci.h   |    2 +-
 .../mach-iop13xx/include/mach-iop13xx/uncompress.h |    2 +-
 arch/arm/mach-iop13xx/io.c                         |    2 +-
 arch/arm/mach-iop13xx/iq81340mc.c                  |    6 +--
 arch/arm/mach-iop13xx/iq81340sc.c                  |    6 +--
 arch/arm/mach-iop13xx/irq.c                        |    6 +--
 arch/arm/mach-iop13xx/pci.c                        |    4 +-
 arch/arm/mach-iop13xx/setup.c                      |    2 +-
 arch/arm/mach-iop32x/em7210.c                      |    4 +-
 arch/arm/mach-iop32x/glantank.c                    |    4 +-
 .../mach-iop32x/include/mach-iop32x/entry-macro.S  |    2 +-
 .../mach-iop32x/include/mach-iop32x/uncompress.h   |    2 +-
 arch/arm/mach-iop32x/iq31244.c                     |    4 +-
 arch/arm/mach-iop32x/iq80321.c                     |    4 +-
 arch/arm/mach-iop32x/irq.c                         |    2 +-
 arch/arm/mach-iop32x/n2100.c                       |    4 +-
 .../mach-iop33x/include/mach-iop33x/entry-macro.S  |    2 +-
 .../mach-iop33x/include/mach-iop33x/uncompress.h   |    2 +-
 arch/arm/mach-iop33x/iq80331.c                     |    4 +-
 arch/arm/mach-iop33x/iq80332.c                     |    4 +-
 arch/arm/mach-iop33x/irq.c                         |    2 +-
 arch/arm/mach-iop33x/uart.c                        |    2 +-
 arch/arm/mach-ixp4xx/avila-pci.c                   |    2 +-
 arch/arm/mach-ixp4xx/avila-setup.c                 |    2 +-
 arch/arm/mach-ixp4xx/common-pci.c                  |    2 +-
 arch/arm/mach-ixp4xx/common.c                      |    6 +--
 arch/arm/mach-ixp4xx/coyote-pci.c                  |    2 +-
 arch/arm/mach-ixp4xx/coyote-setup.c                |    2 +-
 arch/arm/mach-ixp4xx/gateway7001-pci.c             |    2 +-
 arch/arm/mach-ixp4xx/gateway7001-setup.c           |    2 +-
 arch/arm/mach-ixp4xx/gtwx5715-pci.c                |    2 +-
 arch/arm/mach-ixp4xx/gtwx5715-setup.c              |    2 +-
 .../mach-ixp4xx/include/mach-ixp4xx/entry-macro.S  |    2 +-
 .../arm/mach-ixp4xx/include/mach-ixp4xx/hardware.h |    2 +-
 arch/arm/mach-ixp4xx/include/mach-ixp4xx/io.h      |    2 +-
 .../arm/mach-ixp4xx/include/mach-ixp4xx/platform.h |    2 +-
 arch/arm/mach-ixp4xx/include/mach-ixp4xx/timex.h   |    2 +-
 arch/arm/mach-ixp4xx/ixdp425-pci.c                 |    2 +-
 arch/arm/mach-ixp4xx/ixdp425-setup.c               |    2 +-
 arch/arm/mach-ixp4xx/ixdpg425-pci.c                |    2 +-
 arch/arm/mach-ixp4xx/ixp4xx_npe.c                  |    2 +-
 arch/arm/mach-ixp4xx/ixp4xx_qmgr.c                 |    2 +-
 arch/arm/mach-ixp4xx/miccpt-pci.c                  |    2 +-
 arch/arm/mach-ixp4xx/wg302v2-pci.c                 |    2 +-
 arch/arm/mach-ixp4xx/wg302v2-setup.c               |    2 +-
 arch/arm/mach-kirkwood/addr-map.c                  |    4 +-
 arch/arm/mach-kirkwood/board-dnskw.c               |    4 +-
 arch/arm/mach-kirkwood/board-dreamplug.c           |    6 +--
 arch/arm/mach-kirkwood/board-dt.c                  |    4 +-
 arch/arm/mach-kirkwood/board-goflexnet.c           |    6 +--
 arch/arm/mach-kirkwood/board-ib62x0.c              |    2 +-
 arch/arm/mach-kirkwood/board-iconnect.c            |    2 +-
 arch/arm/mach-kirkwood/board-lsxl.c                |    2 +-
 arch/arm/mach-kirkwood/board-ts219.c               |    2 +-
 arch/arm/mach-kirkwood/common.c                    |   22 ++++-----
 arch/arm/mach-kirkwood/cpuidle.c                   |    2 +-
 arch/arm/mach-kirkwood/d2net_v2-setup.c            |    4 +-
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c        |    4 +-
 arch/arm/mach-kirkwood/dockstar-setup.c            |    4 +-
 arch/arm/mach-kirkwood/guruplug-setup.c            |    4 +-
 .../include/mach-kirkwood/bridge-regs.h            |    2 +-
 .../include/mach-kirkwood/debug-macro.S            |    2 +-
 .../include/mach-kirkwood/entry-macro.S            |    2 +-
 .../arm/mach-kirkwood/include/mach-kirkwood/gpio.h |    2 +-
 .../include/mach-kirkwood/uncompress.h             |    2 +-
 arch/arm/mach-kirkwood/irq.c                       |    4 +-
 arch/arm/mach-kirkwood/lacie_v2-common.c           |    6 +--
 arch/arm/mach-kirkwood/mpp.c                       |    4 +-
 arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c     |    2 +-
 arch/arm/mach-kirkwood/netspace_v2-setup.c         |    4 +-
 arch/arm/mach-kirkwood/netxbig_v2-setup.c          |    4 +-
 arch/arm/mach-kirkwood/openrd-setup.c              |    4 +-
 arch/arm/mach-kirkwood/pcie.c                      |    6 +--
 arch/arm/mach-kirkwood/rd88f6192-nas-setup.c       |    2 +-
 arch/arm/mach-kirkwood/rd88f6281-setup.c           |    4 +-
 arch/arm/mach-kirkwood/sheevaplug-setup.c          |    4 +-
 arch/arm/mach-kirkwood/t5325-setup.c               |    2 +-
 arch/arm/mach-kirkwood/ts219-setup.c               |    2 +-
 arch/arm/mach-kirkwood/ts41x-setup.c               |    4 +-
 arch/arm/mach-kirkwood/tsx1x-common.c              |    2 +-
 arch/arm/mach-ks8695/board-acs5k.c                 |    4 +-
 arch/arm/mach-ks8695/board-dsm320.c                |    4 +-
 arch/arm/mach-ks8695/board-micrel.c                |    4 +-
 arch/arm/mach-ks8695/cpu.c                         |    6 +--
 arch/arm/mach-ks8695/devices.c                     |   12 ++---
 .../mach-ks8695/include/mach-ks8695/debug-macro.S  |    4 +-
 .../mach-ks8695/include/mach-ks8695/entry-macro.S  |    4 +-
 arch/arm/mach-ks8695/include/mach-ks8695/memory.h  |    2 +-
 arch/arm/mach-ks8695/include/mach-ks8695/timex.h   |    2 +-
 .../mach-ks8695/include/mach-ks8695/uncompress.h   |    2 +-
 arch/arm/mach-ks8695/irq.c                         |    6 +--
 arch/arm/mach-ks8695/leds.c                        |    2 +-
 arch/arm/mach-ks8695/pci.c                         |    6 +--
 arch/arm/mach-ks8695/time.c                        |    4 +-
 arch/arm/mach-lpc32xx/clock.c                      |    4 +-
 arch/arm/mach-lpc32xx/common.c                     |    4 +-
 arch/arm/mach-lpc32xx/common.h                     |    2 +-
 .../include/mach-lpc32xx/entry-macro.S             |    4 +-
 .../mach-lpc32xx/include/mach-lpc32xx/uncompress.h |    4 +-
 arch/arm/mach-lpc32xx/irq.c                        |    6 +--
 arch/arm/mach-lpc32xx/phy3250.c                    |    8 ++--
 arch/arm/mach-lpc32xx/pm.c                         |    4 +-
 arch/arm/mach-lpc32xx/serial.c                     |    4 +-
 arch/arm/mach-lpc32xx/suspend.S                    |    4 +-
 arch/arm/mach-lpc32xx/timer.c                      |    4 +-
 arch/arm/mach-mmp/aspenite.c                       |   10 ++--
 arch/arm/mach-mmp/avengers_lite.c                  |    8 ++--
 arch/arm/mach-mmp/brownstone.c                     |    8 ++--
 arch/arm/mach-mmp/clock.c                          |    2 +-
 arch/arm/mach-mmp/common.c                         |    4 +-
 arch/arm/mach-mmp/devices.c                        |    8 ++--
 arch/arm/mach-mmp/flint.c                          |    8 ++--
 arch/arm/mach-mmp/gplugd.c                         |    6 +--
 arch/arm/mach-mmp/include/mach-mmp/debug-macro.S   |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/dma.h           |    4 +-
 arch/arm/mach-mmp/include/mach-mmp/entry-macro.S   |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/gpio.h          |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/mfp-mmp2.h      |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/mfp-pxa168.h    |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/mfp-pxa910.h    |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/mfp.h           |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/mmp2.h          |    4 +-
 arch/arm/mach-mmp/include/mach-mmp/pm-mmp2.h       |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/pxa168.h        |    8 ++--
 arch/arm/mach-mmp/include/mach-mmp/pxa910.h        |    4 +-
 arch/arm/mach-mmp/include/mach-mmp/regs-apbc.h     |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/regs-apmu.h     |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/regs-icu.h      |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/regs-rtc.h      |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/regs-smc.h      |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/regs-timers.h   |    2 +-
 arch/arm/mach-mmp/include/mach-mmp/uncompress.h    |    2 +-
 arch/arm/mach-mmp/irq.c                            |    6 +--
 arch/arm/mach-mmp/jasper.c                         |    8 ++--
 arch/arm/mach-mmp/mmp-dt.c                         |    2 +-
 arch/arm/mach-mmp/mmp2-dt.c                        |    4 +-
 arch/arm/mach-mmp/mmp2.c                           |   18 ++++----
 arch/arm/mach-mmp/pm-mmp2.c                        |   12 ++---
 arch/arm/mach-mmp/pm-pxa910.c                      |   12 ++---
 arch/arm/mach-mmp/pxa168.c                         |   20 ++++----
 arch/arm/mach-mmp/pxa910.c                         |   16 +++----
 arch/arm/mach-mmp/sram.c                           |    2 +-
 arch/arm/mach-mmp/tavorevb.c                       |    8 ++--
 arch/arm/mach-mmp/teton_bga.c                      |   12 ++---
 arch/arm/mach-mmp/time.c                           |   10 ++--
 arch/arm/mach-mmp/ttc_dkb.c                        |   10 ++--
 arch/arm/mach-msm/acpuclock-arm11.c                |    4 +-
 arch/arm/mach-msm/board-halibut.c                  |    8 ++--
 arch/arm/mach-msm/board-mahimahi.c                 |    6 +--
 arch/arm/mach-msm/board-msm7x27.c                  |   10 ++--
 arch/arm/mach-msm/board-msm7x30.c                  |    8 ++--
 arch/arm/mach-msm/board-msm8960.c                  |    4 +-
 arch/arm/mach-msm/board-msm8x60.c                  |    4 +-
 arch/arm/mach-msm/board-qsd8x50.c                  |   10 ++--
 arch/arm/mach-msm/board-sapphire.c                 |    8 ++--
 arch/arm/mach-msm/board-trout-mmc.c                |    4 +-
 arch/arm/mach-msm/board-trout-panel.c              |    4 +-
 arch/arm/mach-msm/board-trout.c                    |    6 +--
 arch/arm/mach-msm/board-trout.h                    |    4 +-
 arch/arm/mach-msm/clock-pcom.c                     |    2 +-
 arch/arm/mach-msm/clock.h                          |    2 +-
 arch/arm/mach-msm/devices-iommu.c                  |    4 +-
 arch/arm/mach-msm/devices-msm7x00.c                |    6 +--
 arch/arm/mach-msm/devices-msm7x30.c                |   10 ++--
 arch/arm/mach-msm/devices-msm8960.c                |    4 +-
 arch/arm/mach-msm/devices-qsd8x50.c                |   10 ++--
 arch/arm/mach-msm/dma.c                            |    2 +-
 arch/arm/mach-msm/gpiomux-v2.c                     |    2 +-
 arch/arm/mach-msm/gpiomux.h                        |    2 +-
 arch/arm/mach-msm/include/mach-msm/board.h         |    2 +-
 arch/arm/mach-msm/include/mach-msm/debug-macro.S   |    4 +-
 arch/arm/mach-msm/include/mach-msm/dma.h           |    2 +-
 arch/arm/mach-msm/include/mach-msm/entry-macro.S   |    2 +-
 arch/arm/mach-msm/include/mach-msm/sirc.h          |    2 +-
 arch/arm/mach-msm/include/mach-msm/uncompress.h    |    2 +-
 arch/arm/mach-msm/io.c                             |    6 +--
 arch/arm/mach-msm/irq-vic.c                        |    4 +-
 arch/arm/mach-msm/irq.c                            |    4 +-
 arch/arm/mach-msm/platsmp.c                        |    2 +-
 arch/arm/mach-msm/proc_comm.c                      |    4 +-
 arch/arm/mach-msm/smd.c                            |    4 +-
 arch/arm/mach-msm/smd_debug.c                      |    2 +-
 arch/arm/mach-msm/smd_private.h                    |    2 +-
 arch/arm/mach-msm/timer.c                          |    6 +--
 arch/arm/mach-msm/vreg.c                           |    2 +-
 arch/arm/mach-mv78xx0/addr-map.c                   |    2 +-
 arch/arm/mach-mv78xx0/buffalo-wxl-setup.c          |    2 +-
 arch/arm/mach-mv78xx0/common.c                     |   16 +++----
 arch/arm/mach-mv78xx0/db78x00-bp-setup.c           |    2 +-
 .../include/mach-mv78xx0/bridge-regs.h             |    2 +-
 .../include/mach-mv78xx0/debug-macro.S             |    2 +-
 .../include/mach-mv78xx0/entry-macro.S             |    2 +-
 arch/arm/mach-mv78xx0/include/mach-mv78xx0/gpio.h  |    2 +-
 .../mach-mv78xx0/include/mach-mv78xx0/uncompress.h |    2 +-
 arch/arm/mach-mv78xx0/irq.c                        |    4 +-
 arch/arm/mach-mv78xx0/mpp.c                        |    4 +-
 arch/arm/mach-mv78xx0/pcie.c                       |    4 +-
 arch/arm/mach-mv78xx0/rd78x00-masa-setup.c         |    2 +-
 arch/arm/mach-mvebu/armada-370-xp.c                |    2 +-
 .../mach-mvebu/include/mach-mvebu/debug-macro.S    |    2 +-
 .../arm/mach-mvebu/include/mach-mvebu/uncompress.h |    2 +-
 arch/arm/mach-mxs/devices-mx23.h                   |    4 +-
 arch/arm/mach-mxs/devices-mx28.h                   |    4 +-
 arch/arm/mach-mxs/devices/platform-auart.c         |    6 +--
 arch/arm/mach-mxs/devices/platform-dma.c           |    6 +--
 arch/arm/mach-mxs/devices/platform-fec.c           |    4 +-
 arch/arm/mach-mxs/devices/platform-flexcan.c       |    4 +-
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c      |    6 +--
 arch/arm/mach-mxs/devices/platform-gpmi-nand.c     |    6 +--
 arch/arm/mach-mxs/devices/platform-mxs-i2c.c       |    4 +-
 arch/arm/mach-mxs/devices/platform-mxs-mmc.c       |    6 +--
 arch/arm/mach-mxs/devices/platform-mxs-pwm.c       |    2 +-
 arch/arm/mach-mxs/devices/platform-mxs-saif.c      |    6 +--
 arch/arm/mach-mxs/devices/platform-mxsfb.c         |    6 +--
 arch/arm/mach-mxs/devices/platform-rtc-stmp3xxx.c  |    6 +--
 arch/arm/mach-mxs/icoll.c                          |    4 +-
 arch/arm/mach-mxs/include/mach-mxs/debug-macro.S   |    4 +-
 arch/arm/mach-mxs/include/mach-mxs/entry-macro.S   |    2 +-
 arch/arm/mach-mxs/include/mach-mxs/iomux-mx23.h    |    2 +-
 arch/arm/mach-mxs/include/mach-mxs/iomux-mx28.h    |    2 +-
 arch/arm/mach-mxs/include/mach-mxs/mx23.h          |    2 +-
 arch/arm/mach-mxs/include/mach-mxs/mx28.h          |    2 +-
 arch/arm/mach-mxs/include/mach-mxs/mxs.h           |    4 +-
 arch/arm/mach-mxs/iomux.c                          |    4 +-
 arch/arm/mach-mxs/mach-apx4devkit.c                |    6 +--
 arch/arm/mach-mxs/mach-m28evk.c                    |    4 +-
 arch/arm/mach-mxs/mach-mx23evk.c                   |    4 +-
 arch/arm/mach-mxs/mach-mx28evk.c                   |    6 +--
 arch/arm/mach-mxs/mach-mxs.c                       |    2 +-
 arch/arm/mach-mxs/mach-stmp378x_devb.c             |    4 +-
 arch/arm/mach-mxs/mach-tx28.c                      |    4 +-
 arch/arm/mach-mxs/mm.c                             |    8 ++--
 arch/arm/mach-mxs/module-tx28.c                    |    2 +-
 arch/arm/mach-mxs/ocotp.c                          |    2 +-
 arch/arm/mach-mxs/system.c                         |    4 +-
 arch/arm/mach-mxs/timer.c                          |    4 +-
 arch/arm/mach-netx/fb.c                            |    4 +-
 arch/arm/mach-netx/generic.c                       |    4 +-
 arch/arm/mach-netx/nxdb500.c                       |    6 +--
 arch/arm/mach-netx/nxdkn.c                         |    6 +--
 arch/arm/mach-netx/nxeb500hmi.c                    |    6 +--
 arch/arm/mach-netx/pfifo.c                         |    6 +--
 arch/arm/mach-netx/time.c                          |    4 +-
 arch/arm/mach-netx/xc.c                            |    8 ++--
 arch/arm/mach-nomadik/board-nhk8815.c              |    8 ++--
 arch/arm/mach-nomadik/cpu-8815.c                   |    6 +--
 arch/arm/mach-nomadik/i2c-8815nhk.c                |    4 +-
 arch/arm/mach-nomadik/include/mach-nomadik/fsmc.h  |    2 +-
 arch/arm/mach-nomadik/include/mach-nomadik/irqs.h  |    2 +-
 .../mach-nomadik/include/mach-nomadik/uncompress.h |    2 +-
 arch/arm/mach-omap1/ams-delta-fiq-handler.S        |    4 +-
 arch/arm/mach-omap1/ams-delta-fiq.c                |    4 +-
 arch/arm/mach-omap1/board-ams-delta.c              |   18 ++++----
 arch/arm/mach-omap1/board-fsample.c                |   16 +++----
 arch/arm/mach-omap1/board-generic.c                |    8 ++--
 arch/arm/mach-omap1/board-h2-mmc.c                 |    2 +-
 arch/arm/mach-omap1/board-h2.c                     |   18 ++++----
 arch/arm/mach-omap1/board-h3-mmc.c                 |    2 +-
 arch/arm/mach-omap1/board-h3.c                     |   18 ++++----
 arch/arm/mach-omap1/board-htcherald.c              |   12 ++---
 arch/arm/mach-omap1/board-innovator.c              |   18 ++++----
 arch/arm/mach-omap1/board-nokia770.c               |   18 ++++----
 arch/arm/mach-omap1/board-osk.c                    |   12 ++---
 arch/arm/mach-omap1/board-palmte.c                 |   18 ++++----
 arch/arm/mach-omap1/board-palmtt.c                 |   22 ++++-----
 arch/arm/mach-omap1/board-palmz71.c                |   20 ++++----
 arch/arm/mach-omap1/board-perseus2.c               |   16 +++----
 arch/arm/mach-omap1/board-sx1-mmc.c                |    6 +--
 arch/arm/mach-omap1/board-sx1.c                    |   22 ++++-----
 arch/arm/mach-omap1/board-voiceblue.c              |   16 +++----
 arch/arm/mach-omap1/clock.c                        |   12 ++---
 arch/arm/mach-omap1/clock.h                        |    2 +-
 arch/arm/mach-omap1/clock_data.c                   |   16 +++----
 arch/arm/mach-omap1/common.h                       |    2 +-
 arch/arm/mach-omap1/devices.c                      |   18 ++++----
 arch/arm/mach-omap1/dma.c                          |    6 +--
 arch/arm/mach-omap1/flash.c                        |    6 +--
 arch/arm/mach-omap1/fpga.c                         |    4 +-
 arch/arm/mach-omap1/i2c.c                          |    6 +--
 arch/arm/mach-omap1/id.c                           |    4 +-
 .../mach-omap1/include/mach-omap1/ams-delta-fiq.h  |    2 +-
 .../mach-omap1/include/mach-omap1/debug-macro.S    |    2 +-
 .../mach-omap1/include/mach-omap1/entry-macro.S    |    4 +-
 arch/arm/mach-omap1/include/mach-omap1/gpio.h      |    2 +-
 arch/arm/mach-omap1/include/mach-omap1/hardware.h  |    4 +-
 arch/arm/mach-omap1/include/mach-omap1/irqs.h      |    2 +-
 arch/arm/mach-omap1/include/mach-omap1/memory.h    |    2 +-
 arch/arm/mach-omap1/include/mach-omap1/mtd-xip.h   |    2 +-
 arch/arm/mach-omap1/include/mach-omap1/smp.h       |    2 +-
 arch/arm/mach-omap1/include/mach-omap1/timex.h     |    2 +-
 .../arm/mach-omap1/include/mach-omap1/uncompress.h |    2 +-
 arch/arm/mach-omap1/io.c                           |    6 +--
 arch/arm/mach-omap1/irq.c                          |    4 +-
 arch/arm/mach-omap1/lcd_dma.c                      |    6 +--
 arch/arm/mach-omap1/leds-h2p2-debug.c              |    4 +-
 arch/arm/mach-omap1/leds-innovator.c               |    2 +-
 arch/arm/mach-omap1/leds-osk.c                     |    2 +-
 arch/arm/mach-omap1/leds.c                         |    2 +-
 arch/arm/mach-omap1/mailbox.c                      |    2 +-
 arch/arm/mach-omap1/mcbsp.c                        |   10 ++--
 arch/arm/mach-omap1/mux.c                          |    4 +-
 arch/arm/mach-omap1/ocpi.c                         |    2 +-
 arch/arm/mach-omap1/opp_data.c                     |    2 +-
 arch/arm/mach-omap1/pm.c                           |   18 ++++----
 arch/arm/mach-omap1/pm_bus.c                       |    4 +-
 arch/arm/mach-omap1/reset.c                        |    4 +-
 arch/arm/mach-omap1/serial.c                       |    6 +--
 arch/arm/mach-omap1/sram.S                         |    2 +-
 arch/arm/mach-omap1/time.c                         |    2 +-
 arch/arm/mach-omap1/timer.c                        |    4 +-
 arch/arm/mach-omap1/timer32k.c                     |    4 +-
 arch/arm/mach-omap1/usb.c                          |    4 +-
 arch/arm/mach-omap2/am35xx-emac.c                  |    4 +-
 arch/arm/mach-omap2/board-2430sdp.c                |   10 ++--
 arch/arm/mach-omap2/board-3430sdp.c                |   14 +++---
 arch/arm/mach-omap2/board-3630sdp.c                |    8 ++--
 arch/arm/mach-omap2/board-4430sdp.c                |   10 ++--
 arch/arm/mach-omap2/board-am3517crane.c            |    6 +--
 arch/arm/mach-omap2/board-am3517evm.c              |    8 ++--
 arch/arm/mach-omap2/board-apollon.c                |    8 ++--
 arch/arm/mach-omap2/board-cm-t35.c                 |   14 +++---
 arch/arm/mach-omap2/board-cm-t3517.c               |   10 ++--
 arch/arm/mach-omap2/board-devkit8000.c             |   14 +++---
 arch/arm/mach-omap2/board-flash.c                  |   10 ++--
 arch/arm/mach-omap2/board-flash.h                  |    2 +-
 arch/arm/mach-omap2/board-generic.c                |    4 +-
 arch/arm/mach-omap2/board-h4.c                     |   10 ++--
 arch/arm/mach-omap2/board-igep0020.c               |   10 ++--
 arch/arm/mach-omap2/board-ldp.c                    |   14 +++---
 arch/arm/mach-omap2/board-n8x0.c                   |   14 +++---
 arch/arm/mach-omap2/board-omap3beagle.c            |   12 ++---
 arch/arm/mach-omap2/board-omap3evm.c               |   12 ++---
 arch/arm/mach-omap2/board-omap3logic.c             |   14 +++---
 arch/arm/mach-omap2/board-omap3pandora.c           |   10 ++--
 arch/arm/mach-omap2/board-omap3stalker.c           |   14 +++---
 arch/arm/mach-omap2/board-omap3touchbook.c         |   12 ++---
 arch/arm/mach-omap2/board-omap4panda.c             |    8 ++--
 arch/arm/mach-omap2/board-overo.c                  |   16 +++----
 arch/arm/mach-omap2/board-rm680.c                  |   10 ++--
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   14 +++---
 arch/arm/mach-omap2/board-rx51-video.c             |    6 +--
 arch/arm/mach-omap2/board-rx51.c                   |   12 ++---
 arch/arm/mach-omap2/board-ti8168evm.c              |    8 ++--
 arch/arm/mach-omap2/board-zoom-debugboard.c        |    6 +--
 arch/arm/mach-omap2/board-zoom-display.c           |    4 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |    4 +-
 arch/arm/mach-omap2/board-zoom.c                   |    6 +--
 arch/arm/mach-omap2/clkt2xxx_apll.c                |    4 +-
 arch/arm/mach-omap2/clkt2xxx_dpll.c                |    2 +-
 arch/arm/mach-omap2/clkt2xxx_dpllcore.c            |    6 +--
 arch/arm/mach-omap2/clkt2xxx_osc.c                 |    2 +-
 arch/arm/mach-omap2/clkt2xxx_sys.c                 |    2 +-
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c       |    8 ++--
 arch/arm/mach-omap2/clkt34xx_dpll3m2.c             |    6 +--
 arch/arm/mach-omap2/clkt_clksel.c                  |    2 +-
 arch/arm/mach-omap2/clkt_dpll.c                    |    4 +-
 arch/arm/mach-omap2/clkt_iclk.c                    |    4 +-
 arch/arm/mach-omap2/clock.c                        |    6 +--
 arch/arm/mach-omap2/clock.h                        |    2 +-
 arch/arm/mach-omap2/clock2420_data.c               |    4 +-
 arch/arm/mach-omap2/clock2430.c                    |    4 +-
 arch/arm/mach-omap2/clock2430_data.c               |    4 +-
 arch/arm/mach-omap2/clock2xxx.c                    |    4 +-
 arch/arm/mach-omap2/clock33xx_data.c               |    4 +-
 arch/arm/mach-omap2/clock34xx.c                    |    2 +-
 arch/arm/mach-omap2/clock3517.c                    |    2 +-
 arch/arm/mach-omap2/clock36xx.c                    |    2 +-
 arch/arm/mach-omap2/clock3xxx.c                    |    4 +-
 arch/arm/mach-omap2/clock3xxx_data.c               |    4 +-
 arch/arm/mach-omap2/clock44xx_data.c               |    4 +-
 arch/arm/mach-omap2/clockdomain.c                  |    2 +-
 arch/arm/mach-omap2/clockdomain.h                  |    6 +--
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c         |    2 +-
 arch/arm/mach-omap2/cm2xxx_3xxx.c                  |    2 +-
 arch/arm/mach-omap2/cm33xx.c                       |    2 +-
 arch/arm/mach-omap2/common-board-devices.c         |    4 +-
 arch/arm/mach-omap2/common.c                       |    8 ++--
 arch/arm/mach-omap2/common.h                       |    2 +-
 arch/arm/mach-omap2/control.c                      |    4 +-
 arch/arm/mach-omap2/control.h                      |   10 ++--
 arch/arm/mach-omap2/cpuidle34xx.c                  |    4 +-
 arch/arm/mach-omap2/devices.c                      |   18 ++++----
 arch/arm/mach-omap2/display.c                      |    6 +--
 arch/arm/mach-omap2/dma.c                          |    6 +--
 arch/arm/mach-omap2/dpll3xxx.c                     |    4 +-
 arch/arm/mach-omap2/dpll44xx.c                     |    4 +-
 arch/arm/mach-omap2/drm.c                          |    4 +-
 arch/arm/mach-omap2/dsp.c                          |    4 +-
 arch/arm/mach-omap2/emu.c                          |    2 +-
 arch/arm/mach-omap2/gpio.c                         |    6 +--
 arch/arm/mach-omap2/gpmc-nand.c                    |    8 ++--
 arch/arm/mach-omap2/gpmc-onenand.c                 |    8 ++--
 arch/arm/mach-omap2/gpmc-smc91x.c                  |    6 +--
 arch/arm/mach-omap2/gpmc-smsc911x.c                |    6 +--
 arch/arm/mach-omap2/gpmc.c                         |    4 +-
 arch/arm/mach-omap2/hdq1w.c                        |    6 +--
 arch/arm/mach-omap2/hsmmc.c                        |   10 ++--
 arch/arm/mach-omap2/hwspinlock.c                   |    4 +-
 arch/arm/mach-omap2/i2c.c                          |    6 +--
 arch/arm/mach-omap2/id.c                           |    4 +-
 .../mach-omap2/include/mach-omap2/debug-macro.S    |    2 +-
 arch/arm/mach-omap2/include/mach-omap2/gpio.h      |    2 +-
 arch/arm/mach-omap2/include/mach-omap2/hardware.h  |    2 +-
 arch/arm/mach-omap2/include/mach-omap2/irqs.h      |    2 +-
 arch/arm/mach-omap2/include/mach-omap2/smp.h       |    2 +-
 arch/arm/mach-omap2/include/mach-omap2/timex.h     |    2 +-
 .../arm/mach-omap2/include/mach-omap2/uncompress.h |    2 +-
 arch/arm/mach-omap2/io.c                           |   14 +++---
 arch/arm/mach-omap2/iommu2.c                       |    2 +-
 arch/arm/mach-omap2/irq.c                          |    2 +-
 arch/arm/mach-omap2/mailbox.c                      |    4 +-
 arch/arm/mach-omap2/mcbsp.c                        |   10 ++--
 arch/arm/mach-omap2/msdi.c                         |    6 +--
 arch/arm/mach-omap2/mux.c                          |    2 +-
 arch/arm/mach-omap2/omap-hotplug.c                 |    2 +-
 arch/arm/mach-omap2/omap-iommu.c                   |    4 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |    2 +-
 arch/arm/mach-omap2/omap-secure.c                  |    4 +-
 arch/arm/mach-omap2/omap-smp.c                     |    6 +--
 arch/arm/mach-omap2/omap-wakeupgen.c               |    4 +-
 arch/arm/mach-omap2/omap4-common.c                 |   12 ++---
 arch/arm/mach-omap2/omap_hwmod.c                   |    8 ++--
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |   24 +++++-----
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   24 +++++-----
 .../omap_hwmod_2xxx_3xxx_interconnect_data.c       |    4 +-
 .../mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c |   12 ++---
 .../mach-omap2/omap_hwmod_2xxx_interconnect_data.c |    8 ++--
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |   16 +++----
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   28 ++++++------
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   20 ++++----
 arch/arm/mach-omap2/omap_hwmod_common_data.c       |    2 +-
 arch/arm/mach-omap2/omap_hwmod_common_data.h       |    2 +-
 arch/arm/mach-omap2/omap_opp_data.h                |    2 +-
 arch/arm/mach-omap2/omap_phy_internal.c            |    2 +-
 arch/arm/mach-omap2/opp.c                          |    2 +-
 arch/arm/mach-omap2/opp2420_data.c                 |    2 +-
 arch/arm/mach-omap2/opp2430_data.c                 |    2 +-
 arch/arm/mach-omap2/opp3xxx_data.c                 |    2 +-
 arch/arm/mach-omap2/opp4xxx_data.c                 |    2 +-
 arch/arm/mach-omap2/pm-debug.c                     |    8 ++--
 arch/arm/mach-omap2/pm.c                           |    4 +-
 arch/arm/mach-omap2/pm24xx.c                       |   10 ++--
 arch/arm/mach-omap2/pm34xx.c                       |   10 ++--
 arch/arm/mach-omap2/powerdomain.c                  |    4 +-
 arch/arm/mach-omap2/powerdomain.h                  |    2 +-
 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c         |    2 +-
 arch/arm/mach-omap2/powerdomain33xx.c              |    2 +-
 arch/arm/mach-omap2/powerdomain44xx.c              |    2 +-
 arch/arm/mach-omap2/powerdomains3xxx_data.c        |    2 +-
 arch/arm/mach-omap2/prcm.c                         |    4 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |    6 +--
 arch/arm/mach-omap2/prm33xx.c                      |    2 +-
 arch/arm/mach-omap2/prm44xx.c                      |    6 +--
 arch/arm/mach-omap2/prm_common.c                   |    6 +--
 arch/arm/mach-omap2/sdram-hynix-h8mbx00u0mer-0em.h |    2 +-
 arch/arm/mach-omap2/sdram-micron-mt46h32m32lf-6.h  |    2 +-
 arch/arm/mach-omap2/sdram-nokia.c                  |    4 +-
 arch/arm/mach-omap2/sdram-numonyx-m65kxxxxam.h     |    2 +-
 .../mach-omap2/sdram-qimonda-hyb18m512160af-6.h    |    2 +-
 arch/arm/mach-omap2/sdrc.c                         |    6 +--
 arch/arm/mach-omap2/sdrc.h                         |    2 +-
 arch/arm/mach-omap2/sdrc2xxx.c                     |    8 ++--
 arch/arm/mach-omap2/serial.c                       |   12 ++---
 arch/arm/mach-omap2/sleep24xx.S                    |    2 +-
 arch/arm/mach-omap2/sleep34xx.S                    |    4 +-
 arch/arm/mach-omap2/sleep44xx.S                    |    4 +-
 arch/arm/mach-omap2/sr_device.c                    |    2 +-
 arch/arm/mach-omap2/sram242x.S                     |    2 +-
 arch/arm/mach-omap2/sram243x.S                     |    2 +-
 arch/arm/mach-omap2/sram34xx.S                     |    2 +-
 arch/arm/mach-omap2/timer.c                        |    8 ++--
 arch/arm/mach-omap2/twl-common.c                   |    4 +-
 arch/arm/mach-omap2/twl-common.h                   |    2 +-
 arch/arm/mach-omap2/usb-host.c                     |    8 ++--
 arch/arm/mach-omap2/usb-musb.c                     |   10 ++--
 arch/arm/mach-omap2/usb-tusb6010.c                 |    2 +-
 arch/arm/mach-omap2/vc.c                           |    2 +-
 arch/arm/mach-omap2/voltage.h                      |    2 +-
 arch/arm/mach-omap2/voltagedomains3xxx_data.c      |    2 +-
 arch/arm/mach-omap2/wd_timer.c                     |    2 +-
 arch/arm/mach-omap2/wd_timer.h                     |    2 +-
 arch/arm/mach-orion5x/addr-map.c                   |    4 +-
 arch/arm/mach-orion5x/common.c                     |   16 +++----
 arch/arm/mach-orion5x/d2net-setup.c                |    2 +-
 arch/arm/mach-orion5x/db88f5281-setup.c            |    4 +-
 arch/arm/mach-orion5x/dns323-setup.c               |    2 +-
 arch/arm/mach-orion5x/edmini_v2-setup.c            |    2 +-
 .../include/mach-orion5x/bridge-regs.h             |    2 +-
 .../include/mach-orion5x/debug-macro.S             |    2 +-
 .../include/mach-orion5x/entry-macro.S             |    2 +-
 arch/arm/mach-orion5x/include/mach-orion5x/gpio.h  |    2 +-
 arch/arm/mach-orion5x/include/mach-orion5x/io.h    |    2 +-
 .../mach-orion5x/include/mach-orion5x/uncompress.h |    2 +-
 arch/arm/mach-orion5x/irq.c                        |    4 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c          |    4 +-
 arch/arm/mach-orion5x/ls-chl-setup.c               |    2 +-
 arch/arm/mach-orion5x/ls_hgl-setup.c               |    2 +-
 arch/arm/mach-orion5x/lsmini-setup.c               |    2 +-
 arch/arm/mach-orion5x/mpp.c                        |    4 +-
 arch/arm/mach-orion5x/mss2-setup.c                 |    4 +-
 arch/arm/mach-orion5x/mv2120-setup.c               |    2 +-
 arch/arm/mach-orion5x/net2big-setup.c              |    2 +-
 arch/arm/mach-orion5x/pci.c                        |    6 +--
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c       |    2 +-
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c        |    2 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c            |    2 +-
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c       |    2 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c     |    2 +-
 arch/arm/mach-orion5x/ts209-setup.c                |    2 +-
 arch/arm/mach-orion5x/ts409-setup.c                |    2 +-
 arch/arm/mach-orion5x/ts78xx-setup.c               |    2 +-
 arch/arm/mach-orion5x/tsx09-common.c               |    2 +-
 arch/arm/mach-orion5x/wnr854t-setup.c              |    2 +-
 arch/arm/mach-orion5x/wrt350n-v2-setup.c           |    2 +-
 arch/arm/mach-picoxcell/common.c                   |    4 +-
 .../include/mach-picoxcell/debug-macro.S           |    4 +-
 .../include/mach-picoxcell/hardware.h              |    2 +-
 arch/arm/mach-pnx4008/clock.c                      |    4 +-
 arch/arm/mach-pnx4008/core.c                       |    8 ++--
 arch/arm/mach-pnx4008/dma.c                        |    6 +--
 arch/arm/mach-pnx4008/gpio.c                       |    6 +--
 arch/arm/mach-pnx4008/i2c.c                        |    4 +-
 .../mach-pnx4008/include/mach-pnx4008/hardware.h   |    2 +-
 arch/arm/mach-pnx4008/irq.c                        |    4 +-
 arch/arm/mach-pnx4008/pm.c                         |    6 +--
 arch/arm/mach-pnx4008/serial.c                     |    8 ++--
 arch/arm/mach-pnx4008/sleep.S                      |    2 +-
 arch/arm/mach-pnx4008/time.c                       |    2 +-
 arch/arm/mach-pnx4008/time.h                       |    2 +-
 arch/arm/mach-prima2/clock.c                       |    2 +-
 .../mach-prima2/include/mach-prima2/debug-macro.S  |    4 +-
 .../mach-prima2/include/mach-prima2/entry-macro.S  |    2 +-
 .../arm/mach-prima2/include/mach-prima2/hardware.h |    2 +-
 .../mach-prima2/include/mach-prima2/uncompress.h   |    4 +-
 arch/arm/mach-prima2/irq.c                         |    2 +-
 arch/arm/mach-prima2/lluart.c                      |    4 +-
 arch/arm/mach-prima2/timer.c                       |    2 +-
 arch/arm/mach-pxa/am200epd.c                       |    6 +--
 arch/arm/mach-pxa/am300epd.c                       |    6 +--
 arch/arm/mach-pxa/balloon3.c                       |   18 ++++----
 arch/arm/mach-pxa/capc7117.c                       |    4 +-
 arch/arm/mach-pxa/clock-pxa2xx.c                   |    2 +-
 arch/arm/mach-pxa/clock-pxa3xx.c                   |    4 +-
 arch/arm/mach-pxa/cm-x255.c                        |    2 +-
 arch/arm/mach-pxa/cm-x270.c                        |    6 +--
 arch/arm/mach-pxa/cm-x2xx.c                        |   10 ++--
 arch/arm/mach-pxa/cm-x300.c                        |   16 +++----
 arch/arm/mach-pxa/colibri-evalboard.c              |   12 ++---
 arch/arm/mach-pxa/colibri-pxa270-income.c          |   12 ++---
 arch/arm/mach-pxa/colibri-pxa270.c                 |    6 +--
 arch/arm/mach-pxa/colibri-pxa300.c                 |   10 ++--
 arch/arm/mach-pxa/colibri-pxa320.c                 |   14 +++---
 arch/arm/mach-pxa/colibri-pxa3xx.c                 |   14 +++---
 arch/arm/mach-pxa/corgi.c                          |   14 +++---
 arch/arm/mach-pxa/corgi_pm.c                       |    8 ++--
 arch/arm/mach-pxa/cpufreq-pxa2xx.c                 |    4 +-
 arch/arm/mach-pxa/cpufreq-pxa3xx.c                 |    2 +-
 arch/arm/mach-pxa/csb726.c                         |   12 ++---
 arch/arm/mach-pxa/devices.c                        |   24 +++++-----
 arch/arm/mach-pxa/em-x270.c                        |   16 +++----
 arch/arm/mach-pxa/eseries.c                        |   14 +++---
 arch/arm/mach-pxa/ezx.c                            |   12 ++---
 arch/arm/mach-pxa/generic.c                        |    8 ++--
 arch/arm/mach-pxa/gumstix.c                        |   10 ++--
 arch/arm/mach-pxa/h5000.c                          |    8 ++--
 arch/arm/mach-pxa/himalaya.c                       |    2 +-
 arch/arm/mach-pxa/hx4700.c                         |    8 ++--
 arch/arm/mach-pxa/icontrol.c                       |    4 +-
 arch/arm/mach-pxa/idp.c                            |   12 ++---
 arch/arm/mach-pxa/include/mach-pxa/colibri.h       |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/dma.h           |    4 +-
 arch/arm/mach-pxa/include/mach-pxa/gpio.h          |    4 +-
 arch/arm/mach-pxa/include/mach-pxa/h5000.h         |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/hardware.h      |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/magician.h      |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/mainstone.h     |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa25x.h    |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa27x.h    |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa2xx.h    |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa300.h    |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa320.h    |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa3xx.h    |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa930.h    |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/mfp.h           |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/mtd-xip.h       |    2 +-
 .../mach-pxa/include/mach-pxa/pcm990_baseboard.h   |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/pxa25x.h        |    8 ++--
 arch/arm/mach-pxa/include/mach-pxa/pxa27x.h        |    8 ++--
 arch/arm/mach-pxa/include/mach-pxa/pxa2xx-regs.h   |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/pxa300.h        |    4 +-
 arch/arm/mach-pxa/include/mach-pxa/pxa320.h        |    4 +-
 arch/arm/mach-pxa/include/mach-pxa/pxa3xx-regs.h   |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/pxa3xx.h        |    6 +--
 arch/arm/mach-pxa/include/mach-pxa/pxa930.h        |    4 +-
 arch/arm/mach-pxa/include/mach-pxa/pxa95x.h        |    4 +-
 arch/arm/mach-pxa/include/mach-pxa/pxafb.h         |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/regs-ac97.h     |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/regs-lcd.h      |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/regs-ost.h      |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/regs-rtc.h      |    2 +-
 arch/arm/mach-pxa/include/mach-pxa/regs-u2d.h      |    2 +-
 arch/arm/mach-pxa/irq.c                            |    4 +-
 arch/arm/mach-pxa/leds-idp.c                       |    6 +--
 arch/arm/mach-pxa/leds-lubbock.c                   |    6 +--
 arch/arm/mach-pxa/leds-mainstone.c                 |    6 +--
 arch/arm/mach-pxa/littleton.c                      |   14 +++---
 arch/arm/mach-pxa/lpd270.c                         |   18 ++++----
 arch/arm/mach-pxa/lubbock.c                        |   20 ++++----
 arch/arm/mach-pxa/magician.c                       |   14 +++---
 arch/arm/mach-pxa/mainstone.c                      |   20 ++++----
 arch/arm/mach-pxa/mfp-pxa2xx.c                     |    4 +-
 arch/arm/mach-pxa/mfp-pxa3xx.c                     |    6 +--
 arch/arm/mach-pxa/mioa701.c                        |   22 ++++-----
 arch/arm/mach-pxa/mp900.c                          |    2 +-
 arch/arm/mach-pxa/mxm8x10.c                        |   12 ++---
 arch/arm/mach-pxa/palm27x.c                        |   16 +++----
 arch/arm/mach-pxa/palmld.c                         |   18 ++++----
 arch/arm/mach-pxa/palmt5.c                         |   20 ++++----
 arch/arm/mach-pxa/palmtc.c                         |   14 +++---
 arch/arm/mach-pxa/palmte2.c                        |   16 +++----
 arch/arm/mach-pxa/palmtreo.c                       |   28 ++++++------
 arch/arm/mach-pxa/palmtx.c                         |   20 ++++----
 arch/arm/mach-pxa/palmz72.c                        |   26 +++++------
 arch/arm/mach-pxa/pcm027.c                         |    4 +-
 arch/arm/mach-pxa/pcm990-baseboard.c               |   14 +++---
 arch/arm/mach-pxa/pm.c                             |    2 +-
 arch/arm/mach-pxa/poodle.c                         |   14 +++---
 arch/arm/mach-pxa/pxa25x.c                         |   14 +++---
 arch/arm/mach-pxa/pxa27x.c                         |   16 +++----
 arch/arm/mach-pxa/pxa2xx.c                         |   10 ++--
 arch/arm/mach-pxa/pxa300.c                         |    2 +-
 arch/arm/mach-pxa/pxa320.c                         |    2 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c                    |    6 +--
 arch/arm/mach-pxa/pxa3xx.c                         |   16 +++----
 arch/arm/mach-pxa/pxa930.c                         |    2 +-
 arch/arm/mach-pxa/pxa95x.c                         |   12 ++---
 arch/arm/mach-pxa/raumfeld.c                       |   10 ++--
 arch/arm/mach-pxa/reset.c                          |    4 +-
 arch/arm/mach-pxa/saar.c                           |    4 +-
 arch/arm/mach-pxa/saarb.c                          |   10 ++--
 arch/arm/mach-pxa/sharpsl_pm.c                     |    8 ++--
 arch/arm/mach-pxa/sleep.S                          |    6 +--
 arch/arm/mach-pxa/smemc.c                          |    4 +-
 arch/arm/mach-pxa/spitz.c                          |   20 ++++----
 arch/arm/mach-pxa/spitz_pm.c                       |    8 ++--
 arch/arm/mach-pxa/standby.S                        |    4 +-
 arch/arm/mach-pxa/stargate2.c                      |   10 ++--
 arch/arm/mach-pxa/tavorevb.c                       |    6 +--
 arch/arm/mach-pxa/tavorevb3.c                      |    2 +-
 arch/arm/mach-pxa/time.c                           |    4 +-
 arch/arm/mach-pxa/tosa-bt.c                        |    2 +-
 arch/arm/mach-pxa/tosa.c                           |   18 ++++----
 arch/arm/mach-pxa/trizeps4.c                       |   16 +++----
 arch/arm/mach-pxa/viper.c                          |   12 ++---
 arch/arm/mach-pxa/vpac270.c                        |   18 ++++----
 arch/arm/mach-pxa/xcep.c                           |    6 +--
 arch/arm/mach-pxa/z2.c                             |   14 +++---
 arch/arm/mach-pxa/zeus.c                           |   24 +++++-----
 arch/arm/mach-pxa/zylonite.c                       |   16 +++----
 arch/arm/mach-pxa/zylonite_pxa300.c                |    4 +-
 arch/arm/mach-pxa/zylonite_pxa320.c                |    4 +-
 arch/arm/mach-realview/core.c                      |   10 ++--
 .../mach-realview/include/mach-realview/board-eb.h |    2 +-
 .../include/mach-realview/board-pb1176.h           |    2 +-
 .../include/mach-realview/board-pb11mp.h           |    2 +-
 .../include/mach-realview/board-pba8.h             |    2 +-
 .../include/mach-realview/board-pbx.h              |    2 +-
 .../mach-realview/include/mach-realview/clkdev.h   |    2 +-
 .../arm/mach-realview/include/mach-realview/irqs.h |   10 ++--
 .../include/mach-realview/uncompress.h             |   12 ++---
 arch/arm/mach-realview/platsmp.c                   |    8 ++--
 arch/arm/mach-realview/realview_eb.c               |    6 +--
 arch/arm/mach-realview/realview_pb1176.c           |    6 +--
 arch/arm/mach-realview/realview_pb11mp.c           |    6 +--
 arch/arm/mach-realview/realview_pba8.c             |    6 +--
 arch/arm/mach-realview/realview_pbx.c              |    6 +--
 arch/arm/mach-rpc/dma.c                            |    2 +-
 arch/arm/mach-rpc/ecard.c                          |    2 +-
 arch/arm/mach-rpc/fiq.S                            |    4 +-
 arch/arm/mach-rpc/include/mach-rpc/entry-macro.S   |    2 +-
 arch/arm/mach-rpc/include/mach-rpc/hardware.h      |    2 +-
 arch/arm/mach-rpc/include/mach-rpc/io.h            |    2 +-
 arch/arm/mach-rpc/include/mach-rpc/uncompress.h    |    2 +-
 arch/arm/mach-rpc/riscpc.c                         |    2 +-
 arch/arm/mach-rpc/time.c                           |    2 +-
 arch/arm/mach-s3c2410/cpu-freq.c                   |    8 ++--
 arch/arm/mach-s3c2410/pll.c                        |    4 +-
 arch/arm/mach-s3c2412/cpu-freq.c                   |   10 ++--
 arch/arm/mach-s3c2412/gpio.c                       |    6 +--
 arch/arm/mach-s3c2440/dsc.c                        |   10 ++--
 arch/arm/mach-s3c2440/s3c2440-cpufreq.c            |   10 ++--
 arch/arm/mach-s3c2440/s3c2440-pll-12000000.c       |    4 +-
 arch/arm/mach-s3c2440/s3c2440-pll-16934400.c       |    4 +-
 arch/arm/mach-s3c24xx/bast-ide.c                   |    6 +--
 arch/arm/mach-s3c24xx/bast-irq.c                   |   10 ++--
 arch/arm/mach-s3c24xx/clock-s3c2412.c              |   14 +++---
 arch/arm/mach-s3c24xx/clock-s3c2416.c              |   16 +++----
 arch/arm/mach-s3c24xx/clock-s3c2440.c              |   10 ++--
 arch/arm/mach-s3c24xx/clock-s3c2443.c              |   14 +++---
 arch/arm/mach-s3c24xx/clock-s3c244x.c              |    8 ++--
 arch/arm/mach-s3c24xx/common-s3c2443.c             |   10 ++--
 arch/arm/mach-s3c24xx/common-smdk.c                |   16 +++----
 arch/arm/mach-s3c24xx/common.c                     |   30 ++++++------
 arch/arm/mach-s3c24xx/dma-s3c2410.c                |   30 ++++++------
 arch/arm/mach-s3c24xx/dma-s3c2412.c                |   28 ++++++------
 arch/arm/mach-s3c24xx/dma-s3c2440.c                |   26 +++++------
 arch/arm/mach-s3c24xx/dma-s3c2443.c                |   24 +++++-----
 arch/arm/mach-s3c24xx/h1940-bluetooth.c            |    8 ++--
 .../include/mach-s3c24xx/debug-macro.S             |    8 ++--
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/dma.h   |    2 +-
 .../include/mach-s3c24xx/entry-macro.S             |    2 +-
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/fb.h    |    2 +-
 .../mach-s3c24xx/include/mach-s3c24xx/gpio-fns.h   |    2 +-
 .../mach-s3c24xx/include/mach-s3c24xx/gpio-track.h |    2 +-
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/gpio.h  |    4 +-
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/gta02.h |    2 +-
 .../mach-s3c24xx/include/mach-s3c24xx/hardware.h   |    2 +-
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/io.h    |    2 +-
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/map.h   |    4 +-
 .../mach-s3c24xx/include/mach-s3c24xx/regs-gpio.h  |    2 +-
 .../mach-s3c24xx/include/mach-s3c24xx/uncompress.h |    6 +--
 .../mach-s3c24xx/include/mach-s3c24xx/vr1000-map.h |    2 +-
 arch/arm/mach-s3c24xx/irq-pm.c                     |    6 +--
 arch/arm/mach-s3c24xx/irq-s3c2412.c                |   14 +++---
 arch/arm/mach-s3c24xx/irq-s3c2416.c                |   12 ++---
 arch/arm/mach-s3c24xx/irq-s3c2440.c                |   12 ++---
 arch/arm/mach-s3c24xx/irq-s3c2443.c                |   12 ++---
 arch/arm/mach-s3c24xx/irq-s3c244x.c                |   12 ++---
 arch/arm/mach-s3c24xx/mach-amlm5900.c              |   18 ++++----
 arch/arm/mach-s3c24xx/mach-anubis.c                |   28 ++++++------
 arch/arm/mach-s3c24xx/mach-at2440evb.c             |   24 +++++-----
 arch/arm/mach-s3c24xx/mach-bast.c                  |   36 +++++++--------
 arch/arm/mach-s3c24xx/mach-gta02.c                 |   38 ++++++++--------
 arch/arm/mach-s3c24xx/mach-h1940.c                 |   46 +++++++++----------
 arch/arm/mach-s3c24xx/mach-jive.c                  |   30 ++++++------
 arch/arm/mach-s3c24xx/mach-mini2440.c              |   32 ++++++-------
 arch/arm/mach-s3c24xx/mach-n30.c                   |   26 +++++------
 arch/arm/mach-s3c24xx/mach-nexcoder.c              |   22 ++++-----
 arch/arm/mach-s3c24xx/mach-osiris-dvs.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-osiris.c                |   28 ++++++------
 arch/arm/mach-s3c24xx/mach-otom.c                  |   18 ++++----
 arch/arm/mach-s3c24xx/mach-qt2410.c                |   28 ++++++------
 arch/arm/mach-s3c24xx/mach-rx1950.c                |   34 +++++++-------
 arch/arm/mach-s3c24xx/mach-rx3715.c                |   22 ++++-----
 arch/arm/mach-s3c24xx/mach-smdk2410.c              |   12 ++---
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |   34 +++++++-------
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |   42 ++++++++---------
 arch/arm/mach-s3c24xx/mach-smdk2440.c              |   26 +++++------
 arch/arm/mach-s3c24xx/mach-smdk2443.c              |   26 +++++------
 arch/arm/mach-s3c24xx/mach-tct_hammer.c            |   10 ++--
 arch/arm/mach-s3c24xx/mach-vr1000.c                |   26 +++++------
 arch/arm/mach-s3c24xx/mach-vstms.c                 |   26 +++++------
 arch/arm/mach-s3c24xx/pm-h1940.S                   |    6 +--
 arch/arm/mach-s3c24xx/pm-s3c2410.c                 |   10 ++--
 arch/arm/mach-s3c24xx/pm-s3c2412.c                 |   14 +++---
 arch/arm/mach-s3c24xx/pm-s3c2416.c                 |    8 ++--
 arch/arm/mach-s3c24xx/pm.c                         |   14 +++---
 arch/arm/mach-s3c24xx/s3c2410.c                    |   28 ++++++------
 arch/arm/mach-s3c24xx/s3c2412.c                    |   36 +++++++--------
 arch/arm/mach-s3c24xx/s3c2416.c                    |   34 +++++++-------
 arch/arm/mach-s3c24xx/s3c2440.c                    |   16 +++----
 arch/arm/mach-s3c24xx/s3c2442.c                    |   18 ++++----
 arch/arm/mach-s3c24xx/s3c2443.c                    |   26 +++++------
 arch/arm/mach-s3c24xx/s3c244x.c                    |   34 +++++++-------
 arch/arm/mach-s3c24xx/setup-i2c.c                  |    8 ++--
 arch/arm/mach-s3c24xx/setup-sdhci-gpio.c           |    4 +-
 arch/arm/mach-s3c24xx/setup-spi.c                  |    6 +--
 arch/arm/mach-s3c24xx/setup-ts.c                   |    2 +-
 arch/arm/mach-s3c24xx/simtec-audio.c               |   14 +++---
 arch/arm/mach-s3c24xx/simtec-nor.c                 |    6 +--
 arch/arm/mach-s3c24xx/simtec-pm.c                  |   10 ++--
 arch/arm/mach-s3c24xx/simtec-usb.c                 |   10 ++--
 arch/arm/mach-s3c24xx/sleep-s3c2410.S              |   12 ++---
 arch/arm/mach-s3c24xx/sleep-s3c2412.S              |    6 +--
 arch/arm/mach-s3c24xx/sleep.S                      |   12 ++---
 arch/arm/mach-s3c64xx/clock.c                      |   24 +++++-----
 arch/arm/mach-s3c64xx/common.c                     |   28 ++++++------
 arch/arm/mach-s3c64xx/cpuidle.c                    |    6 +--
 arch/arm/mach-s3c64xx/dev-audio.c                  |   12 ++---
 arch/arm/mach-s3c64xx/dev-uart.c                   |    6 +--
 arch/arm/mach-s3c64xx/dma.c                        |    8 ++--
 .../include/mach-s3c64xx/debug-macro.S             |    6 +--
 arch/arm/mach-s3c64xx/include/mach-s3c64xx/dma.h   |    4 +-
 arch/arm/mach-s3c64xx/include/mach-s3c64xx/map.h   |    4 +-
 .../mach-s3c64xx/include/mach-s3c64xx/pm-core.h    |    2 +-
 .../mach-s3c64xx/include/mach-s3c64xx/uncompress.h |    4 +-
 arch/arm/mach-s3c64xx/irq-pm.c                     |   12 ++---
 arch/arm/mach-s3c64xx/mach-anw6410.c               |   22 ++++-----
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    4 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |   48 ++++++++++----------
 arch/arm/mach-s3c64xx/mach-hmt.c                   |   20 ++++----
 arch/arm/mach-s3c64xx/mach-mini6410.c              |   26 +++++------
 arch/arm/mach-s3c64xx/mach-ncp.c                   |   18 ++++----
 arch/arm/mach-s3c64xx/mach-real6410.c              |   26 +++++------
 arch/arm/mach-s3c64xx/mach-smartq.c                |   28 ++++++------
 arch/arm/mach-s3c64xx/mach-smartq5.c               |   16 +++----
 arch/arm/mach-s3c64xx/mach-smartq7.c               |   16 +++----
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |   14 +++---
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |   40 ++++++++--------
 arch/arm/mach-s3c64xx/pm.c                         |   26 +++++------
 arch/arm/mach-s3c64xx/s3c6400.c                    |   20 ++++----
 arch/arm/mach-s3c64xx/s3c6410.c                    |   26 +++++------
 arch/arm/mach-s3c64xx/setup-fb-24bpp.c             |    4 +-
 arch/arm/mach-s3c64xx/setup-i2c0.c                 |    4 +-
 arch/arm/mach-s3c64xx/setup-i2c1.c                 |    4 +-
 arch/arm/mach-s3c64xx/setup-ide.c                  |    8 ++--
 arch/arm/mach-s3c64xx/setup-keypad.c               |    4 +-
 arch/arm/mach-s3c64xx/setup-sdhci-gpio.c           |    4 +-
 arch/arm/mach-s3c64xx/setup-spi.c                  |    2 +-
 arch/arm/mach-s3c64xx/setup-usb-phy.c              |   10 ++--
 arch/arm/mach-s3c64xx/sleep.S                      |    4 +-
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |   22 ++++-----
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |   22 ++++-----
 arch/arm/mach-s5p64x0/clock.c                      |   20 ++++----
 arch/arm/mach-s5p64x0/common.c                     |   32 ++++++-------
 arch/arm/mach-s5p64x0/dev-audio.c                  |   10 ++--
 arch/arm/mach-s5p64x0/dma.c                        |   14 +++---
 arch/arm/mach-s5p64x0/gpiolib.c                    |   16 +++----
 .../include/mach-s5p64x0/debug-macro.S             |    8 ++--
 arch/arm/mach-s5p64x0/include/mach-s5p64x0/dma.h   |    2 +-
 arch/arm/mach-s5p64x0/include/mach-s5p64x0/irqs.h  |    2 +-
 arch/arm/mach-s5p64x0/include/mach-s5p64x0/map.h   |    4 +-
 .../mach-s5p64x0/include/mach-s5p64x0/pm-core.h    |    2 +-
 .../mach-s5p64x0/include/mach-s5p64x0/regs-clock.h |    2 +-
 .../mach-s5p64x0/include/mach-s5p64x0/regs-gpio.h  |    2 +-
 .../mach-s5p64x0/include/mach-s5p64x0/regs-irq.h   |    2 +-
 .../mach-s5p64x0/include/mach-s5p64x0/uncompress.h |    6 +--
 arch/arm/mach-s5p64x0/irq-pm.c                     |    6 +--
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |   40 ++++++++--------
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |   40 ++++++++--------
 arch/arm/mach-s5p64x0/pm.c                         |   12 ++---
 arch/arm/mach-s5p64x0/setup-fb-24bpp.c             |    6 +--
 arch/arm/mach-s5p64x0/setup-i2c0.c                 |    6 +--
 arch/arm/mach-s5p64x0/setup-i2c1.c                 |    6 +--
 arch/arm/mach-s5p64x0/setup-sdhci-gpio.c           |   10 ++--
 arch/arm/mach-s5p64x0/setup-spi.c                  |    2 +-
 arch/arm/mach-s5pc100/clock.c                      |   18 ++++----
 arch/arm/mach-s5pc100/common.c                     |   30 ++++++------
 arch/arm/mach-s5pc100/dev-audio.c                  |   10 ++--
 arch/arm/mach-s5pc100/dma.c                        |   10 ++--
 .../include/mach-s5pc100/debug-macro.S             |    6 +--
 arch/arm/mach-s5pc100/include/mach-s5pc100/dma.h   |    2 +-
 arch/arm/mach-s5pc100/include/mach-s5pc100/irqs.h  |    2 +-
 arch/arm/mach-s5pc100/include/mach-s5pc100/map.h   |    4 +-
 .../mach-s5pc100/include/mach-s5pc100/regs-clock.h |    2 +-
 .../mach-s5pc100/include/mach-s5pc100/regs-gpio.h  |    2 +-
 .../mach-s5pc100/include/mach-s5pc100/regs-irq.h   |    2 +-
 .../mach-s5pc100/include/mach-s5pc100/uncompress.h |    4 +-
 arch/arm/mach-s5pc100/mach-smdkc100.c              |   34 +++++++-------
 arch/arm/mach-s5pc100/setup-fb-24bpp.c             |    6 +--
 arch/arm/mach-s5pc100/setup-i2c0.c                 |    4 +-
 arch/arm/mach-s5pc100/setup-i2c1.c                 |    4 +-
 arch/arm/mach-s5pc100/setup-ide.c                  |    4 +-
 arch/arm/mach-s5pc100/setup-keypad.c               |    2 +-
 arch/arm/mach-s5pc100/setup-sdhci-gpio.c           |    6 +--
 arch/arm/mach-s5pc100/setup-spi.c                  |    2 +-
 arch/arm/mach-s5pv210/clock.c                      |   18 ++++----
 arch/arm/mach-s5pv210/common.c                     |   30 ++++++------
 arch/arm/mach-s5pv210/dev-audio.c                  |   12 ++---
 arch/arm/mach-s5pv210/dma.c                        |   10 ++--
 .../include/mach-s5pv210/debug-macro.S             |    6 +--
 arch/arm/mach-s5pv210/include/mach-s5pv210/dma.h   |    2 +-
 arch/arm/mach-s5pv210/include/mach-s5pv210/irqs.h  |    2 +-
 arch/arm/mach-s5pv210/include/mach-s5pv210/map.h   |    4 +-
 .../mach-s5pv210/include/mach-s5pv210/regs-clock.h |    2 +-
 .../mach-s5pv210/include/mach-s5pv210/regs-gpio.h  |    2 +-
 .../mach-s5pv210/include/mach-s5pv210/regs-irq.h   |    2 +-
 .../mach-s5pv210/include/mach-s5pv210/uncompress.h |    4 +-
 arch/arm/mach-s5pv210/mach-aquila.c                |   24 +++++-----
 arch/arm/mach-s5pv210/mach-goni.c                  |   32 ++++++-------
 arch/arm/mach-s5pv210/mach-smdkc110.c              |   22 ++++-----
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   40 ++++++++--------
 arch/arm/mach-s5pv210/mach-torbreck.c              |   16 +++----
 arch/arm/mach-s5pv210/pm.c                         |   10 ++--
 arch/arm/mach-s5pv210/setup-fb-24bpp.c             |    8 ++--
 arch/arm/mach-s5pv210/setup-fimc.c                 |    4 +-
 arch/arm/mach-s5pv210/setup-i2c0.c                 |    4 +-
 arch/arm/mach-s5pv210/setup-i2c1.c                 |    4 +-
 arch/arm/mach-s5pv210/setup-i2c2.c                 |    4 +-
 arch/arm/mach-s5pv210/setup-ide.c                  |    2 +-
 arch/arm/mach-s5pv210/setup-keypad.c               |    2 +-
 arch/arm/mach-s5pv210/setup-sdhci-gpio.c           |    6 +--
 arch/arm/mach-s5pv210/setup-spi.c                  |    2 +-
 arch/arm/mach-s5pv210/setup-usb-phy.c              |   10 ++--
 arch/arm/mach-sa1100/assabet.c                     |    8 ++--
 arch/arm/mach-sa1100/badge4.c                      |    6 +--
 arch/arm/mach-sa1100/cerf.c                        |    8 ++--
 arch/arm/mach-sa1100/clock.c                       |    2 +-
 arch/arm/mach-sa1100/collie.c                      |    8 ++--
 arch/arm/mach-sa1100/cpu-sa1100.c                  |    2 +-
 arch/arm/mach-sa1100/cpu-sa1110.c                  |    2 +-
 arch/arm/mach-sa1100/generic.c                     |    4 +-
 arch/arm/mach-sa1100/h3100.c                       |    4 +-
 arch/arm/mach-sa1100/h3600.c                       |    4 +-
 arch/arm/mach-sa1100/h3xxx.c                       |    2 +-
 arch/arm/mach-sa1100/hackkit.c                     |    4 +-
 arch/arm/mach-sa1100/include/mach-sa1100/SA-1101.h |    2 +-
 arch/arm/mach-sa1100/include/mach-sa1100/badge4.h  |    2 +-
 .../mach-sa1100/include/mach-sa1100/debug-macro.S  |    2 +-
 arch/arm/mach-sa1100/include/mach-sa1100/gpio.h    |    2 +-
 arch/arm/mach-sa1100/include/mach-sa1100/mtd-xip.h |    2 +-
 .../mach-sa1100/include/mach-sa1100/nanoengine.h   |    2 +-
 arch/arm/mach-sa1100/irq.c                         |    4 +-
 arch/arm/mach-sa1100/jornada720.c                  |    4 +-
 arch/arm/mach-sa1100/jornada720_ssp.c              |    4 +-
 arch/arm/mach-sa1100/lart.c                        |    6 +--
 arch/arm/mach-sa1100/leds-assabet.c                |    4 +-
 arch/arm/mach-sa1100/leds-badge4.c                 |    2 +-
 arch/arm/mach-sa1100/leds-cerf.c                   |    2 +-
 arch/arm/mach-sa1100/leds-hackkit.c                |    2 +-
 arch/arm/mach-sa1100/leds-lart.c                   |    2 +-
 arch/arm/mach-sa1100/nanoengine.c                  |    6 +--
 arch/arm/mach-sa1100/neponset.c                    |    8 ++--
 arch/arm/mach-sa1100/pci-nanoengine.c              |    4 +-
 arch/arm/mach-sa1100/pleb.c                        |    4 +-
 arch/arm/mach-sa1100/pm.c                          |    2 +-
 arch/arm/mach-sa1100/shannon.c                     |    8 ++--
 arch/arm/mach-sa1100/simpad.c                      |    8 ++--
 arch/arm/mach-sa1100/sleep.S                       |    2 +-
 arch/arm/mach-sa1100/ssp.c                         |    4 +-
 arch/arm/mach-sa1100/time.c                        |    4 +-
 arch/arm/mach-shmobile/board-ag5evm.c              |    8 ++--
 arch/arm/mach-shmobile/board-ap4evb.c              |    6 +--
 arch/arm/mach-shmobile/board-armadillo800eva.c     |    6 +--
 arch/arm/mach-shmobile/board-bonito.c              |    6 +--
 arch/arm/mach-shmobile/board-g3evm.c               |    6 +--
 arch/arm/mach-shmobile/board-g4evm.c               |    6 +--
 arch/arm/mach-shmobile/board-kota2.c               |    8 ++--
 arch/arm/mach-shmobile/board-kzm9d.c               |    4 +-
 arch/arm/mach-shmobile/board-kzm9g.c               |    6 +--
 arch/arm/mach-shmobile/board-mackerel.c            |    6 +--
 arch/arm/mach-shmobile/board-marzen.c              |    8 ++--
 arch/arm/mach-shmobile/clock-emev2.c               |    2 +-
 arch/arm/mach-shmobile/clock-r8a7740.c             |    4 +-
 arch/arm/mach-shmobile/clock-r8a7779.c             |    2 +-
 arch/arm/mach-shmobile/clock-sh7367.c              |    2 +-
 arch/arm/mach-shmobile/clock-sh7372.c              |    2 +-
 arch/arm/mach-shmobile/clock-sh7377.c              |    2 +-
 arch/arm/mach-shmobile/clock-sh73a0.c              |    2 +-
 arch/arm/mach-shmobile/common.c                    |    2 +-
 arch/arm/mach-shmobile/console.c                   |    2 +-
 arch/arm/mach-shmobile/hotplug.c                   |    2 +-
 .../mach-shmobile/include/mach-shmobile/r8a7740.h  |    2 +-
 .../mach-shmobile/include/mach-shmobile/sh7372.h   |    2 +-
 .../mach-shmobile/include/mach-shmobile/zboot.h    |    2 +-
 arch/arm/mach-shmobile/intc-r8a7740.c              |    4 +-
 arch/arm/mach-shmobile/intc-r8a7779.c              |    6 +--
 arch/arm/mach-shmobile/intc-sh7367.c               |    4 +-
 arch/arm/mach-shmobile/intc-sh7372.c               |    4 +-
 arch/arm/mach-shmobile/intc-sh7377.c               |    4 +-
 arch/arm/mach-shmobile/intc-sh73a0.c               |    6 +--
 arch/arm/mach-shmobile/pfc-r8a7740.c               |    4 +-
 arch/arm/mach-shmobile/pfc-r8a7779.c               |    2 +-
 arch/arm/mach-shmobile/pfc-sh7367.c                |    2 +-
 arch/arm/mach-shmobile/pfc-sh7372.c                |    4 +-
 arch/arm/mach-shmobile/pfc-sh7377.c                |    2 +-
 arch/arm/mach-shmobile/pfc-sh73a0.c                |    4 +-
 arch/arm/mach-shmobile/platsmp.c                   |    4 +-
 arch/arm/mach-shmobile/pm-r8a7740.c                |    2 +-
 arch/arm/mach-shmobile/pm-r8a7779.c                |    4 +-
 arch/arm/mach-shmobile/pm-rmobile.c                |    2 +-
 arch/arm/mach-shmobile/pm-sh7372.c                 |    6 +--
 arch/arm/mach-shmobile/setup-emev2.c               |    8 ++--
 arch/arm/mach-shmobile/setup-r8a7740.c             |   10 ++--
 arch/arm/mach-shmobile/setup-r8a7779.c             |    8 ++--
 arch/arm/mach-shmobile/setup-sh7367.c              |    6 +--
 arch/arm/mach-shmobile/setup-sh7372.c              |   10 ++--
 arch/arm/mach-shmobile/setup-sh7377.c              |    6 +--
 arch/arm/mach-shmobile/setup-sh73a0.c              |   10 ++--
 arch/arm/mach-shmobile/smp-emev2.c                 |    4 +-
 arch/arm/mach-shmobile/smp-r8a7779.c               |    4 +-
 arch/arm/mach-shmobile/smp-sh73a0.c                |    2 +-
 .../include/mach-spear13xx/debug-macro.S           |    2 +-
 .../mach-spear13xx/include/mach-spear13xx/gpio.h   |    2 +-
 .../mach-spear13xx/include/mach-spear13xx/timex.h  |    2 +-
 .../include/mach-spear13xx/uncompress.h            |    2 +-
 arch/arm/mach-spear13xx/platsmp.c                  |    2 +-
 arch/arm/mach-spear13xx/spear1310.c                |    4 +-
 arch/arm/mach-spear13xx/spear1340.c                |    6 +--
 arch/arm/mach-spear13xx/spear13xx.c                |    6 +--
 .../include/mach-spear3xx/debug-macro.S            |    2 +-
 .../arm/mach-spear3xx/include/mach-spear3xx/gpio.h |    2 +-
 .../include/mach-spear3xx/misc_regs.h              |    2 +-
 .../mach-spear3xx/include/mach-spear3xx/timex.h    |    2 +-
 .../include/mach-spear3xx/uncompress.h             |    2 +-
 arch/arm/mach-spear3xx/spear300.c                  |    6 +--
 arch/arm/mach-spear3xx/spear310.c                  |    6 +--
 arch/arm/mach-spear3xx/spear320.c                  |    6 +--
 arch/arm/mach-spear3xx/spear3xx.c                  |    6 +--
 .../include/mach-spear6xx/debug-macro.S            |    2 +-
 .../arm/mach-spear6xx/include/mach-spear6xx/gpio.h |    2 +-
 .../include/mach-spear6xx/misc_regs.h              |    2 +-
 .../mach-spear6xx/include/mach-spear6xx/timex.h    |    2 +-
 .../include/mach-spear6xx/uncompress.h             |    2 +-
 arch/arm/mach-spear6xx/spear6xx.c                  |    6 +--
 arch/arm/mach-tegra/apbio.c                        |    4 +-
 arch/arm/mach-tegra/board-dt-tegra20.c             |    4 +-
 arch/arm/mach-tegra/board-dt-tegra30.c             |    2 +-
 arch/arm/mach-tegra/board-harmony-power.c          |    2 +-
 arch/arm/mach-tegra/board-harmony.c                |    8 ++--
 arch/arm/mach-tegra/board-harmony.h                |    2 +-
 arch/arm/mach-tegra/board-paz00.c                  |    6 +--
 arch/arm/mach-tegra/board-paz00.h                  |    2 +-
 arch/arm/mach-tegra/board-pinmux.h                 |    2 +-
 arch/arm/mach-tegra/board-trimslice.c              |    4 +-
 arch/arm/mach-tegra/board-trimslice.h              |    2 +-
 arch/arm/mach-tegra/clock.c                        |    2 +-
 arch/arm/mach-tegra/clock.h                        |    2 +-
 arch/arm/mach-tegra/common.c                       |    4 +-
 arch/arm/mach-tegra/cpu-tegra.c                    |    2 +-
 arch/arm/mach-tegra/cpuidle.c                      |    2 +-
 arch/arm/mach-tegra/devices.c                      |    8 ++--
 arch/arm/mach-tegra/devices.h                      |    2 +-
 arch/arm/mach-tegra/dma.c                          |    8 ++--
 arch/arm/mach-tegra/flowctrl.c                     |    2 +-
 arch/arm/mach-tegra/fuse.c                         |    2 +-
 arch/arm/mach-tegra/headsmp.S                      |    2 +-
 .../mach-tegra/include/mach-tegra/debug-macro.S    |    4 +-
 .../arm/mach-tegra/include/mach-tegra/gpio-tegra.h |    2 +-
 .../arm/mach-tegra/include/mach-tegra/uncompress.h |    4 +-
 arch/arm/mach-tegra/io.c                           |    2 +-
 arch/arm/mach-tegra/irq.c                          |    2 +-
 arch/arm/mach-tegra/pcie.c                         |    6 +--
 arch/arm/mach-tegra/platsmp.c                      |    6 +--
 arch/arm/mach-tegra/pmc.c                          |    2 +-
 arch/arm/mach-tegra/powergate.c                    |    6 +--
 arch/arm/mach-tegra/reset.c                        |    4 +-
 arch/arm/mach-tegra/sleep.S                        |    2 +-
 arch/arm/mach-tegra/tegra2_clocks.c                |    4 +-
 arch/arm/mach-tegra/tegra2_emc.c                   |    2 +-
 arch/arm/mach-tegra/tegra30_clocks.c               |    2 +-
 arch/arm/mach-tegra/timer.c                        |    6 +--
 arch/arm/mach-tegra/usb_phy.c                      |    6 +--
 arch/arm/mach-u300/core.c                          |   10 ++--
 arch/arm/mach-u300/i2c.c                           |    2 +-
 arch/arm/mach-u300/include/mach-u300/debug-macro.S |    2 +-
 arch/arm/mach-u300/include/mach-u300/hardware.h    |    2 +-
 arch/arm/mach-u300/regulator.c                     |    4 +-
 arch/arm/mach-u300/spi.c                           |    4 +-
 arch/arm/mach-u300/timer.c                         |    2 +-
 arch/arm/mach-u300/u300.c                          |    4 +-
 arch/arm/mach-ux500/board-mop500-msp.c             |   16 +++----
 arch/arm/mach-ux500/board-mop500-pins.c            |    6 +--
 arch/arm/mach-ux500/board-mop500-sdi.c             |    6 +--
 arch/arm/mach-ux500/board-mop500-u8500uib.c        |    2 +-
 arch/arm/mach-ux500/board-mop500-uib.c             |    2 +-
 arch/arm/mach-ux500/board-mop500.c                 |   16 +++----
 arch/arm/mach-ux500/board-mop500.h                 |    2 +-
 arch/arm/mach-ux500/cache-l2x0.c                   |    4 +-
 arch/arm/mach-ux500/clock.c                        |    4 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |   12 ++---
 arch/arm/mach-ux500/cpu.c                          |    6 +--
 arch/arm/mach-ux500/devices-common.c               |    4 +-
 arch/arm/mach-ux500/devices-common.h               |    2 +-
 arch/arm/mach-ux500/devices-db8500.c               |    6 +--
 arch/arm/mach-ux500/devices.c                      |    4 +-
 arch/arm/mach-ux500/id.c                           |    4 +-
 .../mach-ux500/include/mach-ux500/crypto-ux500.h   |    2 +-
 .../mach-ux500/include/mach-ux500/debug-macro.S    |    2 +-
 arch/arm/mach-ux500/include/mach-ux500/hardware.h  |    4 +-
 arch/arm/mach-ux500/include/mach-ux500/irqs.h      |    6 +--
 arch/arm/mach-ux500/include/mach-ux500/msp.h       |    2 +-
 .../arm/mach-ux500/include/mach-ux500/uncompress.h |    2 +-
 arch/arm/mach-ux500/platsmp.c                      |    4 +-
 arch/arm/mach-ux500/timer.c                        |    8 ++--
 arch/arm/mach-ux500/usb.c                          |    6 +--
 arch/arm/mach-versatile/core.c                     |   10 ++--
 .../mach-versatile/include/mach-versatile/clkdev.h |    2 +-
 .../mach-versatile/include/mach-versatile/irqs.h   |    2 +-
 arch/arm/mach-versatile/pci.c                      |    2 +-
 arch/arm/mach-versatile/versatile_ab.c             |    2 +-
 arch/arm/mach-versatile/versatile_pb.c             |    2 +-
 arch/arm/mach-vexpress/ct-ca9x4.c                  |    6 +--
 arch/arm/mach-vexpress/platsmp.c                   |    2 +-
 arch/arm/mach-vexpress/v2m.c                       |    6 +--
 arch/arm/mach-vt8500/bv07.c                        |    2 +-
 arch/arm/mach-vt8500/devices-vt8500.c              |    6 +--
 arch/arm/mach-vt8500/devices-wm8505.c              |    6 +--
 arch/arm/mach-vt8500/devices.c                     |    4 +-
 arch/arm/mach-vt8500/wm8505_7in.c                  |    2 +-
 arch/arm/mach-w90x900/clksel.c                     |    4 +-
 arch/arm/mach-w90x900/clock.c                      |    2 +-
 arch/arm/mach-w90x900/cpu.c                        |   10 ++--
 arch/arm/mach-w90x900/dev.c                        |   12 ++---
 arch/arm/mach-w90x900/gpio.c                       |    2 +-
 .../include/mach-w90x900/entry-macro.S             |    4 +-
 arch/arm/mach-w90x900/include/mach-w90x900/gpio.h  |    2 +-
 .../mach-w90x900/include/mach-w90x900/hardware.h   |    2 +-
 .../mach-w90x900/include/mach-w90x900/regs-ldm.h   |    2 +-
 .../mach-w90x900/include/mach-w90x900/uncompress.h |    4 +-
 arch/arm/mach-w90x900/irq.c                        |    4 +-
 arch/arm/mach-w90x900/mach-nuc910evb.c             |    2 +-
 arch/arm/mach-w90x900/mach-nuc950evb.c             |    4 +-
 arch/arm/mach-w90x900/mach-nuc960evb.c             |    2 +-
 arch/arm/mach-w90x900/mfp.c                        |    2 +-
 arch/arm/mach-w90x900/nuc910.c                     |    2 +-
 arch/arm/mach-w90x900/nuc950.c                     |    2 +-
 arch/arm/mach-w90x900/nuc960.c                     |    2 +-
 arch/arm/mach-w90x900/time.c                       |    4 +-
 arch/arm/mach-zynq/common.c                        |    4 +-
 arch/arm/mach-zynq/include/mach-zynq/clkdev.h      |    2 +-
 arch/arm/mach-zynq/include/mach-zynq/debug-macro.S |    4 +-
 arch/arm/mach-zynq/include/mach-zynq/uncompress.h  |    4 +-
 arch/arm/mach-zynq/timer.c                         |    2 +-
 arch/arm/mm/cache-feroceon-l2.c                    |    2 +-
 arch/arm/plat-mxc/3ds_debugboard.c                 |    2 +-
 arch/arm/plat-mxc/avic.c                           |    6 +--
 arch/arm/plat-mxc/clock.c                          |    4 +-
 arch/arm/plat-mxc/cpu.c                            |    2 +-
 arch/arm/plat-mxc/cpufreq.c                        |    4 +-
 arch/arm/plat-mxc/devices.c                        |    2 +-
 arch/arm/plat-mxc/devices/platform-ahci-imx.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-fec.c           |    4 +-
 arch/arm/plat-mxc/devices/platform-flexcan.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.c  |    4 +-
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c      |    2 +-
 arch/arm/plat-mxc/devices/platform-gpio_keys.c     |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-dma.c       |    2 +-
 arch/arm/plat-mxc/devices/platform-imx-fb.c        |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-i2c.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-keypad.c    |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-ssi.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-uart.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-imx2-wdt.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-imx21-hcd.c     |    4 +-
 arch/arm/plat-mxc/devices/platform-imx_udc.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-imxdi_rtc.c     |    4 +-
 arch/arm/plat-mxc/devices/platform-ipu-core.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-mx1-camera.c    |    4 +-
 arch/arm/plat-mxc/devices/platform-mx2-camera.c    |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc-ehci.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc-mmc.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc_nand.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc_pwm.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc_rnga.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc_rtc.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc_w1.c        |    4 +-
 arch/arm/plat-mxc/devices/platform-pata_imx.c      |    4 +-
 .../plat-mxc/devices/platform-sdhci-esdhc-imx.c    |    6 +--
 arch/arm/plat-mxc/devices/platform-spi_imx.c       |    4 +-
 arch/arm/plat-mxc/epit.c                           |    4 +-
 arch/arm/plat-mxc/iomux-v1.c                       |    4 +-
 arch/arm/plat-mxc/iomux-v3.c                       |    4 +-
 arch/arm/plat-mxc/iram_alloc.c                     |    2 +-
 arch/arm/plat-mxc/ssi-fiq-ksym.c                   |    2 +-
 arch/arm/plat-mxc/system.c                         |    4 +-
 arch/arm/plat-mxc/time.c                           |    4 +-
 arch/arm/plat-mxc/tzic.c                           |    6 +--
 arch/arm/plat-mxc/ulpi.c                           |    2 +-
 arch/arm/plat-omap/clock.c                         |    2 +-
 arch/arm/plat-omap/common.c                        |   12 ++---
 arch/arm/plat-omap/counter_32k.c                   |    8 ++--
 arch/arm/plat-omap/debug-devices.c                 |    2 +-
 arch/arm/plat-omap/debug-leds.c                    |    2 +-
 arch/arm/plat-omap/devices.c                       |   10 ++--
 arch/arm/plat-omap/dma.c                           |    4 +-
 arch/arm/plat-omap/dmtimer.c                       |    4 +-
 arch/arm/plat-omap/fb.c                            |    2 +-
 arch/arm/plat-omap/i2c.c                           |    8 ++--
 arch/arm/plat-omap/include/plat-omap/board.h       |    2 +-
 arch/arm/plat-omap/include/plat-omap/common.h      |    4 +-
 arch/arm/plat-omap/include/plat-omap/cpu.h         |    2 +-
 arch/arm/plat-omap/include/plat-omap/dma.h         |    2 +-
 arch/arm/plat-omap/include/plat-omap/hardware.h    |   22 ++++-----
 arch/arm/plat-omap/include/plat-omap/hdq1w.h       |    2 +-
 arch/arm/plat-omap/include/plat-omap/iommu.h       |    2 +-
 arch/arm/plat-omap/include/plat-omap/mmc.h         |    4 +-
 arch/arm/plat-omap/include/plat-omap/nand.h        |    2 +-
 arch/arm/plat-omap/include/plat-omap/omap-serial.h |    2 +-
 arch/arm/plat-omap/include/plat-omap/omap_device.h |    2 +-
 arch/arm/plat-omap/include/plat-omap/omap_hwmod.h  |    2 +-
 arch/arm/plat-omap/include/plat-omap/uncompress.h  |    2 +-
 arch/arm/plat-omap/include/plat-omap/usb.h         |    2 +-
 arch/arm/plat-omap/mailbox.c                       |    2 +-
 arch/arm/plat-omap/mux.c                           |    4 +-
 arch/arm/plat-omap/omap-pm-noop.c                  |    4 +-
 arch/arm/plat-omap/omap_device.c                   |    6 +--
 arch/arm/plat-omap/sram.c                          |    6 +--
 arch/arm/plat-orion/addr-map.c                     |    2 +-
 arch/arm/plat-orion/common.c                       |    4 +-
 arch/arm/plat-orion/gpio.c                         |    2 +-
 arch/arm/plat-orion/irq.c                          |    4 +-
 arch/arm/plat-orion/mpp.c                          |    2 +-
 arch/arm/plat-orion/pcie.c                         |    4 +-
 arch/arm/plat-pxa/mfp.c                            |    2 +-
 arch/arm/plat-s3c24xx/clock-dclk.c                 |    8 ++--
 arch/arm/plat-s3c24xx/cpu-freq-debugfs.c           |    2 +-
 arch/arm/plat-s3c24xx/cpu-freq.c                   |    8 ++--
 arch/arm/plat-s3c24xx/dma.c                        |   10 ++--
 arch/arm/plat-s3c24xx/irq.c                        |    8 ++--
 arch/arm/plat-s3c24xx/s3c2410-clock.c              |   14 +++---
 arch/arm/plat-s3c24xx/s3c2410-cpufreq-utils.c      |    8 ++--
 arch/arm/plat-s3c24xx/s3c2410-iotiming.c           |    8 ++--
 arch/arm/plat-s3c24xx/s3c2412-iotiming.c           |    8 ++--
 arch/arm/plat-samsung/adc.c                        |    4 +-
 arch/arm/plat-samsung/clock-clksrc.c               |    6 +--
 arch/arm/plat-samsung/clock.c                      |    8 ++--
 arch/arm/plat-samsung/cpu.c                        |    2 +-
 arch/arm/plat-samsung/dev-backlight.c              |    6 +--
 arch/arm/plat-samsung/dev-uart.c                   |    2 +-
 arch/arm/plat-samsung/devs.c                       |   42 ++++++++---------
 .../include/plat-samsung/cpu-freq-core.h           |    2 +-
 .../include/plat-samsung/debug-macro.S             |    2 +-
 .../plat-samsung/include/plat-samsung/dma-pl330.h  |    2 +-
 .../include/plat-samsung/dma-s3c24xx.h             |    2 +-
 arch/arm/plat-samsung/include/plat-samsung/dma.h   |    2 +-
 .../plat-samsung/include/plat-samsung/gpio-core.h  |    2 +-
 .../plat-samsung/include/plat-samsung/gpio-fns.h   |    2 +-
 .../plat-samsung/include/plat-samsung/map-s3c.h    |    2 +-
 .../plat-samsung/include/plat-samsung/map-s5p.h    |    2 +-
 .../plat-samsung/include/plat-samsung/regs-fb-v4.h |    2 +-
 arch/arm/plat-samsung/include/plat-samsung/sdhci.h |    2 +-
 .../plat-samsung/include/plat-samsung/uncompress.h |    4 +-
 .../include/plat-samsung/watchdog-reset.h          |    4 +-
 arch/arm/plat-samsung/init.c                       |    8 ++--
 arch/arm/plat-samsung/irq-vic-timer.c              |    6 +--
 arch/arm/plat-samsung/platformdata.c               |    4 +-
 arch/arm/plat-samsung/pm-check.c                   |    2 +-
 arch/arm/plat-samsung/pm-gpio.c                    |    4 +-
 arch/arm/plat-samsung/pm.c                         |    4 +-
 arch/arm/plat-samsung/pwm-clock.c                  |    8 ++--
 arch/arm/plat-samsung/s5p-clock.c                  |    6 +--
 arch/arm/plat-samsung/s5p-dev-mfc.c                |    6 +--
 arch/arm/plat-samsung/s5p-dev-uart.c               |    2 +-
 arch/arm/plat-samsung/s5p-irq-eint.c               |    8 ++--
 arch/arm/plat-samsung/s5p-irq-gpioint.c            |    4 +-
 arch/arm/plat-samsung/s5p-irq-pm.c                 |    6 +--
 arch/arm/plat-samsung/s5p-irq.c                    |    6 +--
 arch/arm/plat-samsung/s5p-pm.c                     |    2 +-
 arch/arm/plat-samsung/s5p-time.c                   |    6 +--
 arch/arm/plat-samsung/time.c                       |    6 +--
 arch/arm/plat-samsung/wakeup-mask.c                |    4 +-
 arch/arm/plat-spear/shirq.c                        |    2 +-
 arch/arm/plat-versatile/clcd.c                     |    2 +-
 arch/arm/plat-versatile/fpga-irq.c                 |    2 +-
 arch/arm/plat-versatile/sched-clock.c              |    2 +-
 drivers/ata/pata_at91.c                            |    4 +-
 drivers/ata/pata_palmld.c                          |    2 +-
 drivers/ata/pata_pxa.c                             |    6 +--
 drivers/ata/pata_samsung_cf.c                      |    4 +-
 drivers/char/hw_random/omap-rng.c                  |    2 +-
 drivers/char/msm_smd_pkt.c                         |    2 +-
 drivers/clk/clk-u300.c                             |    2 +-
 drivers/clk/mxs/clk-imx23.c                        |    4 +-
 drivers/clk/mxs/clk-imx28.c                        |    4 +-
 drivers/clocksource/clksrc-dbx500-prcmu.c          |    4 +-
 drivers/cpufreq/exynos-cpufreq.c                   |    2 +-
 drivers/cpufreq/omap-cpufreq.c                     |    8 ++--
 drivers/crypto/ixp4xx_crypto.c                     |    4 +-
 drivers/crypto/omap-aes.c                          |    4 +-
 drivers/crypto/omap-sham.c                         |    4 +-
 drivers/crypto/s5p-sss.c                           |    4 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |    6 +--
 drivers/crypto/ux500/hash/hash_core.c              |    4 +-
 drivers/devfreq/exynos4_bus.c                      |    2 +-
 drivers/dma/at_hdmac_regs.h                        |    2 +-
 drivers/dma/coh901318.c                            |    2 +-
 drivers/dma/coh901318_lli.c                        |    2 +-
 drivers/dma/coh901318_lli.h                        |    2 +-
 drivers/dma/imx-sdma.c                             |    6 +--
 drivers/dma/ipu/ipu_idmac.c                        |    2 +-
 drivers/dma/ipu/ipu_irq.c                          |    2 +-
 drivers/dma/mmp_tdma.c                             |    4 +-
 drivers/dma/mv_xor.c                               |    2 +-
 drivers/dma/omap-dma.c                             |    2 +-
 drivers/dma/ste_dma40.c                            |    2 +-
 drivers/dma/ste_dma40_ll.c                         |    2 +-
 drivers/gpio/gpio-ep93xx.c                         |    4 +-
 drivers/gpio/gpio-ks8695.c                         |    6 +--
 drivers/gpio/gpio-lpc32xx.c                        |    8 ++--
 drivers/gpio/gpio-msm-v1.c                         |    6 +--
 drivers/gpio/gpio-msm-v2.c                         |    4 +-
 drivers/gpio/gpio-samsung.c                        |   12 ++---
 drivers/gpio/gpio-tegra.c                          |    4 +-
 drivers/gpio/gpio-tnetv107x.c                      |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |    2 +-
 drivers/hwmon/s3c-hwmon.c                          |    4 +-
 drivers/i2c/busses/i2c-at91.c                      |    6 +--
 drivers/i2c/busses/i2c-s3c2410.c                   |    4 +-
 drivers/iio/adc/at91_adc.c                         |    2 +-
 drivers/input/keyboard/davinci_keyscan.c           |    6 +--
 drivers/input/keyboard/ep93xx_keypad.c             |    4 +-
 drivers/input/keyboard/jornada720_kbd.c            |    6 +--
 drivers/input/keyboard/nomadik-ske-keypad.c        |    2 +-
 drivers/input/keyboard/omap-keypad.c               |    6 +--
 drivers/input/keyboard/pxa27x_keypad.c             |    2 +-
 drivers/input/keyboard/pxa930_rotary.c             |    2 +-
 drivers/input/keyboard/spear-keyboard.c            |    2 +-
 drivers/input/keyboard/tegra-kbc.c                 |    4 +-
 drivers/input/keyboard/w90p910_keypad.c            |    2 +-
 drivers/input/mouse/pxa930_trkball.c               |    4 +-
 drivers/input/serio/ams_delta_serio.c              |    4 +-
 drivers/input/touchscreen/jornada720_ts.c          |    6 +--
 drivers/input/touchscreen/s3c2410_ts.c             |    6 +--
 drivers/input/touchscreen/tnetv107x-ts.c           |    2 +-
 drivers/iommu/exynos-iommu.c                       |    2 +-
 drivers/iommu/msm_iommu.c                          |    4 +-
 drivers/iommu/msm_iommu_dev.c                      |    6 +--
 drivers/iommu/omap-iommu-debug.c                   |    6 +--
 drivers/iommu/omap-iommu.c                         |    4 +-
 drivers/iommu/omap-iovmm.c                         |    6 +--
 drivers/iommu/tegra-smmu.c                         |    6 +--
 drivers/leds/leds-netxbig.c                        |    2 +-
 drivers/leds/leds-ns2.c                            |    2 +-
 drivers/leds/leds-s3c24xx.c                        |    6 +--
 drivers/media/video/davinci/isif.c                 |    2 +-
 drivers/media/video/davinci/vpbe_display.c         |    2 +-
 drivers/media/video/davinci/vpbe_osd.c             |    4 +-
 drivers/media/video/davinci/vpbe_venc.c            |    6 +--
 drivers/media/video/davinci/vpif.c                 |    2 +-
 drivers/media/video/davinci/vpss.c                 |    2 +-
 drivers/media/video/mx1_camera.c                   |    8 ++--
 drivers/media/video/mx2_camera.c                   |    4 +-
 drivers/media/video/mx3_camera.c                   |    6 +--
 drivers/media/video/omap/omap_vout.c               |    4 +-
 drivers/media/video/omap/omap_vout_vrfb.c          |    4 +-
 drivers/media/video/omap/omap_voutdef.h            |    2 +-
 drivers/media/video/omap/omap_voutlib.c            |    2 +-
 drivers/media/video/omap1_camera.c                 |    2 +-
 drivers/media/video/omap3isp/isp.h                 |    4 +-
 drivers/media/video/omap3isp/ispreg.h              |    2 +-
 drivers/media/video/omap3isp/ispstat.h             |    2 +-
 drivers/media/video/omap3isp/ispvideo.c            |    6 +--
 drivers/media/video/s5p-fimc/mipi-csis.c           |    2 +-
 drivers/media/video/s5p-tv/sii9234_drv.c           |    2 +-
 drivers/mfd/db8500-prcmu.c                         |    8 ++--
 drivers/mfd/mcp-sa11x0.c                           |    4 +-
 drivers/mfd/menelaus.c                             |    2 +-
 drivers/mfd/omap-usb-host.c                        |    4 +-
 drivers/mfd/ucb1x00-ts.c                           |    2 +-
 drivers/mmc/host/davinci_mmc.c                     |    4 +-
 drivers/mmc/host/msm_sdcc.c                        |    8 ++--
 drivers/mmc/host/mvsdio.c                          |    2 +-
 drivers/mmc/host/omap.c                            |   10 ++--
 drivers/mmc/host/omap_hsmmc.c                      |    6 +--
 drivers/mmc/host/s3cmci.c                          |    6 +--
 drivers/mmc/host/sdhci-cns3xxx.c                   |    2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |    2 +-
 drivers/mmc/host/sdhci-s3c.c                       |    4 +-
 drivers/mmc/host/sdhci-tegra.c                     |    4 +-
 drivers/mtd/maps/autcpu12-nvram.c                  |    4 +-
 drivers/mtd/nand/ams-delta.c                       |    2 +-
 drivers/mtd/nand/autcpu12.c                        |    4 +-
 drivers/mtd/nand/bcm_umi_nand.c                    |    8 ++--
 drivers/mtd/nand/cmx270_nand.c                     |    2 +-
 drivers/mtd/nand/davinci_nand.c                    |    4 +-
 drivers/mtd/nand/mxc_nand.c                        |    4 +-
 drivers/mtd/nand/nand_bcm_umi.c                    |    2 +-
 drivers/mtd/nand/nand_bcm_umi.h                    |    4 +-
 drivers/mtd/nand/nomadik_nand.c                    |    4 +-
 drivers/mtd/nand/omap2.c                           |    6 +--
 drivers/mtd/nand/orion_nand.c                      |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c                     |    2 +-
 drivers/mtd/nand/s3c2410.c                         |    4 +-
 drivers/mtd/onenand/omap2.c                        |    8 ++--
 drivers/mtd/onenand/samsung.c                      |    2 +-
 drivers/net/ethernet/cadence/at91_ether.c          |    4 +-
 drivers/net/ethernet/micrel/ks8695net.c            |    6 +--
 drivers/net/ethernet/netx-eth.c                    |   10 ++--
 drivers/net/ethernet/smsc/smc91x.h                 |    4 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |    6 +--
 drivers/net/wan/ixp4xx_hss.c                       |    4 +-
 drivers/pcmcia/at91_cf.c                           |    8 ++--
 drivers/pcmcia/omap_cf.c                           |    4 +-
 drivers/pcmcia/pxa2xx_balloon3.c                   |    2 +-
 drivers/pcmcia/pxa2xx_base.c                       |    6 +--
 drivers/pcmcia/pxa2xx_e740.c                       |    2 +-
 drivers/pcmcia/pxa2xx_hx4700.c                     |    2 +-
 drivers/pcmcia/pxa2xx_mainstone.c                  |    4 +-
 drivers/pcmcia/pxa2xx_palmld.c                     |    2 +-
 drivers/pcmcia/pxa2xx_palmtc.c                     |    2 +-
 drivers/pcmcia/pxa2xx_palmtx.c                     |    2 +-
 drivers/pcmcia/pxa2xx_trizeps4.c                   |    4 +-
 drivers/pcmcia/pxa2xx_viper.c                      |    2 +-
 drivers/pcmcia/pxa2xx_vpac270.c                    |    2 +-
 drivers/pcmcia/sa1100_assabet.c                    |    2 +-
 drivers/pcmcia/sa1100_cerf.c                       |    4 +-
 drivers/pcmcia/sa1100_h3600.c                      |    4 +-
 drivers/pcmcia/sa1100_nanoengine.c                 |    4 +-
 drivers/pcmcia/sa1100_shannon.c                    |    4 +-
 drivers/pcmcia/sa1100_simpad.c                     |    4 +-
 drivers/pcmcia/sa1111_badge4.c                     |    4 +-
 drivers/pcmcia/sa1111_lubbock.c                    |    4 +-
 drivers/pcmcia/sa1111_neponset.c                   |    4 +-
 drivers/pinctrl/pinctrl-coh901.c                   |    2 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |    4 +-
 drivers/pinctrl/pinctrl-nomadik.h                  |    2 +-
 drivers/pinctrl/pinctrl-tegra.c                    |    2 +-
 drivers/power/collie_battery.c                     |    2 +-
 drivers/power/s3c_adc_battery.c                    |    2 +-
 drivers/power/tosa_battery.c                       |    2 +-
 drivers/ptp/ptp_ixp46x.c                           |    2 +-
 drivers/pwm/pwm-samsung.c                          |    2 +-
 drivers/remoteproc/omap_remoteproc.c               |    4 +-
 drivers/rtc/rtc-at91rm9200.c                       |    2 +-
 drivers/rtc/rtc-at91sam9.c                         |    6 +--
 drivers/rtc/rtc-s3c.c                              |    2 +-
 drivers/spi/spi-davinci.c                          |    4 +-
 drivers/spi/spi-ep93xx.c                           |    4 +-
 drivers/spi/spi-nuc900.c                           |    2 +-
 drivers/spi/spi-omap-100k.c                        |    2 +-
 drivers/spi/spi-omap-uwire.c                       |    4 +-
 drivers/spi/spi-omap2-mcspi.c                      |    4 +-
 drivers/spi/spi-s3c24xx-fiq.S                      |    2 +-
 drivers/spi/spi-s3c24xx.c                          |    4 +-
 drivers/spi/spi-s3c64xx.c                          |    2 +-
 drivers/staging/nvec/nvec.c                        |    4 +-
 drivers/staging/omapdrm/omap_dmm_tiler.h           |    2 +-
 drivers/staging/tidspbridge/core/dsp-clock.c       |    4 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    2 +-
 drivers/staging/tidspbridge/core/tiomap_io.c       |    2 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |    2 +-
 .../tidspbridge/include/dspbridge/host_os.h        |    4 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 +-
 drivers/tty/serial/imx.c                           |    2 +-
 drivers/tty/serial/msm_smd_tty.c                   |    2 +-
 drivers/tty/serial/netx-serial.c                   |    4 +-
 drivers/tty/serial/omap-serial.c                   |    6 +--
 drivers/tty/serial/samsung.c                       |    4 +-
 drivers/usb/gadget/at91_udc.c                      |   10 ++--
 drivers/usb/gadget/atmel_usba_udc.c                |    4 +-
 drivers/usb/gadget/omap_udc.c                      |    2 +-
 drivers/usb/gadget/pxa25x_udc.c                    |    4 +-
 drivers/usb/gadget/pxa25x_udc.h                    |    2 +-
 drivers/usb/gadget/s3c-hsudc.c                     |    2 +-
 drivers/usb/gadget/s3c2410_udc.c                   |    4 +-
 drivers/usb/host/ehci-cns3xxx.c                    |    4 +-
 drivers/usb/host/ehci-mxc.c                        |    4 +-
 drivers/usb/host/ehci-omap.c                       |    2 +-
 drivers/usb/host/ehci-orion.c                      |    2 +-
 drivers/usb/host/ehci-s5p.c                        |    4 +-
 drivers/usb/host/ehci-tegra.c                      |    4 +-
 drivers/usb/host/imx21-hcd.h                       |    2 +-
 drivers/usb/host/ohci-cns3xxx.c                    |    4 +-
 drivers/usb/host/ohci-da8xx.c                      |    4 +-
 drivers/usb/host/ohci-exynos.c                     |    2 +-
 drivers/usb/host/ohci-omap.c                       |    4 +-
 drivers/usb/host/ohci-omap3.c                      |    2 +-
 drivers/usb/host/ohci-pxa27x.c                     |    6 +--
 drivers/usb/host/ohci-s3c2410.c                    |    2 +-
 drivers/usb/host/ohci-sa1111.c                     |    4 +-
 drivers/usb/musb/am35x.c                           |    2 +-
 drivers/usb/musb/da8xx.c                           |    4 +-
 drivers/usb/musb/musb_dsps.c                       |    2 +-
 drivers/usb/musb/omap2430.h                        |    2 +-
 drivers/usb/musb/tusb6010_omap.c                   |    4 +-
 drivers/usb/otg/isp1301_omap.c                     |    2 +-
 drivers/video/acornfb.c                            |    4 +-
 drivers/video/backlight/jornada720_bl.c            |    4 +-
 drivers/video/backlight/jornada720_lcd.c           |    4 +-
 drivers/video/backlight/omap1_bl.c                 |    4 +-
 drivers/video/backlight/tosa_bl.c                  |    2 +-
 drivers/video/backlight/tosa_lcd.c                 |    2 +-
 drivers/video/clps711xfb.c                         |    4 +-
 drivers/video/cyber2000fb.c                        |    2 +-
 drivers/video/exynos/exynos_mipi_dsi.c             |    2 +-
 drivers/video/exynos/exynos_mipi_dsi_common.c      |    2 +-
 drivers/video/exynos/exynos_mipi_dsi_lowlevel.c    |    2 +-
 drivers/video/imxfb.c                              |    4 +-
 drivers/video/msm/mddi.c                           |    8 ++--
 drivers/video/msm/mddi_client_dummy.c              |    2 +-
 drivers/video/msm/mddi_client_nt35399.c            |    2 +-
 drivers/video/msm/mddi_client_toshiba.c            |    2 +-
 drivers/video/msm/mdp.c                            |    4 +-
 drivers/video/msm/mdp_hw.h                         |    4 +-
 drivers/video/msm/mdp_ppp.c                        |    2 +-
 drivers/video/msm/msm_fb.c                         |    4 +-
 drivers/video/mx3fb.c                              |    8 ++--
 drivers/video/nuc900fb.c                           |    8 ++--
 drivers/video/omap/hwa742.c                        |    2 +-
 drivers/video/omap/lcd_ams_delta.c                 |    4 +-
 drivers/video/omap/lcd_inn1510.c                   |    2 +-
 drivers/video/omap/lcd_mipid.c                     |    2 +-
 drivers/video/omap/lcd_osk.c                       |    2 +-
 drivers/video/omap/lcd_palmte.c                    |    2 +-
 drivers/video/omap/lcdc.c                          |    4 +-
 drivers/video/omap/omapfb_main.c                   |    2 +-
 drivers/video/omap/sossi.c                         |    2 +-
 drivers/video/omap2/dss/dispc.c                    |    2 +-
 drivers/video/omap2/dss/dpi.c                      |    2 +-
 drivers/video/omap2/dss/dsi.c                      |    2 +-
 drivers/video/omap2/dss/dss.c                      |    4 +-
 drivers/video/omap2/dss/dss_features.c             |    2 +-
 drivers/video/omap2/dss/overlay.c                  |    2 +-
 drivers/video/omap2/dss/venc.c                     |    2 +-
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |    4 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |    4 +-
 drivers/video/omap2/omapfb/omapfb-sysfs.c          |    2 +-
 drivers/video/omap2/vram.c                         |    4 +-
 drivers/video/omap2/vrfb.c                         |    4 +-
 drivers/video/pxafb.c                              |    6 +--
 drivers/video/s3c-fb.c                             |    4 +-
 drivers/video/sa1100fb.c                           |    4 +-
 drivers/video/vt8500lcdfb.c                        |    2 +-
 drivers/video/wm8505fb.c                           |    2 +-
 drivers/watchdog/at91rm9200_wdt.c                  |    2 +-
 drivers/watchdog/omap_wdt.c                        |    2 +-
 drivers/watchdog/s3c2410_wdt.c                     |    2 +-
 include/linux/mfd/davinci_voicecodec.h             |    2 +-
 include/linux/mfd/dbx500-prcmu.h                   |    2 +-
 include/linux/omapfb.h                             |    2 +-
 include/linux/platform_data/atmel-aes.h            |    2 +-
 include/linux/power/smartreflex.h                  |    2 +-
 include/linux/spi/pxa2xx_spi.h                     |    2 +-
 sound/arm/pxa2xx-ac97-lib.c                        |    6 +--
 sound/arm/pxa2xx-ac97.c                            |    4 +-
 sound/arm/pxa2xx-pcm-lib.c                         |    2 +-
 sound/arm/pxa2xx-pcm.h                             |    2 +-
 sound/atmel/ac97c.c                                |    6 +--
 sound/oss/vidc.c                                   |    2 +-
 sound/oss/vidc_fill.S                              |    2 +-
 sound/oss/waveartist.c                             |    2 +-
 sound/soc/atmel/atmel_ssc_dai.c                    |    2 +-
 sound/soc/atmel/sam9g20_wm8731.c                   |    4 +-
 sound/soc/atmel/snd-soc-afeb9260.c                 |    2 +-
 sound/soc/davinci/davinci-evm.c                    |    6 +--
 sound/soc/davinci/davinci-i2s.c                    |    2 +-
 sound/soc/davinci/davinci-mcasp.h                  |    2 +-
 sound/soc/davinci/davinci-pcm.c                    |    4 +-
 sound/soc/davinci/davinci-pcm.h                    |    4 +-
 sound/soc/davinci/davinci-sffsdr.c                 |    2 +-
 sound/soc/ep93xx/edb93xx.c                         |    2 +-
 sound/soc/ep93xx/ep93xx-ac97.c                     |    2 +-
 sound/soc/ep93xx/ep93xx-i2s.c                      |    6 +--
 sound/soc/ep93xx/ep93xx-pcm.c                      |    6 +--
 sound/soc/ep93xx/simone.c                          |    2 +-
 sound/soc/ep93xx/snappercl15.c                     |    2 +-
 sound/soc/fsl/imx-pcm-fiq.c                        |    4 +-
 sound/soc/fsl/imx-ssi.c                            |    4 +-
 sound/soc/fsl/mx27vis-aic32x4.c                    |    2 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |    2 +-
 sound/soc/kirkwood/kirkwood-openrd.c               |    4 +-
 sound/soc/kirkwood/kirkwood-t5325.c                |    4 +-
 sound/soc/mxs/mxs-saif.c                           |    4 +-
 sound/soc/nuc900/nuc900-ac97.c                     |    2 +-
 sound/soc/nuc900/nuc900-pcm.c                      |    2 +-
 sound/soc/omap/am3517evm.c                         |    6 +--
 sound/soc/omap/ams-delta.c                         |    4 +-
 sound/soc/omap/igep0020.c                          |    6 +--
 sound/soc/omap/mcbsp.c                             |    2 +-
 sound/soc/omap/n810.c                              |    4 +-
 sound/soc/omap/omap-abe-twl6040.c                  |    4 +-
 sound/soc/omap/omap-dmic.c                         |    2 +-
 sound/soc/omap/omap-hdmi.c                         |    2 +-
 sound/soc/omap/omap-mcbsp.c                        |    4 +-
 sound/soc/omap/omap-mcpdm.c                        |    4 +-
 sound/soc/omap/omap-pcm.c                          |    2 +-
 sound/soc/omap/omap3beagle.c                       |    6 +--
 sound/soc/omap/omap3evm.c                          |    6 +--
 sound/soc/omap/omap3pandora.c                      |    2 +-
 sound/soc/omap/osk5912.c                           |    4 +-
 sound/soc/omap/overo.c                             |    6 +--
 sound/soc/omap/rx51.c                              |    2 +-
 sound/soc/omap/sdp3430.c                           |    6 +--
 sound/soc/omap/zoom2.c                             |    8 ++--
 sound/soc/pxa/corgi.c                              |    4 +-
 sound/soc/pxa/e740_wm9705.c                        |    4 +-
 sound/soc/pxa/e750_wm9705.c                        |    4 +-
 sound/soc/pxa/e800_wm9712.c                        |    4 +-
 sound/soc/pxa/em-x270.c                            |    2 +-
 sound/soc/pxa/hx4700.c                             |    2 +-
 sound/soc/pxa/magician.c                           |    2 +-
 sound/soc/pxa/mioa701_wm9713.c                     |    2 +-
 sound/soc/pxa/mmp-pcm.c                            |    2 +-
 sound/soc/pxa/palm27x.c                            |    4 +-
 sound/soc/pxa/poodle.c                             |    4 +-
 sound/soc/pxa/pxa-ssp.c                            |    4 +-
 sound/soc/pxa/pxa2xx-ac97.c                        |    8 ++--
 sound/soc/pxa/pxa2xx-i2s.c                         |    6 +--
 sound/soc/pxa/spitz.c                              |    2 +-
 sound/soc/pxa/tosa.c                               |    4 +-
 sound/soc/pxa/z2.c                                 |    6 +--
 sound/soc/samsung/ac97.c                           |    4 +-
 sound/soc/samsung/h1940_uda1380.c                  |    4 +-
 sound/soc/samsung/i2s.c                            |    2 +-
 sound/soc/samsung/neo1973_wm8753.c                 |    4 +-
 sound/soc/samsung/pcm.c                            |    4 +-
 sound/soc/samsung/rx1950_uda1380.c                 |    2 +-
 sound/soc/samsung/s3c24xx-i2s.c                    |    2 +-
 sound/soc/samsung/s3c24xx_simtec.c                 |    2 +-
 sound/soc/samsung/s3c24xx_uda134x.c                |    2 +-
 sound/soc/samsung/spdif.c                          |    2 +-
 sound/soc/tegra/tegra30_ahub.c                     |    4 +-
 sound/soc/tegra/tegra_pcm.h                        |    2 +-
 sound/soc/tegra/tegra_wm8903.c                     |    2 +-
 sound/soc/ux500/mop500_ab8500.c                    |    2 +-
 sound/soc/ux500/ux500_msp_dai.c                    |    4 +-
 sound/soc/ux500/ux500_msp_i2s.c                    |    4 +-
 sound/soc/ux500/ux500_msp_i2s.h                    |    2 +-
 sound/soc/ux500/ux500_pcm.c                        |    2 +-
 2008 files changed, 5935 insertions(+), 5935 deletions(-)

diff --git a/Documentation/spi/ep93xx_spi b/Documentation/spi/ep93xx_spi
index d8eb01c..f088b4b 100644
--- a/Documentation/spi/ep93xx_spi
+++ b/Documentation/spi/ep93xx_spi
@@ -26,7 +26,7 @@ arch/arm/mach-ep93xx/ts72xx.c:
 #include <linux/gpio.h>
 #include <linux/spi/spi.h>
 
-#include <mach/ep93xx_spi.h>
+#include <mach-ep93xx/ep93xx_spi.h>
 
 /* this is our GPIO line used for chip select */
 #define MMC_CHIP_SELECT_GPIO EP93XX_GPIO_LINE_EGPIO9
diff --git a/arch/arm/boot/compressed/head-shmobile.S b/arch/arm/boot/compressed/head-shmobile.S
index fe3719b..4bcb9c7 100644
--- a/arch/arm/boot/compressed/head-shmobile.S
+++ b/arch/arm/boot/compressed/head-shmobile.S
@@ -23,7 +23,7 @@
 	.section	".start", "ax"
 
 	/* load board-specific initialization code */
-#include <mach/zboot.h>
+#include <mach-shmobile/zboot.h>
 
 #if defined(CONFIG_ZBOOT_ROM_MMCIF) || defined(CONFIG_ZBOOT_ROM_SH_MOBILE_SDHI)
 	/* Load image from MMC/SD */
diff --git a/arch/arm/boot/compressed/sdhi-shmobile.c b/arch/arm/boot/compressed/sdhi-shmobile.c
index bd3d469..ff0aa20 100644
--- a/arch/arm/boot/compressed/sdhi-shmobile.c
+++ b/arch/arm/boot/compressed/sdhi-shmobile.c
@@ -18,7 +18,7 @@
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/sd.h>
 #include <linux/mmc/tmio.h>
-#include <mach/sdhi.h>
+#include <mach-shmobile/sdhi.h>
 
 #define OCR_FASTBOOT		(1<<29)
 #define OCR_HCS			(1<<30)
diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index 6f50c67..fd81ffe 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -16,11 +16,11 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
-#include <mach/at91rm9200.h>
-#include <mach/at91_aic.h>
-#include <mach/at91_pmc.h>
-#include <mach/at91_st.h>
-#include <mach/cpu.h>
+#include <mach-at91/at91rm9200.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/at91_st.h>
+#include <mach-at91/cpu.h>
 
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 01fb732..2b63b60 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -18,10 +18,10 @@
 #include <linux/platform_device.h>
 #include <linux/i2c-gpio.h>
 
-#include <mach/board.h>
-#include <mach/at91rm9200.h>
-#include <mach/at91rm9200_mc.h>
-#include <mach/at91_ramc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91rm9200.h>
+#include <mach-at91/at91rm9200_mc.h>
+#include <mach-at91/at91_ramc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index 104ca40..aec1da4 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -27,7 +27,7 @@
 
 #include <asm/mach/time.h>
 
-#include <mach/at91_st.h>
+#include <mach-at91/at91_st.h>
 
 static unsigned long last_crtr;
 static u32 irqmask;
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 30c7f26..e84bddb 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -17,12 +17,12 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
-#include <mach/cpu.h>
-#include <mach/at91_dbgu.h>
-#include <mach/at91sam9260.h>
-#include <mach/at91_aic.h>
-#include <mach/at91_pmc.h>
-#include <mach/at91_rstc.h>
+#include <mach-at91/cpu.h>
+#include <mach-at91/at91_dbgu.h>
+#include <mach-at91/at91sam9260.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/at91_rstc.h>
 
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 7b9c2ba..cb364af 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -19,13 +19,13 @@
 
 #include <linux/platform_data/at91_adc.h>
 
-#include <mach/board.h>
-#include <mach/cpu.h>
-#include <mach/at91sam9260.h>
-#include <mach/at91sam9260_matrix.h>
-#include <mach/at91_matrix.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at91_adc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/cpu.h>
+#include <mach-at91/at91sam9260.h>
+#include <mach-at91/at91sam9260_matrix.h>
+#include <mach-at91/at91_matrix.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at91_adc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index f40762c..58c830b 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -17,11 +17,11 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
-#include <mach/cpu.h>
-#include <mach/at91sam9261.h>
-#include <mach/at91_aic.h>
-#include <mach/at91_pmc.h>
-#include <mach/at91_rstc.h>
+#include <mach-at91/cpu.h>
+#include <mach-at91/at91sam9261.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/at91_rstc.h>
 
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 8df5c1b..f2e6805 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -21,11 +21,11 @@
 #include <linux/fb.h>
 #include <video/atmel_lcdc.h>
 
-#include <mach/board.h>
-#include <mach/at91sam9261.h>
-#include <mach/at91sam9261_matrix.h>
-#include <mach/at91_matrix.h>
-#include <mach/at91sam9_smc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91sam9261.h>
+#include <mach-at91/at91sam9261_matrix.h>
+#include <mach-at91/at91_matrix.h>
+#include <mach-at91/at91sam9_smc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 84b3810..51f4f7e 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -17,10 +17,10 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
-#include <mach/at91sam9263.h>
-#include <mach/at91_aic.h>
-#include <mach/at91_pmc.h>
-#include <mach/at91_rstc.h>
+#include <mach-at91/at91sam9263.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/at91_rstc.h>
 
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index eb6bbf8..26dc600 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -20,11 +20,11 @@
 #include <linux/fb.h>
 #include <video/atmel_lcdc.h>
 
-#include <mach/board.h>
-#include <mach/at91sam9263.h>
-#include <mach/at91sam9263_matrix.h>
-#include <mach/at91_matrix.h>
-#include <mach/at91sam9_smc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91sam9263.h>
+#include <mach-at91/at91sam9263_matrix.h>
+#include <mach-at91/at91_matrix.h>
+#include <mach-at91/at91sam9_smc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index ffc0957..e3b0d36 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -20,7 +20,7 @@
 
 #include <asm/mach/time.h>
 
-#include <mach/at91_pit.h>
+#include <mach-at91/at91_pit.h>
 
 
 #define PIT_CPIV(x)	((x) & AT91_PIT_CPIV)
diff --git a/arch/arm/mach-at91/at91sam9_alt_reset.S b/arch/arm/mach-at91/at91sam9_alt_reset.S
index 7af2e10..6d8da98 100644
--- a/arch/arm/mach-at91/at91sam9_alt_reset.S
+++ b/arch/arm/mach-at91/at91sam9_alt_reset.S
@@ -14,9 +14,9 @@
  */
 
 #include <linux/linkage.h>
-#include <mach/hardware.h>
-#include <mach/at91_ramc.h>
-#include <mach/at91_rstc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/at91_ramc.h>
+#include <mach-at91/at91_rstc.h>
 
 			.arm
 
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index ef6cedd..45c79b4 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -17,10 +17,10 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
-#include <mach/at91sam9g45.h>
-#include <mach/at91_aic.h>
-#include <mach/at91_pmc.h>
-#include <mach/cpu.h>
+#include <mach-at91/at91sam9g45.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/cpu.h>
 
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 0607399..242c850 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -25,14 +25,14 @@
 #include <linux/fb.h>
 #include <video/atmel_lcdc.h>
 
-#include <mach/at91_adc.h>
-#include <mach/board.h>
-#include <mach/at91sam9g45.h>
-#include <mach/at91sam9g45_matrix.h>
-#include <mach/at91_matrix.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at_hdmac.h>
-#include <mach/atmel-mci.h>
+#include <mach-at91/at91_adc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91sam9g45.h>
+#include <mach-at91/at91sam9g45_matrix.h>
+#include <mach-at91/at91_matrix.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at_hdmac.h>
+#include <mach-at91/atmel-mci.h>
 
 #include <media/atmel-isi.h>
 
diff --git a/arch/arm/mach-at91/at91sam9g45_reset.S b/arch/arm/mach-at91/at91sam9g45_reset.S
index 9d45718..0726dad 100644
--- a/arch/arm/mach-at91/at91sam9g45_reset.S
+++ b/arch/arm/mach-at91/at91sam9g45_reset.S
@@ -11,9 +11,9 @@
  */
 
 #include <linux/linkage.h>
-#include <mach/hardware.h>
-#include <mach/at91_ramc.h>
-#include <mach/at91_rstc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/at91_ramc.h>
+#include <mach-at91/at91_rstc.h>
 
 			.arm
 
diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
index 0849466..b5f4e1d 100644
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ b/arch/arm/mach-at91/at91sam9n12.c
@@ -12,10 +12,10 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
-#include <mach/at91sam9n12.h>
-#include <mach/at91_pmc.h>
-#include <mach/cpu.h>
-#include <mach/board.h>
+#include <mach-at91/at91sam9n12.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/cpu.h>
+#include <mach-at91/board.h>
 
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 72ce50a..3c17719 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -16,12 +16,12 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
-#include <mach/cpu.h>
-#include <mach/at91_dbgu.h>
-#include <mach/at91sam9rl.h>
-#include <mach/at91_aic.h>
-#include <mach/at91_pmc.h>
-#include <mach/at91_rstc.h>
+#include <mach-at91/cpu.h>
+#include <mach-at91/at91_dbgu.h>
+#include <mach-at91/at91sam9rl.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/at91_rstc.h>
 
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index f09fff9..cf41235 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -17,12 +17,12 @@
 #include <linux/fb.h>
 #include <video/atmel_lcdc.h>
 
-#include <mach/board.h>
-#include <mach/at91sam9rl.h>
-#include <mach/at91sam9rl_matrix.h>
-#include <mach/at91_matrix.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at_hdmac.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91sam9rl.h>
+#include <mach-at91/at91sam9rl_matrix.h>
+#include <mach-at91/at91_matrix.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at_hdmac.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index 477cf9d..d919d0e 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -12,10 +12,10 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
-#include <mach/at91sam9x5.h>
-#include <mach/at91_pmc.h>
-#include <mach/cpu.h>
-#include <mach/board.h>
+#include <mach-at91/at91sam9x5.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/cpu.h>
+#include <mach-at91/board.h>
 
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
index 46090e6..e3224b1 100644
--- a/arch/arm/mach-at91/at91x40.c
+++ b/arch/arm/mach-at91/at91x40.c
@@ -17,10 +17,10 @@
 #include <asm/proc-fns.h>
 #include <asm/system_misc.h>
 #include <asm/mach/arch.h>
-#include <mach/at91x40.h>
-#include <mach/at91_aic.h>
-#include <mach/at91_st.h>
-#include <mach/timex.h>
+#include <mach-at91/at91x40.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91_st.h>
+#include <mach-at91/timex.h>
 #include "generic.h"
 
 /*
diff --git a/arch/arm/mach-at91/at91x40_time.c b/arch/arm/mach-at91/at91x40_time.c
index 6ca680a..478fa8a 100644
--- a/arch/arm/mach-at91/at91x40_time.c
+++ b/arch/arm/mach-at91/at91x40_time.c
@@ -24,9 +24,9 @@
 #include <linux/irq.h>
 #include <linux/time.h>
 #include <linux/io.h>
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/mach/time.h>
-#include <mach/at91_tc.h>
+#include <mach-at91/at91_tc.h>
 
 #define at91_tc_read(field) \
 	__raw_readl(AT91_TC + field)
diff --git a/arch/arm/mach-at91/board-1arm.c b/arch/arm/mach-at91/board-1arm.c
index 22d8856..bbfe99a 100644
--- a/arch/arm/mach-at91/board-1arm.c
+++ b/arch/arm/mach-at91/board-1arm.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -34,9 +34,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/cpu.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/board.h>
+#include <mach-at91/cpu.h>
+#include <mach-at91/at91_aic.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
index de7be19..ae1469e 100644
--- a/arch/arm/mach-at91/board-afeb-9260v1.c
+++ b/arch/arm/mach-at91/board-afeb-9260v1.c
@@ -34,7 +34,7 @@
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -43,8 +43,8 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index 477e708..8e3b25a 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -29,7 +29,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -38,9 +38,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-carmeva.c b/arch/arm/mach-at91/board-carmeva.c
index a5b002f..b2f21fc 100644
--- a/arch/arm/mach-at91/board-carmeva.c
+++ b/arch/arm/mach-at91/board-carmeva.c
@@ -34,9 +34,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
index ecbc13b..2d5334c 100644
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@ -39,12 +39,12 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at91sam9260_matrix.h>
-#include <mach/at91_matrix.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at91sam9260_matrix.h>
+#include <mach-at91/at91_matrix.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-cpuat91.c b/arch/arm/mach-at91/board-cpuat91.c
index 2e6d043..73934ef 100644
--- a/arch/arm/mach-at91/board-cpuat91.c
+++ b/arch/arm/mach-at91/board-cpuat91.c
@@ -27,7 +27,7 @@
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/plat-ram.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -36,11 +36,11 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91rm9200_mc.h>
-#include <mach/at91_ramc.h>
-#include <mach/cpu.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91rm9200_mc.h>
+#include <mach-at91/at91_ramc.h>
+#include <mach-at91/cpu.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
index 462bc31..40f5e99 100644
--- a/arch/arm/mach-at91/board-csb337.c
+++ b/arch/arm/mach-at91/board-csb337.c
@@ -37,9 +37,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-csb637.c b/arch/arm/mach-at91/board-csb637.c
index 872871a..df54c811 100644
--- a/arch/arm/mach-at91/board-csb637.c
+++ b/arch/arm/mach-at91/board-csb637.c
@@ -34,9 +34,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-dt.c b/arch/arm/mach-at91/board-dt.c
index e8f45c4..346b427 100644
--- a/arch/arm/mach-at91/board-dt.c
+++ b/arch/arm/mach-at91/board-dt.c
@@ -15,8 +15,8 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-at91/board-eb01.c b/arch/arm/mach-at91/board-eb01.c
index 01f66e9..5a0365d 100644
--- a/arch/arm/mach-at91/board-eb01.c
+++ b/arch/arm/mach-at91/board-eb01.c
@@ -24,11 +24,11 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <asm/mach-types.h>
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
 #include "generic.h"
 
 static void __init at91eb01_init_irq(void)
diff --git a/arch/arm/mach-at91/board-eb9200.c b/arch/arm/mach-at91/board-eb9200.c
index d1e1f3f..3ae9f49 100644
--- a/arch/arm/mach-at91/board-eb9200.c
+++ b/arch/arm/mach-at91/board-eb9200.c
@@ -26,7 +26,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -35,8 +35,8 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
index 9c24cb2..f9d2da7 100644
--- a/arch/arm/mach-at91/board-ecbat91.c
+++ b/arch/arm/mach-at91/board-ecbat91.c
@@ -28,7 +28,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -37,9 +37,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/cpu.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/board.h>
+#include <mach-at91/cpu.h>
+#include <mach-at91/at91_aic.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
index 82bdfde..814756e 100644
--- a/arch/arm/mach-at91/board-eco920.c
+++ b/arch/arm/mach-at91/board-eco920.c
@@ -24,11 +24,11 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91rm9200_mc.h>
-#include <mach/at91_ramc.h>
-#include <mach/cpu.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91rm9200_mc.h>
+#include <mach-at91/at91_ramc.h>
+#include <mach-at91/cpu.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
index 6cc83a8..d5315ef 100644
--- a/arch/arm/mach-at91/board-flexibity.c
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -32,9 +32,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
index 69ab124..43b5fc2 100644
--- a/arch/arm/mach-at91/board-foxg20.c
+++ b/arch/arm/mach-at91/board-foxg20.c
@@ -32,7 +32,7 @@
 #include <linux/clk.h>
 #include <linux/w1-gpio.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -41,9 +41,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
index a9d5e78..b6d0d6f 100644
--- a/arch/arm/mach-at91/board-gsia18s.c
+++ b/arch/arm/mach-at91/board-gsia18s.c
@@ -30,11 +30,11 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/gsia18s.h>
-#include <mach/stamp9g20.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/gsia18s.h>
+#include <mach-at91/stamp9g20.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
index 64c1dbf..7e98f65 100644
--- a/arch/arm/mach-at91/board-kafa.c
+++ b/arch/arm/mach-at91/board-kafa.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -34,9 +34,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/cpu.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/cpu.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index 5d96cb8..5b1bf97 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -26,7 +26,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -35,11 +35,11 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/cpu.h>
-#include <mach/at91_aic.h>
-#include <mach/at91rm9200_mc.h>
-#include <mach/at91_ramc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/cpu.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91rm9200_mc.h>
+#include <mach-at91/at91_ramc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-neocore926.c b/arch/arm/mach-at91/board-neocore926.c
index 18103c5d..c9e9d89 100644
--- a/arch/arm/mach-at91/board-neocore926.c
+++ b/arch/arm/mach-at91/board-neocore926.c
@@ -43,10 +43,10 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
index 9ca3e32..f809d33 100644
--- a/arch/arm/mach-at91/board-pcontrol-g20.c
+++ b/arch/arm/mach-at91/board-pcontrol-g20.c
@@ -29,10 +29,10 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/stamp9g20.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/stamp9g20.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-picotux200.c b/arch/arm/mach-at91/board-picotux200.c
index 1270655..469000d 100644
--- a/arch/arm/mach-at91/board-picotux200.c
+++ b/arch/arm/mach-at91/board-picotux200.c
@@ -28,7 +28,7 @@
 #include <linux/spi/spi.h>
 #include <linux/mtd/physmap.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -37,10 +37,10 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91rm9200_mc.h>
-#include <mach/at91_ramc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91rm9200_mc.h>
+#include <mach-at91/at91_ramc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-qil-a9260.c b/arch/arm/mach-at91/board-qil-a9260.c
index bf351e2..0364e46 100644
--- a/arch/arm/mach-at91/board-qil-a9260.c
+++ b/arch/arm/mach-at91/board-qil-a9260.c
@@ -39,11 +39,11 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at91_shdwc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at91_shdwc.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
index cc2bf97..9769e97 100644
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@ -38,11 +38,11 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91rm9200_mc.h>
-#include <mach/at91_ramc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91rm9200_mc.h>
+#include <mach-at91/at91_ramc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index 62e19e6..2311b39 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -38,11 +38,11 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91rm9200_mc.h>
-#include <mach/at91_ramc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91rm9200_mc.h>
+#include <mach-at91/at91_ramc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-rsi-ews.c b/arch/arm/mach-at91/board-rsi-ews.c
index c3b43ae..5dfc434 100644
--- a/arch/arm/mach-at91/board-rsi-ews.c
+++ b/arch/arm/mach-at91/board-rsi-ews.c
@@ -24,9 +24,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
 
 #include <linux/gpio.h>
 
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index 7bf6da7..39546b8 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -28,7 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -37,9 +37,9 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index 889c1bf..27865bc 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -40,12 +40,12 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at91_shdwc.h>
-#include <mach/system_rev.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at91_shdwc.h>
+#include <mach-at91/system_rev.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 2269be5..e37f30f 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -44,12 +44,12 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at91_shdwc.h>
-#include <mach/system_rev.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at91_shdwc.h>
+#include <mach-at91/system_rev.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 82adf58..b149347 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -43,12 +43,12 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at91_shdwc.h>
-#include <mach/system_rev.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at91_shdwc.h>
+#include <mach-at91/system_rev.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
index 4ea4ee0..cd48ea7 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -34,7 +34,7 @@
 
 #include <linux/platform_data/at91_adc.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
@@ -43,10 +43,10 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/system_rev.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/system_rev.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 3d48ec1..4222519 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -29,7 +29,7 @@
 
 #include <linux/platform_data/at91_adc.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <video/atmel_lcdc.h>
 #include <media/soc_camera.h>
 #include <media/atmel-isi.h>
@@ -42,11 +42,11 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at91_shdwc.h>
-#include <mach/system_rev.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at91_shdwc.h>
+#include <mach-at91/system_rev.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index e7dc3ea..80f805c 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -29,11 +29,11 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at91_shdwc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at91_shdwc.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index a4e031a..dada12c 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -31,10 +31,10 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
index 29eae16..64c7010 100644
--- a/arch/arm/mach-at91/board-stamp9g20.c
+++ b/arch/arm/mach-at91/board-stamp9g20.c
@@ -25,9 +25,9 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-usb-a926x.c b/arch/arm/mach-at91/board-usb-a926x.c
index c1476b9..dacfc5b 100644
--- a/arch/arm/mach-at91/board-usb-a926x.c
+++ b/arch/arm/mach-at91/board-usb-a926x.c
@@ -40,11 +40,11 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91sam9_smc.h>
-#include <mach/at91_shdwc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91sam9_smc.h>
+#include <mach-at91/at91_shdwc.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index 516d340..fed4f0a 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -42,12 +42,12 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/board.h>
-#include <mach/at91_aic.h>
-#include <mach/at91rm9200_mc.h>
-#include <mach/at91_ramc.h>
-#include <mach/cpu.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/board.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91rm9200_mc.h>
+#include <mach-at91/at91_ramc.h>
+#include <mach-at91/cpu.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index de2ec6b..c5789a1 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -25,9 +25,9 @@
 #include <linux/io.h>
 #include <linux/of_address.h>
 
-#include <mach/hardware.h>
-#include <mach/at91_pmc.h>
-#include <mach/cpu.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/cpu.h>
 
 #include <asm/proc-fns.h>
 
diff --git a/arch/arm/mach-at91/cpuidle.c b/arch/arm/mach-at91/cpuidle.c
index 0c63815..6d03dc6 100644
--- a/arch/arm/mach-at91/cpuidle.c
+++ b/arch/arm/mach-at91/cpuidle.c
@@ -21,7 +21,7 @@
 #include <linux/export.h>
 #include <asm/proc-fns.h>
 #include <asm/cpuidle.h>
-#include <mach/cpu.h>
+#include <mach-at91/cpu.h>
 
 #include "pm.h"
 
diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index be42cf0..ce21de2 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -28,8 +28,8 @@
 
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/at91_pio.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/at91_pio.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/include/mach-at91/at91_ramc.h b/arch/arm/mach-at91/include/mach-at91/at91_ramc.h
index d8aeb27..c871a14 100644
--- a/arch/arm/mach-at91/include/mach-at91/at91_ramc.h
+++ b/arch/arm/mach-at91/include/mach-at91/at91_ramc.h
@@ -25,8 +25,8 @@ extern void __iomem *at91_ramc_base[];
 #define AT91_MEMCTRL_SDRAMC	1
 #define AT91_MEMCTRL_DDRSDR	2
 
-#include <mach/at91rm9200_sdramc.h>
-#include <mach/at91sam9_ddrsdr.h>
-#include <mach/at91sam9_sdramc.h>
+#include <mach-at91/at91rm9200_sdramc.h>
+#include <mach-at91/at91sam9_ddrsdr.h>
+#include <mach-at91/at91sam9_sdramc.h>
 
 #endif /* __AT91_RAMC_H__ */
diff --git a/arch/arm/mach-at91/include/mach-at91/at91sam9_smc.h b/arch/arm/mach-at91/include/mach-at91/at91sam9_smc.h
index 175e1fd..2f6393e 100644
--- a/arch/arm/mach-at91/include/mach-at91/at91sam9_smc.h
+++ b/arch/arm/mach-at91/include/mach-at91/at91sam9_smc.h
@@ -16,7 +16,7 @@
 #ifndef AT91SAM9_SMC_H
 #define AT91SAM9_SMC_H
 
-#include <mach/cpu.h>
+#include <mach-at91/cpu.h>
 
 #ifndef __ASSEMBLY__
 struct sam9_smc_config {
diff --git a/arch/arm/mach-at91/include/mach-at91/atmel-mci.h b/arch/arm/mach-at91/include/mach-at91/atmel-mci.h
index 998cb0c..d8f4109 100644
--- a/arch/arm/mach-at91/include/mach-at91/atmel-mci.h
+++ b/arch/arm/mach-at91/include/mach-at91/atmel-mci.h
@@ -1,7 +1,7 @@
 #ifndef __MACH_ATMEL_MCI_H
 #define __MACH_ATMEL_MCI_H
 
-#include <mach/at_hdmac.h>
+#include <mach-at91/at_hdmac.h>
 
 /**
  * struct mci_dma_data - DMA data for MCI interface
diff --git a/arch/arm/mach-at91/include/mach-at91/debug-macro.S b/arch/arm/mach-at91/include/mach-at91/debug-macro.S
index c6bb9e2..8a1599c 100644
--- a/arch/arm/mach-at91/include/mach-at91/debug-macro.S
+++ b/arch/arm/mach-at91/include/mach-at91/debug-macro.S
@@ -11,8 +11,8 @@
  *
 */
 
-#include <mach/hardware.h>
-#include <mach/at91_dbgu.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/at91_dbgu.h>
 
 #if defined(CONFIG_AT91_DEBUG_LL_DBGU0)
 #define AT91_DBGU AT91_BASE_DBGU0
diff --git a/arch/arm/mach-at91/include/mach-at91/hardware.h b/arch/arm/mach-at91/include/mach-at91/hardware.h
index 09242b6..caef81c 100644
--- a/arch/arm/mach-at91/include/mach-at91/hardware.h
+++ b/arch/arm/mach-at91/include/mach-at91/hardware.h
@@ -23,16 +23,16 @@
 #define AT91_BASE_DBGU1	0xffffee00
 
 #if defined(CONFIG_ARCH_AT91X40)
-#include <mach/at91x40.h>
+#include <mach-at91/at91x40.h>
 #else
-#include <mach/at91rm9200.h>
-#include <mach/at91sam9260.h>
-#include <mach/at91sam9261.h>
-#include <mach/at91sam9263.h>
-#include <mach/at91sam9rl.h>
-#include <mach/at91sam9g45.h>
-#include <mach/at91sam9x5.h>
-#include <mach/at91sam9n12.h>
+#include <mach-at91/at91rm9200.h>
+#include <mach-at91/at91sam9260.h>
+#include <mach-at91/at91sam9261.h>
+#include <mach-at91/at91sam9263.h>
+#include <mach-at91/at91sam9rl.h>
+#include <mach-at91/at91sam9g45.h>
+#include <mach-at91/at91sam9x5.h>
+#include <mach-at91/at91sam9n12.h>
 
 /*
  * On all at91 except rm9200 and x40 have the System Controller starts
diff --git a/arch/arm/mach-at91/include/mach-at91/memory.h b/arch/arm/mach-at91/include/mach-at91/memory.h
index 401c207..88c06fd 100644
--- a/arch/arm/mach-at91/include/mach-at91/memory.h
+++ b/arch/arm/mach-at91/include/mach-at91/memory.h
@@ -21,6 +21,6 @@
 #ifndef __ASM_ARCH_MEMORY_H
 #define __ASM_ARCH_MEMORY_H
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 
 #endif
diff --git a/arch/arm/mach-at91/include/mach-at91/timex.h b/arch/arm/mach-at91/include/mach-at91/timex.h
index 5e917a6..f4e72e2 100644
--- a/arch/arm/mach-at91/include/mach-at91/timex.h
+++ b/arch/arm/mach-at91/include/mach-at91/timex.h
@@ -21,7 +21,7 @@
 #ifndef __ASM_ARCH_TIMEX_H
 #define __ASM_ARCH_TIMEX_H
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 
 #ifdef CONFIG_ARCH_AT91X40
 
diff --git a/arch/arm/mach-at91/include/mach-at91/uncompress.h b/arch/arm/mach-at91/include/mach-at91/uncompress.h
index 6f6118d..914feb7 100644
--- a/arch/arm/mach-at91/include/mach-at91/uncompress.h
+++ b/arch/arm/mach-at91/include/mach-at91/uncompress.h
@@ -24,10 +24,10 @@
 
 #include <linux/io.h>
 #include <linux/atmel_serial.h>
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 
-#include <mach/at91_dbgu.h>
-#include <mach/cpu.h>
+#include <mach-at91/at91_dbgu.h>
+#include <mach-at91/cpu.h>
 
 void __iomem *at91_uart;
 
diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
index 1e02c0e..eeddbec 100644
--- a/arch/arm/mach-at91/irq.c
+++ b/arch/arm/mach-at91/irq.c
@@ -33,7 +33,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/irq.h>
 #include <asm/setup.h>
 
@@ -42,7 +42,7 @@
 #include <asm/mach/irq.h>
 #include <asm/mach/map.h>
 
-#include <mach/at91_aic.h>
+#include <mach-at91/at91_aic.h>
 
 void __iomem *at91_aic_base;
 static struct irq_domain *at91_aic_domain;
diff --git a/arch/arm/mach-at91/leds.c b/arch/arm/mach-at91/leds.c
index 8dfafe7..f921b1e 100644
--- a/arch/arm/mach-at91/leds.c
+++ b/arch/arm/mach-at91/leds.c
@@ -15,7 +15,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <mach/board.h>
+#include <mach-at91/board.h>
 
 
 /* ------------------------------------------------------------------------- */
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 2c2d865..a5b940e 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -25,9 +25,9 @@
 #include <asm/mach/time.h>
 #include <asm/mach/irq.h>
 
-#include <mach/at91_aic.h>
-#include <mach/at91_pmc.h>
-#include <mach/cpu.h>
+#include <mach-at91/at91_aic.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/cpu.h>
 
 #include "generic.h"
 #include "pm.h"
@@ -36,8 +36,8 @@
  * Show the reason for the previous system reset.
  */
 
-#include <mach/at91_rstc.h>
-#include <mach/at91_shdwc.h>
+#include <mach-at91/at91_rstc.h>
+#include <mach-at91/at91_shdwc.h>
 
 static void __init show_reset_status(void)
 {
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index 38f467c..529072a 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -11,8 +11,8 @@
 #ifndef __ARCH_ARM_MACH_AT91_PM
 #define __ARCH_ARM_MACH_AT91_PM
 
-#include <mach/at91_ramc.h>
-#include <mach/at91rm9200_sdramc.h>
+#include <mach-at91/at91_ramc.h>
+#include <mach-at91/at91rm9200_sdramc.h>
 
 /*
  * The AT91RM9200 goes into self-refresh mode with this command, and will
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 098c28d..8f263c6 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -13,9 +13,9 @@
  */
 
 #include <linux/linkage.h>
-#include <mach/hardware.h>
-#include <mach/at91_pmc.h>
-#include <mach/at91_ramc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/at91_ramc.h>
 
 
 #ifdef CONFIG_SOC_AT91SAM9263
diff --git a/arch/arm/mach-at91/sam9_smc.c b/arch/arm/mach-at91/sam9_smc.c
index 99a0a1d..be40bf2 100644
--- a/arch/arm/mach-at91/sam9_smc.c
+++ b/arch/arm/mach-at91/sam9_smc.c
@@ -14,7 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 
-#include <mach/at91sam9_smc.h>
+#include <mach-at91/at91sam9_smc.h>
 
 #include "sam9_smc.h"
 
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 944bffb..0fe58d5 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -14,11 +14,11 @@
 #include <asm/system_misc.h>
 #include <asm/mach/map.h>
 
-#include <mach/hardware.h>
-#include <mach/cpu.h>
-#include <mach/at91_dbgu.h>
-#include <mach/at91_pmc.h>
-#include <mach/at91_shdwc.h>
+#include <mach-at91/hardware.h>
+#include <mach-at91/cpu.h>
+#include <mach-at91/at91_dbgu.h>
+#include <mach-at91/at91_pmc.h>
+#include <mach-at91/at91_shdwc.h>
 
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-bcmring/arch.c b/arch/arm/mach-bcmring/arch.c
index 45c97b1..f7469da 100644
--- a/arch/arm/mach-bcmring/arch.c
+++ b/arch/arm/mach-bcmring/arch.c
@@ -32,11 +32,11 @@
 #include <asm/pmu.h>
 
 #include <asm/mach/arch.h>
-#include <mach/dma.h>
-#include <mach/hardware.h>
-#include <mach/csp/mm_io.h>
-#include <mach/csp/chipcHw_def.h>
-#include <mach/csp/chipcHw_inline.h>
+#include <mach-bcmring/dma.h>
+#include <mach-bcmring/hardware.h>
+#include <mach-bcmring/csp/mm_io.h>
+#include <mach-bcmring/csp/chipcHw_def.h>
+#include <mach-bcmring/csp/chipcHw_inline.h>
 
 #include <cfg_global.h>
 
diff --git a/arch/arm/mach-bcmring/clock.c b/arch/arm/mach-bcmring/clock.c
index ad237a4..108845f 100644
--- a/arch/arm/mach-bcmring/clock.c
+++ b/arch/arm/mach-bcmring/clock.c
@@ -22,10 +22,10 @@
 #include <linux/clk.h>
 #include <linux/spinlock.h>
 #include <linux/clkdev.h>
-#include <mach/csp/hw_cfg.h>
-#include <mach/csp/chipcHw_def.h>
-#include <mach/csp/chipcHw_reg.h>
-#include <mach/csp/chipcHw_inline.h>
+#include <mach-bcmring/csp/hw_cfg.h>
+#include <mach-bcmring/csp/chipcHw_def.h>
+#include <mach-bcmring/csp/chipcHw_reg.h>
+#include <mach-bcmring/csp/chipcHw_inline.h>
 
 #include "clock.h"
 
diff --git a/arch/arm/mach-bcmring/clock.h b/arch/arm/mach-bcmring/clock.h
index 5e0b981..2e01614 100644
--- a/arch/arm/mach-bcmring/clock.h
+++ b/arch/arm/mach-bcmring/clock.h
@@ -11,7 +11,7 @@
 * license other than the GPL, without Broadcom's express prior written
 * consent.
 *****************************************************************************/
-#include <mach/csp/chipcHw_def.h>
+#include <mach-bcmring/csp/chipcHw_def.h>
 
 #define CLK_TYPE_PRIMARY         1	/* primary clock must NOT have a parent */
 #define CLK_TYPE_PLL1            2	/* PPL1 */
diff --git a/arch/arm/mach-bcmring/core.c b/arch/arm/mach-bcmring/core.c
index adbfb19..4d089b3 100644
--- a/arch/arm/mach-bcmring/core.c
+++ b/arch/arm/mach-bcmring/core.c
@@ -29,8 +29,8 @@
 #include <linux/amba/bus.h>
 #include <linux/clkdev.h>
 
-#include <mach/csp/mm_addr.h>
-#include <mach/hardware.h>
+#include <mach-bcmring/csp/mm_addr.h>
+#include <mach-bcmring/hardware.h>
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/hardware/arm_timer.h>
@@ -48,9 +48,9 @@
 #include "clock.h"
 
 #include <csp/secHw.h>
-#include <mach/csp/secHw_def.h>
-#include <mach/csp/chipcHw_inline.h>
-#include <mach/csp/tmrHw_reg.h>
+#include <mach-bcmring/csp/secHw_def.h>
+#include <mach-bcmring/csp/chipcHw_inline.h>
+#include <mach-bcmring/csp/tmrHw_reg.h>
 
 static AMBA_APB_DEVICE(uartA, "uartA", 0, MM_ADDR_IO_UARTA, {IRQ_UARTA}, NULL);
 static AMBA_APB_DEVICE(uartB, "uartB", 0, MM_ADDR_IO_UARTB, {IRQ_UARTB}, NULL);
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
index 96273ff..270689d 100644
--- a/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
@@ -30,8 +30,8 @@
 #include <csp/stdint.h>
 #include <csp/module.h>
 
-#include <mach/csp/chipcHw_def.h>
-#include <mach/csp/chipcHw_inline.h>
+#include <mach-bcmring/csp/chipcHw_def.h>
+#include <mach-bcmring/csp/chipcHw_inline.h>
 
 #include <csp/reg.h>
 #include <csp/delay.h>
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
index 367df75..48e5977 100644
--- a/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
@@ -30,8 +30,8 @@
 #include <csp/stdint.h>
 #include <csp/module.h>
 
-#include <mach/csp/chipcHw_def.h>
-#include <mach/csp/chipcHw_inline.h>
+#include <mach-bcmring/csp/chipcHw_def.h>
+#include <mach-bcmring/csp/chipcHw_inline.h>
 
 #include <csp/reg.h>
 #include <csp/delay.h>
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
index 2671d88..0aee4f2 100644
--- a/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
@@ -14,8 +14,8 @@
 
 /* ---- Include Files ---------------------------------------------------- */
 #include <csp/stdint.h>
-#include <mach/csp/chipcHw_def.h>
-#include <mach/csp/chipcHw_inline.h>
+#include <mach-bcmring/csp/chipcHw_def.h>
+#include <mach-bcmring/csp/chipcHw_inline.h>
 #include <csp/intcHw.h>
 #include <csp/cache.h>
 
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
index 54ad964..d466c49 100644
--- a/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
@@ -23,7 +23,7 @@
 
 /* ---- Include Files ---------------------------------------------------- */
 
-#include <mach/csp/chipcHw_inline.h>
+#include <mach-bcmring/csp/chipcHw_inline.h>
 
 /* ---- Private Constants and Types --------------------------------------- */
 
diff --git a/arch/arm/mach-bcmring/csp/dmac/dmacHw.c b/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
index 6b9be2e..4a9675a 100644
--- a/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
+++ b/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
@@ -30,9 +30,9 @@
 #include <stddef.h>
 
 #include <csp/dmacHw.h>
-#include <mach/csp/dmacHw_reg.h>
-#include <mach/csp/dmacHw_priv.h>
-#include <mach/csp/chipcHw_inline.h>
+#include <mach-bcmring/csp/dmacHw_reg.h>
+#include <mach-bcmring/csp/dmacHw_priv.h>
+#include <mach-bcmring/csp/chipcHw_inline.h>
 
 /* ---- External Function Prototypes ------------------------------------- */
 
diff --git a/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c b/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
index a1f3283..f4e883a 100644
--- a/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
+++ b/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
@@ -30,8 +30,8 @@
 #include <stddef.h>
 
 #include <csp/dmacHw.h>
-#include <mach/csp/dmacHw_reg.h>
-#include <mach/csp/dmacHw_priv.h>
+#include <mach-bcmring/csp/dmacHw_reg.h>
+#include <mach-bcmring/csp/dmacHw_priv.h>
 
 extern dmacHw_CBLK_t dmacHw_gCblk[dmacHw_MAX_CHANNEL_COUNT];	/* Declared in dmacHw.c */
 
diff --git a/arch/arm/mach-bcmring/csp/tmr/tmrHw.c b/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
index 16225e4..220e314 100644
--- a/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
+++ b/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
@@ -30,7 +30,7 @@
 #include <csp/stdint.h>
 
 #include <csp/tmrHw.h>
-#include <mach/csp/tmrHw_reg.h>
+#include <mach-bcmring/csp/tmrHw_reg.h>
 
 #define tmrHw_ASSERT(a)                     if (!(a)) *(char *)0 = 0
 #define tmrHw_MILLISEC_PER_SEC              (1000)
diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
index e5fd241..e90cfdf 100644
--- a/arch/arm/mach-bcmring/dma.c
+++ b/arch/arm/mach-bcmring/dma.c
@@ -31,11 +31,11 @@
 #include <linux/proc_fs.h>
 #include <linux/slab.h>
 
-#include <mach/timer.h>
+#include <mach-bcmring/timer.h>
 
 #include <linux/pfn.h>
 #include <linux/atomic.h>
-#include <mach/dma.h>
+#include <mach-bcmring/dma.h>
 
 /* ---- Public Variables ------------------------------------------------- */
 
diff --git a/arch/arm/mach-bcmring/include/csp/dmacHw.h b/arch/arm/mach-bcmring/include/csp/dmacHw.h
index e6a1dc4..97d8a04 100644
--- a/arch/arm/mach-bcmring/include/csp/dmacHw.h
+++ b/arch/arm/mach-bcmring/include/csp/dmacHw.h
@@ -26,7 +26,7 @@
 #include <stddef.h>
 
 #include <csp/stdint.h>
-#include <mach/csp/dmacHw_reg.h>
+#include <mach-bcmring/csp/dmacHw_reg.h>
 
 /* Define DMA Channel ID using DMA controller number (m) and channel number (c).
 
diff --git a/arch/arm/mach-bcmring/include/csp/intcHw.h b/arch/arm/mach-bcmring/include/csp/intcHw.h
index 1c639c8..eb7d3ae 100644
--- a/arch/arm/mach-bcmring/include/csp/intcHw.h
+++ b/arch/arm/mach-bcmring/include/csp/intcHw.h
@@ -28,7 +28,7 @@
 #define _INTCHW_H
 
 /* ---- Include Files ---------------------------------------------------- */
-#include <mach/csp/intcHw_reg.h>
+#include <mach-bcmring/csp/intcHw_reg.h>
 
 /* ---- Public Constants and Types --------------------------------------- */
 /* ---- Public Variable Externs ------------------------------------------ */
diff --git a/arch/arm/mach-bcmring/include/csp/reg.h b/arch/arm/mach-bcmring/include/csp/reg.h
index 56654d2..23ac669 100644
--- a/arch/arm/mach-bcmring/include/csp/reg.h
+++ b/arch/arm/mach-bcmring/include/csp/reg.h
@@ -69,7 +69,7 @@
 /*  */
 
 #if defined(__KERNEL__) && !defined(STANDALONE)
-#include <mach/hardware.h>
+#include <mach-bcmring/hardware.h>
 #include <linux/interrupt.h>
 
 #define REG_LOCAL_IRQ_SAVE      HW_DECLARE_SPINLOCK(reg32) \
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/cap_inline.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/cap_inline.h
index 933ce68..4a1ecfa 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/cap_inline.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/cap_inline.h
@@ -16,7 +16,7 @@
 #define CAP_INLINE_H
 
 /* ---- Include Files ---------------------------------------------------- */
-#include <mach/csp/cap.h>
+#include <mach-bcmring/csp/cap.h>
 #include <cfg_global.h>
 
 /* ---- Public Constants and Types --------------------------------------- */
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_def.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_def.h
index 1619733..fe57b08 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_def.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_def.h
@@ -20,7 +20,7 @@
 #include <csp/stdint.h>
 #include <csp/errno.h>
 #include <csp/reg.h>
-#include <mach/csp/chipcHw_reg.h>
+#include <mach-bcmring/csp/chipcHw_reg.h>
 
 /* ---- Public Constants and Types ---------------------------------------- */
 
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_inline.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_inline.h
index 03238c2..108209c 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_inline.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_inline.h
@@ -19,8 +19,8 @@
 
 #include <csp/errno.h>
 #include <csp/reg.h>
-#include <mach/csp/chipcHw_reg.h>
-#include <mach/csp/chipcHw_def.h>
+#include <mach-bcmring/csp/chipcHw_reg.h>
+#include <mach-bcmring/csp/chipcHw_def.h>
 
 /* ---- Private Constants and Types --------------------------------------- */
 typedef enum {
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_reg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_reg.h
index b162448..85b13d7 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_reg.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_reg.h
@@ -23,9 +23,9 @@
 #ifndef CHIPCHW_REG_H
 #define CHIPCHW_REG_H
 
-#include <mach/csp/mm_io.h>
+#include <mach-bcmring/csp/mm_io.h>
 #include <csp/reg.h>
-#include <mach/csp/ddrcReg.h>
+#include <mach-bcmring/csp/ddrcReg.h>
 
 #define chipcHw_BASE_ADDRESS    MM_IO_BASE_CHIPC
 
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/ddrcReg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/ddrcReg.h
index f1b68e2..462c099 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/ddrcReg.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/ddrcReg.h
@@ -33,7 +33,7 @@ extern "C" {
 #include <csp/reg.h>
 #include <csp/stdint.h>
 
-#include <mach/csp/mm_io.h>
+#include <mach-bcmring/csp/mm_io.h>
 
 /* ---- Public Constants and Types --------------------------------------- */
 
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/dmacHw_reg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/dmacHw_reg.h
index f1ecf96..1f5263f 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/dmacHw_reg.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/dmacHw_reg.h
@@ -25,7 +25,7 @@
 #define _DMACHW_REG_H
 
 #include <csp/stdint.h>
-#include <mach/csp/mm_io.h>
+#include <mach-bcmring/csp/mm_io.h>
 
 /* Data type for 64 bit little endian register */
 typedef struct {
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/hw_cfg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/hw_cfg.h
index cfa91be..aad4e17 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/hw_cfg.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/hw_cfg.h
@@ -19,10 +19,10 @@
 /* ---- Include Files ---------------------------------------------------- */
 
 #include <cfg_global.h>
-#include <mach/csp/cap_inline.h>
+#include <mach-bcmring/csp/cap_inline.h>
 
 #if defined(__KERNEL__)
-#include <mach/memory_settings.h>
+#include <mach-bcmring/memory_settings.h>
 #else
 #include <hw_cfg.h>
 #endif
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/intcHw_reg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/intcHw_reg.h
index 0aeb6a6..0770d7d 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/intcHw_reg.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/intcHw_reg.h
@@ -29,7 +29,7 @@
 /* ---- Include Files ---------------------------------------------------- */
 #include <csp/stdint.h>
 #include <csp/reg.h>
-#include <mach/csp/mm_io.h>
+#include <mach-bcmring/csp/mm_io.h>
 
 /* ---- Public Constants and Types --------------------------------------- */
 
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/mm_io.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/mm_io.h
index de92ec6..dcb1eae 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/mm_io.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/mm_io.h
@@ -27,7 +27,7 @@
 #define _MM_IO_H
 
 /* ---- Include Files ---------------------------------------------------- */
-#include <mach/csp/mm_addr.h>
+#include <mach-bcmring/csp/mm_addr.h>
 
 #if !defined(CSP_SIMULATION)
 #include <cfg_global.h>
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/secHw_def.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/secHw_def.h
index d15f5f3..18279ce 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/secHw_def.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/secHw_def.h
@@ -26,7 +26,7 @@
 #ifndef SECHW_DEF_H
 #define SECHW_DEF_H
 
-#include <mach/csp/mm_io.h>
+#include <mach-bcmring/csp/mm_io.h>
 
 /* Bit mask for various secure device */
 #define secHw_BLK_MASK_CHIP_CONTROL     0x00000001
@@ -95,6 +95,6 @@ static inline void secHw_setUnsecure(uint32_t mask	/*  mask of type secHw_BLK_MA
 /****************************************************************************/
 static inline uint32_t secHw_getStatus(void);
 
-#include <mach/csp/secHw_inline.h>
+#include <mach-bcmring/csp/secHw_inline.h>
 
 #endif /* SECHW_DEF_H */
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/tmrHw_reg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/tmrHw_reg.h
index 3080ac7..e6069f5 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/tmrHw_reg.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/tmrHw_reg.h
@@ -23,8 +23,8 @@
 #ifndef _TMRHW_REG_H
 #define _TMRHW_REG_H
 
-#include <mach/csp/mm_io.h>
-#include <mach/csp/hw_cfg.h>
+#include <mach-bcmring/csp/mm_io.h>
+#include <mach-bcmring/csp/hw_cfg.h>
 /* Base address */
 #define tmrHw_MODULE_BASE_ADDR          MM_IO_BASE_TMR
 
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/dma.h b/arch/arm/mach-bcmring/include/mach-bcmring/dma.h
index 7254378..366caa3 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/dma.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/dma.h
@@ -28,7 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/semaphore.h>
 #include <csp/dmacHw.h>
-#include <mach/timer.h>
+#include <mach-bcmring/timer.h>
 
 /* ---- Constants and Types ---------------------------------------------- */
 
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/entry-macro.S b/arch/arm/mach-bcmring/include/mach-bcmring/entry-macro.S
index 2f316f0..8967896 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/entry-macro.S
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/entry-macro.S
@@ -17,9 +17,9 @@
  * Low-level IRQ helper macros for BCMRing-based platforms
  *
  */
-#include <mach/irqs.h>
-#include <mach/hardware.h>
-#include <mach/csp/mm_io.h>
+#include <mach-bcmring/irqs.h>
+#include <mach-bcmring/hardware.h>
+#include <mach-bcmring/csp/mm_io.h>
 
 		.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
 		ldr	\base, =(MM_IO_BASE_INTC0)
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/hardware.h b/arch/arm/mach-bcmring/include/mach-bcmring/hardware.h
index 6ae20a6..c708efd 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/hardware.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/hardware.h
@@ -23,7 +23,7 @@
 
 #include <asm/sizes.h>
 #include <cfg_global.h>
-#include <mach/csp/mm_io.h>
+#include <mach-bcmring/csp/mm_io.h>
 
 /* Hardware addresses of major areas.
  *  *_START is the physical address
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/reg_nand.h b/arch/arm/mach-bcmring/include/mach-bcmring/reg_nand.h
index 387376f..ec773c2 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/reg_nand.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/reg_nand.h
@@ -31,7 +31,7 @@
 
 /* ---- Include Files ---------------------------------------------------- */
 #include <csp/reg.h>
-#include <mach/reg_umi.h>
+#include <mach-bcmring/reg_umi.h>
 
 /* ---- Constants and Types ---------------------------------------------- */
 
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/reg_umi.h b/arch/arm/mach-bcmring/include/mach-bcmring/reg_umi.h
index 0992842..f659cc1 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/reg_umi.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/reg_umi.h
@@ -31,7 +31,7 @@
 
 /* ---- Include Files ---------------------------------------------------- */
 #include <csp/reg.h>
-#include <mach/csp/mm_io.h>
+#include <mach-bcmring/csp/mm_io.h>
 
 /* ---- Constants and Types ---------------------------------------------- */
 
diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/uncompress.h b/arch/arm/mach-bcmring/include/mach-bcmring/uncompress.h
index 9c9821b..b11fb3f 100644
--- a/arch/arm/mach-bcmring/include/mach-bcmring/uncompress.h
+++ b/arch/arm/mach-bcmring/include/mach-bcmring/uncompress.h
@@ -11,7 +11,7 @@
 * license other than the GPL, without Broadcom's express prior written
 * consent.
 *****************************************************************************/
-#include <mach/csp/mm_addr.h>
+#include <mach-bcmring/csp/mm_addr.h>
 
 #define BCMRING_UART_0_DR (*(volatile unsigned int *)MM_ADDR_IO_UARTA)
 #define BCMRING_UART_0_FR (*(volatile unsigned int *)(MM_ADDR_IO_UARTA + 0x18))
diff --git a/arch/arm/mach-bcmring/irq.c b/arch/arm/mach-bcmring/irq.c
index 437fa68..aa88cac 100644
--- a/arch/arm/mach-bcmring/irq.c
+++ b/arch/arm/mach-bcmring/irq.c
@@ -22,12 +22,12 @@
 #include <linux/timer.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
+#include <mach-bcmring/hardware.h>
 #include <asm/irq.h>
 
 #include <asm/mach/irq.h>
-#include <mach/csp/intcHw_reg.h>
-#include <mach/csp/mm_io.h>
+#include <mach-bcmring/csp/intcHw_reg.h>
+#include <mach-bcmring/csp/mm_io.h>
 
 static void bcmring_mask_irq0(struct irq_data *d)
 {
diff --git a/arch/arm/mach-bcmring/mm.c b/arch/arm/mach-bcmring/mm.c
index 1adec78e..411fa2b 100644
--- a/arch/arm/mach-bcmring/mm.c
+++ b/arch/arm/mach-bcmring/mm.c
@@ -17,8 +17,8 @@
 #include <asm/page.h>
 #include <asm/mach/map.h>
 
-#include <mach/hardware.h>
-#include <mach/csp/mm_io.h>
+#include <mach-bcmring/hardware.h>
+#include <mach-bcmring/csp/mm_io.h>
 
 #define IO_DESC(va, sz) { .virtual = va, \
 	.pfn = __phys_to_pfn(HW_IO_VIRT_TO_PHYS(va)), \
diff --git a/arch/arm/mach-bcmring/timer.c b/arch/arm/mach-bcmring/timer.c
index af9c3d7..ba9754d 100644
--- a/arch/arm/mach-bcmring/timer.c
+++ b/arch/arm/mach-bcmring/timer.c
@@ -16,7 +16,7 @@
 #include <linux/module.h>
 #include <csp/tmrHw.h>
 
-#include <mach/timer.h>
+#include <mach-bcmring/timer.h>
 /* The core.c file initializes timers 1 and 3 as a linux clocksource. */
 /* The real time clock should probably be the real linux clocksource. */
 /* In the meantime, this file should agree with core.c as to the */
diff --git a/arch/arm/mach-clps711x/autcpu12.c b/arch/arm/mach-clps711x/autcpu12.c
index 3fb79a1..82ec281 100644
--- a/arch/arm/mach-clps711x/autcpu12.c
+++ b/arch/arm/mach-clps711x/autcpu12.c
@@ -24,7 +24,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 #include <asm/sizes.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -33,7 +33,7 @@
 #include <asm/page.h>
 
 #include <asm/mach/map.h>
-#include <mach/autcpu12.h>
+#include <mach-clps711x/autcpu12.h>
 
 #include "common.h"
 
diff --git a/arch/arm/mach-clps711x/cdb89712.c b/arch/arm/mach-clps711x/cdb89712.c
index c314f49..6693600 100644
--- a/arch/arm/mach-clps711x/cdb89712.c
+++ b/arch/arm/mach-clps711x/cdb89712.c
@@ -24,7 +24,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/setup.h>
diff --git a/arch/arm/mach-clps711x/ceiva.c b/arch/arm/mach-clps711x/ceiva.c
index a70147e..177fb74 100644
--- a/arch/arm/mach-clps711x/ceiva.c
+++ b/arch/arm/mach-clps711x/ceiva.c
@@ -27,7 +27,7 @@
 
 #include <linux/kernel.h>
 
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/sizes.h>
diff --git a/arch/arm/mach-clps711x/common.c b/arch/arm/mach-clps711x/common.c
index f15293b..5b4fa62 100644
--- a/arch/arm/mach-clps711x/common.c
+++ b/arch/arm/mach-clps711x/common.c
@@ -28,7 +28,7 @@
 #include <linux/sched.h>
 
 #include <asm/sizes.h>
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 #include <asm/irq.h>
 #include <asm/leds.h>
 #include <asm/pgtable.h>
diff --git a/arch/arm/mach-clps711x/edb7211-mm.c b/arch/arm/mach-clps711x/edb7211-mm.c
index 4372f06..6d3e94e 100644
--- a/arch/arm/mach-clps711x/edb7211-mm.c
+++ b/arch/arm/mach-clps711x/edb7211-mm.c
@@ -23,7 +23,7 @@
 #include <linux/init.h>
 #include <linux/bug.h>
 
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 #include <asm/page.h>
 #include <asm/sizes.h>
  
diff --git a/arch/arm/mach-clps711x/fortunet.c b/arch/arm/mach-clps711x/fortunet.c
index 3a3f0b7..12a1368 100644
--- a/arch/arm/mach-clps711x/fortunet.c
+++ b/arch/arm/mach-clps711x/fortunet.c
@@ -23,7 +23,7 @@
 #include <linux/init.h>
 #include <linux/initrd.h>
 
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-clps711x/include/mach-clps711x/debug-macro.S b/arch/arm/mach-clps711x/include/mach-clps711x/debug-macro.S
index 118b3d9..52bd3ef 100644
--- a/arch/arm/mach-clps711x/include/mach-clps711x/debug-macro.S
+++ b/arch/arm/mach-clps711x/include/mach-clps711x/debug-macro.S
@@ -11,7 +11,7 @@
  *
 */
 
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 
 		.macro	addruart, rp, rv, tmp
 #ifndef CONFIG_DEBUG_CLPS711X_UART2
diff --git a/arch/arm/mach-clps711x/include/mach-clps711x/entry-macro.S b/arch/arm/mach-clps711x/include/mach-clps711x/entry-macro.S
index 56e5c2c..889521e 100644
--- a/arch/arm/mach-clps711x/include/mach-clps711x/entry-macro.S
+++ b/arch/arm/mach-clps711x/include/mach-clps711x/entry-macro.S
@@ -7,7 +7,7 @@
  * License version 2. This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
  */
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 
 		.macro	get_irqnr_preamble, base, tmp
 		.endm
diff --git a/arch/arm/mach-clps711x/include/mach-clps711x/hardware.h b/arch/arm/mach-clps711x/include/mach-clps711x/hardware.h
index 13a64fc..29f3409 100644
--- a/arch/arm/mach-clps711x/include/mach-clps711x/hardware.h
+++ b/arch/arm/mach-clps711x/include/mach-clps711x/hardware.h
@@ -22,7 +22,7 @@
 #ifndef __MACH_HARDWARE_H
 #define __MACH_HARDWARE_H
 
-#include <mach/clps711x.h>
+#include <mach-clps711x/clps711x.h>
 
 #define CLPS711X_VIRT_BASE	IOMEM(0xff000000)
 
diff --git a/arch/arm/mach-clps711x/include/mach-clps711x/uncompress.h b/arch/arm/mach-clps711x/include/mach-clps711x/uncompress.h
index 7b28d6a..92a5ee1 100644
--- a/arch/arm/mach-clps711x/include/mach-clps711x/uncompress.h
+++ b/arch/arm/mach-clps711x/include/mach-clps711x/uncompress.h
@@ -17,7 +17,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-#include <mach/clps711x.h>
+#include <mach-clps711x/clps711x.h>
 
 #ifdef CONFIG_DEBUG_CLPS711X_UART2
 #define SYSFLGx	SYSFLG2
diff --git a/arch/arm/mach-clps711x/p720t-leds.c b/arch/arm/mach-clps711x/p720t-leds.c
index bbc449f..b0b684f 100644
--- a/arch/arm/mach-clps711x/p720t-leds.c
+++ b/arch/arm/mach-clps711x/p720t-leds.c
@@ -23,7 +23,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-clps711x/p720t.c b/arch/arm/mach-clps711x/p720t.c
index f266d90..e83d055 100644
--- a/arch/arm/mach-clps711x/p720t.c
+++ b/arch/arm/mach-clps711x/p720t.c
@@ -24,7 +24,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/setup.h>
@@ -32,7 +32,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
-#include <mach/syspld.h>
+#include <mach-clps711x/syspld.h>
 
 #include "common.h"
 
diff --git a/arch/arm/mach-cns3xxx/cns3420vb.c b/arch/arm/mach-cns3xxx/cns3420vb.c
index 2c5fb4c..6e663cf 100644
--- a/arch/arm/mach-cns3xxx/cns3420vb.c
+++ b/arch/arm/mach-cns3xxx/cns3420vb.c
@@ -30,8 +30,8 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
-#include <mach/cns3xxx.h>
-#include <mach/irqs.h>
+#include <mach-cns3xxx/cns3xxx.h>
+#include <mach-cns3xxx/irqs.h>
 #include "core.h"
 #include "devices.h"
 
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index 031805b..1c7da63 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -17,7 +17,7 @@
 #include <asm/mach/irq.h>
 #include <asm/hardware/gic.h>
 #include <asm/hardware/cache-l2x0.h>
-#include <mach/cns3xxx.h>
+#include <mach-cns3xxx/cns3xxx.h>
 #include "core.h"
 
 static struct map_desc cns3xxx_io_desc[] __initdata = {
diff --git a/arch/arm/mach-cns3xxx/devices.c b/arch/arm/mach-cns3xxx/devices.c
index 1e40c99..ef5c80c 100644
--- a/arch/arm/mach-cns3xxx/devices.c
+++ b/arch/arm/mach-cns3xxx/devices.c
@@ -16,9 +16,9 @@
 #include <linux/compiler.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
-#include <mach/cns3xxx.h>
-#include <mach/irqs.h>
-#include <mach/pm.h>
+#include <mach-cns3xxx/cns3xxx.h>
+#include <mach-cns3xxx/irqs.h>
+#include <mach-cns3xxx/pm.h>
 #include "core.h"
 #include "devices.h"
 
diff --git a/arch/arm/mach-cns3xxx/include/mach-cns3xxx/irqs.h b/arch/arm/mach-cns3xxx/include/mach-cns3xxx/irqs.h
index 2ab96f8..a9712a6 100644
--- a/arch/arm/mach-cns3xxx/include/mach-cns3xxx/irqs.h
+++ b/arch/arm/mach-cns3xxx/include/mach-cns3xxx/irqs.h
@@ -15,7 +15,7 @@
 #define IRQ_LOCALWDOG		30
 #define IRQ_TC11MP_GIC_START	32
 
-#include <mach/cns3xxx.h>
+#include <mach-cns3xxx/cns3xxx.h>
 
 #ifndef NR_IRQS
 #error "NR_IRQS not defined by the board-specific files"
diff --git a/arch/arm/mach-cns3xxx/include/mach-cns3xxx/uncompress.h b/arch/arm/mach-cns3xxx/include/mach-cns3xxx/uncompress.h
index a91b605..8b2a4b6 100644
--- a/arch/arm/mach-cns3xxx/include/mach-cns3xxx/uncompress.h
+++ b/arch/arm/mach-cns3xxx/include/mach-cns3xxx/uncompress.h
@@ -8,7 +8,7 @@
  */
 
 #include <asm/mach-types.h>
-#include <mach/cns3xxx.h>
+#include <mach-cns3xxx/cns3xxx.h>
 
 #define AMBA_UART_DR(base)	(*(volatile unsigned char *)((base) + 0x00))
 #define AMBA_UART_LCRH(base)	(*(volatile unsigned char *)((base) + 0x2c))
diff --git a/arch/arm/mach-cns3xxx/pcie.c b/arch/arm/mach-cns3xxx/pcie.c
index 3113283..873e6cd 100644
--- a/arch/arm/mach-cns3xxx/pcie.c
+++ b/arch/arm/mach-cns3xxx/pcie.c
@@ -20,7 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/ptrace.h>
 #include <asm/mach/map.h>
-#include <mach/cns3xxx.h>
+#include <mach-cns3xxx/cns3xxx.h>
 #include "core.h"
 
 enum cns3xxx_access_type {
diff --git a/arch/arm/mach-cns3xxx/pm.c b/arch/arm/mach-cns3xxx/pm.c
index 3645808..40b6e73 100644
--- a/arch/arm/mach-cns3xxx/pm.c
+++ b/arch/arm/mach-cns3xxx/pm.c
@@ -11,8 +11,8 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
-#include <mach/cns3xxx.h>
-#include <mach/pm.h>
+#include <mach-cns3xxx/cns3xxx.h>
+#include <mach-cns3xxx/pm.h>
 #include "core.h"
 
 void cns3xxx_pwr_clk_en(unsigned int block)
diff --git a/arch/arm/mach-davinci/aemif.c b/arch/arm/mach-davinci/aemif.c
index 1ce70a9..4ef9dab 100644
--- a/arch/arm/mach-davinci/aemif.c
+++ b/arch/arm/mach-davinci/aemif.c
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 
-#include <mach/aemif.h>
+#include <mach-davinci/aemif.h>
 
 /* Timing value configuration */
 
diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 0031864..c07754e 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -26,13 +26,13 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/cp_intc.h>
-#include <mach/mux.h>
-#include <mach/nand.h>
-#include <mach/da8xx.h>
-#include <mach/usb.h>
-#include <mach/aemif.h>
-#include <mach/spi.h>
+#include <mach-davinci/cp_intc.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/nand.h>
+#include <mach-davinci/da8xx.h>
+#include <mach-davinci/usb.h>
+#include <mach-davinci/aemif.h>
+#include <mach-davinci/spi.h>
 
 #define DA830_EVM_PHY_ID		""
 /*
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 0149fb4..6fe905e 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -38,12 +38,12 @@
 #include <asm/mach/arch.h>
 #include <asm/system_info.h>
 
-#include <mach/cp_intc.h>
-#include <mach/da8xx.h>
-#include <mach/nand.h>
-#include <mach/mux.h>
-#include <mach/aemif.h>
-#include <mach/spi.h>
+#include <mach-davinci/cp_intc.h>
+#include <mach-davinci/da8xx.h>
+#include <mach-davinci/nand.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/aemif.h>
+#include <mach-davinci/spi.h>
 
 #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
 #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 1c7b1f4..fc915d1 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -26,11 +26,11 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/i2c.h>
-#include <mach/serial.h>
-#include <mach/nand.h>
-#include <mach/mmc.h>
-#include <mach/usb.h>
+#include <mach-davinci/i2c.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/nand.h>
+#include <mach-davinci/mmc.h>
+#include <mach-davinci/usb.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index 8e77032..02eb053 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -23,11 +23,11 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/i2c.h>
-#include <mach/serial.h>
-#include <mach/nand.h>
-#include <mach/mmc.h>
-#include <mach/usb.h>
+#include <mach-davinci/i2c.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/nand.h>
+#include <mach-davinci/mmc.h>
+#include <mach-davinci/usb.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 688a9c5..f661663 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -31,13 +31,13 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/mux.h>
-#include <mach/common.h>
-#include <mach/i2c.h>
-#include <mach/serial.h>
-#include <mach/mmc.h>
-#include <mach/nand.h>
-#include <mach/keyscan.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/i2c.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/mmc.h>
+#include <mach-davinci/nand.h>
+#include <mach-davinci/keyscan.h>
 
 #include <media/tvp514x.h>
 
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index d34ed55..58ff3e7 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -30,14 +30,14 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/common.h>
-#include <mach/i2c.h>
-#include <mach/serial.h>
-#include <mach/mux.h>
-#include <mach/nand.h>
-#include <mach/mmc.h>
-#include <mach/usb.h>
-#include <mach/aemif.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/i2c.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/nand.h>
+#include <mach-davinci/mmc.h>
+#include <mach-davinci/usb.h>
+#include <mach-davinci/aemif.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 958679a..8f6ddc3 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -36,13 +36,13 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/common.h>
-#include <mach/serial.h>
-#include <mach/i2c.h>
-#include <mach/nand.h>
-#include <mach/clock.h>
-#include <mach/cdce949.h>
-#include <mach/aemif.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/i2c.h>
+#include <mach-davinci/nand.h>
+#include <mach-davinci/clock.h>
+#include <mach-davinci/cdce949.h>
+#include <mach-davinci/aemif.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
index beecde3..dce12d5 100644
--- a/arch/arm/mach-davinci/board-mityomapl138.c
+++ b/arch/arm/mach-davinci/board-mityomapl138.c
@@ -23,12 +23,12 @@
 #include <asm/io.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-#include <mach/common.h>
-#include <mach/cp_intc.h>
-#include <mach/da8xx.h>
-#include <mach/nand.h>
-#include <mach/mux.h>
-#include <mach/spi.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/cp_intc.h>
+#include <mach-davinci/da8xx.h>
+#include <mach-davinci/nand.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/spi.h>
 
 #define MITYOMAPL138_PHY_ID		""
 
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 5de69f2..26034db 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -30,13 +30,13 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/common.h>
-#include <mach/i2c.h>
-#include <mach/serial.h>
-#include <mach/mux.h>
-#include <mach/nand.h>
-#include <mach/mmc.h>
-#include <mach/usb.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/i2c.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/nand.h>
+#include <mach-davinci/mmc.h>
+#include <mach-davinci/usb.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/board-omapl138-hawk.c b/arch/arm/mach-davinci/board-omapl138-hawk.c
index dc1208e..ee4ae67 100644
--- a/arch/arm/mach-davinci/board-omapl138-hawk.c
+++ b/arch/arm/mach-davinci/board-omapl138-hawk.c
@@ -17,9 +17,9 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/cp_intc.h>
-#include <mach/da8xx.h>
-#include <mach/mux.h>
+#include <mach-davinci/cp_intc.h>
+#include <mach-davinci/da8xx.h>
+#include <mach-davinci/mux.h>
 
 #define HAWKBOARD_PHY_ID		"davinci_mdio-0:07"
 #define DA850_HAWK_MMCSD_CD_PIN		GPIO_TO_PIN(3, 12)
diff --git a/arch/arm/mach-davinci/board-sffsdr.c b/arch/arm/mach-davinci/board-sffsdr.c
index 9078acf..19c84ce 100644
--- a/arch/arm/mach-davinci/board-sffsdr.c
+++ b/arch/arm/mach-davinci/board-sffsdr.c
@@ -35,11 +35,11 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
 
-#include <mach/common.h>
-#include <mach/i2c.h>
-#include <mach/serial.h>
-#include <mach/mux.h>
-#include <mach/usb.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/i2c.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/usb.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index ac4e003..1e58d68 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -30,11 +30,11 @@
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
-#include <mach/irqs.h>
-#include <mach/edma.h>
-#include <mach/mux.h>
-#include <mach/cp_intc.h>
-#include <mach/tnetv107x.h>
+#include <mach-davinci/irqs.h>
+#include <mach-davinci/edma.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/cp_intc.h>
+#include <mach-davinci/tnetv107x.h>
 
 #define EVM_MMC_WP_GPIO		21
 #define EVM_MMC_CD_GPIO		24
diff --git a/arch/arm/mach-davinci/cdce949.c b/arch/arm/mach-davinci/cdce949.c
index f2232ca..3794178 100644
--- a/arch/arm/mach-davinci/cdce949.c
+++ b/arch/arm/mach-davinci/cdce949.c
@@ -19,8 +19,8 @@
 #include <linux/i2c.h>
 #include <linux/module.h>
 
-#include <mach/clock.h>
-#include <mach/cdce949.h>
+#include <mach-davinci/clock.h>
+#include <mach-davinci/cdce949.h>
 
 #include "clock.h"
 
diff --git a/arch/arm/mach-davinci/clock.c b/arch/arm/mach-davinci/clock.c
index 34668ea..c26fd64 100644
--- a/arch/arm/mach-davinci/clock.c
+++ b/arch/arm/mach-davinci/clock.c
@@ -20,11 +20,11 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 
-#include <mach/hardware.h>
+#include <mach-davinci/hardware.h>
 
-#include <mach/clock.h>
-#include <mach/psc.h>
-#include <mach/cputype.h>
+#include <mach-davinci/clock.h>
+#include <mach-davinci/psc.h>
+#include <mach-davinci/cputype.h>
 #include "clock.h"
 
 static LIST_HEAD(clocks);
diff --git a/arch/arm/mach-davinci/common.c b/arch/arm/mach-davinci/common.c
index 64b0f65..3e997d7 100644
--- a/arch/arm/mach-davinci/common.c
+++ b/arch/arm/mach-davinci/common.c
@@ -17,8 +17,8 @@
 #include <asm/tlb.h>
 #include <asm/mach/map.h>
 
-#include <mach/common.h>
-#include <mach/cputype.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/cputype.h>
 
 #include "clock.h"
 
diff --git a/arch/arm/mach-davinci/cp_intc.c b/arch/arm/mach-davinci/cp_intc.c
index 006dae8..51b1513 100644
--- a/arch/arm/mach-davinci/cp_intc.c
+++ b/arch/arm/mach-davinci/cp_intc.c
@@ -18,8 +18,8 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 
-#include <mach/common.h>
-#include <mach/cp_intc.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/cp_intc.h>
 
 static inline unsigned int cp_intc_read(unsigned offset)
 {
diff --git a/arch/arm/mach-davinci/cpufreq.c b/arch/arm/mach-davinci/cpufreq.c
index 4729eaa..4ef3927 100644
--- a/arch/arm/mach-davinci/cpufreq.c
+++ b/arch/arm/mach-davinci/cpufreq.c
@@ -26,9 +26,9 @@
 #include <linux/platform_device.h>
 #include <linux/export.h>
 
-#include <mach/hardware.h>
-#include <mach/cpufreq.h>
-#include <mach/common.h>
+#include <mach-davinci/hardware.h>
+#include <mach-davinci/cpufreq.h>
+#include <mach-davinci/common.h>
 
 #include "clock.h"
 
diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index 9107691..9d3d884c 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -20,8 +20,8 @@
 #include <asm/proc-fns.h>
 #include <asm/cpuidle.h>
 
-#include <mach/cpuidle.h>
-#include <mach/ddr2.h>
+#include <mach-davinci/cpuidle.h>
+#include <mach-davinci/ddr2.h>
 
 #define DAVINCI_CPUIDLE_MAX_STATES	2
 
diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index deee5c2..a482e57 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -14,13 +14,13 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/psc.h>
-#include <mach/irqs.h>
-#include <mach/cputype.h>
-#include <mach/common.h>
-#include <mach/time.h>
-#include <mach/da8xx.h>
-#include <mach/gpio-davinci.h>
+#include <mach-davinci/psc.h>
+#include <mach-davinci/irqs.h>
+#include <mach-davinci/cputype.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/time.h>
+#include <mach-davinci/da8xx.h>
+#include <mach-davinci/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index b44dc84..7a16c6e 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -20,15 +20,15 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/psc.h>
-#include <mach/irqs.h>
-#include <mach/cputype.h>
-#include <mach/common.h>
-#include <mach/time.h>
-#include <mach/da8xx.h>
-#include <mach/cpufreq.h>
-#include <mach/pm.h>
-#include <mach/gpio-davinci.h>
+#include <mach-davinci/psc.h>
+#include <mach-davinci/irqs.h>
+#include <mach-davinci/cputype.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/time.h>
+#include <mach-davinci/da8xx.h>
+#include <mach-davinci/cpufreq.h>
+#include <mach-davinci/pm.h>
+#include <mach-davinci/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 8db0fc6..fe9c203 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -23,9 +23,9 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 
-#include <mach/asp.h>
-#include <mach/keyscan.h>
-#include <mach/hardware.h>
+#include <mach-davinci/asp.h>
+#include <mach-davinci/keyscan.h>
+#include <mach-davinci/hardware.h>
 
 #include <media/davinci/vpfe_capture.h>
 #include <media/davinci/vpif_types.h>
diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index 783eab6..d851270 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -17,11 +17,11 @@
 #include <linux/ahci_platform.h>
 #include <linux/clk.h>
 
-#include <mach/cputype.h>
-#include <mach/common.h>
-#include <mach/time.h>
-#include <mach/da8xx.h>
-#include <mach/cpuidle.h>
+#include <mach-davinci/cputype.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/time.h>
+#include <mach-davinci/da8xx.h>
+#include <mach-davinci/cpuidle.h>
 
 #include "clock.h"
 
diff --git a/arch/arm/mach-davinci/devices-tnetv107x.c b/arch/arm/mach-davinci/devices-tnetv107x.c
index 29b17f7..e25ca91 100644
--- a/arch/arm/mach-davinci/devices-tnetv107x.c
+++ b/arch/arm/mach-davinci/devices-tnetv107x.c
@@ -19,10 +19,10 @@
 #include <linux/clk.h>
 #include <linux/slab.h>
 
-#include <mach/common.h>
-#include <mach/irqs.h>
-#include <mach/edma.h>
-#include <mach/tnetv107x.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/irqs.h>
+#include <mach-davinci/edma.h>
+#include <mach-davinci/tnetv107x.h>
 
 #include "clock.h"
 
diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index d2f96662..31fe1a8 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -14,14 +14,14 @@
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
-#include <mach/i2c.h>
-#include <mach/irqs.h>
-#include <mach/cputype.h>
-#include <mach/mux.h>
-#include <mach/edma.h>
-#include <mach/mmc.h>
-#include <mach/time.h>
+#include <mach-davinci/hardware.h>
+#include <mach-davinci/i2c.h>
+#include <mach-davinci/irqs.h>
+#include <mach-davinci/cputype.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/edma.h>
+#include <mach-davinci/mmc.h>
+#include <mach-davinci/time.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 678cd99..5279a55 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -18,17 +18,17 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/cputype.h>
-#include <mach/edma.h>
-#include <mach/psc.h>
-#include <mach/mux.h>
-#include <mach/irqs.h>
-#include <mach/time.h>
-#include <mach/serial.h>
-#include <mach/common.h>
-#include <mach/asp.h>
-#include <mach/spi.h>
-#include <mach/gpio-davinci.h>
+#include <mach-davinci/cputype.h>
+#include <mach-davinci/edma.h>
+#include <mach-davinci/psc.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/irqs.h>
+#include <mach-davinci/time.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/asp.h>
+#include <mach-davinci/spi.h>
+#include <mach-davinci/gpio-davinci.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index a50d49de..8f55461 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -21,18 +21,18 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/cputype.h>
-#include <mach/edma.h>
-#include <mach/psc.h>
-#include <mach/mux.h>
-#include <mach/irqs.h>
-#include <mach/time.h>
-#include <mach/serial.h>
-#include <mach/common.h>
-#include <mach/asp.h>
-#include <mach/keyscan.h>
-#include <mach/spi.h>
-#include <mach/gpio-davinci.h>
+#include <mach-davinci/cputype.h>
+#include <mach-davinci/edma.h>
+#include <mach-davinci/psc.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/irqs.h>
+#include <mach-davinci/time.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/asp.h>
+#include <mach-davinci/keyscan.h>
+#include <mach-davinci/spi.h>
+#include <mach-davinci/gpio-davinci.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index c8b8666..6355eaf 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -15,16 +15,16 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/cputype.h>
-#include <mach/edma.h>
-#include <mach/irqs.h>
-#include <mach/psc.h>
-#include <mach/mux.h>
-#include <mach/time.h>
-#include <mach/serial.h>
-#include <mach/common.h>
-#include <mach/asp.h>
-#include <mach/gpio-davinci.h>
+#include <mach-davinci/cputype.h>
+#include <mach-davinci/edma.h>
+#include <mach-davinci/irqs.h>
+#include <mach-davinci/psc.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/time.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/asp.h>
+#include <mach-davinci/gpio-davinci.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 9eb87c1..0c9515e 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -16,16 +16,16 @@
 
 #include <asm/mach/map.h>
 
-#include <mach/cputype.h>
-#include <mach/edma.h>
-#include <mach/irqs.h>
-#include <mach/psc.h>
-#include <mach/mux.h>
-#include <mach/time.h>
-#include <mach/serial.h>
-#include <mach/common.h>
-#include <mach/asp.h>
-#include <mach/gpio-davinci.h>
+#include <mach-davinci/cputype.h>
+#include <mach-davinci/edma.h>
+#include <mach-davinci/irqs.h>
+#include <mach-davinci/psc.h>
+#include <mach-davinci/mux.h>
+#include <mach-davinci/time.h>
+#include <mach-davinci/serial.h>
+#include <mach-davinci/common.h>
+#include <mach-davinci/asp.h>
+#include <mach-davinci/gpio-davinci.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/dma.c b/arch/arm/mach-davinci/dma.c
index a685e97..f0093a8 100644
--- a/arch/arm/mach-davinci/dma.c
+++ b/arch/arm/mach-davinci/dma.c
@@ -25,7 +25,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include <mach/edma.h>
+#include <mach-davinci/edma.h>
 
 /* Offsets matching "struct edmacc_param" */
 #define PARM_OPT		0x00
diff --git a/arch/arm/mach-davinci/include/mach-davinci/asp.h b/arch/arm/mach-davinci/include/mach-davinci/asp.h
index 9aa2409..64e468f 100644
--- a/arch/arm/mach-davinci/include/mach-davinci/asp.h
+++ b/arch/arm/mach-davinci/include/mach-davinci/asp.h
@@ -4,8 +4,8 @@
 #ifndef __ASM_ARCH_DAVINCI_ASP_H
 #define __ASM_ARCH_DAVINCI_ASP_H
 
-#include <mach/irqs.h>
-#include <mach/edma.h>
+#include <mach-davinci/irqs.h>
+#include <mach-davinci/edma.h>
 
 /* Bases of dm644x and dm355 register banks */
 #define DAVINCI_ASP0_BASE	0x01E02000
---
Intentionally cut off for review. If you managed to read this far, you
get the idea. See the rest at
http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=commit;h=d59d6b49ed5287dd0131acda9428fdc0bb0a7365
