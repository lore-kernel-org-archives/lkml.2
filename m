Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1G0Usv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:48:51 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:39276 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753282Ab1G0Ust (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:48:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tI66ORsVM1mfZlK4.LMe1kEeHiBIrMUf8c5H42sRCBK7OaK
 _w7YBDysMy0V6he0o7E61diHrKKNifUuevKkhWoL47LU73pB2aatYqRO9UKG
 UUsJZbAGdG02hDFb3ai6HHWRKCNsioEVeUEqlBfHFzOg5wozI7K4CchQyUQ7
 b4uyfQFK6XzogEwiMygZdSSVQ_.xUyj33V89ruOwofsKOGrKenhvQcMkd3wt
 .JHm2JBvz97nke5ivTqR5orofliO3BEcZ565UB5zpstbWbdByvnxvvNoqPX8
 TVOy_Gb0IVANj0n7VYa7foSub_uC8knD4GQLU9FweUu5l0jm.
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 27 Jul 2011 15:48:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com
Subject: Re: per-cpu operation madness vs validation
In-Reply-To: <alpine.LFD.2.02.1107271919500.2660@ionos>
Message-ID: <alpine.DEB.2.00.1107271542530.17752@router.home>
References: <1311714410.24752.404.camel@twins>  <alpine.DEB.2.00.1107261624210.10273@router.home>  <1311768693.24752.488.camel@twins>  <alpine.DEB.2.00.1107270904290.9418@router.home> <1311783616.5890.178.camel@twins> <alpine.DEB.2.00.1107271204260.13058@router.home>
 <alpine.LFD.2.02.1107271919500.2660@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Thomas Gleixner wrote:

> > The key issue is that the -rt kernel has always had grave issues with
> > performance when it comes to per cpu data access. Solving that by forcing
> > the kernel to go slow it not the right approach.
>
> Nobody want's the kernel to go slow. All we want and we consider that
> also a benefit for mainline is: proper annotation of the per cpu data
> access, like we have for RCU and for locking.

I love that stuff.

> For -rt this lack of documentation and the lack of verification,
> debugability and traceability is a major PITA, but that's true for
> non-rt as well, just the PITA is gradually smaller and the bugs which
> are there today are just extremly hard to trigger.

Right. Sure wish there would be better checks. Or things would not have so
many flavors.

> And Peters idea of per_cpu_lock*() annotations will boil down to the
> exact same thing which is there today when you compile the kernel w/o
> lockdep enabled for per_cpu data correctness. We don't want to change
> anything or impose any slowness, we just want a proper way to document
> and verify that maze. That's really not too much of a request.

No problem with that. The per cpu atomic ops are made to mostly stand on
their own. However, the correctness is affected by placementin the per cpu
sections that may start with get_cpu() or a preempt_disable().

The reason that I switched from get_cpu() to preempt_disable() in some
functions was because the this_cpu operations eliminated the need to pass
the cpu number to a function. Thus the cpu variable is not needed anymore.
Preempt_disable() doesnt provide it and so I thought that was the proper
function to use.

