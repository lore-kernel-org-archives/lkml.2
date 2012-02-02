Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2BBCjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:39:15 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41878 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab2BBCjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:39:14 -0500
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 18:38:47 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 22/41] rcu: Simplify unboosting checks
Message-ID: <20120202023847.GO29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-22-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-22-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:40AM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> This is a port of commit #82e78d80 from TREE_PREEMPT_RCU to
> TINY_PREEMPT_RCU.
> 
> This commit uses the fact that current->rcu_boost_mutex is set
> any time that the RCU_READ_UNLOCK_BOOSTED flag is set in the
> current->rcu_read_unlock_special bitmask.  This allows tests of
> the bit to be changed to tests of the pointer, which in turn allows
> the RCU_READ_UNLOCK_BOOSTED flag to be eliminated.

Does this change affect rcu_read_unlock()'s logic to trigger the
slowpath only when special flags get set?

- Josh Triplett
