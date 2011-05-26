Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab1EZKrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:47:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1EZKrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:47:03 -0400
Message-ID: <4DDE2F73.2020006@redhat.com>
Date: Thu, 26 May 2011 13:46:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gleb Natapov <gleb@redhat.com>, Pekka Enberg <penberg@kernel.org>,
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
References: <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org> <20110526082451.GB26775@elte.hu> <4DDE1419.3000708@redhat.com> <BANLkTind9dUu3=OkSjXrkmrh5ik6xxT=vw@mail.gmail.com> <20110526085939.GG29458@redhat.com> <20110526103836.GC1763@elte.hu>
In-Reply-To: <20110526103836.GC1763@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 01:38 PM, Ingo Molnar wrote:
> * Gleb Natapov<gleb@redhat.com>  wrote:
>
> >  On Thu, May 26, 2011 at 11:57:51AM +0300, Pekka Enberg wrote:
> >  >  Hi Avi,
> >  >
> >  >  On Thu, May 26, 2011 at 11:49 AM, Avi Kivity<avi@redhat.com>  wrote:
> >  >
> >  >  >  You mean each thread will have a different security context?  I
> >  >  >  don't see the point.  All threads share all of memory so it
> >  >  >  would be trivial for one thread to exploit another and gain all
> >  >  >  of its privileges.
> >  >
> >  >  So how would that happen? I'm assuming that once the security
> >  >  context has been set up for a thread, you're not able to change
> >  >  it after that. You'd be able to exploit other threads through
> >  >  shared memory but how would you gain privileges?
> >
> >  By tricking other threads to execute code for you. Just replace
> >  return address on the other's thread stack.
>
> That kind of exploit is not possible if the worker pool consists of
> processes - which would be rather easy to achieve with tools/kvm/.
>
> In that model each process has its own stack, not accessible to other
> worker processes. They'd only share the guest RAM image and some
> (minimal) global state.
>
> This way the individual devices are (optionally) isolated from each
> other. In a way this is a microkernel done right ;-)

It's really hard to achieve, since devices have global interactions.  
For example a PCI device can change the memory layout when a BAR is 
programmed.  So you would have a lot of message passing going on (not at 
runtime, so no huge impact on performance).  The programming model is 
very different.

Note that message passing is in fact quite a good way to model hardware, 
since what different devices actually do is pass messages to each 
other.  I expect if done this way, the device model would be better than 
what we have today.  But it's not an easy step away from threads.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

