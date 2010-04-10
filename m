Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab0DJAhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 20:37:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136Ab0DJAhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 20:37:07 -0400
Date: Fri, 9 Apr 2010 17:32:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Borislav Petkov <bp@alien8.de>,
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
In-Reply-To: <20100410003110.GI28964@cmpxchg.org>
Message-ID: <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
References: <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic> <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org> <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic>
 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
 <20100410003110.GI28964@cmpxchg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Apr 2010, Johannes Weiner wrote:
> 
> That leaves the chance that my code was correct and we leave a conceptual
> error around somewhere that can materialize again.

Absolutely. I really don't know whether your merge routine works or not. 
I'd just rather not have to even _try_ to understand it.

I have a fairly simple rule for most of the code I see: if I have a hard 
time understanding why it should work, I don't really want to rely on it.

> But I am at a point where simplification never sounded more blissful, so 
> yeah, I like it :)

Exactly. This is the "let's limit things a bit to keep them much simpler.

> Let's hope it fixes Boris's issue.

I'm going to just guess that it won't, and that Boris' issue was actually 
due to something else entirely, and we've all been staring at totally the 
wrong code.

But we can hope.

			Linus
