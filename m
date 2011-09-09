Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab1IITCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 15:02:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49699 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759516Ab1IITCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 15:02:08 -0400
Date: Fri, 9 Sep 2011 20:01:35 +0100
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
Message-ID: <20110909190134.GA14520@n2100.arm.linux.org.uk>
References: <CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com> <CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com> <3110288.bQbb0H2ME1@wuerfel> <1315520956.4126.3.camel@finisterre.wolfsonmicro.main> <20110908223720.GA21469@n2100.arm.linux.org.uk> <20110908224731.GB5201@opensource.wolfsonmicro.com> <20110908230102.GB21469@n2100.arm.linux.org.uk> <20110908235903.GA6370@opensource.wolfsonmicro.com> <20110909094156.GE6918@n2100.arm.linux.org.uk> <20110909161151.GA3515@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909161151.GA3515@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 09:11:52AM -0700, Mark Brown wrote:
> On Fri, Sep 09, 2011 at 10:41:56AM +0100, Russell King - ARM Linux wrote:
> > On Thu, Sep 08, 2011 at 04:59:04PM -0700, Mark Brown wrote:
> 
> > > The problem is that someone has to manually go and add the device to
> > > every board that needs one and people find that tedious and slightly
> > > inelegant
> 
> > Sheesh.  So now you're arguing against your statement above?  Please
> > stop wasting my time.
> 
> There's two things going on here - what we are doing and what people
> would like to be able to do.  What we are doing is explicitly adding
> devices, what people would like to do is infer the devices from the
> board type.  Personally I'm totally happy with explicitly adding an
> audio device, but not everyone is and I do understand where they're
> coming from.

Well, with DT, there won't be any 'board type' anymore.  There won't be
any 'machine_is_xxx()' to sort it out anymore.  Using DT, all that will
be history - it's all got to be sorted out by either devices or device
properties.

So, given that, I don't see the logic of having two methods - it might
as well be dealt with by devices and [platform data for non-DT | DT
properties], and which then means we have everything working the same
way irrespective of what the backing data for the platform actually is.

Therefore, as we are heading for DT, I'd definitely say that having
machine_is_xxx() outside of arch/arm is a bug, no less and no more.
