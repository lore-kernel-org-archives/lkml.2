Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab2BPLwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:52:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:57220 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2BPLwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:52:46 -0500
Message-ID: <1329393115.2293.204.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
 implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Date: Thu, 16 Feb 2012 12:51:55 +0100
In-Reply-To: <20120216110030.GA1425@Krystal>
References: <20120213020951.GA12138@linux.vnet.ibm.com>
	 <20120215143116.GA1696@Krystal> <20120215145144.GA6277@Krystal>
	 <20120216063805.GF2976@linux.vnet.ibm.com> <20120216110030.GA1425@Krystal>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 06:00 -0500, Mathieu Desnoyers wrote:
> This brings the following question then: which memory barriers, in the
> scheduler activity, act as full memory barriers to migrated threads ? I
> see that the rq_lock is taken, but this lock is permeable in one
> direction (operations can spill into the critical section). I'm probably
> missing something else, but this something else probably needs to be
> documented somewhere, since we are doing tons of assumptions based on
> it. 

A migration consists of two context switches, one switching out the task
on the old cpu, and one switching in the task on the new cpu.

Now on x86 all the rq->lock grabbery is plenty implied memory barriers
to make anybody happy.

But I think, since there's guaranteed order (can't switch to before
switching from) you can match the UNLOCK from the switch-from to the
LOCK from the switch-to to make your complete MB.

Does that work or do we need more?
