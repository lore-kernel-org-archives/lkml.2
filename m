Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2CNGkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:40:36 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:13539
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785Ab2CNGkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:40:33 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz1432N98dK1447Mzz1202hzz8275ch8275bh8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 14 Mar 2012 14:42:25 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>
Subject: Re: [PATCH v1 2/5] mmc: mxs-mmc: add dt probe support
Message-ID: <20120314064224.GA25735@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-3-git-send-email-b29396@freescale.com>
 <20120313174238.CE9133E053B@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120313174238.CE9133E053B@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 01:42:38AM +0800, Grant Likely wrote:
> On Tue, 13 Mar 2012 16:47:05 +0800, Dong Aisheng <b29396@freescale.com> wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > ---
> > The patch is still using a private way for dma part binding
> > since the common dma binding is still under discussion.
> > http://www.spinics.net/lists/linux-omap/msg65528.html
> > 
> > Will update to use common dma binding when it hits mainline.
> > ---
> >  .../devicetree/bindings/mmc/fsl-mxs-mmc.txt        |   23 ++++++
> >  drivers/mmc/host/mxs-mmc.c                         |   82 +++++++++++++++++++-
> >  2 files changed, 102 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt b/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt
> > new file mode 100644
> > index 0000000..adc1142
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt
> > @@ -0,0 +1,23 @@
> > +* FREESCALE MXS MMC peripheral
> > +
> > +Required properties:
> > +- compatible : Should be "fsl,<chip>-mmc"
> > +- reg : Should contain registers location and length
> > +- interrupts : Should contain interrupt.
> > +  The format is <irq_err irq_dma>.
> > +- dma_channel: Should contain the dma channel it uses
> 
> Don't use '_' in property names.
> 
Yes, my mistake.

> The is a generic dma binding being drafted that uses a phandle to the dma
> controller and the ability to encode channel numbers.  You may want to take
> a look at it.
> 
I will look at it.
Thanks for the reminder.

...
> > +	dmares->flags = IORESOURCE_DMA;
> > +	ret = of_property_read_u32(np, "dma_channel", &dmares->start);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "unable to get dmares from dt\n");
> > +		return NULL;
> > +	}
> > +	dmares->end = dmares->start;
> > +
> > +	return dmares;
> > +}
> > +
> > +static int __devinit mxs_mmc_get_of_property(struct platform_device *pdev,
> > +				struct mxs_mmc_platform_data **ppdata)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct mxs_mmc_platform_data *pdata = *ppdata;
> > +
> > +	if (!np)
> > +		return -ENODEV;
> > +
> > +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> 
> Ditto
> 
Got it.

> Fix up those comments and you can add my:
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
Thanks.

Regards
Dong Aisheng

