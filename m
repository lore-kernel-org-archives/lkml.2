Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1HYJoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:44:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55671 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750827Ab1HYJoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:44:37 -0400
Date: Thu, 25 Aug 2011 10:44:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kenneth Heitke <kheitke@codeaurora.org>,
        sdharia@codeaurora.org, David Brown <davidb@codeaurora.org>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110825094434.GB31154@opensource.wolfsonmicro.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
 <1772239.ndMLD9ec3r@wuerfel>
 <20110817080327.GD13460@opensource.wolfsonmicro.com>
 <201108171242.24918.arnd@arndb.de>
 <1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
 <CACRpkdbSVF1FxpuocoXkDFH3vDQc4OoTwjU+9iqj0=vVs3R3dQ@mail.gmail.com>
 <1313636407.19990.102.camel@finisterre.wolfsonmicro.main>
 <CACRpkdbSQWej3iZF7qww1q5KW6kQTW6bqrVs4+rkLvhP5qu5fA@mail.gmail.com>
 <20110824092147.GS9232@opensource.wolfsonmicro.com>
 <CACRpkda+Yx1GCD_sUywRjXsxWa0611rt8Sd+BazTe93RVnbt7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda+Yx1GCD_sUywRjXsxWa0611rt8Sd+BazTe93RVnbt7g@mail.gmail.com>
X-Cookie: Never reveal your best argument.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 09:10:41AM +0200, Linus Walleij wrote:

> OK it's founded in Arnd's remarks that the "Linux model" is to
> use auto-detection as much as possible, which means hotplug
> *and* coldplug, i.e. auto-discovery at boot, by probing the bus
> for devices.

> If the device is not powered on boot I understand that it
> cannot be auto-discovered.

> So then you need platform data or device tree or similar to
> register the device. Which is frowned upon, if there exist
> other ways to detect the hardware.

Two problems with that.  One is that that'll only work for regulators,
not for GPIOs (eg, reset signals).  The other is that if we're going to
be pulling power from devices at runtime we're going to have to cope
with live devices hotplugging underneath an already registered device at
runtime so we've already got all the software cost of being able to
preregister everything anyway so we may as well use it.

> But maybe this is a misunderstanding on my side: maybe
> slimbus devices can be hotplugged and discovered, so the
> bus driver will tell you that a new device arrived, whereas
> it cannot be coldplugged, i.e. you cannot ask the bus to
> enumerate and say deliver the addresses to the devices
> on it?

Coldplugging should work.

> > Should be able to, yes, though we'll still need to bind
> > platform/OF data to them.

> OK so what you're saying is that it can never be made to
> have self-contained drivers without any accompanying platform
> data or device tree info?

Well, some devices might be able to work with no platform data but
that's not going to be true in the general case.
