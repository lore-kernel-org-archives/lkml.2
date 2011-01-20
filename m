Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1ATRwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:52:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55558 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1ATRwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:52:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Y9tynR5ARzDZZAiv7YQ5CNH/VQVEmAhvWk4nRvhiBbdP/zdRjwXkJTIDIbPv0F6bek
         FPRe+rzRqGwasvAaJ70CUDFqSA6GP6LLKqRHrj6PDCozj6t+B72hONi+iIv9StEgWSlm
         PdFzWo7Cq5l4FZ3B+hddbSvAHcrsBRfHAtbTc=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=MizfGY4koMmRHprts6Ji3ofeSZPBBTiH1FDcn@mail.gmail.com>
References: <1295516739-9839-1-git-send-email-pullip.cho@samsung.com>
	<20110120142844.GA28358@barrios-desktop>
	<AANLkTinXAiShaf1f69ufVHg7KPaY5j=jmOTtK71GNNp5@mail.gmail.com>
	<AANLkTikBbknwsLvN-b4HVqL_gAUHC-4VjQ=WQ=h_kLhW@mail.gmail.com>
	<AANLkTi=MizfGY4koMmRHprts6Ji3ofeSZPBBTiH1FDcn@mail.gmail.com>
Date: Fri, 21 Jan 2011 02:52:34 +0900
Message-ID: <AANLkTimf4oqEs4Oq1gMEjRsqhGM=vYkU6zm2MSuRBVdk@mail.gmail.com>
Subject: Re: [PATCH] ARM: mm: Regarding section when dealing with meminfo
From: KyongHo Cho <pullip.linux@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Ilho Lee <ilho215.lee@samsung.com>,
        KeyYoung Park <keyyoung.park@samsung.com>,
        KyongHo Cho <pullip.cho@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 2:44 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> Fix linux-arm-kernel address.
>
Thank you!
Too late in the night:)

> On Fri, Jan 21, 2011 at 2:43 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> Restore Cced.
>>
>> On Fri, Jan 21, 2011 at 2:24 AM, KyongHo Cho <pullip.linux@gmail.com> wrote:
>>> On Thu, Jan 20, 2011 at 11:28 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>>>> On Thu, Jan 20, 2011 at 06:45:39PM +0900, KyongHo Cho wrote:
>>>>> Sparsemem allows that a bank of memory spans over several adjacent
>>>>> sections if the start address and the end address of the bank
>>>>> belong to different sections.
>>>>> When gathering statictics of physical memory in mem_init() and
>>>>> show_mem(), this possiblity was not considered.
>>>>
>>>> Please write down the result if we doesn't consider this patch.
>>>> I can understand what happens but for making good description and review,
>>>> merging easily, it would be better to write down the result without
>>>> the patch explicitly.
>>>>
>>> As we know that each section has its own memmap and
>>> a contiguous chunk of physical memory that is represented by 'bank' in meminfo
>>> can be larger than the size of a section.
>>> "page++" in the current implementation can access invalid memory area.
>>> The size of the section is 256 MiB in ARM and the number of banks in
>>> meminfo is 8.
>>> This means that the maximum size of the physical memory cannot be grow than 2GiB
>>> to avoid this problem in the current implementation.
>>> Thus we need to fix the calculation of the last page descriptor in
>>> terms of sections.
>>>
>>> This patch determines the last page descriptor in a memmap with
>>> min(last_pfn_of_bank, last_pfn_of_current_section)
>>> If there remains physical memory not consumed, it calculates the last
>>> page descriptor
>>> with min(last_pfn_of_bank, last_pfn_of_next_section).
>>>
>>>>
>>>> Hmm.. new ifndef magic makes code readability bad.
>>>> Couldn't we do it by simple pfn iterator not page and pfn_valid check?
>>>>
>>> True.
>>> We need to consider the implementation again.
>>> I think the previous implementation gave the importance to the
>>> efficiency but to the readability.
>>>
>>
>> Please consider readability and consistency with other architectures
>> if we can do. :)
>> Thanks.
>>
>> --
>> Kind regards,
>> Minchan Kim
>>
>
>
>
> --
> Kind regards,
> Minchan Kim
>
