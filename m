Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab1LOI7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:59:34 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:18286
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab1LOI7d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:59:33 -0500
X-SpamScore: -19
X-BigFish: VS-19(zz9371I542M1432N98dK4015Lzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Guo Shawn-R65073 <r65073@freescale.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Thread-Topic: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Thread-Index: AQHMunirzWtXRBa0wUCO2ofliTlfR5XcOaMAgAAR44CAAJPfAIAAFsgA//+jpfA=
Date: Thu, 15 Dec 2011 08:59:28 +0000
Message-ID: <7FE21149F4667147B645348EC60578850564C5@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
	<1323878622-26602-5-git-send-email-b29396@freescale.com>
	<20111214211152.GM27267@pengutronix.de>
	<CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
	<20111215070505.GA22541@S2101-09.ap.freescale.net>
 <CACRpkdbN26q1_d4tPkJp4f4_KdvoEEk9uCCRyOfEU97DOWAnEw@mail.gmail.com>
In-Reply-To: <CACRpkdbN26q1_d4tPkJp4f4_KdvoEEk9uCCRyOfEU97DOWAnEw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: Thursday, December 15, 2011 4:27 PM
> To: Guo Shawn-R65073
> Cc: Sascha Hauer; Dong Aisheng-B29396; linus.walleij@stericsson.com;
> linux-kernel@vger.kernel.org; rob.herring@calxeda.com;
> grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de
> Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux
> subsystem
> Importance: High
> 
> On Thu, Dec 15, 2011 at 8:05 AM, Shawn Guo <shawn.guo@freescale.com>
> wrote:
> >[Me]
> >> So if you want to do this for i.MX you need something like selectable
> >> dummy pinmuxes, i.e. pinmux_get() to return something that just say
> >> "OK" to everything like the dummy regulators.
> >>
> >> Shall I try to create something like that?
> >>
> > Isn't the empty functions defined in include/linux/pinctrl/pinmux.h
> > for this purpose?
> 
> No, these are for compiling it *out*, dummy pinmuxes would be if you
> compile it *in*, but don't find an apropriate pinmux, you still get
> something that does nothing and still works.
> 
> Dummy regulators work exactly this way.
> 

I did not read the dummy regulator code too much.
But does it mean that the dummy regulator or dummy pinmux will also hide the
Real errors since it will always get a available one?
How do we distinguish between the two case(real error and fake error)?

> > It does not solve the problem with single image.
> 
> I think it does.
> 
> > You might probably mean that we create a dummy_pinctrl_desc and
> > register it to pinctrl core with pinctrl_register() if we detect that
> > the kernel is running on a soc that has no pinctrl support?
> 
> No. You have a #ifdef CONFIG_PINMUX_DUMMY in pinmux_get() that makes sure
> you return a working no-op pinmux handle even though there is no real
> pinmux behind it.
> 
> > This is not a problem to pinctrl migration only.  We have the same
> > problem with common clk migration.  Unless we migrate imx3, imx5 and
> > imx6 to common clk at the same time, single image build just does not
> > cope with clk_* api.
> 
> And  you could have the same problem with regulator migration...
> Luckily dummy regulators saves you in that case.
> 
> Thanks,
> Linus Walleij


