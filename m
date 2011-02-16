Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1BPUqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:46:43 -0500
Received: from www.tglx.de ([62.245.132.106]:33442 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab1BPUqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:46:40 -0500
Date: Wed, 16 Feb 2011 21:45:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: David Daney <ddaney@caviumnetworks.com>,
        Roland McGrath <roland@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Julien Desfossez <julien.desfossez@polymtl.ca>,
        dominique.toupin@ericsson.com, ltt-dev@lists.casi.polymtl.ca,
        systemtap@sources.redhat.com, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, andi@firstfloor.org, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Porting "jump labels" to userspace
In-Reply-To: <20110216203953.GB2015@Krystal>
Message-ID: <alpine.LFD.2.00.1102162143430.2701@localhost6.localdomain6>
References: <4D5AA164.1050607@polymtl.ca> <y0mvd0ltgba.fsf@fche.csb> <AANLkTi=Nsy6fXE9=Njxs9LPHuohHzf=q5kD+fK765Rht@mail.gmail.com> <1297853778.3224.90.camel@springer.wildebeest.org> <20110216185056.CAD7B1806E0@magilla.sf.frob.com> <20110216200034.GA6066@Krystal>
 <20110216200449.1EB9618020E@magilla.sf.frob.com> <4D5C30D8.8070107@caviumnetworks.com> <20110216203953.GB2015@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011, Mathieu Desnoyers wrote:

> * David Daney (ddaney@caviumnetworks.com) wrote:
> > On 02/16/2011 12:04 PM, Roland McGrath wrote:
> >> IMHO there is not really so much to the in-kernel implementation that it's
> >> worth attempting to reuse the code in userland.  Pretty much all the work
> >> is in the details of the implementation that would naturally differ a lot
> >> in a different context.  If you understand the mechanism and the machine
> >> details, then implementing it well for a userland context is not a big deal
> >> and is cleaner to do from scratch than shoe-horning kernel-centric code
> >> into a wildly different context.
> >>
> >
> > Good point.
> >
> > Certainly the details of maintaining instruction cache coherency may be  
> > different in userspace.
> 
> Indeed, the arch-specific parts will need some extra care (which might, in the
> worse case scenario, require to suspend a whole process during the update), but
> the generic code in jump_label.c and jump_label.h could certainly be reused.

We talk about 500 lines of code, where half of it is modules specific
and the whole thing is full of kernelims. IMNSHO, that's faster
reimplemented from scratch than writing all the mails and get the
authors to sign off on the license change.

Thanks,

	tglx
