Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1IHXBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:01:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35199 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab1IHXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:01:26 -0400
Date: Fri, 9 Sep 2011 00:01:02 +0100
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
Message-ID: <20110908230102.GB21469@n2100.arm.linux.org.uk>
References: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org> <CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com> <CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com> <3110288.bQbb0H2ME1@wuerfel> <1315520956.4126.3.camel@finisterre.wolfsonmicro.main> <20110908223720.GA21469@n2100.arm.linux.org.uk> <20110908224731.GB5201@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908224731.GB5201@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 03:47:31PM -0700, Mark Brown wrote:
> On Thu, Sep 08, 2011 at 11:37:20PM +0100, Russell King - ARM Linux wrote:
> 
> > With DT of course, all devices get instantiated from the device tree,
> > so there should not be any more platform specific chunks of code in
> > these locations (ha, it couldn't be solved with platform data so I
> > suspect it will continue to persist, forever unsolved.)
> 
> That's not the case at all for audio, the PCB schematic for the audio
> subsystem on a device like a smartphone is a sufficiently interesting
> piece of hardware to be a device with a driver in its own right.  The
> ASoC machine drivers aren't about instantiating devices, they are about
> controlling the interrelationships between the various devices in the
> audio subsystem.
> 
> What will happen for device tree is that there will be a device in the
> device tree for the ASoC board.

Sounds like you just solved the machine_is_xxx() problem in ASoC land too
there.  If you're _already_ going for separate devices to describe the
ASoC stuff on the board, then there's no reason that couldn't have already
been done to eliminate the machine_is_xxx() usage in ASoC - rather than
complaining about machine_is_xxx() not being a very good solution.

As I said, the problem was solved years ago, and all the component parts
have been there also for years.
