Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1ATPnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:43:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40815 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab1ATPnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dbfmC8nk38UtBUAgjmVe+waUprjVdxMLWb2rFoGP77TmffAlxheUky0KG6F7YukLcU
         tlh6Oj8h4qwEw2Ci0Hg/QAHZepkfmBG29365yEqK5hSchfkD0Olc0CFpmdAnNYtx4+CH
         DPdP0cb1kc9xl/WmMVpPT9ihy+0bDK8wk2Ik0=
MIME-Version: 1.0
In-Reply-To: <1295537746.2825.298.camel@edumazet-laptop>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
 <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com> <1295537746.2825.298.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu, 20 Jan 2011 23:43:17 +0800
Message-ID: <AANLkTi=BHxP465epxWwsZxfVtL7yJOCDRjQ3sKdmSYDp@mail.gmail.com>
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eric,

On Thu, Jan 20, 2011 at 11:35 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 20 janvier 2011 à 23:30 +0800, Po-Yu Chuang a écrit :
>
>> +     /* push packet to protocol stack */
>> +     netif_receive_skb(skb);
>> +
>> +     netdev->stats.rx_packets++;
>> +     netdev->stats.rx_bytes += skb->len;
>> +
>> +     (*processed)++;
>> +
>> +     return true;
>> +}
>> +
>
> Hmm, after call to netif_receive_skb(skb), you are not allowed to access
> skb anymore (maybe it was freed)
>
> netdev->stats.rx_packets++;
> netdev->stats.rx_bytes += skb->len;
> netif_receive_skb(skb);

Wow, you are totally right.

Thanks,
Po-Yu Chuang
