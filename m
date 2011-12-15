Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab1LOLNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 06:13:10 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:27178
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755662Ab1LOLNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 06:13:08 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371I168aJ542M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Thu, 15 Dec 2011 19:21:45 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Message-ID: <20111215112140.GA10522@S2101-09.ap.freescale.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
 <1323878622-26602-5-git-send-email-b29396@freescale.com>
 <20111214211152.GM27267@pengutronix.de>
 <CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
 <20111215070505.GA22541@S2101-09.ap.freescale.net>
 <CACRpkdbN26q1_d4tPkJp4f4_KdvoEEk9uCCRyOfEU97DOWAnEw@mail.gmail.com>
 <7FE21149F4667147B645348EC60578850564C5@039-SN2MPN1-013.039d.mgd.msft.net>
 <20111215093319.GO27267@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111215093319.GO27267@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 10:33:19AM +0100, Sascha Hauer wrote:
> On Thu, Dec 15, 2011 at 08:59:28AM +0000, Dong Aisheng-B29396 wrote:
> > > -----Original Message-----
> > > From: Linus Walleij [mailto:linus.walleij@linaro.org]
> > > Sent: Thursday, December 15, 2011 4:27 PM
> > > To: Guo Shawn-R65073
> > > Cc: Sascha Hauer; Dong Aisheng-B29396; linus.walleij@stericsson.com;
> > > linux-kernel@vger.kernel.org; rob.herring@calxeda.com;
> > > grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
> > > kernel@pengutronix.de
> > > Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux
> > > subsystem
> > > Importance: High
> > > 
> > > On Thu, Dec 15, 2011 at 8:05 AM, Shawn Guo <shawn.guo@freescale.com>
> > > wrote:
> > > >[Me]
> > > >> So if you want to do this for i.MX you need something like selectable
> > > >> dummy pinmuxes, i.e. pinmux_get() to return something that just say
> > > >> "OK" to everything like the dummy regulators.
> > > >>
> > > >> Shall I try to create something like that?
> > > >>
> > > > Isn't the empty functions defined in include/linux/pinctrl/pinmux.h
> > > > for this purpose?
> > > 
> > > No, these are for compiling it *out*, dummy pinmuxes would be if you
> > > compile it *in*, but don't find an apropriate pinmux, you still get
> > > something that does nothing and still works.
> > > 
> > > Dummy regulators work exactly this way.
> > > 
> > 
> > I did not read the dummy regulator code too much.
> > But does it mean that the dummy regulator or dummy pinmux will also hide the
> > Real errors since it will always get a available one?

What do you mean 'real error'?  When driver calls pimnux api on a
platform with real pinmux support, the error is error.  When driver
calls pinmux api on a platform support with dummy pinmux, it's totally
error free, as the pinmux core will ensure all the pinmux_* calls
always return success.

> > How do we distinguish between the two case(real error and fake error)?
> 
What do we need to distinguish between two cases?  The real success for
real pinmux from the fake success for the dummy pinmux?  It does not
really matter.

> We don't :(
> 
> That's the problem with the dummy regulator.
> 
What is the problem exactly?  I do not quite understand.

-- 
Regards,
Shawn

