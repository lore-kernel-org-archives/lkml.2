Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab0GTHE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:04:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45639 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab0GTHE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:04:57 -0400
Message-ID: <4C454A8D.9060102@cs.helsinki.fi>
Date: Tue, 20 Jul 2010 10:04:45 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org
Subject: Re: [PATCH] slab: use deferable timers for its periodic housekeeping
References: <4C44928E.8060506@linux.intel.com>
In-Reply-To: <4C44928E.8060506@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] slab: use deferable timers for its periodic housekeeping
> 
> slab has a "once every 2 second" timer for its housekeeping.
> As the number of logical processors is growing, its more and more
> common that this 2 second timer becomes the primary wakeup source.
> 
> This patch turns this housekeeping timer into a deferable timer,
> which means that the timer does not interrupt idle, but just runs
> at the next event that wakes the cpu up.
> 
> The impact is that the timer likely runs a bit later, but during the
> delay no code is running so there's not all that much reason for
> a difference in housekeeping to occur because of this delay.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  mm/slab.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 7451bda..ef3cd3d 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -884,7 +884,7 @@ static void __cpuinit start_cpu_timer(int cpu)
>       */
>      if (keventd_up() && reap_work->work.func == NULL) {
>          init_reap_node(cpu);
> -        INIT_DELAYED_WORK(reap_work, cache_reap);
> +        INIT_DELAYED_WORK_DEFERRABLE(reap_work, cache_reap);
>          schedule_delayed_work_on(cpu, reap_work,
>                      __round_jiffies_relative(HZ, cpu));
>      }

[ The patch seems to have been whitespace damaged. ]

Applied, thanks!
