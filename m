Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934992Ab2JaHoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:44:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38248 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab2JaHoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:44:15 -0400
Date: Wed, 31 Oct 2012 00:44:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        joe.korty@ccur.com
Subject: Re: [PATCH tip/core/rcu 0/2] v2 Add callback-free CPUs
Message-ID: <20121031074402.GV3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121031034552.GA1999@linux.vnet.ibm.com>
 <1351668321.4047.39.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351668321.4047.39.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103107-2876-0000-0000-0000018628F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 08:25:21AM +0100, Peter Zijlstra wrote:
> On Tue, 2012-10-30 at 20:45 -0700, Paul E. McKenney wrote:
> > This commit therefore adds the ability
> > for selected CPUs ("rcu_nocbs=" boot parameter) to have their
> > callbacks
> > offloaded to kthreads, inspired by Joe Korty's and Jim Houston's JRCU.
> > If the "rcu_nocb_poll" boot parameter is also specified, these
> > kthreads
> > will do polling, removing the need for the offloaded CPUs to do
> > wakeups. 
> 
> How much pain to make that dynamically configurable?

A fair amount of pain, though I do hope to make it runtime configurable
at some point.  Known problems include races between changes in the
nocb configuration, rcu_barrier(), grace-period initialization, and
CPU hotplug.  Should be solvable, but want to get the other bugs out of
the way first.

							Thanx, Paul

