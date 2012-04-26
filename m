Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab2DZNFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:05:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:51825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2DZNFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:05:22 -0400
Message-ID: <1335445496.13683.21.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 4/4] rcu: Ensure that RCU_FAST_NO_HZ
 timers expire on correct CPU
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 26 Apr 2012 15:04:56 +0200
In-Reply-To: <1335197761-6577-4-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423161539.GA6467@linux.vnet.ibm.com>
	 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335197761-6577-4-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 09:16 -0700, Paul E. McKenney wrote:
> -               mod_timer(&per_cpu(rcu_idle_gp_timer, cpu),
> -                         per_cpu(rcu_idle_gp_timer_expires, cpu));
> +               tp = &per_cpu(rcu_idle_gp_timer, cpu);
> +               tp->expires = per_cpu(rcu_idle_gp_timer_expires, cpu);
> +               add_timer_on(tp, cpu); 

The simpler change looks to use mod_timer_pinned()
