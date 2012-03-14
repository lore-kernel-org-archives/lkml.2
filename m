Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab2CNIn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:43:27 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:53352 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab2CNInW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:43:22 -0400
Message-ID: <1331714575.2389.47.camel@epip-laptop>
Subject: Re: [PATCH 7/7] arch/unicore32/kernel/dma.c: ensure arguments to
 request_irq and free_irq are compatible
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 14 Mar 2012 16:42:55 +0800
In-Reply-To: <20120314081910.GC3163@mwanda>
References: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1331494587-12196-8-git-send-email-Julia.Lawall@lip6.fr>
	 <1331513926.2048.58.camel@epip-laptop>
	 <alpine.DEB.2.02.1203120625570.2066@localhost6.localdomain6>
	 <1331622633.2048.87.camel@epip-laptop>
	 <alpine.DEB.2.02.1203130921250.1974@localhost6.localdomain6>
	 <1331712444.2389.36.camel@epip-laptop> <20120314081910.GC3163@mwanda>
Organization: MPRC, PKU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 11:19 +0300, Dan Carpenter wrote:
> On Wed, Mar 14, 2012 at 04:07:24PM +0800, Guan Xuetao wrote:
> > puv3_init_dma() is called ONCE when initializing.
> > In logical, if request_irq(IRQ_DMAERR, *) failed, free_irq(IRQ_DMA, *)
> > is unnecessary, and dma device/driver can keep on working.
> > The patch could be:
> >   	ret = request_irq(IRQ_DMAERR, dma_err_handler, 0, "DMAERR", NULL);
> >   	if (ret) {
> >   		printk(KERN_CRIT "Can't register IRQ for DMAERR\n");
> >  -		free_irq(IRQ_DMA, "DMA");
> >   		return ret;
> >   	}
> 
> It seems like you should remove the error return as well?
> 
> regards,
> dan carpenter
> 
The error return value will only generate an extra warning message, and
have no side-effect.

Thanks and Regards,
Guan Xuetao


