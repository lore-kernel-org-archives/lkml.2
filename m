Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2BGUEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:04:11 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54582 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2BGUEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:04:09 -0500
MIME-Version: 1.0
In-Reply-To: <ef62da964e8660dfdf2a25cd643631bb15914ecf.1328445742.git.netdev@pradeepdalvi.com>
References: <cf736034e7bd407297e2ea9fbf247fb410eb7b39.1328445742.git.netdev@pradeepdalvi.com>
	<ef62da964e8660dfdf2a25cd643631bb15914ecf.1328445742.git.netdev@pradeepdalvi.com>
Date: Tue, 7 Feb 2012 21:04:07 +0100
X-Google-Sender-Auth: rbQfcYxwEcUmScjIcFJ038cXJ0k
Message-ID: <CAMuHMdXFz5zEWUkrJjNvOqkgt-n2uKc3wzD9H5NKKz1LT4BpOw@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] netdev: ethernet dev_alloc_skb to netdev_alloc_skb
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 13:50, Pradeep A. Dalvi <netdev@pradeepdalvi.com> wrote:
> diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
> index 26e25d7..0452e296 100644
> --- a/drivers/net/ethernet/natsemi/sonic.c
> +++ b/drivers/net/ethernet/natsemi/sonic.c
> @@ -51,7 +51,7 @@ static int sonic_open(struct net_device *dev)
>                printk("sonic_open: initializing sonic driver.\n");
>
>        for (i = 0; i < SONIC_NUM_RRS; i++) {
> -               struct sk_buff *skb = dev_alloc_skb(SONIC_RBSIZE + 2);
> +               struct sk_buff *skb = netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
>                if (skb == NULL) {
>                        while(i > 0) { /* free any that were allocated successfully */
>                                i--;
> @@ -422,7 +422,7 @@ static void sonic_rx(struct net_device *dev)
>                status = sonic_rda_get(dev, entry, SONIC_RD_STATUS);
>                if (status & SONIC_RCR_PRX) {
>                        /* Malloc up new buffer. */
> -                       new_skb = dev_alloc_skb(SONIC_RBSIZE + 2);
> +                       new_skb = netdev_alloc_skb(SONIC_RBSIZE + 2);

drivers/net/ethernet/natsemi/sonic.c:425: error: too few arguments to
function 'netdev_alloc_skb'

cfr. m68k/defconfig http://kisskb.ellerman.id.au/kisskb/buildresult/5583743/

Your search-and-replace script (hmm, you haven't used a script, have
you?) forgot
to add the first "dev" parameter.

>                        if (new_skb == NULL) {
>                                printk(KERN_ERR "%s: Memory squeeze, dropping packet.\n", dev->name);
>                                lp->stats.rx_dropped++;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
