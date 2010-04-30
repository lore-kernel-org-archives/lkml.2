Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab0D3XUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 19:20:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54995
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894Ab0D3XUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 19:20:47 -0400
Date: Fri, 30 Apr 2010 16:20:53 -0700 (PDT)
Message-Id: <20100430.162053.24603839.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: eric.dumazet@gmail.com, sergey.senozhatsky@gmail.com, oleg@redhat.com,
       mingo@elte.hu, a.p.zijlstra@chello.nl, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: r8169 INFO: inconsistent lock state
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100430211556.GA4903@electric-eye.fr.zoreil.com>
References: <20100430182012.GA3329@swordfish.minsk.epam.com>
	<1272661149.2230.11.camel@edumazet-laptop>
	<20100430211556.GA4903@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Fri, 30 Apr 2010 23:15:56 +0200

> Eric Dumazet <eric.dumazet@gmail.com> :
> [...]
>> So we have following illegal chain (process context, not softirq)
>> 
>> rtl8169_reset_task() -> tl8169_rx_interrupt() -> netif_receive_skb()
>> 
>> And normally, commit 630b943c tried to change this chain to :
>> 
>> rtl8169_reset_task() -> tl8169_rx_interrupt() -> netif_rx()
>> 
>> I have no idea why it doesnt work.
> 
> 630b943c appears to be in net-next.
> 
> Oops ?

I just tossed this into net-2.6, thanks for noticing.
