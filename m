Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab2LRGOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 01:14:09 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:47660 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2LRGOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 01:14:07 -0500
X-Greylist: delayed 15446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 01:14:07 EST
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20121218060009.GK23971@game.jcrosoft.org>
References: <1355774107-364-1-git-send-email-tobetter@gmail.com>
	<1355774107-364-2-git-send-email-tobetter@gmail.com>
	<CAOesGMgZWNiCmTFGvr--zKf+vS51hX5jPnD+NZq8OvGFLS9rJA@mail.gmail.com>
	<20121218060009.GK23971@game.jcrosoft.org>
Date: Mon, 17 Dec 2012 22:14:05 -0800
Message-ID: <CAOesGMj05zX=h+79t=-GPO3YCL1R-ognrPEn7EEyw0CTdCvkHg@mail.gmail.com>
Subject: Re: [PATCH 1/4] ODROID-X: dts: Add board dts file for ODROID-X
From: Olof Johansson <olof@lixom.net>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Dongjin Kim <tobetter@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 10:00 PM, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> On 17:56 Mon 17 Dec     , Olof Johansson wrote:
>> On Mon, Dec 17, 2012 at 11:55 AM, Dongjin Kim <tobetter@gmail.com> wrote:
>> > Add initial dtb file for Hardkernel's ODROID-X board based on EXYNOS4412 SoC.
>> >
>> > Signed-off-by: Dongjin Kim <tobetter@gmail.com>
>> > ---
>> >  arch/arm/boot/dts/Makefile               |    1 +
>> >  arch/arm/boot/dts/exynos4412-odroidx.dts |   52 ++++++++++++++++++++++++++++++
>> >  2 files changed, 53 insertions(+)
>> >  create mode 100644 arch/arm/boot/dts/exynos4412-odroidx.dts
>> >
>> > diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> > index ca6fb8e..3355af9 100644
>> > --- a/arch/arm/boot/dts/Makefile
>> > +++ b/arch/arm/boot/dts/Makefile
>> > @@ -45,6 +45,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
>> >         exynos5250-smdk5250.dtb \
>> >         exynos5440-ssdk5440.dtb \
>> >         exynos4412-smdk4412.dtb \
>> > +       exynos4412-odroidx.dtb \
>>
>> Please add them alphabetically, so before smdk.
> we need to drop the \ \ stuff it will end with merge conflict
> as if you add 2 dtb at the end you will end with 2 patch that touch the same
> previous line

..which is why the dts files should be added alphabetically instead of
just appended to the list.

>> > diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
>> > new file mode 100644
>> > index 0000000..786ddd7
>> > --- /dev/null
>> > +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
>> > @@ -0,0 +1,52 @@
>> > +/*
>> > + * Hardkernel's Exynos4412 based ODROID-X board device tree source
>> > + *
>> > + * Copyright (c) 2012-2013 Dongjin Kim <tobetter@gmail.com>
>>
>> Are you from the future?
>>
>> > + *
>> > + * Device tree source file for Hardkernel's ODROID-X board which is based on
>> > + * Samsung's Exynos4412 SoC.
>> > + *
>> > + * This program is free software; you can redistribute it and/or modify
>> > + * it under the terms of the GNU General Public License version 2 as
>> > + * published by the Free Software Foundation.
>> > +*/
>> > +
>> > +/dts-v1/;
>> > +/include/ "exynos4412.dtsi"
>> > +
>> > +/ {
>> > +       model = "Hardkernel ODROID-X board based on Exynos4412";
>> > +       compatible = "samsung,exynos4412";
>>
>> It should have a more specific compatible value first, i.e.
>> "hardkernel,odroid-x" or similar.
>>
>>
>> > +       memory {
>> > +               reg = <0x40000000 0x40000000>;
>> > +       };
>> > +
>> > +       chosen {
>> > +               bootargs ="root=/dev/mmcblk0p3 rw console=ttySAC1,115200 init=/sbin/init delay=2";
>>
>> Bootargs should be passed in from u-boot, don't specify them in the
>> static device tree.
>
> why not we can choose to have a default cmdline and even usit as a complement
> of the bootloader one
>
> it's up to the dts maintainer to choose

The chance of having a valid generic command line that will work for
everyone with that hardware is fairly small, especially on more
generic systems that might have a regular distro installed on them.


-Olof
