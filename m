Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2JSR4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:56:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab2JSR4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:56:51 -0400
Date: Fri, 19 Oct 2012 19:57:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121019175737.GA1936@redhat.com>
References: <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com> <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com> <1350650286.30157.28.camel@twins> <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com> <1350668451.2768.60.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350668451.2768.60.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19, Peter Zijlstra wrote:
>
> But using preempt_{disable,enable} and using synchronize_sched() would
> be better (for PREEMPT_RCU) although it wouldn't fix anything
> fundamental.

BTW, I agree. I didn't even notice percpu-rwsem.h uses _rcu, not _sched.

> Fine goal, although somewhat arch specific. Also note that there's a
> relation between atomics and memory barriers, one isn't necessarily
> worse than the other, they all require synchronization of sorts.

As Paul pointed out, the fast path can avoid mb(). It is only needed
when "up_read" detects the writer.

Oleg.

