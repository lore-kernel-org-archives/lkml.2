Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2BCCoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 21:44:10 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51781 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2BCCoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 21:44:09 -0500
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 18:43:46 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC 0/3] Fix cpuidle_idle_call() RCU usage
Message-ID: <20120203024346.GE13456@leaf>
References: <20120203011208.GA2004@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203011208.GA2004@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 05:12:08PM -0800, Paul E. McKenney wrote:
> This patch series is a second attempt to fix the idle-loop uses of RCU,
> see https://lkml.org/lkml/2012/2/1/741 for v1.  Where the first series
> attempted to drive rcu_idle_enter() and rcu_idle_exit() further down
> into the Linux kernels multitude of idle loops, this patch instead
> marks specific idle-loop operations containing RCU read-side critical
> sections, as suggested by Nicolas Pitre and Steven Rostedt.  The possibility
> of code shared between idle and non-idle also requires the ability to nest
> rcu_idle_enter() calls.  The individual patches are as follows:
> 
> 1.	Allow nesting of rcu_idle_enter() and rcu_idle_exit().
> 2.	Add an RCU_NONIDLE() macro to enclose idle-loop code that
> 	contains RCU read-side critical sections.
> 3.	Use RCU_NONIDLE() to protect cpuidle_idle_call()'s tracepoints.
> 
> This patchset has the distinct advantage of avoiding touching any
> architecture-specific code.  ;-)
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
>  b/drivers/cpuidle/cpuidle.c |   12 ++++++++----
>  b/include/linux/rcupdate.h  |   27 +++++++++++++++++++++++++++
>  b/kernel/rcu.h              |   18 +++++++++++++++++-
>  b/kernel/rcutiny.c          |   16 ++++++++++++----
>  b/kernel/rcutree.c          |   19 +++++++++++++------
>  kernel/rcutiny.c            |    2 ++
>  kernel/rcutree.c            |    2 ++
>  7 files changed, 81 insertions(+), 15 deletions(-)

Looks good to me.  Much cleaner.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
