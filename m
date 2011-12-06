Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab1LFDWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 22:22:14 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:14471
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756489Ab1LFDWN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 22:22:13 -0500
X-SpamScore: -25
X-BigFish: VS-25(zzbb2dK9371K1447M542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>, Dong Aisheng <dongas86@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
Thread-Topic: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
Thread-Index: AQHMsnlB4tyTDOR3uEmPDrmj3tcvppXMPl6AgACwewCAAFYigIAA3e8w
Date: Tue, 6 Dec 2011 03:21:59 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F77234579B@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <1322999384-7886-2-git-send-email-b29396@freescale.com>
 <20111204161123.GS27267@pengutronix.de>
 <CAA+hA=RM77XORR-cUrFSW_rfn=KG9B1gr-Ny0jcDsU1_NiTT7A@mail.gmail.com>
 <20111205075119.GT27267@pengutronix.de>
In-Reply-To: <20111205075119.GT27267@pengutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

Sorry for the late reply.
I took one day leave for my passport processing yesterday.

> -----Original Message-----
> From: Sascha Hauer [mailto:s.hauer@pengutronix.de]
> Sent: Monday, December 05, 2011 3:51 PM
> To: Dong Aisheng
> Cc: Dong Aisheng-B29396; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linus.walleij@stericsson.com; Guo Shawn-
> R65073; kernel@pengutronix.de
> Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
> 
> On Mon, Dec 05, 2011 at 10:43:02AM +0800, Dong Aisheng wrote:
> > Hi Sascha,
> >
> > 2011/12/5 Sascha Hauer <s.hauer@pengutronix.de>:
> > > On Sun, Dec 04, 2011 at 07:49:43PM +0800, Dong Aisheng wrote:
> > >> Signed-off-by: Dong Aisheng <b29396@freescale.com>
> > >> Cc: Linus Walleij <linus.walleij@linaro.org>
> > >> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > >> Cc: Shawn Guo <shanw.guo@freescale.com>
> > >> ---
> > >>  drivers/pinctrl/pinmux-imx53.c |  514
> > >> ++++++++++++++++++++++++++++++++++++++++
> > >>  1 files changed, 514 insertions(+), 0 deletions(-)
> > >>
> > >> diff --git a/drivers/pinctrl/pinmux-imx53.c
> > >> b/drivers/pinctrl/pinmux-imx53.c
> > >> +
> > >> +/* mx53 pin groups and mux mode */ static const unsigned
> > >> +mx53_fec_pins[] = {
> > >> +     MX53_FEC_MDC,
> > >> +     MX53_FEC_MDIO,
> > >> +     MX53_FEC_REF_CLK,
> > >> +     MX53_FEC_RX_ER,
> > >> +     MX53_FEC_CRS_DV,
> > >> +     MX53_FEC_RXD1,
> > >> +     MX53_FEC_RXD0,
> > >> +     MX53_FEC_TX_EN,
> > >> +     MX53_FEC_TXD1,
> > >> +     MX53_FEC_TXD0,
> > >> +};
> > >> +static const unsigned mx53_fec_mux[] = { 0, 0, 0, 0, 0, 0, 0, 0,
> > >> +0, 0 };
> > >
> > > The FEC_MDC could be routed to PAD_KEY_ROW2 or to PAD_FEC_MDC. Also
> > > FEC_MDIO could be routed to either PAD_FEC_MDIO or to PAD_KEY_COL2.
> > > For other fec pins also different options might exist. How does this
> > > fit into this group scheme?
> > >
> > Thanks for the review.
> > Here it's only one group for fec function.
> > If i understood right, for current pinmux desgin, pins are arranged in
> > groups per specifc functions.
> > For the case FEC_MDC could be routed to KEY_ROW2, we need define a KEY
> > group for key function.
> >
> > Currently, i only added one group for one function with the reference
> > of MX53 LOCO pinmux defines.
> > And it's a big work which is in the TODO list that for me to manually
> > add all possible functions and pin groups.
> > So I send out the patch first to see if any design issue for the FSL
> > iomux specialist.
> >
> > >> +
> > >> +static const unsigned mx53_sd1_pins[] = {
> > >> +     MX53_SD1_CMD,
> > >> +     MX53_SD1_CLK,
> > >> +     MX53_SD1_DATA0,
> > >> +     MX53_SD1_DATA1,
> > >> +     MX53_SD1_DATA2,
> > >> +     MX53_SD1_DATA3,
> > >> +
> > >> +};
> > >> +static const unsigned mx53_sd1_mux[] = { 0, 0, 0, 0, 0, 0 };
> > >> +
> > >> +static const unsigned mx53_sd3_pins[] = {
> > >> +     MX53_PATA_DATA8,
> > >> +     MX53_PATA_DATA9,
> > >> +     MX53_PATA_DATA10,
> > >> +     MX53_PATA_DATA11,
> > >> +     MX53_PATA_DATA0,
> > >> +     MX53_PATA_DATA1,
> > >> +     MX53_PATA_DATA2,
> > >> +     MX53_PATA_DATA3,
> > >> +     MX53_PATA_IORDY,
> > >> +     MX53_PATA_RESET_B,
> > >> +
> > >> +};
> > >> +static const unsigned mx53_sd3_mux[] = { 4, 4, 4, 4, 4, 4, 4, 4,
> > >> +2, 2 };
> > >> +
> > >> +static const unsigned mx53_uart1_pins[] = {
> > >> +     MX53_CSI0_DAT10,
> > >> +     MX53_CSI0_DAT11,
> > >> +};
> > >> +static const unsigned mx53_uart1_mux[] = { 2, 2 };
> > >
> > > For uart1 indeed only one routing possibility exists, but look at
> uart2:
> > >
> > > uart2 txd -> PAD_EIM_D26
> > >          -> PAD_PATA_DMARQ
> > >          -> PAD_GPIO_7
> > >
> > > uart2 rxd -> PAD_EIM_D27
> > >          -> PAD_PATA_BUFFER_EN
> > >          -> PAD_GPIO_8
> > >
> > > So this at least means that you should not name the array above
> > > mx53_uart1_mux, but something like mx53_uart1_option1,
> > > mx53_uart1_option2 and so on.
> > >
> > Yes, acked on this.
> > I may take this name option.
> 
> BTW the name _option1 was only meant as an example. mx53_uart2_eim,
> mx53_uart2_pata might make more sense.
> 
I will take account of it.

> >
> > > Then it's probably possible to use mixtures of different options for
> > > the uart.
> > How mixture?
> > Can you describe more or give an example?
> 
> For example a board might have uart2 txd -> PAD_EIM_D26 and uart2 rxd ->
> PAD_PATA_BUFFER_EN. I don't know if this is done somewhere, but it's
> technically possible.
>
Yes, that's possible and I understand it might be a big trouble if we define
the pin groups per soc base per your idea.

> >
> > > I don't think that this grouping of pads to their functions makes
> > > sense. On i.MX every pad is muxed independently and not in groups.
> > > Which pins belong to which function is board specific and not SoC
> > > specific.
> > >
> > Yes, i noted this.
> > As i said above, pins seem to be arranged in groups per functions not
> > per pins itself.
> > So our to do is define all possible pin function and group for board to
> use.
> > But obviously, it's a big work. Especially for your UART2 work, it
> > might be a headache since many possible combination of pins.
> > I still not find the good idea.
> > My current plan is to define all (might be frequently) used functoin
> > and groups for the exist upstreamed board like 53 Loco and etc, is
> > that ok?
> 
> As said, I don't think that it's a good idea to group pins together on a
> per SoC base. I rather think that if we want to go for groups of pins
> belonging to a device, the board has to define those groups, not the SoC.
Acked.

> If you really want to go for SoC specific Pins groups I don't necessarily
> want to see 'everything for LOCO', I rather want to see 'everything for
> uart2', including RTS/CTS, modem control pins (if
> applicable) and an example of using those pins as gpio. Another
> interesting thing is the IPU. While a UART might have three groups
> (rxd+txd, rts+cts, dtr+dcd+dsr) the IPU groups are not so easy to
> identify. We have pins for two displays, each of them might be 8bit,
> 15bit, 18bit or 24bit. There are different sync signals for each display,
> some of them maybe unused on certain setups. The unused pins shouldn't be
> in the groups as you could use them as gpios instead.
Agree.

> By putting the iomux pins in SoC specific groups you try to press the
> hardware into a software design for which it is not designed for. It will
> always be easy to find a case which is not covered by any of the
> predefined groups.
> 
Agree.

I really understand your point for possible issues you mentioned here.
As you said, it may be suitable to define groups of pins in boards file, that
could save us much trouble and could make the things simple.

I want to say that your response is indeed what I need and it is the original
purpose I sent out the patches first for discussion without fully complete it.
Then, we can get a correct way to go.
Thanks for your suggestions.

Regards
Dong Aisheng

