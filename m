Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab2JJOzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:55:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62243 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2JJOzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:55:39 -0400
MIME-Version: 1.0
In-Reply-To: <20121010134725.GB4005@phenom.dumpdata.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<20121010134725.GB4005@phenom.dumpdata.com>
Date: Wed, 10 Oct 2012 07:55:38 -0700
X-Google-Sender-Auth: uL2nfsorWm9P5HVrULE3ylLX-ic
Message-ID: <CAE9FiQXFcozs2SqDBeFsSKy-Ae9HjKvE_vb_vM+QMHX492cnpw@mail.gmail.com>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 6:47 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Tue, Oct 09, 2012 at 04:58:28PM -0700, Yinghai Lu wrote:
>> on top of tip/x86/mm2, but please zap last patch in that branch.
>
> So while I appreciate you actively looking at this and iteratively
> sending snapshots of the progress - I think it would be easier if
> you posted a patchset that has rework done completly per what
> Peter described.

it should be done this time,  so asked Stefano to test it again.

>
> That way folks who are reviewing will know when they can focus their
> time on reviewing the whole thing in one go instead of doing it
> step by step - as some of the patches still haven't addressed the
> review comments that were given the first time.

I addressed one that i can do.

>
>
>> 1. use brk to mapping first PMD_SIZE range.
>> 2. top down to initialize page table range by range.
>> 3. get rid of calculate page table, and find_early_page_table.
>> 4. remove early_ioremap in page table accessing.
>>
>> v2: changes, update xen interface about pagetable_reserve, so not
>>    use pgt_buf_* in xen code directly.
>> v3: use range top-down to initialize page table, so will not use
>>    calculating/find early table anymore.
>>    also reorder the patches sequence.
>>
>> could be found at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm
>>
>> later we could get rid of workaround about xen_mapping_pagetable_reserve, that
>> could kill another 50 lines codes. --- will do that later because x86/mm2 is
>> not updated to linus/master yet. If we do that now, will have merge conflicts.
>
> I am confused. Why do you need x86/mm2? If you do need it, you need to
> describe in this writeup why you depend on it, and what is there.
>
> You can't base it on linus's tree?

no, some init_memory_mapping related cleanups are in x86/mm2.

the whole story: while reviewing x86/mm2,
Stefano say it would be better to get rid of ioremap to access page table area.
so according to hpa's concept, I use some pages in BRK to pre-map page
table at first.
on -v2, with xen Stefano found panic on system with more than 4g.
To address that panic, we come out -v3 that will map memory top-down
and range size for
each step is from PMD_SIZE to more bigger...

Thanks

Yinghai
