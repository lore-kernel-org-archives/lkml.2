Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3AHOnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:43:21 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:63623 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab3AHOnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:43:19 -0500
MIME-Version: 1.0
In-Reply-To: <1357652409-22907-1-git-send-email-laurent.navet@gmail.com>
References: <1357652409-22907-1-git-send-email-laurent.navet@gmail.com>
Date: Tue, 8 Jan 2013 15:43:19 +0100
Message-ID: <CAH7P7Nh2S9pHyKs=eQ-9YRXeGnH6OV+oZDJAAfbC8y+eaQNLnA@mail.gmail.com>
Subject: Re: [PATCH] drivers: i2c: muxes: fix sizeof(ptr)
From: Laurent Navet <laurent.navet@gmail.com>
To: w.sang@pengutronix.de
Cc: ben-linux@fluff.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not really a bug as mux->busses is a multilevel pointer, so
the result of sizeof(ptr) is the same as sizeof(*ptr).
But I think this is more logical and according to CodingStyle rules like this.
This is also what is done for mux->states a few lines above.

Regards,


2013/1/8, Laurent Navet <laurent.navet@gmail.com>:
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
> diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c
> b/drivers/i2c/muxes/i2c-mux-pinctrl.c
> index 7fa5b24..f958d0f 100644
> --- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
> +++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
> @@ -167,7 +167,7 @@ static int __devinit i2c_mux_pinctrl_probe(struct
> platform_device *pdev)
>  	}
>
>  	mux->busses = devm_kzalloc(&pdev->dev,
> -				   sizeof(mux->busses) * mux->pdata->bus_count,
> +				   sizeof(*mux->busses) * mux->pdata->bus_count,
>  				   GFP_KERNEL);
>  	if (!mux->busses) {
>  		dev_err(&pdev->dev, "Cannot allocate busses\n");
> --
> 1.7.10.4
>
>


-- 
« On ne résout pas un problème avec les modes de pensée qui l’ont engendré. »
« You cannot solve current problems with current thinking. Current
problems are the result of current thinking »
