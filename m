Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2BMQog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:44:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56937 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108Ab2BMQof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:44:35 -0500
Date: Mon, 13 Feb 2012 11:44:27 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] omap: board-omap3evm: add required smsc911x regulators
Message-ID: <20120213164424.GD40045@h115-84.vpn.ti.com>
References: <1328738812-26755-1-git-send-email-mporter@ti.com>
 <20120210174046.GQ1426@atomide.com>
 <20120210185033.GC40045@h115-84.vpn.ti.com>
 <20120210225340.GB21865@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120210225340.GB21865@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 02:53:41PM -0800, Tony Lindgren wrote:
> * Matt Porter <mporter@ti.com> [120210 10:19]:
> > On Fri, Feb 10, 2012 at 09:40:47AM -0800, Tony Lindgren wrote:
> > > * Matt Porter <matt@ohporter.com> [120208 13:35]:
> > > > This fixes smsc911x support on omap3evm that has been broken since
> > > > the smsc911x driver was updated to require the existence of vdd33a
> > > > and vddvario supplies.
> > > 
> > > Great. Few comments:
> > > 
> > > 1. Could you please include the smsc911x commit and subject here too
> > >    so it clearly shows the regression?
> > 
> > Sure. Will do for v2.
> > 
> > > 2. Also, why don't you add this fixed regulator to gpmc-smsc911.c?
> > > 
> > > That way it gets fixed for other too, like zoom2/3.
> > 
> > Ok, so I considered that at first and had two concerns that made me just
> > do it in the omap3evm specific way and see what the feedback was.
> > 
> > 1) If we do a generic implementation in gpmc-smsc911x.c, there needs to
> > be a way to override it. Another board may have a variable supply that
> > feeds this consumer.
> > 
> > 2) Technically, this omap3evm specific implementation matches the hardware
> > in that the osk_3v3 rail is software controllable. Granted, I commented
> > that we simply don't hook up the gpio at this time since this real
> > hardware regulator has always been silently asserted on by the nature of
> > the reset state of the TWL GPIOs and the board level pull downs as well.
> 
> OK
>  
> > So that said, I don't need #2 to make omap3evm work and I don't think
> > anybody cares yet to actually turn that regulator off (as it will kill
> > other things that appear to not have regulator support anyway). It looks
> > like you talked me into respinning it as a generic implementation. Only
> > question is whether I should bother consider not-yet-existing boards that
> > may not want that generic regulator.
> 
> Well for future boards the regulator should come from device tree,
> so for now it should be safe to add it to gpmc-smsc911.c.

Ok, sounds good. Posted an updated version.

-Matt
