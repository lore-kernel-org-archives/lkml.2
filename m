Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab1EZKrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:47:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1EZKrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:47:08 -0400
Date: Thu, 26 May 2011 13:46:36 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20110526104636.GL29458@redhat.com>
References: <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
 <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
 <BANLkTind9dUu3=OkSjXrkmrh5ik6xxT=vw@mail.gmail.com>
 <20110526085939.GG29458@redhat.com>
 <20110526103836.GC1763@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20110526103836.GC1763@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 12:38:36PM +0200, Ingo Molnar wrote:
> 
> * Gleb Natapov <gleb@redhat.com> wrote:
> 
> > On Thu, May 26, 2011 at 11:57:51AM +0300, Pekka Enberg wrote:
> > > Hi Avi,
> > > 
> > > On Thu, May 26, 2011 at 11:49 AM, Avi Kivity <avi@redhat.com> wrote:
> > >
> > > > You mean each thread will have a different security context? šI 
> > > > don't see the point. šAll threads share all of memory so it 
> > > > would be trivial for one thread to exploit another and gain all 
> > > > of its privileges.
> > > 
> > > So how would that happen? I'm assuming that once the security 
> > > context has been set up for a thread, you're not able to change 
> > > it after that. You'd be able to exploit other threads through 
> > > shared memory but how would you gain privileges?
> > 
> > By tricking other threads to execute code for you. Just replace 
> > return address on the other's thread stack.
> 
> That kind of exploit is not possible if the worker pool consists of 
> processes - which would be rather easy to achieve with tools/kvm/.
> 
Well, of course. There original question was about threads.

> In that model each process has its own stack, not accessible to other 
> worker processes. They'd only share the guest RAM image and some 
> (minimal) global state.
> 
> This way the individual devices are (optionally) isolated from each 
> other. In a way this is a microkernel done right ;-)
> 
But doesn't this design suffer the same problem as microkernel? Namely
a lot of slow IPCs?

--
			Gleb.
