Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab0DJVfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 17:35:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967Ab0DJVf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 17:35:27 -0400
Date: Sat, 10 Apr 2010 14:30:49 -0700 (PDT)
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
In-Reply-To: <20100410212555.GA1797@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <20100410163828.GA25579@a1.tnic> <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic>
 <20100410185839.GA32035@a1.tnic> <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org> <20100410203628.GB32035@a1.tnic> <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org>
 <20100410212555.GA1797@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Apr 2010, Borislav Petkov wrote:
> 
> Damn, nope, still no joy :(. It looked like it was fixed but one of the
> test was to hibernate right after the 3 kvm guests were shut down and I
> guess the mem freeing pattern kinda hits it where it most hurts.

Damn, I really hoped that was it. Three independent bugs found and fixed, 
and still no joy? Oh well.

> By the way, do we want to create a new thread - the mailchain is off the
> screen limits of my netbook :)

I prefer to keep it in one thread so that they all show up together if I 
need to, but feel free to start a new one. Not a biggie.

> [  647.492781] BUG: unable to handle kernel NULL pointer dereference at (null)
> [  647.493001] IP: [<ffffffff810c60a0>] page_referenced+0xee/0x1dc

Well, it sure is consistent. I'll start to think about what else could go 
wrong..

		Linus
