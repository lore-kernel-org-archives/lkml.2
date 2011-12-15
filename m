Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab1LOHXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:23:47 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:6497 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1LOHXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:23:46 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: RE: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Thread-Topic: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Thread-Index: AQHMunirzWtXRBa0wUCO2ofliTlfR5XcOaMAgAAR44CAACoQYA==
Date: Thu, 15 Dec 2011 07:23:42 +0000
Message-ID: <7FE21149F4667147B645348EC60578850561FF@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
	<1323878622-26602-5-git-send-email-b29396@freescale.com>
	<20111214211152.GM27267@pengutronix.de>
 <CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
In-Reply-To: <CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
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
> Sent: Thursday, December 15, 2011 6:16 AM
> To: Sascha Hauer
> Cc: Dong Aisheng-B29396; linus.walleij@stericsson.com; linux-
> kernel@vger.kernel.org; rob.herring@calxeda.com;
> grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de; Guo Shawn-R65073
> Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux
> subsystem
> Importance: High
> 
> On Wed, Dec 14, 2011 at 10:11 PM, Sascha Hauer <s.hauer@pengutronix.de>
> wrote:
> > On Thu, Dec 15, 2011 at 12:03:42AM +0800, Dong Aisheng wrote:
> 
> >> +     pmx = pinmux_get(&pdev->dev, NULL);
> >> +     if (IS_ERR(pmx)) {
> >> +             err = PTR_ERR(pmx);
> >> +             goto err_pmx_get;
> >> +     }
> >> +     err = pinmux_enable(pmx);
> >> +     if (err)
> >> +             goto err_pmx_enable;
> >> +     imx_data->pmx = pmx;
> >> +
> >
> > Won't this break every i.MX except i.MX6?
>

If not select PINCTRL, pinmux_enable returns ok by default and pinmux_get
Returns NULL which also does not block.
So it will not break other i.MX currently since only mx6q are using PINCTRL.
 
> Not this patch on its own, first the machines have to select PINCTRL
> select PINMUX_FOO
> 
> *Then* it will break :-D
> 

After we move to one single image for mx5 and mx6, it could be an issue
Since PINCTRL may be selected by default.
So mx5 pinmux driver is in my TODO list.

> So if you want to do this for i.MX you need something like selectable
> dummy pinmuxes, i.e. pinmux_get() to return something that just say "OK"
> to everything like the dummy regulators.
> 
> Shall I try to create something like that?
> 
For those platforms do not select PINCTRL, current code does not block.
For platforms do select PINCTRL but does not have pinmux driver ready,
for example, single image for both mx5&mx6,
IMHO it may be better to fix in driver to avoid introduce too much
complexity in pinctrl core.

Regards
Dong Aisheng

