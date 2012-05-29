Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2E2RoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:44:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37954 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2E2RoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:44:06 -0400
Message-ID: <1338313407.26856.163.camel@twins>
Subject: Re: [PATCH 22/35] autonuma: sched_set_autonuma_need_balance
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
Date: Tue, 29 May 2012 19:43:27 +0200
In-Reply-To: <20120529173347.GJ21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-23-git-send-email-aarcange@redhat.com>
	 <1338307942.26856.111.camel@twins> <20120529173347.GJ21339@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 19:33 +0200, Andrea Arcangeli wrote:
> So the cost on a 24-way SMP 

is irrelevant.. also, not every cpu gets to the 24 cpu domain, just 2
do.

When you do for_each_cpu() think at least 4096, if you do
for_each_node() think at least 256.

Add to that the knowledge that doing 4096 remote memory accesses will
cost multiple jiffies, then realize you're wanting to do that with
preemption disabled.

That's just a very big no go.
