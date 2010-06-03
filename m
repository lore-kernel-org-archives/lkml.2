Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0FCUGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:06:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35790 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0FCUGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:06:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6002"; a="43232543"
Subject: Re: ARM defconfig files
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
In-Reply-To: <20100603195703.GG25779@flint.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	 <20100603181010.GA25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
	 <20100603185333.GD25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
	 <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
	 <20100603194559.GF25779@flint.arm.linux.org.uk>
	 <1275594598.23384.52.camel@c-dwalke-linux.qualcomm.com>
	 <20100603195703.GG25779@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 13:06:48 -0700
Message-ID: <1275595608.23384.58.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 20:57 +0100, Russell King wrote:
> On Thu, Jun 03, 2010 at 12:49:58PM -0700, Daniel Walker wrote:
> > On Thu, 2010-06-03 at 20:45 +0100, Russell King wrote:
> > > On Thu, Jun 03, 2010 at 12:35:42PM -0700, Daniel Walker wrote:
> > > > On Thu, 2010-06-03 at 11:56 -0700, Linus Torvalds wrote:
> > > > > 
> > > > > On Thu, 3 Jun 2010, Russell King wrote:
> > > > > > 
> > > > > > No amount of reorganising the Kconfig files into a heirarchial manner
> > > > > > (which they already are) helps.  Not one bit.  Because they already are.
> > > > > > That's not where the problem is.
> > > > > 
> > > > > I don't think you read the whole thread.
> > > > > 
> > > > > Earlier on, I explained exactly what I wanted: just add some "select" 
> > > > > statements to pickt he things you need per the particular target 
> > > > > configuration. You seem to have missed that part.
> > > > > 
> > > > > In other words, you _can_ encode the information that is in the 
> > > > > xyz_defconfig files by doing it in Kconfig.xyz files instead. But you do 
> > > > > it in a human-readable manner. And the hierarchical thing is absolutely 
> > > > > required for that - otherwise you'd end up with just another form of the 
> > > > > current xyz_defconfig.
> > > > > 
> > > > > See?
> > > > > 
> > > > > In other words, you should be able to basically use "make allnoconfig" 
> > > > > together with a Kconfig.xyz file input to select _exactly_ the pieces you 
> > > > > need, and nothing else.
> > > > 
> > > > If you did this for drivers, what about disabling a driver? If we used
> > > > "select" wouldn't that force all the drivers on without allowing it to
> > > > be unselected?
> > > 
> > > I already covered that in my (ignored) email where I brought up a
> > > "STD_CONFIG" config symbol, which could be disabled to turn off all
> > > these additional "select"s.
> > 
> > I didn't ignore it, I guess I just didn't fully understand it ..
> > 
> > So your saying it would drop all the selects, but keep the selected
> > options in tact? Or it would just turn off all the selected options?
> 
> config MACH_HALIBUT
> 	bool "Halibut Board (QCT SURF7201A)"
> 	select I2C if STD_CONFIG
> 	select I2C_WHATEVER if STD_CONFIG
> 	...
> 
> That means if you enable STD_CONFIG, you'll get everything that's required
> selected.  If you then disable STD_CONFIG, I believe Kconfig leaves
> everything that was selected as still being selected.

I just did a little test, and it doesn't. Kconfig would un-select all
the drivers, at least from my test.

> So, what you _could_ do is start off with a blank configuration, then
> configure a kernel with STD_CONFIG enabled and you end up with everything
> that's required.  If you then want to disable something that's selected,
> turn off STD_CONFIG first, and you'll be able to turn off individual
> options.

If my test was correct we would need a new "select" variant that would
leave the options turned on in order to get something equal to the
current defconfigs.

Daniel


