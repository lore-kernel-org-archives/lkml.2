Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2GFA3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:29:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43570 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab2GFA3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:29:54 -0400
Date: Thu, 5 Jul 2012 17:29:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu] Make RCU_FAST_NO_HZ respect nohz= boot
 parameter
Message-ID: <20120706002944.GL2522@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120705223731.GA27608@linux.vnet.ibm.com>
 <20120705230208.GB26150@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705230208.GB26150@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070600-1780-0000-0000-00000725E424
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000284; HX=3.00000191; KW=3.00000007;
 PH=3.00000001; SC=3.00000004; SDB=6.00154114; UDB=6.00034779; UTC=2012-07-06
 00:29:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 04:02:08PM -0700, Josh Triplett wrote:
> On Thu, Jul 05, 2012 at 03:37:31PM -0700, Paul E. McKenney wrote:
> > If the nohz= boot parameter disables nohz, then RCU_FAST_NO_HZ needs to
> > also disable itself.  This commit therefore checks for tick_nohz_enabled
> > being zero, disabling rcu_prepare_for_idle() if so.  This patch assumes
> > that tick_nohz_enabled can change at runtime: If this is not the case,
> > then a simpler approach suffices.
> 
> Allowing nohz to change at runtime seems like an entirely unnecessary
> bit of added complexity.  (So does having a boot parameter for it, but
> that one at least seems easier to handle.)

I will let representatives from the various distros expound to you on
their one-binary-only strategy for kernel builds.  ;-)

> What would the patch look like if you can assume nohz will never change
> at runtime?  And does anyone have a use case for changing nohz at
> runtime, rather than at boot time?

It would be a little bit simpler, but would break in very odd and
difficult-to-debug ways if anyone ever did allow it to change at runtime,
for example, to accommodate systems subject to varying workloads.

							Thanx, Paul

