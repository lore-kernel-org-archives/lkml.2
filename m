Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2AaPoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:44:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:53530 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2AaPow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:44:52 -0500
Message-ID: <1328024684.2446.234.camel@twins>
Subject: Re: [PATCH] scheduler: domain: init next_balance in
 nohz_idle_balancer with jiffies
From: Peter Zijlstra <peterz@infradead.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Diwakar Tundlam <dtundlam@nvidia.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Date: Tue, 31 Jan 2012 16:44:44 +0100
In-Reply-To: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
References: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 14:44 +0200, Peter De Schrijver wrote:
> From: Diwakar Tundlam <dtundlam@nvidia.com>
> 
> The next_balance parameter of nohz_idle_balancer should be initialized
> to jiffies since jiffies itself is initialized to 300 seconds shy of
> overflow. Otherwise, nohz_idle_balancer does not run for the first 5
> mins after bootup.
> 
> Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
> Reviewed-by: Aleksandr Frid <afrid@nvidia.com>
> Reviewed-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
> Reviewed-by: Satya Popuri <spopuri@nvidia.com>
> ---
>  kernel/sched.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

You'll find that this file no longer exists...

> diff --git a/kernel/sched.c b/kernel/sched.c
> index b5efd6c..d3f291f 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8383,6 +8383,7 @@ void __init sched_init(void)
>  	atomic_set(&nohz.load_balancer, nr_cpu_ids);
>  	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
>  	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
> +	nohz.next_balance = jiffies;
>  #endif
>  	/* May be allocated at isolcpus cmdline parse time */
>  	if (cpu_isolated_map == NULL)

Not does this code section..
