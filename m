Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1KCEze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 00:55:34 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39488 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1KCEzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 00:55:32 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 50.43.15.19
Date: Wed, 2 Nov 2011 21:55:09 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 28/28] rcu: Fix idle-task checks
Message-ID: <20111103045509.GH2042@leaf>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-28-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320265849-5744-28-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 01:30:49PM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> RCU has traditionally relied on idle_cpu() to determine whether a given
> CPU is running in the context of an idle task, but recent changes have
> invalidated this approach.  This commit therefore switches from idle_cpu
> to "current->pid != 0".

Could you elaborate a bit on "recent changes"?  It looks like you mean
commit 908a3283728d92df36e0c7cd63304fd35e93a8a9; if so, could you add
that reference to the commit message?

Also, the hard-coded use of "current->pid != 0" concerns me.  Could this
use some existing function?  Does idle_task() help?  If no appropriate
predicate exists, perhaps it should.  is_idle_task(current)?

- Josh Triplett
