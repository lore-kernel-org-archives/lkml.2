Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab2ILMtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:49:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57242 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757887Ab2ILMtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:49:41 -0400
Date: Wed, 12 Sep 2012 20:49:34 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: Add DA9055 codec driver
Message-ID: <20120912124932.GC19055@opensource.wolfsonmicro.com>
References: <1347375823.12329.14.camel@matrix>
 <20120912025709.GD9162@opensource.wolfsonmicro.com>
 <1347454578.23366.305.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347454578.23366.305.camel@matrix>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 06:26:18PM +0530, Ashish Chavan wrote:
> On Wed, 2012-09-12 at 10:57 +0800, Mark Brown wrote:

> > Why is any of this being exposed to userspace?  If this should be
> > configured I'd expect it to be static platform data, not something that
> > gets changed at runtime.

> These parameters are exposed considering the fact that DMIC itself is
> not part of the codec. Codec only provides DMIC interface using which an
> external DMIC can be attached. These parameters depend on the actual
> DMIC hardware and hence kept configurable to allow runtime plug in of
> any DMIC hardware. Doesn't it make sense to keep them runtime
> configurable?

No.  The only realistic way to attach a new DMIC to a board is to solder
it down, that's not something people are going to do while the system is
actve.  It's something that's fixed at PCB design time.

> > > +	/* In slave mode, there is only one set of divisors */
> > > +	if (!da9055->master)
> > > +		fout = 2822400;

> > Should check the user supplied this value

> Can you explain which value / user supplied value you are referring to?
> It is not quite clear to me.

The specified output frequency, you just totally ignore it.

> For other things like input mixers, Headphone and Lineouts, DAPM is
> already used to control power specific bits. The confusion is because
> there are two separate control bits for these blocks. One bit is for
> "Enabling" that block and other is for "Enabling Amplifier" of that
> block.
> e.g for headphone, one bit is for "output enable" while other is for
> "output amplifier enable".

So document this.
