Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1HPPXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:23:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33575 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751559Ab1HPPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:23:45 -0400
Date: Wed, 17 Aug 2011 00:23:34 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110816152333.GB15484@opensource.wolfsonmicro.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
 <201108111455.56319.arnd@arndb.de>
 <20110812164608.GC28150@sirena.org.uk>
 <201108161537.28612.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108161537.28612.arnd@arndb.de>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 03:37:28PM +0200, Arnd Bergmann wrote:
> On Friday 12 August 2011, Mark Brown wrote:

> > > I don't think this should be exported: AFAICT, the set of slim_devices
> > > is a property of the platform, so I don't see how any other device driver
> > > would add another device.

> > The platform may be comprised of multiple hardwaare modules with
> > functionality on daughtercards which can be probed at runtime.  You may
> > also find someone constructing a PCI card or something with a slimbus
> > controller on it at some point.

> This is theoretically true, but IIRC David mentioned that the bus is
> only present on few SoCs and has since been abandoned in favor of standard
> busses for new devices.

No, that's not the case at all - I'm not sure what gave you that
impression.  This is new technology which is rolling out at the minute.
It is a standard bus.

> > It seems a bit extreme to prevent anyone implementing a subsystem for
> > their platform until they've converted it into device tree.  Though with
> > slimbus it should be at least somewhat probeable IIRC?

> From what I've heard (and seen in the code), there is no support for
> probing, just like in I2C.

That's what the code does, yes.  I'd need to recheck the spec but I do
seem to recall some device IDs in there.

> The platform is in the process of getting converted to device tree
> already, the first patches were posted on Saturday. I don't know what
> the timeline is for this, or how many board with slimbus are supported
> in mainline or still waiting to get merged, but my guess is that the
> bulk is still out of tree. If that's true, it's definitely cleaner to
> convert it over to device tree before merging, instead of having to
> change all the board files again when doing the conversion.

That's one platform, this is not at all constructive for other devices
(or worse, architectures) implementing slimbus support.  Insisting that
new ARM platforms use device tree is one thing, insisting that new bus
implementations only work with device tree is quite a different thing.
