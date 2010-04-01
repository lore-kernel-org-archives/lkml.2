Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab0DADUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:20:33 -0400
Received: from waste.org ([173.11.57.241]:36843 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab0DADU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:20:28 -0400
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003311754110.3707@i5.linux-foundation.org>
References: <1270056227-5442-1-git-send-email-san@google.com>
	 <alpine.LFD.2.00.1003311036200.3707@i5.linux-foundation.org>
	 <1270071636.3552.978.camel@calx>
	 <alpine.LFD.2.00.1003311754110.3707@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Mar 2010 22:20:23 -0500
Message-ID: <1270092024.3552.1054.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 18:33 -0700, Linus Torvalds wrote:
> 
> On Wed, 31 Mar 2010, Matt Mackall wrote:
> >
> > Linus, I must say your charm has really worn thin. I've just stuck a
> > post-it on my monitor saying "don't be Linus" to remind me not to be
> > rude to my contributors. 
> 
> You didn't actually answer the problem, though.
> 
> I'm rude, because I think the code is buggy.

And what does that achieve? I've got plenty of other work I could be
doing where people are nice to me when asking me to fix bugs.

> I pointed out how, and why I 
> think it's pretty fundamental. You quoted it, but you didn't answer it.

Yes, I was muddling the distinction between pinned in page cache and
pinned in the mm, and you've just now re-clarified it for me. So I'll
agree the current code is bogus.

> So Matt, please actually address the _bug_ I pointed out rather than talk 
> about other things. And yes, getting rid of the vma accesses sounds like 
> it would fix it best. If that means that it doesn't work for hugepages, so 
> be it.

That'd actually take us back to where it was when it hit mainline, which
would make a lot of people unhappy. I wouldn't be one of them as there
thankfully aren't any huge pages in my world. But I'm convinced
put_user() must go. In which case, get_user_pages() stays, and I've got
to switch things to direct physical page access into that array. 

Even if I fix that, I believe San's original bug can still be triggered
though, as all the new callers to find_vma are run outside of the
target's mm_sem. Fixing that should be reasonably straight-forward.

-- 
http://selenic.com : development and support for Mercurial and Linux


