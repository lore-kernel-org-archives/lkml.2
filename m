Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab1EYUTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:19:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60112 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab1EYUTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:19:42 -0400
Date: Wed, 25 May 2011 22:19:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees.cook@canonical.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110525201927.GA8397@elte.hu>
References: <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins>
 <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <20110525191152.GC19633@outflux.net>
 <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, May 25, 2011 at 12:11 PM, Kees Cook <kees.cook@canonical.com> wrote:
> >
> > Uhm, what? Chrome would use it. And LXC would. Those were stated very
> > early on as projects extremely interested in syscall filtering.
> 
> .. and I seriously doubt it is workable.
> 
> Or at least it needs some actual working proof-of-concept thing.
> Exactly because of issues like direct rendering etc, that require some
> of the nastier system calls to work at all.

Btw., Will's patch in this thread (which i think he tested with real 
code) implements an approach which detaches the concept from a rigid 
notion of 'syscall filtering' and opens it up for things like 
reliable pathname checks, memory object checks, etc. - without having 
to change the ABI.

If we go for syscall filtering as per bitmask, then we've pretty much 
condemned this to be limited to the syscall boundary alone.

So this sandboxing concept looked flexible enough to me to work 
itself up the security concept food chain *embedded in apps*.

<flame>

IMHO the key design mistake of LSM is that it detaches security 
policy from applications: you need to be admin to load policies, you 
need to be root to use/configure an LSM. Dammit, you need to be root 
to add labels to files!

This not only makes the LSM policies distro specific (and needlessly 
forked and detached from real security), but also gives the message 
that:

 'to ensure your security you need to be privileged'

which is the anti-concept of good security IMO.

So why not give unprivileged security policy facilities and let 
*Apps* shape their own security models. Yes, they will mess up 
initially and will reinvent the wheel. But socially IMO it will work 
a *lot* better in the long run: it's not imposed on them 
*externally*, it's something they can use and grow gradually. They 
will experience the security holes first hand and they will be *able 
to do something strategic about them* if we give them the right 
facilities.

At least the Chrome browser project appears to be intent on following 
such an approach. I consider a more bazaar alike approach more 
healthy, and it very much needs kernel help as LSMs are isolated from 
apps right now.

The thing is, we cannot possibly make the LSM situation much worse 
than it is today: i see *ALL* of the LSMs focused on all the wrong 
things!

But yes, i can understand that you are deeply sceptical.

</flame>

Thanks,

	Ingo
