Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab2DZP3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:29:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:54176 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2DZP3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:29:22 -0400
Message-ID: <1335454137.13683.95.camel@twins>
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
Date: Thu, 26 Apr 2012 17:28:57 +0200
In-Reply-To: <20120426141213.GB2407@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
	 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335444707.13683.14.camel@twins>
	 <20120426141213.GB2407@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 07:12 -0700, Paul E. McKenney wrote:
> On Thu, Apr 26, 2012 at 02:51:47PM +0200, Peter Zijlstra wrote:

> > Wouldn't it be much better to match the rcu fanout tree to the physical
> > topology of the machine?
> 
> From what I am hearing, doing so requires me to morph the rcu_node tree
> at run time.  I might eventually become courageous/inspired/senile
> enough to try this, but not yet.  ;-)

Yes, boot time with possibly some hotplug hooks.

> Actually, some of this topology shifting seems to me like a firmware
> bug.  Why not arrange the Linux-visible numbering in a way to promote
> locality for code sequencing through the CPUs?

I'm not sure.. but it seems well established on x86 to first enumerate
the cores (thread 0) and then the sibling threads (thread 1) -- one
'advantage' is that if you boot with max_cpus=$half you get all cores
instead of half the cores.

OTOH it does make linear iteration of the cpus 'funny' :-)

Also, a fanout of 16 is nice when your machine doesn't have HT and has a
2^n core count, but some popular machines these days have 6/10 cores per
socket, resulting in your fanout splitting caches.


