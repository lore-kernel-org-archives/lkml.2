Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1EXM07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:26:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61819 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab1EXM06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:26:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Date: Tue, 24 May 2011 14:26:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
References: <201105181047.17309.arnd@arndb.de> <201105191708.27464.arnd@arndb.de> <BANLkTinX-7GPaEXGwiNzK4bXiU7-cZk4Qw@mail.gmail.com>
In-Reply-To: <BANLkTinX-7GPaEXGwiNzK4bXiU7-cZk4Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241426.47628.arnd@arndb.de>
X-Provags-ID: V02:K0:wAb0eXTIzHNfPTCutEEdPkTimivd2msG4lDJN/SgXTu
 KTEnQE82/J7lVC+EC7W/9qCZqZObnCGwxmZMVSQ35LljOVePHR
 Yq2giEPou9Sk7ydzyb86FKeYULtfgtrtKV38S1l0wtVZmsABp0
 oaf/biTyQdFEnS2ad5QJWWAXsqC8OtH8Us0ftV05gsfWk04/eC
 p6UKJo3+M0R5/Y6dGBAPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 May 2011, Barry Song wrote:
> 2011/5/19 Arnd Bergmann <arnd@arndb.de>
>
> > If you can just post a diffstat of the stuff you currently have,
> > we also get an impression of the amount of code that you are
> > talking about.
> Arnd, thanks very much for thinking. Now the codes are based on 2.6.38
> and not quanified for sending patches. we will port them to be
> againest linux's tree.

Thanks for the diffstat, that is very helpful as an estimate. It appears
that there is a large amount of work ahead of you in this, so by the
time you get ready for inclusion, we will most certainly require this
to be based on device tree for probing of all devices. I'd strongly
recommend that you investigate what that means for you before you port
a lot of the code to 2.6.39 or 2.6.40.

Since the timing is a bit unfortunate for you, you might want to stay
on 2.6.38 with the full port and not spend too much time on forward
porting all of it, but instead migrate the drivers to be based on
device tree properties rather than platform data, so you can submit
the drivers individually upstream.

>  mach-prima2/Kconfig                                          |   32
>  mach-prima2/Makefile                                         |   11
>  mach-prima2/Makefile.boot                                    |    3
>  mach-prima2/devices.c                                        |  191 +
>  mach-prima2/include/mach/cache-sirfsoc-prima2-l2.h           |   12
>  mach-prima2/include/mach/clkdev.h                            |    5
>  mach-prima2/include/mach/debug-macro.S                       |   38
>  mach-prima2/include/mach/entry-macro.S                       |   31
>  mach-prima2/include/mach/gpio.h                              |    5
>  mach-prima2/include/mach/hardware.h                          |   10
>  mach-prima2/include/mach/io.h                                |   20
>  mach-prima2/include/mach/irqs.h                              |  284 +
>  mach-prima2/include/mach/isa-dma.h                           |   13
>  mach-prima2/include/mach/map.h                               |  263 +
>  mach-prima2/include/mach/memory.h                            |   56

The irqs.h and map.h are the largest by far here, and they should go
away for the most part with the move to device tree.

>  mach-prima2/include/mach/prima2.h                            |   20
>  mach-prima2/include/mach/prima2_pinmux.h                     |   39
>  mach-prima2/include/mach/prima2cb.h                          |  111

There is a new pinmux subsystem in the works, so you probably
end up having to write a new driver for that subsystem.

>  mach-prima2/include/mach/regs-iobrg.h                        |   54
>  mach-prima2/include/mach/regs-irq.h                          |   42
>  mach-prima2/include/mach/regs-reset.h                        |   88
>  mach-prima2/include/mach/regs-rsc.h                          |   76

For the registers, they can go together with the respective drivers
using them.

>  mach-prima2/include/mach/system.h                            |    5
>  mach-prima2/include/mach/timex.h                             |    5
>  mach-prima2/include/mach/uncompress.h                        |   45
>  mach-prima2/include/mach/vmalloc.h                           |   19
>  mach-prima2/lcdinit.c                                        |  136
>  mach-prima2/mach-prima2cb.c                                  |  226 +
>  mach-prima2/padmode.c                                        |  139
>  mach-prima2/prima2.c                                         |   81
>  mach-prima2/prima2cb-keypad.c                                |  136
>  mach-prima2/pwrc.c                                           |  286 +
>  mach-prima2/tsc2100_dev.c                                    |  137

Any drivers in here should get moved to a proper place in drivers/*/
eventually, out of the subarchitecture code.

>  mm/Kconfig                                                   |   13
>  mm/Makefile                                                  |    1
>  mm/cache-sirfsoc-prima2-l2.c                                 |  342 +
>  plat-sirfsoc/Kconfig                                         |  108
>  plat-sirfsoc/Makefile                                        |   34
>  plat-sirfsoc/adc.c                                           | 1395 ++++++++
>  plat-sirfsoc/adcprocfs.c                                     |  348 ++
>  plat-sirfsoc/apm.c                                           |  107
>  plat-sirfsoc/clock.c                                         | 1045 ++++++
>  plat-sirfsoc/clock.h                                         |   32
>  plat-sirfsoc/core.c                                          |  245 +
>  plat-sirfsoc/cpufreq.c                                       |  239 +
>  plat-sirfsoc/deepsleep.S                                     |  425 ++
>  plat-sirfsoc/dma.c                                           |  386 ++
>  plat-sirfsoc/hibernate.h                                     |  118

Same here.

>  plat-sirfsoc/include/plat/audio_controller.h                 |  333 +
>  plat-sirfsoc/include/plat/belmont.h                          |   92
>  plat-sirfsoc/include/plat/bootmem.h                          |   45
>  plat-sirfsoc/include/plat/clkdev.h                           |   15
>  plat-sirfsoc/include/plat/cpld.h                             |   27
>  plat-sirfsoc/include/plat/cpld_evb.h                         |  200 +
>  plat-sirfsoc/include/plat/cpld_fpga.h                        |  201 +
>  plat-sirfsoc/include/plat/cpu.h                              |   51
>  plat-sirfsoc/include/plat/debug-macro.S                      |   34
>  plat-sirfsoc/include/plat/gpio.h                             |   92
>  plat-sirfsoc/include/plat/hardware.h                         |   28
>  plat-sirfsoc/include/plat/iobrg.h                            |   17
>  plat-sirfsoc/include/plat/irqs.h                             |  320 +
>  plat-sirfsoc/include/plat/isa-dma.h                          |  111
>  plat-sirfsoc/include/plat/lcd_panels.h                       |   33
>  plat-sirfsoc/include/plat/map.h                              |  233 +
>  plat-sirfsoc/include/plat/memory.h                           |   43
>  plat-sirfsoc/include/plat/perfmon.h                          |   62
>  plat-sirfsoc/include/plat/pinmux.h                           |   23

It's not clear yet what will happen in the long run to the split between
mach-* and plat-* directories. Ideally, we would not need them to be
separate if we can completely abstract the SoCs within their broader
families, but we might not get that far before you merge your platform.

What other mach-* do you expect to see in the future using plat-sirfsoc,
and how similar are they to prima2?

>  plat-sirfsoc/include/plat/platform_device/android_usb_dev.h  |   27
>  plat-sirfsoc/include/plat/platform_device/audio.h            |   28
>  plat-sirfsoc/include/plat/platform_device/bt_codec.h         |   26
>  plat-sirfsoc/include/plat/platform_device/eth.h              |   26
>  plat-sirfsoc/include/plat/platform_device/gps.h              |   40
>  plat-sirfsoc/include/plat/platform_device/i2c.h              |   27
>  plat-sirfsoc/include/plat/platform_device/inner_audio.h      |   26
>  plat-sirfsoc/include/plat/platform_device/lcd.h              |   85
>  plat-sirfsoc/include/plat/platform_device/mbx.h              |   37
>  plat-sirfsoc/include/plat/platform_device/modac.h            |   26
>  plat-sirfsoc/include/plat/platform_device/mved.h             |   36
>  plat-sirfsoc/include/plat/platform_device/nand.h             |   27
>  plat-sirfsoc/include/plat/platform_device/pmem.h             |   27
>  plat-sirfsoc/include/plat/platform_device/pwm_dev.h          |   31
>  plat-sirfsoc/include/plat/platform_device/rtc.h              |   27
>  plat-sirfsoc/include/plat/platform_device/sata.h             |   33
>  plat-sirfsoc/include/plat/platform_device/sd.h               |   31
>  plat-sirfsoc/include/plat/platform_device/serial.h           |   82
>  plat-sirfsoc/include/plat/platform_device/sirfsoc_ts.h       |   31
>  plat-sirfsoc/include/plat/platform_device/snd.h              |   30
>  plat-sirfsoc/include/plat/platform_device/spi.h              |   53
>  plat-sirfsoc/include/plat/platform_device/spi_sirfsoc_gpio.h |   34
>  plat-sirfsoc/include/plat/platform_device/ts_stream_mode.h   |   26
>  plat-sirfsoc/include/plat/platform_device/usb.h              |   40
>  plat-sirfsoc/include/plat/platform_device/usppcm.h           |   25
>  plat-sirfsoc/include/plat/platform_device/uspserial.h        |   45
>  plat-sirfsoc/include/plat/platform_device/uspspi.h           |   33
>  plat-sirfsoc/include/plat/platform_device/vpp.h              |   27
>  plat-sirfsoc/include/plat/platform_device/vxd.h              |   27
>  plat-sirfsoc/include/plat/platform_device/wdt.h              |   26
>  plat-sirfsoc/platform_device/Makefile                        |   36
>  plat-sirfsoc/platform_device/android_usb_dev.c               |   60
>  plat-sirfsoc/platform_device/audio_dev.c                     |   88
>  plat-sirfsoc/platform_device/bt_codec_dev.c                  |   26
>  plat-sirfsoc/platform_device/camera_dev.c                    |  286 +
>  plat-sirfsoc/platform_device/eth_dev.c                       |   75
>  plat-sirfsoc/platform_device/gps_dev.c                       |  106
>  plat-sirfsoc/platform_device/i2c_dev.c                       |  124
>  plat-sirfsoc/platform_device/inner_audio_dev.c               |   75
>  plat-sirfsoc/platform_device/lcd_dev.c                       |  156
>  plat-sirfsoc/platform_device/mbx_dev.c                       |   74
>  plat-sirfsoc/platform_device/modac_dev.c                     |   67
>  plat-sirfsoc/platform_device/mved_dev.c                      |   70
>  plat-sirfsoc/platform_device/nand_dev.c                      |   75
>  plat-sirfsoc/platform_device/pmem_dev.c                      |   59
>  plat-sirfsoc/platform_device/pwm_device.c                    |   79
>  plat-sirfsoc/platform_device/sata_dev.c                      |   64
>  plat-sirfsoc/platform_device/sdmmc_dev.c                     |  108
>  plat-sirfsoc/platform_device/serial_dev.c                    |  241 +
>  plat-sirfsoc/platform_device/sirfsoc_rtcdev.c                |   78
>  plat-sirfsoc/platform_device/sirfsoc_tsdev.c                 |   65
>  plat-sirfsoc/platform_device/spi_dev.c                       |  163
>  plat-sirfsoc/platform_device/spigpio_dev.c                   |   75
>  plat-sirfsoc/platform_device/ts_stream_mode_dev.c            |   64
>  plat-sirfsoc/platform_device/usb_dev.c                       |  120
>  plat-sirfsoc/platform_device/usppcm_dev.c                    |   69
>  plat-sirfsoc/platform_device/uspserial_dev.c                 |  197 +
>  plat-sirfsoc/platform_device/uspspi_dev.c                    |   97
>  plat-sirfsoc/platform_device/vpp_dev.c                       |   70
>  plat-sirfsoc/platform_device/vxd_dev.c                       |   68
>  plat-sirfsoc/platform_device/wdt_dev.c                       |   41

These will probably all get replaced with device tree bindings.

>  plat-sirfsoc/include/plat/pm.h                               |   41
>  plat-sirfsoc/include/plat/pwm.h                              |   63
>  plat-sirfsoc/include/plat/regs-clkc.h                        |   33
>  plat-sirfsoc/include/plat/regs-gpio.h                        |   43
>  plat-sirfsoc/include/plat/regs-irq.h                         |   39
>  plat-sirfsoc/include/plat/regs-modac.h                       |  114
>  plat-sirfsoc/include/plat/regs-power.h                       |   77
>  plat-sirfsoc/include/plat/regs-pwm.h                         |   37
>  plat-sirfsoc/include/plat/regs-pwrc.h                        |   62
>  plat-sirfsoc/include/plat/regs-reset.h                       |   73
>  plat-sirfsoc/include/plat/regs-rsc.h                         |   78
>  plat-sirfsoc/include/plat/regs-rtc.h                         |   41
>  plat-sirfsoc/include/plat/regs-serial.h                      |   87
>  plat-sirfsoc/include/plat/regs-timer.h                       |   39
>  plat-sirfsoc/include/plat/regs-vip.h                         |   98
>  plat-sirfsoc/include/plat/sd.h                               |  110
>  plat-sirfsoc/include/plat/sirfsoc_adc.h                      |  261 +
>  plat-sirfsoc/include/plat/sirfsoc_usp.h                      |  288 +

And these can hopefully all get moved next to the respective drivers.

>  plat-sirfsoc/include/plat/system.h                           |   39
>  plat-sirfsoc/include/plat/timex.h                            |   33
>  plat-sirfsoc/include/plat/uncompress.h                       |   46
>  plat-sirfsoc/include/plat/vmalloc.h                          |   26
>  plat-sirfsoc/irq.c                                           |  102
>  plat-sirfsoc/lcd_panels.c                                    |  281 +
>  plat-sirfsoc/led.c                                           |  340 +
>  plat-sirfsoc/perfmon.c                                       | 1347 +++++++

For the perfmon implementation, I would recommend splitting it out of the
submission at the beginning. If it's based on perf, it should be easy to
add at a later stage. Otherwise, it's not going anywhere. If it's related
to the ARM system trace macrocell, I'd recommend posting the code now
(independent of the rest), because other people are interested in getting
that to work.

>  plat-sirfsoc/pinmux.c                                        |  992 +++++

-> pinmux subsystem

> for drivers/:
>  Kconfig                             |    2
>  Makefile                            |    1
>  char/sirfsoc_gps.c                  |  878 +++++++++++++
>  char/sirfsoc_gpsdrv.h               |  134 +
>  input/misc/gpio_event.c             |  253 +++

A new user space interface is always hard to establish. If you want these
to get in, you should start way ahead of the other drivers that simply
implement an existing interface.

If the gps driver is just a tty device like a serial port, it should
now be moved into drivers/tty.

>  nanddisk/Kconfig                    |   17
>  nanddisk/Makefile                   |    5
>  nanddisk/nand.c                     |  937 +++++++++++++
>  nanddisk/nanddisk.h                 |  702 ++++++++++

How does this relate to drivers/mtd?

>  net/dm9000.c                        |  290 +---
>  net/dm9000.h                        |    8

Ah, code removal ;-)

>  video/Kconfig                       |   24
>  video/Makefile                      |    2
>  video/backlight/Makefile            |    1
>  video/sirfsoc_clcdc.h               |  269 ++++
>  video/sirfsoc_fb.c                  | 2369 +++++++++++++++++++++++++++++++++++
>  video/sirfsoc_vpp.c                 | 1166 +++++++++++++++++

Have you considered doing a KMS device driver instead of an old-style
frame buffer?

> i want to upstream steps by steps. send arch/arm patches for reviewing
> at first, then clean-up drivers and send patches to subsystem for
> reviewing. There are really too many issues waiting for refination in
> arch/arm for the moment, we have more than 20 tasks for team to work.

Ok, no problem.

	Arnd
