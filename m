Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0LAAuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:50:52 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44600 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab0LAAuu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:50:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uZYpWuitytB6Qv3Gm9+pfTeNqFhvjQ87rRQV6jyrfTqgqYjJB5PSRKb/+3S6NAcmDd
         hulXcIA9kRG5DzIItyfeuyGSqX39NTQsb3Abz5SPdu9ndHjyb/UmoGfVX8BmjEy0JBUk
         Zvh33K+TwjDNCLDPF/tgtax5ZLjSeoDqn5VJ4=
MIME-Version: 1.0
In-Reply-To: <20101130113540.GD15564@cmpxchg.org>
References: <cover.1291043273.git.minchan.kim@gmail.com>
	<a0f2905bb64ce33909d7dd74146bfea826fec21a.1291043274.git.minchan.kim@gmail.com>
	<20101130113540.GD15564@cmpxchg.org>
Date: Wed, 1 Dec 2010 09:50:49 +0900
Message-ID: <AANLkTi=SPop0yXgVA=gdkgC2TUOp2v3W3_iL4px1OaQR@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] Prevent activation of page in madvise_dontneed
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 8:35 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Nov 30, 2010 at 12:23:21AM +0900, Minchan Kim wrote:
>> Now zap_pte_range alwayas activates pages which are pte_young &&
>> !VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
>> it's unnecessary since the page wouldn't use any more.
>>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> Acked-by: Rik van Riel <riel@redhat.com>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Nick Piggin <npiggin@kernel.dk>
>> Cc: Mel Gorman <mel@csn.ul.ie>
>> Cc: Wu Fengguang <fengguang.wu@intel.com>
>>
>> Changelog since v2:
>>  - remove unnecessary description
>> Changelog since v1:
>>  - change word from promote to activate
>>  - add activate argument to zap_pte_range and family function
>>
>> ---
>>  include/linux/mm.h |    4 ++--
>>  mm/madvise.c       |    4 ++--
>>  mm/memory.c        |   38 +++++++++++++++++++++++---------------
>>  mm/mmap.c          |    4 ++--
>>  4 files changed, 29 insertions(+), 21 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index e097df6..6032881 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -779,11 +779,11 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>>  int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
>>               unsigned long size);
>>  unsigned long zap_page_range(struct vm_area_struct *vma, unsigned long address,
>> -             unsigned long size, struct zap_details *);
>> +             unsigned long size, struct zap_details *, bool activate);
>
> I would prefer naming the parameter 'ignore_references' or something
> similar, so that it reflects the immediate effect on the zappers'
> behaviour, not what mark_page_accessed() might end up doing.
>
> Other than that, the patch looks good to me.

Fair enough.
Will fix.
Maybe it would take a long time until sending next version.

Thanks, Hannes.

>
>        Hannes
>



-- 
Kind regards,
Minchan Kim
