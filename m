Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1DUNui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:50:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53448 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1DUNuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JzxOSjpfg2fqkHoYVlvM+r/RiSUVFigK0aG9C0Y4c01D3n7Nnds1eWQa54xlja2pJz
         qZzC62l83JX97+ZeqGZ3pUsHWpWLErgSytcLBZ6cORTDdHZ09LXjHIFARnfvKrt5xJVX
         zkh0xG6z20b8q2gUcIVigao0w/4adCfJv4Sl4=
MIME-Version: 1.0
In-Reply-To: <20110421134312.GA3225@zhy>
References: <BANLkTi=41=2_QOMOabg1UrwQ2A06fJAY9w@mail.gmail.com>
	<20110421132904.GA2702@zhy>
	<20110421134312.GA3225@zhy>
Date: Thu, 21 Apr 2011 21:50:35 +0800
Message-ID: <BANLkTik6uerEZfULDQe9kY8L6U7OpP3Q5Q@mail.gmail.com>
Subject: Re: [PATCH] sched: deduplicate mm checks in normalize_rt_tasks()
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 9:43 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Thu, Apr 21, 2011 at 09:29:04PM +0800, Yong Zhang wrote:
>> On Thu, Apr 21, 2011 at 09:15:56PM +0800, Hillf Danton wrote:
>> > When normalizing realtime tasks, only user tasks are concerned by
>> > checking their ->mm.
>> > If the task is not realtime, the -mm is checked again, thus the
>> > overwork could be removed.
>> >
>> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> > ---
>> >
>> > --- a/kernel/sched.c        2011-03-30 03:09:48.000000000 +0800
>> > +++ b/kernel/sched.c        2011-04-21 20:59:28.000000000 +0800
>> > @@ -8364,7 +8364,7 @@ void normalize_rt_tasks(void)
>> >                      * Renice negative nice level userspace
>> >                      * tasks back to 0:
>> >                      */
>> > -                   if (TASK_NICE(p) < 0 && p->mm)
>> > +                   if (TASK_NICE(p) < 0)
>>
>> This looks good.
>>
>> And we can also move TASK_NICE(p) < 0 to the upper if(),
>> like:
>>               if (!rt_task(p) && TASK_NICE(p) < 0) {
>>                       set_user_nice(p, 0);
>>                       continue;
>>               }
>>
>> to reduce one level if() to make code cleaner :)
>
> Damm, I'm wrong here, just ignore it.
>
Hi Yong

We could not be fine every time, right?

thanks
          Hillf

> Yours is good.
>
> Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
>
>>
>> Thanks,
>> Yong
>>
>> >                             set_user_nice(p, 0);
>> >                     continue;
>> >             }
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
