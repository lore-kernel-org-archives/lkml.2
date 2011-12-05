Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab1LEKHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:07:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49130 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab1LEKHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:07:03 -0500
Date: Mon, 5 Dec 2011 18:03:46 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
Message-ID: <20111205100346.GA28750@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <1323078096.32012.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1323078096.32012.14.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 10:41:36AM +0100, Peter Zijlstra wrote:
> On Sat, 2011-12-03 at 10:34 -0800, Paul E. McKenney wrote:
> > From: Yong Zhang <yong.zhang0@gmail.com>
> > 
> > RCU-lockdep will issue warnings given the following use pattern:
> > 
> > 	rcu_read_lock();
> > 	local_irq_disable();
> > 	rcu_read_unlock();
> > 	local_irq_enable();
> > 
> > However, this use pattern is legal except for the scheduler's runqueue
> > and priority-inheritance locks (and any other locks that the scheduler
> > might use during priority-inheritance operations).
> 
> So what does this patch do? Make it not complain when you do the above?

It suppose to not complain but it bring other complain :(

> How often does this pattern actually happen?

IIRC, we have just one which is cured by commit [a841796: signal: align
__lock_task_sighand() irq disabling and RCU]

> Can't be that often
> otherwise we'd have had more complaints, no?

Yeah,

So that also means we don't dedicated lock_class_key for mtx.wait_lock.

Thanks,
Yong
