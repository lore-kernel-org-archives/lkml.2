Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab0KGLmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 06:42:50 -0500
Received: from 1wt.eu ([62.212.114.60]:47112 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab0KGLmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 06:42:49 -0500
Date: Sun, 7 Nov 2010 12:41:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101107114156.GV4627@1wt.eu>
References: <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de> <20101104190804.GA16099@elte.hu> <20101104212920.GA31256@1wt.eu> <20101104215157.GA25128@elte.hu> <20101104223526.GC31236@1wt.eu> <20101107085016.GA23843@elte.hu> <20101107094932.GT4627@1wt.eu> <20101107112709.GA2634@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107112709.GA2634@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 12:27:09PM +0100, Ingo Molnar wrote:
> > I don't understand the point you're trying to make with this patch. [...]
> 
> It was a simple experiement to support my rather simple argument which you disputed.

OK

> > [...] Obviously we can pretend to be any version, [...]
> 
> Ok, it's a pretty cavalier style of arguing that you now essentially turn around 
> your earlier claim that the 'kernel version is needed at many places' and say what 
> i've been saying, prefixed with 'obviously' ;-)

Huh ?

> Yes, it's obvious that the kernel version is not needed for many functional purposes 
> on a modern distro - and that was my exact point.
> 
> I cannot think of a single valid case where the proper user-space solution to some 
> ABI compatibility detail is a kernel version check.

Ingo, I believe you did not read a single line of my previous mail, because I
precisely gave you counter-examples of that. The first use is simply the user
running "uname -a" to see if *he* can safely enable feature X or Y which is
known to be badly broken in some old versions.

> I'd even argue that we want to 
> keep unprivileged user-space from being able to implement such crappy version checks 
> ...

I'd say that *YOU* want that despite the fact that on mainstream distros, it
buys nothing since it's easy to guess the real version anyway as I showed you.
Don't forget that you proposed this in order to hide symbols from a small set
of well-known distro kernels. And the most important in my opinion is that it
does not bring anything to those who are currently victim of exploits : those
who don't upgrade, because their uptime alone is enough to *know* that the
vuln you want to exploit is still there.

At some places, your proposal would probably end up with uname being
chmoded +s so that users stop asking the admin for trivial things. That
really makes no sense.

Willy

