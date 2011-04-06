Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1DFGLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 02:11:36 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:49031
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab1DFGLf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 02:11:35 -0400
X-SpamScore: -31
X-BigFish: VS-31(zz9371O542M1432N98dK1447Rzz1202hzz8275bh8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: "greg@kroah.com" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhou Jie-B30303 <B30303@freescale.com>
Subject: RE: [PATCH 1/1] uio: clean uioinfo when uninstall uio driver
Thread-Topic: [PATCH 1/1] uio: clean uioinfo when uninstall uio driver
Thread-Index: AQHL8RNPSP1UdIOMcUqkgoyNIXvMmpROSa+AgAIVOhA=
Date: Wed, 6 Apr 2011 06:11:31 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F77214FA34@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1301734523-27933-1-git-send-email-b29396@freescale.com>
 <20110404171616.GB4830@local>
In-Reply-To: <20110404171616.GB4830@local>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Hans J. Koch [mailto:hjk@hansjkoch.de]
> Sent: Tuesday, April 05, 2011 1:16 AM
> To: Dong Aisheng-B29396
> Cc: hjk@hansjkoch.de; greg@kroah.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] uio: clean uioinfo when uninstall uio driver
> 
> On Sat, Apr 02, 2011 at 04:55:23PM +0800, Aisheng Dong wrote:
> > From: Jie Zhou <b30303@freescale.com>
> >
> > The uioinfo should be cleaned up when uninstall, otherwise re-install
> > failure of uio_pdrv_genirq.ko will happen.
> >
> > Signed-off-by: Jie Zhou <b30303@freescale.com>
> > Signed-off-by: Aisheng Dong <b29396@freescale.com>
> > ---
> >  drivers/uio/uio_pdrv_genirq.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/uio/uio_pdrv_genirq.c
> > b/drivers/uio/uio_pdrv_genirq.c index 7174d51..e669a2c 100644
> > --- a/drivers/uio/uio_pdrv_genirq.c
> > +++ b/drivers/uio/uio_pdrv_genirq.c
> > @@ -189,6 +189,12 @@ static int uio_pdrv_genirq_remove(struct
> > platform_device *pdev)
> >
> >  	uio_unregister_device(priv->uioinfo);
> >  	pm_runtime_disable(&pdev->dev);
> > +
> > +	priv->uioinfo->irq_flags = 0;
> 
> Why this one?
Could be removed.

> > +	priv->uioinfo->handler = NULL;
> > +	priv->uioinfo->irqcontrol = NULL;
> 
> Both OK, good catch!
> 
> > +	priv->uioinfo->priv = NULL;
> 
> Why this one?
Could be removed.

Thanks for the info.
The V2 patch will be soon.

