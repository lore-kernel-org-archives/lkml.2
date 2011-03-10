Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1CJA2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:28:32 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50314 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1CJA2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:28:30 -0500
Date: Wed, 9 Mar 2011 16:28:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] An RCU for SMP with a single CPU garbage collector
Message-ID: <20110310002822.GC2196@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110307210157.GG3104@linux.vnet.ibm.com>
 <20110307211613.GA26455@tsunami.ccur.com>
 <20110307225110.GA19414@tsunami.ccur.com>
 <20110308090742.GO3104@linux.vnet.ibm.com>
 <20110308155710.GA15138@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308155710.GA15138@tsunami.ccur.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 10:57:10AM -0500, Joe Korty wrote:
> On Tue, Mar 08, 2011 at 04:07:42AM -0500, Paul E. McKenney wrote:
> >> Thinking about it some more, the tap-into-syscall approach might
> >> work in my implementation, in which case the tap-into-preempt-enable
> >> code could go away.
> > 
> > OK, please let me know how that goes!
> > 
> >> Nice thing about RCU, the algorithms are infinitely mallable :)
> > 
> > Just trying to keep the code size finite.  ;-)
> 
> I hope to get to it this afternoon!  I especially like
> the lockless nature of JRCU, and that the dedicated cpus
> are not loaded down with callback inovcations either.
> Not sure how to support the PREEMPT_RCU mode though; so
> if Fredrick is planning to support that, that alone would
> make his approach the very best.

One thing for PREEMPT_RCU -- given that you will have other CPUs reading
the writes to the counters, you will need memory barriers in both
rcu_read_lock() and rcu_read_unlock().  Unless you can do the reading
of these counters locally from rcu_note_context_switch() or some such.
But in that case, your grace periods would extend indefinitely if the
thread in question never entered the scheduler.  (Not sure if you are
supporting this notion, but Frederic is.)

							Thanx, Paul
