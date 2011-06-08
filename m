Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1FHUFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:05:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52530 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1FHUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:05:40 -0400
Subject: Re: [PATCH 2/4] sched: Isolate preempt counting in its own config
 option
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110608195816.GJ2324@linux.vnet.ibm.com>
References: <1307555315-30989-1-git-send-email-fweisbec@gmail.com>
	 <1307555315-30989-3-git-send-email-fweisbec@gmail.com>
	 <1307562434.3941.22.camel@twins> <20110608195816.GJ2324@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 22:09:14 +0200
Message-ID: <1307563754.2497.999.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 12:58 -0700, Paul E. McKenney wrote:
> 
> On Wed, Jun 08, 2011 at 09:47:14PM +0200, Peter Zijlstra wrote:
> > On Wed, 2011-06-08 at 19:48 +0200, Frederic Weisbecker wrote:
> > > 
> > > Create a new CONFIG_PREEMPT_COUNT that handles the inc/dec
> > > of preempt count offset independently. So that the offset
> > > can be updated by preempt_disable() and preempt_enable()
> > > even without the need for CONFIG_PREEMPT beeing set.
> > > 
> > > This prepares to make CONFIG_DEBUG_SPINLOCK_SLEEP working
> > > with !CONFIG_PREEMPT where it currently doesn't detect
> > > code that sleeps inside explicit preemption disabled
> > > sections. 
> > 
> > The last time this got proposed it got shot down due to the extra
> > inc/dec stuff all over the place increasing overhead significantly.
> 
> Even given that the extra inc/dec stuff only happens in kernels built
> with DEBUG_SPINLOCK_SLEEP=y (DEBUG_ATOMIC_SLEEP=y after patch 4/4)? 

Ah, no that might be ok. That's what I get for trying to read email in
no time.


