Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2AKNen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:34:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab2AKNel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:34:41 -0500
Message-ID: <4F0D8FCE.7080202@redhat.com>
Date: Wed, 11 Jan 2012 08:34:06 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: linux-mm@kvack.org, aarcange@redhat.com, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
        Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com
Subject: Re: [PATCH -mm 2/2] mm: kswapd carefully invoke compaction
References: <20120109213156.0ff47ee5@annuminas.surriel.com> <20120109213357.148e7927@annuminas.surriel.com> <CAHGf_=rj=aDVGWXqdq7fh_LrCFnug_mPNuuE=YdXaWpvwyjfzg@mail.gmail.com>
In-Reply-To: <CAHGf_=rj=aDVGWXqdq7fh_LrCFnug_mPNuuE=YdXaWpvwyjfzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 02:25 AM, KOSAKI Motohiro wrote:
>> With CONFIG_COMPACTION enabled, kswapd does not try to free
>> contiguous free pages, even when it is woken for a higher order
>> request.
>>
>> This could be bad for eg. jumbo frame network allocations, which
>> are done from interrupt context and cannot compact memory themselves.
>> Higher than before allocation failure rates in the network receive
>> path have been observed in kernels with compaction enabled.
>>
>> Teach kswapd to defragment the memory zones in a node, but only
>> if required and compaction is not deferred in a zone.
>>
>> Signed-off-by: Rik van Riel<riel@redhat.com>
>
> I agree with we need asynchronous defragmentations feature. But, do we
> really need to use kswapd for compaction? While kswapd take a
> compaction work, it can't work to make free memory.

I believe we do need some background compaction, especially
to help allocations from network interrupts.

If you believe the compaction is better done from some
other thread, I guess we could do that, but truthfully, if
kswapd spends a lot of time doing compaction, I made a
mistake somewhere :)

-- 
All rights reversed
