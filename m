Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2FFRUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:20:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49139 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2FFRUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:20:35 -0400
MIME-Version: 1.0
Reply-To: paul.clements@us.sios.com
In-Reply-To: <1338992116-28094-1-git-send-email-loke.chetan@gmail.com>
References: <1338992116-28094-1-git-send-email-loke.chetan@gmail.com>
Date: Wed, 6 Jun 2012 13:20:34 -0400
Message-ID: <CAECXXi5OjRwQ3Ma2k+XGwGWf8E-CMhYsFERxtoSkEjmTktnsfQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] block/nbd: micro-optimization in nbd request completion
From: Paul Clements <paul.clements@steeleye.com>
To: Chetan Loke <loke.chetan@gmail.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes sense. Looks good to me.

Acked-by: Paul.Clements@steeleye.com

On Wed, Jun 6, 2012 at 10:15 AM, Chetan Loke <loke.chetan@gmail.com> wrote:
>
> Add in-flight cmds to the tail. That way while searching(during request completion),we will always get a hit on the first element.
>
>
> Signed-off-by: Chetan Loke <loke.chetan@gmail.com>
> ---
>  drivers/block/nbd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 061427a..8957b9f 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -481,7 +481,7 @@ static void nbd_handle_req(struct nbd_device *nbd, struct request *req)
>                nbd_end_request(req);
>        } else {
>                spin_lock(&nbd->queue_lock);
> -               list_add(&req->queuelist, &nbd->queue_head);
> +               list_add_tail(&req->queuelist, &nbd->queue_head);
>                spin_unlock(&nbd->queue_lock);
>        }
>
> --
> 1.7.5.2
>
