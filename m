Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2EOEe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 00:34:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32935 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab2EOEe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 00:34:26 -0400
Subject: Re: [PATCH 5/9 v3] serial: sh-sci: prepare for conversion to the
 shdma base library
From: Vinod Koul <vkoul@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
In-Reply-To: <1336576161-27082-6-git-send-email-g.liakhovetski@gmx.de>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
	 <1336576161-27082-6-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 09:57:09 +0530
Message-ID: <1337056029.16185.5363.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 17:09 +0200, Guennadi Liakhovetski wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/tty/serial/sh-sci.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> index bf461cf..49e3b2a 100644
> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c
> @@ -1579,9 +1579,9 @@ static bool filter(struct dma_chan *chan, void *slave)
>  	struct sh_dmae_slave *param = slave;
>  
>  	dev_dbg(chan->device->dev, "%s: slave ID %d\n", __func__,
> -		param->slave_id);
> +		param->shdma_slave.slave_id);
>  
> -	chan->private = param;
> +	chan->private = &param->shdma_slave;
passing stuff using chan->private is a dead road, so don't use it.
>  	return true;
>  }
>  
> @@ -1620,7 +1620,7 @@ static void sci_request_dma(struct uart_port *port)
>  	param = &s->param_tx;
>  
>  	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_TX */
> -	param->slave_id = s->cfg->dma_slave_tx;
> +	param->shdma_slave.slave_id = s->cfg->dma_slave_tx;
>  
>  	s->cookie_tx = -EINVAL;
>  	chan = dma_request_channel(mask, filter, param);
> @@ -1648,7 +1648,7 @@ static void sci_request_dma(struct uart_port *port)
>  	param = &s->param_rx;
>  
>  	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_RX */
> -	param->slave_id = s->cfg->dma_slave_rx;
> +	param->shdma_slave.slave_id = s->cfg->dma_slave_rx;
>  
>  	chan = dma_request_channel(mask, filter, param);
>  	dev_dbg(port->dev, "%s: RX: got channel %p\n", __func__, chan);



