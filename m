Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab2K3LKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:10:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36116 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab2K3LKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:10:16 -0500
MIME-Version: 1.0
In-Reply-To: <20121130110400.GA9400@avionic-0098.adnet.avionic-design.de>
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com>
 <20121123075537.A14713E0A91@localhost> <50AF3E21.4000009@ti.com>
 <50AF4584.7020604@ti.com> <20121126154600.765E03E1AFD@localhost>
 <50B5D161.6010200@ti.com> <20121129161024.EEA803E0912@localhost>
 <20121130064752.GB26474@avionic-0098.adnet.avionic-design.de>
 <20121130102039.0267E3E129E@localhost> <20121130110400.GA9400@avionic-0098.adnet.avionic-design.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 30 Nov 2012 11:09:54 +0000
X-Google-Sender-Auth: CivzTwcbLcOMjPtBbssZtafEOww
Message-ID: <CACxGe6sOhvRC4YFxKmDSc1xJ3Q6DomPpAKjtk3_gdY4XpfONRg@mail.gmail.com>
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 11:04 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:

>> > One other problem is that some PWM devices cannot be setup to achieve a
>> > 0% or 100% duty-cycle but instead will toggle for at least one period.
>> > This would be another argument in favour of moving the functionality to
>> > the individual drivers, perhaps with some functionality provided by the
>> > core to do the gpio_chip registration (a period could be passed to that
>> > function at registration time), which will likely be the same for all
>> > hardware that can and wants to support this feature.
>>
>> It is a bit of an oddball case where if the hardware engineer wires up a
>> PWM to use as a GPIO, then he better be sure that it is actually fit for
>> the purpose.
>
> Yes, I agree. So what we really want is to make this configurable in
> some way. For DT this could just be controlled by the gpio-controller
> property. The PWM core could easily setup the gpio_chip in the presence
> of that property.
>
> For non-DT it could probably be done via a flag that is passed to the
> driver via platform data, in which case the driver would have to call
> the helper explicitly based on the setting of this flag.
>
>> That doesn't prevent the PWM core having some gpio-emulation helper
>> functionality, but do need to be careful about it.
>
> On the other hand, if we turn that support into a helper maybe it is
> easier to leave it up to the driver whether to call it or not. A big
> advantage of this would be that the driver could pass a period along
> that it can choose sensibly according to the chip's capabilities.
>
> Something as simple as:
>
>         int pwmchip_emulate_gpio(struct pwm_chip *chip, unsigned long period);
>
> could do. Cleanup could be done automatically in pwmchip_remove().

Looks reasonable.

g.
