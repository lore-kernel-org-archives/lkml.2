Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1HNRyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:54:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab1HNRyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:54:41 -0400
Date: Sun, 14 Aug 2011 19:51:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: NeilBrown <neilb@suse.de>, Ben Blum <bblum@andrew.cmu.edu>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
	questionable code in de_thread.
Message-ID: <20110814175119.GC2381@redhat.com>
References: <20110727171101.5e32d8eb@notabene.brown> <20110727150710.GB5242@unix33.andrew.cmu.edu> <20110727234235.GA2318@linux.vnet.ibm.com> <20110728110813.7ff84b13@notabene.brown> <20110728121741.GB2427@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728121741.GB2427@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Paul E. McKenney wrote:
>
> On Thu, Jul 28, 2011 at 11:08:13AM +1000, NeilBrown wrote:
> >
> > I disagree.  It also requires - by virtue of the use of while_each_thread() -
> > that 'g' remains on the list that 't' is walking along.
>
> Doesn't the following code in the loop body deal with this possibilty?
>
> 	/* Exit if t or g was unhashed during refresh. */
> 	if (t->state == TASK_DEAD || g->state == TASK_DEAD)
> 		goto unlock;

This code is completely wrong even if while_each_thread() was fine.

I sent the patch but it was ignored.

	[PATCH] fix the racy check_hung_uninterruptible_tasks()->rcu_lock_break()
	http://marc.info/?l=linux-kernel&m=127688790019041

Oleg.

