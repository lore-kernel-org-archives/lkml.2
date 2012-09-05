Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab2IEMi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:38:28 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:50278 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab2IEMi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:38:26 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: drbd-dev@lists.linbit.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org, drbd-user@lists.linbit.com
Subject: Re: [Drbd-dev] [PATCH] drbd: use list_move_tail instead of list_del/list_add_tail
Date: Wed, 05 Sep 2012 14:38:23 +0200
Message-ID: <40830346.FXn1k67TTR@fat-tyre>
User-Agent: KMail/4.8.4 (Linux/3.2.0-29-generic; KDE/4.8.4; x86_64; ; )
In-Reply-To: <CAPgLHd_HTYgzRJWvM7wekcm+EiVj24WzrhcOXkj9c1k33z+ARg@mail.gmail.com>
References: <CAPgLHd_HTYgzRJWvM7wekcm+EiVj24WzrhcOXkj9c1k33z+ARg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks, applied.

Best regards,
 Phil
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_move_tail() instead of list_del() + list_add_tail().
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/block/drbd/drbd_worker.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_worker.c
> b/drivers/block/drbd/drbd_worker.c index 6bce2cc..a196281 100644
> --- a/drivers/block/drbd/drbd_worker.c
> +++ b/drivers/block/drbd/drbd_worker.c
> @@ -141,8 +141,7 @@ static void drbd_endio_write_sec_final(struct
> drbd_epoch_entry *e) __releases(lo
> 
>  	spin_lock_irqsave(&mdev->req_lock, flags);
>  	mdev->writ_cnt += e->size >> 9;
> -	list_del(&e->w.list); /* has been on active_ee or sync_ee */
> -	list_add_tail(&e->w.list, &mdev->done_ee);
> +	list_move_tail(&e->w.list, &mdev->done_ee);
> 
>  	/* No hlist_del_init(&e->collision) here, we did not send the Ack yet,
>  	 * neither did we wake possibly waiting conflicting requests.
> 
> 
> _______________________________________________
> drbd-dev mailing list
> drbd-dev@lists.linbit.com
> http://lists.linbit.com/mailman/listinfo/drbd-dev
