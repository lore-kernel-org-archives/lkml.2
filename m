Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab0DIRy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 13:54:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab0DIRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 13:54:54 -0400
Date: Fri, 9 Apr 2010 10:50:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <20100409174041.GA10780@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org> <20100408054707.GA9299@a1.tnic> <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org> <20100408210035.GA25834@a1.tnic> <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org>
 <20100408234721.GB25834@a1.tnic> <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org> <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic> <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org> <20100409174041.GA10780@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Apr 2010, Borislav Petkov wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, Apr 09, 2010 at 09:35:15AM -0700
> 
> > Can you try with _just_ my patch?
> 
> Yep, yours along with the SLUB debugging piece just survived one
> hibernation cycle without a problem. Also, no SIGBUS-killed processes,
> all seems fine. Will continue stressing it though...
> 
> Let me know what you want me to do next.

Continue stress-testing it. I don't think my patch on its own should fix 
the original problem, but at least we now know why you got those NULL 
anon_vma's.

So what I _think_ will happen is that you'll be able to re-create the 
problem that started this all.  But I'd like to verify that, just because 
I'm anal and I'd like these things to be tested independently.

So assuming that the original problem happens again, if you can then apply 
Rik's patch, but add a

	dst->anon_vma = src->anon_vma;

to just before the success case (the "return 0") in anon_vma_clone(), 
that would be good.

			Linus
