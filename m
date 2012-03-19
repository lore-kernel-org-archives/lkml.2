Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030Ab2CSMUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:20:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59137 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819Ab2CSMUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:20:32 -0400
Message-ID: <1332159598.18960.320.camel@twins>
Subject: Re: [RFC][PATCH 15/26] sched, numa: Implement hotplug hooks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Mon, 19 Mar 2012 13:19:58 +0100
In-Reply-To: <4F672384.7030500@linux.vnet.ibm.com>
References: <20120316144028.036474157@chello.nl>
	 <20120316144241.074193109@chello.nl> <4F672384.7030500@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 17:46 +0530, Srivatsa S. Bhat wrote:
> > +     get_online_cpus();
> > +     cpu_notifier(numa_hotplug, 0);
> 
> 
> ABBA deadlock!
> 
Yeah, I know.. luckily it can't actually happen since early_initcalls
are pre-smp. I could just leave out the get_online_cpus() thing.
