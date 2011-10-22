Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1JVJ5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 05:57:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56599 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1JVJ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 05:57:19 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Subject: [PATCH V3 00/49] Tree wide: cleanup IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:56:12 +0800
Message-Id: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Since the merge window will open soon, and the following patches
are the loftovers, Could you please pick them up?

Thanks,
Yong

------------------changelog from V2 to V3------------------------
Changelog V3 < V2:
  -- Refresh the patches based on next-20111014

  -- Drop below patches since it's been taken:
       ata-irq-Remove-IRQF_DISABLED.patch
       i2c-irq-Remove-IRQF_DISABLED.patch
       infiniband-irq-Remove-IRQF_DISABLED.patch
       mmc-irq-Remove-IRQF_DISABLED.patch
       TTY-irq-Remove-IRQF_DISABLED.patch
       video-irq-Remove-IRQF_DISABLED.patch
       sound-irq-Remove-IRQF_DISABLED.patch

  -- Collect more Acks.

  -- Add one more patches which do more cleanup on USB.
       USB-pxa168-xls-irq-Remove-IRQF_DISABLED.patch
         When I made the patch which has been picked up by Greg,
         ehci-pxa168 and ohci-xls is not included in the tree yet.
         So now we have this additional patch.

------------------changelog from V1 to V2------------------------
Changelog V2 < V1:
  -- Change c58543c8 to e58aa3d2 to reflect the correct commit

  -- Drop below patches since it's been taken:
       hexagon-irq-Remove-IRQF_DISABLED.patch (Richard Kuo)
       hwmon-irq-Remove-IRQF_DISABLED.patch   (Guenter Roeck)

  -- Collect more Acks.

------------------changelog from V0 to V1------------------------
Changelog V1 < V0:
  -- Show more info in the commit log, thus make the patch more
     easy to review (Required by David Miller)
  
  -- Drop below pathces since they are not needed any more:
       mpu401-snd_mpu401_uart_new-split-semantic-of-irq_fla.patch
       gpio-irq-Remove-IRQF_DISABLED.patch

  -- Drop below patches since they are picked by individual maintainer:
       Blackfin-irq-Remove-IRQF_DISABLED.patch (Bob Liu)
       staging-irq-Remove-IRQF_DISABLED.patch  (Greg KH)
       USB-irq-Remove-IRQF_DISABLED.patch      (Greg KH)
       Input-irq-Remove-IRQF_DISABLED.patch    (Dmitry Torokhov)
       mfd-irq-Remove-IRQF_DISABLED.patch      (Samuel Ortiz)

  -- Collect some Acks.
     Almost half of the patches get Acks(for the whole patch or part).

  -- Refresh this patchset based on next-20110920 (commit 8c024a21).
  
  -- Add two more patches:
       hexagon-irq-Remove-IRQF_DISABLED.patch
       hwmon-irq-Remove-IRQF_DISABLED.patch
         The two new add patches make me think that we should push this
         patches to upstream ASAP.

------------------------base log(in V0)-------------------------
IRQF_DISABLED has been marked 'removal' for some time, now this
trival patchset achive the goal.
Most of the patch is one-line change/remove IRQF_DISABLED
except patch-0001.

patch-0001 just remove the workround which live with IRQF_DISABLED
is not NOOP, say before v2.6.35.

Others just do:
  --if IRQF_DISABLED is combined with other irq_flags,just remove
    IRQF_DISABLED;
  --if IRQF_DISABLED is the only irq_flags of request_irq(),
    change IRQF_DISABLED to 0 like some callers of request_irq()
    have done.
  --if IRQF_DISABLED is the only flags if irq_action, just remove
    that item.

And I make the patches based on subdirs, so it's more easy to be
reviewed/taken by relevant trees than one-big-patch.

---
Yong Zhang (49):
  usb/hcd: Remove tricky code dealing with IRQF_DISABLED && IRQF_SHARED
  alpha: irq: Remove IRQF_DISABLED
  arm: irq: Remove IRQF_DISABLED
  avr32: irq: Remove IRQF_DISABLED
  cris: irq: Remove IRQF_DISABLED
  frv: irq: Remove IRQF_DISABLED
  h8300: irq: Remove IRQF_DISABLED
  ia64: irq: Remove IRQF_DISABLED
  m32r: irq: Remove IRQF_DISABLED
  m68k: irq: Remove IRQF_DISABLED
  microblaze: irq: Remove IRQF_DISABLED
  MIPS: irq: Remove IRQF_DISABLED
  mn10300: irq: Remove IRQF_DISABLED
  parisc: irq: remove IRQF_DISABLED
  powerpc: irq: Remove IRQF_DISABLED
  SH: irq: Remove IRQF_DISABLED
  sparc: irq: Remove IRQF_DISABLED
  um: irq: Remove IRQF_DISABLED
  unicore32: Remove IRQF_DISABLED
  x86: irq: Remove IRQF_DISABLED
  xtensa: irq: Remove IRQF_DISABLED
  score: irq: Remove IRQF_DISABLED
  clocksource: irq: Remove IRQF_DISABLED
  SCSI: irq: Remove IRQF_DISABLED
  block: irq: Remove IRQF_DISABLED
  cdrom: irq: Remove IRQF_DISABLED
  driver/char: irq: Remove IRQF_DISABLED
  crypto: irq: Remove IRQF_DISABLED
  dmaengine: irq: Remove IRQF_DISABLED
  EDAC: irq: Remove IRQF_DISABLED
  ISDN: irq: Remove IRQF_DISABLED
  media: irq: Remove IRQF_DISABLED
  drivers:misc:irq: Remove IRQF_DISABLED
  mtd: irq: Remove IRQF_DISABLED
  net: irq: Remove IRQF_DISABLED
  dirvers/parisc: irq: Remove IRQF_DISABLED
  pcmcia: irq: Remove IRQF_DISABLED
  sony-laptop:irq: Remove IRQF_DISABLED
  PNP: irq: Remove IRQF_DISABLED
  power_supply:irq: Remove IRQF_DISABLED
  powerpc/ps3: irq: Remove IRQF_DISABLED
  rtc: irq: Remove IRQF_DISABLED
  spi: irq: Remove IRQF_DISABLED
  w1: irq: Remove IRQF_DISABLED
  watchdog: irq: Remove IRQF_DISABLED
  xen: irq: Remove IRQF_DISABLED
  Documentation: irq: Change documents related to IRQF_DISABLED
  USB: pxa168: xls: irq: Remove IRQF_DISABLED
  genirq: Remove IRQF_DISABLED

 Documentation/PCI/MSI-HOWTO.txt                 |   21 ---------------------
 Documentation/feature-removal-schedule.txt      |    7 -------
 Documentation/scsi/ncr53c8xx.txt                |    3 ++-
 Documentation/scsi/tmscsim.txt                  |    4 ++--
 arch/alpha/include/asm/floppy.h                 |    2 +-
 arch/alpha/kernel/irq_alpha.c                   |    1 -
 arch/alpha/kernel/sys_titan.c                   |   14 +++++++-------
 arch/arm/common/time-acorn.c                    |    1 -
 arch/arm/common/timer-sp.c                      |    2 +-
 arch/arm/include/asm/floppy.h                   |    2 +-
 arch/arm/kernel/perf_event.c                    |    2 +-
 arch/arm/mach-at91/at91rm9200_time.c            |    2 +-
 arch/arm/mach-at91/at91sam926x_time.c           |    2 +-
 arch/arm/mach-at91/at91x40_time.c               |    2 +-
 arch/arm/mach-bcmring/dma.c                     |    2 +-
 arch/arm/mach-clps711x/time.c                   |    2 +-
 arch/arm/mach-cns3xxx/core.c                    |    2 +-
 arch/arm/mach-davinci/board-da830-evm.c         |    2 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c     |    2 +-
 arch/arm/mach-davinci/time.c                    |    4 ++--
 arch/arm/mach-ebsa110/core.c                    |    2 +-
 arch/arm/mach-ep93xx/core.c                     |    2 +-
 arch/arm/mach-footbridge/dc21285-timer.c        |    2 +-
 arch/arm/mach-footbridge/dc21285.c              |   10 +++++-----
 arch/arm/mach-footbridge/isa-timer.c            |    2 +-
 arch/arm/mach-gemini/time.c                     |    2 +-
 arch/arm/mach-h720x/cpu-h7201.c                 |    2 +-
 arch/arm/mach-h720x/cpu-h7202.c                 |    2 +-
 arch/arm/mach-imx/mach-armadillo5x0.c           |    2 +-
 arch/arm/mach-imx/mach-mx31_3ds.c               |    2 +-
 arch/arm/mach-imx/mach-pca100.c                 |    2 +-
 arch/arm/mach-imx/mach-pcm037.c                 |    2 +-
 arch/arm/mach-imx/mx31lilly-db.c                |    2 +-
 arch/arm/mach-integrator/integrator_ap.c        |    2 +-
 arch/arm/mach-ixp2000/core.c                    |    2 +-
 arch/arm/mach-ixp23xx/core.c                    |    2 +-
 arch/arm/mach-ixp4xx/common.c                   |    2 +-
 arch/arm/mach-ixp4xx/dsmg600-setup.c            |    2 +-
 arch/arm/mach-ixp4xx/fsg-setup.c                |    4 ++--
 arch/arm/mach-ixp4xx/nas100d-setup.c            |    2 +-
 arch/arm/mach-ixp4xx/nslu2-setup.c              |    4 ++--
 arch/arm/mach-ks8695/time.c                     |    2 +-
 arch/arm/mach-lpc32xx/timer.c                   |    2 +-
 arch/arm/mach-mmp/time.c                        |    2 +-
 arch/arm/mach-msm/timer.c                       |    4 ++--
 arch/arm/mach-netx/time.c                       |    2 +-
 arch/arm/mach-omap1/fpga.c                      |    4 ++--
 arch/arm/mach-omap1/pm.c                        |    1 -
 arch/arm/mach-omap1/time.c                      |    2 +-
 arch/arm/mach-omap1/timer32k.c                  |    2 +-
 arch/arm/mach-omap2/omap_l3_noc.c               |    4 ++--
 arch/arm/mach-omap2/omap_l3_smx.c               |    4 ++--
 arch/arm/mach-omap2/pm34xx.c                    |    2 +-
 arch/arm/mach-omap2/timer.c                     |    2 +-
 arch/arm/mach-pnx4008/time.c                    |    2 +-
 arch/arm/mach-pxa/am200epd.c                    |    2 +-
 arch/arm/mach-pxa/am300epd.c                    |    2 +-
 arch/arm/mach-pxa/em-x270.c                     |    2 +-
 arch/arm/mach-pxa/magician.c                    |    2 +-
 arch/arm/mach-pxa/mainstone.c                   |    2 +-
 arch/arm/mach-pxa/pcm990-baseboard.c            |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c                  |    8 ++++----
 arch/arm/mach-pxa/time.c                        |    2 +-
 arch/arm/mach-pxa/trizeps4.c                    |    2 +-
 arch/arm/mach-rpc/dma.c                         |    2 +-
 arch/arm/mach-s3c2410/usb-simtec.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq.c             |    2 +-
 arch/arm/mach-sa1100/dma.c                      |    2 +-
 arch/arm/mach-sa1100/time.c                     |    2 +-
 arch/arm/mach-shark/core.c                      |    2 +-
 arch/arm/mach-tcc8k/time.c                      |    2 +-
 arch/arm/mach-tegra/timer.c                     |    2 +-
 arch/arm/mach-u300/timer.c                      |    2 +-
 arch/arm/mach-vt8500/timer.c                    |    2 +-
 arch/arm/mach-w90x900/time.c                    |    2 +-
 arch/arm/mach-zynq/timer.c                      |    2 +-
 arch/arm/plat-iop/time.c                        |    2 +-
 arch/arm/plat-mxc/Kconfig                       |    2 +-
 arch/arm/plat-mxc/epit.c                        |    2 +-
 arch/arm/plat-mxc/time.c                        |    2 +-
 arch/arm/plat-nomadik/timer.c                   |    2 +-
 arch/arm/plat-omap/dma.c                        |    1 -
 arch/arm/plat-orion/time.c                      |    2 +-
 arch/arm/plat-pxa/dma.c                         |    2 +-
 arch/arm/plat-s3c24xx/dma.c                     |    2 +-
 arch/arm/plat-s5p/s5p-time.c                    |    2 +-
 arch/arm/plat-s5p/sysmmu.c                      |    2 +-
 arch/arm/plat-samsung/time.c                    |    2 +-
 arch/arm/plat-spear/time.c                      |    2 +-
 arch/avr32/kernel/time.c                        |    2 +-
 arch/cris/arch-v10/drivers/gpio.c               |    4 ++--
 arch/cris/arch-v10/drivers/sync_serial.c        |    4 ++--
 arch/cris/arch-v10/kernel/time.c                |    4 ++--
 arch/cris/arch-v32/drivers/mach-a3/gpio.c       |    2 +-
 arch/cris/arch-v32/drivers/mach-fs/gpio.c       |    4 ++--
 arch/cris/arch-v32/kernel/fasttimer.c           |    2 +-
 arch/cris/arch-v32/kernel/irq.c                 |    4 ++--
 arch/cris/arch-v32/kernel/smp.c                 |    1 -
 arch/cris/arch-v32/kernel/time.c                |    4 ++--
 arch/cris/arch-v32/mach-a3/arbiter.c            |    4 ++--
 arch/cris/arch-v32/mach-fs/arbiter.c            |    2 +-
 arch/cris/include/arch-v10/arch/irq.h           |    5 +++--
 arch/cris/include/arch-v32/arch/irq.h           |    5 +++--
 arch/cris/kernel/irq.c                          |    3 +--
 arch/frv/kernel/irq-mb93091.c                   |    8 ++++----
 arch/frv/kernel/irq-mb93093.c                   |    1 -
 arch/frv/kernel/irq-mb93493.c                   |    4 ++--
 arch/frv/kernel/time.c                          |    1 -
 arch/h8300/kernel/timer/itu.c                   |    2 +-
 arch/h8300/kernel/timer/timer16.c               |    2 +-
 arch/h8300/kernel/timer/timer8.c                |    2 +-
 arch/h8300/kernel/timer/tpu.c                   |    2 +-
 arch/ia64/hp/sim/simserial.c                    |    2 +-
 arch/ia64/kernel/irq_ia64.c                     |    4 ----
 arch/ia64/kernel/mca.c                          |    6 ------
 arch/ia64/kernel/perfmon.c                      |    1 -
 arch/ia64/kernel/time.c                         |    2 +-
 arch/ia64/xen/irq_xen.c                         |    3 ---
 arch/m32r/kernel/time.c                         |    1 -
 arch/m68k/include/asm/floppy.h                  |    2 +-
 arch/m68k/include/asm/irq.h                     |    4 ++--
 arch/m68k/include/asm/sun3xflop.h               |    2 +-
 arch/m68k/platform/68328/timers.c               |    2 +-
 arch/m68k/platform/68360/config.c               |    2 +-
 arch/m68k/platform/coldfire/pit.c               |    2 +-
 arch/m68k/platform/coldfire/sltimers.c          |    4 ++--
 arch/m68k/platform/coldfire/timers.c            |    4 ++--
 arch/microblaze/kernel/timer.c                  |    2 +-
 arch/mips/alchemy/common/dbdma.c                |    2 +-
 arch/mips/alchemy/common/time.c                 |    2 +-
 arch/mips/alchemy/devboards/db1200/platform.c   |    4 ++--
 arch/mips/cavium-octeon/smp.c                   |    2 +-
 arch/mips/dec/setup.c                           |    1 -
 arch/mips/include/asm/mach-generic/floppy.h     |    2 +-
 arch/mips/include/asm/mach-jazz/floppy.h        |    2 +-
 arch/mips/jazz/irq.c                            |    2 +-
 arch/mips/kernel/cevt-bcm1480.c                 |    2 +-
 arch/mips/kernel/cevt-ds1287.c                  |    2 +-
 arch/mips/kernel/cevt-gt641xx.c                 |    2 +-
 arch/mips/kernel/cevt-r4k.c                     |    2 +-
 arch/mips/kernel/cevt-sb1250.c                  |    2 +-
 arch/mips/kernel/cevt-txx9.c                    |    2 +-
 arch/mips/kernel/i8253.c                        |    2 +-
 arch/mips/kernel/rtlx.c                         |    1 -
 arch/mips/kernel/smtc.c                         |    2 +-
 arch/mips/lantiq/irq.c                          |    1 -
 arch/mips/loongson/common/cs5536/cs5536_mfgpt.c |    2 +-
 arch/mips/mti-malta/malta-int.c                 |    4 ++--
 arch/mips/pci/ops-pmcmsp.c                      |    2 +-
 arch/mips/pci/ops-tx3927.c                      |    2 +-
 arch/mips/pci/pci-tx4927.c                      |    2 +-
 arch/mips/pci/pci-tx4938.c                      |    2 +-
 arch/mips/pci/pci-tx4939.c                      |    2 +-
 arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c     |    2 +-
 arch/mips/pmc-sierra/msp71xx/msp_smp.c          |    4 ++--
 arch/mips/pnx8550/common/int.c                  |    4 ++--
 arch/mips/pnx8550/common/time.c                 |    4 ++--
 arch/mips/sgi-ip22/ip22-int.c                   |   10 +++++-----
 arch/mips/sgi-ip27/ip27-irq.c                   |    2 +-
 arch/mips/sgi-ip27/ip27-timer.c                 |    2 +-
 arch/mips/sgi-ip32/ip32-irq.c                   |    2 --
 arch/mips/sni/irq.c                             |    2 +-
 arch/mips/sni/time.c                            |    2 +-
 arch/mips/txx9/generic/pci.c                    |    2 +-
 arch/mn10300/kernel/cevt-mn10300.c              |    2 +-
 arch/mn10300/kernel/mn10300-serial.c            |    6 +++---
 arch/mn10300/kernel/smp.c                       |    1 -
 arch/mn10300/unit-asb2364/irq-fpga.c            |    2 +-
 arch/parisc/include/asm/floppy.h                |    4 ++--
 arch/parisc/kernel/irq.c                        |    4 ++--
 arch/powerpc/include/asm/floppy.h               |    4 ++--
 arch/powerpc/include/asm/xics.h                 |    4 ++--
 arch/powerpc/kernel/smp.c                       |    2 +-
 arch/powerpc/platforms/cell/beat.c              |    2 +-
 arch/powerpc/platforms/cell/celleb_scc_pciex.c  |    2 +-
 arch/powerpc/platforms/cell/iommu.c             |    3 +--
 arch/powerpc/platforms/cell/pmu.c               |    2 +-
 arch/powerpc/platforms/cell/spu_base.c          |    9 +++------
 arch/powerpc/platforms/powermac/pic.c           |    1 -
 arch/powerpc/platforms/powermac/smp.c           |    4 ++--
 arch/powerpc/platforms/ps3/device-init.c        |    2 +-
 arch/powerpc/sysdev/mpic.c                      |    2 --
 arch/powerpc/sysdev/ppc4xx_soc.c                |    2 +-
 arch/powerpc/sysdev/xics/xics-common.c          |    5 ++---
 arch/score/kernel/time.c                        |    2 +-
 arch/sh/boards/board-secureedge5410.c           |    3 +--
 arch/sh/boards/mach-cayman/irq.c                |    2 --
 arch/sh/boards/mach-hp6xx/hp6xx_apm.c           |    2 +-
 arch/sh/drivers/dma/dma-g2.c                    |    2 +-
 arch/sh/drivers/dma/dma-pvr2.c                  |    1 -
 arch/sh/drivers/dma/dma-sh.c                    |    4 ++--
 arch/sh/drivers/dma/dmabrg.c                    |    6 +++---
 arch/sh/drivers/pci/pci-sh5.c                   |    4 ++--
 arch/sh/drivers/pci/pci-sh7780.c                |    2 +-
 arch/sh/drivers/push-switch.c                   |    2 +-
 arch/sh/kernel/cpu/sh4a/smp-shx3.c              |    2 +-
 arch/sparc/include/asm/floppy_64.h              |    2 +-
 arch/sparc/kernel/ldc.c                         |    4 ++--
 arch/um/drivers/line.c                          |    8 ++++----
 arch/um/drivers/mconsole_kern.c                 |    2 +-
 arch/um/drivers/net_kern.c                      |    2 +-
 arch/um/drivers/port_kern.c                     |    4 ++--
 arch/um/drivers/random.c                        |    2 +-
 arch/um/drivers/ubd_kern.c                      |    2 +-
 arch/um/drivers/xterm_kern.c                    |    2 +-
 arch/um/kernel/sigio.c                          |    2 +-
 arch/um/kernel/time.c                           |    2 +-
 arch/unicore32/kernel/puv3-nb0916.c             |    4 ++--
 arch/unicore32/kernel/time.c                    |    2 +-
 arch/x86/include/asm/floppy.h                   |    4 ++--
 arch/x86/kernel/hpet.c                          |    2 +-
 arch/x86/kernel/time.c                          |    2 +-
 arch/x86/xen/smp.c                              |    8 ++++----
 arch/x86/xen/spinlock.c                         |    2 +-
 arch/x86/xen/time.c                             |    5 ++---
 arch/xtensa/kernel/time.c                       |    1 -
 drivers/block/cciss.c                           |    4 ++--
 drivers/block/cpqarray.c                        |    2 +-
 drivers/block/hd.c                              |    7 +------
 drivers/block/mg_disk.c                         |    2 +-
 drivers/cdrom/gdrom.c                           |    4 ++--
 drivers/char/hpet.c                             |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c                |    4 ++--
 drivers/char/nwbutton.c                         |    2 +-
 drivers/char/rtc.c                              |    4 ++--
 drivers/char/snsc.c                             |    2 +-
 drivers/char/snsc_event.c                       |    2 +-
 drivers/char/tlclk.c                            |    2 +-
 drivers/clocksource/cs5535-clockevt.c           |    2 +-
 drivers/clocksource/dw_apb_timer.c              |    3 +--
 drivers/clocksource/sh_cmt.c                    |    2 +-
 drivers/clocksource/sh_mtu2.c                   |    2 +-
 drivers/clocksource/sh_tmu.c                    |    2 +-
 drivers/clocksource/tcb_clksrc.c                |    2 +-
 drivers/crypto/mv_cesa.c                        |    3 +--
 drivers/dma/amba-pl08x.c                        |    2 +-
 drivers/dma/coh901318.c                         |    2 +-
 drivers/dma/shdma.c                             |    4 ++--
 drivers/edac/mpc85xx_edac.c                     |    6 +++---
 drivers/edac/mv64x60_edac.c                     |    8 ++++----
 drivers/edac/ppc4xx_edac.c                      |    4 ++--
 drivers/isdn/hardware/eicon/divasmain.c         |    2 +-
 drivers/isdn/sc/init.c                          |    2 +-
 drivers/media/common/saa7146_core.c             |    2 +-
 drivers/media/dvb/bt8xx/bt878.c                 |    2 +-
 drivers/media/radio/si4713-i2c.c                |    2 +-
 drivers/media/rc/winbond-cir.c                  |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c         |    2 +-
 drivers/media/video/cx18/cx18-driver.c          |    2 +-
 drivers/media/video/cx23885/cx23885-core.c      |    2 +-
 drivers/media/video/cx88/cx88-alsa.c            |    2 +-
 drivers/media/video/cx88/cx88-mpeg.c            |    2 +-
 drivers/media/video/cx88/cx88-video.c           |    2 +-
 drivers/media/video/davinci/vpbe_display.c      |    2 +-
 drivers/media/video/davinci/vpfe_capture.c      |    4 ++--
 drivers/media/video/davinci/vpif_capture.c      |    2 +-
 drivers/media/video/davinci/vpif_display.c      |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c          |    2 +-
 drivers/media/video/meye.c                      |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc.c           |    3 +--
 drivers/media/video/saa7134/saa7134-alsa.c      |    2 +-
 drivers/media/video/saa7134/saa7134-core.c      |    2 +-
 drivers/media/video/saa7164/saa7164-core.c      |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c      |    2 +-
 drivers/media/video/zoran/zoran_card.c          |    2 +-
 drivers/misc/arm-charlcd.c                      |    2 +-
 drivers/misc/phantom.c                          |    2 +-
 drivers/mtd/nand/mxc_nand.c                     |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c                  |    3 +--
 drivers/mtd/nand/tmio_nand.c                    |    2 +-
 drivers/net/ethernet/adi/bfin_mac.c             |    4 ++--
 drivers/net/ethernet/amd/sun3lance.c            |    2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c    |    4 ++--
 drivers/net/ethernet/dec/tulip/de4x5.c          |    2 +-
 drivers/net/ethernet/freescale/fec.c            |    2 +-
 drivers/net/ethernet/hp/hp100.c                 |    2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c       |    6 +++---
 drivers/net/ethernet/korina.c                   |    8 ++++----
 drivers/net/ethernet/lantiq_etop.c              |    4 ++--
 drivers/net/ethernet/marvell/pxa168_eth.c       |    2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c        |    2 +-
 drivers/net/ethernet/natsemi/jazzsonic.c        |    2 +-
 drivers/net/ethernet/natsemi/xtsonic.c          |    2 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c        |    4 ++--
 drivers/net/ethernet/smsc/smc91x.h              |    2 +-
 drivers/net/ethernet/smsc/smsc9420.c            |    2 +-
 drivers/net/ethernet/ti/davinci_emac.c          |    2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c    |    2 +-
 drivers/net/hamradio/baycom_ser_fdx.c           |    2 +-
 drivers/net/hamradio/baycom_ser_hdx.c           |    2 +-
 drivers/net/hamradio/scc.c                      |    2 +-
 drivers/net/hamradio/yam.c                      |    2 +-
 drivers/net/irda/bfin_sir.c                     |    4 ++--
 drivers/net/irda/donauboe.c                     |    4 ++--
 drivers/net/irda/sh_irda.c                      |    2 +-
 drivers/net/irda/sh_sir.c                       |    2 +-
 drivers/net/wan/hostess_sv11.c                  |    2 +-
 drivers/net/wan/sealevel.c                      |    2 +-
 drivers/net/wireless/p54/p54spi.c               |    2 +-
 drivers/parisc/superio.c                        |    2 +-
 drivers/pcmcia/db1xxx_ss.c                      |    4 ++--
 drivers/pcmcia/soc_common.c                     |    2 +-
 drivers/platform/x86/sony-laptop.c              |    2 +-
 drivers/pnp/resource.c                          |    2 +-
 drivers/power/wm97xx_battery.c                  |    2 +-
 drivers/power/z2_battery.c                      |    2 +-
 drivers/ps3/ps3-vuart.c                         |    2 +-
 drivers/ps3/ps3stor_lib.c                       |    2 +-
 drivers/rtc/rtc-at91sam9.c                      |    2 +-
 drivers/rtc/rtc-cmos.c                          |    2 +-
 drivers/rtc/rtc-coh901331.c                     |    2 +-
 drivers/rtc/rtc-davinci.c                       |    2 +-
 drivers/rtc/rtc-ds1511.c                        |    2 +-
 drivers/rtc/rtc-ds1553.c                        |    2 +-
 drivers/rtc/rtc-lpc32xx.c                       |    2 +-
 drivers/rtc/rtc-mpc5121.c                       |    4 ++--
 drivers/rtc/rtc-mrst.c                          |    2 +-
 drivers/rtc/rtc-mv.c                            |    2 +-
 drivers/rtc/rtc-nuc900.c                        |    2 +-
 drivers/rtc/rtc-omap.c                          |    4 ++--
 drivers/rtc/rtc-pl030.c                         |    2 +-
 drivers/rtc/rtc-pl031.c                         |    2 +-
 drivers/rtc/rtc-puv3.c                          |    4 ++--
 drivers/rtc/rtc-pxa.c                           |    4 ++--
 drivers/rtc/rtc-s3c.c                           |    4 ++--
 drivers/rtc/rtc-sa1100.c                        |    4 ++--
 drivers/rtc/rtc-sh.c                            |    8 ++++----
 drivers/rtc/rtc-stk17ta8.c                      |    2 +-
 drivers/rtc/rtc-tx4939.c                        |    2 +-
 drivers/rtc/rtc-vr41xx.c                        |    4 ++--
 drivers/scsi/NCR5380.c                          |    2 +-
 drivers/scsi/aacraid/rx.c                       |    2 +-
 drivers/scsi/aacraid/sa.c                       |    2 +-
 drivers/scsi/aacraid/src.c                      |    2 +-
 drivers/scsi/aha152x.c                          |    4 ++--
 drivers/scsi/aic7xxx_old.c                      |    2 +-
 drivers/scsi/arm/acornscsi.c                    |    2 +-
 drivers/scsi/arm/cumana_1.c                     |    2 +-
 drivers/scsi/arm/cumana_2.c                     |    2 +-
 drivers/scsi/arm/powertec.c                     |    2 +-
 drivers/scsi/dtc.c                              |    2 +-
 drivers/scsi/eata.c                             |    2 +-
 drivers/scsi/eata_pio.c                         |    4 ++--
 drivers/scsi/g_NCR5380.c                        |    2 +-
 drivers/scsi/gdth.c                             |    6 +++---
 drivers/scsi/hpsa.c                             |    4 ++--
 drivers/scsi/ibmvscsi/ibmvstgt.c                |    2 +-
 drivers/scsi/in2000.c                           |    2 +-
 drivers/scsi/initio.c                           |    2 +-
 drivers/scsi/pas16.c                            |    2 +-
 drivers/scsi/pm8001/pm8001_init.c               |    4 +---
 drivers/scsi/t128.c                             |    2 +-
 drivers/scsi/u14-34f.c                          |    2 +-
 drivers/scsi/wd7000.c                           |    2 +-
 drivers/spi/spi-bfin5xx.c                       |    2 +-
 drivers/spi/spi-coldfire-qspi.c                 |    2 +-
 drivers/spi/spi-ppc4xx.c                        |    2 +-
 drivers/spi/spi-sh-msiof.c                      |    2 +-
 drivers/spi/spi-sh.c                            |    2 +-
 drivers/usb/core/hcd.c                          |   15 ---------------
 drivers/usb/host/ehci-pxa168.c                  |    2 +-
 drivers/usb/host/ohci-xls.c                     |    2 +-
 drivers/w1/masters/ds1wm.c                      |    2 +-
 drivers/w1/masters/omap_hdq.c                   |    2 +-
 drivers/watchdog/coh901327_wdt.c                |    2 +-
 drivers/watchdog/eurotechwdt.c                  |    2 +-
 drivers/watchdog/mpcore_wdt.c                   |    3 +--
 drivers/watchdog/octeon-wdt-main.c              |    2 +-
 drivers/watchdog/sb_wdog.c                      |    4 ++--
 drivers/watchdog/wdt.c                          |    2 +-
 drivers/watchdog/wdt_pci.c                      |    2 +-
 drivers/xen/evtchn.c                            |    2 +-
 drivers/xen/platform-pci.c                      |    2 +-
 include/linux/interrupt.h                       |    3 ---
 include/net/irda/irda_device.h                  |    2 +-
 375 files changed, 463 insertions(+), 561 deletions(-)

