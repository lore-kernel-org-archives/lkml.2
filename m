Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1KAImO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 04:42:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37871 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1KAImN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 04:42:13 -0400
MIME-Version: 1.0
In-Reply-To: <4EB01C8F0200001600008FAE@novprvlin0050.provo.novell.com>
References: <1320049412-12642-1-git-send-email-gjhe@suse.com>
	<1320110288.22361.190.camel@sli10-conroe>
	<4EB01C8F0200001600008FAE@novprvlin0050.provo.novell.com>
Date: Tue, 1 Nov 2011 16:42:12 +0800
X-Google-Sender-Auth: hnP12SE1sYQ8CPD9dtcHA0sUCr0
Message-ID: <CANejiEVk41X-P+UyMf96jmPrJJ5-_vbubYtnQgaWXY2FLb41iw@mail.gmail.com>
Subject: Re: [PATCH][mm/memory.c]: transparent hugepage check condition missed
From: Shaohua Li <shaohua.li@intel.com>
To: Guan Jun He <gjhe@suse.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/1 Guan Jun He <gjhe@suse.com>:
>
>
>>>> On 11/1/2011 at 09:18 AM, in message <1320110288.22361.190.camel@sli10-conroe>,
> Shaohua Li <shaohua.li@intel.com> wrote:
>> On Mon, 2011-10-31 at 16:23 +0800, Guanjun He wrote:
>>> For the transparent hugepage module still does not support
>>> tmpfs and cache,the check condition should always be checked
>>> to make sure that it only affect the anonymous maps, the
>>> original check condition missed this, this patch is to fix this.
>>> Otherwise,the hugepage may affect the file-backed maps,
>>> then the cache for the small-size pages will be unuseful,
>>> and till now there is still no implementation for hugepage's cache.
>>>
>>> Signed-off-by: Guanjun He <gjhe@suse.com>
>>> ---
>>>  mm/memory.c |    3 ++-
>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index a56e3ba..79b85fe 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -3475,7 +3475,8 @@ int handle_mm_fault(struct mm_struct *mm, struct
>> vm_area_struct *vma,
>>>              if (pmd_trans_huge(orig_pmd)) {
>>>                      if (flags & FAULT_FLAG_WRITE &&
>>>                          !pmd_write(orig_pmd) &&
>>> -                        !pmd_trans_splitting(orig_pmd))
>>> +                        !pmd_trans_splitting(orig_pmd) &&
>>> +                        !vma->vm_ops)
>>>                              return do_huge_pmd_wp_page(mm, vma, address,
>>>                                                         pmd, orig_pmd);
>>>                      return 0;
>> so if vma->vm_ops != NULL, how could the pmd_trans_huge(orig_pmd) be
>> true? We never enable THP if vma->vm_ops != NULL.
> acturally, pmd_trans_huge(orig_pmd) only checks the _PAGE_PSE bits,
> it's only a pagesize, not a flag to identity a hugepage.
> If I change my default pagesize to PAGE_PSE,
Not sure what pagesize means here, assume pmd entry bits.
how could you make the default 'pagesize' to PAGE_PSE?
