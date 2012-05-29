Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2E2NKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:10:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48810 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2E2NKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:10:45 -0400
Message-ID: <1338297004.26856.70.camel@twins>
Subject: Re: [PATCH 12/35] autonuma: CPU follow memory algorithm
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Date: Tue, 29 May 2012 15:10:04 +0200
In-Reply-To: <1337965359-29725-13-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-13-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
> + * This function is responsible for deciding which is the best CPU
> + * each process should be running on according to the NUMA
> + * affinity. To do that it evaluates all CPUs and checks if there's
> + * any remote CPU where the current process has more NUMA affinity
> + * than with the current CPU, and where the process running on the
> + * remote CPU has less NUMA affinity than the current process to run
> + * on the remote CPU. Ideally this should be expanded to take all
> + * runnable processes into account but this is a good
> + * approximation. When we compare the NUMA affinity between the
> + * current and remote CPU we use the per-thread information if the
> + * remote CPU runs a thread of the same process that the current task
> + * belongs to, or the per-process information if the remote CPU runs
> a
> + * different process than the current one. If the remote CPU runs the
> + * idle task we require both the per-thread and per-process
> + * information to have more affinity with the remote CPU than with
> the
> + * current CPU for a migration to happen. 

This doesn't explain anything in the dense code that follows.

What statistics, how are they used, with what goal etc..


