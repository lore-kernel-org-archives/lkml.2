Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab0HZBjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 21:39:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52749 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0HZBjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 21:39:20 -0400
Date: Thu, 26 Aug 2010 10:38:16 +0900
From: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
In-reply-to: <20100825173125.0855a6b0@bike.lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-mm@kvack.org,
        Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Message-id: <4C75C588.7010707@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100805 Icedove/3.0.6
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <1282310110.2605.976.camel@laptop>
 <20100825155814.25c783c7.akpm@linux-foundation.org>
 <20100825173125.0855a6b0@bike.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 08:31 AM, Jonathan Corbet wrote:
> On Wed, 25 Aug 2010 15:58:14 -0700
> Andrew Morton<akpm@linux-foundation.org>  wrote:
>
>    
>>> If you want guarantees you can free stuff, why not add constraints to
>>> the page allocation type and only allow MIGRATE_MOVABLE pages inside a
>>> certain region, those pages are easily freed/moved aside to satisfy
>>> large contiguous allocations.
>>>        
>> That would be good.  Although I expect that the allocation would need
>> to be 100% rock-solid reliable, otherwise the end user has a
>> non-functioning device.  Could generic core VM provide the required level
>> of service?
>>      
> The original OLPC has a camera controller which requires three contiguous,
> image-sized buffers in memory.  That system is a little memory constrained
> (OK, it's desperately short of memory), so, in the past, the chances of
> being able to allocate those buffers anytime some kid decides to start
> taking pictures was poor.  Thus, cafe_ccic.c has an option to snag the
> memory at initialization time and never let go even if you threaten its
> family.  Hell hath no fury like a little kid whose new toy^W educational
> tool stops taking pictures.
>
> That, of course, is not a hugely efficient use of memory on a
> memory-constrained system.  If the VM could reliably satisfy those
> allocation requestss, life would be wonderful.  Seems difficult.  But it
> would be a nicer solution than CMA, which, to a great extent, is really
> just a standardized mechanism for grabbing memory and never letting go.
>    

The main problem is of course fragmentation, for this there is no 
solution in CMA. It has a feature intended to at least reduce memory 
usage though, if only a little bit. It is region sharing. It allows 
platform architects to define regions shared by more than one driver, as 
explained by Michal in the RFC. So we can at least try to reuse each 
chunk of memory as much as possible and not hold separate regions for 
each driver when they are not intended to work simultaneously. Not a 
silver bullet, but is there any though?

>> It would help (a lot) if we could get more attention and buyin and
>> fedback from the potential clients of this code.  rmk's feedback is
>> valuable.  Have we heard from the linux-media people?  What other
>> subsystems might use it?  ieee1394 perhaps?  Please help identify
>> specific subsystems and I can perhaps help to wake people up.
>>      
> If this code had been present when I did the Cafe driver, I would have used
> it.  I think it could be made useful to a number of low-end camera drivers
> if the videobuf layer were made to talk to it in a way which Just Works.
>    

I am working on new videobuf which will (hopefully) Just Work. CMA is 
intended to be pluggable into it, as should be any other allocator for 
that matter.

-- 

Best regards,
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center

