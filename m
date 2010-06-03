Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab0FCWYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 18:24:10 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13007 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab0FCWYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 18:24:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6002"; a="43244685"
Subject: Re: ARM defconfig files
From: Daniel Walker <dwalker@codeaurora.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
In-Reply-To: <20100603211707.GA6499@atomide.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	 <20100603181010.GA25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
	 <20100603185333.GD25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
	 <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
	 <20100603194559.GF25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
	 <20100603211707.GA6499@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 15:24:04 -0700
Message-ID: <1275603844.23384.240.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 00:17 +0300, Tony Lindgren wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> [100603 23:30]:
> > 
> > and now you'd be able to basically generate a OMAP3EVM .config file by 
> > just running "allnoconfig" on that Kconfig.omap3_evm file. But it would 
> > only have to select the parts that are specific for the EVM platform, 
> > because the generic OMAP3 support would be picked by the Kconfig.omap3 
> > file, which in turn would not have to worry about the generic ARM parts 
> > etc.
> > 
> > See?
> 
> Sounds like a good improvment to me.

I was looking at this new defconfig added this merge window,
omap3_stalker_lks_defconig ..

diff -u arch/arm/configs/omap3_defconfig arch/arm/configs/omap3_stalker_lks_defconfig | diffstat
 omap3_stalker_lks_defconfig |  850 +++++++-------------------------------------
 1 file changed, 140 insertions(+), 710 deletions(-)

There's a lot of stuff that's different in there .. If I look through
it, there's stuff that's not related to OMAP , or even drivers. Like
Kprobes gets disabled over omap3_defconfig .

To me that's kind of messy .. It should really be just what the user
absolutely needs. I think we're able to get away with that now cause no
one cares enough to really read the defconfig and see what's going on.

Having stuff like that adds more flux.

Whatever scheme we go to would likely change that and people would
actually read what's going on. So we wouldn't be able to randomly have
Kprobes enabled in one config, and not enabled in another one. Or having
a debug config as one, then having a performance config for another.

Daniel



