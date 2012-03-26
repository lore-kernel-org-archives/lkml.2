Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab2CZRg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:36:28 -0400
Received: from londo.lunn.ch ([80.238.139.98]:54974 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122Ab2CZRg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:36:27 -0400
Date: Mon, 26 Mar 2012 19:36:24 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFT v2] watchdog: Convert orion_wdt driver to watchdog
 core
Message-ID: <20120326173624.GA12884@lunn.ch>
References: <1332761395.20711.1.camel@phoenix>
 <20120326141233.GR2484@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326141233.GR2484@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  static int __devinit orion_wdt_probe(struct platform_device *pdev)
> > @@ -241,26 +146,28 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
> >  	struct resource *res;
> >  	int ret;
> >  
> > -	if (pdata) {
> > -		wdt_tclk = pdata->tclk;
> > -	} else {
> > +	if (!pdata) {
> >  		pr_err("misses platform data\n");
> >  		return -ENODEV;
> >  	}
> 
> Platform data is changing soon with devicetree support (and converting
> to common clock).  Please don't change this if you don't need to.
> 
> Also, I'll include Andrew Lunn in the CC.  He's doing the conversion of
> orion over to common clock, which affects this driver.

Yep,

Once the merge is over and the first -rc kernel is released, i will
post my patches rebased on that. For wdt, clk is no longer in the
platform data.

	 Andrew
