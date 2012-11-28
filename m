Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2K1UiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:38:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60429 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2K1UiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:38:08 -0500
MIME-Version: 1.0
In-Reply-To: <20121128190902.GS21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
	<1353123563-3103-35-git-send-email-yinghai@kernel.org>
	<20121128190902.GS21266@phenom.dumpdata.com>
Date: Wed, 28 Nov 2012 12:38:06 -0800
X-Google-Sender-Auth: w6POzqBpLXmLNXKz3vJH-AGCFGI
Message-ID: <CAE9FiQVN1-W3vLK5J75kQgt+0BW3sd2GkWi+4EeJMYwoyPi-gg@mail.gmail.com>
Subject: Re: [PATCH v8 34/46] x86, mm: Add check before clear pte above
 max_low_pfn on 32bit
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 11:09 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>>       /*
>>        * Remove any mappings which extend past the end of physical
>> -      * memory from the boot time page table:
>> +      * memory from the boot time page table.
>> +      * In virtual address space, we should have at least two pages
>> +      * from VMALLOC_END to pkmap or fixmap according to VMALLOC_END
>> +      * definition. And max_low_pfn is set to VMALLOC_END physical
>> +      * address. If initial memory mapping is doing right job, we
>> +      * should have pte used near max_low_pfn or one pmd is not present.
>
> 'have pte used near' ?
>
> Do you mean we should have an used PTE near max_low_pfn and one
> empty PMD?
>

==>
         * we should have used PTE to map address near max_low_pfn or
         * one empty PMD
