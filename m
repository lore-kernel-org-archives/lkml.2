Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1CAFU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:20:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39670 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1CAFUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:20:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FMnpBcPiyiS4nwJoMka/soOFzFQ+LORY4VqCqd/A60e3UM/WKDeKp5hic7vvYXKpy0
         hTsH6sl6Ca3DSPR7A48Bzg7Zaau92TG0CfTe9DuqIpcN20A/2fRbRbDqHRIqmgDeUkiU
         dDDpC8N574Zqep7CEUYY589WyqHfhB75xyLw0=
MIME-Version: 1.0
In-Reply-To: <1298634040.2659.32.camel@edumazet-laptop>
References: <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
 <1298627845-1583-1-git-send-email-ratbert.chuang@gmail.com> <1298634040.2659.32.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Tue, 1 Mar 2011 13:20:04 +0800
Message-ID: <AANLkTimeDR27Q7fcBmB0ix7Q_pRT_GDpc7S3LO21-fh-@mail.gmail.com>
Subject: Re: [PATCH v6] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Fri, Feb 25, 2011 at 7:40 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 25 février 2011 à 17:57 +0800, Po-Yu Chuang a écrit :
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>>
>> FTMAC100 Ethernet Media Access Controller supports 10/100 Mbps and
>> MII.  This driver has been working on some ARM/NDS32 SoC's including
>> Faraday A320 and Andes AG101.
>>
>> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
>
> It seems fine to me, but I have somes questions
>
> 1) On V5, the receive function ftmac100_rx_packet() was able to process
> several segments per skb. On V6 you process one frag only.
>
> Isnt this NIC able to handle large MTU (say... 9000) ?

No, it isn't. Its max supported packet size is 0x7ff (2047 bytes).

I wasn't sure when will get multi-segment packet. After confirmed with
HW designer two weeks ago, he told me that only if the rx buffer described
by the first descriptor is not big enough, another rx buffer will be used.

That means, since every rx buffer is large enough, it is impossible to
get a multi-segment packets.

So I simplified ftmac100_rx_packet().

>
> 2) ftmac100_alloc_rx_page() is called and allocate a full page for a
> rxdes.
>
> 128*4K -> 512 Kbytes of memory for RX ring
>
> In V5, you were using half pages only, so 256 kbytes of memory.
>
> If you look at other drivers (NIU, BENET), they are able to use exactly
> 128*2 kbytes (for a rxring of 128 slots, and 2Kbytes per slot)

Both NIU and BENET refill rx ring after all packets receive work done,
but I allocate rx buffer right after a packet is received. I think it
is difficult
to use a page for two rx buffers in my driver now. Can we just keep it
the way it is? I can study how to achieve that after current driver is accepted.

best regards,
Po-Yu Chuang
