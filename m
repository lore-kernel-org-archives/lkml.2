Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966387Ab2ERIyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:54:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45787 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964972Ab2ERIyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:54:20 -0400
Message-ID: <1337331254.573.1.camel@twins>
Subject: Re: [PATCH v2] sched: taint kernel with TAINT_WARN after
 sleep-in-atomic bug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 18 May 2012 10:54:14 +0200
In-Reply-To: <20120510122004.4873.12726.stgit@zurg>
References: <1336650398.27020.91.camel@laptop>
	 <20120510122004.4873.12726.stgit@zurg>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 16:20 +0400, Konstantin Khlebnikov wrote:
> Usually sleep-in-atomic bugs are followed by dozens other warnings.
> This patch should help to figure out original source of problem.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Thanks!

> ---
>  kernel/sched/core.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 0533a68..b6458e4 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3113,6 +3113,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
>  	if (irqs_disabled())
>  		print_irqtrace_events(prev);
>  	dump_stack();
> +	add_taint(TAINT_WARN);
>  }
>  
>  /*
> 

