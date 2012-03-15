Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161242Ab2CORzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:55:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:41912 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161079Ab2CORzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:55:21 -0400
Date: Thu, 15 Mar 2012 18:55:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 0/5] seqlock consolidation
In-Reply-To: <20120315174305.GD8943@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1203151854110.2466@ionos>
References: <20120314170736.617746873@linutronix.de> <20120315122112.GB8943@ZenIV.linux.org.uk> <alpine.LFD.2.02.1203151322020.2466@ionos> <20120315174305.GD8943@ZenIV.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Al Viro wrote:

> On Thu, Mar 15, 2012 at 01:28:03PM +0100, Thomas Gleixner wrote:
> 
> > The only way out is to lock d->d_lock which is contended, so the
> > reader side boosts the writer and waits for the lock to be
> > released. Though with the open coded seqlock we have no idea which
> > lock we need to take.
> > 
> > Any better ideas ?
> 
> So basically you want RT stuff to know that several areas in fs/dcache.c
> (from write_seqcount_begin() to write_seqcount_end()) are protected by
> (already held by that point) ->d_lock of corresponding dentries?
> 
> If that's it, I suggest to look for a solution that would express just that...
> Or do you want something on the reader side as well?

The problem is the reader side. If the reader preempts the writer then
the only way to make progress is to take the lock, but therefor I need
to know which lock I should take.

Thanks,

	tglx

