Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1HXJVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:21:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55133 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751557Ab1HXJVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:21:49 -0400
Date: Wed, 24 Aug 2011 10:21:47 +0100
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
Message-ID: <20110824092147.GS9232@opensource.wolfsonmicro.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
 <1772239.ndMLD9ec3r@wuerfel>
 <20110817080327.GD13460@opensource.wolfsonmicro.com>
 <201108171242.24918.arnd@arndb.de>
 <1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
 <CACRpkdbSVF1FxpuocoXkDFH3vDQc4OoTwjU+9iqj0=vVs3R3dQ@mail.gmail.com>
 <1313636407.19990.102.camel@finisterre.wolfsonmicro.main>
 <CACRpkdbSQWej3iZF7qww1q5KW6kQTW6bqrVs4+rkLvhP5qu5fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbSQWej3iZF7qww1q5KW6kQTW6bqrVs4+rkLvhP5qu5fA@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 11:15:56AM +0200, Linus Walleij wrote:
> On Thu, Aug 18, 2011 at 5:00 AM, Mark Brown
> > On Wed, 2011-08-17 at 15:17 +0200, Linus Walleij wrote:

> >> And I guess there is nothing in the spec claiming that all devices
> >> be powered-on when you boot?

> > I don't believe so, and if there were I'd not expect anyone to pay a
> > blind bit of notice to it.

> That means that the regulators handling the slimbus devices
> will need to be enabled before the drivers issue regulator_get()
> and regulator_enable() on them.

What makes you say that?  We've been discussing how we register Slimbus
devices other than via hotplug.

> Does the regulator constraint .always_on have this semantic
> effect, so the regulator framework can power up the devices
> without their drivers claiming the regulators first?

It does have that effect but it would (as one might expect) force the
regulators to always be on which is unacceptable for actual systems.

> Or would we need a new .boot_enable flag to handle that?

There is such a flag already.

> > If my memory serves (I don't have access to the relevant documents right
> > now) the device announces itself when it detects that the bus is alive.
> > Slimbus is a relatively heavyweight interface so the extra cost of doing
> > this won't be too bad.

> OK so if we can just power the device the bus can probably
> autodetect all devices on it, it seems.

Should be able to, yes, though we'll still need to bind platform/OF data
to them.
