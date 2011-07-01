Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1GAKyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 06:54:15 -0400
Received: from us7.mainehost.net ([65.126.238.4]:42385 "EHLO us7.mainehost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1GAKyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 06:54:14 -0400
Subject: Re: [PATCH] DMA: OMAP: Remove extra looping from omap_request_dma
From: Scott Ellis <scott@jumpnowtek.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
In-Reply-To: <20110701071942.GC23145@atomide.com>
References: <1309356549.3995.13.camel@quad>
	 <20110701071942.GC23145@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 06:54:00 -0400
Message-ID: <1309517640.2624.38.camel@quad>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - us7.mainehost.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - jumpnowtek.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A free channel gets found correctly, that's not the problem. 

The patch is to eliminate the extra passes through the loop after
free_ch is assigned.

I dropped some printk's into omap_request_dma()

[  158.375885] inside omap_request_dma()
[  158.379577] dev_id = 61 ch = 0 free_ch = -1
[  158.383789] dev_id = 61 ch = 1 free_ch = -1
[  158.387969] dev_id = 61 ch = 2 free_ch = -1
[  158.392181] dev_id = 61 ch = 3 free_ch = -1
[  158.396392] dev_id = 61 ch = 4 free_ch = -1
[  158.400573] set free_ch = 4 (could break now)
[  158.403381] dev_id = 61 ch = 5 free_ch = 4
[  158.407501] dev_id = 61 ch = 6 free_ch = 4
[  158.411621] dev_id = 61 ch = 7 free_ch = 4
[  158.415740] dev_id = 61 ch = 8 free_ch = 4
[  158.419830] dev_id = 61 ch = 9 free_ch = 4
[  158.423950] dev_id = 61 ch = 10 free_ch = 4
[  158.428161] dev_id = 61 ch = 11 free_ch = 4
[  158.432373] dev_id = 61 ch = 12 free_ch = 4
[  158.436553] dev_id = 61 ch = 13 free_ch = 4
[  158.440765] dev_id = 61 ch = 14 free_ch = 4
[  158.444976] dev_id = 61 ch = 15 free_ch = 4
[  158.449157] dev_id = 61 ch = 16 free_ch = 4
[  158.453369] dev_id = 61 ch = 17 free_ch = 4
[  158.457580] dev_id = 61 ch = 18 free_ch = 4
[  158.461761] dev_id = 61 ch = 19 free_ch = 4
[  158.465972] dev_id = 61 ch = 20 free_ch = 4
[  158.470184] dev_id = 61 ch = 21 free_ch = 4
[  158.474395] dev_id = 61 ch = 22 free_ch = 4
[  158.478576] dev_id = 61 ch = 23 free_ch = 4
[  158.482788] dev_id = 61 ch = 24 free_ch = 4
[  158.486999] dev_id = 61 ch = 25 free_ch = 4
[  158.491180] dev_id = 61 ch = 26 free_ch = 4
[  158.495391] dev_id = 61 ch = 27 free_ch = 4
[  158.499603] dev_id = 61 ch = 28 free_ch = 4
[  158.503784] dev_id = 61 ch = 29 free_ch = 4
[  158.507995] dev_id = 61 ch = 30 free_ch = 4
[  158.512207] dev_id = 61 ch = 31 free_ch = 4
...
[    4.097991] inside omap_request_dma()
[    4.101684] dev_id = 62 ch = 0 free_ch = -1
[    4.105895] dev_id = 62 ch = 1 free_ch = -1
[    4.110076] dev_id = 62 ch = 2 free_ch = -1
[    4.114288] dev_id = 62 ch = 3 free_ch = -1
[    4.118499] dev_id = 62 ch = 4 free_ch = -1
[    4.122680] set free_ch = 4 (could break now)
[    4.125488] dev_id = 62 ch = 5 free_ch = 4
[    4.129608] dev_id = 62 ch = 6 free_ch = 4
[    4.133728] dev_id = 62 ch = 7 free_ch = 4
[    4.137847] dev_id = 62 ch = 8 free_ch = 4
[    4.141937] dev_id = 62 ch = 9 free_ch = 4
[    4.146057] dev_id = 62 ch = 10 free_ch = 4
[    4.150268] dev_id = 62 ch = 11 free_ch = 4
[    4.154479] dev_id = 62 ch = 12 free_ch = 4
[    4.158660] dev_id = 62 ch = 13 free_ch = 4
[    4.162872] dev_id = 62 ch = 14 free_ch = 4
[    4.167083] dev_id = 62 ch = 15 free_ch = 4
[    4.171264] dev_id = 62 ch = 16 free_ch = 4
[    4.175476] dev_id = 62 ch = 17 free_ch = 4
[    4.179687] dev_id = 62 ch = 18 free_ch = 4
[    4.183868] dev_id = 62 ch = 19 free_ch = 4
[    4.188079] dev_id = 62 ch = 20 free_ch = 4
[    4.192291] dev_id = 62 ch = 21 free_ch = 4
[    4.196502] dev_id = 62 ch = 22 free_ch = 4
[    4.200683] dev_id = 62 ch = 23 free_ch = 4
[    4.204895] dev_id = 62 ch = 24 free_ch = 4
[    4.209106] dev_id = 62 ch = 25 free_ch = 4
[    4.213287] dev_id = 62 ch = 26 free_ch = 4
[    4.217498] dev_id = 62 ch = 27 free_ch = 4
[    4.221710] dev_id = 62 ch = 28 free_ch = 4
[    4.225891] dev_id = 62 ch = 29 free_ch = 4
[    4.230102] dev_id = 62 ch = 30 free_ch = 4
[    4.234313] dev_id = 62 ch = 31 free_ch = 4
...

I was also wondering, what is special about dev_id == 0? The current
code treats that special and does break immediately?

Scott

On Fri, 2011-07-01 at 00:19 -0700, Tony Lindgren wrote:
> * Scott Ellis <scott@jumpnowtek.com> [110629 20:58]:
> > Break from dma channel search when a free one is found.
> 
> Care to describe how the current code is not finding a
> free channel currently?
> 
> Tony
> 
>  
> > Signed-off-by: Scott Ellis <scott@jumpnowtek.com>
> > ---
> >  arch/arm/plat-omap/dma.c |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
> > index c22217c..3d36fcf 100644
> > --- a/arch/arm/plat-omap/dma.c
> > +++ b/arch/arm/plat-omap/dma.c
> > @@ -678,10 +678,9 @@ int omap_request_dma(int dev_id, const char *dev_name,
> >  
> >  	spin_lock_irqsave(&dma_chan_lock, flags);
> >  	for (ch = 0; ch < dma_chan_count; ch++) {
> > -		if (free_ch == -1 && dma_chan[ch].dev_id == -1) {
> > +		if (dma_chan[ch].dev_id == -1) {
> >  			free_ch = ch;
> > -			if (dev_id == 0)
> > -				break;
> > +			break;
> >  		}
> >  	}
> >  	if (free_ch == -1) {
> > 

-- 
Sent from my Linux box

