Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab1EZOZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:25:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34674 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab1EZOZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:25:56 -0400
Date: Thu, 26 May 2011 07:25:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110526142553.GA2386@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110524013523.GO7428@linux.vnet.ibm.com>
 <4DDC21E1.1070502@kernel.org>
 <4DDC48E3.1060108@kernel.org>
 <20110525045253.GB2262@linux.vnet.ibm.com>
 <4DDD7F96.3090408@kernel.org>
 <20110525223437.GO2341@linux.vnet.ibm.com>
 <4DDD8775.1000501@kernel.org>
 <20110526011310.GP2341@linux.vnet.ibm.com>
 <20110526013029.GA28103@linux.vnet.ibm.com>
 <20110526061348.GA26775@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526061348.GA26775@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 08:13:48AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > rcu: Start RCU kthreads in TASK_INTERRUPTIBLE state
> > 
> > Upon creation, kthreads are in TASK_UNINTERRUPTIBLE state, which can
> > result in softlockup warnings.  Because some of RCU's kthreads can
> > legitimately be idle indefinitely, start them in TASK_INTERRUPTIBLE
> > state in order to avoid those warnings.
> > 
> > Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> this should also solve load average artifacts - do not 
> TASK_UNINTERRUPTIBLE tasks skew the load upwards?

Quite possibly -- in this case the artifacts would appear just after
boot, and would disappear as soon as the RCU kthreads had something
to do.

							Thanx, Paul
