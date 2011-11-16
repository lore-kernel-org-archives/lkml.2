Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab1KPAFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:05:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38697 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1KPAFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:05:23 -0500
Message-ID: <4EC2FE33.7030905@gmail.com>
Date: Wed, 16 Nov 2011 08:05:07 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: cleanup the comment for head/tail pages of compound
 pages in mm/page_alloc.c
References: <4EC21D78.4080508@gmail.com> <20111115132409.GA7551@tiehlicka.suse.cz>
In-Reply-To: <20111115132409.GA7551@tiehlicka.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年11月15日 21:24, Michal Hocko wrote:
> On Tue 15-11-11 16:06:16, Wang Sheng-Hui wrote:
>> Per the void prep_compound_page(struct page *page, unsigned long order) code,
>> compound pages use PG_head/PG_tail, 
> 
> This is true only for CONFIG_PAGEFLAGS_EXTENDED otherwise we trick it by
> PG_compound & ~PG_reclaim = head page
> PG_compound & PG_reclaim = tail page
> 
> Have a look at PG_head_tail_mask
> 
>> and only tail pages point at head page using their ->first_page field.
> 
> This part is correct.
> 
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  mm/page_alloc.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 6e8ecb6..f645ce8 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -332,8 +332,8 @@ out:
>>   *
>>   * The remaining PAGE_SIZE pages are called "tail pages".
>>   *
>> - * All pages have PG_compound set.  All pages have their ->private pointing at
>> - * the head page (even the head page has this).
>> + * Head page has PG_head set, and all tail pages have PG_tail set. All tail
>> + * pages have their ->first_page pointing at the head page.
>>   *
>>   * The first tail page's ->lru.next holds the address of the compound page's
>>   * put_page() function.  Its ->lru.prev holds the order of allocation.
>> -- 
>> 1.7.1
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

Thanks, Michal.

New patch generated.


[PATCH] mm: cleanup the comment for head/tail pages of compound pages in mm/page_alloc.c

Only tail pages point at the head page using their ->first_page fields.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e8ecb6..e7dd848 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -332,8 +332,8 @@ out:
  *
  * The remaining PAGE_SIZE pages are called "tail pages".
  *
- * All pages have PG_compound set.  All pages have their ->private pointing at
- * the head page (even the head page has this).
+ * All pages have PG_compound set.  All tail pages have their ->first_page
+ * pointing at the head page.
  *
  * The first tail page's ->lru.next holds the address of the compound page's
  * put_page() function.  Its ->lru.prev holds the order of allocation.
-- 
1.7.1


