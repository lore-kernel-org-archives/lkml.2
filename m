Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030337Ab2HIORc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:17:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46870 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052Ab2HIORa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:17:30 -0400
Date: Thu, 9 Aug 2012 15:17:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device
 tree
Message-ID: <20120809141727.GW24328@opensource.wolfsonmicro.com>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
 <20120809101947.GA8474@sirena.org.uk>
 <CAKGA1bkT2GDXXXAgjG4ySfTxwO=4O7o30BLzLHCMZKDrR318xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1bkT2GDXXXAgjG4ySfTxwO=4O7o30BLzLHCMZKDrR318xQ@mail.gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 08:40:36AM -0500, Matt Sealey wrote:

> The reason they're set like that is legacy - that's how they're set up
> in a kernel
> (pre-DT) that we know works. Most of those ranges are directly from the Babbage
> reference and stay like that in the Babbage DT too - so there's another broken
> one nobody noticed. I know what those voltages should be, but we're
> leaving that for another patch that restricts the range of voltages
> (it works right
> now, since there are no consumers, nothing CHANGES the voltages as
> configured at U-Boot time, and anything not boot-on is just not listed
> in the DT anyway, but some of them really need to stay on)

Oh dear.  Well, no reason to propagate the breakage - if nothing else it
might well explode if we start doing more aggressive power saving with
the regulators (like having an option for dropping down to the lower end
of the voltage ranges in late init which I keep contemplating, it'd
explode with the boards doing this).

> There are few consumers because the primary ones out there are the display
> controllers and USB hubs and some other things. MMC should be a consumer
> but since on one board we share two MMC slots with one regulator we don't
> want anyone to change the voltage (it breaks spec anyway, since we can't
> provide more than 3.15V with FSL's PMIC and it should be 3.3V by default)
> and since you can't coordinate between MMC hosts on what the lowest voltage
> both cards can support actually is.. having someone change it would be
> bad.

It's not a problem to have fixed voltages, the problem is the
combination of specifying voltage ranges in conjunction with not having
anything there that wants to change the voltage.  Especially with things
like the audio supply, it's clear what that's for and it'd normally get
upset with the voltage changing.
