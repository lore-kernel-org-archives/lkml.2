Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0DJWAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 18:00:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60035 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab0DJWAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 18:00:00 -0400
Date: Sat, 10 Apr 2010 23:51:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100410215115.GA2599@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
 <20100410185145.GB28952@a1.tnic>
 <20100410185839.GA32035@a1.tnic>
 <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
 <20100410203628.GB32035@a1.tnic>
 <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org>
 <20100410212555.GA1797@a1.tnic>
 <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, Apr 10, 2010 at 02:30:49PM -0700

> On Sat, 10 Apr 2010, Borislav Petkov wrote:
> > 
> > Damn, nope, still no joy :(. It looked like it was fixed but one of the
> > test was to hibernate right after the 3 kvm guests were shut down and I
> > guess the mem freeing pattern kinda hits it where it most hurts.
> 
> Damn, I really hoped that was it. Three independent bugs found and fixed, 
> and still no joy? Oh well.

Yep, I'll redo the testing tomorrow, so that we are sure that even with
the _three_ bugs fixed we still hit the funky list element issue.

> > By the way, do we want to create a new thread - the mailchain is off the
> > screen limits of my netbook :)
> 
> I prefer to keep it in one thread so that they all show up together if I 
> need to, but feel free to start a new one. Not a biggie.

I'll keep the thread then - I didn't know it mattered. Mine was just a
suggestion, nevermind.

> > [  647.492781] BUG: unable to handle kernel NULL pointer dereference at (null)
> > [  647.493001] IP: [<ffffffff810c60a0>] page_referenced+0xee/0x1dc
> 
> Well, it sure is consistent. I'll start to think about what else could go 
> wrong..

Which could mean that even with those issues fixed, the real issue is
yet something else. Because obviously the fixes you throw at it don't
seem to change it - even the traces remain consistent across tests.
And if it is use-after-free case, the funny patterns could be some
shifted SLUB poison values which we happen to "see" through the dangling
pointer...  I dunno.

Hmm.

-- 
Regards/Gruss,
Boris.
