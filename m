Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750762Ab1COEAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 00:00:22 -0400
Received: from mail4.comsite.net ([205.238.176.238]:14964 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1COEAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 00:00:21 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=75.92.62.227;
Subject: Re: [01/22] sched: Provide scheduler_ipi() callback in response to
 smp_send_reschedule()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
From: Milton Miller <miltonm@bga.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <1299857247.2308.5990.camel@twins>
References: <20110302174120.313761743@chello.nl>
	 <sched-ipi-callback-comment@mdm.bga.com>
	<1299857247.2308.5990.camel@twins>
Message-ID: <sched-ipi-callback-comment-2@mdm.bga.com>
Date: Mon, 14 Mar 2011 21:59:18 -0600
X-Originating-IP: 75.92.62.227
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011 16:27:27 +0100, Peter Zijlstra wrote:
> 
> On Fri, 2011-03-11 at 09:07 -0600, Milton Miller wrote:
> > >       case PPC_MSG_RESCHEDULE:
> > >               /* we notice need_resched on exit */
> > > +		    smp_reschedule_ipi()
> >
> > This comment should also be removed, as it was documenting the empty
> > action.
> 
> But its still true, TIF_NEED_RESCHED isn't going away and we still
> notice that on the interrupt return path.

Just because it is true does not mean it is useful.  Why is this site
different than the twenty odd other call sites that it needs to document
the behaivors requried upon exiting the kernel from interrupt deep in this
interrupt handling call path?  Why is it not placed after the call, where
it would talk about what happens next instead of what will happen later?
For that matter, what does on exit mean?

I went ahead and sent this when I saw the comments questioning the
sparc 32 part of the patch and thought you might respin.  But if this is
already committed then I will submit a followup patch for consideration
after this is merged.

milton
