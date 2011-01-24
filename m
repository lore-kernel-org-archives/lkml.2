Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1AXIH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 03:07:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44887 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1AXIH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 03:07:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=N5Mb9pAKmD4EpIZXcmUDBz/TvgoaL3GhE0wCG4kQu1xfYOGi40ixLpjjacwXOts3zi
         pE7Zy05mX6+YvbR7t1AhVYIbPJ/z7IBhieTOwD5oGBQVyDjQ3bBJQXCP+awFYzB4cM6B
         U7s+bUkMS1Y1bG9LIZaH2+iVP/wlKC1PO34Fc=
MIME-Version: 1.0
In-Reply-To: <1295600887.2601.5.camel@edumazet-laptop>
References: <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
 <1295596533-1748-1-git-send-email-ratbert.chuang@gmail.com> <1295600887.2601.5.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Mon, 24 Jan 2011 16:07:05 +0800
Message-ID: <AANLkTim-u1V3-uPGrKLuG4SSQMY8HGrEThivgYA7XDeJ@mail.gmail.com>
Subject: Re: [PATCH v4] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eric,

On Fri, Jan 21, 2011 at 5:08 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 21 janvier 2011 à 15:55 +0800, Po-Yu Chuang a écrit :
> ...
>> +
>> +     dma_unmap_single(priv->dev, map, skb_headlen(skb), DMA_TO_DEVICE);
>> +
>> +     dev_kfree_skb_irq(skb);
>> +
>> +     ftmac100_txdes_reset(txdes);
>> +
>> +     ftmac100_tx_clean_pointer_advance(priv);
>> +
>> +     priv->tx_pending--;
>> +     netif_wake_queue(netdev);
>> +
>> +     return true;
>> +}
>> +
>
> Thanks to NAPI, you can free skb directly, not queuing it via
> NET_TX_SOFTIRQ softirq, using dev_kfree_skb() instead of
> dev_kfree_skb_irq()

Fixed. Thanks a lot.

best regards,
Po-Yu Chuang
