Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab0KAQQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:16:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50226 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0KAQQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bq/YsVtWOByuYDed3IN4r8UE8fzm+VCnPvvNeVwFp6teLbjbSS7hQInUuOm8XubsAB
         JtkvyPSkkYjP2EiAGHZtdwzPTbYKlw0DdvZarKxYHIFn4xqtiox6Zv6SVsrHT5ved/YG
         VX3C0I+1HKCi10Pd2NXAqfFJk5hI1xzGpwnm4=
MIME-Version: 1.0
In-Reply-To: <1288253909-12084-1-git-send-email-mad_soft@inbox.ru>
References: <1288253909-12084-1-git-send-email-mad_soft@inbox.ru>
Date: Mon, 1 Nov 2010 17:16:39 +0100
Message-ID: <AANLkTimMwTbj-2oP-VP7Ht1VnA8_w7vpTGz1kk5HG7zx@mail.gmail.com>
Subject: Re: [PATCH] USB: gadget: fix ethernet gadget crash in gether_setup
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/28 Dmitry Artamonow <mad_soft@inbox.ru>:
> Crash is triggered by commit e6484930d7 ("net: allocate tx queues in
> register_netdevice"), which moved tx netqueue creation into register_netdev.
> So now calling netif_stop_queue() before register_netdev causes an oops.
> Move netif_stop_queue() after net device registration to fix crash.
>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> ---
>  drivers/usb/gadget/u_ether.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
> index 6bb876d..cb23355 100644
> --- a/drivers/usb/gadget/u_ether.c
> +++ b/drivers/usb/gadget/u_ether.c
> @@ -797,7 +797,6 @@ int gether_setup(struct usb_gadget *g, u8 ethaddr[ETH_ALEN])
>         *  - iff DATA transfer is active, carrier is "on"
>         *  - tx queueing enabled if open *and* carrier is "on"
>         */
> -       netif_stop_queue(net);
>        netif_carrier_off(net);
>
>        dev->gadget = g;
> @@ -812,6 +811,7 @@ int gether_setup(struct usb_gadget *g, u8 ethaddr[ETH_ALEN])
>                INFO(dev, "MAC %pM\n", net->dev_addr);
>                INFO(dev, "HOST MAC %pM\n", dev->host_mac);
>
> +               netif_stop_queue(net);
>                the_dev = dev;
>        }
>

What about a race between register_netdev() -> open() -> rest of
gether_setup() ? What is this netif_stop_queue() here needed for?

Best Regards,
Micha³ Miros³aw
