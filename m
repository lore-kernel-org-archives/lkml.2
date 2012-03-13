Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2CMHK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:10:58 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:35847 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab2CMHK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:10:56 -0400
Message-ID: <1331622633.2048.87.camel@epip-laptop>
Subject: Re: [PATCH 7/7] arch/unicore32/kernel/dma.c: ensure arguments to
 request_irq and free_irq are compatible
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Mar 2012 15:10:33 +0800
In-Reply-To: <alpine.DEB.2.02.1203120625570.2066@localhost6.localdomain6>
References: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1331494587-12196-8-git-send-email-Julia.Lawall@lip6.fr>
	 <1331513926.2048.58.camel@epip-laptop>
	 <alpine.DEB.2.02.1203120625570.2066@localhost6.localdomain6>
Organization: MPRC, PKU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 06:27 +0100, Julia Lawall wrote:
> On Mon, 12 Mar 2012, Guan Xuetao wrote:
> 
> > On Sun, 2012-03-11 at 20:36 +0100, Julia Lawall wrote:
> >> From: Julia Lawall <Julia.Lawall@lip6.fr>
> >>
> >> Convert calls to free_irq so that the second argument is the same as the
> >> last argument of the corresponding call to request_irq, rather than the
> >> second to last.  Without this property, free_irq does nothing.
> >>
> >> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >>
> >> ---
> >>  arch/unicore32/kernel/dma.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/unicore32/kernel/dma.c b/arch/unicore32/kernel/dma.c
> >> index ae441bc..c813fec 100644
> >> --- a/arch/unicore32/kernel/dma.c
> >> +++ b/arch/unicore32/kernel/dma.c
> >> @@ -173,7 +173,7 @@ int __init puv3_init_dma(void)
> >>  	ret = request_irq(IRQ_DMAERR, dma_err_handler, 0, "DMAERR", NULL);
> >>  	if (ret) {
> >>  		printk(KERN_CRIT "Can't register IRQ for DMAERR\n");
> >> -		free_irq(IRQ_DMA, "DMA");
> >> +		free_irq(IRQ_DMA, NULL);
> >>  		return ret;
> >>  	}
> >>
> > Yeah, it's an obvious mistake. Thanks.
> > Because the dma device is just located inside PKUnity-3 SoC, and
> > request_irq() should always return 0, I prefer to remove this free_irq()
> > line.
> 
> Remove the whole if test I guess.  Is there a nce way to indicate that the 
> return value is not needed (eg for the benefit of future bug finding 
> rules)?
> 
> julia
In this case, removing the line containing free_irq() is well enough,
because IRQ_DMA can work even when IRQ_DMAERR doesn't work. And we need
printk and error return value to get potential logical bug information.

Thanks & Regards,

Guan Xuetao

