Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1IUM1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:27:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35728 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1IUM1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:27:11 -0400
Date: Wed, 21 Sep 2011 20:27:00 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Subject: Re: [PATCH V1 00/57] Tree wide: cleanup IRQF_DISABLED
Message-ID: <20110921122700.GF2550@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Top reply for some notice]

So it seems I have to resend this patchset for another time because
the commit id c58543c8 is a wrong reference, actually it should be
e58aa3d2. Sorry for my unknown mistake.

But anyway, it will not prevent you from reviewing/picking up the patch.

So I will refresh this patchset to modify the commit id at suitable
time.

Thanks,
Yong

On Wed, Sep 21, 2011 at 05:28:01PM +0800, Yong Zhang wrote:
> IRQF_DISABLED has been marked 'removal' for some time, now this
> trival patchset achive the goal.
> Most of the patch is one-line change/remove IRQF_DISABLED
> except patch-0001.
> 
> patch-0001 just remove the workround which live with IRQF_DISABLED
> is not NOOP, say before v2.6.35.
> 
> Others just do:
>   --if IRQF_DISABLED is combined with other irq_flags,just remove
>     IRQF_DISABLED;
>   --if IRQF_DISABLED is the only irq_flags of request_irq(),
>     change IRQF_DISABLED to 0 like some callers of request_irq()
>     have done.
>   --if IRQF_DISABLED is the only flags if irq_action, just remove
>     that item.
> 
> And I make the patches based on subdirs, so it's more easy to be
> reviewed/taken by relevant trees than one-big-patch.
> 
> Changelog V1 < V0:
>   -- Show more info in the commit log, thus make the patch more
>      easy to review (Required by David Miller)
>   
>   -- Drop below pathces since they are not needed any more:
>        mpu401-snd_mpu401_uart_new-split-semantic-of-irq_fla.patch
>        gpio-irq-Remove-IRQF_DISABLED.patch
> 
>   -- Drop below patches since they are picked by individual maintainer:
>        Blackfin-irq-Remove-IRQF_DISABLED.patch (Bob Liu)
>        staging-irq-Remove-IRQF_DISABLED.patch  (Greg KH)
>        USB-irq-Remove-IRQF_DISABLED.patch      (Greg KH)
>        Input-irq-Remove-IRQF_DISABLED.patch    (Dmitry Torokhov)
>        mfd-irq-Remove-IRQF_DISABLED.patch      (Samuel Ortiz)
> 
>   -- Collect some Acks.
>      Almost half of the patches get Acks(for the whole patch or part).
> 
>   -- Refresh this patchset based on next-20110920 (commit 8c024a21).
>   
>   -- Add two more patches:
>        hexagon-irq-Remove-IRQF_DISABLED.patch
>        hwmon-irq-Remove-IRQF_DISABLED.patch
>          The two new add patches make me think that we should push this
>          patches to upstream ASAP.
> 
> Since the merge window is more close to us now, could you please
> pick up the individual patch or give an Ack? And quoted for Thomas's
> previous reply:
> [ We can hold off the "remove the define" patch until 3.2-rc1 and push
>   it along with everything which hasn't been merged until then.
> 
>   Alternatively I can pick the whole * bunch as well. I let *(you)
>   decide. ]
> 
> BTW, I'm sending the patchset through
> 'git send-email --cc-cmd="./scripts/get_maintainer.pl'.
> If you are get noised by it, I apologies.
> 
> Thanks,
> Yong
> 
> ---
> Yong Zhang (57):
>   usb/hcd: Remove tricky code dealing with IRQF_DISABLED && IRQF_SHARED
>   alpha: irq: Remove IRQF_DISABLED
>   arm: irq: Remove IRQF_DISABLED
>   avr32: irq: Remove IRQF_DISABLED
>   cris: irq: Remove IRQF_DISABLED
>   frv: irq: Remove IRQF_DISABLED
>   h8300: irq: Remove IRQF_DISABLED
>   ia64: irq: Remove IRQF_DISABLED
>   m32r: irq: Remove IRQF_DISABLED
>   m68k: irq: Remove IRQF_DISABLED
>   microblaze: irq: Remove IRQF_DISABLED
>   MIPS: irq: Remove IRQF_DISABLED
>   mn10300: irq: Remove IRQF_DISABLED
>   parisc: irq: remove IRQF_DISABLED
>   powerpc: irq: Remove IRQF_DISABLED
>   score: irq: Remove IRQF_DISABLED
>   SH: irq: Remove IRQF_DISABLED
>   sparc: irq: Remove IRQF_DISABLED
>   um: irq: Remove IRQF_DISABLED
>   unicore32: Remove IRQF_DISABLED
>   x86: irq: Remove IRQF_DISABLED
>   xtensa: irq: Remove IRQF_DISABLED
>   clocksource: irq: Remove IRQF_DISABLED
>   irq: Remove IRQF_DISABLED
>   ata: irq: Remove IRQF_DISABLED
>   block: irq: Remove IRQF_DISABLED
>   cdrom: irq: Remove IRQF_DISABLED
>   driver/char: irq: Remove IRQF_DISABLED
>   crypto: irq: Remove IRQF_DISABLED
>   dmaengine: irq: Remove IRQF_DISABLED
>   EDAC: irq: Remove IRQF_DISABLED
>   i2c: irq: Remove IRQF_DISABLED
>   infiniband: irq: Remove IRQF_DISABLED
>   ISDN: irq: Remove IRQF_DISABLED
>   media: irq: Remove IRQF_DISABLED
>   drivers:misc:irq: Remove IRQF_DISABLED
>   mmc: irq: Remove IRQF_DISABLED
>   mtd: irq: Remove IRQF_DISABLED
>   net: irq: Remove IRQF_DISABLED
>   dirvers/parisc: irq: Remove IRQF_DISABLED
>   pcmcia: irq: Remove IRQF_DISABLED
>   sony-laptop:irq: Remove IRQF_DISABLED
>   PNP: irq: Remove IRQF_DISABLED
>   power_supply:irq: Remove IRQF_DISABLED
>   powerpc/ps3: irq: Remove IRQF_DISABLED
>   rtc: irq: Remove IRQF_DISABLED
>   spi: irq: Remove IRQF_DISABLED
>   TTY: irq: Remove IRQF_DISABLED
>   video: irq: Remove IRQF_DISABLED
>   w1: irq: Remove IRQF_DISABLED
>   watchdog: irq: Remove IRQF_DISABLED
>   xen: irq: Remove IRQF_DISABLED
>   sound: irq: Remove IRQF_DISABLED
>   Documentation: irq: Change documents related to IRQF_DISABLED
>   hexagon: irq: Remove IRQF_DISABLED
>   hwmon: irq: Remove IRQF_DISABLED
>   genirq: Remove IRQF_DISABLED
> 
>  Documentation/PCI/MSI-HOWTO.txt                 |   21 ---------------------
>  Documentation/feature-removal-schedule.txt      |    7 -------
>  Documentation/scsi/ncr53c8xx.txt                |    4 +++-
>  Documentation/scsi/tmscsim.txt                  |    4 ++--
>  arch/alpha/include/asm/floppy.h                 |    2 +-
>  arch/alpha/kernel/irq_alpha.c                   |    1 -
>  arch/alpha/kernel/sys_titan.c                   |   14 +++++++-------
>  arch/arm/common/time-acorn.c                    |    1 -
>  arch/arm/common/timer-sp.c                      |    2 +-
>  arch/arm/include/asm/floppy.h                   |    2 +-
>  arch/arm/kernel/perf_event.c                    |    2 +-
>  arch/arm/mach-at91/at91rm9200_time.c            |    2 +-
>  arch/arm/mach-at91/at91sam926x_time.c           |    2 +-
>  arch/arm/mach-at91/at91x40_time.c               |    2 +-
>  arch/arm/mach-bcmring/dma.c                     |    2 +-
>  arch/arm/mach-clps711x/time.c                   |    2 +-
>  arch/arm/mach-cns3xxx/core.c                    |    2 +-
>  arch/arm/mach-davinci/board-da830-evm.c         |    2 +-
>  arch/arm/mach-davinci/board-omapl138-hawk.c     |    2 +-
>  arch/arm/mach-davinci/time.c                    |    4 ++--
>  arch/arm/mach-ebsa110/core.c                    |    2 +-
>  arch/arm/mach-ep93xx/core.c                     |    2 +-
>  arch/arm/mach-footbridge/dc21285-timer.c        |    2 +-
>  arch/arm/mach-footbridge/dc21285.c              |   10 +++++-----
>  arch/arm/mach-footbridge/isa-timer.c            |    2 +-
>  arch/arm/mach-gemini/time.c                     |    2 +-
>  arch/arm/mach-h720x/cpu-h7201.c                 |    2 +-
>  arch/arm/mach-h720x/cpu-h7202.c                 |    2 +-
>  arch/arm/mach-imx/mach-armadillo5x0.c           |    2 +-
>  arch/arm/mach-imx/mach-mx31_3ds.c               |    2 +-
>  arch/arm/mach-imx/mach-pca100.c                 |    2 +-
>  arch/arm/mach-imx/mach-pcm037.c                 |    2 +-
>  arch/arm/mach-imx/mx31lilly-db.c                |    2 +-
>  arch/arm/mach-integrator/integrator_ap.c        |    2 +-
>  arch/arm/mach-ixp2000/core.c                    |    2 +-
>  arch/arm/mach-ixp23xx/core.c                    |    2 +-
>  arch/arm/mach-ixp4xx/common.c                   |    2 +-
>  arch/arm/mach-ixp4xx/dsmg600-setup.c            |    2 +-
>  arch/arm/mach-ixp4xx/fsg-setup.c                |    4 ++--
>  arch/arm/mach-ixp4xx/nas100d-setup.c            |    2 +-
>  arch/arm/mach-ixp4xx/nslu2-setup.c              |    4 ++--
>  arch/arm/mach-ks8695/time.c                     |    2 +-
>  arch/arm/mach-lpc32xx/timer.c                   |    2 +-
>  arch/arm/mach-mmp/time.c                        |    2 +-
>  arch/arm/mach-msm/timer.c                       |    4 ++--
>  arch/arm/mach-netx/time.c                       |    2 +-
>  arch/arm/mach-nuc93x/time.c                     |    2 +-
>  arch/arm/mach-omap1/fpga.c                      |    4 ++--
>  arch/arm/mach-omap1/pm.c                        |    1 -
>  arch/arm/mach-omap1/time.c                      |    2 +-
>  arch/arm/mach-omap1/timer32k.c                  |    2 +-
>  arch/arm/mach-omap2/omap_l3_noc.c               |    4 ++--
>  arch/arm/mach-omap2/omap_l3_smx.c               |    4 ++--
>  arch/arm/mach-omap2/pm34xx.c                    |    2 +-
>  arch/arm/mach-omap2/timer.c                     |    2 +-
>  arch/arm/mach-pnx4008/time.c                    |    2 +-
>  arch/arm/mach-pxa/am200epd.c                    |    2 +-
>  arch/arm/mach-pxa/am300epd.c                    |    2 +-
>  arch/arm/mach-pxa/em-x270.c                     |    2 +-
>  arch/arm/mach-pxa/magician.c                    |    2 +-
>  arch/arm/mach-pxa/mainstone.c                   |    2 +-
>  arch/arm/mach-pxa/pcm990-baseboard.c            |    2 +-
>  arch/arm/mach-pxa/sharpsl_pm.c                  |    8 ++++----
>  arch/arm/mach-pxa/time.c                        |    2 +-
>  arch/arm/mach-pxa/trizeps4.c                    |    2 +-
>  arch/arm/mach-rpc/dma.c                         |    2 +-
>  arch/arm/mach-s3c2410/usb-simtec.c              |    2 +-
>  arch/arm/mach-s3c64xx/mach-smartq.c             |    2 +-
>  arch/arm/mach-sa1100/dma.c                      |    2 +-
>  arch/arm/mach-sa1100/time.c                     |    2 +-
>  arch/arm/mach-shark/core.c                      |    2 +-
>  arch/arm/mach-tcc8k/time.c                      |    2 +-
>  arch/arm/mach-tegra/timer.c                     |    2 +-
>  arch/arm/mach-u300/timer.c                      |    2 +-
>  arch/arm/mach-vt8500/timer.c                    |    2 +-
>  arch/arm/mach-w90x900/time.c                    |    2 +-
>  arch/arm/mach-zynq/timer.c                      |    2 +-
>  arch/arm/plat-iop/time.c                        |    2 +-
>  arch/arm/plat-mxc/Kconfig                       |    2 +-
>  arch/arm/plat-mxc/epit.c                        |    2 +-
>  arch/arm/plat-mxc/time.c                        |    2 +-
>  arch/arm/plat-nomadik/timer.c                   |    2 +-
>  arch/arm/plat-omap/dma.c                        |    1 -
>  arch/arm/plat-orion/time.c                      |    2 +-
>  arch/arm/plat-pxa/dma.c                         |    2 +-
>  arch/arm/plat-s3c24xx/dma.c                     |    2 +-
>  arch/arm/plat-s5p/s5p-time.c                    |    2 +-
>  arch/arm/plat-s5p/sysmmu.c                      |    2 +-
>  arch/arm/plat-samsung/time.c                    |    2 +-
>  arch/arm/plat-spear/time.c                      |    2 +-
>  arch/avr32/kernel/time.c                        |    2 +-
>  arch/cris/arch-v10/drivers/gpio.c               |    4 ++--
>  arch/cris/arch-v10/drivers/sync_serial.c        |    4 ++--
>  arch/cris/arch-v10/kernel/time.c                |    4 ++--
>  arch/cris/arch-v32/drivers/mach-a3/gpio.c       |    2 +-
>  arch/cris/arch-v32/drivers/mach-fs/gpio.c       |    4 ++--
>  arch/cris/arch-v32/kernel/fasttimer.c           |    2 +-
>  arch/cris/arch-v32/kernel/irq.c                 |    4 ++--
>  arch/cris/arch-v32/kernel/smp.c                 |    1 -
>  arch/cris/arch-v32/kernel/time.c                |    4 ++--
>  arch/cris/arch-v32/mach-a3/arbiter.c            |    4 ++--
>  arch/cris/arch-v32/mach-fs/arbiter.c            |    2 +-
>  arch/cris/include/arch-v10/arch/irq.h           |    5 +++--
>  arch/cris/include/arch-v32/arch/irq.h           |    5 +++--
>  arch/cris/kernel/irq.c                          |    3 +--
>  arch/frv/kernel/irq-mb93091.c                   |    8 ++++----
>  arch/frv/kernel/irq-mb93093.c                   |    1 -
>  arch/frv/kernel/irq-mb93493.c                   |    4 ++--
>  arch/frv/kernel/time.c                          |    1 -
>  arch/h8300/kernel/timer/itu.c                   |    2 +-
>  arch/h8300/kernel/timer/timer16.c               |    2 +-
>  arch/h8300/kernel/timer/timer8.c                |    2 +-
>  arch/h8300/kernel/timer/tpu.c                   |    2 +-
>  arch/hexagon/kernel/smp.c                       |    2 +-
>  arch/hexagon/kernel/time.c                      |    2 +-
>  arch/ia64/hp/sim/simserial.c                    |    2 +-
>  arch/ia64/kernel/irq_ia64.c                     |    4 ----
>  arch/ia64/kernel/mca.c                          |    6 ------
>  arch/ia64/kernel/perfmon.c                      |    1 -
>  arch/ia64/kernel/time.c                         |    2 +-
>  arch/ia64/xen/irq_xen.c                         |    3 ---
>  arch/m32r/kernel/time.c                         |    1 -
>  arch/m68k/include/asm/floppy.h                  |    2 +-
>  arch/m68k/include/asm/irq.h                     |    4 ++--
>  arch/m68k/include/asm/sun3xflop.h               |    2 +-
>  arch/m68k/platform/68328/timers.c               |    2 +-
>  arch/m68k/platform/68360/config.c               |    2 +-
>  arch/m68k/platform/coldfire/pit.c               |    2 +-
>  arch/m68k/platform/coldfire/sltimers.c          |    4 ++--
>  arch/m68k/platform/coldfire/timers.c            |    4 ++--
>  arch/microblaze/kernel/timer.c                  |    2 +-
>  arch/mips/alchemy/common/dbdma.c                |    2 +-
>  arch/mips/alchemy/common/time.c                 |    2 +-
>  arch/mips/alchemy/devboards/db1200/platform.c   |    4 ++--
>  arch/mips/cavium-octeon/smp.c                   |    2 +-
>  arch/mips/dec/setup.c                           |    1 -
>  arch/mips/include/asm/mach-generic/floppy.h     |    2 +-
>  arch/mips/include/asm/mach-jazz/floppy.h        |    2 +-
>  arch/mips/jazz/irq.c                            |    2 +-
>  arch/mips/kernel/cevt-bcm1480.c                 |    2 +-
>  arch/mips/kernel/cevt-ds1287.c                  |    2 +-
>  arch/mips/kernel/cevt-gt641xx.c                 |    2 +-
>  arch/mips/kernel/cevt-r4k.c                     |    2 +-
>  arch/mips/kernel/cevt-sb1250.c                  |    2 +-
>  arch/mips/kernel/cevt-txx9.c                    |    2 +-
>  arch/mips/kernel/i8253.c                        |    2 +-
>  arch/mips/kernel/perf_event.c                   |    2 +-
>  arch/mips/kernel/rtlx.c                         |    1 -
>  arch/mips/kernel/smtc.c                         |    2 +-
>  arch/mips/lantiq/irq.c                          |    1 -
>  arch/mips/loongson/common/cs5536/cs5536_mfgpt.c |    2 +-
>  arch/mips/mti-malta/malta-int.c                 |    4 ++--
>  arch/mips/pci/ops-pmcmsp.c                      |    2 +-
>  arch/mips/pci/ops-tx3927.c                      |    2 +-
>  arch/mips/pci/pci-tx4927.c                      |    2 +-
>  arch/mips/pci/pci-tx4938.c                      |    2 +-
>  arch/mips/pci/pci-tx4939.c                      |    2 +-
>  arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c     |    2 +-
>  arch/mips/pmc-sierra/msp71xx/msp_smp.c          |    4 ++--
>  arch/mips/pnx8550/common/int.c                  |    4 ++--
>  arch/mips/pnx8550/common/time.c                 |    4 ++--
>  arch/mips/sgi-ip22/ip22-int.c                   |   10 +++++-----
>  arch/mips/sgi-ip27/ip27-irq.c                   |    2 +-
>  arch/mips/sgi-ip27/ip27-timer.c                 |    2 +-
>  arch/mips/sgi-ip32/ip32-irq.c                   |    2 --
>  arch/mips/sni/irq.c                             |    2 +-
>  arch/mips/sni/time.c                            |    2 +-
>  arch/mips/txx9/generic/pci.c                    |    2 +-
>  arch/mn10300/kernel/cevt-mn10300.c              |    2 +-
>  arch/mn10300/kernel/mn10300-serial.c            |    6 +++---
>  arch/mn10300/kernel/smp.c                       |    1 -
>  arch/mn10300/unit-asb2364/irq-fpga.c            |    2 +-
>  arch/parisc/include/asm/floppy.h                |    4 ++--
>  arch/parisc/kernel/irq.c                        |    4 ++--
>  arch/powerpc/include/asm/floppy.h               |    4 ++--
>  arch/powerpc/include/asm/xics.h                 |    4 ++--
>  arch/powerpc/kernel/smp.c                       |    2 +-
>  arch/powerpc/platforms/cell/beat.c              |    2 +-
>  arch/powerpc/platforms/cell/celleb_scc_pciex.c  |    2 +-
>  arch/powerpc/platforms/cell/iommu.c             |    3 +--
>  arch/powerpc/platforms/cell/pmu.c               |    2 +-
>  arch/powerpc/platforms/cell/spu_base.c          |    9 +++------
>  arch/powerpc/platforms/powermac/pic.c           |    1 -
>  arch/powerpc/platforms/powermac/smp.c           |    4 ++--
>  arch/powerpc/platforms/ps3/device-init.c        |    2 +-
>  arch/powerpc/sysdev/mpic.c                      |    2 --
>  arch/powerpc/sysdev/ppc4xx_soc.c                |    2 +-
>  arch/powerpc/sysdev/xics/xics-common.c          |    5 ++---
>  arch/score/kernel/time.c                        |    2 +-
>  arch/sh/boards/board-secureedge5410.c           |    3 +--
>  arch/sh/boards/mach-cayman/irq.c                |    2 --
>  arch/sh/boards/mach-hp6xx/hp6xx_apm.c           |    2 +-
>  arch/sh/drivers/dma/dma-g2.c                    |    2 +-
>  arch/sh/drivers/dma/dma-pvr2.c                  |    1 -
>  arch/sh/drivers/dma/dma-sh.c                    |    4 ++--
>  arch/sh/drivers/dma/dmabrg.c                    |    6 +++---
>  arch/sh/drivers/pci/pci-sh5.c                   |    4 ++--
>  arch/sh/drivers/pci/pci-sh7780.c                |    2 +-
>  arch/sh/drivers/push-switch.c                   |    2 +-
>  arch/sh/kernel/cpu/sh4a/smp-shx3.c              |    2 +-
>  arch/sparc/include/asm/floppy_64.h              |    2 +-
>  arch/sparc/kernel/ldc.c                         |    4 ++--
>  arch/um/drivers/line.c                          |    8 ++++----
>  arch/um/drivers/mconsole_kern.c                 |    2 +-
>  arch/um/drivers/net_kern.c                      |    2 +-
>  arch/um/drivers/port_kern.c                     |    4 ++--
>  arch/um/drivers/random.c                        |    2 +-
>  arch/um/drivers/ubd_kern.c                      |    2 +-
>  arch/um/drivers/xterm_kern.c                    |    2 +-
>  arch/um/kernel/sigio.c                          |    2 +-
>  arch/um/kernel/time.c                           |    2 +-
>  arch/unicore32/kernel/puv3-nb0916.c             |    4 ++--
>  arch/unicore32/kernel/time.c                    |    2 +-
>  arch/x86/include/asm/floppy.h                   |    4 ++--
>  arch/x86/kernel/hpet.c                          |    2 +-
>  arch/x86/kernel/time.c                          |    2 +-
>  arch/x86/xen/smp.c                              |    8 ++++----
>  arch/x86/xen/spinlock.c                         |    2 +-
>  arch/x86/xen/time.c                             |    5 ++---
>  arch/xtensa/kernel/time.c                       |    1 -
>  drivers/ata/pata_mpc52xx.c                      |    2 +-
>  drivers/block/cciss.c                           |    4 ++--
>  drivers/block/cpqarray.c                        |    2 +-
>  drivers/block/hd.c                              |    7 +------
>  drivers/block/mg_disk.c                         |    2 +-
>  drivers/cdrom/gdrom.c                           |    4 ++--
>  drivers/char/hpet.c                             |    2 +-
>  drivers/char/ipmi/ipmi_si_intf.c                |    4 ++--
>  drivers/char/nwbutton.c                         |    2 +-
>  drivers/char/rtc.c                              |    4 ++--
>  drivers/char/snsc.c                             |    2 +-
>  drivers/char/snsc_event.c                       |    2 +-
>  drivers/char/tlclk.c                            |    2 +-
>  drivers/clocksource/cs5535-clockevt.c           |    2 +-
>  drivers/clocksource/dw_apb_timer.c              |    3 +--
>  drivers/clocksource/sh_cmt.c                    |    2 +-
>  drivers/clocksource/sh_mtu2.c                   |    2 +-
>  drivers/clocksource/sh_tmu.c                    |    2 +-
>  drivers/clocksource/tcb_clksrc.c                |    2 +-
>  drivers/crypto/mv_cesa.c                        |    3 +--
>  drivers/dma/amba-pl08x.c                        |    2 +-
>  drivers/dma/coh901318.c                         |    2 +-
>  drivers/dma/shdma.c                             |    4 ++--
>  drivers/edac/mpc85xx_edac.c                     |    6 +++---
>  drivers/edac/mv64x60_edac.c                     |    8 ++++----
>  drivers/edac/ppc4xx_edac.c                      |    4 ++--
>  drivers/hwmon/exynos4_tmu.c                     |    2 +-
>  drivers/i2c/busses/i2c-bfin-twi.c               |    4 ++--
>  drivers/i2c/busses/i2c-designware.c             |    2 +-
>  drivers/i2c/busses/i2c-highlander.c             |    2 +-
>  drivers/i2c/busses/i2c-nomadik.c                |    2 +-
>  drivers/i2c/busses/i2c-nuc900.c                 |    2 +-
>  drivers/i2c/busses/i2c-pmcmsp.c                 |    2 +-
>  drivers/i2c/busses/i2c-s3c2410.c                |    2 +-
>  drivers/i2c/busses/i2c-sh7760.c                 |    2 +-
>  drivers/i2c/busses/i2c-sh_mobile.c              |    2 +-
>  drivers/i2c/busses/i2c-stu300.c                 |    2 +-
>  drivers/infiniband/hw/ehca/ehca_eq.c            |    4 ++--
>  drivers/isdn/hardware/eicon/divasmain.c         |    2 +-
>  drivers/isdn/sc/init.c                          |    2 +-
>  drivers/media/common/saa7146_core.c             |    2 +-
>  drivers/media/dvb/bt8xx/bt878.c                 |    2 +-
>  drivers/media/radio/si4713-i2c.c                |    2 +-
>  drivers/media/rc/winbond-cir.c                  |    2 +-
>  drivers/media/video/bt8xx/bttv-driver.c         |    2 +-
>  drivers/media/video/cx18/cx18-driver.c          |    2 +-
>  drivers/media/video/cx23885/cx23885-core.c      |    2 +-
>  drivers/media/video/cx88/cx88-alsa.c            |    2 +-
>  drivers/media/video/cx88/cx88-mpeg.c            |    2 +-
>  drivers/media/video/cx88/cx88-video.c           |    2 +-
>  drivers/media/video/davinci/vpbe_display.c      |    2 +-
>  drivers/media/video/davinci/vpfe_capture.c      |    4 ++--
>  drivers/media/video/davinci/vpif_capture.c      |    2 +-
>  drivers/media/video/davinci/vpif_display.c      |    2 +-
>  drivers/media/video/ivtv/ivtv-driver.c          |    2 +-
>  drivers/media/video/meye.c                      |    2 +-
>  drivers/media/video/s5p-mfc/s5p_mfc.c           |    3 +--
>  drivers/media/video/saa7134/saa7134-alsa.c      |    2 +-
>  drivers/media/video/saa7134/saa7134-core.c      |    2 +-
>  drivers/media/video/saa7164/saa7164-core.c      |    2 +-
>  drivers/media/video/sh_mobile_ceu_camera.c      |    2 +-
>  drivers/media/video/zoran/zoran_card.c          |    2 +-
>  drivers/misc/arm-charlcd.c                      |    2 +-
>  drivers/misc/phantom.c                          |    2 +-
>  drivers/mmc/host/omap_hsmmc.c                   |    5 ++---
>  drivers/mmc/host/tmio_mmc.c                     |    4 ++--
>  drivers/mtd/nand/mxc_nand.c                     |    2 +-
>  drivers/mtd/nand/pxa3xx_nand.c                  |    3 +--
>  drivers/mtd/nand/tmio_nand.c                    |    2 +-
>  drivers/net/ethernet/adi/bfin_mac.c             |    4 ++--
>  drivers/net/ethernet/amd/sun3lance.c            |    2 +-
>  drivers/net/ethernet/broadcom/bcm63xx_enet.c    |    4 ++--
>  drivers/net/ethernet/dec/tulip/de4x5.c          |    2 +-
>  drivers/net/ethernet/freescale/fec.c            |    2 +-
>  drivers/net/ethernet/hp/hp100.c                 |    2 +-
>  drivers/net/ethernet/ibm/ehea/ehea_main.c       |    6 +++---
>  drivers/net/ethernet/korina.c                   |    8 ++++----
>  drivers/net/ethernet/lantiq_etop.c              |    4 ++--
>  drivers/net/ethernet/marvell/pxa168_eth.c       |    2 +-
>  drivers/net/ethernet/micrel/ks8851_mll.c        |    2 +-
>  drivers/net/ethernet/natsemi/jazzsonic.c        |    2 +-
>  drivers/net/ethernet/natsemi/xtsonic.c          |    2 +-
>  drivers/net/ethernet/pasemi/pasemi_mac.c        |    4 ++--
>  drivers/net/ethernet/smsc/smc91x.h              |    2 +-
>  drivers/net/ethernet/smsc/smsc9420.c            |    2 +-
>  drivers/net/ethernet/ti/davinci_emac.c          |    2 +-
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c    |    2 +-
>  drivers/net/hamradio/baycom_ser_fdx.c           |    2 +-
>  drivers/net/hamradio/baycom_ser_hdx.c           |    2 +-
>  drivers/net/hamradio/scc.c                      |    2 +-
>  drivers/net/hamradio/yam.c                      |    2 +-
>  drivers/net/irda/bfin_sir.c                     |    4 ++--
>  drivers/net/irda/donauboe.c                     |    4 ++--
>  drivers/net/irda/sh_irda.c                      |    2 +-
>  drivers/net/irda/sh_sir.c                       |    2 +-
>  drivers/net/wan/hostess_sv11.c                  |    2 +-
>  drivers/net/wan/sealevel.c                      |    2 +-
>  drivers/net/wireless/p54/p54spi.c               |    2 +-
>  drivers/parisc/superio.c                        |    2 +-
>  drivers/pcmcia/db1xxx_ss.c                      |    4 ++--
>  drivers/pcmcia/soc_common.c                     |    2 +-
>  drivers/platform/x86/sony-laptop.c              |    2 +-
>  drivers/pnp/resource.c                          |    2 +-
>  drivers/power/wm97xx_battery.c                  |    2 +-
>  drivers/power/z2_battery.c                      |    2 +-
>  drivers/ps3/ps3-vuart.c                         |    2 +-
>  drivers/ps3/ps3stor_lib.c                       |    2 +-
>  drivers/rtc/rtc-at91sam9.c                      |    2 +-
>  drivers/rtc/rtc-cmos.c                          |    2 +-
>  drivers/rtc/rtc-coh901331.c                     |    2 +-
>  drivers/rtc/rtc-davinci.c                       |    2 +-
>  drivers/rtc/rtc-ds1511.c                        |    2 +-
>  drivers/rtc/rtc-ds1553.c                        |    2 +-
>  drivers/rtc/rtc-lpc32xx.c                       |    2 +-
>  drivers/rtc/rtc-mpc5121.c                       |    4 ++--
>  drivers/rtc/rtc-mrst.c                          |    2 +-
>  drivers/rtc/rtc-mv.c                            |    2 +-
>  drivers/rtc/rtc-nuc900.c                        |    2 +-
>  drivers/rtc/rtc-omap.c                          |    4 ++--
>  drivers/rtc/rtc-pl030.c                         |    2 +-
>  drivers/rtc/rtc-pl031.c                         |    2 +-
>  drivers/rtc/rtc-puv3.c                          |    4 ++--
>  drivers/rtc/rtc-pxa.c                           |    4 ++--
>  drivers/rtc/rtc-s3c.c                           |    4 ++--
>  drivers/rtc/rtc-sa1100.c                        |    4 ++--
>  drivers/rtc/rtc-sh.c                            |    8 ++++----
>  drivers/rtc/rtc-stk17ta8.c                      |    2 +-
>  drivers/rtc/rtc-tx4939.c                        |    2 +-
>  drivers/rtc/rtc-vr41xx.c                        |    4 ++--
>  drivers/scsi/NCR5380.c                          |    2 +-
>  drivers/scsi/aacraid/rx.c                       |    2 +-
>  drivers/scsi/aacraid/sa.c                       |    2 +-
>  drivers/scsi/aacraid/src.c                      |    2 +-
>  drivers/scsi/aha152x.c                          |    4 ++--
>  drivers/scsi/aic7xxx_old.c                      |    2 +-
>  drivers/scsi/arm/acornscsi.c                    |    2 +-
>  drivers/scsi/arm/cumana_1.c                     |    2 +-
>  drivers/scsi/arm/cumana_2.c                     |    2 +-
>  drivers/scsi/arm/powertec.c                     |    2 +-
>  drivers/scsi/dtc.c                              |    2 +-
>  drivers/scsi/eata.c                             |    2 +-
>  drivers/scsi/eata_pio.c                         |    4 ++--
>  drivers/scsi/g_NCR5380.c                        |    2 +-
>  drivers/scsi/gdth.c                             |    6 +++---
>  drivers/scsi/hpsa.c                             |    4 ++--
>  drivers/scsi/ibmvscsi/ibmvstgt.c                |    2 +-
>  drivers/scsi/in2000.c                           |    2 +-
>  drivers/scsi/initio.c                           |    2 +-
>  drivers/scsi/pas16.c                            |    2 +-
>  drivers/scsi/pm8001/pm8001_init.c               |    4 +---
>  drivers/scsi/t128.c                             |    2 +-
>  drivers/scsi/u14-34f.c                          |    2 +-
>  drivers/scsi/wd7000.c                           |    2 +-
>  drivers/spi/spi-bfin5xx.c                       |    2 +-
>  drivers/spi/spi-coldfire-qspi.c                 |    2 +-
>  drivers/spi/spi-ppc4xx.c                        |    2 +-
>  drivers/spi/spi-sh-msiof.c                      |    2 +-
>  drivers/spi/spi-sh.c                            |    2 +-
>  drivers/tty/amiserial.c                         |    2 +-
>  drivers/tty/cyclades.c                          |    2 +-
>  drivers/tty/hvc/hvc_irq.c                       |    2 +-
>  drivers/tty/hvc/hvcs.c                          |    2 +-
>  drivers/tty/hvc/hvsi.c                          |    2 +-
>  drivers/tty/isicom.c                            |    2 +-
>  drivers/tty/serial/68328serial.c                |    2 +-
>  drivers/tty/serial/altera_jtaguart.c            |    2 +-
>  drivers/tty/serial/altera_uart.c                |    2 +-
>  drivers/tty/serial/bfin_sport_uart.c            |    2 +-
>  drivers/tty/serial/bfin_uart.c                  |    8 ++++----
>  drivers/tty/serial/crisv10.c                    |   18 +++++++++---------
>  drivers/tty/serial/icom.c                       |    2 +-
>  drivers/tty/serial/lantiq.c                     |    6 +++---
>  drivers/tty/serial/mcf.c                        |    2 +-
>  drivers/tty/serial/mpc52xx_uart.c               |    2 +-
>  drivers/tty/serial/serial_ks8695.c              |    8 ++++----
>  drivers/tty/serial/sh-sci.c                     |    2 +-
>  drivers/tty/serial/sn_console.c                 |    2 +-
>  drivers/usb/core/hcd.c                          |   15 ---------------
>  drivers/video/au1200fb.c                        |    2 +-
>  drivers/video/bf54x-lq043fb.c                   |    2 +-
>  drivers/video/bfin-lq035q1-fb.c                 |    2 +-
>  drivers/video/bfin-t350mcqb-fb.c                |    2 +-
>  drivers/video/bfin_adv7393fb.c                  |    2 +-
>  drivers/video/mb862xx/mb862xxfbdrv.c            |    4 ++--
>  drivers/video/msm/mddi.c                        |    2 +-
>  drivers/video/msm/mdp.c                         |    2 +-
>  drivers/video/nuc900fb.c                        |    2 +-
>  drivers/video/omap2/displays/panel-taal.c       |    2 +-
>  drivers/video/ps3fb.c                           |    2 +-
>  drivers/video/pxa3xx-gcu.c                      |    2 +-
>  drivers/video/pxafb.c                           |    2 +-
>  drivers/video/s3c2410fb.c                       |    2 +-
>  drivers/video/sa1100fb.c                        |    3 +--
>  drivers/video/sh_mobile_lcdcfb.c                |    2 +-
>  drivers/video/tmiofb.c                          |    2 +-
>  drivers/video/vt8500lcdfb.c                     |    2 +-
>  drivers/w1/masters/ds1wm.c                      |    2 +-
>  drivers/w1/masters/omap_hdq.c                   |    2 +-
>  drivers/watchdog/coh901327_wdt.c                |    2 +-
>  drivers/watchdog/eurotechwdt.c                  |    2 +-
>  drivers/watchdog/mpcore_wdt.c                   |    3 +--
>  drivers/watchdog/octeon-wdt-main.c              |    2 +-
>  drivers/watchdog/sb_wdog.c                      |    4 ++--
>  drivers/watchdog/wdt.c                          |    2 +-
>  drivers/watchdog/wdt_pci.c                      |    2 +-
>  drivers/xen/evtchn.c                            |    2 +-
>  drivers/xen/platform-pci.c                      |    2 +-
>  include/linux/interrupt.h                       |    3 ---
>  include/net/irda/irda_device.h                  |    2 +-
>  include/sound/initval.h                         |    2 +-
>  sound/arm/aaci.c                                |    2 +-
>  sound/arm/pxa2xx-ac97-lib.c                     |    2 +-
>  sound/drivers/ml403-ac97cr.c                    |    4 ++--
>  sound/drivers/mpu401/mpu401_uart.c              |    2 +-
>  sound/drivers/mtpav.c                           |    2 +-
>  sound/drivers/serial-u16550.c                   |    2 +-
>  sound/isa/ad1816a/ad1816a_lib.c                 |    2 +-
>  sound/isa/es1688/es1688_lib.c                   |    2 +-
>  sound/isa/es18xx.c                              |    2 +-
>  sound/isa/gus/gus_main.c                        |    2 +-
>  sound/isa/gus/gusmax.c                          |    2 +-
>  sound/isa/gus/interwave.c                       |    2 +-
>  sound/isa/opl3sa2.c                             |    2 +-
>  sound/isa/opti9xx/opti92x-ad1848.c              |    2 +-
>  sound/isa/sb/sb_common.c                        |    2 +-
>  sound/isa/wavefront/wavefront.c                 |    2 +-
>  sound/isa/wss/wss_lib.c                         |    2 +-
>  sound/mips/au1x00.c                             |    4 ++--
>  sound/pci/sis7019.c                             |    4 ++--
>  sound/ppc/snd_ps3.c                             |    2 +-
>  sound/soc/au1x/dma.c                            |    2 +-
>  sound/soc/codecs/tlv320dac33.c                  |    2 +-
>  sound/soc/nuc900/nuc900-pcm.c                   |    2 +-
>  sound/soc/samsung/ac97.c                        |    2 +-
>  sound/soc/sh/fsi.c                              |    2 +-
>  sound/soc/txx9/txx9aclc-ac97.c                  |    2 +-
>  sound/sparc/amd7930.c                           |    2 +-
>  457 files changed, 570 insertions(+), 669 deletions(-)
> 
> -- 
> 1.7.4.1
