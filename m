Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab0LTKeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:34:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:38939 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab0LTKeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:34:14 -0500
Subject: Re: [PATCH RFC tip/core/rcu 13/20] rcu: increase
 synchronize_sched_expedited() batching
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
In-Reply-To: <20101219163552.GF2143@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
	 <1292619291-2468-13-git-send-email-paulmck@linux.vnet.ibm.com>
	 <4D0CDD93.7040907@kernel.org> <20101218201419.GD2143@linux.vnet.ibm.com>
	 <4D0DD3D2.4030606@kernel.org>  <20101219163552.GF2143@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 11:33:51 +0100
Message-ID: <1292841231.2708.136.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 08:35 -0800, Paul E. McKenney wrote:
> >  (int)((unsigned)(a) - (unsigned)(b)) < 0
> 
> Unfortunately, no.  :-(
> 
> The (int) converts from unsigned to signed, and if the upper bit of
> the unsigned difference is non-zero, then the paragraph I quoted above
> applies, and the standard allows the compiler to do whatever it wants.
> 
As noted in the previous reply, that would render quite a lot of our
time-keeping code broken. I think its safe to assume this works.

Look at time_after() for example:

#define time_after(a,b)		\
	(typecheck(unsigned long, a) && \
	 typecheck(unsigned long, b) && \
	 ((long)(b) - (long)(a) < 0))

