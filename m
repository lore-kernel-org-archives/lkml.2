Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab1EYEeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 00:34:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42141 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1EYEeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 00:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=d5TFdCmjCOLh7wmJurgOqxMNQEuWi3d8hV/5f9gQ3gViIueYV67nbyHWtKxnnqvTCj
         EqU/R6SPMkzK2PzCUmCPiBh2Q5Hd9rLjIQjNeI53haM0fwrhqP6BMGBfC7L2Sg6IANB4
         tAbze4Icz1tnLqKikyWxUUxt5siFZ7PazGqPU=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=-c_XQOP4FAQEH6FN-9D62HS+tLw@mail.gmail.com>
References: <BANLkTin4OiDiPO3znMvKTVZcYukHReydMQ@mail.gmail.com>
	<1306244383.1465.59.camel@gandalf.stny.rr.com>
	<BANLkTin2r7omjQC9ro0f2_qEc8SzPX33Pg@mail.gmail.com>
	<BANLkTi=-c_XQOP4FAQEH6FN-9D62HS+tLw@mail.gmail.com>
Date: Wed, 25 May 2011 12:34:23 +0800
Message-ID: <BANLkTi=7C1jkKau_Lt7BxJ_PKrzE67incg@mail.gmail.com>
Subject: Re: [PATCH] sched: fix need_resched() when checking peempt
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 11:24 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Tue, May 24, 2011 at 9:50 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> On Tue, May 24, 2011 at 9:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> On Tue, 2011-05-24 at 21:27 +0800, Hillf Danton wrote:
>>>> When checking if current task could be preempted by a newly woken task,
>>>> further check could be bypassed if the current thread is different from
>>>> the current task of run-queue, and it is corrected accordingly.
>>>
>>> Ug, that change log is an obfuscated mess. But looking at the actual
>>> patch, I figured what you wanted to say. How about this:
>>>
>>> ----
>>> The RT preempt check tests the wrong task if NEED_RESCHED is set. It
>>> currently checks the local CPU task. It is suppose to check the task
>>> that is running on the run queue we are about to wake another task on.
>>> ----
>>>
>> Thanks, it is great changelog:)
>
> Good catch.
>
> Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
>
> BTW, this may be the reason for we could trigger
> WARN_ON_ONCE(test_tsk_need_resched(next));
> https://lkml.org/lkml/2010/12/20/28
>
> Peter, Mike, how do you think about it?

Since rq->lock protects both, that issue needs more digging :)

>
> Thanks,
> Yong
>
>
> --
> Only stand for myself
>



-- 
Only stand for myself
