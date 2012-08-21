Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2HUAXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 20:23:45 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61820 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2HUAXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 20:23:43 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-61-5032d50d02ad
From: Namhyung Kim <namhyung@kernel.org>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: changing timeslice in linux
References: <CALKntY0G6WBYT-MGbzQ-e6X_XyRENzeJww7FiLGAgiHtrfwQiA@mail.gmail.com>
	<1345442050.25011.38.camel@marge.simpson.net>
	<CALKntY0dQFxmSz+61Bia-zxpvsQg7kySG1mfk1GVc90YCc27qw@mail.gmail.com>
Date: Tue, 21 Aug 2012 09:16:50 +0900
In-Reply-To: <CALKntY0dQFxmSz+61Bia-zxpvsQg7kySG1mfk1GVc90YCc27qw@mail.gmail.com>
	(Xin Tong's message of "Mon, 20 Aug 2012 07:51:52 -0700")
Message-ID: <87mx1phzf1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012 07:51:52 -0700, Xin Tong wrote:
> On Sun, Aug 19, 2012 at 10:54 PM, Mike Galbraith <efault@gmx.de> wrote:
>> On Sun, 2012-08-19 at 11:58 -0700, Xin Tong wrote:
>>> I have 2 questions about linux 2.6 x86_64 scheduler.
>>>
>>> 1. is the default scheduling algorithm SCHED_NORMAL in linux ?
>>
>> Yes.
> Is there any document describing what the sched_normal is ? it is more
> difficult than SCHED_RR to infer its meaning just based on its name ?
>>
>>> 2. how do i change the time slice in linux source code ?
>>
>> You shouldn't need to.  You can tune "slice" by adjusting
>> sched_latency_ns and sched_min_granularity_ns, but note that "slice" is
>> not a fixed quantum.  Also note that CFS preemption decisions are based
>> upon instantaneous state.  A task may have received a full (variable)
>> "slice" of CPU time, but preemption will be triggered only if a more
>> deserving task is available, so a "slice" is not the "max uninterrupted
>> CPU time" that you may expect it to be.. but it is somewhat similar.
>>
>> -Mike
>>
> This can be done without recompiling and reinstalling the kernel ?
> maybe one simply needs to write to a device file under /dev ?

You can find those files under /proc/sys/kernel/.

Thanks,
Namhyung
