Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2JMXqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 19:46:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:31766 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab2JMXqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 19:46:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,580,1344236400"; 
   d="scan'208";a="234642290"
From: Andi Kleen <andi@firstfloor.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] RFC SLUB: increase range of kmalloc slab sizes
References: <1350145885-6099-1-git-send-email-richard@rsk.demon.co.uk>
Date: Sat, 13 Oct 2012 16:46:19 -0700
In-Reply-To: <1350145885-6099-1-git-send-email-richard@rsk.demon.co.uk>
	(Richard Kennedy's message of "Sat, 13 Oct 2012 17:31:23 +0100")
Message-ID: <m2y5jarl4k.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy <richard@rsk.demon.co.uk> writes:

> This patch increases the range of slab sizes available to kmalloc, adding
> slabs half way between the existing power of two sized ones, so allowing slightly
>  more efficient use of memory.
> Most of the new slabs already exist as kmem_cache slabs so only the 1.5k,3k & 6k 
> are entirely new.

I'm not sure what order slab/slub use by default these days, but for
order 0 none of your new sizes sound like a winner:

4K / 1.5 = 2  = 4K / 2K 
4K / 3K  = 1  = 4K / 4K
8K / 6K  = 1  = 8K / 8K

I think you need better data that it actually saves memory with some
reproducible workloads.

Revisiting the sizes is a good idea -- the original Bonwick slab paper
explicitely recommended against power of twos -- but I think it needs a
more data driven process to actually select better ones than what you
used.

Most likely the best fits are different between 32bit and 64bit
and also will change occasionally as kernel data structures grow
(or rarely shrink)

In fact I suspect it would be an interesting option for feedback
control for embedded kernels - measure workload, reboot/recompile with
slab fitting the workload well.

So I think before trying any of this you need a good slab profiler
and a good set of workloads.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
