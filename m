Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0FAD3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:29:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab0FAD3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:29:13 -0400
Date: Mon, 31 May 2010 20:24:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006011051.25636.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1005312011490.3637@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <20100531094834.c1a684d1.akpm@linux-foundation.org> <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org> <201006011051.25636.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Rusty Russell wrote:
> 
> Sure, that simplicity has been eroded, but "crap" is harsh.

Crap is crap. Crap in locking is _especially_ dangerous.

> > module loading may well "work", but who the hell knows what it really 
> > results in?
> 
> I do.  If I didn't think so, I wouldn't have pushed the patch.

I'm sorry, but that's simply not good enough. We do not do ad-hoc locking 
"just becuse it works". Locking is too damn easy to get wrong, and "one 
person knows how the locking works" is not an excuse for anything at all.

> See, this I agree with, but you could have said this in far fewer words and
> much more politely.

Why? Why does "locking is crap" need any politeness? And why is it wrong 
to explain at length exactly _why_ our module locking is a piece of sh*t?

So explain why I should be more polite, or more terse?

> As posted, I had a patch to clean up the locking.  Seems you ignored it.

Umm. That patch was not the original one that I objected to, is it?

I do agree with your 1/2, btw, the one you posted under protest after I 
pointed out that the locking was crap. I was just explaining _why_ the 
locking was crap, and what the problem was to Andrew. 

I happen to also think that my solution to the problem is actually better 
and more straightforward than your one is. 

> > It's entirely possible that an interim fix (if we can't just fix the 
> > locking) is to _not_ use "strong_try_module_get()" at all, but instead 
> > just use "try_module_get()", and then after we've dropped the 
> > module_mutex, but _before_ we call the "init" function for the module, we 
> > wait for all the modules that this module depends on.
> 
> No, those modules could still fail init.

Umm. Which I took care of.

> > Doesn't that sound like the logical thing to do? And it wouldn't change 
> > any locking.
> 
> No, it sounds wrong, complex and fundamentally broken.

An dby "complex and fundamentally broken" you obviously mean "simpler and 
cleaner than the series posted by yourself". Or what?

I posted the damn series. Your next email even claims that my first one in 
the series (the bigger one) was a nice cleanup. You didn't comment on the 
second one, apparently because you're too embarrassed to admit you were 
wrong, and it wasn't all that 'wrong, complex, and fundamentally broken' 
to begin with. 

It was pretty damn straightforward, with no subtleties at all, in fact. 
Wasn't it?

		Linus
