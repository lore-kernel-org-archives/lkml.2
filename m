Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0DDPGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 11:06:21 -0400
Received: from nat.nue.novell.com ([195.135.221.3]:34301 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754500Ab0DDPGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 11:06:15 -0400
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Rik van Riel <riel@redhat.com>
Cc: rostedt@goodmis.org, Darren Hart <dvhltc@us.ibm.com>,
       "lkml," <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       john cooper <john.cooper@third-harmonic.com>
In-Reply-To: <4BB7F05A.6010102@redhat.com>
References: <4BB3D90C.3030108@us.ibm.com>
	 <1270078689.19685.8040.camel@gandalf.stny.rr.com>
	 <4BB40140.20109@us.ibm.com>
	 <1270088753.19685.8218.camel@gandalf.stny.rr.com>
	 <4BB7F05A.6010102@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Novell Inc.
Date: Sun, 04 Apr 2010 09:06:04 -0600
Message-ID: <1270393564.2997.141.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-03 at 21:50 -0400, Rik van Riel wrote:
> On 03/31/2010 10:25 PM, Steven Rostedt wrote:
> > On Wed, 2010-03-31 at 19:13 -0700, Darren Hart wrote:
> >> Steven Rostedt wrote:
> >>> On Wed, 2010-03-31 at 16:21 -0700, Darren Hart wrote:
> >>>
> >>>> o What type of lock hold times do we expect to benefit?
> >>>
> >>> 0 (that's a zero) :-p
> >>>
> >>> I haven't seen your patches but you are not doing a heuristic approach,
> >>> are you? That is, do not "spin" hoping the lock will suddenly become
> >>> free. I was against that for -rt and I would be against that for futex
> >>> too.
> >>
> >> I'm not sure what you're getting at here. Adaptive spinning is indeed
> >> hoping the lock will become free while you are spinning and checking
> >> it's owner...
> >
> > I'm talking about the original idea people had of "lets spin for 50us
> > and hope it is unlocked before then", which I thought was not a good
> > idea.
> 
> Maybe not a good idea when running on bare metal, but it
> could be a big help when running virtualized.
> 
> A lock with a short hold time can, occasionally, have a
> very long hold time, when the VCPU holding the lock is
> preempted by the host/hypervisor.
> 
> An adaptive lock would spin-and-acquire if the lock holder
> is running, while turning into a sleep lock when the lock
> holder has been preempted.
> 

Which is precisely what the RT variant does.  Each iteration of the
'spin' loop verifies that the lock owner is on CPU.   If the owner is
not, all other tasks stop spinning and sleep.

So how does a timeout help in the VCPU case?  

Best,
-PWM





