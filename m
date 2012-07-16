Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2GPW5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:57:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47096 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2GPW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:57:43 -0400
Date: Tue, 17 Jul 2012 00:57:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 00/11] rcu: Userspace RCU extended quiescent state v2
Message-ID: <20120716225733.GB28744@somewhere>
References: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
 <20120716221556.GH2403@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716221556.GH2403@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 03:15:56PM -0700, Paul E. McKenney wrote:
> On Wed, Jul 11, 2012 at 08:26:29PM +0200, Frederic Weisbecker wrote:
> > Hi,
> > 
> > There are significant changes this time. I reverted back to using
> > a TIF flag to hook on syscalls slow path and put the hooks on
> > high level exception handlers instead of low level ones.
> > 
> > It makes the code more portable between x86-32 and x86-64, it
> > makes the hooks clearer and easier to review and the overhead
> > is lowered in the off-case. This can be even better if we use
> > jump labels later.
> 
> Thank you, Frederic, I have queued these:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/idle
> 
> I had to rework patch 4 a bit to take into account that I dropped the
> rcu_switch_from() patch, please check it to make sure that I didn't
> rework it out of existence.
> 
> 							Thanx, Paul

Ok so it crashed once and I got 3 successful reboots afterward.
Not sure what was the issue, not sure that's even due to my patches.

Anyway, I'll tell you if I see the crash again.
