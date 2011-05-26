Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab1EZSQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:16:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43644 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256Ab1EZSQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:16:18 -0400
Date: Thu, 26 May 2011 20:15:54 +0200
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
Message-ID: <20110526181554.GB3572@elte.hu>
References: <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
 <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
 <20110526093040.GB19536@elte.hu>
 <4DDE31D6.4070209@redhat.com>
 <20110526113842.GA27618@elte.hu>
 <4DDE96B7.8030006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDE96B7.8030006@redhat.com>
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

> On 05/26/2011 02:38 PM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>  >  The biggest amount of RAM is the guest RAM image - but if that is
> >>  >  mmap(SHARED) and mapped using hugepages then the pte overhead
> >>  >  from a process model is largely mitigated.
> >>
> >>  That doesn't work with memory hotplug.
> >
> > Why not, if we do the sensible thing and restrict the size 
> > granularity and alignment of plugged/unplugged memory regions to 
> > 2MB?
> 
> Once forked, you cannot have new shared anonymous memory, can you?

We can have named shared memory.

Incidentally i suggested this to Pekka just yesterday: i think we 
should consider guest RAM images to be named files on the local 
filesystem (prefixed with the disk image's name or so, for easy 
identification), this will help with debugging and with swapping as 
well. (This way guest RAM wont eat up regular anonymous swap space - 
it will be swapped to the filesystem.)

As a sidenote, live migration might also become possible this way: in 
theory we could freeze a guest to its RAM image - which can then be 
copied (together with the disk image) to another box as files and 
restarted there, with some some hw configuration state dumped to a 
header portion of that RAM image as well. (outside of the RAM area)

Thanks,

	Ingo
