Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2BBGMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 01:12:47 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54068 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab2BBGMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 01:12:46 -0500
X-Originating-IP: 217.70.178.137
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 22:12:28 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 39/41] rcu: Wait at least a jiffy before
 declaring a CPU to be offline
Message-ID: <20120202061228.GV29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-39-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-39-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:57AM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The force_quiescent_state() function uses a state machine to help
> force grace periods to completion.  One of its responsibilities is to
> detect offline CPUs, and to report quiescent states on their behalf.
> However, the CPU hotplug process is not atomic, in fact, there is
> significant uncertainty as to exactly when a given CPU came online or
> went offline.  For example, once a CPU has marked itself offline and
> executed the CPU_DYING notifiers, it continues executing, entering
> the scheduler and perhaps also the idle loop.
> 
> In the old days, force_quiescent_state() was guaranteed to wait for
> several jiffies before declaring a given CPU offline.  This is no
> longer the case, due to some of the more aggressive rcutorture tests
> and the CONFIG_RCU_FAST_NO_HZ idle-entry code.  Therefore, this commit
> makes force_quiescent_state() explicitly wait for at least a jiffy
> before declaring a CPU to be offline.

This commit seems to implement behavior documented as working in patch
38.  Shouldn't those bits go together?

- Josh Triplett
