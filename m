Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab1JNPEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:04:23 -0400
Received: from smail2.alcatel.fr ([64.208.49.57]:34628 "EHLO smail2.alcatel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab1JNPEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:04:22 -0400
Message-ID: <4E984F70.60102@alcatel-lucent.com>
Date: Fri, 14 Oct 2011 17:04:16 +0200
From: Thanh-Lam NGUYEN <thanh-lam.nguyen@alcatel-lucent.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf.c: core file shrinking
References: <4E946279.8090800@alcatel-lucent.com> <4E97F83F.6050501@alcatel-lucent.com> <CAJd=RBAR6gy2=NFkEAOqH-K+YcUYQKZhsB9YAJi0-TvWFvEKMg@mail.gmail.com>
In-Reply-To: <CAJd=RBAR6gy2=NFkEAOqH-K+YcUYQKZhsB9YAJi0-TvWFvEKMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/2011 16:45, Hillf Danton wrote:

> On Fri, Oct 14, 2011 at 4:52 PM, Thanh-Lam NGUYEN
> <thanh-lam.nguyen@alcatel-lucent.com> wrote:
>> Sorry for upping the patch,
>> as it is my first contribution I would like to know if there is any
>> problem with it.
>>
>> Best regard
>> Thanh lam NGUYEN
>>
>> On 11/10/2011 17:36, Thanh-Lam NGUYEN wrote:
>>
>>> The vma_shrink function looks for the 1st allocated and the last
>>> allocated page. Only this part is dumped to the disk (the virual
>>> start address and the size are dupdated to reflect the new dumped
>>> information).
>>>
>>> Signed-off-by: Thanh Lam NGUYEN <thanh-lam.nguyen@alcatel-lucent.com>
>>> Signed-off-by: Benjamin ZORES <Benjamin.Zores@alcatel-lucent.com>
>>> ---
>>>  linux/fs/binfmt_elf.c |   54
>>> ++++++++++++++++++++++++++++++++++++++++++++++----
> 
> corrupted message?
> 
>>>  1 file changed, 55 insertions(+), 4 deletions(-)
>>>
>>> --- linux/fs/binfmt_elf.c
>>> +++ linux/fs/binfmt_elf.c
>>> @@ -1085,6 +1085,48 @@
>>>   * Jeremy Fitzhardinge <jeremy@sw.oz.au>
>>>   */
>>>
>>> +/*
>>> + * Search for 1st and last allocated page from vma_start to vma_end.
>>> + * Update vma_start and vma_end to reflect the result.
>>> + */
>>> +void vma_shrink(struct vm_area_struct *vma, unsigned long *vma_start,
>>> +             unsigned long *vma_end)
>>> +{
>>> +     int allocated;
>>> +     unsigned long start, addr, end;
>>> +
>>> +     allocated = 0;
>>> +     start = end = *vma_start;
>>> +     for (addr = *vma_start; _addr < *vma_end; addr += PAGE_SIZE) {
>                                         -----^
>                                         where is _addr from?
> 

My bad, it's addr and not _addr.

>>> +             struct page *page;
>>> +             if (get_user_pages(current, current->mm, addr, 1, 0, 1,
>>> +                                &page, NULL) <= 0) {
>>> +                     /* NO PAGE */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
=~=~=~=~=~=~=~=~=~=~=~=~==~=~=~=~=~=~=~=~=~=~=~=~=~=~=
Thanh lam NGUYEN
Prestataire externe ALTEN        | ALTEN Subcontractor
pour ALCATEL-LUCENT              | in ALCATEL-LUCENT

Tel: +333906 77095

Equipe/Team: SWINT
email: tlnguyen@webmail.alten.fr
