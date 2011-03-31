Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab1CaOLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:11:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1CaOLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:11:30 -0400
Date: Thu, 31 Mar 2011 16:10:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110331141040.GA5960@redhat.com>
References: <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com> <20110330130951.GA2124@jolsa.brq.redhat.com> <1301496684.4859.192.camel@twins> <20110331132815.GA4267@redhat.com> <1301579484.4859.277.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301579484.4859.277.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Peter Zijlstra wrote:
>
> On Thu, 2011-03-31 at 15:28 +0200, Oleg Nesterov wrote:
> >
> > OK, synchronize_sched() can't work. How about
> >
> > 	static int force_perf_event_task_sched_out(void *unused)
> > 	{
> > 		struct task_struct *curr = current;
> >
> > 		__perf_event_task_sched_out(curr, task_rq(curr)->idle);
>
> I'd call task_ctx_sched_out() there,

Perhaps... but then we miss perf_cgroup_sched_out(). Anyway, I think
it is better to not optimize this code. If __perf_event_task_sched_in()
was called, it should be paired with __perf_event_task_sched_out().

> we can't actually use struct rq
> outside of sched.c

Yes, this should live in sched.c

> and we know we'll not swap contexts with the idle
> thread.

Yes, that is why it uses next = rq->idle.

> Anyway, I _think_ we can do better..

Yes, agreed. As I said, I don't like this too much.

Oleg.

