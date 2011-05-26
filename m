Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab1EZSHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:07:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab1EZSHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:07:34 -0400
Message-ID: <4DDE96B7.8030006@redhat.com>
Date: Thu, 26 May 2011 21:06:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
References: <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org> <20110526082451.GB26775@elte.hu> <4DDE1419.3000708@redhat.com> <20110526093040.GB19536@elte.hu> <4DDE31D6.4070209@redhat.com> <20110526113842.GA27618@elte.hu>
In-Reply-To: <20110526113842.GA27618@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 02:38 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
> >  >  The biggest amount of RAM is the guest RAM image - but if that is
> >  >  mmap(SHARED) and mapped using hugepages then the pte overhead
> >  >  from a process model is largely mitigated.
> >
> >  That doesn't work with memory hotplug.
>
> Why not, if we do the sensible thing and restrict the size
> granularity and alignment of plugged/unplugged memory regions to 2MB?

Once forked, you cannot have new shared anonymous memory, can you?

> We can fix guest Linux as well to not be stupid about the sizing of
> memory hotplug requests. It does hotplug based on the memory map we
> pass to it anyway.
>
> Am i missing something obvious here?

Yes, the new mmap() will be only visible in the calling process.

> >  >  Maybe even the isolation and per device access control of
> >  >  *same-class* devices from each other is possible: with careful
> >  >  implementation of the subsystem shared data structures. (which
> >  >  isnt much really)
> >
> >  Right, hardly at all in fact.  The problem comes from the side-band
> >  issues like reset, interrupts, hotplug, and whatnot.
>
> Yeah. There are two good aspects here i think:
>
>   - The sideband IPC overhead does not matter much, it's a side band.
>
>   - Spending the effort to isolate configuration details is worth it:
>     sideband code is a primary breeding ground for bugs and security
>     holes.
>
> The main worry to me would be the maintainability difference: does it
> result in much more complex code? As always i'm cautiously optimistic
> about that: i think once we try it we can find a suitable model ...
> It might even turn out to be more readable and more flexible in the
> end.

I also believe it will be more maintainable, especially if written in a 
language that has explicit support for message passing (e.g. Erlang).  
This is because it is more similar to how hardware actually works.  
However it needs to be designed in, it's not just a matter of switching 
a thread to a process.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

