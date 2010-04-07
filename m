Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0DGAOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:14:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932182Ab0DGAOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:14:37 -0400
Date: Tue, 6 Apr 2010 17:10:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <4BBBC240.3090302@redhat.com>
Message-ID: <alpine.LFD.2.00.1004061707250.3487@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org> <1270571019.1814.163.camel@barrios-desktop> <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <20100406120315.53ad7390.akpm@linux-foundation.org> <20100406194238.GB20357@a1.tnic> <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org> <20100406205123.GC20357@a1.tnic>
 <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org> <4BBBC240.3090302@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Apr 2010, Rik van Riel wrote:
> 
> It gets more fun.  It looks like the anon_vma is only
> allocated through anon_vma_alloc() and only handled
> by the functions in rmap.c
> 
> By themselves, all of those functions look alright.

Yes. Very trivially so, in fact.

> However, I think I may have found a possible bug in
> the interplay between anon_vma_prepare() and vma_adjust(),
> across several mprotect invocations.
> 
> Let me explain what I think may be going on in small
> steps, since it is quite subtle (assuming I am right).

Sounds at least possible. Way more likely than any of the "trivially 
obvious" code being buggy, or the SLUB layer suddenly having a serious bug 
that only the new user could trigger.

That said, the code that _really_ confuses me is the stuff that uses 
"anon_vma_clone()". Could you please also explain the code flow of 
vma_adjust() to mere mortals, please?

I suspect Borislav is sleeping. But at least we have a patch for him to 
test when he wakes up ;)

		Linus
