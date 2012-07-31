Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2GaO5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:57:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36609 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab2GaO5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:57:48 -0400
Date: Tue, 31 Jul 2012 16:57:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
Message-ID: <20120731145742.GA6934@gmail.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
 <1343660892.20897.3.camel@twins>
 <20120730155059.GB17078@somewhere.redhat.com>
 <20120731070640.GA2950@gmail.com>
 <20120731104845.GC17078@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731104845.GC17078@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Jul 31, 2012 at 09:06:40AM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Mon, Jul 30, 2012 at 05:08:12PM +0200, Peter Zijlstra wrote:
> > > > On Fri, 2012-07-27 at 17:40 +0200, Frederic Weisbecker wrote:
> > > > > +++ b/kernel/user_hooks.c
> > > > > @@ -0,0 +1,56 @@
> > > > > +#include <linux/user_hooks.h>
> > > > > +#include <linux/rcupdate.h>
> > > > > +#include <linux/sched.h>
> > > > > +#include <linux/percpu.h>
> > > > > +
> > > > > +struct user_hooks {
> > > > > +       bool hooking;
> > > > > +       bool in_user;
> > > > > +};
> > > > 
> > > > I really detest using bool in structures.. but that's just me. Also this
> > > > really wants a comment as to wtf 'hooking' means. in_user I can just
> > > > about guess.
> > > 
> > > I really don't mind changing that to int. I just like them as 
> > > bool because they better describe the purpose of the field.
> > > 
> > > hooking means that the hooks are set (the TIF flag is set on 
> > > the current task and we also handle the exception hooks).
> > > 
> > > I can call that is_hooking instead? And/or add a comment to 
> > > explain the purpose of this.
> > 
> > Please don't use this horrible naming - use something more 
> > technical like struct user_callback and callback::active, ok?
> 
> Ok, user callback should be fine. I'll respin with that.

One problem I have with the word 'hook' is that it's rarely 
clear whether it's used as a noun or a verb - and the naming in 
your patch shows that kind of confusion in action.

'callback', while a longer word, is almost always used as a noun 
within the kernel - and it also has a pretty narrow meaning.

Thanks,

	Ingo
