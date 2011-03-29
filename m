Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1C2Txd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:53:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:45428 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1C2Txc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:53:32 -0400
Date: Tue, 29 Mar 2011 21:53:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] lockdep: Print a nice description of an irq locking
 issue
In-Reply-To: <1301418845.14261.284.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1103292152370.2774@localhost6.localdomain6>
References: <1301418845.14261.284.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011, Steven Rostedt wrote:
>     other info that might help us debug this:
>     
>     Chain exists of:
>       &rq->lock --> lockA --> lockC
>     
>      Possible interrupt unsafe locking scenario:
>     
>            CPU0                    CPU1
>            ----                    ----
>       lock(lockC);
>                                    local_irq_disable();
>                                    lock(&rq->lock);
>                                    lock(lockA);
>       <Interrupt>
>         lock(&rq->lock)
>     
>      *** DEADLOCK ***

Cool stuff. I always have to twist my brain around those splats as
well :)

Thanks,

	tglx
