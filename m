Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1HOSCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:02:04 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52722 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab1HOSCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:02:02 -0400
Date: Mon, 15 Aug 2011 11:01:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: NeilBrown <neilb@suse.de>, Ben Blum <bblum@andrew.cmu.edu>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
 questionable code in de_thread.
Message-ID: <20110815180155.GT2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
 <20110728121741.GB2427@linux.vnet.ibm.com>
 <20110814175119.GC2381@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110814175119.GC2381@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 07:51:19PM +0200, Oleg Nesterov wrote:
> On 07/28, Paul E. McKenney wrote:
> >
> > On Thu, Jul 28, 2011 at 11:08:13AM +1000, NeilBrown wrote:
> > >
> > > I disagree.  It also requires - by virtue of the use of while_each_thread() -
> > > that 'g' remains on the list that 't' is walking along.
> >
> > Doesn't the following code in the loop body deal with this possibilty?
> >
> > 	/* Exit if t or g was unhashed during refresh. */
> > 	if (t->state == TASK_DEAD || g->state == TASK_DEAD)
> > 		goto unlock;
> 
> This code is completely wrong even if while_each_thread() was fine.
> 
> I sent the patch but it was ignored.
> 
> 	[PATCH] fix the racy check_hung_uninterruptible_tasks()->rcu_lock_break()
> 	http://marc.info/?l=linux-kernel&m=127688790019041

If it helps...

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

							Thanx, Paul
