Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3AGP6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:58:20 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51987 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3AGP6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:58:19 -0500
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.39.152
Date: Mon, 7 Jan 2013 07:58:10 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 1/1] Tiny RCU changes for 3.9
Message-ID: <20130107155810.GC11145@leaf>
References: <20130105175059.GA15961@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130105175059.GA15961@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 09:50:59AM -0800, Paul E. McKenney wrote:
> rcu: Provide RCU CPU stall warnings for tiny RCU
> 
> Tiny RCU has historically omitted RCU CPU stall warnings in order to
> reduce memory requirements, however, lack of these warnings caused Thomas
> Gleixner some debugging pain recently.  Therefore, this commit adds RCU
> CPU stall warnings to tiny RCU if RCU_TRACE=y.  This keeps the memory
> footprint small, while still enabling CPU stall warnings in kernels
> built to enable them.
> 
> This is still a bit on the high-risk side, so running this will likely
> be a debugging exercise.
> 
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Did you generate this patch with something other than git?  The
formatting seems a bit off: it doesn't have a diffstat or the usual
"---" line between the commit message and the patch.

This patch seems reasonable to me, but the repeated use of #if
defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE) seems somewhat
annoying, and fragile if you ever decide to change the conditions.  How
about defining an appropriate symbol in Kconfig for stall warnings, and
using that?

- Josh Triplett
