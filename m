Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1LFGpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:45:49 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:21343
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747Ab1LFGps convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:45:48 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 6 Dec 2011 14:58:26 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
Message-ID: <20111206065825.GB3649@S2100-06.ap.freescale.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <1322999384-7886-2-git-send-email-b29396@freescale.com>
 <CACRpkdaYz+-nZA6atxA+5kvWOO84YeSHQPNiojq_R4zkHUGz3Q@mail.gmail.com>
 <20111205211838.GG27267@pengutronix.de>
 <65EE16ACC360FA4D99C96DC085B3F7723458DA@039-SN1MPN1-002.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <65EE16ACC360FA4D99C96DC085B3F7723458DA@039-SN1MPN1-002.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 01:54:35PM +0800, Dong Aisheng-B29396 wrote:
> > -----Original Message-----
> > From: Sascha Hauer [mailto:s.hauer@pengutronix.de]
> > Sent: Tuesday, December 06, 2011 5:19 AM
> > To: Linus Walleij
> > Cc: Dong Aisheng-B29396; linux-kernel@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; linus.walleij@stericsson.com; Guo Shawn-
> > R65073; kernel@pengutronix.de
> > Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
> > 
> > On Mon, Dec 05, 2011 at 05:57:42PM +0100, Linus Walleij wrote:
> > > On Sun, Dec 4, 2011 at 12:49 PM, Dong Aisheng <b29396@freescale.com>
> > wrote:
> > >
> > > > +enum imx_mx53_pads {
> > > > +       MX53_GPIO_19 = 0,
> > > > +       MX53_KEY_COL0 = 1,
> > > (...)
> > >
> > > First I thought it looked a bit strange since you needed enums for all
> > > pads but then I realized that your macros use the same enumerator name
> > > to name the pad and then it looks sort of clever.
> > >
> > > But maybe put in a comment about that here:
> > >
> > > > +/* Pad names for the pinmux subsystem */
> > >
> > > Like this:
> > >
> > > /*
> > >  * Pad names for the pinmux subsystem.
> > >  * These pad names are constructed from the pin enumerator names
> > >  * in the IMX_PINCTRL_PIN() macro.
> > >  */
> > >
> > > > +static const struct pinctrl_pin_desc mx53_pads[] = {
> > > > +       IMX_PINCTRL_PIN(MX53_GPIO_19),
> > > > +       IMX_PINCTRL_PIN(MX53_KEY_COL0),
> > > (...)
> > >
> > > > +/* mx53 pin groups and mux mode */
> > > > +static const unsigned mx53_fec_pins[] = {
> > > > +       MX53_FEC_MDC,
> > > > +       MX53_FEC_MDIO,
> > > > +       MX53_FEC_REF_CLK,
> > > > +       MX53_FEC_RX_ER,
> > > > +       MX53_FEC_CRS_DV,
> > > > +       MX53_FEC_RXD1,
> > > > +       MX53_FEC_RXD0,
> > > > +       MX53_FEC_TX_EN,
> > > > +       MX53_FEC_TXD1,
> > > > +       MX53_FEC_TXD0,
> > > > +};
> > >
> > > I understand this.
> > >
> > > > +static const unsigned mx53_fec_mux[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0,
> > > > +0 };
> > >
> > > But what is this? Just zeroes? Why?
> > > Especially with a const so they really cannot be anything else. The
> > > same pin (0) can only be enumerated once.
> > >
> > > > +static const unsigned mx53_sd1_pins[] = {
> > > > +       MX53_SD1_CMD,
> > > > +       MX53_SD1_CLK,
> > > > +       MX53_SD1_DATA0,
> > > > +       MX53_SD1_DATA1,
> > > > +       MX53_SD1_DATA2,
> > > > +       MX53_SD1_DATA3,
> > > > +
> > > > +};
> > > > +static const unsigned mx53_sd1_mux[] = { 0, 0, 0, 0, 0, 0 };
> > >
> > > And here again.
> > >
> > > > +static const unsigned mx53_sd3_pins[] = {
> > > > +       MX53_PATA_DATA8,
> > > > +       MX53_PATA_DATA9,
> > > > +       MX53_PATA_DATA10,
> > > > +       MX53_PATA_DATA11,
> > > > +       MX53_PATA_DATA0,
> > > > +       MX53_PATA_DATA1,
> > > > +       MX53_PATA_DATA2,
> > > > +       MX53_PATA_DATA3,
> > > > +       MX53_PATA_IORDY,
> > > > +       MX53_PATA_RESET_B,
> > > > +
> > > > +};
> > > > +static const unsigned mx53_sd3_mux[] = { 4, 4, 4, 4, 4, 4, 4, 4, 2,
> > > > +2 };
> > >
> > > This also looks strange. Can you explain what these muxes are?
> > 
> > Freescale has named the pins after their primary function which is quite
> > confusing.
> > 
> > The above means:
> > 
> > MX53_PATA_DATA8 -> mux mode 4
> > MX53_PATA_DATA9 -> mux mode 4
> > ...
> > 
> > This brings me to the point that currently we have the pins described as
> > 
> > #define MX53_PAD_<name>__<function>
> > 
> > which means that you don't have to look into the datasheet to get the
> > different options for a pin (and don't have a chance to get it wrong).
> > I don't really want to lose this.
> > 
> Obviously current used pin defines in that way is pretty good.
> And I also don't want to lose this.
> 
> Actually I also have tried to see if we can reuse the current iomux-v3 code.
> 
> For current pinmux driver, one approach I can see is that define mux
> in enum for each pin like:
> 
> enum MX53_PAD_GPIO_19_MUX {
>         MX53_PAD_GPIO_19__KPP_COL_5,
>         MX53_PAD_GPIO_19__GPIO4_5,
>         MX53_PAD_GPIO_19__CCM_CLKO,
>         MX53_PAD_GPIO_19__SPDIF_OUT1,
>         MX53_PAD_GPIO_19__RTC_CE_RTC_EXT_TRIG2,
>         MX53_PAD_GPIO_19__ECSPI1_RDY,
>         MX53_PAD_GPIO_19__FEC_TDATA_3,
>         MX53_PAD_GPIO_19__SRC_INT_BOOT,
> };

I would say, no, do not do that, because it simply does not worth.
Most of the definitions will probably never be used.

IMO, we can just focus on the support for device tree case (imx6) for
now.  With proper DT binding for pinctrl settled, all these data can
go into DT.  For those non-DT cases, we may want to leave them as they
are for now.

Regards,
Shawn

> Then put them in a common file for each mx53 based board to use.
> 
> Take uart1 as an example, it could be:
> static const unsigned mx53_uart1_pins[] = {
>         MX53_CSI0_DAT10,
>         MX53_CSI0_DAT11,
> };
> 
> static const unsigned mx53_uart1_mux[] = {
>         MX53_CSI0_DAT10__UART1_TXD_MUX,
>         MX53_CSI0_DAT11__UART1_RXD_MUX
> };
> 
> static const struct imx_pin_group mx53_pin_groups[] = {
>         IMX_PIN_GROUP("uart1grp", mx53_uart1_pins, mx53_uart1_mux),
> };
> 
> The benefit is that it's very clear and good maintainable.
> The defect is it will increase the code size a lot by defining all
> pin's mux enum and each pin's mux array in board file.
> 
> Do you think if it's ok or you have any better idea?
> 
> Regards
> Dong Aisheng

