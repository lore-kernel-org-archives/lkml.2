Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0E1IFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 04:05:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab0E1IFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 04:05:42 -0400
Date: Fri, 28 May 2010 10:05:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, torvalds@linux-foundation.org, tglx@linutronix.de,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: boot crash in arp_error_report()
Message-ID: <20100528080531.GA9893@elte.hu>
References: <alpine.LFD.2.00.1005271213091.3689@i5.linux-foundation.org>
 <1274989637.2446.1.camel@edumazet-laptop>
 <1274991504.2446.13.camel@edumazet-laptop>
 <20100527.161011.104042698.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527.161011.104042698.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Thu, 27 May 2010 22:18:24 +0200
> 
> > [PATCH] net: fix __neigh_event_send()
> > 
> > commit 7fee226ad23 (net: add a noref bit on skb dst) missed one spot
> > where an skb is enqueued, with a possibly not refcounted dst entry.
> > 
> > __neigh_event_send() inserts skb into arp_queue, so we must make sure
> > dst entry is refcounted, or dst entry can be freed by garbage collector
> > after caller exits from rcu protected section.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Applied, thanks Eric.
> 
> Ingo can we get a confirmation that this fixes the bootup crash?

Sure, will let you know how it goes.

Thanks,

	Ingo
