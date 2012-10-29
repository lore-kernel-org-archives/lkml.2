Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2J2NMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:12:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58726 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2J2NMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:12:03 -0400
MIME-Version: 1.0
In-Reply-To: <20121029020631.GI15767@bbox>
References: <1351451576-2611-1-git-send-email-js1304@gmail.com>
	<1351451576-2611-5-git-send-email-js1304@gmail.com>
	<20121029020631.GI15767@bbox>
Date: Mon, 29 Oct 2012 22:12:02 +0900
Message-ID: <CAAmzW4Otw336E52o_Y6XEJjf2qaWfk6LuuucM3QsMxFYUNP1uQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] mm, highmem: makes flush_all_zero_pkmaps() return
 index of last flushed entry
From: JoonSoo Kim <js1304@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/29 Minchan Kim <minchan@kernel.org>:
> On Mon, Oct 29, 2012 at 04:12:55AM +0900, Joonsoo Kim wrote:
>> In current code, after flush_all_zero_pkmaps() is invoked,
>> then re-iterate all pkmaps. It can be optimized if flush_all_zero_pkmaps()
>> return index of flushed entry. With this index,
>> we can immediately map highmem page to virtual address represented by index.
>> So change return type of flush_all_zero_pkmaps()
>> and return index of last flushed entry.
>>
>> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>>
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index ef788b5..0683869 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -32,6 +32,7 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
>>
>>  #ifdef CONFIG_HIGHMEM
>>  #include <asm/highmem.h>
>> +#define PKMAP_INDEX_INVAL (-1)
>
> How about this?
>
> #define PKMAP_INVALID_INDEX (-1)

Okay.

>>
>>  /* declarations for linux/mm/highmem.c */
>>  unsigned int nr_free_highpages(void);
>> diff --git a/mm/highmem.c b/mm/highmem.c
>> index 731cf9a..65beb9a 100644
>> --- a/mm/highmem.c
>> +++ b/mm/highmem.c
>> @@ -106,10 +106,10 @@ struct page *kmap_to_page(void *vaddr)
>>       return virt_to_page(addr);
>>  }
>>
>> -static void flush_all_zero_pkmaps(void)
>> +static int flush_all_zero_pkmaps(void)
>>  {
>>       int i;
>> -     int need_flush = 0;
>> +     int index = PKMAP_INDEX_INVAL;
>>
>>       flush_cache_kmaps();
>>
>> @@ -141,10 +141,12 @@ static void flush_all_zero_pkmaps(void)
>>                         &pkmap_page_table[i]);
>>
>>               set_page_address(page, NULL);
>> -             need_flush = 1;
>> +             index = i;
>
> How about returning first free index instead of last one?
> and update last_pkmap_nr to it.

Okay. It will be more good.

Thanks.
