Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab2HRE7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 00:59:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:29315 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2HRE7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 00:59:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,790,1336374000"; 
   d="scan'208";a="203982064"
Date: Sat, 18 Aug 2012 12:59:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: lockdep warning on rt_mutex_lock()
Message-ID: <20120818045908.GA7503@localhost>
References: <20120817100635.GA30765@localhost>
 <20120817134328.GB2872@linux.vnet.ibm.com>
 <20120817140240.GB539@localhost>
 <20120817144437.GC2872@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817144437.GC2872@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 07:44:37AM -0700, Paul E. McKenney wrote:
> On Fri, Aug 17, 2012 at 10:02:40PM +0800, Fengguang Wu wrote:
> > On Fri, Aug 17, 2012 at 06:43:28AM -0700, Paul E. McKenney wrote:
> > > On Fri, Aug 17, 2012 at 06:06:35PM +0800, Fengguang Wu wrote:
> > > > Greetings,
> > > > 
> > > > FYI, a lockdep warning:
> > > 
> > > Certainly looks problematic!
> > > 
> > > Any hint as to what version of the kernel produced this splat?
> > > (Yes, lazy of me to ask, I know, but I am not seeing it in my testing.)
> > 
> > It happens on both 3.5.0 and 3.6-rc1. Will bisect (try older kernels) help?
> > Bisect is handy for me :)
> 
> Bisection would be very welcome!!!  ;-)

The bisect result is...

commit 9e571a82f0cb205a65a0ea41657f19f22b7fabb8
Author: Paul E. McKenney <paul.mckenney@linaro.org>
Date:   Thu Sep 30 21:26:52 2010 -0700

    rcu: add tracing for TINY_RCU and TINY_PREEMPT_RCU
    
    Add tracing for the tiny RCU implementations, including statistics on
    boosting in the case of TINY_PREEMPT_RCU and RCU_BOOST.
    
    Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks,
Fengguang
