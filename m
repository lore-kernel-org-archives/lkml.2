Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2IETqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:46:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55301 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab2IETqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:46:20 -0400
MIME-Version: 1.0
In-Reply-To: <1346775269-12191-2-git-send-email-peter.senna@gmail.com>
References: <1346775269-12191-2-git-send-email-peter.senna@gmail.com>
Date: Wed, 5 Sep 2012 16:46:20 -0300
Message-ID: <CALF0-+UiJy-mcB7U003dCqmQp2ziiTKrTehh3E-2C6FU2bfvkQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] drivers/media/platform/vino.c: fix error return code
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Sep 4, 2012 at 1:14 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
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
>  drivers/media/platform/vino.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/platform/vino.c b/drivers/media/platform/vino.c
> index cc9110c..6654a28 100644
> --- a/drivers/media/platform/vino.c
> +++ b/drivers/media/platform/vino.c
> @@ -2061,6 +2061,7 @@ static int vino_capture_next(struct vino_channel_settings *vcs, int start)
>         }
>         if (incoming == 0) {
>                 dprintk("vino_capture_next(): no buffers available\n");
> +               err = -ENOMEM;
>                 goto out;
>         }
>

Mmm, this one doesn't look good.

I think the intention was to return zero, without error.
They driver tt's just double-checking for incoming data, if there's no incoming
data, then he simply exits.

Thanks,
Ezequiel.
