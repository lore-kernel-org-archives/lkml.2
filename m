Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002Ab1IWR2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:28:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54156 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1IWR2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <1316788285-17433-10-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com> <1316788285-17433-10-git-send-email-philipp.reisner@linbit.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 23 Sep 2011 13:28:24 -0400
Message-ID: <CAGZ=bq+Ef+wy8E9taBv=vZfTdvC_VBFFD=GzNqR9Em46U-wMmg@mail.gmail.com>
Subject: Re: [PATCH 09/10] drbd: Remove volume numbers from struct p_header95
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Sep 23, 2011 at 10:31, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> From: Andreas Gruenbacher <agruen@linbit.com>
>
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> ---
[...snip...]
> diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
> index 3310986..99b467e 100644
> --- a/drivers/block/drbd/drbd_main.c
> +++ b/drivers/block/drbd/drbd_main.c
> @@ -717,11 +717,11 @@ static unsigned int prepare_header80(struct p_header80 *h, enum drbd_packet cmd,
>        return sizeof(struct p_header80);
>  }
>
> -static unsigned int prepare_header95(struct p_header95 *h, enum drbd_packet cmd, int size, int vnr)
> +static unsigned int prepare_header95(struct p_header95 *h, enum drbd_packet cmd, int size)
>  {
>        h->magic   = cpu_to_be16(DRBD_MAGIC_BIG);
>        h->command = cpu_to_be16(cmd);
> -       h->vol_n_len = cpu_to_be32(vnr << 24 | size);
> +       h->length = cpu_to_be32(size);
>        return sizeof(struct p_header95);
>  }

This patch needs a commit message indicating why it does not break
compatibility.  If you are guaranteed that the "vnr" passed into
prepare_header95 is always zero, then you should indicate why that is
true.

Cheers,
Kyle Moffett
