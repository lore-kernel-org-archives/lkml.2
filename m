Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0DJSb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 14:31:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043Ab0DJSb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 14:31:57 -0400
Date: Sat, 10 Apr 2010 11:26:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004101123540.3558@i5.linux-foundation.org>
References: <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
 <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic> <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <20100410163828.GA25579@a1.tnic>
 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Apr 2010, Linus Torvalds wrote:
> 
> I dunno. Does the above sound at all sane? Or am I just raving?
> 
> Something hacky like the above might fix it if I'm not just raving. I 
> really might be missing something here.

Btw, if this turns out to be accurate, the real fix is to probably just 
have a separate phase at the very end to actually release all the vma's, 
rather than do it in "free_page_tables()". We don't want to make the 
tlb-gather any more atomic than it already is. In fact, Nick is trying to 
make it preemptible.

So the patch included in that mail was meant very much as a "let's test my 
crazy theory" patch, rather than as the real solution.

The patch is also untested. Maybe it doesn't work at all and introduces 
new bugs. Caveat emptor.

			Linus
