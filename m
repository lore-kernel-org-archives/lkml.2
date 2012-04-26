Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab2DZWEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:04:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34600 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554Ab2DZWEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:04:13 -0400
Subject: Re: [PATCH RFC tip/core/rcu 6/6] rcu: Reduce cache-miss
 initialization latencies for large systems
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
In-Reply-To: <20120426202940.GL2407@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
	 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335444707.13683.14.camel@twins>
	 <20120426141213.GB2407@linux.vnet.ibm.com>
	 <1335454137.13683.95.camel@twins>
	 <20120426161509.GE2407@linux.vnet.ibm.com>
	 <1335469319.2463.97.camel@laptop> <1335469664.2463.98.camel@laptop>
	 <20120426202940.GL2407@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Apr 2012 00:04:05 +0200
Message-ID: <1335477845.2463.131.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 13:29 -0700, Paul E. McKenney wrote:
> On Thu, Apr 26, 2012 at 09:47:44PM +0200, Peter Zijlstra wrote:
> > On Thu, 2012-04-26 at 21:41 +0200, Peter Zijlstra wrote:
> > > 
> > > I can very easily give you the size (nr cpus in) a node, still as long
> > > as you iterate the cpu space linearly that's not going to be much
> > > help.
> > > 
> > Oh, I forgot, the numa masks etc are available, depending on
> > CONFIG_NUMA, as cpumask_of_node(n).
> 
> These change with each CPU-hotplug operation?  Or is a given CPU
> hotplug operation guaranteed to change only those node masks that
> the CPU was (or will be, in the case of online) a member?

I'd have to check, but its either the last or they don't change at all
and you have to mask out the offline cpus yourself.

NUMA topology doesn't actually change due to hotplug, so there's no
reason to update masks that do not (or should not) contain the cpu under
operation.



