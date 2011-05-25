Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab1EYDYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:24:32 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57066 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab1EYDYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bAJ0LvKPgptfslHx6d3KoMcbYSjdM9h7oIOdqhTfSDYk7PNwK8d/oJEU3DZVH++jM/
         uej9l+yXXKKbK5mWT4WlH4nk56R9FtgMkNr3bShYRXi6FieSTV2yN6RhuGm7rzcLsAK8
         zVVJaUhEQNSPJmthwaC9EgtxNbDJta3FvEhlI=
MIME-Version: 1.0
In-Reply-To: <BANLkTin2r7omjQC9ro0f2_qEc8SzPX33Pg@mail.gmail.com>
References: <BANLkTin4OiDiPO3znMvKTVZcYukHReydMQ@mail.gmail.com>
	<1306244383.1465.59.camel@gandalf.stny.rr.com>
	<BANLkTin2r7omjQC9ro0f2_qEc8SzPX33Pg@mail.gmail.com>
Date: Wed, 25 May 2011 11:24:30 +0800
Message-ID: <BANLkTi=-c_XQOP4FAQEH6FN-9D62HS+tLw@mail.gmail.com>
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

On Tue, May 24, 2011 at 9:50 PM, Hillf Danton <dhillf@gmail.com> wrote:
> On Tue, May 24, 2011 at 9:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Tue, 2011-05-24 at 21:27 +0800, Hillf Danton wrote:
>>> When checking if current task could be preempted by a newly woken task,
>>> further check could be bypassed if the current thread is different from
>>> the current task of run-queue, and it is corrected accordingly.
>>
>> Ug, that change log is an obfuscated mess. But looking at the actual
>> patch, I figured what you wanted to say. How about this:
>>
>> ----
>> The RT preempt check tests the wrong task if NEED_RESCHED is set. It
>> currently checks the local CPU task. It is suppose to check the task
>> that is running on the run queue we are about to wake another task on.
>> ----
>>
> Thanks, it is great changelog:)

Good catch.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

BTW, this may be the reason for we could trigger
WARN_ON_ONCE(test_tsk_need_resched(next));
https://lkml.org/lkml/2010/12/20/28

Peter, Mike, how do you think about it?

Thanks,
Yong


-- 
Only stand for myself
