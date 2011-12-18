Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab1LRA0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 19:26:41 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23815 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1LRA0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 19:26:39 -0500
Date: Sun, 18 Dec 2011 01:26:37 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Put braces around potentially empty 'if' body in
 handle_pte_fault()
In-Reply-To: <1324167535.3323.63.camel@edumazet-laptop>
Message-ID: <alpine.LNX.2.00.1112180125250.21784@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1112180059080.21784@swampdragon.chaosbits.net> <1324167535.3323.63.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1228915649-1324167997=:21784"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1228915649-1324167997=:21784
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 18 Dec 2011, Eric Dumazet wrote:

> Le dimanche 18 décembre 2011 à 01:03 +0100, Jesper Juhl a écrit :
> > If one builds the kernel with -Wempty-body one gets this warning:
> > 
> >   mm/memory.c:3432:46: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> > 
> > due to the fact that 'flush_tlb_fix_spurious_fault' is a macro that
> > can sometimes be defined to nothing.
> > 
> > I suggest we heed gcc's advice and put a pair of braces on that if.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  mm/memory.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 829d437..9cf1b48 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -3428,9 +3428,9 @@ int handle_pte_fault(struct mm_struct *mm,
> >  		 * This still avoids useless tlb flushes for .text page faults
> >  		 * with threads.
> >  		 */
> > -		if (flags & FAULT_FLAG_WRITE)
> > +		if (flags & FAULT_FLAG_WRITE) {
> >  			flush_tlb_fix_spurious_fault(vma, address);
> > +		}
> >  	}
> >  unlock:
> >  	pte_unmap_unlock(pte, ptl);
> > -- 
> > 1.7.8
> > 
> 
> Thats should be fixed in the reverse way :
> 
> #define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
> 

I did consider that, bot opted for the other solution since there was only 
one user. But, on second thought, you are right, I should just have made 
the macro safe so that future uses also won't have problems. Will send a 
new patch in a minute.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1228915649-1324167997=:21784--
