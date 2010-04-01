Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0DAEbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 00:31:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796Ab0DAEbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 00:31:39 -0400
Date: Wed, 31 Mar 2010 21:27:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
In-Reply-To: <1270092024.3552.1054.camel@calx>
Message-ID: <alpine.LFD.2.00.1003312118010.3707@i5.linux-foundation.org>
References: <1270056227-5442-1-git-send-email-san@google.com>  <alpine.LFD.2.00.1003311036200.3707@i5.linux-foundation.org>  <1270071636.3552.978.camel@calx>  <alpine.LFD.2.00.1003311754110.3707@i5.linux-foundation.org> <1270092024.3552.1054.camel@calx>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Mar 2010, Matt Mackall wrote:
> > 
> > I'm rude, because I think the code is buggy.
> 
> And what does that achieve? I've got plenty of other work I could be
> doing where people are nice to me when asking me to fix bugs.

I would suggest you go back and read my original email once more, now that 
you realize that you had simply not understood the difference between 
physical page pinning and virtual page pinning.

Seriously.

Now that you understand why I called the code buggy, maybe you realize 
that calling the code "insane and misdesigned" is actually not overly 
rude: it's just an accurate representation of the state of the code.

And if you read the mail once more, you'll also notice that every single 
derogatory remark was about the _code_, not you.

Oh, and I did ask you for an explanation for why we shouldn't just remove 
it. There can't be all that many users. 

Because quite frankly, if you apparently want to keep the vma around, the 
code is going to get way more complex and ugly. You may be able to avoid 
some of the _worst_ crap if you require that user pointers have to always 
be u64-aligned. Yes, that's a very ugly and non-intuitive requirement for 
a read() interface, but probably better than the alternative.

Or maybe just do the double buffering, and limiting pagemap reads to 
fairly small chunks at a time.

		Linus
