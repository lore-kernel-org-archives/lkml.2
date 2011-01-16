Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1APAPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 19:15:21 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52700 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab1APAPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 19:15:19 -0500
Date: Sat, 15 Jan 2011 16:15:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        paul.mckenney@linaro.org, rmk+kernel@arm.linux.org.uk,
        weber@corscience.de, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] rcu: avoid pointless blocked-task warnings
Message-ID: <20110116001516.GB2229@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-b24efdfdf679cf9b05947c531971905fc727dd40@git.kernel.org>
 <20110115142857.GA8610@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110115142857.GA8610@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 03:28:57PM +0100, Ingo Molnar wrote:
> 
> * tip-bot for Paul E. McKenney <paul.mckenney@linaro.org> wrote:
> 
> > Commit-ID:  b24efdfdf679cf9b05947c531971905fc727dd40
> > Gitweb:     http://git.kernel.org/tip/b24efdfdf679cf9b05947c531971905fc727dd40
> > Author:     Paul E. McKenney <paul.mckenney@linaro.org>
> > AuthorDate: Wed, 12 Jan 2011 14:18:11 -0800
> > Committer:  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > CommitDate: Fri, 14 Jan 2011 04:58:08 -0800
> > 
> > rcu: avoid pointless blocked-task warnings
> > 
> > If the RCU callback-processing kthread has nothing to do, it parks in
> > a wait_event().  If RCU remains idle for more than two minutes, the
> > kernel complains about this.  This commit changes from wait_event()
> > to wait_event_interruptible() to prevent the kernel from complaining
> > just because RCU is idle.
> 
> Btw., a sidenote, it's not just about the blocked-tasks lockup detector warning, 
> uninterruptible sleeps will also artificially inflate the load average of the box, 
> +1.0 per such task. So it's definitely a bug to sleep for a very long time 
> uninterruptible.

Good point, and I have made the corresponding change in the in-progress
TREE_PREEMPT_RCU variant of RCU priority boosting.  Some thought will be
required when merging SRCU into the Tiny and Tree RCU implementations.  ;-)

								Thanx, Paul
