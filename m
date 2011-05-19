Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1ESBoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:44:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34144 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab1ESBoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CfUXiIW8eZvPamSve6lrsI8FMSaz7ASZQHz6AoGIBKOV6GOSl4Zp73+X5u6WaT4mlF
         ku0CZdaCeimFPFpu1eY4Mf0neme2pkVV/t6b7CnhnA4JYV0o/fcPbUyFc+DrTfLVsL/P
         t7tBL5vn3UWw+Z3AL5uSm2WAGmzgbMV3WoexA=
MIME-Version: 1.0
In-Reply-To: <BANLkTim0SKAya-S_1h_zvS5rHW5ZOMG7Ow@mail.gmail.com>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
	<BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
	<BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
	<20110512120606.GA3639@zhy>
	<20110518013842.GD23940@home.goodmis.org>
	<BANLkTikOW9t6F8jvTJ0uPvyYDy+mpXh-DA@mail.gmail.com>
	<BANLkTikMdAG4HFmhiB9c3x97FH0N3PnpHA@mail.gmail.com>
	<1305725044.26849.11.camel@gandalf.stny.rr.com>
	<BANLkTinzsjTy6yA7N-ssy5beyJn5NQZX3w@mail.gmail.com>
	<BANLkTim0SKAya-S_1h_zvS5rHW5ZOMG7Ow@mail.gmail.com>
Date: Thu, 19 May 2011 09:44:21 +0800
Message-ID: <BANLkTikFo=CNGf06sRkun7Ab7E0dusd7SQ@mail.gmail.com>
Subject: Re: [PATCH] sched: correct how RT task is picked
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 9:41 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Wed, May 18, 2011 at 10:46 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> On Wed, May 18, 2011 at 9:24 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> On Wed, 2011-05-18 at 21:19 +0800, Hillf Danton wrote:
>>>
>>>> Hi all
>>>>
>>>> The patch is prepared again, in which tests for both cpu and
>>>> nr_cpus_allowed are dropped.
>>>>
>>>> The reason to drop nr_cpus_allowed is to make sure that the
>>>> returned value is correct for both case that cpu == rq->cpu and
>>>> case that cpu != rq->cpu.
>>>
>>> -ENOPARSE
>>>
>>> Why would we pick a task that can't migrate?
>>>
>> Hi Steven
>>
>> For migration, it is the case that cpu != rq->cpu, and
>> if cpu is allowed by task's affinity, it is bug that task
>> could not goto cpu because of nr_cpus_allowed since
>> the nr_cpus_allowed is computed based on the cpus_allowed mask.
>
> But for next_prio(), we just calculate the next highest migratible task
> for a rq regardless on which cpu that task will run, say we let cpu=rq->cpu
> to be second parameter of pick_next_highest_task_rt(), IOW, it has
> the same effect as cpu = -1
>

That means we could get a bound task's priority for the rt_rq's next highest
priority.


> Thanks,
> Yong
>
>
>
> --
> Only stand for myself
>



-- 
Only stand for myself
