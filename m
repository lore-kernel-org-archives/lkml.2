Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1FCSQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:16:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1FCSQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:16:40 -0400
Date: Fri, 3 Jun 2011 20:16:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Andre Bartke <andre.bartke@googlemail.com>
cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andre Bartke <andre.bartke@gmail.com>
Subject: Re: [PATCH] drivers/media: fix uninitialized variable
In-Reply-To: <1307121721-6658-1-git-send-email-andre.bartke@gmail.com>
Message-ID: <Pine.LNX.4.64.1106032016170.5065@axis700.grange>
References: <1307121721-6658-1-git-send-email-andre.bartke@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:P8NF8DfIFaPEfJc6X/VuQ5OJpWDJxSvA2Zyu7YBW1Ud
 W4nnr4WEvTuPnHTcQ6SOHdfHaEfEpzK3AwIA8PN4SBET02fYEA
 EXZhpQ8RGBEBawOSWw4uSWY2VTlQCTgtcp4ZLQWjZpBiMZnqn3
 MYCzEJ+q85O60JKlJAn8qAyobvs4yoUbDYXdNF8DMiUWTTMg9+
 Rf3EzLqo1K4/+S6dSLOMIJi3fdae9DuPGqJ4qpvdTQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011, Andre Bartke wrote:

> mx1_camera_add_device() can return an
> uninitialized value of ret.
> 
> Signed-off-by: Andre Bartke <andre.bartke@gmail.com>

Thanks, will push to 3.0

Guennadi

> ---
>  drivers/media/video/mx1_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
> index bc0c23a..d9fc4b2 100644
> --- a/drivers/media/video/mx1_camera.c
> +++ b/drivers/media/video/mx1_camera.c
> @@ -444,7 +444,7 @@ static int mx1_camera_add_device(struct soc_camera_device *icd)
>  {
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>  	struct mx1_camera_dev *pcdev = ici->priv;
> -	int ret;
> +	int ret = 0;
>  
>  	if (pcdev->icd) {
>  		ret = -EBUSY;
> -- 
> 1.7.5.2
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
