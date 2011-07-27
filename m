Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1G0DKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:10:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36668 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1G0DJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:09:59 -0400
MIME-Version: 1.0
In-Reply-To: <4E2B17A6.6080602@fusionio.com>
References: <1311130413.15392.326.camel@sli10-conroe>
	<CAEwNFnDj30Bipuxrfe9upD-OyuL4v21tLs0ayUKYUfye5TcGyA@mail.gmail.com>
	<1311142253.15392.361.camel@sli10-conroe>
	<CAEwNFnD3iCMBpZK95Ks+Z7DYbrzbZbSTLf3t6WXDQdeHrE6bLQ@mail.gmail.com>
	<1311144559.15392.366.camel@sli10-conroe>
	<4E287EC0.4030208@fusionio.com>
	<1311311695.15392.369.camel@sli10-conroe>
	<4E2B17A6.6080602@fusionio.com>
Date: Wed, 27 Jul 2011 11:09:58 +0800
X-Google-Sender-Auth: 9HedDqun8u-_yoNLzbSpV3vI0wI
Message-ID: <CANejiEW3hmQJ4WUTkfJ+p+4Wg1Vgp8cHmTOTs1uGMLRae72M7w@mail.gmail.com>
Subject: Re: [PATCH]vmscan: add block plug for page reclaim
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "mgorman@suse.de" <mgorman@suse.de>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/24 Jens Axboe <jaxboe@fusionio.com>:
> On 2011-07-22 07:14, Shaohua Li wrote:
>> On Fri, 2011-07-22 at 03:32 +0800, Jens Axboe wrote:
>>> On 2011-07-20 08:49, Shaohua Li wrote:
>>>> On Wed, 2011-07-20 at 14:30 +0800, Minchan Kim wrote:
>>>>> On Wed, Jul 20, 2011 at 3:10 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>>>>>> On Wed, 2011-07-20 at 13:53 +0800, Minchan Kim wrote:
>>>>>>> On Wed, Jul 20, 2011 at 11:53 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>>>>>>>> per-task block plug can reduce block queue lock contention and increase request
>>>>>>>> merge. Currently page reclaim doesn't support it. I originally thought page
>>>>>>>> reclaim doesn't need it, because kswapd thread count is limited and file cache
>>>>>>>> write is done at flusher mostly.
>>>>>>>> When I test a workload with heavy swap in a 4-node machine, each CPU is doing
>>>>>>>> direct page reclaim and swap. This causes block queue lock contention. In my
>>>>>>>> test, without below patch, the CPU utilization is about 2% ~ 7%. With the
>>>>>>>> patch, the CPU utilization is about 1% ~ 3%. Disk throughput isn't changed.
>>>>>>>
>>>>>>> Why doesn't it enhance through?
>>>>>> throughput? The disk isn't that fast. We already can make it run in full
>>>>>
>>>>> Yes. Sorry for the typo.
>>>>>
>>>>>> speed, CPU isn't bottleneck here.
>>>>>
>>>>> But you try to optimize CPU. so your experiment is not good.
>>>> it's not that good, because the disk isn't fast. The swap test is the
>>>> workload with most significant impact I can get.
>>>
>>> Let me just interject here that a plug should be fine, from 3.1 we'll
>>> even auto-unplug if a certain depth has been reached. So latency should
>>> not be a worry. Personally I think the patch looks fine, though some
>>> numbers would be interesting to see. Cycles spent submitting the actual
>>> IO, combined with IO statistics what kind of IO patterns were observed
>>> for plain and with patch would be good.
>> I can observe the average request size changes. Before the patch, the
>> average request size is about 90k from iostat (but the variation is
>> big). With the patch, the request size is about 100k and variation is
>> small.
>
> That's a good win right there, imho.
>
>> how to check the cycles spend submitting the I/O?
>
> It's not easy, normal profiles is pretty much the only thing to go by.
>
> I guess I'm just a bit puzzled by Minchan's reluctance towards the
> patch, it seems like mostly goodness to me.
akpm,
would you consider picking this up?

Thanks,
Shaohua
