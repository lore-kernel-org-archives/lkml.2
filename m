Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2JZLp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:45:26 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58607 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333Ab2JZLpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:45:25 -0400
Date: Fri, 26 Oct 2012 07:45:33 -0400
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Cyril Chemparathy <cyril@ti.com>, khilman@ti.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] davinci: check for presence of channel controller on
 slot alloc
Message-ID: <20121026114533.GA2710@beef>
References: <1347473642-9948-1-git-send-email-cyril@ti.com>
 <508A7665.4030109@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508A7665.4030109@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 05:09:17PM +0530, Sekhar Nori wrote:
> + Matt, who is doing the DMA engine conversion for EDMA
> 
> On 9/12/2012 11:44 PM, Cyril Chemparathy wrote:
> > This patch adds a check for the presence of the channel controller when
> > trying to allocate a slot.  Without this fix, the kernel panics with a NULL
> > pointer dereference when the dma-engine drivers are probed.
> > 
> > Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> > ---
> >  arch/arm/mach-davinci/dma.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm/mach-davinci/dma.c b/arch/arm/mach-davinci/dma.c
> > index a685e97..2fee31e 100644
> > --- a/arch/arm/mach-davinci/dma.c
> > +++ b/arch/arm/mach-davinci/dma.c
> > @@ -743,6 +743,9 @@ EXPORT_SYMBOL(edma_free_channel);
> >   */
> >  int edma_alloc_slot(unsigned ctlr, int slot)
> >  {
> > +	if (!edma_cc[ctlr])
> > +		return -ENODEV;
> 
> I am ok with this patch, although I wonder if a better error is -ENXIO
> or even -EINVAL (since its most likely the result of a wrong argument).
> 
> This patch will conflict with the EDMA movement series that Matt is
> doing and he should probably include it in his series to avoid
> conflicts. From the description it appears to be not required for v3.7
> anyway.

I'll add this to the am33xx dmaengine series with -EINVAL, thanks.

-Matt
