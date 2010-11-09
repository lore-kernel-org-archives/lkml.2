Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0KIUVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:21:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35793 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab0KIUVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:21:36 -0500
Date: Tue, 9 Nov 2010 12:20:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: suspicious rcu_dereference_check() usage splat
Message-ID: <20101109202051.GT4032@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101107071414.GA3600@deepthought.bhanu.net>
 <20101107185013.GC15561@linux.vnet.ibm.com>
 <20101108153957.GA3418@deepthought.bhanu.net>
 <20101108202437.GH4032@linux.vnet.ibm.com>
 <20101109090931.GH3971@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109090931.GH3971@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:09:31AM +0200, Sergey Senozhatsky wrote:
> On (11/08/10 12:24), Paul E. McKenney wrote:
> > Looking over the patch again, the scope of the RCU read-side critical
> > section needs to expand to cover the use of the pointer as well as the
> > call to find_task_by_vpid().  So, for example:
> > 
> > 		case IOPRIO_WHO_PROCESS:
> > 			rcu_read_lock();
> > 			if (!who)
> > 				p = current;
> > 			else
> > 				p = find_task_by_vpid(who);
> > 			if (p)
> > 				ret = set_task_ioprio(p, ioprio);
> > 			rcu_read_unlock();
> > 			break;
> > 		case IOPRIO_WHO_PGRP:
> > 
> > 
> > Otherwise, the task could go away before the last use.
> > 
> > Sergey, could you please make this change and re-post your patch?
> > 
> > 							Thanx, Paul
> > 
> 
> Hello,
> Should we protect set_task_ioprio? Critical operations are protected
> with rcu_read_lock/rcu_read_unlock in set_task_ioprio, the rest is protected
> via task_lock(task)/task_unlock(task).

At first glance, this function's locking is OK, but I must defer to
people who know this code better than do I.

							Thanx, Paul
