Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1EXJYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:24:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54613 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab1EXJYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hvUzAHH9HNbLpzFw00XRbMUkIGaXRKaz0A6ZS3aItfdF7XFIoKCQak6NOafu1Sv1fk
         gMSNinN1x2AJjwWdfJyYVzJChv2zXsxC7Vi5x5qhg25e5JRTS5796CQzX+O+9HTeYWr4
         k3dHK5tniQMDb46rRuF0wKI2xEbZv63nj7J3k=
MIME-Version: 1.0
In-Reply-To: <201105191708.27464.arnd@arndb.de>
References: <201105181047.17309.arnd@arndb.de> <201105191550.20129.arnd@arndb.de>
 <BANLkTikKhZu_H_QT+Uds22sepk1OnEeDNA@mail.gmail.com> <201105191708.27464.arnd@arndb.de>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 24 May 2011 17:23:53 +0800
Message-ID: <BANLkTinX-7GPaEXGwiNzK4bXiU7-cZk4Qw@mail.gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/19 Arnd Bergmann <arnd@arndb.de>
>
> On Thursday 19 May 2011, Barry Song wrote:
> > >
> > > Do you have a diffstat or a git tree with your work available?
> >
> > not yet by now. it should be coming in the middle of next month. we
> > have workable codes but need a lot of refinations before sending
> > patches for review. it is more like a new begin from scratch, so
> > arm/arch changes should be things we can catch.
>
> I'd like to make sure that you are not doing duplicate work by
> going in a wrong direction with this, so I think it would be best
> to post as early as possible, ideally with a list of things that
> you already know you need to change, so people don't need to comment
> on them.
>
> If you can just post a diffstat of the stuff you currently have,
> we also get an impression of the amount of code that you are
> talking about.
Arnd, thanks very much for thinking. Now the codes are based on 2.6.38
and not quanified for sending patches. we will port them to be
againest linux's tree.
current diffstat for arch/arm againest 2.6.38 mainline is
 Kconfig                                                      |   34
 Makefile                                                     |    5
 common/Makefile                                              |    1
 common/sirfsoc.c                                             |   21
 configs/prima2cb_defconfig                                   | 1903 +++++++++++
 include/asm/dma.h                                            |   10
 include/asm/mach/dma.h                                       |    7
 kernel/dma.c                                                 |   47
 kernel/vmlinux.lds                                           |  488 ++
 mach-prima2/Kconfig                                          |   32
 mach-prima2/Makefile                                         |   11
 mach-prima2/Makefile.boot                                    |    3
 mach-prima2/devices.c                                        |  191 +
 mach-prima2/include/mach/cache-sirfsoc-prima2-l2.h           |   12
 mach-prima2/include/mach/clkdev.h                            |    5
 mach-prima2/include/mach/debug-macro.S                       |   38
 mach-prima2/include/mach/entry-macro.S                       |   31
 mach-prima2/include/mach/gpio.h                              |    5
 mach-prima2/include/mach/hardware.h                          |   10
 mach-prima2/include/mach/io.h                                |   20
 mach-prima2/include/mach/irqs.h                              |  284 +
 mach-prima2/include/mach/isa-dma.h                           |   13
 mach-prima2/include/mach/map.h                               |  263 +
 mach-prima2/include/mach/memory.h                            |   56
 mach-prima2/include/mach/prima2.h                            |   20
 mach-prima2/include/mach/prima2_pinmux.h                     |   39
 mach-prima2/include/mach/prima2cb.h                          |  111
 mach-prima2/include/mach/regs-iobrg.h                        |   54
 mach-prima2/include/mach/regs-irq.h                          |   42
 mach-prima2/include/mach/regs-reset.h                        |   88
 mach-prima2/include/mach/regs-rsc.h                          |   76
 mach-prima2/include/mach/system.h                            |    5
 mach-prima2/include/mach/timex.h                             |    5
 mach-prima2/include/mach/uncompress.h                        |   45
 mach-prima2/include/mach/vmalloc.h                           |   19
 mach-prima2/lcdinit.c                                        |  136
 mach-prima2/mach-prima2cb.c                                  |  226 +
 mach-prima2/padmode.c                                        |  139
 mach-prima2/prima2.c                                         |   81
 mach-prima2/prima2cb-keypad.c                                |  136
 mach-prima2/pwrc.c                                           |  286 +
 mach-prima2/tsc2100_dev.c                                    |  137
 mm/Kconfig                                                   |   13
 mm/Makefile                                                  |    1
 mm/cache-sirfsoc-prima2-l2.c                                 |  342 +
 plat-sirfsoc/Kconfig                                         |  108
 plat-sirfsoc/Makefile                                        |   34
 plat-sirfsoc/adc.c                                           | 1395 ++++++++
 plat-sirfsoc/adcprocfs.c                                     |  348 ++
 plat-sirfsoc/apm.c                                           |  107
 plat-sirfsoc/clock.c                                         | 1045 ++++++
 plat-sirfsoc/clock.h                                         |   32
 plat-sirfsoc/core.c                                          |  245 +
 plat-sirfsoc/cpufreq.c                                       |  239 +
 plat-sirfsoc/deepsleep.S                                     |  425 ++
 plat-sirfsoc/dma.c                                           |  386 ++
 plat-sirfsoc/hibernate.h                                     |  118
 plat-sirfsoc/include/plat/audio_controller.h                 |  333 +
 plat-sirfsoc/include/plat/belmont.h                          |   92
 plat-sirfsoc/include/plat/bootmem.h                          |   45
 plat-sirfsoc/include/plat/clkdev.h                           |   15
 plat-sirfsoc/include/plat/cpld.h                             |   27
 plat-sirfsoc/include/plat/cpld_evb.h                         |  200 +
 plat-sirfsoc/include/plat/cpld_fpga.h                        |  201 +
 plat-sirfsoc/include/plat/cpu.h                              |   51
 plat-sirfsoc/include/plat/debug-macro.S                      |   34
 plat-sirfsoc/include/plat/gpio.h                             |   92
 plat-sirfsoc/include/plat/hardware.h                         |   28
 plat-sirfsoc/include/plat/iobrg.h                            |   17
 plat-sirfsoc/include/plat/irqs.h                             |  320 +
 plat-sirfsoc/include/plat/isa-dma.h                          |  111
 plat-sirfsoc/include/plat/lcd_panels.h                       |   33
 plat-sirfsoc/include/plat/map.h                              |  233 +
 plat-sirfsoc/include/plat/memory.h                           |   43
 plat-sirfsoc/include/plat/perfmon.h                          |   62
 plat-sirfsoc/include/plat/pinmux.h                           |   23
 plat-sirfsoc/include/plat/platform_device/android_usb_dev.h  |   27
 plat-sirfsoc/include/plat/platform_device/audio.h            |   28
 plat-sirfsoc/include/plat/platform_device/bt_codec.h         |   26
 plat-sirfsoc/include/plat/platform_device/eth.h              |   26
 plat-sirfsoc/include/plat/platform_device/gps.h              |   40
 plat-sirfsoc/include/plat/platform_device/i2c.h              |   27
 plat-sirfsoc/include/plat/platform_device/inner_audio.h      |   26
 plat-sirfsoc/include/plat/platform_device/lcd.h              |   85
 plat-sirfsoc/include/plat/platform_device/mbx.h              |   37
 plat-sirfsoc/include/plat/platform_device/modac.h            |   26
 plat-sirfsoc/include/plat/platform_device/mved.h             |   36
 plat-sirfsoc/include/plat/platform_device/nand.h             |   27
 plat-sirfsoc/include/plat/platform_device/pmem.h             |   27
 plat-sirfsoc/include/plat/platform_device/pwm_dev.h          |   31
 plat-sirfsoc/include/plat/platform_device/rtc.h              |   27
 plat-sirfsoc/include/plat/platform_device/sata.h             |   33
 plat-sirfsoc/include/plat/platform_device/sd.h               |   31
 plat-sirfsoc/include/plat/platform_device/serial.h           |   82
 plat-sirfsoc/include/plat/platform_device/sirfsoc_ts.h       |   31
 plat-sirfsoc/include/plat/platform_device/snd.h              |   30
 plat-sirfsoc/include/plat/platform_device/spi.h              |   53
 plat-sirfsoc/include/plat/platform_device/spi_sirfsoc_gpio.h |   34
 plat-sirfsoc/include/plat/platform_device/ts_stream_mode.h   |   26
 plat-sirfsoc/include/plat/platform_device/usb.h              |   40
 plat-sirfsoc/include/plat/platform_device/usppcm.h           |   25
 plat-sirfsoc/include/plat/platform_device/uspserial.h        |   45
 plat-sirfsoc/include/plat/platform_device/uspspi.h           |   33
 plat-sirfsoc/include/plat/platform_device/vpp.h              |   27
 plat-sirfsoc/include/plat/platform_device/vxd.h              |   27
 plat-sirfsoc/include/plat/platform_device/wdt.h              |   26
 plat-sirfsoc/include/plat/pm.h                               |   41
 plat-sirfsoc/include/plat/pwm.h                              |   63
 plat-sirfsoc/include/plat/regs-clkc.h                        |   33
 plat-sirfsoc/include/plat/regs-gpio.h                        |   43
 plat-sirfsoc/include/plat/regs-irq.h                         |   39
 plat-sirfsoc/include/plat/regs-modac.h                       |  114
 plat-sirfsoc/include/plat/regs-power.h                       |   77
 plat-sirfsoc/include/plat/regs-pwm.h                         |   37
 plat-sirfsoc/include/plat/regs-pwrc.h                        |   62
 plat-sirfsoc/include/plat/regs-reset.h                       |   73
 plat-sirfsoc/include/plat/regs-rsc.h                         |   78
 plat-sirfsoc/include/plat/regs-rtc.h                         |   41
 plat-sirfsoc/include/plat/regs-serial.h                      |   87
 plat-sirfsoc/include/plat/regs-timer.h                       |   39
 plat-sirfsoc/include/plat/regs-vip.h                         |   98
 plat-sirfsoc/include/plat/sd.h                               |  110
 plat-sirfsoc/include/plat/sirfsoc_adc.h                      |  261 +
 plat-sirfsoc/include/plat/sirfsoc_usp.h                      |  288 +
 plat-sirfsoc/include/plat/system.h                           |   39
 plat-sirfsoc/include/plat/timex.h                            |   33
 plat-sirfsoc/include/plat/uncompress.h                       |   46
 plat-sirfsoc/include/plat/vmalloc.h                          |   26
 plat-sirfsoc/irq.c                                           |  102
 plat-sirfsoc/lcd_panels.c                                    |  281 +
 plat-sirfsoc/led.c                                           |  340 +
 plat-sirfsoc/perfmon.c                                       | 1347 +++++++
 plat-sirfsoc/pinmux.c                                        |  992 +++++
 plat-sirfsoc/platform_device/Makefile                        |   36
 plat-sirfsoc/platform_device/android_usb_dev.c               |   60
 plat-sirfsoc/platform_device/audio_dev.c                     |   88
 plat-sirfsoc/platform_device/bt_codec_dev.c                  |   26
 plat-sirfsoc/platform_device/camera_dev.c                    |  286 +
 plat-sirfsoc/platform_device/eth_dev.c                       |   75
 plat-sirfsoc/platform_device/gps_dev.c                       |  106
 plat-sirfsoc/platform_device/i2c_dev.c                       |  124
 plat-sirfsoc/platform_device/inner_audio_dev.c               |   75
 plat-sirfsoc/platform_device/lcd_dev.c                       |  156
 plat-sirfsoc/platform_device/mbx_dev.c                       |   74
 plat-sirfsoc/platform_device/modac_dev.c                     |   67
 plat-sirfsoc/platform_device/mved_dev.c                      |   70
 plat-sirfsoc/platform_device/nand_dev.c                      |   75
 plat-sirfsoc/platform_device/pmem_dev.c                      |   59
 plat-sirfsoc/platform_device/pwm_device.c                    |   79
 plat-sirfsoc/platform_device/sata_dev.c                      |   64
 plat-sirfsoc/platform_device/sdmmc_dev.c                     |  108
 plat-sirfsoc/platform_device/serial_dev.c                    |  241 +
 plat-sirfsoc/platform_device/sirfsoc_rtcdev.c                |   78
 plat-sirfsoc/platform_device/sirfsoc_tsdev.c                 |   65
 plat-sirfsoc/platform_device/spi_dev.c                       |  163
 plat-sirfsoc/platform_device/spigpio_dev.c                   |   75
 plat-sirfsoc/platform_device/ts_stream_mode_dev.c            |   64
 plat-sirfsoc/platform_device/usb_dev.c                       |  120
 plat-sirfsoc/platform_device/usppcm_dev.c                    |   69
 plat-sirfsoc/platform_device/uspserial_dev.c                 |  197 +
 plat-sirfsoc/platform_device/uspspi_dev.c                    |   97
 plat-sirfsoc/platform_device/vpp_dev.c                       |   70
 plat-sirfsoc/platform_device/vxd_dev.c                       |   68
 plat-sirfsoc/platform_device/wdt_dev.c                       |   41
 plat-sirfsoc/pm.c                                            |  179 +
 plat-sirfsoc/pm.h                                            |   21
 plat-sirfsoc/pwm.c                                           |  508 ++
 plat-sirfsoc/sleep.S                                         |  328 +
 plat-sirfsoc/sleep_prima2.S                                  |  331 +
 plat-sirfsoc/spislave.c                                      |  138
 plat-sirfsoc/timer.c                                         |  229 +
 plat-sirfsoc/vfp.S                                           |   53
 vfp/vfpmodule.c                                              |    9
 173 files changed, 22531 insertions(+), 3 deletions(-)

but many codes actually are useless and will be deleted or be simpler
while porting to linus' newest tree.

for drivers/:
 Kconfig                             |    2
 Makefile                            |    1
 char/sirfsoc_gps.c                  |  878 +++++++++++++
 char/sirfsoc_gpsdrv.h               |  134 +
 gpio/Kconfig                        |   17
 gpio/Makefile                       |    2
 gpio/sirfsoc-gpio.c                 |  704 ++++++++++
 gpio/sirfsoc_cpld.c                 |  269 ++++
 i2c/busses/Kconfig                  |    8
 i2c/busses/Makefile                 |    1
 i2c/busses/i2c-sirfsoc.c            |  472 +++++++
 input/misc/gpio_event.c             |  253 +++
 input/touchscreen/Kconfig           |   17
 input/touchscreen/Makefile          |    2
 input/touchscreen/ads7846.c         |   82 -
 input/touchscreen/sirfsoc_ts.c      |  520 +++++++
 input/touchscreen/tsc2100.c         |  494 +++++++
 input/touchscreen/tsc2100.h         |   78 +
 mmc/host/Kconfig                    |    6
 mmc/host/Makefile                   |    1
 mmc/host/sdhci-sirfsoc.c            |  316 ++++
 mmc/host/sdhci.c                    |   10
 mmc/host/sdhci.h                    |    2
 nanddisk/Kconfig                    |   17
 nanddisk/Makefile                   |    5
 nanddisk/nand.c                     |  937 +++++++++++++
 nanddisk/nanddisk.h                 |  702 ++++++++++
 net/dm9000.c                        |  290 +---
 net/dm9000.h                        |    8
 rtc/Kconfig                         |   13
 rtc/Makefile                        |    2
 rtc/rtc-sirfsoc.c                   |  687 ++++++++++
 rtc/rtc1-sirfsoc.c                  |  328 ++++
 spi/Kconfig                         |   24
 spi/Makefile                        |    3
 spi/spi_sirfsoc.c                   | 1033 +++++++++++++++
 spi/spi_sirfsoc.h                   |  128 +
 spi/spi_sirfsoc_gpio.c              |  260 +++
 spi/spi_sirfsoc_usp.c               |  960 ++++++++++++++
 tty/serial/Kconfig                  |   58
 tty/serial/Makefile                 |    2
 tty/serial/sirfsoc_serial.c         | 1770 ++++++++++++++++++++++++++
 tty/serial/sirfsoc_serial_drv.h     |  178 ++
 tty/serial/sirfsoc_uspserial.c      | 1736 +++++++++++++++++++++++++
 usb/Kconfig                         |    3
 usb/Makefile                        |    3
 usb/gadget/Kconfig                  |    4
 usb/gadget/gadget_chips.h           |    8
 usb/host/ehci-hcd.c                 |    9
 usb/sirfusb/Kconfig                 |   11
 usb/sirfusb/Makefile                |    6
 usb/sirfusb/sirfsoc_usb_driver.c    | 1017 +++++++++++++++
 usb/sirfusb/sirfsoc_usb_drv.h       |   83 +
 usb/sirfusb/sirfsoc_usb_hcd.c       |  230 +++
 usb/sirfusb/sirfsoc_usb_os_precom.h |   50
 usb/sirfusb/sirfsoc_usb_pcd.c       | 2419 ++++++++++++++++++++++++++++++++++++
 usb/sirfusb/sirfsoc_usb_pcd.h       |  227 +++
 usb/sirfusb/sirfsoc_usb_regs.h      |  612 +++++++++
 video/Kconfig                       |   24
 video/Makefile                      |    2
 video/backlight/Makefile            |    1
 video/sirfsoc_clcdc.h               |  269 ++++
 video/sirfsoc_fb.c                  | 2369 +++++++++++++++++++++++++++++++++++
 video/sirfsoc_vpp.c                 | 1166 +++++++++++++++++
 watchdog/Kconfig                    |    7
 watchdog/Makefile                   |    1
 watchdog/sirfsoc_wdt.c              |  349 +++++
 67 files changed, 22051 insertions(+), 229 deletions(-)

i want to upstream steps by steps. send arch/arm patches for reviewing
at first, then clean-up drivers and send patches to subsystem for
reviewing. There are really too many issues waiting for refination in
arch/arm for the moment, we have more than 20 tasks for team to work.

>
>        Arnd
