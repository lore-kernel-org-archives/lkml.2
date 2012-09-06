Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab2IFNfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:35:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34890 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2IFNfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:35:44 -0400
Message-ID: <1346938478.18408.4.camel@twins>
Subject: Re: [PATCH tip/core/rcu 03/23] rcu: Move RCU grace-period cleanup
 into kthread
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Date: Thu, 06 Sep 2012 15:34:38 +0200
In-Reply-To: <1346350718-30937-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-3-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
>  static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
>         __releases(rcu_get_root(rsp)->lock)
>  {
> +       raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
> +       wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
>  } 

Could you now also clean up the locking so that the caller releases this
lock?

I so dislike asymmetric locking like that..
