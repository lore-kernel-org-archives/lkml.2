Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2IGCni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:43:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33501 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab2IGCng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:43:36 -0400
Date: Fri, 7 Sep 2012 10:43:52 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <shijie8@gmail.com>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] serial: mxs-auart: put the device in
 mxs_auart_probe()
Message-ID: <20120907024349.GH26709@S2101-09.ap.freescale.net>
References: <1346985521-2248-1-git-send-email-shijie8@gmail.com>
 <1346985521-2248-2-git-send-email-shijie8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346985521-2248-2-git-send-email-shijie8@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 10:38:41PM -0400, Huang Shijie wrote:
> We call the get_device() in the mxs_auart_probe().
> For the balance of the reference count, we should put the
> device in the mxs_auart_remove().
> 
> Signed-off-by: Huang Shijie <shijie8@gmail.com>
> ---
>  drivers/tty/serial/mxs-auart.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
> index ea5f888..6898413 100644
> --- a/drivers/tty/serial/mxs-auart.c
> +++ b/drivers/tty/serial/mxs-auart.c
> @@ -796,6 +796,7 @@ static int __devexit mxs_auart_remove(struct platform_device *pdev)
>  
>  	auart_port[pdev->id] = NULL;
>  
> +	put_device(s->dev);
>  	clk_put(s->clk);
>  	free_irq(s->irq, s);
>  	kfree(s);

So the error path of probe needs function fixing too, right?

-- 
Regards,
Shawn
