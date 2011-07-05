Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1GEOKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:10:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39754 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab1GEOKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:10:23 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: [PATCH v2 2/5] input: twl6040-vibra: Do not use wrapper for irq request
Date: Tue, 5 Jul 2011 17:10:13 +0300
Message-ID: <1462382.yEDobJovyP@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110705135745.GN2820@legolas.emea.dhcp.ti.com>
References: <1309873775-17927-1-git-send-email-peter.ujfalusi@ti.com> <1309873775-17927-3-git-send-email-peter.ujfalusi@ti.com> <20110705135745.GN2820@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011 15:57:46 Balbi, Felipe wrote:
> > +	info->irq = platform_get_irq(pdev, 0);
> > +	if (!info->irq) {
> 
> this is wrong. platform_get_irq() will return -ENXIO if it can't find
> the IRQ you requested:
> 
>   55 /**
>   56  * platform_get_irq - get an IRQ for a device
>   57  * @dev: platform device
>   58  * @num: IRQ number index
>   59  */
>   60 int platform_get_irq(struct platform_device *dev, unsigned int num)
>   61 {
>   62         struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ,
> num); 63
>   64         return r ? r->start : -ENXIO;
>   65 }
>   66 EXPORT_SYMBOL_GPL(platform_get_irq);

Yes, I have not checked that..
Will replace the check with (info->irq< 0) checks in both slaves.

Thanks for noticing it!
I'll wait a bit for other comments, and will resend.

-- 
Péter
