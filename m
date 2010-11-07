Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab0KGLsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 06:48:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57890 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0KGLsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 06:48:22 -0500
Date: Sun, 7 Nov 2010 12:47:56 +0100
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
Message-ID: <20101107114756.GB3759@elte.hu>
References: <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
 <20101104190804.GA16099@elte.hu>
 <20101104212920.GA31256@1wt.eu>
 <20101104215157.GA25128@elte.hu>
 <20101104223526.GC31236@1wt.eu>
 <20101107085016.GA23843@elte.hu>
 <20101107094932.GT4627@1wt.eu>
 <20101107112709.GA2634@elte.hu>
 <20101107114156.GV4627@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107114156.GV4627@1wt.eu>
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

> On Sun, Nov 07, 2010 at 12:27:09PM +0100, Ingo Molnar wrote:
> > > I don't understand the point you're trying to make with this patch. [...]
> > 
> > It was a simple experiement to support my rather simple argument which you disputed.
> 
> OK
> 
> > > [...] Obviously we can pretend to be any version, [...]
> > 
> > Ok, it's a pretty cavalier style of arguing that you now essentially turn around 
> > your earlier claim that the 'kernel version is needed at many places' and say what 
> > i've been saying, prefixed with 'obviously' ;-)
> 
> Huh ?
> 
> > Yes, it's obvious that the kernel version is not needed for many functional purposes 
> > on a modern distro - and that was my exact point.
> > 
> > I cannot think of a single valid case where the proper user-space solution to some 
> > ABI compatibility detail is a kernel version check.
> 
> Ingo, I believe you did not read a single line of my previous mail, because I 
> precisely gave you counter-examples of that. [...]

I did read it and saw no valid counter-examples. You mentioned this one:

 > Take the splice() data corruption bug for instance. I believe it was fixed in 
 > 2.6.26 or 2.6.27 and backported late in the 2.6.25.X stable branch. Due to this, 
 > without knowing the kernel version, the user can't know whether it's safe to use 
 > splice() or not. I'm particularly aware of this one because I got quite a bunch 
 > of questions from users on this subject. But certainly there are a bunch of other 
 > ones.

That example is entirely bogus. The correct answer to a buggy, data-corrupting 
kernel is a fixed kernel. No ifs and when. No version checks in user-space. If 
user-space ever works around a bug in that fashion it's entirely broken and 
_deserves_ to be further broken via version fuzzing.

Do you know of a single such actual vmsplice() version check example in user-space, 
or have you just made it up?

Thanks,

	Ingo
