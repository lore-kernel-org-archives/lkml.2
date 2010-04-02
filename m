Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0DBX3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 19:29:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901Ab0DBX3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 19:29:50 -0400
Date: Fri, 2 Apr 2010 16:24:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Jason Wessel <jason.wessel@windriver.com>,
       Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net, linux-arm@vger.kernel.org
Subject: Re: [PATCH 4/5] kgdb: Use atomic operators which use barriers
In-Reply-To: <20100402222516.GA11073@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1004021621300.3634@i5.linux-foundation.org>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com> <1270233145-29335-2-git-send-email-jason.wessel@windriver.com> <1270233145-29335-3-git-send-email-jason.wessel@windriver.com> <1270233145-29335-4-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-5-git-send-email-jason.wessel@windriver.com> <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org> <4BB64762.6040806@windriver.com> <alpine.LFD.2.00.1004021238270.3634@i5.linux-foundation.org>
 <20100402222516.GA11073@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, Russell King - ARM Linux wrote:
> 
> Actually, in future threads you end up agreeing with my position...

I always agreed that it was not a memory barrier.

In fact, the commit that extended on the "volatile-considered-harmful" 
patch from you has this quote from me in the commit logs:

    Linus sayeth:
    
    : I don't think it was ever the intention that it would be seen as anything
    : but a compiler barrier, although it is obviously implied that it might
    : well perform some per-architecture actions that have "memory barrier-like"
    : semantics.
    :
    : After all, the whole and only point of the "cpu_relax()" thing is to tell
    : the CPU that we're busy-looping on some event.
    :
    : And that "event" might be (and often is) about reading the same memory
    : location over and over until it changes to what we want it to be.  So it's
    : quite possible that on various architectures the "cpu_relax()" could be
    : about making sure that such a tight loop on loads doesn't starve cache
    : transactions, for example - and as such look a bit like a memory barrier
    : from a CPU standpoint.
    :
    : But it's not meant to have any kind of architectural memory ordering
    : semantics as far as the kernel is concerned - those must come from other
    : sources.

which I think is pretty clear. 

But that quote seems to be the one where you then think I "agree" with 
you.

			Linus
