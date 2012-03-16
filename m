Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2CPTom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:44:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2CPTol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:44:41 -0400
Date: Fri, 16 Mar 2012 20:44:36 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 06/11] huge-memory: Use lockdep_assert_held
Message-ID: <20120316194436.GN24602@redhat.com>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
 <1331924464-18023-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331924464-18023-7-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, Mar 16, 2012 at 12:00:59PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Use lockdep_assert_held to check for locks instead of an opencoded
> variant.
> 
> Cc: aarcange@redhat.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  mm/huge_memory.c |    4 ++--
>  mm/swap.c        |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 91d3efb..28669c6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2083,7 +2083,7 @@ static void collect_mm_slot(struct mm_slot *mm_slot)
>  {
>  	struct mm_struct *mm = mm_slot->mm;
>  
> -	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
> +	lockdep_assert_held(&khugepaged_mm_lock);

This check was intended to be a VM debug check, so getting enabled by
DEBUG_VM, not through lockdep. I mean I always have DEBUG_VM enabled
in all my kernels, but lockdep only enabled on my test system. So it's
not an opencoded variant strictly speaking.

My estimate is that what gets more tested is BUG_ON, second VM_BUG_ON,
third LOCKDEP. But hey, this code has been tested for a while so I'm
neutral and if you prefer the lockdep version it's up to you.

Thanks,
Andrea
