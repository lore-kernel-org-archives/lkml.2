Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581Ab2FDPHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:07:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39289 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab2FDPG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:06:59 -0400
Date: Mon, 4 Jun 2012 07:54:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: automount hangs during boot somewhere in rcu_barrier.
Message-ID: <20120604145432.GA2490@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120603113236.GW2311@redhat.com>
 <20120604031549.GE2357@linux.vnet.ibm.com>
 <20120604074803.GA23670@redhat.com>
 <20120604100925.GC23670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604100925.GC23670@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060415-3270-0000-0000-000006E361F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 01:09:25PM +0300, Gleb Natapov wrote:
> On Mon, Jun 04, 2012 at 10:48:03AM +0300, Gleb Natapov wrote:
> > On Sun, Jun 03, 2012 at 08:15:49PM -0700, Paul E. McKenney wrote:
> > > Hmmm...  Could you please try disabling CONFIG_RCU_FAST_NO_HZ?  If that
> > > makes the problem go away, I have some patches 3.6-targeted patches
> > > for you.
> > Will report back.
> > 
> Do not see any problems with the option disabled.

OK, then you are probably being bitten by the same bug that was biting
Pascal and Heiko.  Could you please apply the following series from -rcu?

	bf7757c3 (Merge commit 'v3.4-rc6' into HEAD)
	edc17350 (RCU_FAST_NO_HZ detection of callback adoption)
	8e03a88e (Update RCU_FAST_NO_HZ tracing for lazy callbacks)
	f2298c63 (Move RCU_FAST_NO_HZ per-CPU variables to rcu_dynticks structure)
	05cc0fc9 (Precompute RCU_FAST_NO_HZ timer offsets)
	477fca01 (Dump only the current CPU's buffers for idle-entry/exit warnings)
	f29075fb (The rcu_needs_cpu() function is not a quiescent state)

Of these, 05cc0fc9 (Precompute RCU_FAST_NO_HZ timer offsets) is likely
to be the most relevant.  The -rcu tree may be found at:

	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git

Please let me know if you have any trouble pulling this series.

							Thanx, Paul

