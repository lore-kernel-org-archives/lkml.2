Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab0JRVXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:23:43 -0400
Received: from www.tglx.de ([62.245.132.106]:56104 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab0JRVXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:23:41 -0400
Date: Mon, 18 Oct 2010 23:23:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Rientjes <rientjes@google.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
In-Reply-To: <alpine.DEB.2.00.1010181340080.10965@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.00.1010182320440.6815@localhost6.localdomain6>
References: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com> <alpine.DEB.2.00.1010181340080.10965@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, David Rientjes wrote:

> On Mon, 18 Oct 2010, Frederic Weisbecker wrote:
> 
> > 9, 19 and 26 values are missing from the TIF shift range, probably
> > due to flags that were removed by the past. Now repack the range
> > so that we can quickly retrieve the remaining free shift slots.
> > 
> > But take care of keeping the seperation between high and low bits
> > as some masks are created on top of this boundary.
> > 
> 
> What's the benefit of doing this?
> 
> These flags are exported to userspace through SysRq-T, SysRq+W, the hung 
> task detector, and the rcu stall detector, so there may be external 
> dependencies testing for these bits.
> 
> We use this to look for TIF_MEMDIE to determine whether an oom killed task 
> has failed to exit and becomes hung after having access to memory 
> reserves, and that's one of the bits you've changed here.

I agree in general, but this is stupid as hell. No fcking interface
should exposed kernel internal flag bits just as hex values and no
fcking luser space should rely on it to be a subject of no change.

Seriously, if we can't even change TIF_* bits anymore then we are
doing something wrong. That's a pure kernel internal affair and
subject to change.

Thanks,

	tglx

