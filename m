Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab2BBRyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:54:01 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59513 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441Ab2BBRx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:53:59 -0500
Date: Thu, 2 Feb 2012 09:48:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 22/41] rcu: Simplify unboosting checks
Message-ID: <20120202174812.GT2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-22-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202023847.GO29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202023847.GO29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020217-5112-0000-0000-000004A78D57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 06:38:47PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:40AM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > This is a port of commit #82e78d80 from TREE_PREEMPT_RCU to
> > TINY_PREEMPT_RCU.
> > 
> > This commit uses the fact that current->rcu_boost_mutex is set
> > any time that the RCU_READ_UNLOCK_BOOSTED flag is set in the
> > current->rcu_read_unlock_special bitmask.  This allows tests of
> > the bit to be changed to tests of the pointer, which in turn allows
> > the RCU_READ_UNLOCK_BOOSTED flag to be eliminated.
> 
> Does this change affect rcu_read_unlock()'s logic to trigger the
> slowpath only when special flags get set?

Interestingly enough, it does not.  The only way a task can be subjected
to RCU priority boosting is for that task to block sometime in its
current RCU read-side critical section.  When the task blocks, the
RCU_READ_UNLOCK_BLOCKED flag will be set.  Therefore, any time that the
current->rcu_boost_mutex pointer is non-NULL, the RCU_READ_UNLOCK_BLOCKED
flag will be set, so the current test of current->rcu_read_unlock_special
against zero continues to work correctly.

OK, OK, I will update the commit message with words to this effect.  ;-)

							Thanx, Paul

