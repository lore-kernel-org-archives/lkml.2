Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2IQBzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:55:35 -0400
Received: from relais.videotron.ca ([24.201.245.36]:38222 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2IQBzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 21:55:33 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Sun, 16 Sep 2012 21:55:31 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Russell King <linux@arm.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
In-reply-to: <20120916124015.GI5469@titan.lakedaemon.net>
Message-id: <alpine.LFD.2.02.1209162137270.28681@xanadu.home>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-4-git-send-email-sebastian.hesselbarth@gmail.com>
 <20120916074652.GM28177@lunn.ch> <20120916124015.GI5469@titan.lakedaemon.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2012, Jason Cooper wrote:

> On Sun, Sep 16, 2012 at 09:46:52AM +0200, Andrew Lunn wrote:
> > > +++ b/Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt
> > > @@ -0,0 +1,279 @@
> > > +* Marvell Kirkwood SoC pinctrl driver for mpp
> > > +
> > > +Please refer to marvell,mvebu-pinctrl.txt in this directory for common binding
> > > +part and usage.
> > > +
> > > +Required properties:
> > > +- compatible: "marvell,88f6180-pinctrl",
> > > +              "marvell,88f6190-pinctrl", "marvell,88f6192-pinctrl",
> > > +              "marvell,88f6281-pinctrl", "marvell,88f6282-pinctrl"
> > > +
> > > +This driver supports all kirkwood variants, i.e. 88f6180, 88f619x, and 88f628
> > 
> > Hi Sebastian 
> > 
> > The current MPP code determines for itself what chip it is running on.
> > It can then check if a pin configuration is valid for the current
> > run time environment.
> > 
> > Here you are suggesting we have to put into the DT what chip we expect
> > to be on.
> > 
> > What is the advantage of this, over getting the information from the
> > device itself?
> 
> The DT should describe the hardware as accurately as possible.  We can't
> always assume Linux will be the only thing the DT is handed off to.
> 
> > If i wanted to mass convert all existing kirkwood DT boards over to
> > use pinctrl, im stuck at the very first step. I've no idea what chip
> > they use, it was not relevant before.
> 
> Let's try to do the DT correctly, and create a migration path for
> kirkwood to work first, then migrate to using the DT fully.

Beware beware.

The DT should of course describe the hardware as accurately as possible.  
That doesn't necessarily mean it should describe the hardware as 
_extensively_ as possible.

And that doesn't mean that all the information found in the DT has to be 
consumed by the kernel either.

Any information that can be *probed* at run time has no benefit being 
stuffed in a DT.  That's true whether it is Linux or another operating 
system.  The more that can be probed at run time the better.


Nicolas
