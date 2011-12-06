Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1LFQP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:15:58 -0500
Received: from [205.233.59.134] ([205.233.59.134]:52649 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1LFQP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:15:57 -0500
Message-ID: <1323188096.32012.77.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Date: Tue, 06 Dec 2011 17:14:56 +0100
In-Reply-To: <20111206161110.GD2325@linux.vnet.ibm.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
	 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20111205091924.GA28117@zhy> <20111205164505.GB2326@linux.vnet.ibm.com>
	 <20111206012635.GA32498@zhy> <1323165152.32012.51.camel@twins>
	 <1323167246.32012.60.camel@twins>
	 <20111206161110.GD2325@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 08:11 -0800, Paul E. McKenney wrote:

> The problem with the IRQs enabled is the following sequence:
> 
> 	rcu_read_lock();
> 	/* do stuff */
> 	local_irq_save(flags);
> 	/* do more stuff */
> 	rcu_read_unlock();
> 	/* do even more stuff */
> 	local_irq_restore(flags);
> 
> This has been legal in the past, and might well be used in places that
> -rt does not exercise, hence the desire to explicitly legalize it.

So why not make it strictly dis-allowed, even for !-rt and see what
falls over? If there's lots of fallout we might need to reconsider, but
wouldn't it be easier to all abide by the strictest rules than to try
and frob stuff like was proposed?
