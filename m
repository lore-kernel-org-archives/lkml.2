Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab1EZLjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:39:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36525 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757401Ab1EZLjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:39:11 -0400
Date: Thu, 26 May 2011 13:38:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526113842.GA27618@elte.hu>
References: <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
 <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
 <20110526093040.GB19536@elte.hu>
 <4DDE31D6.4070209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDE31D6.4070209@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> > The biggest amount of RAM is the guest RAM image - but if that is 
> > mmap(SHARED) and mapped using hugepages then the pte overhead 
> > from a process model is largely mitigated.
> 
> That doesn't work with memory hotplug.

Why not, if we do the sensible thing and restrict the size 
granularity and alignment of plugged/unplugged memory regions to 2MB?

We can fix guest Linux as well to not be stupid about the sizing of 
memory hotplug requests. It does hotplug based on the memory map we 
pass to it anyway.

Am i missing something obvious here?

> > Maybe even the isolation and per device access control of 
> > *same-class* devices from each other is possible: with careful 
> > implementation of the subsystem shared data structures. (which 
> > isnt much really)
> 
> Right, hardly at all in fact.  The problem comes from the side-band 
> issues like reset, interrupts, hotplug, and whatnot.

Yeah. There are two good aspects here i think:

 - The sideband IPC overhead does not matter much, it's a side band.

 - Spending the effort to isolate configuration details is worth it: 
   sideband code is a primary breeding ground for bugs and security 
   holes.

The main worry to me would be the maintainability difference: does it 
result in much more complex code? As always i'm cautiously optimistic 
about that: i think once we try it we can find a suitable model ... 
It might even turn out to be more readable and more flexible in the 
end.

Thanks,

	Ingo
