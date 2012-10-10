Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2JJN7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:59:18 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63279 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab2JJN7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:59:16 -0400
Date: Wed, 10 Oct 2012 09:47:26 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
Message-ID: <20121010134725.GB4005@phenom.dumpdata.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:58:28PM -0700, Yinghai Lu wrote:
> on top of tip/x86/mm2, but please zap last patch in that branch.

So while I appreciate you actively looking at this and iteratively
sending snapshots of the progress - I think it would be easier if
you posted a patchset that has rework done completly per what
Peter described.

That way folks who are reviewing will know when they can focus their
time on reviewing the whole thing in one go instead of doing it
step by step - as some of the patches still haven't addressed the
review comments that were given the first time.


> 1. use brk to mapping first PMD_SIZE range.
> 2. top down to initialize page table range by range.
> 3. get rid of calculate page table, and find_early_page_table.
> 4. remove early_ioremap in page table accessing.
> 
> v2: changes, update xen interface about pagetable_reserve, so not
>    use pgt_buf_* in xen code directly.
> v3: use range top-down to initialize page table, so will not use
>    calculating/find early table anymore.
>    also reorder the patches sequence.
> 
> could be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm
> 
> later we could get rid of workaround about xen_mapping_pagetable_reserve, that
> could kill another 50 lines codes. --- will do that later because x86/mm2 is
> not updated to linus/master yet. If we do that now, will have merge conflicts.

I am confused. Why do you need x86/mm2? If you do need it, you need to
describe in this writeup why you depend on it, and what is there.

You can't base it on linus's tree?

> 
> Thanks
> 
> Yinghai Lu
> 
> Yinghai Lu (7):
>   x86, mm: align start address to correct big page size
>   x86, mm: Use big page size for small memory range
>   x86, mm: Don't clear page table if next range is ram
>   x86, mm: only keep initial mapping for ram
>   x86, mm: Break down init_all_memory_mapping
>   x86, mm: setup page table from top-down
>   x86, mm: Remove early_memremap workaround for page table accessing
> 
>  arch/x86/include/asm/page_types.h |    1 +
>  arch/x86/include/asm/pgtable.h    |    1 +
>  arch/x86/kernel/setup.c           |    3 +
>  arch/x86/mm/init.c                |  251 ++++++++++++------------------------
>  arch/x86/mm/init_32.c             |   18 +++-
>  arch/x86/mm/init_64.c             |  100 ++++++---------
>  6 files changed, 144 insertions(+), 230 deletions(-)
> 
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
