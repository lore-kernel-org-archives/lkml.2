Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3ACWk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:40:26 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63699 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3ACWkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:40:19 -0500
Subject: Re: [PATCH net-next] softirq: reduce latencies
From: Eric Dumazet <erdnetdev@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tom Herbert <therbert@google.com>
In-Reply-To: <1357250880.2685.29.camel@bwh-desktop.uk.solarflarecom.com>
References: <1357216132.21409.24107.camel@edumazet-glaptop>
	 <1357250880.2685.29.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jan 2013 14:40:16 -0800
Message-ID: <1357252816.21409.26384.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 22:08 +0000, Ben Hutchings wrote:
> On Thu, 2013-01-03 at 04:28 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > In various network workloads, __do_softirq() latencies can be up
> > to 20 ms if HZ=1000, and 200 ms if HZ=100.
> > 
> > This is because we iterate 10 times in the softirq dispatcher,
> > and some actions can consume a lot of cycles.
> > 
> > This patch changes the fallback to ksoftirqd condition to :
> > 
> > - A time limit of 2 ms.
> > - need_resched() being set on current task
> [...]
> > --- a/kernel/softirq.c
> > +++ b/kernel/softirq.c
> [...]
> > -#define MAX_SOFTIRQ_RESTART 10
> > +#define MAX_SOFTIRQ_TIME  min(1, (2*HZ/1000))
> [...]
> 
> Really?  Never iterate if HZ < 500?
> 

good catch, it should be max()


