Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2LVDIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:08:18 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35501 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2LVDIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:08:15 -0500
MIME-Version: 1.0
In-Reply-To: <007b01cddfa6$f158b460$d40a1d20$@samsung.com>
References: <1356111423-3454-1-git-send-email-tobetter@gmail.com>
	<1356111423-3454-2-git-send-email-tobetter@gmail.com>
	<007b01cddfa6$f158b460$d40a1d20$@samsung.com>
Date: Sat, 22 Dec 2012 12:02:36 +0900
Message-ID: <CADoNuNfomOi9Addt1irqOhi3dOn6TZ9xe-PbpP9iZ=P=0RS60A@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ODROID-X: dts: Add board dts file for ODROID-X
From: Dongjin Kim <tobetter@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

Thank you for your review.

I was confused a little bit about bootargs what is better removing or
including it in the board file, obviously I saw error message failing
mount the root file system if I remove bootargs from board file and
with default bootargs from u-boot.

What I thought is passing bootargs from boot-loader would be better to
give more options like boot device and partition setup to the
developers. If board file has fixed bootargs, then DTS file has to be
updated whenever boot partition is changed or arguments need to be
changed. And bootargs and other boot configuration could be set up
from u-boot itself with certain script as well, I believe that this is
much easier and comfortable rather than changing DTS file. We also can
start the hardware with initramfs with default bootargs like
"boot=/dev/ram0 rw ramdisk=8192..." and mount the expected boot
partition for rootfs, anyhow real boot media has to be specified in
bootargs as well.

Thanks and any advice will be welcomed a lot.

Best regrds,
Dongjin.

On Sat, Dec 22, 2012 at 3:13 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Dongjin Kim wrote:
>>
>> Add initial dtb file for Hardkernel's ODROID-X board based on EXYNOS4412
>> SoC.
>>
>> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
>> ---
>>  arch/arm/boot/dts/Makefile               |    1 +
>>  arch/arm/boot/dts/exynos4412-odroidx.dts |   47
>> ++++++++++++++++++++++++++++++
>>  2 files changed, 48 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/exynos4412-odroidx.dts
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index d077ef8..364d67b 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -44,6 +44,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-
>> origen.dtb \
>>       exynos4210-trats.dtb \
>>       exynos5250-smdk5250.dtb \
>>       exynos5440-ssdk5440.dtb \
>> +     exynos4412-odroidx.dtb \
>>       exynos4412-smdk4412.dtb \
>>       exynos5250-smdk5250.dtb \
>>       exynos5250-snow.dtb
>
> Just now, I sorted out the ordering alphabetically and submitted.
>
>> diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts
>> b/arch/arm/boot/dts/exynos4412-odroidx.dts
>> new file mode 100644
>> index 0000000..323ed177
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
>> @@ -0,0 +1,47 @@
>> +/*
>> + * Hardkernel's Exynos4412 based ODROID-X board device tree source
>> + *
>> + * Copyright (c) 2012 Dongjin Kim <tobetter@gmail.com>
>> + *
>> + * Device tree source file for Hardkernel's ODROID-X board which is based
>> on
>> + * Samsung's Exynos4412 SoC.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> +*/
>> +
>> +/dts-v1/;
>> +/include/ "exynos4412.dtsi"
>> +
>> +/ {
>> +     model = "Hardkernel ODROID-X board based on Exynos4412";
>> +     compatible = "hardkernel,exynos4412", "samsung,exynos4412";
>
> Probably,
>
> +       compatible = "hardkernel,odroid-x", "samsung,exynos4412";
>
>> +
>> +     memory {
>> +             reg = <0x40000000 0x40000000>;
>
> If you can't see any error message in kernel boot, boot-loader should inform
> the memory size and bank information to the kernel. So should be separated
> with bank size, 256MiB. But I need to think again as Olof said in other
> thread.
>
>> +     };
>> +
>> +     serial@13800000 {
>> +             status = "okay";
>> +     };
>> +
>> +     serial@13810000 {
>> +             status = "okay";
>> +     };
>> +
>> +     serial@13820000 {
>> +             status = "okay";
>> +     };
>> +
>> +     serial@13830000 {
>> +             status = "okay";
>> +     };
>> +
>> +     sdhci@12530000 {
>> +             bus-width = <4>;
>> +             pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
>> +             pinctrl-names = "default";
>> +             status = "okay";
>> +     };
>> +};
>> --
>> 1.7.9.5
>
> BTW, you don't need any bootargs as default?
>
> - Kukjin
>
