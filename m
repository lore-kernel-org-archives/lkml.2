Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2DZC7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:59:23 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:16159
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785Ab2DZC7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:59:21 -0400
X-SpamScore: -20
X-BigFish: VS-20(zz9371Ic89bh542Mdf9M1432N98dK4015Izz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h93fhd25hbe9i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Li Yang-R58472 <r58472@freescale.com>
To: Shi Xuelin-B29237 <B29237@freescale.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: RE: [PATCH]     fsldma: fix performance degradation by optimizing
 spinlock use.
Thread-Topic: [PATCH]     fsldma: fix performance degradation by optimizing
 spinlock use.
Thread-Index: AQHM0DZg8AHMyC8/2ES5582dOlbpzJYHvCeAgKWY5wD//7sHQA==
Date: Thu, 26 Apr 2012 02:59:15 +0000
Message-ID: <94F013E7935FF44C83EBE7784D62AD3F092D8457@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1324879263-11845-1-git-send-email-b29237@freescale.com>
 <DBB740589CE8814680DECFE34BE197AB1665A3@039-SN1MPN1-006.039d.mgd.msft.net>
 <20120111161347.GA1430@ovro.caltech.edu>
 <00ACF084E0EED647B22C27725E03EAFD06D7E2@039-SN2MPN1-011.039d.mgd.msft.net>
In-Reply-To: <00ACF084E0EED647B22C27725E03EAFD06D7E2@039-SN2MPN1-011.039d.mgd.msft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.76]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3Q2xbe6011032

Hi Dan and Vinod,

Please help to pick this patch up.  It addresses a great performance regression for RAID offloading.

Acked-by: Li Yang <leoli@freescale.com>

- Leo

> -----Original Message-----
> From: Shi Xuelin-B29237
> Sent: Thursday, April 26, 2012 10:04 AM
> To: dan.j.williams@intel.com
> Cc: vinod.koul@intel.com; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; Ira W. Snyder; Li Yang-R58472
> Subject: RE: [PATCH] fsldma: fix performance degradation by optimizing
> spinlock use.
> 
> Hi Dan Williams,
> 
> Do you have any comment about this patch?
> 
> Thanks,
> Forrest
> 
> -----Original Message-----
> From: Ira W. Snyder [mailto:iws@ovro.caltech.edu]
> Sent: 2012å¹´1æœˆ12æ—¥ 0:14
> To: Shi Xuelin-B29237
> Cc: vinod.koul@intel.com; dan.j.williams@intel.com; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] fsldma: fix performance degradation by optimizing
> spinlock use.
> 
> On Wed, Jan 11, 2012 at 07:54:55AM +0000, Shi Xuelin-B29237 wrote:
> > Hello Iris,
> >
> > As we discussed in the previous patch, I add one smp_mb() in
> fsl_tx_status.
> > In my testing with iozone, this smp_mb() could cause 1%~2% performance
> degradation.
> > Anyway it is acceptable for me. Do you have any other comments?
> >
> 
> This patch looks fine to me.
> 
> Ira
> 
> > -----Original Message-----
> > From: Shi Xuelin-B29237
> > Sent: 2011å¹´12æœˆ26æ—¥ 14:01
> > To: iws@ovro.caltech.edu; vinod.koul@intel.com;
> dan.j.williams@intel.com; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org
> > Cc: Shi Xuelin-B29237
> > Subject: [PATCH] fsldma: fix performance degradation by optimizing
> spinlock use.
> >
> > From: Forrest shi <b29237@freescale.com>
> >
> >     dma status check function fsl_tx_status is heavily called in
> >     a tight loop and the desc lock in fsl_tx_status contended by
> >     the dma status update function. this caused the dma performance
> >     degrades much.
> >
> >     this patch releases the lock in the fsl_tx_status function, and
> >     introduce the smp_mb() to avoid possible memory inconsistency.
> >
> >     Signed-off-by: Forrest Shi <xuelin.shi@freescale.com>
> > ---
> >  drivers/dma/fsldma.c |    6 +-----
> >  1 files changed, 1 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c index
> 8a78154..008fb5e 100644
> > --- a/drivers/dma/fsldma.c
> > +++ b/drivers/dma/fsldma.c
> > @@ -986,15 +986,11 @@ static enum dma_status fsl_tx_status(struct
> dma_chan *dchan,
> >  	struct fsldma_chan *chan = to_fsl_chan(dchan);
> >  	dma_cookie_t last_complete;
> >  	dma_cookie_t last_used;
> > -	unsigned long flags;
> > -
> > -	spin_lock_irqsave(&chan->desc_lock, flags);
> >
> > 	last_complete = chan->completed_cookie;
> > +	smp_mb();
> > 	last_used = dchan->cookie;
> >
> > -	spin_unlock_irqrestore(&chan->desc_lock, flags);
> > -
> >  	dma_set_tx_state(txstate, last_complete, last_used, 0);
> >  	return dma_async_is_complete(cookie, last_complete, last_used); }
> > --
> > 1.7.0.4
> >
> >

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
