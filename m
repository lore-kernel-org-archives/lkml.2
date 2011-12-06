Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab1LFHsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:48:08 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:34814
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932947Ab1LFHsG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:48:06 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Tue, 6 Dec 2011 16:00:06 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Sascha Hauer <s.hauer@pengutronix.de>, <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        Dong Aisheng <b29396@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
Message-ID: <20111206080005.GA3864@S2100-06.ap.freescale.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <1322999384-7886-2-git-send-email-b29396@freescale.com>
 <CACRpkdaYz+-nZA6atxA+5kvWOO84YeSHQPNiojq_R4zkHUGz3Q@mail.gmail.com>
 <20111205211838.GG27267@pengutronix.de>
 <20111206062500.GA3649@S2100-06.ap.freescale.net>
 <20189.50504.375779.311903@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20189.50504.375779.311903@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 08:33:28AM +0100, Lothar Waßmann wrote:
> Hi,
> 
> Shawn Guo writes:
> > On Mon, Dec 05, 2011 at 10:18:38PM +0100, Sascha Hauer wrote:
> > > Freescale has named the pins after their primary function which is quite
> > > confusing.
> > > 
> > > The above means:
> > > 
> > > MX53_PATA_DATA8 -> mux mode 4
> > > MX53_PATA_DATA9 -> mux mode 4
> > > ...
> > > 
> > > This brings me to the point that currently we have the pins described as
> > > 
> > > #define MX53_PAD_<name>__<function>
> > > 
> > But that's also the reason why we have so many lengthy iomux-mx*.h on
> > imx.  Taking iomux-mx53.h for example, it's a 109K header with 1219
> > LOC, but probably only 10% of the definitions will actually be used.
> > 
> Which has the benefit of having correct pin definitions for everyone
> to use. If developers who need to use currently unused pindefs have to
> create them on their own, there will always be a good chance in
> getting them wrong.

If the configuration is not working, they will notice it's wrong anyway.

> 
> > > which means that you don't have to look into the datasheet to get the
> > > different options for a pin
> > 
> > Looking at the datasheet when we write code is a pretty natural thing
> > to me.
> > 
> The pindefs are like interrupt numbers or IO addresses for which there
> also is a complete list of definitions in the kernel no matter whether
> they are actually all in use.
> 
The interrupt list is much shorter than iomux list here, which enumerate
every single function for every single pad.  Also, most interrupts stand
a pretty good chance to be used, while most of the pad functions do not.

-- 
Regards,
Shawn

