Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0C3PF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 11:05:56 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48268 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751813Ab0C3PFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:05:54 -0400
Date: Tue, 30 Mar 2010 11:05:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, stable <stable@kernel.org>
Subject: Re: [PATCH] lockdep fix incorrect percpu usage
Message-ID: <20100330150551.GA22312@Krystal>
References: <20100330033425.GD7683@Krystal> <1269938876.5109.510.camel@twins> <20100330134555.GA20673@Krystal> <1269959111.5258.142.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269959111.5258.142.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:03:39 up 66 days, 17:40,  9 users,  load average: 0.90, 0.71,
	0.73
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2010-03-30 at 09:45 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Mon, 2010-03-29 at 23:34 -0400, Mathieu Desnoyers wrote:
> > > > Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> > > > for per cpu pointers).
> > > > 
> > > > git blame points to commit:
> > > > 
> > > > lockdep.c: commit 8e18257d29238311e82085152741f0c3aa18b74d
> > > > 
> > > > But it's really just moving the code around. But it's enough to say that the
> > > > problems appeared before Jul 19 01:48:54 2007, which brings us back to 2.6.23.
> > > > 
> > > > So it should be applied to stable 2.6.23.x to 2.6.33.x (or whichever of these
> > > > stable branches are still maintained) and to mainline 2.6.34-rc2.
> > > 
> > > well, definately not to mainline, since that code is utterly busted in
> > > mainline due to recent per-cpu changes.
> > 
> > How recent ? I'm based on 
> > 
> > commit f57d4e859a8acd63f878cd0534ec4b990b1710dc
> > Merge: 0528faa... eed6351...
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Mon Mar 29 18:56:00 2010 +0200
> > 
> > from -tip and I see the problem there, both in module.c and lockdep.c.
> 
> Yeah, its basically been busted since the early merge window period,
> hopefully Tejun's patches will make it in soon:
> 
>   http://lkml.org/lkml/2010/3/10/79

I see. These patches are "on their way" to mainline, so it's better not to
create conflicts. So the lockdep patch should only be applied to -stable, but
separate module.c patch should apply to both -stable and mainline. Am I
correct ?

Thanks,

Mathieu


> 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
