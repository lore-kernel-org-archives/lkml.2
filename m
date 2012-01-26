Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2AZVI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:08:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53795 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2AZVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:08:28 -0500
Date: Thu, 26 Jan 2012 22:07:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-serial@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/7 v2] dmaengine: add a simple dma library
In-Reply-To: <20120126173444.GM5446@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1201262206530.10057@axis700.grange>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
 <20120126173444.GM5446@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:jd5aGejw5its88DdcsaS3POCGlE+LThz/8ge31SqRJJ
 Z9DBLAKjLDss4K+AYV+RRPNnVPZNQX+VxpW4jWWjOoAGCQ/R6/
 19o22b3+TLAlrnMaS2jbMuVm0qLdtI9im7Gw0X4YhnFMsVZd2y
 bxRLqkpWgicMHEHoLf9rkfqqa+IG0vCFXXLR8vsY7tkZhMQ3f1
 UPHvBpYEHJwSewkmpNyA4eNzl5wQbLBtwZCVZ2MghP0U5pNTbd
 bXhB2axgg29giTvHI+6/mCuV6VXhfRlrQP6hrxxhsHyJu4Kcqy
 x0jCon+MeH8ALRm4S5nvoE4PLvurlMcxlMcvsnD/AxKKUK8cdg
 KJw9guRIi7jKaVZNyScPL4xdpjCsK6gicCkBSE6lueQlClFw4G
 iour0wi6V68QQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha

On Thu, 26 Jan 2012, Sascha Hauer wrote:

> Hi Guennadi,
> 
> On Thu, Jan 26, 2012 at 03:56:18PM +0100, Guennadi Liakhovetski wrote:
> > This patch adds a library of functions, helping to implement dmaengine
> > drivers for hardware, unable to handle scatter-gather lists natively.
> > The first version of this driver only supports memcpy and slave DMA
> > operation.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> 
> [...]
> 
> > +
> > +/*
> > + * For slave DMA we assume, that there is a finite number of DMA slaves in the
> > + * system, and that each such slave can only use a finite number of channels.
> > + * We use slave channel IDs to make sure, that no such slave channel ID is
> > + * allocated more than once.
> > + */
> > +static unsigned int slave_num = 256;
> > +module_param(slave_num, uint, 0444);
> > +
> > +/* A bitmask with slave_num bits */
> > +static unsigned long *simple_slave_used;
> 
> You never check that the slave ids passed into this code are
> within the range of slave_num. Given that this is a user changeable
> value this is a bit flawy.

Right, never trust the user;-) I'll fix that.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
