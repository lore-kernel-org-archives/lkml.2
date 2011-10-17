Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1JQMwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:52:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1JQMwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:52:38 -0400
Date: Mon, 17 Oct 2011 14:52:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
In-Reply-To: <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
Message-ID: <Pine.LNX.4.64.1110171023070.18438@axis700.grange>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
 <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:7E/UpGLpS9Y0hHmosrd/gK/+cNmK+4i8kJBWXG8mx5J
 MKCW9ZimV833cWQwtyv3vttvIC/UXGrHwDXyCqBKnDbsFBdZv5
 AK/+MAUlVZMmPq29fBAK1AGdYLLFB/PTXV+cRzrY/d8ue+avcE
 mc7q5lWWwPgF3D54th0iLgktccOSx0D/tJXdqsSStaz8AesOFQ
 Ze6SFLaTHksrJu20yfOPoCdJSWsb7ZYGKlUNTNeldehCCdLTXd
 nCD44B6xZhxrjom126MpZefCz09U3ke7krcUiBmDS4OW3z7lb4
 2UprAXKKyZwCax/IW1jquImTgesxJLyXGQ751/b1AlZZ3JFJlL
 vOqAjxwic6LC1NZOIj5sYNa/W6YC6KsOpx989alk31u3k5HKUe
 Gw8wRaOkfuUtw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A general note to this rework. I haven't been cc'ed on patch 00/10, so, 
replying here. Are we sure it is a good idea to name these new macros like 
this:

MEM_TO_DEV,
DEV_TO_MEM,
...

i.e., without a common namespace? Wouldn't something like DMA_DIRECTION_* 
be better?

On Fri, 14 Oct 2011, Vinod Koul wrote:

> From: Vinod Koul <vinod.koul@linux.intel.com>
> 
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: H Hartley Sweeten <hartleys@visionengravers.com>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Zhang Wei <zw@zh-kernel.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Yong Wang <yong.y.wang@intel.com>
> Cc: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
> Cc: Boojin Kim <boojin.kim@samsung.com>
> Cc: Barry Song <Baohua.Song@csr.com>
> ---

[snip]

> diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
> index 81809c2..cab7d3e 100644
> --- a/drivers/dma/shdma.c
> +++ b/drivers/dma/shdma.c
> @@ -23,7 +23,6 @@
>  #include <linux/interrupt.h>
>  #include <linux/dmaengine.h>
>  #include <linux/delay.h>
> -#include <linux/dma-mapping.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/sh_dma.h>
> @@ -479,19 +478,19 @@ static void sh_dmae_free_chan_resources(struct dma_chan *chan)
>   * @sh_chan:	DMA channel
>   * @flags:	DMA transfer flags
>   * @dest:	destination DMA address, incremented when direction equals
> - *		DMA_FROM_DEVICE or DMA_BIDIRECTIONAL
> + *		DEV_TO_MEM
>   * @src:	source DMA address, incremented when direction equals
> - *		DMA_TO_DEVICE or DMA_BIDIRECTIONAL
> + *		MEM_TO_DEV

Why have you changed the above two comments? Doesn't seem correct to me.

>   * @len:	DMA transfer length
>   * @first:	if NULL, set to the current descriptor and cookie set to -EBUSY
>   * @direction:	needed for slave DMA to decide which address to keep constant,
> - *		equals DMA_BIDIRECTIONAL for MEMCPY
> + *		equals MEM_TO_MEM for MEMCPY
>   * Returns 0 or an error
>   * Locks: called with desc_lock held
>   */
>  static struct sh_desc *sh_dmae_add_desc(struct sh_dmae_chan *sh_chan,
>  	unsigned long flags, dma_addr_t *dest, dma_addr_t *src, size_t *len,
> -	struct sh_desc **first, enum dma_data_direction direction)
> +	struct sh_desc **first, enum dma_transfer_direction direction)
>  {
>  	struct sh_desc *new;
>  	size_t copy_size;
> @@ -531,9 +530,9 @@ static struct sh_desc *sh_dmae_add_desc(struct sh_dmae_chan *sh_chan,
>  	new->direction = direction;
>  
>  	*len -= copy_size;
> -	if (direction == DMA_BIDIRECTIONAL || direction == DMA_TO_DEVICE)
> +	if (direction == MEM_TO_MEM || direction == MEM_TO_DEV)
>  		*src += copy_size;
> -	if (direction == DMA_BIDIRECTIONAL || direction == DMA_FROM_DEVICE)
> +	if (direction == MEM_TO_MEM || direction == DEV_TO_MEM)
>  		*dest += copy_size;
>  
>  	return new;
> @@ -546,12 +545,12 @@ static struct sh_desc *sh_dmae_add_desc(struct sh_dmae_chan *sh_chan,
>   * converted to scatter-gather to guarantee consistent locking and a correct
>   * list manipulation. For slave DMA direction carries the usual meaning, and,
>   * logically, the SG list is RAM and the addr variable contains slave address,
> - * e.g., the FIFO I/O register. For MEMCPY direction equals DMA_BIDIRECTIONAL
> + * e.g., the FIFO I/O register. For MEMCPY direction equals MEM_TO_MEM
>   * and the SG list contains only one element and points at the source buffer.
>   */
>  static struct dma_async_tx_descriptor *sh_dmae_prep_sg(struct sh_dmae_chan *sh_chan,
>  	struct scatterlist *sgl, unsigned int sg_len, dma_addr_t *addr,
> -	enum dma_data_direction direction, unsigned long flags)
> +	enum dma_transfer_direction direction, unsigned long flags)
>  {
>  	struct scatterlist *sg;
>  	struct sh_desc *first = NULL, *new = NULL /* compiler... */;
> @@ -592,7 +591,7 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_sg(struct sh_dmae_chan *sh_c
>  			dev_dbg(sh_chan->dev, "Add SG #%d@%p[%d], dma %llx\n",
>  				i, sg, len, (unsigned long long)sg_addr);
>  
> -			if (direction == DMA_FROM_DEVICE)
> +			if (direction == DEV_TO_MEM)
>  				new = sh_dmae_add_desc(sh_chan, flags,
>  						&sg_addr, addr, &len, &first,
>  						direction);
> @@ -646,13 +645,13 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_memcpy(
>  	sg_dma_address(&sg) = dma_src;
>  	sg_dma_len(&sg) = len;
>  
> -	return sh_dmae_prep_sg(sh_chan, &sg, 1, &dma_dest, DMA_BIDIRECTIONAL,
> +	return sh_dmae_prep_sg(sh_chan, &sg, 1, &dma_dest, MEM_TO_MEM,
>  			       flags);
>  }
>  
>  static struct dma_async_tx_descriptor *sh_dmae_prep_slave_sg(
>  	struct dma_chan *chan, struct scatterlist *sgl, unsigned int sg_len,
> -	enum dma_data_direction direction, unsigned long flags)
> +	enum dma_transfer_direction direction, unsigned long flags)
>  {
>  	struct sh_dmae_slave *param;
>  	struct sh_dmae_chan *sh_chan;
> @@ -996,7 +995,7 @@ static void dmae_do_tasklet(unsigned long data)
>  	spin_lock_irq(&sh_chan->desc_lock);
>  	list_for_each_entry(desc, &sh_chan->ld_queue, node) {
>  		if (desc->mark == DESC_SUBMITTED &&
> -		    ((desc->direction == DMA_FROM_DEVICE &&
> +		    ((desc->direction == DEV_TO_MEM &&
>  		      (desc->hw.dar + desc->hw.tcr) == dar_buf) ||
>  		     (desc->hw.sar + desc->hw.tcr) == sar_buf)) {
>  			dev_dbg(sh_chan->dev, "done #%d@%p dst %u\n",

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
