Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1DUINz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:13:55 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:27589
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab1DUINx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:13:53 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz3b49K1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 21 Apr 2011 16:17:49 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-mmc@vger.kernel.org>, <patches@linaro.org>,
        <linaro-dev@lists.linaro.org>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>
Subject: Re: [PATCH 3/5] mmc: sdhci: make sdhci-of device drivers self
 registered
Message-ID: <20110421081749.GF4024@S2100-06.ap.freescale.net>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <1301042931-4869-4-git-send-email-shawn.guo@linaro.org>
 <20110419102101.GD4164@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110419102101.GD4164@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 12:21:01PM +0200, Wolfram Sang wrote:
> 
> > +static int __devinit sdhci_esdhc_probe(struct platform_device *pdev)
> > +{
> > +	struct sdhci_host *host;
> > +	int ret;
> > +
> > +	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_pdata);
> > +	if (!host)
> > +		return -ENOMEM;
> 
> Just noticed: Since pltfm_init may fail due to various reasons, maybe
> ERRPTR might be a good idea?
> 
Ok.

> [...]
> 
> > +static int __init sdhci_hlwd_init(void)
> > +{
> > +	return platform_driver_register(&sdhci_hlwd_driver);
> > +}
> > +module_init(sdhci_hlwd_init);
> > +
> > +static void __exit sdhci_hlwd_exit(void)
> > +{
> > +	platform_driver_unregister(&sdhci_hlwd_driver);
> > +}
> > +module_exit(sdhci_hlwd_exit);
> > +
> > +MODULE_DESCRIPTION("Secure Digital Host Controller Interface OF driver");
> > +MODULE_AUTHOR("Xiaobo Xie <X.Xie@freescale.com>, "
> > +	      "Anton Vorontsov <avorontsov@ru.mvista.com>");
> > +MODULE_LICENSE("GPL v2");
> 
> Please double check the authors. It is based on the fsl driver, but the
> copyright should go to
> 
>  * Copyright (C) 2009 The GameCube Linux Team
>  * Copyright (C) 2009 Albert Herranz
> 
> I think.
> 
Sorry, I misread the current copyright in sdhci-of-hlwd.c.  You are
right.

-- 
Regards,
Shawn

