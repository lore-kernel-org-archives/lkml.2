Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934983Ab1ETOff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:35:35 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:35454 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933843Ab1ETOfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:35:34 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 20 May 2011 22:40:00 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <patches@linaro.org>,
        <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH 2/3] ARM: mxs: add gpio-mxs platform devices
Message-ID: <20110520143959.GC27551@S2100-06.ap.freescale.net>
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org>
 <201105201223.00427.arnd@arndb.de>
 <20110520140316.GA27551@S2100-06.ap.freescale.net>
 <201105201623.40990.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201105201623.40990.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 04:23:40PM +0200, Arnd Bergmann wrote:
> On Friday 20 May 2011 16:03:17 Shawn Guo wrote:
> > On Fri, May 20, 2011 at 12:23:00PM +0200, Arnd Bergmann wrote:
> > > 
> > > I know it's tempting to use macros for these, but I think it obscures
> > > the code a lot, especially when you use them to concatenate identifier
> > > names. Why not just do:
> > > 
> > The pattern is being widely used in mxc/mxs platform device codes.
> > If you are not extremely unhappy about this, I would leave it as it
> > is to keep consistency.
> 
> I think it's a real pain to do it like this, and we need to start
> at some point cleaning up the mess. Why not start now?
> 
OK

> > > > +
> > > > +	return mxs_add_platform_device("mxs-gpio", data->id,
> > > > +					res, ARRAY_SIZE(res), NULL, 0);
> > > > +}
> > > 
> > > mxs_add_platform_device doesn't set the parent pointer correctly, I think you
> > > should either fix that or open-code the platform device creation to do it
> > > right.
> > > 
> > I see the following in drivers/base/platform.c, function
> > platform_device_add():
> > 
> >         if (!pdev->dev.parent)
> >                 pdev->dev.parent = &platform_bus;
> > 
> > So we are fine?
> 
> No, this would put all gpio devices below the top-level /sys/devices/platform
> directory, where they certainly don't belong. Please find a proper
> place and put them there.
> 
Understood.  Will do.

-- 
Regards,
Shawn

