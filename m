Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2C1HCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:02:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57011 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2C1HCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:02:44 -0400
Date: Wed, 28 Mar 2012 09:02:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Paul Mundt <lethal@linux-sh.org>
cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/2] dma: shdma: fix runtime PM: clear channel buffers
 on reset
In-Reply-To: <20120328052503.GP26543@linux-sh.org>
Message-ID: <Pine.LNX.4.64.1203280858120.4583@axis700.grange>
References: <Pine.LNX.4.64.1201041528570.30506@axis700.grange>
 <Pine.LNX.4.64.1201041532290.30506@axis700.grange> <20120328052503.GP26543@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:eTxxLwVpPDatJWF54jtSERuXf9Irm+wkMgy7sQbcEZP
 JT3BYgknGZVvj9PNb1Z+t2r32+lKbq56PotcxU6VTAIp8AeiJO
 fNCDce0irUSpvx2wQoqA8Bsdafoh3ERiFcm/xxs5sOKqnrY6Fc
 sPeHNfkORTr+VMniuBHJLTPxZDB7iJbE5mqUjMHNKb72GbOm5w
 Y49MFMyeRK94bPyfSiM1zEVAbtomuQLYlEM91GT59WUVr5vAAs
 F7h3BlrIK6CVUKxZe5dWiYexyOGWO0Sf/9ujKHB7rZDowDpk/Z
 jyRkoEWW7CQ43cwut7T7tf9axgQ+IY13VtmAu4PMnRmYcezyA5
 +5m37ATNwI96v/zNe3n0i/GotFkvM7IyDhQGutUvHJf6DI2+DO
 RlflsPGnnzXlw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012, Paul Mundt wrote:

> On Wed, Jan 04, 2012 at 03:34:17PM +0100, Guennadi Liakhovetski wrote:
> > On platforms, supporting power domains, if the domain, containing a DMAC
> > instance is powered down, the driver fails to resume correctly. On those
> > platforms DMAC channels have an additional CHCLR register for clearing
> > channel buffers. Using this register during runtime resume fixes the
> > problem.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> ..
> 
> > @@ -139,6 +157,10 @@ static int sh_dmae_rst(struct sh_dmae_device *shdev)
> >  		dev_warn(shdev->common.dev, "Can't initialize DMAOR.\n");
> >  		return -EIO;
> >  	}
> > +	if (shdev->pdata->dmaor_init & ~dmaor)
> > +		dev_warn(shdev->common.dev,
> > +			 "DMAOR=0x%x hasn't latched the initial value 0x%x.\n",
> > +			 dmaor, shdev->pdata->dmaor_init);
> >  	return 0;
> >  }
> >  
> I've just hit this on SH7786, which I suspect means that I've got it
> wired up incorrectly somehow. This hunk also appears completely unrelated
> to the changelog, so I'm wondering what exactly it's for. If this is a
> probe attempt then presumably we should be handing down an error and
> -ENODEV'ing in the init path? Is it expected that this is non-fatal in
> the other reset cases?

The answer is "I don't know." I'm also seeing this in several cases, e.g., 
on sh7372 one of the two USB DMA controllers always triggers this, IIRC. 
This failure does indeed seem to be non-fatal, and it has been simply 
ignored in the past. I just hit it in my tests and decided it was worth 
drawing attention to it to maybe actually find out what's going on there.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
