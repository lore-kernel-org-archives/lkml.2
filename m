Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2JJQlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:41:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:17272 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab2JJQk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:40:58 -0400
X-IronPort-AV: E=Sophos;i="4.80,565,1344211200"; 
   d="scan'208";a="15081039"
Date: Wed, 10 Oct 2012 17:40:41 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
In-Reply-To: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Yinghai Lu wrote:
> on top of tip/x86/mm2, but please zap last patch in that branch.
> 
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

I don't think you can change the x86 code without changing the xen code
at the same time, otherwise you'll be really likely to break Xen. That
is unless you don't change any of the pvops but I thought that it was
one of the point of this series.



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

So you are missing the Xen patches entirely in this iteration of the
series?
