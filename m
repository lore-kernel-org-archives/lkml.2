Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317Ab1INUtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:49:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:42896 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab1INUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:49:11 -0400
Date: Wed, 14 Sep 2011 22:49:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 2/3] futex: Reduce hash bucket lock contention
In-Reply-To: <1316015498.5040.33.camel@twins>
Message-ID: <alpine.LFD.2.02.1109142243170.2723@ionos>
References: <20110914133034.687048806@chello.nl>  <20110914133750.831707072@chello.nl> <4E70CC3B.4000905@linux.intel.com> <1316015498.5040.33.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011, Peter Zijlstra wrote:

> On Wed, 2011-09-14 at 08:46 -0700, Darren Hart wrote:
> > 
> > On 09/14/2011 06:30 AM, Peter Zijlstra wrote:
> > > Use the brand spanking new wake_list to delay the futex wakeups until
> > > after we've released the hash bucket locks. This avoids the newly
> > > woken tasks from immediately getting stuck on the hb lock.
> > > 
> > > This is esp. painful on -rt, where the hb lock is preemptible.
> > 
> > Nice!
> > 
> > Have you run this through the functional and performance tests from
> > futextest? Looks like I should also add a multiwake test to really
> > showcase this.
> 
> Not more functional than booting, but a very similar patch used to live
> in 33-rt.. I lost the use-case we had that led to that patch, for -rt it
> made a huge difference because we endlessly scheduled back and forth
> between the waker and the wakee bouncing on the hb lock.

The use case was that utter trainwreck AMQP, which is bouncing futexes
back and forth just to burn the maximum cpu cycles for no value.

Thanks,

	tglx
