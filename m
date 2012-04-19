Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2DSKhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 06:37:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48830 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753792Ab2DSKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 06:37:35 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18EwpQicE0EzhkAGFcyw+qcbgCxQU5TR0RjYnWTcg
	GWglDOy/7sGjqp
From: Sven Joachim <svenjoac@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, mingo@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rjw@sisk.pl,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Fix oneshot broadcast setup really
References: <alpine.LFD.2.02.1204181205540.2542@ionos>
	<tip-b435092f70ec5ebbfb6d075d5bf3c631b49a51de@git.kernel.org>
	<CAMQu2gx4-4kbgEHXUbU0SR=Xj6pe5FxjYJJ_dZD5D=jZs7f03A@mail.gmail.com>
	<4F8ECD39.3080900@ti.com> <alpine.LFD.2.02.1204181723350.2542@ionos>
	<1334802459.28674.209.camel@sbsiddha-desk.sc.intel.com>
	<alpine.LFD.2.02.1204191028510.2542@ionos>
Date: Thu, 19 Apr 2012 12:37:29 +0200
In-Reply-To: <alpine.LFD.2.02.1204191028510.2542@ionos> (Thomas Gleixner's
	message of "Thu, 19 Apr 2012 10:29:46 +0200 (CEST)")
Message-ID: <87lils3t3q.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.04.2012 um 10:29 schrieb Thomas Gleixner:

> On Wed, 18 Apr 2012, Suresh Siddha wrote:
>> On Wed, 2012-04-18 at 17:31 +0200, Thomas Gleixner wrote:
>> From: Suresh Siddha <suresh.b.siddha@intel.com>
>> Subject: tick: Fix the spurious broadcast timer ticks
>> 
>> During resume, tick_resume_broadcast() programs the broadcast timer
>> in oneshot mode unconditionally. On the platforms where broadcast timer
>> is not really required, this will generate spurious broadcast timer ticks
>> upon resume. For example, on the always running apic timer platforms with
>> HPET, I see spurious hpet tick once every ~5minutes (which is the 32-bit
>> hpet counter wraparound time).
>> 
>> Similar to boot time, during resume make the oneshot mode setting of
>> the broadcast clock event device conditional on the state of active broadcast
>> users. 
>> 
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
> Sven, Santosh, can you confirm that this works for you on top of the
> other two patches?

Works for me, thanks.

>> ---
>>  kernel/time/tick-broadcast.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>> 
>> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
>> index bf57abd..766cd82 100644
>> --- a/kernel/time/tick-broadcast.c
>> +++ b/kernel/time/tick-broadcast.c
>> @@ -346,7 +346,8 @@ int tick_resume_broadcast(void)
>>  						     tick_get_broadcast_mask());
>>  			break;
>>  		case TICKDEV_MODE_ONESHOT:
>> -			broadcast = tick_resume_broadcast_oneshot(bc);
>> +			if (!cpumask_empty(tick_get_broadcast_mask()))
>> +				broadcast = tick_resume_broadcast_oneshot(bc);
>>  			break;
>>  		}
>>  	}

