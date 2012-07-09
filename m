Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab2GIRnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:43:32 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:54683 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2GIRnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:43:31 -0400
Date: Mon, 9 Jul 2012 19:43:23 +0200
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
Subject: Re: [PATCH 6/6] x86: Exit RCU extended QS on notify resume
Message-ID: <20120709174321.GC8185@somewhere.redhat.com>
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
 <1341576018-10721-7-git-send-email-fweisbec@gmail.com>
 <20120706163338.GW2522@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706163338.GW2522@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 09:33:38AM -0700, Paul E. McKenney wrote:
> On Fri, Jul 06, 2012 at 02:00:18PM +0200, Frederic Weisbecker wrote:
> > do_notify_resume() may be called on irq exit but it won't
> > be protected between rcu_irq_enter() and rcu_irq_exit()
> > and we don't call rcu_user_exit() on irq entry (unlike
> > syscalls/exceptions entry).
> > 
> > Since it can use RCU read side critical section, we must call
> > rcu_user_exit() before doing anything there.
> > 
> > This complete support for RCU userspace extended quiescent state
> > in x86.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Alessio Igor Bogani <abogani@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Avi Kivity <avi@redhat.com>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Geoff Levand <geoff@infradead.org>
> > Cc: Gilad Ben Yossef <gilad@benyossef.com>
> > Cc: Hakan Akkan <hakanakkan@gmail.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Kevin Hilman <khilman@ti.com>
> > Cc: Max Krasnyansky <maxk@qualcomm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Stephen Hemminger <shemminger@vyatta.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  arch/x86/Kconfig         |    1 +
> >  arch/x86/kernel/signal.c |    2 ++
> >  2 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index c70684f..38dfcc2 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -95,6 +95,7 @@ config X86
> >  	select KTIME_SCALAR if X86_32
> >  	select GENERIC_STRNCPY_FROM_USER
> >  	select GENERIC_STRNLEN_USER
> > +	select HAVE_RCU_USER_QS if X86_64
> 
> And I will bite yet again.  Why only 64-bit kernels?
> 
> 							Thanx, Paul

Because I don't want to spend time on implementing it the same way on 32
in case people disagree with the whole design :)
