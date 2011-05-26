Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1EZKjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:39:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60865 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab1EZKjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:39:15 -0400
Date: Thu, 26 May 2011 12:38:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>,
        James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526103836.GC1763@elte.hu>
References: <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
 <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
 <BANLkTind9dUu3=OkSjXrkmrh5ik6xxT=vw@mail.gmail.com>
 <20110526085939.GG29458@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110526085939.GG29458@redhat.com>
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


* Gleb Natapov <gleb@redhat.com> wrote:

> On Thu, May 26, 2011 at 11:57:51AM +0300, Pekka Enberg wrote:
> > Hi Avi,
> > 
> > On Thu, May 26, 2011 at 11:49 AM, Avi Kivity <avi@redhat.com> wrote:
> >
> > > You mean each thread will have a different security context?  I 
> > > don't see the point.  All threads share all of memory so it 
> > > would be trivial for one thread to exploit another and gain all 
> > > of its privileges.
> > 
> > So how would that happen? I'm assuming that once the security 
> > context has been set up for a thread, you're not able to change 
> > it after that. You'd be able to exploit other threads through 
> > shared memory but how would you gain privileges?
> 
> By tricking other threads to execute code for you. Just replace 
> return address on the other's thread stack.

That kind of exploit is not possible if the worker pool consists of 
processes - which would be rather easy to achieve with tools/kvm/.

In that model each process has its own stack, not accessible to other 
worker processes. They'd only share the guest RAM image and some 
(minimal) global state.

This way the individual devices are (optionally) isolated from each 
other. In a way this is a microkernel done right ;-)

Thanks,

	Ingo
