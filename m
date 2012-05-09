Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460Ab2EIRQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:16:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55885 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab2EIRQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:16:46 -0400
Date: Wed, 9 May 2012 10:16:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sami Liedes <sami.liedes@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: kmemleak: Cannot insert 0xffff880007fedd28 into the object
 search tree (already existing)
Message-ID: <20120509171642.GC24636@google.com>
References: <20120506160828.GE13332@sli.dy.fi>
 <20120509155519.GL11099@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509155519.GL11099@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 04:55:19PM +0100, Catalin Marinas wrote:
> ----------------8<---------------------------------------------

git-am doesn't handle patches submitted this way.  Can you please put
the patch title as $SUBJ and put patch description in the body
followed by '---' for non-description comments?  Or is there some tool
that I should be using instead?

> commit 631d16e6284ddecd9d261f929582244f6757b678
> Author: Catalin Marinas <catalin.marinas@arm.com>
> Date:   Wed May 9 16:45:46 2012 +0100
> 
>     kmemleak: Fix the kmemleak tracking of the percpu areas with !SMP
>     
>     Kmemleak tracks the percpu allocations via a specific API and the
>     originally allocated areas must be removed from kmemleak (via
>     kmemleak_free). The code was already doing this for SMP systems.
>     
>     Reported-by: Sami Liedes <sami.liedes@iki.fi>
>     Cc: Tejun Heo <tj@kernel.org>
>     Cc: Christoph Lameter <cl@linux-foundation.org>
>     Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index f47af91..2daf6d5 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1885,6 +1885,8 @@ void __init setup_per_cpu_areas(void)
>  	fc = __alloc_bootmem(unit_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
>  	if (!ai || !fc)
>  		panic("Failed to allocate memory for percpu areas.");
> +	/* kmemleak tracks the percpu allocations separately */
> +	kmemleak_free(fc);
>  
>  	ai->dyn_size = unit_size;
>  	ai->unit_size = unit_size;

Applied to percpu/for-3.4-fixes.  Thanks.

-- 
tejun
