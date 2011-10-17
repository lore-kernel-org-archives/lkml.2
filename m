Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1JQBtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:49:35 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52087 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1JQBte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:49:34 -0400
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.15.19
Date: Sun, 16 Oct 2011 18:49:15 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 36/55] rcu: Prevent early boot
 set_need_resched() from __rcu_pending()
Message-ID: <20111017014915.GE19421@leaf>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-36-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315332049-2604-36-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 11:00:30AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> There isn't a whole lot of point in poking the scheduler before there
> are other tasks to switch to.  This commit therefore adds a check
> for rcu_scheduler_fully_active in __rcu_pending() to suppress any
> pre-scheduler calls to set_need_resched().  The downside of this approach
> is additional runtime overhead in a reasonably hot code path.

If you're concerned about the runtime overhead, this does seem like a
perfect candidate for jump labels.

- Josh Triplett
