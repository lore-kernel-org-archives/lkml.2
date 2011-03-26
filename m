Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1CZS6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:58:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab1CZS6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:58:42 -0400
Date: Sat, 26 Mar 2011 19:49:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110326184934.GA25969@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com> <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com> <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301164168.2250.370.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Peter Zijlstra wrote:
>
> On Sat, 2011-03-26 at 18:35 +0100, Oleg Nesterov wrote:
> >
> > but probably we also need update_context_time().
>
> It looks like event_sched_out() relies on up-to-date ctx->time through
> perf_event_time() and most call-paths leading to event_sched_out() do
> indeed seem to update the ctx time, all except the move_group branch in
> perf_event_open() afaict.

OK, thanks...

> Sadly the reproducer doesn't seem to trigger the issue at all, its still
> running on a plain -tip kernel.

This test-case is not "perfect", the task should change its CPU after
it closes the last perf_even_fd and before it exits...

But to me, the main question is: I do not understand how this test-case
can ever trigger the problem with HAVE_JUMP_LABEL. But it does.

I didn't try to reproduce, my gcc is old and not-CC_HAVE_ASM_GOTO.

Oleg.

