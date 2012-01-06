Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030276Ab2AFKhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:37:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230Ab2AFKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:37:36 -0500
Date: Fri, 6 Jan 2012 11:37:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
Message-ID: <20120106103734.GV11715@one.firstfloor.org>
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com> <20120105182846.GQ11715@one.firstfloor.org> <4F0630CC.7050001@zytor.com> <20120106014748.GS11715@one.firstfloor.org> <4F06566B.8080708@zytor.com> <20120106094922.GU11715@one.firstfloor.org> <4F06D979020000780006AC49@nat.nue.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F06D979020000780006AC49@nat.nue.novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I checked the most recent K8 (Hammer) and Pentium4 documentation,
> and didn't find mention of anything related. So pointing out where you

Sorry don't really plan to do any errata archaeology for this folly.

Maybe it got fixed in the latest versions, I remember them being there
on some early ones at least.

> >> > so making any of that slower is not a good idea.
> >> > 
> >> 
> >> Obviously not, but I'm perfectly fine turning REP_GOOD off on old broken
> >> CPUs.
> > 
> > That would be even worse.
> 
> How could you allow a CPU fall under REP_GOOD is its rep
> implementation is buggy.

The kernel never does >4GB copies, memsets, so it's not buggy.
It's just like any other obscure errata that doesn't matter because
it's not exercised.

REP_GOOD just means "string instructions are faster for 4K operations"

> 
> > You would slow a critical fast path operation down for something
> > that never happens?!?
> 
> It does happen, just (so far) not in-tree. It's a latent problem that's
> just waiting for someone else to run into. Apart from large bootmem
> allocations (where not even the latency of the memory clearing

Modern kernels are bootmem less.

> matters in any way, there's nothing I know of that would prevent
> someone from vmalloc()-ing a huge block of memory and then
> calling memset() on it (which ought to be tolerable in a preemptable
> kernel at least).

I bet there are more "int"s in the allocators and other code. It would
surprise me if it worked even with a changed memset.

Besides it obviously would be a bad idea on non preemptive kernels,
and since that can always happen it would be bad code, hopefully
never hitting any trees.

If you need it in Xen please just add the cmps there.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
