Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab0KGL16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 06:27:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab0KGL15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 06:27:57 -0500
Date: Sun, 7 Nov 2010 12:27:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
 reduce ease of attacking
Message-ID: <20101107112709.GA2634@elte.hu>
References: <20101104122906.GH25118@suse.de>
 <20101104135802.GA31416@elte.hu>
 <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
 <20101104190804.GA16099@elte.hu>
 <20101104212920.GA31256@1wt.eu>
 <20101104215157.GA25128@elte.hu>
 <20101104223526.GC31236@1wt.eu>
 <20101107085016.GA23843@elte.hu>
 <20101107094932.GT4627@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107094932.GT4627@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> Hi Ingo,
> 
> On Sun, Nov 07, 2010 at 09:50:16AM +0100, Ingo Molnar wrote:
> > 
> > * Willy Tarreau <w@1wt.eu> wrote:
> > 
> > > On Thu, Nov 04, 2010 at 10:51:57PM +0100, Ingo Molnar wrote:
> > > > > Quite honnestly, it's the worst idea I've ever read to protect the kernel. Kernel 
> > > > > version is needed at many places, when building some code which relies on presence 
> > > > > of syscall X or Y depending on a version, etc... [...]
> > > > 
> > > > Actually that's not true, since we have a kernel ABI, and since there's many 
> > > > backports of newer kernel features into older kernels that it's generally not
> > > > needed nor meaningful to know the kernel version for syscalls.
> > > > 
> > > > Returning -ENOSYS is the general standard we use to communicate syscall 
> > > > capabilities.
> > > > 
> > > > In fact using kernel version to switch around library functionality is a bug i'd 
> > > > argue.
> > > 
> > > I'm sorry Ingo, but I still don't agree. We've had several versions of epoll, 
> > > several (some even buggy) versions of splice() which cannot even be detected 
> > > without checking the kernel release. And those are just two that immediately come 
> > > to my mind. If we've been providing a version for the last 19 years, it surely had 
> > > some valid uses.
> > 
> > I'm sorry Willy, but you are mostly wrong - and there's no need to speculate here 
> > really. Just try the patch below :-)
> > 
> > If your claim that 'kernel version is needed at many places' is true then why am i 
> > seeing this on a pretty general distro box bootup:
> > 
> >  [root@aldebaran ~]# uname -a
> >  Linux aldebaran 2.6.99-tip-01574-g6ba54c9-dirty #1 SMP Sun Nov 7 10:24:38 CET 2010 x86_64 x86_64 x86_64 GNU/Linux
> 
> I don't understand the point you're trying to make with this patch. [...]

It was a simple experiement to support my rather simple argument which you disputed.

> [...] Obviously we can pretend to be any version, [...]

Ok, it's a pretty cavalier style of arguing that you now essentially turn around 
your earlier claim that the 'kernel version is needed at many places' and say what 
i've been saying, prefixed with 'obviously' ;-)

Yes, it's obvious that the kernel version is not needed for many functional purposes 
on a modern distro - and that was my exact point.

I cannot think of a single valid case where the proper user-space solution to some 
ABI compatibility detail is a kernel version check. I'd even argue that we want to 
keep unprivileged user-space from being able to implement such crappy version checks 
...

Thanks,

	Ingo
