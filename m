Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2GEMEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:04:30 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45764 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2GEME2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:04:28 -0400
Date: Thu, 5 Jul 2012 08:04:13 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 09/40] autonuma: introduce kthread_bind_node()
Message-ID: <20120705120412.GA12779@localhost.localdomain>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
 <1340888180-15355-10-git-send-email-aarcange@redhat.com>
 <20120630045013.GB3975@localhost.localdomain>
 <20120704231425.GP25743@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120704231425.GP25743@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /**
>  * kthread_bind_node - bind a just-created kthread to the CPUs of a node.
>  * @p: thread created by kthread_create().
>  * @nid: node (might not be online, must be possible) for @k to run on.
>  *
>  * Description: This function is equivalent to set_cpus_allowed(),
>  * except that @nid doesn't need to be online, and the thread must be
>  * stopped (i.e., just returned from kthread_create()).
>  */
> void kthread_bind_node(struct task_struct *p, int nid)
> {
> 	/* Must have done schedule() in kthread() before we set_task_cpu */
> 	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
> 		WARN_ON(1);
> 		return;
> 	}
> 
> 	/* It's safe because the task is inactive. */
> 	do_set_cpus_allowed(p, cpumask_of_node(nid));
> 	p->flags |= PF_THREAD_BOUND;
> }
> EXPORT_SYMBOL(kthread_bind_node);
> 
> The above should explain why it's not _GPL right now. As far as
> AutoNUMA is concerned I can drop the EXPORT_SYMBOL completely and not
> allow modules to call this. In fact I could have coded this inside
> autonuma too.

Ok. How about dropping it and then if its needed for modules then
export it out.
> 
> I can change it to _GPL, drop the EXPORT_SYMBOL or move it inside the
> autonuma code, let me know what you prefer. If I hear nothing I won't
> make changes.
> 
> Thanks,
> Andrea
> 
