Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1KCI0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 04:26:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35697 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab1KCI0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 04:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <1320150365.14409.160.camel@x61.thuisdomein>
References: <1320147705-15117-1-git-send-email-heguanbo@gmail.com>
	<1320150365.14409.160.camel@x61.thuisdomein>
Date: Thu, 3 Nov 2011 16:26:50 +0800
Message-ID: <CAGW+__+-Gj3WQJf+PQYfn8sArxwYkWR_kcUgA8s5L_Z+-yJCtg@mail.gmail.com>
Subject: Re: [PATCH][mm:] adjust the logic of checking THP
From: GuanJun He <heguanbo@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!I have updated and resent it.

best,
Guanjun

On Tue, Nov 1, 2011 at 8:26 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Perhaps a summary would help the people actually knowledgeable about mm
> understand why this adjustment is needed.
>
> I'll just mention a few obvious things.
>
> On Tue, 2011-11-01 at 19:41 +0800, Guanjun He wrote:
>> Signed-off-by: Guanjun He <heguanbo@gmail.com>
>> ---
>>  mm/memory.c |   32 ++++++++++++++++++--------------
>>  1 files changed, 18 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index a56e3ba..d6dd6b3 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -3465,20 +3465,24 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>>       pmd = pmd_alloc(mm, pud, address);
>>       if (!pmd)
>>               return VM_FAULT_OOM;
>> -     if (pmd_none(*pmd) && transparent_hugepage_enabled(vma)) {
>> -             if (!vma->vm_ops)
>> -                     return do_huge_pmd_anonymous_page(mm, vma, address,
>> -                                                       pmd, flags);
>> -     } else {
>> -             pmd_t orig_pmd = *pmd;
>> -             barrier();
>> -             if (pmd_trans_huge(orig_pmd)) {
>> -                     if (flags & FAULT_FLAG_WRITE &&
>> -                         !pmd_write(orig_pmd) &&
>> -                         !pmd_trans_splitting(orig_pmd))
>> -                             return do_huge_pmd_wp_page(mm, vma, address,
>> -                                                        pmd, orig_pmd);
>> -                     return 0;
>> +     if (transparent_hugepage_enabled(vma)) {
>> +             if(pmd_none(*pmd)){
>
> codingstyle (scripts/checkpatch.pl would have caught that one).
>
>> +                     if (!vma->vm_ops)
>> +                             return do_huge_pmd_anonymous_page(mm, vma, address,
>> +                                             pmd, flags);
>> +             }
>> +             else
>> +             {
>
> codingstyle (ditto). There's probably more.
>
>> +                     pmd_t orig_pmd = *pmd;
>> +                     barrier();
>> +                     if (pmd_trans_huge(orig_pmd)) {
>> +                             if (flags & FAULT_FLAG_WRITE &&
>> +                                             !pmd_write(orig_pmd) &&
>> +                                             !pmd_trans_splitting(orig_pmd))
>> +                                     return do_huge_pmd_wp_page(mm, vma, address,
>> +                                                     pmd, orig_pmd);
>> +                             return 0;
>> +                     }
>>               }
>>       }
>>
>
>
> Paul Bolle
>
>
