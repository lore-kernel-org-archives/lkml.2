Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab2CaJw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 05:52:58 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:54646 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab2CaJwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 05:52:55 -0400
Message-ID: <4F76D3E5.6050605@permonline.ru>
Date: Sat, 31 Mar 2012 15:52:37 +0600
From: Mike Sinkovsky <msink@permonline.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] Ethernet driver for the WIZnet W5100 chip
References: <1332752876-1650-1-git-send-email-msink@permonline.ru> <1333090806-27988-2-git-send-email-msink@permonline.ru> <1333099431.19659.15.camel@edumazet-laptop>
In-Reply-To: <1333099431.19659.15.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

30.03.2012 15:23, Eric Dumazet написал:

>> +static int w5100_start_tx(struct sk_buff *skb, struct net_device *ndev)
>> +{
>> +	struct w5100_priv *priv = netdev_priv(ndev);
>> +	u16 offset;
>> +
>> +	if (w5100_read16(priv, W5100_S0_TX_FSR)<  skb->len) {
>
> There is a race here.
> Interrupt came come right here before you set the stop_queue()
>
>> +		netif_stop_queue(ndev);
>
> So Here I suggest adding a test again
> 	
> 	if (w5100_read16(priv, W5100_S0_TX_FSR)>= skb->len)
> 		netif_wake_queue(ndev);
> 	else
> 		return NETDEV_TX_BUSY;
>
>> +		return NETDEV_TX_BUSY;

Maybe, but I cannot test this, sorry - when I set breakpoint on this 
branch - it never triggered, on all my tests on all boards.
Appears that my processor is too slow and cannot feed packets fast enough.

But will do, maybe it triggers for someone on fastest processors.

-- 
Mike

