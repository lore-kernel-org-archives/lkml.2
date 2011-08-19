Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1HSSB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:01:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41644 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab1HSSB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:01:57 -0400
X-Sasl-enc: eeIhw04zy4G9opuUI5vR1fSSkII7TstOyu/X5jXYsd1s 1313776914
Date: Fri, 19 Aug 2011 11:01:37 -0700
From: Greg KH <greg@kroah.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        laijs@cn.fujitsu.com, eric.dumazet@gmail.com, patches@linaro.org,
        peterz@infradead.org, josh@joshtriplett.org, rostedt@goodmis.org,
        stable@kernel.org, dhowells@redhat.com, darren@dvhart.com,
        niv@us.ibm.com, tglx@linutronix.de, dipankar@in.ibm.com,
        Valdis.Kletnieks@vt.edu, mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: [stable] [PATCH RFC tip/core/urgent] rcu: Avoid having
 just-onlined CPU resched itself when RCU is idle
Message-ID: <20110819180137.GA22040@kroah.com>
References: <20110819163547.GA5182@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819163547.GA5182@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 09:35:47AM -0700, Paul E. McKenney wrote:
> CPUs set rdp->qs_pending when coming online to resolve races with
> grace-period start.  However, this means that if RCU is idle, the
> just-onlined CPU might needlessly send itself resched IPIs.  Adjust the
> online-CPU initialization to avoid this, and also to correctly cause
> the CPU to respond to the current grace period if needed.
> 
> This patch is believed to fix or otherwise suppress problems in
> https://bugzilla.redhat.com/show_bug.cgi?id=726877, however, the
> relationship is not apparent to this patch's author.  That said, it is
> hard to argue with test results.
> 
> This will be available from -rcu as soon as kernel.org's mirrors update:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> 
> Reported-by: Nicolas Mailhot <nicolas.mailhot@laposte.net>
> Reported-by: Michal Jaegermann <michal@harddata.com>
> Reported-by: Josh Boyer <jwboyer@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Josh Boyer <jwboyer@redhat.com>
> 
>  rcutree.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
