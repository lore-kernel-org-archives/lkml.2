Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2GIRpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:45:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55498 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2GIRpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:45:45 -0400
Date: Mon, 9 Jul 2012 19:45:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/6] rcu: Allow rcu_user_enter()/exit() to nest
Message-ID: <20120709174535.GD8185@somewhere.redhat.com>
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
 <1341576018-10721-3-git-send-email-fweisbec@gmail.com>
 <4FF9AD2A.1000901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF9AD2A.1000901@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 06:54:18PM +0300, Avi Kivity wrote:
> On 07/06/2012 03:00 PM, Frederic Weisbecker wrote:
> > Allow calls to rcu_user_enter() even if we are already
> > in userspace (as seen by RCU) and allow calls to rcu_user_exit()
> > even if we are already in the kernel.
> > 
> > This makes the APIs more flexible to be called from architectures.
> > Exception entries for example won't need to know if they come from
> > userspace before calling rcu_user_exit().
> 
> I guess I should switch kvm to rcu_user_enter() and co, so we can
> disable the tick while running in a guest.  But where are those
> functions?  What are the rules for calling them?

I guess we need to have a closer look at the guest case first. We probably need
to take some care about specifics in time and load accounting usually
handled by the tick before we can shut it down. RCU is only part of the
problem.
