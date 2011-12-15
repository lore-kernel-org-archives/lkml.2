Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab1LOJc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:32:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37529 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab1LOJc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:32:27 -0500
Date: Thu, 15 Dec 2011 10:32:18 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dong Aisheng-B29396 <B29396@freescale.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Message-ID: <20111215093218.GN27267@pengutronix.de>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
 <1323878622-26602-5-git-send-email-b29396@freescale.com>
 <20111214211152.GM27267@pengutronix.de>
 <CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
 <7FE21149F4667147B645348EC60578850561FF@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7FE21149F4667147B645348EC60578850561FF@039-SN2MPN1-013.039d.mgd.msft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:31:44 up 32 days, 17:18, 47 users,  load average: 0.07, 0.10,
 0.46
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 07:23:42AM +0000, Dong Aisheng-B29396 wrote:
> > -----Original Message-----
> > From: Linus Walleij [mailto:linus.walleij@linaro.org]
> > Sent: Thursday, December 15, 2011 6:16 AM
> > To: Sascha Hauer
> > Cc: Dong Aisheng-B29396; linus.walleij@stericsson.com; linux-
> > kernel@vger.kernel.org; rob.herring@calxeda.com;
> > grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
> > kernel@pengutronix.de; Guo Shawn-R65073
> > Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux
> > subsystem
> > Importance: High
> > 
> > On Wed, Dec 14, 2011 at 10:11 PM, Sascha Hauer <s.hauer@pengutronix.de>
> > wrote:
> > > On Thu, Dec 15, 2011 at 12:03:42AM +0800, Dong Aisheng wrote:
> > 
> > >> +     pmx = pinmux_get(&pdev->dev, NULL);
> > >> +     if (IS_ERR(pmx)) {
> > >> +             err = PTR_ERR(pmx);
> > >> +             goto err_pmx_get;
> > >> +     }
> > >> +     err = pinmux_enable(pmx);
> > >> +     if (err)
> > >> +             goto err_pmx_enable;
> > >> +     imx_data->pmx = pmx;
> > >> +
> > >
> > > Won't this break every i.MX except i.MX6?
> >
> 
> If not select PINCTRL, pinmux_enable returns ok by default and pinmux_get
> Returns NULL which also does not block.
> So it will not break other i.MX currently since only mx6q are using PINCTRL.
>  
> > Not this patch on its own, first the machines have to select PINCTRL
> > select PINMUX_FOO
> > 
> > *Then* it will break :-D
> > 
> 
> After we move to one single image for mx5 and mx6, it could be an issue
> Since PINCTRL may be selected by default.
> So mx5 pinmux driver is in my TODO list.

Add i.MX3 which is compiled together with i.MX6 :)

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
