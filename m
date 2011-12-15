Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab1LOKky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:40:54 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:55653 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753694Ab1LOKkx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:40:53 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: RE: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Thread-Topic: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Thread-Index: AQHMunirzWtXRBa0wUCO2ofliTlfR5XcOaMAgAAR44CAACoQYIAAku0A//+ubnA=
Date: Thu, 15 Dec 2011 10:40:44 +0000
Message-ID: <7FE21149F4667147B645348EC6057885056723@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
 <1323878622-26602-5-git-send-email-b29396@freescale.com>
 <20111214211152.GM27267@pengutronix.de>
 <CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
 <7FE21149F4667147B645348EC60578850561FF@039-SN2MPN1-013.039d.mgd.msft.net>
 <20111215093218.GN27267@pengutronix.de>
In-Reply-To: <20111215093218.GN27267@pengutronix.de>
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
> From: Sascha Hauer [mailto:s.hauer@pengutronix.de]
> Sent: Thursday, December 15, 2011 5:32 PM
> To: Dong Aisheng-B29396
> Cc: Linus Walleij; linus.walleij@stericsson.com; linux-
> kernel@vger.kernel.org; rob.herring@calxeda.com;
> grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de; Guo Shawn-R65073
> Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux
> subsystem
> Importance: High
> 
> On Thu, Dec 15, 2011 at 07:23:42AM +0000, Dong Aisheng-B29396 wrote:
> > > -----Original Message-----
> > > From: Linus Walleij [mailto:linus.walleij@linaro.org]
> > > Sent: Thursday, December 15, 2011 6:16 AM
> > > To: Sascha Hauer
> > > Cc: Dong Aisheng-B29396; linus.walleij@stericsson.com; linux-
> > > kernel@vger.kernel.org; rob.herring@calxeda.com;
> > > grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
> > > kernel@pengutronix.de; Guo Shawn-R65073
> > > Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux
> > > subsystem
> > > Importance: High
> > >
> > > On Wed, Dec 14, 2011 at 10:11 PM, Sascha Hauer
> > > <s.hauer@pengutronix.de>
> > > wrote:
> > > > On Thu, Dec 15, 2011 at 12:03:42AM +0800, Dong Aisheng wrote:
> > >
> > > >> +     pmx = pinmux_get(&pdev->dev, NULL);
> > > >> +     if (IS_ERR(pmx)) {
> > > >> +             err = PTR_ERR(pmx);
> > > >> +             goto err_pmx_get;
> > > >> +     }
> > > >> +     err = pinmux_enable(pmx);
> > > >> +     if (err)
> > > >> +             goto err_pmx_enable;
> > > >> +     imx_data->pmx = pmx;
> > > >> +
> > > >
> > > > Won't this break every i.MX except i.MX6?
> > >
> >
> > If not select PINCTRL, pinmux_enable returns ok by default and
> > pinmux_get Returns NULL which also does not block.
> > So it will not break other i.MX currently since only mx6q are using
> PINCTRL.
> >
> > > Not this patch on its own, first the machines have to select PINCTRL
> > > select PINMUX_FOO
> > >
> > > *Then* it will break :-D
> > >
> >
> > After we move to one single image for mx5 and mx6, it could be an
> > issue Since PINCTRL may be selected by default.
> > So mx5 pinmux driver is in my TODO list.
> 
> Add i.MX3 which is compiled together with i.MX6 :)
> 
Sure, would like to do it.
Thanks

Regards
Dong Aisheng



