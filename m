Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1G3OCi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 10:02:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46231 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1G3OCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 10:02:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110730113255.GB2847@redhat.com>
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan>
	<4E318BD0.40202@lwfinger.net>
	<20110730113009.GA2847@redhat.com>
	<20110730113255.GB2847@redhat.com>
Date: Sat, 30 Jul 2011 16:02:27 +0200
Message-ID: <CAOZOX0UqOF-y6h2=-Jxpw=Nn2MJDAWumwy-SBsYsHVUX9mMayw@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 1:32 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> We should clear skb->data not skb itself. Bug was introduced by:
> commit 0b8004aa12d13ec750d102ba4082a95f0107c649 "rt2x00: Properly
> reserve room for descriptors in skbs".
>
> Cc: stable@kernel.org # 2.6.36+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 75d2c6c..f94d669 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -703,8 +703,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>        /*
>         * Add space for the TXWI in front of the skb.
>         */
> -       skb_push(entry->skb, TXWI_DESC_SIZE);
> -       memset(entry->skb, 0, TXWI_DESC_SIZE);
> +       memset(skb_push(entry->skb, TXWI_DESC_SIZE), 0, TXWI_DESC_SIZE);
>
>        /*
>         * Register descriptor details in skb frame descriptor.
> --
> 1.7.4
>
>
