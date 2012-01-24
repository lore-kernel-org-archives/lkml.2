Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab2AXOvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:51:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:44252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab2AXOvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:51:51 -0500
Message-ID: <1327416705.2446.58.camel@twins>
Subject: Re: [PATCH 5/5] ipc/sem.c: alternatives to preempt_disable()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>
Date: Tue, 24 Jan 2012 15:51:45 +0100
In-Reply-To: <1318684920-2033-1-git-send-email-manfred@colorfullife.com>
References: <1318684920-2033-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-15 at 15:22 +0200, Manfred Spraul wrote:
> ipc/sem.c uses a custom wakeup scheme that relies on preempt_disable().
> On -RT, this causes increased latencies and debug warnings.
> 
> The patch adds two additional schemes:
> - one built around a completion - could be better for -RT kernels
> - one built around a spinlock - unfortunately it's broken
> - and the current one
> 
> Mike, Peter: Would the completion work on -rt?
> 
> My preferred solution would be the spinlock implementation:
> RT would use premptible spinlocks, mainline normal spinlocks.
> Thus both get the optimal implementation without any special code in
> ipc/sem.c.
> Unfortunately, I don't see how it could be fixed.

Sorry, I was convinced I replied to this, but I cannot actually find
anything in my send folder or elsewhere. Thanks for poking Andrew.

Yes I think it should work, and I'm afraid I have to agree with not
being able to make the spinlock thing work properly. Even if you were to
use arch_spin_* primitives you can still run into the 256 limit --
although not from the preempt_count in that case. Nor would arch_spin_
do what we need on -rt.


