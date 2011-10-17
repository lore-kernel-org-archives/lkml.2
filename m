Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1JQSEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:04:24 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:44948 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab1JQSEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:04:22 -0400
Date: Mon, 17 Oct 2011 20:03:51 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, gregkh@suse.de,
        Kai Jiang <Kai.Jiang@freescale.com>
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Message-ID: <20111017180350.GC13919@local>
References: <1318521058-15662-1-git-send-email-galak@kernel.crashing.org>
 <20111014183144.GD28556@local>
 <4D73F261-3795-4F71-9921-568C1B9F06E0@kernel.crashing.org>
 <20111017171859.GB13919@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017171859.GB13919@local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 07:18:59PM +0200, Hans J. Koch wrote:
> On Mon, Oct 17, 2011 at 11:00:55AM -0500, Kumar Gala wrote:
> > 
> > On Oct 14, 2011, at 1:31 PM, Hans J. Koch wrote:
> > 
> > > On Thu, Oct 13, 2011 at 10:50:58AM -0500, Kumar Gala wrote:
> > >> From: Kai Jiang <Kai.Jiang@freescale.com>
> > >> 
> > >> To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
> > >> extend the width of 'addr' in struct uio_mem.  Numerous platforms like
> > >> embedded PPC, ARM, and X86 have support for systems with larger physical
> > >> address than logical.
> > >> 
> > >> Since 'addr' may contain a physical, logical, or virtual address the
> > >> easiest solution is to just change the type to 'phys_addr_t' which
> > >> should always be greater than or equal to the sizeof(void *) such that
> > >> it can properly hold any of the address types.
> > >> 
> > >> For physical address we can support up to a 44-bit physical address on a
> > >> typical 32-bit system as we utilize remap_pfn_range() for the mapping of
> > >> the memory region and pfn's are represnted by shifting the address by
> > >> the page size (typically 4k).
> > >> 
> > >> Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
> > >> Signed-off-by: Minghuan Lian <Minghuan.Lian@freescale.com>
> > >> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> > > 
> > > Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>
> > > 
> > > That looks good to me. There's an unnecessary cast (see below), but I fixed that
> > > on the way.
> > > 
> > > Greg, please pull this from branch uio-for-gregkh from
> > > 
> > > git://hansjkoch.de/git/linux-hjk
> > > 
> > > Thanks,
> > > Hans
> > 
> > I think removing that cast is wrong:
> > 
> > drivers/uio/uio.c: In function 'uio_vma_fault':
> > drivers/uio/uio.c:637:26: warning: cast to pointer from integer of different size
> 
> Hmm, on what platform did you see this? I tested on 32bit-x86 and didn't get
> any warnings.

OK, you're right. I turned on CONFIG_HIGHMEM64G and got that warning. Damned x86...

Greg, can you fix it, or should I send the patch again?

Thanks,
Hans
