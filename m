Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1LLOlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:41:13 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61052 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab1LLOlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:41:10 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Mel Gorman" <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 04/11] mm: compaction: export some of the functions
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
 <1321634598-16859-5-git-send-email-m.szyprowski@samsung.com>
 <20111212142906.GE3277@csn.ul.ie>
Date: Mon, 12 Dec 2011 15:41:04 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v6dseqji3l0zgt@mpn-glaptop>
In-Reply-To: <20111212142906.GE3277@csn.ul.ie>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 15:29:07 +0100, Mel Gorman <mel@csn.ul.ie> wrote:

> On Fri, Nov 18, 2011 at 05:43:11PM +0100, Marek Szyprowski wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>>
>> This commit exports some of the functions from compaction.c file
>> outside of it adding their declaration into internal.h header
>> file so that other mm related code can use them.
>>
>> This forced compaction.c to always be compiled (as opposed to being
>> compiled only if CONFIG_COMPACTION is defined) but as to avoid
>> introducing code that user did not ask for, part of the compaction.c
>> is now wrapped in on #ifdef.
>>
>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>  mm/Makefile     |    3 +-
>>  mm/compaction.c |  112 +++++++++++++++++++++++--------------------------------
>>  mm/internal.h   |   35 +++++++++++++++++
>>  3 files changed, 83 insertions(+), 67 deletions(-)
>>
>> diff --git a/mm/Makefile b/mm/Makefile
>> index 50ec00e..24ed801 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -13,7 +13,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
>>  			   readahead.o swap.o truncate.o vmscan.o shmem.o \
>>  			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
>>  			   page_isolation.o mm_init.o mmu_context.o percpu.o \
>> -			   $(mmu-y)
>> +			   $(mmu-y) compaction.o
>
> That should be
>
> compaction.o $(mmu-y)
>
> for consistency.
>
> Overall, this patch implies that CMA is always compiled in.

Not really.  But yes, it produces some bloat when neither CMA nor
compaction are compiled.  I assume that linker will be able to deal
with that (since the functions are not EXPORT_SYMBOL'ed).

Note also that the was majority of compaction.c is #ifdef'd though
so only a handful of functions are compiled.

> Why not just make CMA depend on COMPACTION to keep things simplier?

I could imagine that someone would want to have CMA but not compaction,
hence I decided to give that choice.

> For example, if you enable CMA and do not enable COMPACTION, you
> lose things like the vmstat counters that can aid debugging. In
> fact, as parts of compaction.c are using defines like COMPACTBLOCKS,
> I'm not even sure compaction.c can compile without CONFIG_COMPACTION
> because of the vmstat stuff.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
