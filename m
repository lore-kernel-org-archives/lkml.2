Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1LIWtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:49:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44363 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab1LIWtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:49:50 -0500
MIME-Version: 1.0
In-Reply-To: <1323466526.27746.29.camel@joe2Laptop>
References: <1323465781-2976-1-git-send-email-kosaki.motohiro@gmail.com> <1323466526.27746.29.camel@joe2Laptop>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 9 Dec 2011 17:49:27 -0500
Message-ID: <CAHGf_=pWrM3ToRw0Hwb+mY3FVibmpvm2ShK+VspunQwWBCy9bA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: simplify find_vma_prev
To: Joe Perches <joe@perches.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/mm/mmap.c b/mm/mmap.c
> []
>> @@ -1603,39 +1603,21 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
>>
>>  EXPORT_SYMBOL(find_vma);
>>
>> -/* Same as find_vma, but also return a pointer to the previous VMA in *pprev. */
>> +/*
>> + * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
>> + * Note: pprev is set to NULL when return value is NULL.
>> + */
>>  struct vm_area_struct *
>> -find_vma_prev(struct mm_struct *mm, unsigned long addr,
>> -                     struct vm_area_struct **pprev)
>
>> +find_vma_prev(struct mm_struct *mm, unsigned long addr, struct vm_area_struct **pprev)
>
> eh.  This declaration change seems gratuitous and it exceeds 80 columns.
>
>> +     *pprev = NULL;
>> +     vma = find_vma(mm, addr);
>> +     if (vma)
>> +             *pprev = vma->vm_prev;
>
> There's no need to possibly set *pprev twice.
>
> Maybe
> {
>        struct vm_area_struct *vma = find_vma(mm, addr);
>
>        *pprev = vma ? vma->vm_prev : NULL;
> or
>        if (vma)
>                *pprev = vma->vm_prev;
>        else
>                *pprev = NULL;
>
>        return vma;

Thank you for reviewing. Updated.
