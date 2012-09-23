Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2IWV3C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 17:29:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59545 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab2IWV3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 17:29:00 -0400
Date: Sun, 23 Sep 2012 23:28:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: Fwd: [PATCH 1/14] drivers/media/platform/soc_camera/soc_camera.c:
 fix error return code
In-Reply-To: <505F643C.3020203@redhat.com>
Message-ID: <Pine.LNX.4.64.1209232255350.31250@axis700.grange>
References: <1346945041-26676-13-git-send-email-peter.senna@gmail.com>
 <505F643C.3020203@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:AF+6i22CgeQh4A5LXuYRBUiwuA4ON1hDmgnvjWocdjd
 PEf5K5tPArs1/d/hmUOBn3DPxfj9Da1reA5egm5o5l7Hau8MJE
 zouZBi1wK4fspYg+bxXzjwJdrj1Zg9ExrGJbkX5UioRStNW/H9
 PVOtYhy9iS4/s3CzLhieTdhUnHTuo3v+3b+Kdw2PWQ4Fa28i1b
 MTJDh9Qv7vQF38f3u54cN24XZJ3IszcYir++tPQnJWXUdhnmOE
 VE38O/9MIE8umjDwWlwHOyKR7vtwq4D7ZhU8DIW8XoTxHS46Yu
 6pFU/ejfDtmBFkpI4x4oRpeexdRcZK4MjENFy10vvg0HG48JNF
 85psCwsIofNQf5cuX6IAebf9SBrodvag/aGwjb5EmCl5lAA88l
 XIQP29KiF3LiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro, Peter

On Sun, 23 Sep 2012, Mauro Carvalho Chehab wrote:

> Please review.
> Please review.
> 
> Regards,
> Mauro.
> 
> -------- Mensagem original --------
> Assunto: [PATCH 1/14] drivers/media/platform/soc_camera/soc_camera.c: fix error return code
> Data: Thu,  6 Sep 2012 17:24:00 +0200
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
>  drivers/media/platform/soc_camera/soc_camera.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 10b57f8..a4beb6c 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1184,7 +1184,8 @@ static int soc_camera_probe(struct soc_camera_device *icd)
>  	sd->grp_id = soc_camera_grp_id(icd);
>  	v4l2_set_subdev_hostdata(sd, icd);
>  
> -	if (v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler))
> +	ret = v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler);
> +	if (ret)
>  		goto ectrl;

Yes, this is a correct fix. I'm actually also fixing it in one of my 
current experimental patches, I don't think it's occurring too often in 
real life, so, I didn't bother sending a separate fix:-) But yes, let's 
fix it properly. Please, update the other patch to mx2_camera and I'll 
send a "fixes" pull request with these two and an ov2640 fix.

Thanks
Guennadi

>  
>  	/* At this point client .probe() should have run already */

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
