Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1LFGM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:12:28 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:40855
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743Ab1LFGM1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:12:27 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 6 Dec 2011 14:25:01 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Dong Aisheng <b29396@freescale.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <kernel@pengutronix.de>
Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
Message-ID: <20111206062500.GA3649@S2100-06.ap.freescale.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <1322999384-7886-2-git-send-email-b29396@freescale.com>
 <CACRpkdaYz+-nZA6atxA+5kvWOO84YeSHQPNiojq_R4zkHUGz3Q@mail.gmail.com>
 <20111205211838.GG27267@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20111205211838.GG27267@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 10:18:38PM +0100, Sascha Hauer wrote:
> On Mon, Dec 05, 2011 at 05:57:42PM +0100, Linus Walleij wrote:
> > On Sun, Dec 4, 2011 at 12:49 PM, Dong Aisheng <b29396@freescale.com> wrote:
> > 
> > > +enum imx_mx53_pads {
> > > +       MX53_GPIO_19 = 0,
> > > +       MX53_KEY_COL0 = 1,
> > (...)
> > 
> > First I thought it looked a bit strange since you needed enums for all pads
> > but then I realized that your macros use the same enumerator name to
> > name the pad and then it looks sort of clever.
> > 
> > But maybe put in a comment about that here:
> > 
> > > +/* Pad names for the pinmux subsystem */
> > 
> > Like this:
> > 
> > /*
> >  * Pad names for the pinmux subsystem.
> >  * These pad names are constructed from the pin enumerator names
> >  * in the IMX_PINCTRL_PIN() macro.
> >  */
> > 
> > > +static const struct pinctrl_pin_desc mx53_pads[] = {
> > > +       IMX_PINCTRL_PIN(MX53_GPIO_19),
> > > +       IMX_PINCTRL_PIN(MX53_KEY_COL0),
> > (...)
> > 
> > > +/* mx53 pin groups and mux mode */
> > > +static const unsigned mx53_fec_pins[] = {
> > > +       MX53_FEC_MDC,
> > > +       MX53_FEC_MDIO,
> > > +       MX53_FEC_REF_CLK,
> > > +       MX53_FEC_RX_ER,
> > > +       MX53_FEC_CRS_DV,
> > > +       MX53_FEC_RXD1,
> > > +       MX53_FEC_RXD0,
> > > +       MX53_FEC_TX_EN,
> > > +       MX53_FEC_TXD1,
> > > +       MX53_FEC_TXD0,
> > > +};
> > 
> > I understand this.
> > 
> > > +static const unsigned mx53_fec_mux[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
> > 
> > But what is this? Just zeroes? Why?
> > Especially with a const so they really cannot be anything
> > else. The same pin (0) can only be enumerated once.
> > 
> > > +static const unsigned mx53_sd1_pins[] = {
> > > +       MX53_SD1_CMD,
> > > +       MX53_SD1_CLK,
> > > +       MX53_SD1_DATA0,
> > > +       MX53_SD1_DATA1,
> > > +       MX53_SD1_DATA2,
> > > +       MX53_SD1_DATA3,
> > > +
> > > +};
> > > +static const unsigned mx53_sd1_mux[] = { 0, 0, 0, 0, 0, 0 };
> > 
> > And here again.
> > 
> > > +static const unsigned mx53_sd3_pins[] = {
> > > +       MX53_PATA_DATA8,
> > > +       MX53_PATA_DATA9,
> > > +       MX53_PATA_DATA10,
> > > +       MX53_PATA_DATA11,
> > > +       MX53_PATA_DATA0,
> > > +       MX53_PATA_DATA1,
> > > +       MX53_PATA_DATA2,
> > > +       MX53_PATA_DATA3,
> > > +       MX53_PATA_IORDY,
> > > +       MX53_PATA_RESET_B,
> > > +
> > > +};
> > > +static const unsigned mx53_sd3_mux[] = { 4, 4, 4, 4, 4, 4, 4, 4, 2, 2 };
> > 
> > This also looks strange. Can you explain what these muxes are?
> 
> Freescale has named the pins after their primary function which is quite
> confusing.
> 
> The above means:
> 
> MX53_PATA_DATA8 -> mux mode 4
> MX53_PATA_DATA9 -> mux mode 4
> ...
> 
> This brings me to the point that currently we have the pins described as
> 
> #define MX53_PAD_<name>__<function>
> 
But that's also the reason why we have so many lengthy iomux-mx*.h on
imx.  Taking iomux-mx53.h for example, it's a 109K header with 1219
LOC, but probably only 10% of the definitions will actually be used.

> which means that you don't have to look into the datasheet to get the
> different options for a pin

Looking at the datasheet when we write code is a pretty natural thing
to me.

-- 
Regards,
Shawn

> (and don't have a chance to get it wrong).
> I don't really want to lose this.
> 

