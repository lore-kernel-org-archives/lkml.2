Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1FHT6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:58:21 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45344 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab1FHT6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:58:20 -0400
Date: Wed, 8 Jun 2011 12:58:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/4] sched: Isolate preempt counting in its own config
 option
Message-ID: <20110608195816.GJ2324@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307555315-30989-1-git-send-email-fweisbec@gmail.com>
 <1307555315-30989-3-git-send-email-fweisbec@gmail.com>
 <1307562434.3941.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307562434.3941.22.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 09:47:14PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-06-08 at 19:48 +0200, Frederic Weisbecker wrote:
> > 
> > Create a new CONFIG_PREEMPT_COUNT that handles the inc/dec
> > of preempt count offset independently. So that the offset
> > can be updated by preempt_disable() and preempt_enable()
> > even without the need for CONFIG_PREEMPT beeing set.
> > 
> > This prepares to make CONFIG_DEBUG_SPINLOCK_SLEEP working
> > with !CONFIG_PREEMPT where it currently doesn't detect
> > code that sleeps inside explicit preemption disabled
> > sections. 
> 
> The last time this got proposed it got shot down due to the extra
> inc/dec stuff all over the place increasing overhead significantly.

Even given that the extra inc/dec stuff only happens in kernels built
with DEBUG_SPINLOCK_SLEEP=y (DEBUG_ATOMIC_SLEEP=y after patch 4/4)?

							Thanx, Paul
