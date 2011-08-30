Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1H3LSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:18:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54739 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1H3LSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:18:06 -0400
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to
 idle enter/exit APIs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Tue, 30 Aug 2011 13:17:42 +0200
In-Reply-To: <20110829233521.GK9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
	 <1314627922.2816.65.camel@twins>
	 <20110829171155.GD9748@somewhere.redhat.com>
	 <1314640155.2816.117.camel@twins>
	 <20110829175954.GF9748@somewhere.redhat.com>
	 <1314641160.2816.128.camel@twins>
	 <20110829233521.GK9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314703062.2799.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 01:35 +0200, Frederic Weisbecker wrote:
> But rcu read side critical sections (preemption disabled, rcu_read_lock(),
> softirq disabled) don't need the tick to enforce the critical section
> itself. 

Note that with PREEMPT_RCU only the rcu_read_lock() is actually an rcu
read side critical section, non of the others should be used as such.
Relying on preempt_disable(), local_bh_disable() and similar is broken
as per a long while ago.


