Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966053Ab2B1WQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:16:38 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:25098 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab2B1WQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:16:36 -0500
Date: Tue, 28 Feb 2012 23:16:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Meelis Roos <mroos@linux.ee>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3.3-rc5] memblock: Fix size aligning of
	memblock_alloc_base_nid()
Message-ID: <20120228221629.GA3246@merkur.ravnborg.org>
References: <20120228205621.GC3252@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228205621.GC3252@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 05:56:21AM +0900, Tejun Heo wrote:
> memblock allocator aligns @size to @align to reduce the amount of
> fragmentation.  7bd0b0f0da "memblock: Reimplement memblock allocation
> using reverse free area iterator" broke it by incorrectly relocating
> @size aligning to memblock_find_in_range_node().  As the aligned size
> is not propagated back to memblock_alloc_base_nid(), the actually
> reserved size isn't aligned.
> 
> While this increases memory use for memblock reserved array, this
> shouldn't cause any critical failure; however, it seems that the size
> aligning was hiding a use-beyond-allocation bug in sparc64 and losing
> the aligning causes boot failure.
> 
> The underlying problem is currently being debugged but this is a
> proper fix in itself, it's already pretty late in -rc cycle for boot
> failures and reverting the change for debugging isn't difficult.
> Restore the size aligning moving it to memblock_alloc_base_nid().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Meelis Roos <mroos@linux.ee>

> Reported-by: Sam Ravnborg <sam@ravnborg.org>
Actually not :-(
I only fooled around with some clueless suggestions - I do
not have any sparc64 boxes. And my sparc32 box that is alive atm,
does not exhibit this problem.

	Sam
