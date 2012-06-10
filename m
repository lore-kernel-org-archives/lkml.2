Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab2FJR5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 13:57:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49800 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2FJR5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 13:57:10 -0400
Date: Sun, 10 Jun 2012 10:54:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] rcu: Extended quiescent state for adaptive nohz
Message-ID: <20120610175456.GC2425@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
 <20120604181313.GL2490@linux.vnet.ibm.com>
 <CAFTL4hzqa1z4icSBwEqZXLjCrVsG+axm2TaGSaaMXkjazT0Qfw@mail.gmail.com>
 <20120604210709.GO2490@linux.vnet.ibm.com>
 <20120605103055.GA4553@somewhere.redhat.com>
 <20120605234640.GY2388@linux.vnet.ibm.com>
 <20120607142101.GI19842@somewhere.redhat.com>
 <20120607224508.GX19601@linux.vnet.ibm.com>
 <20120609225852.GC31957@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120609225852.GC31957@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061017-3270-0000-0000-0000070E47D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 12:58:56AM +0200, Frederic Weisbecker wrote:
> On Thu, Jun 07, 2012 at 03:45:08PM -0700, Paul E. McKenney wrote:
> > > I can see you've implemented a version for TinyRCU. Nohz cpusets only work on
> > > SMP right now because there must be at least one CPU running with the tick
> > > to maintain the timekeeping. I'm pretty confident that one day we'll remove
> > > the jiffies and we'll be able to do the whole timekeeping by using the TSC
> > > or so. There is quite a way before we reach that though.
> > 
> > In the meantime, would it make sense to slow the tick rate by a factor
> > of 10 or so on that one CPU when nothing else is going on?  Or does
> > timekeeping absolutely require running the tick at full speed?
> 
> I'm not sure of the possible consequences of that.

OK, so I will remove the TINY_RCU patches for the moment.  If reducing
tick speed on the sole remaining idle CPU ever becomes feasible and
useful, they are easy to add back in.

							Thanx, Paul

