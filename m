Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1GVI3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:29:48 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:49359 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1GVI3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:29:46 -0400
Date: Fri, 22 Jul 2011 10:29:22 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the ptrace tree with the s390 tree
Message-ID: <20110722102922.61e7e279@mschwide>
In-Reply-To: <20110722080600.GE2622@htj.dyndns.org>
References: <20110720153320.a7f33784158ccb04fafcb5d6@canb.auug.org.au>
	<20110721080240.GZ3455@htj.dyndns.org>
	<20110721144447.GA7580@redhat.com>
	<20110722080600.GE2622@htj.dyndns.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 10:06:00 +0200
Tejun Heo <tj@kernel.org> wrote:

> On Thu, Jul 21, 2011 at 04:44:47PM +0200, Oleg Nesterov wrote:
> > On 07/21, Tejun Heo wrote:
> > > Also, I think we really should standardize what gets reported in these
> > > debug traps instead of letting each arch do its own thing.
> > 
> > May be we can standardize .si_info within the single arch at least ;)
> > 
> > I never understood what TRAP_HWBKPT/TRAP_BRKPT actually means, and
> > I can be easily wrong. But, afaics, on x86 PTRACE_SINGLESTEP results
> > in TRAP_TRACE. Unless the tracee steps over syscall, in this case
> > user_single_step_siginfo() sets TRAP_BRKPT. Hmm.
> > 
> > And unless I misread 248bed4b0f3c s390 thinks we need TRAP_HWBKPT.
> 
> Yeah, it looks like a proper mess.  It seems ptrace left too much for
> archs to decide.  Events to be reported should be defined by generic
> ptrace code (there can be some exceptions but only few) and archs
> should provide the mechanisms to implement them.  I'm planning on
> going through ptrace arch specifics soonish.  Hopefully it can be
> cleaned up somehow.

The ptrace code differs because the architectures are different in
regard to tracing, no? For s390 instruction single stepping and
hardware breakpoints are the same thing. It all gets mapped to the
progam-event-recording (PER) tracer. You have a start and an end
address and a few events you want to see for this area (e.g.
instruction fetch or storage alteration).
I could special case ptrace with PTRACE_SINGLESTEP to return with
TRAP_TRACE instead of TRAP_HWBKPT but that would be artificial.
>From the hardware perspective its the same.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

