Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0FQLlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 07:41:21 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54800 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab0FQLlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 07:41:20 -0400
Message-ID: <4C1A09DF.9070809@kernel.dk>
Date: Thu, 17 Jun 2010 13:41:19 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC PATCH] mm: let the bdi_writeout fraction respond more  quickly
References: <1276523894.1980.85.camel@castor.rsk>	 <1276526681.1980.89.camel@castor.rsk>  <1276714466.1745.625.camel@laptop> <1276774796.1978.11.camel@castor.rsk>
In-Reply-To: <1276774796.1978.11.camel@castor.rsk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-17 13:39, Richard Kennedy wrote:
> On Wed, 2010-06-16 at 20:54 +0200, Peter Zijlstra wrote:
>> On Mon, 2010-06-14 at 15:44 +0100, Richard Kennedy wrote:
>>>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>>>> index 2fdda90..315dd04 100644
>>>> --- a/mm/page-writeback.c
>>>> +++ b/mm/page-writeback.c
>>>> @@ -144,7 +144,7 @@ static int calc_period_shift(void)
>>>>       else
>>>>               dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
>>>>                               100;
>>>> -     return 2 + ilog2(dirty_total - 1);
>>>> +     return ilog2(dirty_total - 1) - 4;
>>>>  } 
>>
>> IIRC I suggested similar things in the past and all we needed to do was
>> find people doing the measurements on different bits of hardware or so..
>>
>> I don't have any problems with the approach, all we need to make sure is
>> that we never return 0 or a negative number (possibly ensure a minimum
>> positive shift value).
> 
> Yep that sounds reasonable. would minimum shift of 4 be ok ?
> 
> something like
> 
> 	max ( (ilog2(dirty_total - 1)- 4) , 4);
> 
> Unfortunately volunteers don't seem to be leaping out of the woodwork,
> maybe Andrew could be persuaded to try this in his tree for a while and
> see if any one squeaks ?

I'm pretty sure that most volunteers are curious what to actually test,
so they shy away from it. If you added a good explanation of an easy way
to test the before and after, then it would be more approachable.

I'll give it a spin here.

-- 
Jens Axboe

