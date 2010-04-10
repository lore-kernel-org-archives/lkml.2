Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab0DJP2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 11:28:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab0DJP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 11:28:46 -0400
Date: Sat, 10 Apr 2010 08:24:02 -0700 (PDT)
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
In-Reply-To: <20100410112639.GA24708@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
References: <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org> <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic>
 <20100410112639.GA24708@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Apr 2010, Borislav Petkov wrote:
> > 
> > I will keep running that kernel in the next couple of days and keep you
> > informed in case this is the fix we're gonna use.
> 
> Yep, you jinxed it :)
> 
> This time we got stuck on the anon_vma->lock (yep, we've seen that
> oopsie before). So, it might be that we _really_ are staring at the
> wrong code... Back to square one.

No, I think we're good. I suspect this is a different issue. Do you have 
lockdep enabled, along with mutex and spinlock debugging etc? That might 
help pinpoint what triggers this.

But I think the fact that you are apparently not able to get the list 
corruption is a good sign. Of course, it might just be harder to trigger, 
and these things could all be a sign of a different bug, but my gut feel 
is that we did fix something, and you are just damn good at stressing the 
new code. Kudos.

		Linus
