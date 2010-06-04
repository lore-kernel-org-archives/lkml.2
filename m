Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab0FDXPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 19:15:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35041
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757395Ab0FDXPV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 19:15:21 -0400
Date: Fri, 04 Jun 2010 16:15:30 -0700 (PDT)
Message-Id: <20100604.161530.245412851.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: x0066660@ti.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, tony@atomide.com,
       santosh.shilimkar@ti.com, Tristram.Ha@micrel.com
Subject: Re: NULL Pointer Deference: NFS & Telnet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1274906933.2542.17.camel@edumazet-laptop>
References: <1274851741.25136.16.camel@edumazet-laptop>
	<27F9C60D11D683428E133F85D2BB4A53043E3EE6A3@dlee03.ent.ti.com>
	<1274906933.2542.17.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 26 May 2010 22:48:53 +0200

> Le mercredi 26 mai 2010 à 15:19 -0500, Arce, Abraham a écrit :
> 
>> By increasing the allocation length of our rx skbuff the corruption issue is fixed... I have increased it by 2... Were we writing outside our boundaries of skb data?
>> 
>> Please let me know about this approach...
>> 
>> diff --git a/drivers/net/ks8851.c b/drivers/net/ks8851.c
>> index b4fb07a..6da81e1 100644
>> --- a/drivers/net/ks8851.c
>> +++ b/drivers/net/ks8851.c
>> @@ -504,7 +504,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
>>                                ks->rc_rxqcr | RXQCR_SDA | RXQCR_ADRFE);
>> 
>>                 if (rxlen > 0) {
>> -                       skb = netdev_alloc_skb(ks->netdev, rxlen + 2 + 8);
>> +                       skb = netdev_alloc_skb(ks->netdev, rxlen + 4 + 8);
>>                         if (!skb) {
>> 
>> Best Regards
>> Abraham
>> 
> 
> Yes that makes sense, nr_frag is right after the packet (padded to L1
> cache size)
> 
> But please do the correct allocation ?
> 
> Also, we dont need FCS ?

Can we make some progress and get this patch tested and formally
submitted so we can kill this bug?

Thanks!
