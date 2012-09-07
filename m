Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab2IGDOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:14:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41474 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab2IGDOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:14:05 -0400
Date: Fri, 7 Sep 2012 11:14:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: mxs-auart: put the device when exit or error
Message-ID: <20120907031416.GJ26709@S2101-09.ap.freescale.net>
References: <20120907024349.GH26709@S2101-09.ap.freescale.net>
 <1346985187-30459-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346985187-30459-1-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 10:33:07AM +0800, Huang Shijie wrote:
> We call the get_device() in the mxs_auart_probe().
> For the balance of the reference count, we should put the
> device in the mxs_auart_remove() or in the error path of
> probe.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/tty/serial/mxs-auart.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
> index 3a667ee..203e512 100644
> --- a/drivers/tty/serial/mxs-auart.c
> +++ b/drivers/tty/serial/mxs-auart.c
> @@ -781,6 +781,7 @@ out_free_irq:
>  	auart_port[pdev->id] = NULL;
>  	free_irq(s->irq, s);
>  out_free_clk:
> +	put_device(s->dev);
>  	clk_put(s->clk);
>  out_free:
>  	kfree(s);
> @@ -796,6 +797,7 @@ static int __devexit mxs_auart_remove(struct platform_device *pdev)
>  
>  	auart_port[pdev->id] = NULL;
>  
> +	put_device(s->dev);
>  	clk_put(s->clk);
>  	free_irq(s->irq, s);
>  	kfree(s);
> -- 
> 1.7.0.4
> 
> 
