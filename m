Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab2A3RdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:33:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53376 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2A3RdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:33:15 -0500
Date: Mon, 30 Jan 2012 09:33:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
Message-ID: <20120130173311.GE3355@google.com>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org>
 <20120130171558.GB3355@google.com>
 <20120130171919.GC3355@google.com>
 <alpine.DEB.2.00.1201301122410.28693@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201301122410.28693@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:22:57AM -0600, Christoph Lameter wrote:
> On Mon, 30 Jan 2012, Tejun Heo wrote:
> 
> > On Mon, Jan 30, 2012 at 09:15:58AM -0800, Tejun Heo wrote:
> > > Percpu pointers are in a different address space and using
> > > ZERO_SIZE_PTR directly will trigger sparse address space warning.
> > > Also, I'm not entirely sure whether 16 is guaranteed to be unused in
> > > percpu address space (maybe it is but I don't think we have anything
> > > enforcing that).
> >
> > Another thing is that percpu address dereferencing always goes through
> > rather unintuitive translation and 1. we can't (or rather currently
> > don't) guarantee that fault will occur for any address 2. even if it
> > does, the faulting address wouldn't be anything easily
> > distinguishible.  So, unless the above shortcomings is resolved, I
> > don't really see much point of using ZERO_SIZE_PTR for percpu
> > allocator.
> 
> The same is true for the use of NULL pointers.

I'm pretty sure it never gives out NULL for a dynamic allocation.  The
base might be mapped to zero but we're guaranteed to have some static
percpu areas there and IIRC the percpu addresses aren't supposed to
wrap.

Also, if ZERO_SIZE_PTR doesn't actually help anything, it is not a
good idea to have it.  The only thing it does would be giving wrong
impressions.

Thanks.

-- 
tejun
