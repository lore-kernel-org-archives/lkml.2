Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2GIV41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:56:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65486 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab2GIV4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:56:25 -0400
MIME-Version: 1.0
In-Reply-To: <87pq9m30h1.wl%kuninori.morimoto.gx@renesas.com>
References: <87mx4rmqzd.wl%kuninori.morimoto.gx@renesas.com>
 <20120529064621.GB6166@verge.net.au> <20120529070458.GB11445@linux-sh.org>
 <20120529073313.GA21702@verge.net.au> <87k3zvmo4r.wl%kuninori.morimoto.gx@renesas.com>
 <20120529091129.GA26043@verge.net.au> <87txyy347i.wl%kuninori.morimoto.gx@renesas.com>
 <87sjei325k.wl%kuninori.morimoto.gx@renesas.com> <20120530013056.GA31474@verge.net.au>
 <87r4u2310j.wl%kuninori.morimoto.gx@renesas.com> <87pq9m30h1.wl%kuninori.morimoto.gx@renesas.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 9 Jul 2012 22:56:03 +0100
X-Google-Sender-Auth: E08iQEVQuXh3f6aM75QqhmZdDEM
Message-ID: <CACxGe6s+dKvQ07+dzH-84-7sDdmF3uOgTmk7PXS7CzMOHMBySg@mail.gmail.com>
Subject: Re: [PATCH] driver core: fixup reversed deferred probe order
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Paul Mundt <lethal@linux-sh.org>, Rafael <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus <magnus.damm@gmail.com>, Linux-SH <linux-sh@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 2:46 AM, Kuninori Morimoto
<kuninori.morimoto.gx@renesas.com> wrote:
> If driver requests probe deferral,
> it will be added to deferred_probe_pending_list
> by driver_deferred_probe_add(), but, it used list_add().
> Because of that, deferred probe will be run as reversed order.
> This patch uses list_add_tail(), and solved this issue.
>
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

(But not tested; I'm not in a position to test anything at the moment)  :-(

g.

> ---
>  drivers/base/dd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 1b1cbb5..dcb8a6e 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -100,7 +100,7 @@ static void driver_deferred_probe_add(struct device *dev)
>         mutex_lock(&deferred_probe_mutex);
>         if (list_empty(&dev->p->deferred_probe)) {
>                 dev_dbg(dev, "Added to deferred list\n");
> -               list_add(&dev->p->deferred_probe, &deferred_probe_pending_list);
> +               list_add_tail(&dev->p->deferred_probe, &deferred_probe_pending_list);
>         }
>         mutex_unlock(&deferred_probe_mutex);
>  }
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
