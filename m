Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab1LEJmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:42:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:56338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab1LEJmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:42:36 -0500
Message-ID: <1323078096.32012.14.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Yong Zhang <yong.zhang0@gmail.com>
Date: Mon, 05 Dec 2011 10:41:36 +0100
In-Reply-To: <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
	 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-03 at 10:34 -0800, Paul E. McKenney wrote:
> From: Yong Zhang <yong.zhang0@gmail.com>
> 
> RCU-lockdep will issue warnings given the following use pattern:
> 
> 	rcu_read_lock();
> 	local_irq_disable();
> 	rcu_read_unlock();
> 	local_irq_enable();
> 
> However, this use pattern is legal except for the scheduler's runqueue
> and priority-inheritance locks (and any other locks that the scheduler
> might use during priority-inheritance operations).

So what does this patch do? Make it not complain when you do the above?
How often does this pattern actually happen? Can't be that often
otherwise we'd have had more complaints, no?


