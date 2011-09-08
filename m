Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1IHX7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:59:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55476 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756522Ab1IHX7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:59:09 -0400
Date: Thu, 8 Sep 2011 16:59:04 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linaro-dev@lists.linaro.org,
        linux-omap@vger.kernel.org, Mans Rullgard <mans.rullgard@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform
 drivers
Message-ID: <20110908235903.GA6370@opensource.wolfsonmicro.com>
References: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org>
 <CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com>
 <CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com>
 <3110288.bQbb0H2ME1@wuerfel>
 <1315520956.4126.3.camel@finisterre.wolfsonmicro.main>
 <20110908223720.GA21469@n2100.arm.linux.org.uk>
 <20110908224731.GB5201@opensource.wolfsonmicro.com>
 <20110908230102.GB21469@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908230102.GB21469@n2100.arm.linux.org.uk>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 12:01:02AM +0100, Russell King - ARM Linux wrote:
> On Thu, Sep 08, 2011 at 03:47:31PM -0700, Mark Brown wrote:

> > What will happen for device tree is that there will be a device in the
> > device tree for the ASoC board.

> Sounds like you just solved the machine_is_xxx() problem in ASoC land too
> there.  If you're _already_ going for separate devices to describe the
> ASoC stuff on the board, then there's no reason that couldn't have already
> been done to eliminate the machine_is_xxx() usage in ASoC - rather than
> complaining about machine_is_xxx() not being a very good solution.

The problem is that someone has to manually go and add the device to
every board that needs one and people find that tedious and slightly
inelegant (especially for device tree where not everyone is entirely
happy that it's a good idea to have the node for the board when we
already have the top level machine information saying what board we're
running on).   Jassi's suggestion was that we should have some magic to
automatically generate defaults for the relevant device registrations to
sidestep these issues.
