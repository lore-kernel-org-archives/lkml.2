Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1GUTcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:32:31 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:37358 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab1GUTc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:32:27 -0400
X-ASG-Debug-ID: 1311276745-03d6a510a91b8240001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E287EC0.4030208@fusionio.com>
Date: Thu, 21 Jul 2011 21:32:16 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "mgorman@suse.de" <mgorman@suse.de>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]vmscan: add block plug for page reclaim
References: <1311130413.15392.326.camel@sli10-conroe>  <CAEwNFnDj30Bipuxrfe9upD-OyuL4v21tLs0ayUKYUfye5TcGyA@mail.gmail.com>  <1311142253.15392.361.camel@sli10-conroe>  <CAEwNFnD3iCMBpZK95Ks+Z7DYbrzbZbSTLf3t6WXDQdeHrE6bLQ@mail.gmail.com> <1311144559.15392.366.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [PATCH]vmscan: add block plug for page reclaim
In-Reply-To: <1311144559.15392.366.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1311276745
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.69589
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-20 08:49, Shaohua Li wrote:
> On Wed, 2011-07-20 at 14:30 +0800, Minchan Kim wrote:
>> On Wed, Jul 20, 2011 at 3:10 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>>> On Wed, 2011-07-20 at 13:53 +0800, Minchan Kim wrote:
>>>> On Wed, Jul 20, 2011 at 11:53 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>>>>> per-task block plug can reduce block queue lock contention and increase request
>>>>> merge. Currently page reclaim doesn't support it. I originally thought page
>>>>> reclaim doesn't need it, because kswapd thread count is limited and file cache
>>>>> write is done at flusher mostly.
>>>>> When I test a workload with heavy swap in a 4-node machine, each CPU is doing
>>>>> direct page reclaim and swap. This causes block queue lock contention. In my
>>>>> test, without below patch, the CPU utilization is about 2% ~ 7%. With the
>>>>> patch, the CPU utilization is about 1% ~ 3%. Disk throughput isn't changed.
>>>>
>>>> Why doesn't it enhance through?
>>> throughput? The disk isn't that fast. We already can make it run in full
>>
>> Yes. Sorry for the typo.
>>
>>> speed, CPU isn't bottleneck here.
>>
>> But you try to optimize CPU. so your experiment is not good.
> it's not that good, because the disk isn't fast. The swap test is the
> workload with most significant impact I can get.

Let me just interject here that a plug should be fine, from 3.1 we'll
even auto-unplug if a certain depth has been reached. So latency should
not be a worry. Personally I think the patch looks fine, though some
numbers would be interesting to see. Cycles spent submitting the actual
IO, combined with IO statistics what kind of IO patterns were observed
for plain and with patch would be good.

-- 
Jens Axboe

