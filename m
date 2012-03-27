Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab2C0PqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:46:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35743 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2C0PqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:46:00 -0400
Message-ID: <1332863135.16159.239.camel@twins>
Subject: Re: [PATCH 07/39] autonuma: introduce kthread_bind_node()
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
Date: Tue, 27 Mar 2012 17:45:35 +0200
In-Reply-To: <20120327152209.GL5906@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
	 <1332783986-24195-8-git-send-email-aarcange@redhat.com>
	 <1332786755.16159.174.camel@twins> <20120327152209.GL5906@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 17:22 +0200, Andrea Arcangeli wrote:
> I don't see what's wrong with more than 1 CPU in the hard bind
> cpumask.

Because its currently broken, but we're trying to restore its pure
semantic so that we can use it in more places again, like
debug_smp_processor_id(). Testing a single process flag is _much_
cheaper than testing ->cpus_allowed.

Adding more broken isn't an option.
