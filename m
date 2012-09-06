Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab2IFOhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:37:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40869 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab2IFOhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:37:50 -0400
Message-ID: <1346942162.18408.25.camel@twins>
Subject: Re: [PATCH tip/core/rcu 23/23] rcu: Simplify quiescent-state
 detection
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 16:36:02 +0200
In-Reply-To: <1346350718-30937-23-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-23-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The current quiescent-state detection algorithm is needlessly
> complex.

Heh! Be careful, we might be led into believing all this RCU is actually
really rather simple and this complexity is a bug on your end ;-)

>   It records the grace-period number corresponding to
> the quiescent state at the time of the quiescent state, which
> works, but it seems better to simply erase any record of previous
> quiescent states at the time that the CPU notices the new grace
> period.  This has the further advantage of removing another piece
> of RCU for which lockless reasoning is required. 

So why didn't you do that from the start? :-)

That is, I'm curious to know some history, why was it so and what led
you to this insight?
