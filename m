Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab2D0EgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 00:36:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40233 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750858Ab2D0EgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 00:36:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19gzsFBidhg2p/Meg9NiHxpvcfgyl+dajj2VDNa+a
	ZI8lb9UGw/BusW
Message-ID: <1335501371.10374.30.camel@marge.simpson.net>
Subject: Re: [PATCH RFC tip/core/rcu 6/6] rcu: Reduce cache-miss
 initialization latencies for large systems
From: Mike Galbraith <efault@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Date: Fri, 27 Apr 2012 06:36:11 +0200
In-Reply-To: <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
	 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 09:42 -0700, Paul E. McKenney wrote: 
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Commit #0209f649 (rcu: limit rcu_node leaf-level fanout) set an upper
> limit of 16 on the leaf-level fanout for the rcu_node tree.  This was
> needed to reduce lock contention that was induced by the synchronization
> of scheduling-clock interrupts, which was in turn needed to improve
> energy efficiency for moderate-sized lightly loaded servers.
> 
> However, reducing the leaf-level fanout means that there are more
> leaf-level rcu_node structures in the tree, which in turn means that
> RCU's grace-period initialization incurs more cache misses.  This is
> not a problem on moderate-sized servers with only a few tens of CPUs,

With a distro config (4096 CPUs) interrupt latency is bad even on a
quad.  Traversing empty nodes taking locks and cache misses hurts.

-Mike

