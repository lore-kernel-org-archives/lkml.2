Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2BTH5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 02:57:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59605 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2BTH5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 02:57:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of geunsik.lim@gmail.com designates 10.52.174.212 as permitted sender) smtp.mail=geunsik.lim@gmail.com; dkim=pass header.i=geunsik.lim@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120217142806.07a97347.akpm@linux-foundation.org>
References: <1328257256-1296-1-git-send-email-geunsik.lim@gmail.com>
	<20120217142806.07a97347.akpm@linux-foundation.org>
Date: Mon, 20 Feb 2012 16:57:35 +0900
Message-ID: <CAGFP0LJhqC9xqn=BmoOyRL_wJX8=KU=Z4+k=t=C3MLhWYqWLnQ@mail.gmail.com>
Subject: Re: [PATCH] Fix potentially derefencing uninitialized 'r'.
From: Geunsik Lim <geunsik.lim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 7:28 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri,  3 Feb 2012 17:20:56 +0900
> Geunsik Lim <geunsik.lim@gmail.com> wrote:
>
>> struct memblock_region 'r' will not be initialized potentially
>> because of while statement's condition in __next_mem_pfn_range()function.
>> Initialize struct memblock_region data structure by default.
>>
>> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>  mm/memblock.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 77b5f22..867f5a2 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -671,7 +671,7 @@ void __init_memblock __next_mem_pfn_range(int *idx, int nid,
>>                               unsigned long *out_end_pfn, int *out_nid)
>>  {
>>       struct memblock_type *type = &memblock.memory;
>> -     struct memblock_region *r;
>> +     struct memblock_region *r = &type->regions[*idx];
>>
>>       while (++*idx < type->cnt) {
>>               r = &type->regions[*idx];
>
> The following `if' test prevents any such dereference.
>
> Maybe you saw a compilation warning (I didn't).  If so,
> unintialized_var() is one way of suppressing it.
Yepp. This patch is  for solving compilation warning as you commented.
>
> A better way is to reorganise the code (nicely).  Often that option
> isn't available.
I will post patch again after reorganizing the code with better way.
Thanks.
>
>



-- 
----
Best regards,
Geunsik Lim, Samsung Electronics
http://leemgs.fedorapeople.org
----
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
