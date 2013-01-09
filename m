Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab3AISuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:50:00 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53964 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab3AISt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:49:58 -0500
Date: Wed, 9 Jan 2013 10:49:50 -0800
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rostedt@goodmis.org, Vincent Guittot <vincent.guittot@linaro.org>,
        pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        mingo@redhat.com, peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
Message-ID: <20130109184950.GO3926@htj.dyndns.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
 <ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
 <20121126171539.GZ15971@htj.dyndns.org>
 <CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
 <CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
 <20130104150928.GC15633@mtj.dyndns.org>
 <CAKohpo=hhScCDUnDcqnZx4YzU_8nF1658jmSM_wzsOpSCxXwqA@mail.gmail.com>
 <20130107150422.GB3926@htj.dyndns.org>
 <CAKohponQP7+fUJtTysDiaDNQA0fTCcErb97gpKCxXpshSOuYfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohponQP7+fUJtTysDiaDNQA0fTCcErb97gpKCxXpshSOuYfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 07, 2013 at 11:37:22PM +0530, Viresh Kumar wrote:
> On 7 January 2013 20:34, Tejun Heo <tj@kernel.org> wrote:
> > The latter part "not using idle cpu just for processing work" does
> > apply to homogeneous systems too but as I wrote earlier work items
> > don't spontaneously happen on an idle core.  Something, including
> > timer, needs to kick it.  So, by definition, a CPU already isn't idle
> > when a work item starts execution on it.  What am I missing here?
> 
> We are talking about a core being idle from schedulers perspective :)

But it's not like cpu doesn't consume power if scheduler considers it
idle, right?  Can you please explain in detail how this contributes to
saving power?  Is it primarily about routing work items to lower power
CPUs?  And please don't point to presentation slides.  They don't seem
to explain much better and patches and the code should be able to
describe themselves.  Here, more so, as the desired behavior change
and the resulting powersave are rather subtle.

> > Yeah, this could be a better solution, I think.  Plus, it's not like
> > finding the optimal cpu is free.
> 
> Thanks for the first part (When i shared this idea with Vincent and Amit, i
> wasn't sure at all about the feedback i will get from you and others, but i
> am very happy now :) ).
> 
> I couldn't understand the second part. We still need to search for a free cpu
> for this new routine. And the implementation would almost be same as the
> implementation of queue_work() in my initial patch

I meant that enforcing lookup for the "optimal" cpu on queue_work() by
default would add overhead to the operation, which in cases (on most
homogeneous configs) would lead to overhead without any realized
benefit.

> > Let's start simple for now.  If we really need it, we can always add
> > more later.
> 
> :)
> Agreed. But i liked the idea from steven, we can have two routines:
> queue_work_on_any_cpu() and queue_work_on_cpus()

We can talk about specifics later but please try to *justify* each new
interface.  Please note that "putting work items to cpus which the
scheduler considers idle" can't really be justification in itself.

Thanks.

-- 
tejun
