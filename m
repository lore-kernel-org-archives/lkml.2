Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab0DHShQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:37:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933009Ab0DHShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:37:12 -0400
Date: Thu, 8 Apr 2010 11:32:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Borislav Petkov <bp@alien8.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <4BBE1F92.3060802@redhat.com>
Message-ID: <alpine.LFD.2.00.1004081128470.3558@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org> <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org> <20100408101925.FB9F.A69D9226@jp.fujitsu.com> <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
 <20100408054707.GA9299@a1.tnic> <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org> <4BBE1F92.3060802@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Apr 2010, Rik van Riel wrote:
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>

Yeah, I think I'll commit it as-is, assuming we get confirmation that it 
(along with your patch) actually ends up fixing the original problem.

I had actually had lockdep etc on with that patch, but for some reason I'd 
overlooked the SPINLOCK_SLEEP debugging, so I hadn't seen the stupid issue 
that Borislav pointed out. I wonder if LOCKDEP or spinlock debugging hould 
just select it. Small detail, but I should have caught that obvious bug 
myself.

> I haven't seen any places that insert VMAs by itself.
> Several strange places that allocate them, but they
> all appear to use the standard functions to insert them.

Yeah, it's complicated enough to add a vma with all the rbtree etc stuff 
that I hope nobody actually cooks their own. But I too grepped for vma 
allocations, and there were more of them than I expected, so...

		Linus
