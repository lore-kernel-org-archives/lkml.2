Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1IPHlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 03:41:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42206 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab1IPHlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 03:41:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:message-id:date:from:user-agent:
	mime-version:newsgroups:to:cc:subject:references:in-reply-to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=mq/i+q37lbRtU9G25aVK56jbMfr1vsXoLWVJ28GckUuQXqc1R11cF2/xCoD/wqVwS
	IimExRZ57rRf/Jza7L7QA==
Message-ID: <4E72FD93.2060805@google.com>
Date: Fri, 16 Sep 2011 00:41:07 -0700
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Wang Xingchao <xingchao.wang@intel.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        yong.zhang0@gmail.com
Subject: Re: [PATCH] cfs: remove unused 'if' condition checking
References: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
In-Reply-To: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/11 10:35, Wang Xingchao wrote:

Please include a one-line summary such as:
sched: remove extra nr_running check in check_preempt_tick

 > nr_running must be more than 1, so remove the checking
 >

Sure, reasonable.

Please expand this comment though, e.g.
We already test for nr_running > 1 within entity_tick so there is no 
need to recheck it within check_preempt_tick().

 > Signed-off-by: Wang Xingchao<xingchao.wang@intel.com>

Reviewed-by: Paul Turner <pjt@google.com>

 > ---
 >   kernel/sched_fair.c |   16 ++++++++--------
 >   1 files changed, 8 insertions(+), 8 deletions(-)
 >
 > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
 > index 1ca2cd4..fef0bfd 100644
 > --- a/kernel/sched_fair.c
 > +++ b/kernel/sched_fair.c
 > @@ -1106,6 +1106,8 @@ static void
 >   check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 >   {
 >       unsigned long ideal_runtime, delta_exec;
 > +    struct sched_entity *se;
 > +    s64 delta;
 >
 >       ideal_runtime = sched_slice(cfs_rq, curr);
 >       delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
 > @@ -1127,16 +1129,14 @@ check_preempt_tick(struct cfs_rq *cfs_rq, 
struct sched_entity *curr)
 >       if (delta_exec<  sysctl_sched_min_granularity)

You've mangled the white space on the less-than.

 >           return;
 >
 > -    if (cfs_rq->nr_running>  1) {
 > -        struct sched_entity *se = __pick_first_entity(cfs_rq);
 > -        s64 delta = curr->vruntime - se->vruntime;
 > +    se = __pick_first_entity(cfs_rq);
 > +    delta = curr->vruntime - se->vruntime;
 >
 > -        if (delta<  0)
 > -            return;
 > +    if (delta<  0)

And here.

 > +        return;
 >
 > -        if (delta>  ideal_runtime)
 > -            resched_task(rq_of(cfs_rq)->curr);
 > -    }
 > +    if (delta>  ideal_runtime)

Here too.

 > +        resched_task(rq_of(cfs_rq)->curr);
 >   }
 >
 >   static void

