Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3AEApa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 19:45:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab3AEAp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 19:45:28 -0500
Message-ID: <50E77792.8010700@redhat.com>
Date: Fri, 04 Jan 2013 19:45:06 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com
Subject: Re: [RFC PATCH 3/5] x86,smp: auto tune spinlock backoff delay factor
References: <20130103001536.7fd1e952@annuminas.surriel.com> <20130103002341.3cc4b7b4@annuminas.surriel.com> <CANN689Hd01BNYhcBJJBfz7VXJiFM5QikGOLVnokS4Gbq7cT=1g@mail.gmail.com> <50E5BD0F.9040004@redhat.com>
In-Reply-To: <50E5BD0F.9040004@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 12:17 PM, Rik van Riel wrote:

>>> +               if (!(head % 7) && delay < MAX_SPINLOCK_DELAY)
>>> +                       delay++;
>>> +
>>> +               loops = delay * waiters_ahead;
>>
>> I don't like the head % 7 thing. I think using fixed point arithmetic
>> would be nicer:
>>
>> if (delay < MAX_SPINLOCK_DELAY)
>>    delay += 256/7; /* Or whatever constant we choose */
>>
>> loops = (delay * waiter_ahead) >> 8;
>
> I'll do that. That could get completely rid of any artifacts
> caused by incrementing sometimes, and not other times.
>
>> Also, we should probably skip the delay increment on the first loop
>> iteration - after all, we haven't waited yet, so we can't say that the
>> delay was too short.
>
> Good point. I will do that.

> I will build a kernel with the things you pointed out fixed,
> and will give it a spin this afternoon.
>
> Expect new patches soonish :)

After implementing all the ideas you came up with, which made
perfect sense to me, the code performs significantly worse
than before.

*sigh*

New patches will be coming ... later.

-- 
All rights reversed
