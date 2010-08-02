Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0HBQ2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:28:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36421 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0HBQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:28:30 -0400
Date: Mon, 2 Aug 2010 17:28:10 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the final tree (tip
	tree related)
Message-ID: <20100802162810.GB4755@flint.arm.linux.org.uk>
References: <20100803022310.bec3ba79.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803022310.bec3ba79.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 02:23:10AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Lots (if not all) of the arm builds failed for next-20100802 with these
> errors:
> 
> arch/arm/mm/init.c: In function 'arm_bootmem_init':
> arch/arm/mm/init.c:184: error: implicit declaration of function 'memblock_start_pfn'
> arch/arm/mm/init.c:186: error: implicit declaration of function 'memblock_end_pfn'
> arch/arm/mm/init.c:188: error: implicit declaration of function 'memblock_size_bytes'
> 
> Caused by commit 53e16bfaf19346f59b3502e207aa66c61332075c ("memblock:
> Introduce for_each_memblock() and new accessors, and use it") interacting
> with commit 2778f62056ada442414392d7ccd41188bb631619 ("ARM: initial LMB
> trial") and some others from the arm tree.

Please, no, don't break the memblock code now.  I'm not reworking the
ARM implementation just as the merge window has opened - especially
as the ARM implementation has now been pulled into other people's
trees.

If there's changes to memblock which haven't been in linux-next (which,
as this is a new failure, that is most definitely the case), then they
shouldn't be going into this merge window.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
