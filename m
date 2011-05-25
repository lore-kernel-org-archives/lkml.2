Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1EYCZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 22:25:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43096 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1EYCZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 22:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AU5jw33B0CkbzK1uP8aAa4q/CfNZfoicieDoE0Uz51h0cdLLU9CBftDsR8Fc9XKJAQ
         Wr2Ivl0A/Ww4r5VPt33xo5ETEAD4pWuwoH25wUJkjnSBhu8pVA9LCuPY9S3tTOJ+HCn3
         J5pBVYLnceP2tWGv8KRw12+g+HO9Cx9ui+yZ0=
MIME-Version: 1.0
In-Reply-To: <BANLkTikfje67KyyD+7Pn0D=afTyEde0euw@mail.gmail.com>
References: <BANLkTikfje67KyyD+7Pn0D=afTyEde0euw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 25 May 2011 10:24:54 +0800
Message-ID: <BANLkTi=7p_Usp=aY3ajG8scZSr27rZRmcA@mail.gmail.com>
Subject: Re: CSR ARM SoC Subarchitecture preview
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4P2PTSf005901

2011/5/25 Barry Song <21cnbao@gmail.com>:
> Hi Arnd,
> thanks! since the discussion has been much different with original
> subject. i move to a new thread.
>
> 2011/5/24 Arnd Bergmann <arnd@arndb.de>:
>> On Tuesday 24 May 2011, Barry Song wrote:
>>> 2011/5/19 Arnd Bergmann <arnd@arndb.de>
>>>
>>> > If you can just post a diffstat of the stuff you currently have,
>>> > we also get an impression of the amount of code that you are
>>> > talking about.
>>> Arnd, thanks very much for thinking. Now the codes are based on 2.6.38
>>> and not quanified for sending patches. we will port them to be
>>> againest linux's tree.
>>
>> Thanks for the diffstat, that is very helpful as an estimate. It appears
>> that there is a large amount of work ahead of you in this, so by the
>> time you get ready for inclusion, we will most certainly require this
>> to be based on device tree for probing of all devices. I'd strongly
>> recommend that you investigate what that means for you before you port
>> a lot of the code to 2.6.39 or 2.6.40.
>>
>> Since the timing is a bit unfortunate for you, you might want to stay
>> on 2.6.38 with the full port and not spend too much time on forward
>> porting all of it, but instead migrate the drivers to be based on
>> device tree properties rather than platform data, so you can submit
>> the drivers individually upstream.
>
> good idea. then i will branch 2.6.38 for merging device tree and other
> new changes.
>
>>
>>>  mach-prima2/Kconfig                                          |   32
>>>  mach-prima2/Makefile                                         |   11
>>>  mach-prima2/Makefile.boot                                    |    3
>>>  mach-prima2/devices.c                                        |  191 +
>>>  mach-prima2/include/mach/cache-sirfsoc-prima2-l2.h           |   12
>>>  mach-prima2/include/mach/clkdev.h                            |    5
>>>  mach-prima2/include/mach/debug-macro.S                       |   38
>>>  mach-prima2/include/mach/entry-macro.S                       |   31
>>>  mach-prima2/include/mach/gpio.h                              |    5
>>>  mach-prima2/include/mach/hardware.h                          |   10
>>>  mach-prima2/include/mach/io.h                                |   20
>>>  mach-prima2/include/mach/irqs.h                              |  284 +
>>>  mach-prima2/include/mach/isa-dma.h                           |   13
>>>  mach-prima2/include/mach/map.h                               |  263 +
>>>  mach-prima2/include/mach/memory.h                            |   56
>>
>> The irqs.h and map.h are the largest by far here, and they should go
>> away for the most part with the move to device tree.
>>
>>>  mach-prima2/include/mach/prima2.h                            |   20
>>>  mach-prima2/include/mach/prima2_pinmux.h                     |   39
>>>  mach-prima2/include/mach/prima2cb.h                          |  111
>>
>> There is a new pinmux subsystem in the works, so you probably
>> end up having to write a new driver for that subsystem.
>
> i have noticed the pinmux from Linus Walleij. that is a task we want to do.
>
>>
>>>  mach-prima2/include/mach/regs-iobrg.h                        |   54
>>>  mach-prima2/include/mach/regs-irq.h                          |   42
>>>  mach-prima2/include/mach/regs-reset.h                        |   88
>>>  mach-prima2/include/mach/regs-rsc.h                          |   76
>>
>> For the registers, they can go together with the respective drivers
>> using them.
>
> ok. looks like they should be limited to use in special drivers for
> low coupling and other drivers call functions not access registers
> directly.
> then i will check whether they are overall shared, which cause them be
> in mach head files.
>
>>
>>>  mach-prima2/include/mach/system.h                            |    5
>>>  mach-prima2/include/mach/timex.h                             |    5
>>>  mach-prima2/include/mach/uncompress.h                        |   45
>>>  mach-prima2/include/mach/vmalloc.h                           |   19
>>>  mach-prima2/lcdinit.c                                        |  136
>>>  mach-prima2/mach-prima2cb.c                                  |  226 +
>>>  mach-prima2/padmode.c                                        |  139
>>>  mach-prima2/prima2.c                                         |   81
>>>  mach-prima2/prima2cb-keypad.c                                |  136
>>>  mach-prima2/pwrc.c                                           |  286 +
>>>  mach-prima2/tsc2100_dev.c                                    |  137
>>
>> Any drivers in here should get moved to a proper place in drivers/*/
>> eventually, out of the subarchitecture code.
>
> things related with driver framework/callbacks will be moved out.
> platform_device data/hardware-related callbacks will be kept. but if
> device tree supports platform_device data/callbacks good, i will take
> a look whether we can delete as many as possible.
>
>>
>>>  mm/Kconfig                                                   |   13
>>>  mm/Makefile                                                  |    1
>>>  mm/cache-sirfsoc-prima2-l2.c                                 |  342 +
>>>  plat-sirfsoc/Kconfig                                         |  108
>>>  plat-sirfsoc/Makefile                                        |   34
>>>  plat-sirfsoc/adc.c                                           | 1395 ++++++++
>>>  plat-sirfsoc/adcprocfs.c                                     |  348 ++
>>>  plat-sirfsoc/apm.c                                           |  107
>>>  plat-sirfsoc/clock.c                                         | 1045 ++++++
>>>  plat-sirfsoc/clock.h                                         |   32
>>>  plat-sirfsoc/core.c                                          |  245 +
>>>  plat-sirfsoc/cpufreq.c                                       |  239 +
>>>  plat-sirfsoc/deepsleep.S                                     |  425 ++
>>>  plat-sirfsoc/dma.c                                           |  386 ++
>>>  plat-sirfsoc/hibernate.h                                     |  118
>>
>> Same here.
>>
>>>  plat-sirfsoc/include/plat/audio_controller.h                 |  333 +
>>>  plat-sirfsoc/include/plat/belmont.h                          |   92
>>>  plat-sirfsoc/include/plat/bootmem.h                          |   45
>>>  plat-sirfsoc/include/plat/clkdev.h                           |   15
>>>  plat-sirfsoc/include/plat/cpld.h                             |   27
>>>  plat-sirfsoc/include/plat/cpld_evb.h                         |  200 +
>>>  plat-sirfsoc/include/plat/cpld_fpga.h                        |  201 +
>>>  plat-sirfsoc/include/plat/cpu.h                              |   51
>>>  plat-sirfsoc/include/plat/debug-macro.S                      |   34
>>>  plat-sirfsoc/include/plat/gpio.h                             |   92
>>>  plat-sirfsoc/include/plat/hardware.h                         |   28
>>>  plat-sirfsoc/include/plat/iobrg.h                            |   17
>>>  plat-sirfsoc/include/plat/irqs.h                             |  320 +
>>>  plat-sirfsoc/include/plat/isa-dma.h                          |  111
>>>  plat-sirfsoc/include/plat/lcd_panels.h                       |   33
>>>  plat-sirfsoc/include/plat/map.h                              |  233 +
>>>  plat-sirfsoc/include/plat/memory.h                           |   43
>>>  plat-sirfsoc/include/plat/perfmon.h                          |   62
>>>  plat-sirfsoc/include/plat/pinmux.h                           |   23
>>
>> It's not clear yet what will happen in the long run to the split between
>> mach-* and plat-* directories. Ideally, we would not need them to be
>> separate if we can completely abstract the SoCs within their broader
>> families, but we might not get that far before you merge your platform.
>
> before prima2 SoC, we have mach-atlas4,  mach-atlas5 and mach-prima.
> after prima2, we will have mach-atlas6. many ip cores are shared
> between these SoCs, then there is a plat.
> but we will not maintain old mach-atlas4,  mach-atlas5 and mach-prima
> for the current and future kernel. the new mach-atlas6 is the coming
> SoC we will upstream after mach-prima2.
>
>>
>> What other mach-* do you expect to see in the future using plat-sirfsoc,
>> and how similar are they to prima2?
>
> plat-sirfsoc should be things shared by mach-prima2/mach-atlas6 and
> other future SoCs.
>
>>
>>>  plat-sirfsoc/include/plat/platform_device/android_usb_dev.h  |   27
>>>  plat-sirfsoc/include/plat/platform_device/audio.h            |   28
>>>  plat-sirfsoc/include/plat/platform_device/bt_codec.h         |   26
>>>  plat-sirfsoc/include/plat/platform_device/eth.h              |   26
>>>  plat-sirfsoc/include/plat/platform_device/gps.h              |   40
>>>  plat-sirfsoc/include/plat/platform_device/i2c.h              |   27
>>>  plat-sirfsoc/include/plat/platform_device/inner_audio.h      |   26
>>>  plat-sirfsoc/include/plat/platform_device/lcd.h              |   85
>>>  plat-sirfsoc/include/plat/platform_device/mbx.h              |   37
>>>  plat-sirfsoc/include/plat/platform_device/modac.h            |   26
>>>  plat-sirfsoc/include/plat/platform_device/mved.h             |   36
>>>  plat-sirfsoc/include/plat/platform_device/nand.h             |   27
>>>  plat-sirfsoc/include/plat/platform_device/pmem.h             |   27
>>>  plat-sirfsoc/include/plat/platform_device/pwm_dev.h          |   31
>>>  plat-sirfsoc/include/plat/platform_device/rtc.h              |   27
>>>  plat-sirfsoc/include/plat/platform_device/sata.h             |   33
>>>  plat-sirfsoc/include/plat/platform_device/sd.h               |   31
>>>  plat-sirfsoc/include/plat/platform_device/serial.h           |   82
>>>  plat-sirfsoc/include/plat/platform_device/sirfsoc_ts.h       |   31
>>>  plat-sirfsoc/include/plat/platform_device/snd.h              |   30
>>>  plat-sirfsoc/include/plat/platform_device/spi.h              |   53
>>>  plat-sirfsoc/include/plat/platform_device/spi_sirfsoc_gpio.h |   34
>>>  plat-sirfsoc/include/plat/platform_device/ts_stream_mode.h   |   26
>>>  plat-sirfsoc/include/plat/platform_device/usb.h              |   40
>>>  plat-sirfsoc/include/plat/platform_device/usppcm.h           |   25
>>>  plat-sirfsoc/include/plat/platform_device/uspserial.h        |   45
>>>  plat-sirfsoc/include/plat/platform_device/uspspi.h           |   33
>>>  plat-sirfsoc/include/plat/platform_device/vpp.h              |   27
>>>  plat-sirfsoc/include/plat/platform_device/vxd.h              |   27
>>>  plat-sirfsoc/include/plat/platform_device/wdt.h              |   26
>>>  plat-sirfsoc/platform_device/Makefile                        |   36
>>>  plat-sirfsoc/platform_device/android_usb_dev.c               |   60
>>>  plat-sirfsoc/platform_device/audio_dev.c                     |   88
>>>  plat-sirfsoc/platform_device/bt_codec_dev.c                  |   26
>>>  plat-sirfsoc/platform_device/camera_dev.c                    |  286 +
>>>  plat-sirfsoc/platform_device/eth_dev.c                       |   75
>>>  plat-sirfsoc/platform_device/gps_dev.c                       |  106
>>>  plat-sirfsoc/platform_device/i2c_dev.c                       |  124
>>>  plat-sirfsoc/platform_device/inner_audio_dev.c               |   75
>>>  plat-sirfsoc/platform_device/lcd_dev.c                       |  156
>>>  plat-sirfsoc/platform_device/mbx_dev.c                       |   74
>>>  plat-sirfsoc/platform_device/modac_dev.c                     |   67
>>>  plat-sirfsoc/platform_device/mved_dev.c                      |   70
>>>  plat-sirfsoc/platform_device/nand_dev.c                      |   75
>>>  plat-sirfsoc/platform_device/pmem_dev.c                      |   59
>>>  plat-sirfsoc/platform_device/pwm_device.c                    |   79
>>>  plat-sirfsoc/platform_device/sata_dev.c                      |   64
>>>  plat-sirfsoc/platform_device/sdmmc_dev.c                     |  108
>>>  plat-sirfsoc/platform_device/serial_dev.c                    |  241 +
>>>  plat-sirfsoc/platform_device/sirfsoc_rtcdev.c                |   78
>>>  plat-sirfsoc/platform_device/sirfsoc_tsdev.c                 |   65
>>>  plat-sirfsoc/platform_device/spi_dev.c                       |  163
>>>  plat-sirfsoc/platform_device/spigpio_dev.c                   |   75
>>>  plat-sirfsoc/platform_device/ts_stream_mode_dev.c            |   64
>>>  plat-sirfsoc/platform_device/usb_dev.c                       |  120
>>>  plat-sirfsoc/platform_device/usppcm_dev.c                    |   69
>>>  plat-sirfsoc/platform_device/uspserial_dev.c                 |  197 +
>>>  plat-sirfsoc/platform_device/uspspi_dev.c                    |   97
>>>  plat-sirfsoc/platform_device/vpp_dev.c                       |   70
>>>  plat-sirfsoc/platform_device/vxd_dev.c                       |   68
>>>  plat-sirfsoc/platform_device/wdt_dev.c                       |   41
>>
>> These will probably all get replaced with device tree bindings.
>
> good.
>
>>
>>>  plat-sirfsoc/include/plat/pm.h                               |   41
>>>  plat-sirfsoc/include/plat/pwm.h                              |   63
>>>  plat-sirfsoc/include/plat/regs-clkc.h                        |   33
>>>  plat-sirfsoc/include/plat/regs-gpio.h                        |   43
>>>  plat-sirfsoc/include/plat/regs-irq.h                         |   39
>>>  plat-sirfsoc/include/plat/regs-modac.h                       |  114
>>>  plat-sirfsoc/include/plat/regs-power.h                       |   77
>>>  plat-sirfsoc/include/plat/regs-pwm.h                         |   37
>>>  plat-sirfsoc/include/plat/regs-pwrc.h                        |   62
>>>  plat-sirfsoc/include/plat/regs-reset.h                       |   73
>>>  plat-sirfsoc/include/plat/regs-rsc.h                         |   78
>>>  plat-sirfsoc/include/plat/regs-rtc.h                         |   41
>>>  plat-sirfsoc/include/plat/regs-serial.h                      |   87
>>>  plat-sirfsoc/include/plat/regs-timer.h                       |   39
>>>  plat-sirfsoc/include/plat/regs-vip.h                         |   98
>>>  plat-sirfsoc/include/plat/sd.h                               |  110
>>>  plat-sirfsoc/include/plat/sirfsoc_adc.h                      |  261 +
>>>  plat-sirfsoc/include/plat/sirfsoc_usp.h                      |  288 +
>>
>> And these can hopefully all get moved next to the respective drivers.
>
> good.
>
>>
>>>  plat-sirfsoc/include/plat/system.h                           |   39
>>>  plat-sirfsoc/include/plat/timex.h                            |   33
>>>  plat-sirfsoc/include/plat/uncompress.h                       |   46
>>>  plat-sirfsoc/include/plat/vmalloc.h                          |   26
>>>  plat-sirfsoc/irq.c                                           |  102
>>>  plat-sirfsoc/lcd_panels.c                                    |  281 +
>>>  plat-sirfsoc/led.c                                           |  340 +
>>>  plat-sirfsoc/perfmon.c                                       | 1347 +++++++
>>
>> For the perfmon implementation, I would recommend splitting it out of the
>> submission at the beginning. If it's based on perf, it should be easy to
>> add at a later stage. Otherwise, it's not going anywhere. If it's related
>> to the ARM system trace macrocell, I'd recommend posting the code now
>> (independent of the rest), because other people are interested in getting
>> that to work.
> sorry for not exculding this file in diff.
> perfmon is a IP included by our old atlas5 and doesn't exist in
> prima2, which exports bus bandwidth and latency. it is not related
> with STM. and it is not based on perf too.  people wrote this driver a
> long time ago and simply exported some registers to userspace by proc.
> it should not be in our final patches.
>
>>
>>>  plat-sirfsoc/pinmux.c                                        |  992 +++++
>>
>> -> pinmux subsystem
>>
>>> for drivers/:
>>>  Kconfig                             |    2
>>>  Makefile                            |    1
>>>  char/sirfsoc_gps.c                  |  878 +++++++++++++
>>>  char/sirfsoc_gpsdrv.h               |  134 +
>>>  input/misc/gpio_event.c             |  253 +++
>>
>> A new user space interface is always hard to establish. If you want these
>> to get in, you should start way ahead of the other drivers that simply
>> implement an existing interface.
>>
>> If the gps driver is just a tty device like a serial port, it should
>> now be moved into drivers/tty.
>
> most GPS are /dev/ttySn to userspace, they are connected to SoC by
> uart.  DSP is one of CSR's main product lines. An internal DSP in SoC

sorry for typo. *GPS* is one of CSR's main product lines.

> handles GPS and we use this driver to communicate with the DSP. i will
> take a look whether we can have better framework than a simple char
> device.
>
>>
>>>  nanddisk/Kconfig                    |   17
>>>  nanddisk/Makefile                   |    5
>>>  nanddisk/nand.c                     |  937 +++++++++++++
>>>  nanddisk/nanddisk.h                 |  702 ++++++++++
>>
>> How does this relate to drivers/mtd?
>
> that is a big issue to upstream. CSR built a NTFL supporting both
> WINCE/Linux with good performance and proved reliable products. the
> NTFL is a binary. NAND disk is a up level block driver to call API in
> the NTFL binary.
> that makes the NAND related codes very difficult to be accepted since
> it is completely not based on MTD. i hope we can also have a MTD based
> driver and compare the performance of  UBI on MTD and current
> solution.
>
>>
>>>  net/dm9000.c                        |  290 +---
>>>  net/dm9000.h                        |    8
>>
>> Ah, code removal ;-)
>
> sure. some guys hacked dm9000 to make it work on my debug board. but
> it is unneccessary since we can modify related platform data in
> arch/arm.
>
>>
>>>  video/Kconfig                       |   24
>>>  video/Makefile                      |    2
>>>  video/backlight/Makefile            |    1
>>>  video/sirfsoc_clcdc.h               |  269 ++++
>>>  video/sirfsoc_fb.c                  | 2369 +++++++++++++++++++++++++++++++++++
>>>  video/sirfsoc_vpp.c                 | 1166 +++++++++++++++++
>>
>> Have you considered doing a KMS device driver instead of an old-style
>> frame buffer?
>
> it depends on the whole schedule and resources of the related teams.
> i'd like to see the stronger KMS driver.
>
>>
>>> i want to upstream steps by steps. send arch/arm patches for reviewing
>>> at first, then clean-up drivers and send patches to subsystem for
>>> reviewing. There are really too many issues waiting for refination in
>>> arch/arm for the moment, we have more than 20 tasks for team to work.
>>
>> Ok, no problem.
>>
>>        Arnd
>>
> -barry
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
