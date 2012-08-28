Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2H1UP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:15:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40773 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab2H1UP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:15:28 -0400
MIME-Version: 1.0
In-Reply-To: <87mx1phzf1.fsf@sejong.aot.lge.com>
References: <CALKntY0G6WBYT-MGbzQ-e6X_XyRENzeJww7FiLGAgiHtrfwQiA@mail.gmail.com>
	<1345442050.25011.38.camel@marge.simpson.net>
	<CALKntY0dQFxmSz+61Bia-zxpvsQg7kySG1mfk1GVc90YCc27qw@mail.gmail.com>
	<87mx1phzf1.fsf@sejong.aot.lge.com>
Date: Tue, 28 Aug 2012 13:15:27 -0700
Message-ID: <CALKntY02CougnJLANeZwgqB0W8qch2DLN13BYU=j+ooAgji1AQ@mail.gmail.com>
Subject: Re: changing timeslice in linux
From: Xin Tong <xerox.time.tech@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i changed the TIMESLICE defined in the sched.c

  109 /*
  110  * These are the 'tuning knobs' of the scheduler:
  111  *
  112  * default timeslice is 100 msecs (used only for SCHED_RR tasks).
  113  * Timeslices get refilled after they expire.
  114  */
  115 #define DEF_TIMESLICE           (20 * HZ / 1000)


I compiled and installed the modified kernel, but when i looked at the
, i get a different number

root@elm:~# cat /proc/sys/kernel/sched_rt_period_us
1000000


Xin

On Mon, Aug 20, 2012 at 5:16 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Mon, 20 Aug 2012 07:51:52 -0700, Xin Tong wrote:
>> On Sun, Aug 19, 2012 at 10:54 PM, Mike Galbraith <efault@gmx.de> wrote:
>>> On Sun, 2012-08-19 at 11:58 -0700, Xin Tong wrote:
>>>> I have 2 questions about linux 2.6 x86_64 scheduler.
>>>>
>>>> 1. is the default scheduling algorithm SCHED_NORMAL in linux ?
>>>
>>> Yes.
>> Is there any document describing what the sched_normal is ? it is more
>> difficult than SCHED_RR to infer its meaning just based on its name ?
>>>
>>>> 2. how do i change the time slice in linux source code ?
>>>
>>> You shouldn't need to.  You can tune "slice" by adjusting
>>> sched_latency_ns and sched_min_granularity_ns, but note that "slice" is
>>> not a fixed quantum.  Also note that CFS preemption decisions are based
>>> upon instantaneous state.  A task may have received a full (variable)
>>> "slice" of CPU time, but preemption will be triggered only if a more
>>> deserving task is available, so a "slice" is not the "max uninterrupted
>>> CPU time" that you may expect it to be.. but it is somewhat similar.
>>>
>>> -Mike
>>>
>> This can be done without recompiling and reinstalling the kernel ?
>> maybe one simply needs to write to a device file under /dev ?
>
> You can find those files under /proc/sys/kernel/.
>
> Thanks,
> Namhyung
