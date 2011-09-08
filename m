Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab1IHWhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 18:37:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54367 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1IHWhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 18:37:53 -0400
Date: Thu, 8 Sep 2011 23:37:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linaro-dev@lists.linaro.org,
        linux-omap@vger.kernel.org, Mans Rullgard <mans.rullgard@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform
	drivers
Message-ID: <20110908223720.GA21469@n2100.arm.linux.org.uk>
References: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org> <CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com> <CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com> <3110288.bQbb0H2ME1@wuerfel> <1315520956.4126.3.camel@finisterre.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315520956.4126.3.camel@finisterre.wolfsonmicro.main>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 03:29:11PM -0700, Mark Brown wrote:
> On Thu, 2011-09-08 at 22:28 +0200, Arnd Bergmann wrote:
> > On Thursday 08 September 2011 20:05:48 Mans Rullgard wrote:
> 
> > > I had the same thought, but I couldn't find a suitable string anywhere.
> > > Are you suggesting an if(machine_is_foo()) cascade in omap_init_audio()?
> 
> > > I'll be the first to agree this patch is not particularly pretty.
> 
> > My general feeling is that practically every time someone writes
> > machine_is_*(), they are doing it wrong. There are of course exceptions,
> > but I would strongly recommend to have the initialization calling up
> > from the board file into more general functions instead of having all
> > boards calling the same function which then goes to board specific
> > code again.
> 
> I have to agree, that seems tasteless. I'd expect something like
> triggering registration of devices based off walking down a table of
> machine IDs or something. One other issue to consider here is that we
> don't want to discourage people from sharing machine drivers while we
> can so it can't be completely automatic, it 

This problem has been solved (before DT) for _ages_ through the use
of platform devices in the platform support files, registered by the
.init_machine callback.

Where it went wrong is when ASOC and PCMCIA became rather complicated
that you could no longer just pass a platform data structure, but
instead needed some complex platform specific code - which started the
demand to have mini platform specific chunks of code in drivers/pcmcia/
and sound/.

With DT of course, all devices get instantiated from the device tree,
so there should not be any more platform specific chunks of code in
these locations (ha, it couldn't be solved with platform data so I
suspect it will continue to persist, forever unsolved.)
