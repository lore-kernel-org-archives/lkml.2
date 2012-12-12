Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108Ab2LLFmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 00:42:20 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:42980 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2LLFmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 00:42:18 -0500
X-Greylist: delayed 1872 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2012 00:42:18 EST
MIME-Version: 1.0
In-Reply-To: <1355271894-5284-3-git-send-email-tipecaml@gmail.com>
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com> <1355271894-5284-3-git-send-email-tipecaml@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 12 Dec 2012 10:40:45 +0530
Message-ID: <CA+V-a8swnn89Nj2t07VRmeyBYuaV__F1fuyPUA8_+-sT3Yd5xQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] media: davinci: fix return value check in vpbe_display_reqbufs().
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Prabhakar Lad <prabhakar.lad@ti.com>, mchehab@redhat.com,
        linux-media@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyril,

On Wed, Dec 12, 2012 at 5:54 AM, Cyril Roelandt <tipecaml@gmail.com> wrote:
> vb2_dma_contig_init_ctx() returns ERR_PTR and never returns NULL, so IS_ERR
> should be used instead of a NULL check.
>
patch fixing this issue has been already posted with a better fix
https://patchwork.kernel.org/patch/1830231/

Regards,
--Prabhakar Lad

> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>  drivers/media/platform/davinci/vpbe_display.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 2bfde79..2db4eff 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -1393,7 +1393,7 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
>         }
>         /* Initialize videobuf queue as per the buffer type */
>         layer->alloc_ctx = vb2_dma_contig_init_ctx(vpbe_dev->pdev);
> -       if (!layer->alloc_ctx) {
> +       if (IS_ERR(layer->alloc_ctx)) {
>                 v4l2_err(&vpbe_dev->v4l2_dev, "Failed to get the context\n");
>                 return -EINVAL;
>         }
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
