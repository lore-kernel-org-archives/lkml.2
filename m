Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab2HWPNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:13:10 -0400
Received: from nikam.ms.mff.cuni.cz ([195.113.20.16]:58533 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2HWPNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:13:04 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2012 11:13:04 EDT
Date: Thu, 23 Aug 2012 17:02:17 +0200
From: Jan Hubicka <hubicka@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        hubicka@ucw.cz
Subject: Re: RFC: Link Time Optimization support for the kernel
Message-ID: <20120823150217.GA29373@kam.mff.cuni.cz>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <20120820074835.GA6710@gmail.com>
 <20120820101044.GE16230@one.firstfloor.org>
 <20120821074921.GA10809@gmail.com>
 <20120821170216.GM16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821170216.GM16230@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If data structures could be encapsulated/internalized to 
> > subsystems and only global functions are exposed to other 
> > subsystems [which are then LTO optimized] then our include
> > file dependencies could become a *lot* simpler.
> 
> Yes, long term we could have these benefits.

Yes, LTO should make in long term life of developers easier, it is just not tool
how to get few extra % of performance.
There is a lot to do.
> 
> BTW I should add LTO does more than just inlining:
> - Drop unused global functions and variables
>   (so may cut down on ifdefs)
> - Detect type inconsistencies between files
> - Partial inlining (inline only parts of a function like a test
>   at the beginning)
> - Detect pure and const functions without side effects that can be more 
>   aggressively optimized in the caller.
Also noreturn and nothorw are autodetected (the second is probably not big deal
for kernel, but it makes some C++ codebases a lot smaller by elliminating EH
and cleanps). We plan to add more in near future.
> - Detect global clobbers globally. Normally any global call has to 
>   assume all global variables could be changed.  With LTO information some
>   of them can be cached in registers over calls.
> - Detect read only variables and optimize them
> - Optimize arguments to global functions (drop unnecessary arguments, 
>   optimize input/output etc.)

At this moment this really happen s within compilation units only.
It is one of harder optimizations to get working over whole program,
we are slowly getting infrasrtucture to make this possible.

> - Replace indirect calls with direct calls, enabling other
>   optimizations.
> - Do constant propagation and specialization for functions. So if a
>   function is called commonly with a constant it can generate a special 
>   variant of this function optimized for that.  This still needs more tuning (and
>   currently the code size impact is on the largish side), but I hope
>   to eventually have e.g. a special kmalloc optimized for GFP_KERNEL. 
>   It can also in principle inline callbacks.

Also profile propagation is done.  When function is called only on cold paths, it becomes
cold.

Thanks for all the hard work on LTO kernel, Andi!
Honza
> 
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.
