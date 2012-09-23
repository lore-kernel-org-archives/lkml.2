Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab2IWRq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 13:46:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60687 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2IWRqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 13:46:54 -0400
MIME-Version: 1.0
In-Reply-To: <505F4949.2090509@redhat.com>
References: <1346775269-12191-1-git-send-email-peter.senna@gmail.com>
	<505F4949.2090509@redhat.com>
Date: Sun, 23 Sep 2012 19:46:53 +0200
Message-ID: <CA+MoWDree3U=o8kiMoz5L-3EKC8oBWov+qPbUr5VWMpGKnAZdA@mail.gmail.com>
Subject: Re: [PATCH 5/5] drivers/media/platform/omap3isp/isp.c: fix error
 return code
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 7:39 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Laurent,
>
> Could you please review this patch?
>
> Peter,
>
> Please, always c/c the driver maintainer/author on patches you submit.
>
> You can check it with scripts/get_maintainer.pl.
Sorry for that. I'll be more careful next time. Thanks!

>
> Regards,
> Mauro
>
> -------- Mensagem original --------
> Assunto: [PATCH 5/5] drivers/media/platform/omap3isp/isp.c: fix error return code
> Data: Tue,  4 Sep 2012 18:14:25 +0200
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
>  drivers/media/platform/omap3isp/isp.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index e0096e0..91fcaef 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2102,8 +2102,10 @@ static int __devinit isp_probe(struct platform_device *pdev)
>         if (ret < 0)
>                 goto error;
>
> -       if (__omap3isp_get(isp, false) == NULL)
> +       if (__omap3isp_get(isp, false) == NULL) {
> +               ret = -EBUSY; /* Not sure if EBUSY is best for here */
>                 goto error;
> +       }
>
>         ret = isp_reset(isp);
>         if (ret < 0)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
Peter
