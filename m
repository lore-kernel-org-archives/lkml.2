Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab2CZSlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:41:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37723 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015Ab2CZSlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:41:08 -0400
Message-ID: <1332786353.16159.173.camel@twins>
Subject: Re: [PATCH 11/39] autonuma: CPU follow memory algorithm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 26 Mar 2012 20:25:53 +0200
In-Reply-To: <1332783986-24195-12-git-send-email-aarcange@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
	 <1332783986-24195-12-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 19:45 +0200, Andrea Arcangeli wrote:
> @@ -3220,6 +3214,8 @@ need_resched:
>  
>         post_schedule(rq);
>  
> +       sched_autonuma_balance();
> +
>         sched_preempt_enable_no_resched();
>         if (need_resched())
>                 goto need_resched; 

I already told you, this isn't ever going to happen. You do _NOT_ put a
for_each_online_cpu() loop in the middle of schedule().

You also do not call stop_one_cpu(migration_cpu_stop) in schedule to
force migrate the task you just scheduled to away from this cpu. That's
retarded.

Nacked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
