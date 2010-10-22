Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0JVOD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:03:58 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60238 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab0JVODt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:03:49 -0400
Message-ID: <4CC199D5.1010709@fusionio.com>
Date: Fri, 22 Oct 2010 16:04:05 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: Fix a gcc 4.5 warning and put some comments
References: <20101021182403.GA8378@redhat.com> <4CC1414B.8070102@fusionio.com> <20101022133101.GA7020@redhat.com>
In-Reply-To: <20101022133101.GA7020@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-22 15:31, Vivek Goyal wrote:
> On Fri, Oct 22, 2010 at 09:46:19AM +0200, Jens Axboe wrote:
>> On 2010-10-21 20:24, Vivek Goyal wrote:
>>> - Andi encountedred following warning with gcc 4.5
>>>
>>>   linux/block/cfq-iosched.c: In function ‘cfq_dispatch_requests’:
>>>   linux/block/cfq-iosched.c:2156:3: warning: array subscript is above array
>>>   bounds
>>>
>>> - Warning happens due to following code.
>>>
>>>   slice = group_slice * count /
>>> 		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
>>> 		cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
>>>
>>>   gcc is complaining about cfqg->busy_queues_avg[] being indexed by CFQ
>>>   prio classes (RT, BE and IDLE) while the array size is only 2.
>>>
>>> - At run time, we never access cfqg->busy_queues_avg[IDLE] and return from
>>>   function before this code hits.
>>>
>>> - To fix warning increase the array size though it will remain unused. This
>>>   patch also puts some comments to clarify some of the confusions.
>>>
>>> - I have taken Jens's patch and modified it a bit.
>>>
>>> - Compile tested with gcc 4.4 and boot tested. I don't have gcc 4.5
>>>   running, Andi can you please test it with gcc 4.5 to make sure it
>>>   worked.
>>>
>>> Reported-by: Andi Kleen <ak@linux.intel.com>
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> Thanks, I'll put this one in. BTW, you can't just add a signed-off-by
>> from me (or anyone else, for that matter), they have to be provided
>> explicitly by each individual.
> 
> Ok, sorry about that.
> 
> So in general, if I happen to pick somebody's patch, modify it and repost
> it, how do I reflect the Signed-off-by of original author.

What I usually do is leave the original signed-off-by, then describe my
changes, then add my signed-off-by. I think that is acceptable
behaviour. It's very different from adding a signed-off-by to something
that hasn't been signed-off by the original author yet that's legally an
issue. But hey, IANAL :-)

-- 
Jens Axboe

