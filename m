Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2G3QHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:07:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab2G3QHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:07:04 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=rLFqv8mQjsYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=rzyDks9vhFNdzAiSlhUA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343664422.27983.12.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 30 Jul 2012 12:07:02 -0400
In-Reply-To: <20120730155059.GB17078@somewhere.redhat.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
	 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
	 <1343660892.20897.3.camel@twins>
	 <20120730155059.GB17078@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-30 at 17:51 +0200, Frederic Weisbecker wrote:
> On Mon, Jul 30, 2012 at 05:08:12PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-07-27 at 17:40 +0200, Frederic Weisbecker wrote:
> > > +++ b/kernel/user_hooks.c
> > > @@ -0,0 +1,56 @@
> > > +#include <linux/user_hooks.h>
> > > +#include <linux/rcupdate.h>
> > > +#include <linux/sched.h>
> > > +#include <linux/percpu.h>
> > > +
> > > +struct user_hooks {
> > > +       bool hooking;
> > > +       bool in_user;
> > > +};
> > 
> > I really detest using bool in structures.. but that's just me. Also this
> > really wants a comment as to wtf 'hooking' means. in_user I can just
> > about guess.
> 
> I really don't mind changing that to int. I just like them as bool because
> they better describe the purpose of the field.

Not only does bool describe it better, it should also allow gcc to
optimize it better as well. Unless Peter has a legitimate rational why
using bool in struct is bad, I would keep it as is.
 
> 
> hooking means that the hooks are set (the TIF flag is set on the current task
> and we also handle the exception hooks).
> 
> I can call that is_hooking instead? And/or add a comment to explain the
> purpose of this.

Would 'is_hooked' be better? 'is_hooking' sounds more like what women in
high heels, really short skirts and lots of makeup are doing late night
on a corner of a Paris street ;-)

A comment to explain the purpose should be added regardless.

-- Steve


