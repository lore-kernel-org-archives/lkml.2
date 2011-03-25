Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab1CYMTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:19:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1CYMTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:19:35 -0400
Subject: Re: deadlock caused by printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <tom.leiming@gmail.com>
Cc: torvalds@osdl.org, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinCk35LSMLyO0nD+Z1ZmZskaCCN5c8kyxLcmXYx@mail.gmail.com>
References: <AANLkTinCk35LSMLyO0nD+Z1ZmZskaCCN5c8kyxLcmXYx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 13:21:38 +0100
Message-ID: <1301055698.2250.198.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 20:15 +0800, Ming Lei wrote:
> Hi,
> 
> These days I was studying "perf code" and try to dump some debug
> info in event_sched_out(): kernel/perf_event.c by printk, but found
> system can hang easily.
> 
> After digging into related code for several days, I find the hang is
> caused by spinlock deadlock when acquiring rq->lock in task_rq_lock(),
> which is called in the path below:
> 
>           try_to_wake_up<-wake_up_process<-up<-console_unlock<-printk.
> 
> I wonder if there are some usage conventions about printk, which says
> explicitly that printk can not by used in some places of kernel. Or does the
> above show that it is a bug of kernel?
> 
> If the above is really a limitation of printk, have we other dump functions
> which may be used safely in some places of kernel source code where
> printk is not allowed.

Don't use printk from NMI context, that's never going to work well.

One thing you could to is use trace_printk() and use ftrace to debug
perf.

