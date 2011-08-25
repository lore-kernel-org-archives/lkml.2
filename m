Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1HYOWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:22:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:49168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1HYOWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:22:39 -0400
Subject: Re: [PATCH] perf_event: fix slow and broken cgroup context switch
 code
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ming.m.lin@intel.com
Date: Thu, 25 Aug 2011 16:22:28 +0200
In-Reply-To: <20110825135803.GA4697@quad>
References: <20110825135803.GA4697@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314282148.27911.13.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 15:58 +0200, Stephane Eranian wrote:
> +static inline void perf_event_task_sched_in(struct task_struct *prev,
> +                                           struct task_struct *task)
>  {
>         if (static_branch(&perf_sched_events))
> +               __perf_event_task_sched_in(prev, task);
>  }
>  
> +static inline void perf_event_task_sched_out(struct task_struct *prev,
> +                                            struct task_struct *next)
>  {
>         perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
>  
> +       if (static_branch(&perf_sched_events))
> +               __perf_event_task_sched_out(prev, next);
>  }

BTW, Ingo, is there any particular reason we have these two calls and
not a single perf_event_task_switch() call?
