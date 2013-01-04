Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3ADVtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:49:14 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41122 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3ADVtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:49:11 -0500
Date: Fri, 04 Jan 2013 13:49:10 -0800 (PST)
Message-Id: <20130104.134910.1157297903826332014.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: bhutchings@solarflare.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        therbert@google.com
Subject: Re: [PATCH v2 net-next] softirq: reduce latencies
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357285780.21409.28416.camel@edumazet-glaptop>
References: <1357250880.2685.29.camel@bwh-desktop.uk.solarflarecom.com>
	<1357252816.21409.26384.camel@edumazet-glaptop>
	<1357285780.21409.28416.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 03 Jan 2013 23:49:40 -0800

> From: Eric Dumazet <edumazet@google.com>
> 
> In various network workloads, __do_softirq() latencies can be up
> to 20 ms if HZ=1000, and 200 ms if HZ=100.
> 
> This is because we iterate 10 times in the softirq dispatcher,
> and some actions can consume a lot of cycles.
> 
> This patch changes the fallback to ksoftirqd condition to :
> 
> - A time limit of 2 ms.
> - need_resched() being set on current task
> 
> When one of this condition is met, we wakeup ksoftirqd for further
> softirq processing if we still have pending softirqs.
 ...
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: David S. Miller <davem@davemloft.net>
