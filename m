Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978Ab3AHFIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:08:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab3AHFIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:08:54 -0500
Message-ID: <50EBA9DC.9070400@redhat.com>
Date: Tue, 08 Jan 2013 00:08:44 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Shaohua Li <shli@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@redhat.com, hughd@google.com
Subject: Re: [RFC]x86: clearing access bit don't flush tlb
References: <20130107081213.GA21779@kernel.org> <50EAE66B.1020804@redhat.com> <50EB4CB9.9010104@zytor.com> <20130108045519.GB2459@kernel.org> <50EBA8AB.2060003@zytor.com>
In-Reply-To: <50EBA8AB.2060003@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 12:03 AM, H. Peter Anvin wrote:
> On 01/07/2013 08:55 PM, Shaohua Li wrote:
>>
>> I searched a little bit, the change (doing TLB flush to clear access bit) is
>> made between 2.6.7 - 2.6.8, I can't find the changelog, but I found a patch:
>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.7-rc2/2.6.7-rc2-mm2/broken-out/mm-flush-tlb-when-clearing-young.patch
>>
>> The changelog declaims this is for arm/ppc/ppc64.
>>
>
> Not really.  It says that those have stumbled over it already.  It is
> true in general that this change will make very frequently used pages
> (which stick in the TLB) candidates for eviction.

That is only true if the pages were to stay in the TLB for a
very very long time.  Probably multiple seconds.

> x86 would seem to be just as affected, although possibly with a
> different frequency.
>
> Do we have any actual metrics on anything here?

I suspect that if we do need to force a TLB flush for page
reclaim purposes, it may make sense to do that TLB flush
asynchronously. For example, kswapd could kick off a TLB
flush of every CPU in the system once a second, when the
system is under pageout pressure.

We would have to do this in a smart way, so the kswapds
from multiple nodes do not duplicate the work.

If people want that kind of functionality, I would be
happy to cook up an RFC patch.

-- 
All rights reversed
