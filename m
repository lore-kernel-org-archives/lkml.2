Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1HMOXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:23:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50622 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1HMOXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:23:40 -0400
Subject: Re: [ANNOUNCE] 3.0.1-rt11
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Sat, 13 Aug 2011 16:23:13 +0200
In-Reply-To: <1313243965.4486.36.camel@marge.simson.net>
References: <1313232790.25267.7.camel@twins>
	 <1313236135.4486.10.camel@marge.simson.net>
	 <1313236713.25267.10.camel@twins>
	 <1313243965.4486.36.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313245393.25267.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-13 at 15:59 +0200, Mike Galbraith wrote:
> Hohum.  rt10 did change the symptom.  Box no longer gripes at some
> random point while just idling along, now it gripes (and dies as well)
> during boot.
> 
> First boot, it choked on sr0 a wee bit later, second boot here.
> 
> [   40.582256] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
> [   40.582260] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 08:00:69:15:c1:d5
> [   40.582335] igb 0000:01:00.1: eth1: PBA No: FFFFFF-0FF
> [   40.582338] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [  100.409012] INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by 21, t=60002 jiffies)
> 
> Guess I should try x3550 M3 or Q6600.  They were griping the same way UV
> box did earlier this morning (with an earlier -rt though), and they make
> much smaller gripes.
> 
> Gripe attached.  Looks a lot like the old gripes to me, just earlier and
> deadlier.  But I don't speak rcu. 

Nothing stands out, but then, I'm tired and it are 32 cpu traces to look
through.

There is definitely something still fishy with RCU, the last patch in
-rt10 is as far as we understand things a complete bandaid at best and
horridly wrong otherwise.

I think I'll try Paul's WARN_ON(t->rcu_read_lock_nesting == 0 &&
t->rcu_read_unlock_special); in __rcu_read_lock() sometime later.

I also haven't read through my IRC backlog in which Paul and Steven
discussed things way after I fell over and got keyboard face. 

/me needs to go out in the rain to get some shopping done, shops in this
country I live in are closed on sunday :/ 
