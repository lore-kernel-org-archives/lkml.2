Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2HINk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:40:59 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35687 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2HINk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:40:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120809101947.GA8474@sirena.org.uk>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com> <20120809101947.GA8474@sirena.org.uk>
From: Matt Sealey <matt@genesi-usa.com>
Date: Thu, 9 Aug 2012 08:40:36 -0500
Message-ID: <CAKGA1bkT2GDXXXAgjG4ySfTxwO=4O7o30BLzLHCMZKDrR318xQ@mail.gmail.com>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device tree
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:19 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Aug 07, 2012 at 04:46:18PM -0500, Matt Sealey wrote:
>
> Yay for indentation!  It'd be good to rewrite your DT so you could cut
> down on that, at the minute it's not good for legibility.
>
>> +                                                     sw1_reg: sw1 {
>> +                                                             regulator-min-microvolt = <600000>;
>> +                                                             regulator-max-microvolt = <1375000>;
>> +                                                             regulator-boot-on;
>> +                                                             regulator-always-on;
>> +                                                     };
>
> This and many of your other regulators have voltage ranges specified but
> no consumers which doesn't make sense.  It looks awfully like you've
> just typed in the maximum range supported by the regulator which is most
> likely broken.
>
> You're also specifying both boot_on and always_on which again doesn't
> seem to make a lot of sense - boot_on mainly exists to help autoprobe,
> using it quite this routinely isn't too clever.

The reason they're set like that is legacy - that's how they're set up
in a kernel
(pre-DT) that we know works. Most of those ranges are directly from the Babbage
reference and stay like that in the Babbage DT too - so there's another broken
one nobody noticed. I know what those voltages should be, but we're
leaving that for another patch that restricts the range of voltages
(it works right
now, since there are no consumers, nothing CHANGES the voltages as
configured at U-Boot time, and anything not boot-on is just not listed
in the DT anyway, but some of them really need to stay on)

There are few consumers because the primary ones out there are the display
controllers and USB hubs and some other things. MMC should be a consumer
but since on one board we share two MMC slots with one regulator we don't
want anyone to change the voltage (it breaks spec anyway, since we can't
provide more than 3.15V with FSL's PMIC and it should be 3.3V by default)
and since you can't coordinate between MMC hosts on what the lowest voltage
both cards can support actually is.. having someone change it would be
bad.

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
