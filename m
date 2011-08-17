Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab1HQILq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 04:11:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43508 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751884Ab1HQILn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 04:11:43 -0400
Date: Wed, 17 Aug 2011 17:03:27 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, sdharia@codeaurora.org,
        David Brown <davidb@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110817080327.GD13460@opensource.wolfsonmicro.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
 <4380004.YTvKt3Mlxd@wuerfel>
 <4E4AFCC9.7020109@codeaurora.org>
 <1772239.ndMLD9ec3r@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1772239.ndMLD9ec3r@wuerfel>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 09:09:44AM +0200, Arnd Bergmann wrote:

> * Move the logic for enabling and disabling devices into a host specific
>   driver that takes care of powering the devices up initially, identifying
>   them and putting them into run-time PM disabled state when no driver was
>   found or the device is unused.

> This will make it possible to reuse the same driver for multiple machines
> that have the same endpoint devices, while moving all the board specific
> clock and reset logic into a separate driver, which can be very small in
> many cases.

There should be no more need for this with slimbus than there is with
any of our other buses - this sort of dynamic enable and disable is
already standard practice for devices in embedded systems.  There's some
stuff it'd be good to do here but it shouldn't be driver specific, it
should be a generic device model thing.  The main problem cases right
now are things like USB which currently assume there's no magic going on
outside of the bus.

One thing I've wanted to do for a while but never quite got the time to
look at yet is to add support for automatically enabling and disabling
regulators along with the probe, remove, suspend and runtime suspend
paths.  If there's sufficient hooks for that they should also be usable
for anything that is suitably board specific.

> I would guess that in many cases, the logic for enabling the devices
> fits into the slimbus host driver. If that is not the case, e.g. when
> a lot of machines have the same host controller but each of them uses
> a different way to get the devices out of reset, you can turn the host

I'd expect that bringing the device out of reset is going to be largely
unrelated to the host controller, it's going to be GPIOs, clocks and
regulators.  The individual drivers are going to want to manage this
stuff dynamically at runtime too.
