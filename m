Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab1LOL2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 06:28:31 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:56070
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758726Ab1LOL23 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 06:28:29 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371I168aJ542M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Guo Shawn-R65073 <r65073@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Thread-Topic: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Thread-Index: AQHMunirzWtXRBa0wUCO2ofliTlfR5XcOaMAgAAR44CAAJPfAIAAFsgA//+jpfCAAG76gIAAHkyA//+Zx9A=
Date: Thu, 15 Dec 2011 11:28:18 +0000
Message-ID: <7FE21149F4667147B645348EC60578850567C3@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
 <1323878622-26602-5-git-send-email-b29396@freescale.com>
 <20111214211152.GM27267@pengutronix.de>
 <CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
 <20111215070505.GA22541@S2101-09.ap.freescale.net>
 <CACRpkdbN26q1_d4tPkJp4f4_KdvoEEk9uCCRyOfEU97DOWAnEw@mail.gmail.com>
 <7FE21149F4667147B645348EC60578850564C5@039-SN2MPN1-013.039d.mgd.msft.net>
 <20111215093319.GO27267@pengutronix.de>
 <20111215112140.GA10522@S2101-09.ap.freescale.net>
In-Reply-To: <20111215112140.GA10522@S2101-09.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Guo Shawn-R65073
> Sent: Thursday, December 15, 2011 7:22 PM
> To: Sascha Hauer
> Cc: Dong Aisheng-B29396; Linus Walleij; Guo Shawn-R65073;
> linus.walleij@stericsson.com; linux-kernel@vger.kernel.org;
> rob.herring@calxeda.com; grant.likely@secretlab.ca; linux-arm-
> kernel@lists.infradead.org; kernel@pengutronix.de
> Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux
> subsystem
> Importance: High
> 
> On Thu, Dec 15, 2011 at 10:33:19AM +0100, Sascha Hauer wrote:
> > On Thu, Dec 15, 2011 at 08:59:28AM +0000, Dong Aisheng-B29396 wrote:
> > > > -----Original Message-----
> > > > From: Linus Walleij [mailto:linus.walleij@linaro.org]
> > > > Sent: Thursday, December 15, 2011 4:27 PM
> > > > To: Guo Shawn-R65073
> > > > Cc: Sascha Hauer; Dong Aisheng-B29396;
> > > > linus.walleij@stericsson.com; linux-kernel@vger.kernel.org;
> > > > rob.herring@calxeda.com; grant.likely@secretlab.ca;
> > > > linux-arm-kernel@lists.infradead.org;
> > > > kernel@pengutronix.de
> > > > Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux
> > > > subsystem
> > > > Importance: High
> > > >
> > > > On Thu, Dec 15, 2011 at 8:05 AM, Shawn Guo
> > > > <shawn.guo@freescale.com>
> > > > wrote:
> > > > >[Me]
> > > > >> So if you want to do this for i.MX you need something like
> > > > >> selectable dummy pinmuxes, i.e. pinmux_get() to return
> > > > >> something that just say "OK" to everything like the dummy
> regulators.
> > > > >>
> > > > >> Shall I try to create something like that?
> > > > >>
> > > > > Isn't the empty functions defined in
> > > > > include/linux/pinctrl/pinmux.h for this purpose?
> > > >
> > > > No, these are for compiling it *out*, dummy pinmuxes would be if
> > > > you compile it *in*, but don't find an apropriate pinmux, you
> > > > still get something that does nothing and still works.
> > > >
> > > > Dummy regulators work exactly this way.
> > > >
> > >
> > > I did not read the dummy regulator code too much.
> > > But does it mean that the dummy regulator or dummy pinmux will also
> > > hide the Real errors since it will always get a available one?
> 
> What do you mean 'real error'?  When driver calls pimnux api on a
> platform with real pinmux support, the error is error.  When driver calls
> pinmux api on a platform support with dummy pinmux, it's totally error
> free, as the pinmux core will ensure all the pinmux_* calls always return
> success.
> 
My understanding is that pinmux_get will return an error if no proper pinmux
Found without dummy pinmux. That's a real error.
But with dummy pinmux, if no proper pinmux found, the pinctrl core may check
If dummy pinmux is supported, if supported, it will fakely success with returning
a dummy pinmux. Then real error is hiden.
This is due to for supporting one single image, the dummy pinmux may also be enabled
For platforms like mx6q with real pinmux.

I just did a quick look at the regulator code and got this understanding,
please let me know if I understood wrong.

> > > How do we distinguish between the two case(real error and fake error)?
> >
> What do we need to distinguish between two cases?  The real success for
> real pinmux from the fake success for the dummy pinmux?  It does not
> really matter.
> 
> > We don't :(
> >
> > That's the problem with the dummy regulator.
> >
> What is the problem exactly?  I do not quite understand.
> 
> --
> Regards,
> Shawn

