Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1FGJxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:53:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:49018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1FGJxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:53:43 -0400
Subject: Re: [PATCH] sched: remove redundant check in select_task_rq_fair
From: Peter Zijlstra <peterz@infradead.org>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20110607094821.29969.50197.stgit@IBM-009124035060.in.ibm.com>
References: <20110607094821.29969.50197.stgit@IBM-009124035060.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 11:53:34 +0200
Message-ID: <1307440414.2322.236.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 15:18 +0530, Nikunj A. Dadhania wrote:
> When balancing for wakeup affinity, a redundant check can removed.

Yes, tempting, but no, now you've got an extra call to wake_affine(),
which is more expensive.

> Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> ---
>  kernel/sched_fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 433491c..b9e5701 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1753,7 +1753,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  	}
>  
>  	if (affine_sd) {
> -		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
> +		if (wake_affine(affine_sd, p, sync))
>  			prev_cpu = cpu;
>  
>  		new_cpu = select_idle_sibling(p, prev_cpu);
> 

