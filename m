Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3AHTc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 14:32:28 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:5519 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3AHTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 14:32:26 -0500
Date: Tue, 8 Jan 2013 20:32:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: i2c: muxes: fix sizeof(ptr)
Message-ID: <20130108203211.6df938ff@endymion.delvare>
In-Reply-To: <1357652409-22907-1-git-send-email-laurent.navet@gmail.com>
References: <1357652409-22907-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Jan 2013 14:40:09 +0100, Laurent Navet wrote:
> sizeof when applied to a pointer typed expression gives the size of
> the pointer
> 
> The semantic patch that makes this output is available
> in scripts/coccinelle/misc/noderef.cocci.
> 
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/i2c/muxes/i2c-mux-pinctrl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
> index 7fa5b24..f958d0f 100644
> --- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
> +++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
> @@ -167,7 +167,7 @@ static int __devinit i2c_mux_pinctrl_probe(struct platform_device *pdev)
>  	}
>  
>  	mux->busses = devm_kzalloc(&pdev->dev,
> -				   sizeof(mux->busses) * mux->pdata->bus_count,
> +				   sizeof(*mux->busses) * mux->pdata->bus_count,
>  				   GFP_KERNEL);
>  	if (!mux->busses) {
>  		dev_err(&pdev->dev, "Cannot allocate busses\n");

Good catch.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
