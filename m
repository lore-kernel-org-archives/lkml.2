Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0DLWQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 18:16:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006Ab0DLWQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 18:16:30 -0400
Date: Mon, 12 Apr 2010 15:11:53 -0700 (PDT)
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
In-Reply-To: <20100412215027.GA6263@liondog.tnic>
Message-ID: <alpine.LFD.2.00.1004121508290.3647@i5.linux-foundation.org>
References: <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic>
 <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
 <20100412215027.GA6263@liondog.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Apr 2010, Borislav Petkov wrote:
> 
> > I have a new theory. And this new theory is completely different from all 
> > the other things we've been looking at.
> 
> Yeah, because all starts with "I have a new theory..." :o)

Hey, all my other theories made sense too.. They just didn't work.

But as Edison said: I didn't fail, I just found three other ways to not 
fix your bug.

> > The patch below is my largely mindless try at fixing this. It's untested. 
> > I'm not entirely sure that it actually works. But it makes some amount of 
> > conceptual sense. No?
> 
> Linus, are you trying to give me a heart-attack? This sh*t just survived
> 20(!) hibernation runs without a problem (well, there is this nagging
> /sysfs lockdep warning) but apart from that, it survived! I even did my
> all time best when hitting on it. Normally, it used to crap up on the
> 6th cycle as latest. Now we're rock solid. And yes, there were something
> like ~64Mb in the swap cache.
> 
> Also, I have your verification stuff in addition to the 4 patches you
> sent before. Not a single WARN_ONCE got triggered. So I have a gut
> feeling that it is fixed but you never know with these beasts.

Ok. That does sound very positive. Of course, last time you sounded 
positive, I had an email from you half an hour later that said "oh no, it 
oopsed again". So I'll take it with a bit of salt, but on the whole I'll 
be optimistic about it.

				Linus
