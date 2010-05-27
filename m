Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0E0XKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:10:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33531
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab0E0XKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:10:03 -0400
Date: Thu, 27 May 2010 16:10:11 -0700 (PDT)
Message-Id: <20100527.161011.104042698.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: torvalds@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: boot crash in arp_error_report()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1274991504.2446.13.camel@edumazet-laptop>
References: <alpine.LFD.2.00.1005271213091.3689@i5.linux-foundation.org>
	<1274989637.2446.1.camel@edumazet-laptop>
	<1274991504.2446.13.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 27 May 2010 22:18:24 +0200

> [PATCH] net: fix __neigh_event_send()
> 
> commit 7fee226ad23 (net: add a noref bit on skb dst) missed one spot
> where an skb is enqueued, with a possibly not refcounted dst entry.
> 
> __neigh_event_send() inserts skb into arp_queue, so we must make sure
> dst entry is refcounted, or dst entry can be freed by garbage collector
> after caller exits from rcu protected section.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.

Ingo can we get a confirmation that this fixes the bootup crash?

Thanks!
