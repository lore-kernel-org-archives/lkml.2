Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab2GaKs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:48:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49754 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab2GaKs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:48:56 -0400
Date: Tue, 31 Jul 2012 12:48:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
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
Message-ID: <20120731104845.GC17078@somewhere.redhat.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
 <1343660892.20897.3.camel@twins>
 <20120730155059.GB17078@somewhere.redhat.com>
 <20120731070640.GA2950@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731070640.GA2950@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 09:06:40AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Jul 30, 2012 at 05:08:12PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2012-07-27 at 17:40 +0200, Frederic Weisbecker wrote:
> > > > +++ b/kernel/user_hooks.c
> > > > @@ -0,0 +1,56 @@
> > > > +#include <linux/user_hooks.h>
> > > > +#include <linux/rcupdate.h>
> > > > +#include <linux/sched.h>
> > > > +#include <linux/percpu.h>
> > > > +
> > > > +struct user_hooks {
> > > > +       bool hooking;
> > > > +       bool in_user;
> > > > +};
> > > 
> > > I really detest using bool in structures.. but that's just me. Also this
> > > really wants a comment as to wtf 'hooking' means. in_user I can just
> > > about guess.
> > 
> > I really don't mind changing that to int. I just like them as 
> > bool because they better describe the purpose of the field.
> > 
> > hooking means that the hooks are set (the TIF flag is set on 
> > the current task and we also handle the exception hooks).
> > 
> > I can call that is_hooking instead? And/or add a comment to 
> > explain the purpose of this.
> 
> Please don't use this horrible naming - use something more 
> technical like struct user_callback and callback::active, ok?

Ok, user callback should be fine. I'll respin with that.
