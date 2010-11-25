Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0KYLUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:20:41 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60240 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab0KYLUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:20:40 -0500
Subject: Re: [PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
In-Reply-To: <4ce510d4.0fedd80a.742c.10b9@mx.google.com>
References: <4ce510d4.0fedd80a.742c.10b9@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 12:20:33 +0100
Message-ID: <1290684033.2145.25.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 12:40 +0200, Stephane Eranian wrote:
> @@ -919,6 +945,10 @@ static inline void perf_event_task_sched_in(struct task_struct *task)
>  static inline
>  void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
>  {
> +#ifdef CONFIG_CGROUPS
> +       atomic_t *cgroup_events = &__get_cpu_var(perf_cgroup_events);
> +       COND_STMT(cgroup_events, perf_cgroup_switch(task, next));
> +#endif
>         COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
>  } 

I don't think that'll actually work, the jump label stuff needs a static
address.

Why not simply: s/perf_task_events/perf_sched_events/ and increment it
for cgroup events as well?


