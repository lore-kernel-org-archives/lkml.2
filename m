Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab3ADIPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 03:15:54 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53153 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751448Ab3ADIPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 03:15:52 -0500
Message-ID: <1357287351.5452.44.camel@joe-AO722>
Subject: Re: [PATCH v2 net-next] softirq: reduce latencies
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tom Herbert <therbert@google.com>
Date: Fri, 04 Jan 2013 00:15:51 -0800
In-Reply-To: <1357285780.21409.28416.camel@edumazet-glaptop>
References: <1357216132.21409.24107.camel@edumazet-glaptop>
	 <1357250880.2685.29.camel@bwh-desktop.uk.solarflarecom.com>
	 <1357252816.21409.26384.camel@edumazet-glaptop>
	 <1357285780.21409.28416.camel@edumazet-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 23:49 -0800, Eric Dumazet wrote:
> In various network workloads, __do_softirq() latencies can be up
> to 20 ms if HZ=1000, and 200 ms if HZ=100.
> This patch changes the fallback to ksoftirqd condition to :
> - A time limit of 2 ms.

[]
> diff --git a/kernel/softirq.c b/kernel/softirq.c
[]
> +#define MAX_SOFTIRQ_TIME  max(1, (2*HZ/1000))

And if HZ is 10000?
 
>  asmlinkage void __do_softirq(void)
>  {
[]
> +	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;

Perhaps MAX_SOFTIRQ_TIME should be

#define MAX_SOFTIRQ_TIME msecs_to_jiffies(2)

though it would be nicer if it were a compile time constant.


