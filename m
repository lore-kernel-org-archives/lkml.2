Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2GEKKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:10:50 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:59230 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab2GEKKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:10:49 -0400
MIME-Version: 1.0
In-Reply-To: <4FF56029.2060007@linaro.org>
References: <1341412452-3808-1-git-send-email-lee.jones@linaro.org>
	<CACRpkdb1rZQWpuUxQoxqg2eYanf4tnm0SmFkQQBwvSuyYV00Gw@mail.gmail.com>
	<4FF56029.2060007@linaro.org>
Date: Thu, 5 Jul 2012 12:10:48 +0200
Message-ID: <CACRpkdaEBXprf8-6hXTi=p6pmuYo84io6D1BUzyvMWebro8TvA@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Register pinctrl from platform code until
 it's been DT:ed
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        Stephen Warren <swarren@wwwdotorg.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Patrice CHOTARD <patrice.chotard@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 11:36 AM, Lee Jones <lee.jones@linaro.org> wrote:

> A way to link
> the mapping tables registered with a platform device to the driver started
> with Device Tree is missing. This can be over-come by several methods:
>
> a) Create a binding which takes a device name to tag onto a mapping. This
> can be used in the name based searches currently employed by pinctrl. This
> is the binding I was talking about in the commit log. In retrospect, I can
> see that this is not the correct solution.

This is what the generic bindings does. The binding already exists.
It's a matter of augmenting the device tree per se, and making sure
the static maps are not enabled if you have these nodes.

> b) Continue using Device Tree and force the 'pinctrl-db8500' device name
> which any string based searches will be expecting with AUXDATA(). We do
> similar things for clock-names already. However, this must be seen as a
> hacky work-around and it to be removed after full enablement has been taken
> place.
>
> c) Prevent the pinctrl driver from being started by Device Tree and allow
> platform code to register the device until we can populate the device tree
> with all of the mappings. This is the way you advised me to do it [see
> below] and it's what this patch tries to achieve.

Yeah.

>> examples of how to do this in for example:
>> arch/arm/boot/dts/tegra-seaboard.dts
>
> I don't see this file anywhere?

It's in my linux-next from yesterday, but any tegra-* with a "pinmux" node
will do the illustration I think?

>> Is the DT machinery really incapable of specifying
>> the device name to anything else than the bus name?
>> Can't you do this with AUX_DATA()? I've seen that done in the
>> past. For example you do:
>>
>> OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e000, "gpio.0", NULL),
>>
>> Can't you just:
>> OF_DEV_AUXDATA("stericsson,nmk_pinctrl", 0, "pinctrl-db8500", NULL),
>>
>> And it will happily assign the "pinctrl-db8500" name to it's instantiated
>> device?
>
> Yes, this will work, see option 'b' above.

OK! Go for it.

Linus Walleij
