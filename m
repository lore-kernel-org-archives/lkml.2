Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153Ab1LRATG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 19:19:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39439 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1LRATC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 19:19:02 -0500
Message-ID: <1324167535.3323.63.camel@edumazet-laptop>
Subject: Re: [PATCH] Put braces around potentially empty 'if' body in
 handle_pte_fault()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Sun, 18 Dec 2011 01:18:55 +0100
In-Reply-To: <alpine.LNX.2.00.1112180059080.21784@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1112180059080.21784@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 18 décembre 2011 à 01:03 +0100, Jesper Juhl a écrit :
> If one builds the kernel with -Wempty-body one gets this warning:
> 
>   mm/memory.c:3432:46: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> 
> due to the fact that 'flush_tlb_fix_spurious_fault' is a macro that
> can sometimes be defined to nothing.
> 
> I suggest we heed gcc's advice and put a pair of braces on that if.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  mm/memory.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 829d437..9cf1b48 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3428,9 +3428,9 @@ int handle_pte_fault(struct mm_struct *mm,
>  		 * This still avoids useless tlb flushes for .text page faults
>  		 * with threads.
>  		 */
> -		if (flags & FAULT_FLAG_WRITE)
> +		if (flags & FAULT_FLAG_WRITE) {
>  			flush_tlb_fix_spurious_fault(vma, address);
> +		}
>  	}
>  unlock:
>  	pte_unmap_unlock(pte, ptl);
> -- 
> 1.7.8
> 

Thats should be fixed in the reverse way :

#define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)



