Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1ASJVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:21:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45671 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1ASJVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:21:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ollr0EvA1+MxwQzRs5KObpxd96oCFicTIX+9MiPdCI7RsDyFxDedsFZj98yhiRt3D2
         jb2kkY8tPYKRIxBmdq6VQF5SOKzNu2aiDrWrPWeWIQLK3vVce4MlLVIvaqh1jmVmTqcW
         hATgvv9xatPyi52YfspG0xhOOxvqZIfLqK/4g=
MIME-Version: 1.0
In-Reply-To: <1295288462.3335.55.camel@edumazet-laptop>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
 <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com> <1295288462.3335.55.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Wed, 19 Jan 2011 17:20:38 +0800
Message-ID: <AANLkTikDkvcDhjEpVL+VK=UTHb5M19Mw167R_z0QwDVW@mail.gmail.com>
Subject: Re: [PATCH v2] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com, bhutchings@solarflare.com, joe@perches.com,
        dilinger@queued.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eric,

On Tue, Jan 18, 2011 at 2:21 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le lundi 17 janvier 2011 à 17:21 +0800, Po-Yu Chuang a écrit :
>> +     spin_lock_irqsave(&priv->tx_lock, flags);
>> +     ftmac100_txdes_set_skb(txdes, skb);
>> +     ftmac100_txdes_set_dma_addr(txdes, map);
>> +
>> +     ftmac100_txdes_set_first_segment(txdes);
>> +     ftmac100_txdes_set_last_segment(txdes);
>> +     ftmac100_txdes_set_txint(txdes);
>> +     ftmac100_txdes_set_buffer_size(txdes, len);
>
> I wonder if its not too expensive to read/modify/write txdes->txdes1
>
> Maybe you should use a temporary u32 var and perform one final write on
> txdes->txdes1 (with the set_dma_own)

That's OK, the compiler combines these bits updates together and write once
since txdes is not volatile. (I checked the object file)
It's not expensive.

BTW, DMA_OWN bit is at txdes0

>> +     priv->tx_pending++;
>> +     if (priv->tx_pending == TX_QUEUE_ENTRIES) {
>> +             if (net_ratelimit())
>> +                     netdev_info(netdev, "tx queue full\n");
>> +
>> +             netif_stop_queue(netdev);
>> +     }
>> +
>> +     /* start transmit */
>> +     ftmac100_txdes_set_dma_own(txdes);
>
>        txdes->txdes1 = txdes1;
>
> BTW, shouldnt you use cpu_to_be32() or cpu_to_le32(), if this driver is
> multi platform ?

OK, but I am not sure if I use them the right way.
Please check my v3 patch later.

Thanks,
Po-Yu Chuang
