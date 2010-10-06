Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab0JFLDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 07:03:33 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:42342 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414Ab0JFLDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 07:03:32 -0400
Message-ID: <4CAC577F.9040401@rsk.demon.co.uk>
Date: Wed, 06 Oct 2010 12:03:27 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Mel Gorman <mel@csn.ul.ie>, npiggin@kernel.dk,
        yanmin_zhang@linux.intel.com
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
References: <20101005185725.088808842@linux.com> <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>
In-Reply-To: <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/10 09:01, Pekka Enberg wrote:
> (Adding more people who've taken interest in slab performance in the
> past to CC.)
> 
> On Tue, Oct 5, 2010 at 9:57 PM, Christoph Lameter <cl@linux.com> wrote:
>> V3->V4:
>> - Lots of debugging
>> - Performance optimizations (more would be good)...
>> - Drop per slab locking in favor of per node locking for
>>  partial lists (queuing implies freeing large amounts of objects
>>  to per node lists of slab).
>> - Implement object expiration via reclaim VM logic.
>>
>> The following is a release of an allocator based on SLAB
>> and SLUB that integrates the best approaches from both allocators. The
>> per cpu queuing is like in SLAB whereas much of the infrastructure
>> comes from SLUB.
>>
>> After this patches SLUB will track the cpu cache contents
>> like SLAB attemped to. There are a number of architectural differences:
>>
>> 1. SLUB accurately tracks cpu caches instead of assuming that there
>>   is only a single cpu cache per node or system.
>>
>> 2. SLUB object expiration is tied into the page reclaim logic. There
>>   is no periodic cache expiration.
>>
>> 3. SLUB caches are dynamically configurable via the sysfs filesystem.
>>
>> 4. There is no per slab page metadata structure to maintain (aside
>>   from the object bitmap that usually fits into the page struct).
>>
>> 5. Has all the resiliency and diagnostic features of SLUB.
>>
>> The unified allocator is a merging of SLUB with some queuing concepts from
>> SLAB and a new way of managing objects in the slabs using bitmaps. Memory
>> wise this is slightly more inefficient than SLUB (due to the need to place
>> large bitmaps --sized a few words--in some slab pages if there are more
>> than BITS_PER_LONG objects in a slab) but in general does not increase space
>> use too much.
>>
>> The SLAB scheme of not touching the object during management is adopted.
>> The unified allocator can efficiently free and allocate cache cold objects
>> without causing cache misses.
>>


Hi Christoph,
What tree are these patches against ? I'm getting patch failures on the
main tree.

regards
Richard
