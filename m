Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab2KQXQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 18:16:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2KQXQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 18:16:06 -0500
Date: Sun, 18 Nov 2012 00:16:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Tushar Behera <tushar.behera@linaro.org>
cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 05/14] [media] atmel-isi: Update error check for unsigned
 variables
In-Reply-To: <1353048646-10935-6-git-send-email-tushar.behera@linaro.org>
Message-ID: <Pine.LNX.4.64.1211180014330.30062@axis700.grange>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
 <1353048646-10935-6-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:TEVKlhHXkoBe7i3eM04vfl8uNFYNa8R7dlse68PLFdT
 uUriJ+LemhKQILw7BWRdvvRpnsOFNsF15Qk/twZytJO+2UtITA
 ZQ49OtyGq1ZUp2XZt2LbD3yxRHAaWgs+WPwJHtJ3gWu54L7QfE
 NhWJ8JGB9/oiLUTfo2IrmSlLLvN8jPqmpA01Q+UfMYy/ruFqjT
 mjqaYtmvG3dBOOR+rbgiumr04/juLKUjiMePGKlRnD/2VTFkVo
 P4Vx5NCFjBZVqlxyLQu3kVpQNCNEv55Qz0yN8rY3w6E1mfGycp
 1U2+95F0nJzRmUqu9p0N8od8IElFELpjQPzbCbnTXSX7n430nZ
 seedUtUpwIf+Quf6CZeirk8x9UkvEh/6GVqaaEIDsVrOgbZa+Z
 JFCACub2qQtRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012, Tushar Behera wrote:

> Checking '< 0' for unsigned variables always returns false. For error
> codes, use IS_ERR_VALUE() instead.

Wouldn't just changing "irq" type to "int" also work? I think that would 
be a more straight-forward solution. If however there are strong arguments 
against that, I'm fine with this fix too.

Thanks
Guennadi

> 
> CC: Mauro Carvalho Chehab <mchehab@infradead.org>
> CC: linux-media@vger.kernel.org
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/media/platform/soc_camera/atmel-isi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 6274a91..5bd65df 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -1020,7 +1020,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
>  	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>  
>  	irq = platform_get_irq(pdev, 0);
> -	if (irq < 0) {
> +	if (IS_ERR_VALUE(irq)) {
>  		ret = irq;
>  		goto err_req_irq;
>  	}
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
