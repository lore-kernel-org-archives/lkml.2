Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab0EJLz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:55:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38379 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0EJLzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:55:54 -0400
Date: Mon, 10 May 2010 05:55:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org,
       davem@davemloft.net, rmk@arm.linux.org.uk
Subject: Re: [RFC PATCH] Update the cachetlb.txt file WRT flush_dcache_page
	and update_mmu_cache
Message-ID: <20100510115552.GD10452@parisc-linux.org>
References: <20100507132418.28009.6013.stgit@e102109-lin.cambridge.arm.com> <20100510170616O.fujita.tomonori@lab.ntt.co.jp> <1273486607.3023.37.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273486607.3023.37.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 11:16:47AM +0100, Catalin Marinas wrote:
> In most situations, just doing flushing in set_pte_at() would suffice
> and flush_dcache_page() can be ignored. There are two situations where I
> still see flush_dcache_page() useful:
> 
>      1. SMP systems where the cache maintenance operations aren't
>         automatically broadcast in hardware
>      2. The kernel modifies a page cache page that is already mapped in
>         user space
> 
> (1) can be worked around on some architectures (though not sure about
> all of them).
> 
> Is (2) a valid scenario?

The kernel always calls kmap() / kunmap() around accesses to page cache
pages (thanks to x86-32's ability to support 64GB).  There are three
ways I know of that architectures use this:

1) No-ops.  These architectures don't have cache problems.
2) Flush the kernel's mapping in kunmap().  This can have bad consequences
in SMP systems with threaded programs.
3) Select an address in kmap() that will alias to the user's address.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
