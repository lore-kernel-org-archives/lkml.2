Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2IWVPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 17:15:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64940 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab2IWVPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 17:15:38 -0400
Date: Sun, 23 Sep 2012 23:15:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: Fwd: [PATCH 2/14] drivers/media/platform/soc_camera/mx2_camera.c:
 fix error return code
In-Reply-To: <505F6461.8090401@redhat.com>
Message-ID: <Pine.LNX.4.64.1209232313500.31250@axis700.grange>
References: <1346945041-26676-12-git-send-email-peter.senna@gmail.com>
 <505F6461.8090401@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:zhlFKIB34oRrCMZ0KfNOFBc/CggIgVd4+/yttJaV7NB
 aKeVLEUDNSXG/HlEOwXaHeh8MaUYZFB+LzgUmmqsFCjgyIyUPy
 YXhuqg34p5TXdzGBQbmi++EMfbAlulN/pGMTWxbWgKX+CgmbHJ
 E6Ywt9r0HtXm32Espqj7AAplH+PJwap9RDQ8wYupE+3kP0hp25
 GoLJyktbp2e1/IoiI8/kOmRn61FmUng/HJscIpn6izNNBrf7O9
 vcSzlUlY2xi0toVueo/D+SS9qmUJxBgen7QOd8I6Dts5BHPZvv
 g4MTJcMNbYwbJ82Rwfau7/ZkBqUO0tHhaW/AKZdD4AyEZQWt/C
 gh/TBByUtkHZsxksQaz6NUSEpMhd+FAY/xXzHhND42KcGqQE96
 psp0tfJzjx6YA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter

Thanks for the patch, but I think it can be improved:

On Sun, 23 Sep 2012, Mauro Carvalho Chehab wrote:

> Please review,
> 
> Regards,
> Mauro.
> 
> 
> -------- Mensagem original --------
> Assunto: [PATCH 2/14] drivers/media/platform/soc_camera/mx2_camera.c: fix error return code
> Data: Thu,  6 Sep 2012 17:23:59 +0200
> De: Peter Senna Tschudin <peter.senna@gmail.com>
> Para: Mauro Carvalho Chehab <mchehab@infradead.org>
> CC: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
> 
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> ---
>  drivers/media/platform/soc_camera/mx2_camera.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
> index 256187f..f8884a7 100644
> --- a/drivers/media/platform/soc_camera/mx2_camera.c
> +++ b/drivers/media/platform/soc_camera/mx2_camera.c
> @@ -1800,13 +1800,16 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  
>  		if (!res_emma || !irq_emma) {
>  			dev_err(&pdev->dev, "no EMMA resources\n");
> +			err = -ENODEV;
>  			goto exit_free_irq;
>  		}
>  
>  		pcdev->res_emma = res_emma;
>  		pcdev->irq_emma = irq_emma;
> -		if (mx27_camera_emma_init(pcdev))
> +		if (mx27_camera_emma_init(pcdev)) {
> +			err = -ENODEV;

I think, propagating the error, returned by mx27_camera_emma_init() to the 
caller would be better, than using -ENODEV.

Thanks
Guennadi

>  			goto exit_free_irq;
> +		}
>  	}
>  
>  	pcdev->soc_host.drv_name	= MX2_CAM_DRV_NAME,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
