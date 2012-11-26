Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2KZHr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 02:47:59 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:32800 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2KZHr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 02:47:58 -0500
MIME-Version: 1.0
In-Reply-To: <slrnkb64p3.2k6.narkewoody@zuhnb712.local.com>
References: <slrnkb64p3.2k6.narkewoody@zuhnb712.local.com>
Date: Mon, 26 Nov 2012 08:47:57 +0100
Message-ID: <CAAfyv35QOvgvH8xoMkE-S5Zf-9HF5Jb9X1EbMoi2FCcx1UMXNA@mail.gmail.com>
Subject: Re: The ethernet driver doesn't get probed
From: Belisko Marek <marek.belisko@gmail.com>
To: Woody Wu <narkewoody@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 7:59 AM, Woody Wu <narkewoody@gmail.com> wrote:
> Hi, List
>
> I enabled an ax88796 Ethernet driver in the kernel configuration menu.
> Kernel version is 3.4.19. The arch is ARM and the system type is
> Samsung S3C2410.
>
> In my debugging, I found the probe function of the driver did not get
> invoked.
Did you define platform data and platform device in board file?
See: arch/arm/mach-pxa/colibri-pxa300.c (line ~87)
>
> This driver is declared as platform_driver
>
> static struct platform_driver axdrv = {
>         .driver = {
>                 .name           = "ax88796",
>                 .owner          = THIS_MODULE,
>         },
>         .probe          = ax_probe,
>         .remove         = ax_remove,
>         .suspend        = ax_suspend,
>         .resume         = ax_resume,
> };
>
> module_platform_driver(axdrv);
>
> So, its driver init function actually goes through
> platform_driver_register() and then driver_register(), which eventually
> call driver_attach() trying to attach the driver to the "platform" bus.
> But, on the platform bus, there is no any device that can match the
> ax88796 driver, hence the driver failed in attaching.
>
> I discovered the full list of devices found on the platform bus:
>
>     s3c2410-ohci,
>     s3c2410-lcd,
>     s3c2410-wdt,
>     s3c2410-i2c,
>     s3c24xx-iis,
>     s3c2410-nand,
>     s3c24xx_led,
>     s3c2410-uart,
>
> You see, in the list, there is no a device looks like ax88796. All these
> already existed devices on the platform bus are build-in peripherals on
> the SoC of s3c2410, they are compiled into the code by enabling some
> kernel configuration options.
>
> My question is, in terms of Linux driver technology, how to enable a
> non-PCI and not on-chip device driver? I think the ax_probe function
> must be called somehow, is this thinking right? If yes, I think before
> the driver get initialized, the corresponding device has to appear on
> the bus, but now it seems not.
>
> Thanks in advance.
>
> --
> woody
> I can't go back to yesterday - because I was a different person then.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Cheers,

mbe

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
