Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2DZPKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:10:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:53754 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab2DZPKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:10:08 -0400
Message-ID: <1335452976.13683.88.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 3/4] rcu: Make RCU_FAST_NO_HZ account
 for pauses out of idle
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 26 Apr 2012 17:09:36 +0200
In-Reply-To: <20120426144910.GC2407@linux.vnet.ibm.com>
References: <20120423161539.GA6467@linux.vnet.ibm.com>
	 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335197761-6577-3-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335445242.13683.19.camel@twins>
	 <20120426144910.GC2407@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 07:49 -0700, Paul E. McKenney wrote:
> >   per_cpu(rcu_dyntick.first_pass, cpu) = 0;

> I must confess that I had no idea that you could say the above.  I would
> have expected to have to say the following:
> 
>     per_cpu(rcu_dyntick, cpu).first_pass = 0; 

They both work and are afaik identical. The first takes the per-cpu
address of rcu_dyntick and adds the offset of first_pass, then
transforms the per-cpu address to a linear address. The second
transforms the per-cpu address of rcu_dyntick, transforms it to a linear
address and then adds the offset of first_pass, IOW:

 (&rcu_dyntick + offset) + per_cpu_offset == 
		(&rcu_dyntick + per_cpu_offset) + offset



