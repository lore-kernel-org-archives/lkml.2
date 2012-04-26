Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357Ab2DZU3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:29:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53503 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab2DZU3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:29:51 -0400
Date: Thu, 26 Apr 2012 13:29:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 6/6] rcu: Reduce cache-miss
 initialization latencies for large systems
Message-ID: <20120426202940.GL2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335444707.13683.14.camel@twins>
 <20120426141213.GB2407@linux.vnet.ibm.com>
 <1335454137.13683.95.camel@twins>
 <20120426161509.GE2407@linux.vnet.ibm.com>
 <1335469319.2463.97.camel@laptop>
 <1335469664.2463.98.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335469664.2463.98.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042620-6148-0000-0000-0000055A381A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 09:47:44PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-04-26 at 21:41 +0200, Peter Zijlstra wrote:
> > 
> > I can very easily give you the size (nr cpus in) a node, still as long
> > as you iterate the cpu space linearly that's not going to be much
> > help.
> > 
> Oh, I forgot, the numa masks etc are available, depending on
> CONFIG_NUMA, as cpumask_of_node(n).

These change with each CPU-hotplug operation?  Or is a given CPU
hotplug operation guaranteed to change only those node masks that
the CPU was (or will be, in the case of online) a member?

							Thanx, Paul

