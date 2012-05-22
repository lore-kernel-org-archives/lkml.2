Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2EVRHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:07:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:39404 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2EVRHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:07:49 -0400
Date: Tue, 22 May 2012 19:07:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
In-Reply-To: <1337705539.13348.81.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1205221906250.3231@ionos>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>   <alpine.LFD.2.02.1205221553400.3231@ionos>  <1337701801.13348.56.camel@gandalf.stny.rr.com>  <alpine.LFD.2.02.1205221803290.3231@ionos> <1337705539.13348.81.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Steven Rostedt wrote:

> On Tue, 2012-05-22 at 18:40 +0200, Thomas Gleixner wrote:
> 
> > > I'm all for benchmarks. But right now, making all readers pass through a
> > > single mutex is a huge bottle neck for a lot of loads. Yes, they are
> > > mostly Java loads, but for some strange reason, our customers seems to
> > > like to run Java on our RT kernel :-p
> > 
> > I'm well aware that mmap_sem is a PITA but replacing one nightmare
> > with the next one is not the best approach.
> 
> Perhaps we could just change the mmap_sem to use this approach. Create a
> new type of rwsem/lock for -rt that we can be picky about.
> 
> Yeah, mmap_sem is a real PITA and it would be nice to have a solution
> that can be used until we can convert it to an RCU lock.

That still wants to be verified with numbers on a machine with at
least 32 cores and workloads which are mmap heavy. And before we don't
have such numbers we can really stop arguing about that solution.

Thanks,

	tglx
