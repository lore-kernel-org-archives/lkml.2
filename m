Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab0FIKzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:55:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34681 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab0FIKzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:55:37 -0400
Date: Wed, 9 Jun 2010 11:55:18 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 07/28] extend KSM refcounts to the anon_vma root
Message-ID: <20100609105518.GC5650@csn.ul.ie>
References: <20100607110654.606530953@chello.nl> <20100607111407.033426211@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100607111407.033426211@chello.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 01:07:01PM +0200, Peter Zijlstra wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> KSM reference counts can cause an anon_vma to exist after the processe
> it belongs to have already exited.  Because the anon_vma lock now lives
> in the root anon_vma, we need to ensure that the root anon_vma stays
> around until after all the "child" anon_vmas have been freed.
> 
> The obvious way to do this is to have a "child" anon_vma take a
> reference to the root in anon_vma_fork.  When the anon_vma is freed
> at munmap or process exit, we drop the refcount in anon_vma_unlink
> and possibly free the root anon_vma.
> 
> The KSM anon_vma reference count function also needs to be modified
> to deal with the possibility of freeing 2 levels of anon_vma.  The
> easiest way to do this is to break out the KSM magic and make it
> generic.
> 
> When compiling without CONFIG_KSM, this code is compiled out.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <20100526154124.04607d04@annuminas.surriel.com>

Acked-by: Mel Gorman <mel@csn.ul.ie

> <SNIP>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
