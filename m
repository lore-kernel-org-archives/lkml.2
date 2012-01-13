Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab2AMFd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 00:33:59 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38400 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2AMFdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 00:33:55 -0500
MIME-Version: 1.0
In-Reply-To: <1326403988-872-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1326403988-872-1-git-send-email-Julia.Lawall@lip6.fr>
	<1326403988-872-5-git-send-email-Julia.Lawall@lip6.fr>
Date: Fri, 13 Jan 2012 14:33:54 +0900
X-Google-Sender-Auth: 7O6KmNqZaX2Hg52dBcLX_eVFInQ
Message-ID: <CAH9JG2VcYqqvS6uu1upemTrfD_Cfq+4qh6VR=cxRFUT84g9MmQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] drivers/media/video/s5p-mfc/s5p_mfc.c: adjust double test
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Kamil Debski <k.debski@samsung.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All patches.

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

To Marek,
Please collect all patches and send git request pull.

Thank you,
Kyungmin Park

On 1/13/12, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Rewrite a duplicated test to test the correct value
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression E;
> @@
>
> (
> * E
>   || ... || E
> |
> * E
>   && ... && E
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  drivers/media/video/s5p-mfc/s5p_mfc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
> b/drivers/media/video/s5p-mfc/s5p_mfc.c
> index 8be8b54..53126f2 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -475,7 +475,7 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx
> *ctx,
>  			ctx->mv_size = 0;
>  		}
>  		ctx->dpb_count = s5p_mfc_get_dpb_count();
> -		if (ctx->img_width == 0 || ctx->img_width == 0)
> +		if (ctx->img_width == 0 || ctx->img_height == 0)
>  			ctx->state = MFCINST_ERROR;
>  		else
>  			ctx->state = MFCINST_HEAD_PARSED;
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
