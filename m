Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2HNIcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:32:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:56909 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab2HNIcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:32:10 -0400
Date: Tue, 14 Aug 2012 10:32:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
In-Reply-To: <20120813233520.GG25632@google.com>
Message-ID: <alpine.LFD.2.02.1208141031180.32033@ionos>
References: <1344449428-24962-1-git-send-email-tj@kernel.org> <20120813233520.GG25632@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 08, 2012 at 11:10:24AM -0700, Tejun Heo wrote:
> > Timer internals are protected by irqsafe lock but the lock is
> > naturally dropped and irq enabled while a timer is executed.  This
> > makes dequeueing timer for execution and the actual execution
> > non-atomic against IRQs.  No matter what the timer function does, IRQs
> > can occur between timer dispatch and execution.  This means that an
> > IRQ handler could interrupt any timer in progress and it's impossible
> > for an IRQ handler to cancel and drain a timer.
> 
> If nobody objects, I'll route this through wq/for-3.7 together with
> "workqueue: use irqsafe timer in delayed_work" patchset.  If you
> object, please scream.

SCREAM!

I'll reply to the original posting later - still processing my
vacation backlog.

Thanks,

	tglx
