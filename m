Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab2ERLDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:03:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:55305 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2ERLDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:03:03 -0400
Message-ID: <1337338974.573.27.camel@twins>
Subject: Re: [tip:sched/core] sched: Set TAINT_UNSAFE_SMP after
 sleep-in-atomic bug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, akpm@linux-foundation.org, khlebnikov@openvz.org,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Date: Fri, 18 May 2012 13:02:54 +0200
In-Reply-To: <tip-1d76f4381601a259323ad4faadce18db08ddebcd@git.kernel.org>
References: <20120517232210.A292EA02FF@akpm.mtv.corp.google.com>
	 <tip-1d76f4381601a259323ad4faadce18db08ddebcd@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 03:48 -0700, tip-bot for Konstantin Khlebnikov
wrote:
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

This is the patch I objected to.. 

> +++ b/kernel/sched/core.c
> @@ -3138,6 +3138,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
>  	if (irqs_disabled())
>  		print_irqtrace_events(prev);
>  	dump_stack();
> +	add_taint(TAINT_UNSAFE_SMP);
>  }

This should very much be TAINT_WARN.. it has nothing what so ever to do
with SMP.
