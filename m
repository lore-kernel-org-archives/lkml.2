Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab0EJOkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:40:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59917 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971Ab0EJOkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:40:12 -0400
Subject: Re: [RFC PATCH] Update the cachetlb.txt file WRT flush_dcache_page
 and update_mmu_cache
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, davem@davemloft.net, rmk@arm.linux.org.uk
In-Reply-To: <20100510102947.GA14278@linux-sh.org>
References: <20100507132418.28009.6013.stgit@e102109-lin.cambridge.arm.com>
	 <20100510170616O.fujita.tomonori@lab.ntt.co.jp>
	 <1273486607.3023.37.camel@e102109-lin.cambridge.arm.com>
	 <20100510102947.GA14278@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 09:40:08 -0500
Message-ID: <1273502408.4424.4.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 19:29 +0900, Paul Mundt wrote:
> On Mon, May 10, 2010 at 11:16:47AM +0100, Catalin Marinas wrote:
> > In most situations, just doing flushing in set_pte_at() would suffice
> > and flush_dcache_page() can be ignored. There are two situations where I
> > still see flush_dcache_page() useful:
> > 
> >      1. SMP systems where the cache maintenance operations aren't
> >         automatically broadcast in hardware
> >      2. The kernel modifies a page cache page that is already mapped in
> >         user space
> > 
> > (1) can be worked around on some architectures (though not sure about
> > all of them).
> > 
> > Is (2) a valid scenario?
> > 
> get_user_pages() ?

Actually, no, not really.  get_user_pages() is preparing the pages for
DMA (so it pins and possibly flushes them to make the underlying
physical page in the page cache clean).  This means it gathers the
physical pages into a scatter gather list.  It actually assumes the
kernel *won't* be touching them (without using kmap), so it doesn't give
the pages an in-kernel mapping.

James


