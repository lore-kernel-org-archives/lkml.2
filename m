Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2K1TkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:40:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64505 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2K1TkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:40:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121128170856.GL21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
	<1353123563-3103-15-git-send-email-yinghai@kernel.org>
	<20121128170856.GL21266@phenom.dumpdata.com>
Date: Wed, 28 Nov 2012 11:40:19 -0800
X-Google-Sender-Auth: 261TaWYUyGmsB3lMqqW_nYp2-tU
Message-ID: <CAE9FiQWGKdfxceWF9yrtk5K+9bqNmWk=CaWGwffpOq0aZzJWrg@mail.gmail.com>
Subject: Re: [PATCH v8 14/46] x86, mm: use pfn_range_is_mapped() with reserve_initrd
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

On Wed, Nov 28, 2012 at 9:08 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Nov 16, 2012 at 07:38:51PM -0800, Yinghai Lu wrote:
>> We are going to map ram only, so under max_low_pfn_mapped,
>> between 4g and max_pfn_mapped does not mean mapped at all.
>>
>> Use pfn_range_is_mapped() to find out if range is mapped for initrd.
>>
>> That could happen bootloader put initrd in range but user could
>                    ^- 'if the'                              ^^^^^-'used'
>
>> use memmap to carve some of range out.
>   ^^^-> get rid of that.       ^^^^->'ranges'
>
>>
>> Also during copying need to use early_memmap to map original initrd
>> for accessing.

===>
---
We are going to map ram only in patch:
        x86, mm: Only direct map addresses that are marked as E820_RAM

so range under max_low_pfn_mapped, ranges between 4g and max_pfn_mapped
could have holes in them and the holes will not be mapped.

Use pfn_range_is_mapped() to check if range is mapped for initrd.

That could happen if the bootloader put initrd in range but user used
"memmap=" to carve some of ranges out.

Also during copying need to use early_memmap to map original initrd
for accessing.
---
