Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3AJQ7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:59:23 -0500
Received: from mail.vyatta.com ([76.74.103.46]:40669 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab3AJQ7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:59:22 -0500
Date: Thu, 10 Jan 2013 08:57:54 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RELEASE] Userspace RCU 0.7.6
Message-ID: <20130110085754.2d32b314@nehalam.linuxnetplumber.net>
In-Reply-To: <20130110164241.GA5051@Krystal>
References: <20130109184616.GA14968@Krystal>
	<20130110083247.591ad0ba@nehalam.linuxnetplumber.net>
	<20130110164241.GA5051@Krystal>
Organization: Vyatta
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013 11:42:41 -0500
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> * Stephen Hemminger (shemminger@vyatta.com) wrote:
> > On Wed, 9 Jan 2013 13:46:17 -0500
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This
> > > data synchronization library provides read-side access which scales
> > > linearly with the number of cores. It does so by allowing multiples
> > > copies of a given data structure to live at the same time, and by
> > > monitoring the data structure accesses to detect grace periods after
> > > which memory reclamation is possible.
> > > 
> > > liburcu-cds provides efficient data structures based on RCU and
> > > lock-free algorithms. Those structures include hash tables, queues,
> > > stacks, and doubly-linked lists.
> > > 
> > > This is a bugfix release, mainly fixing handling of processes using
> > > call_rcu, then fork() without following exec(), and then continuing use
> > > of synchronize_rcu() or call_rcu() in the child process. A hang in
> > > synchronize_rcu() in the child could occur, which is fixed by this
> > > release.
> > > 
> > > Changelog:
> > > 2013-01-09 Userspace RCU 0.7.6
> > >         * Discourage use of pthread_atfork() for call_rcu handlers
> > >         * Fix call_rcu fork handling
> > >         * test: fork handling
> > >         * Fix TLS detection: test with linker, add --disable-compiler-tls
> > >         * Cleanup: cast pthread_self() return value to unsigned long
> > >         * Fallback mechanism not working on platform where TLS is unsupported
> > > 
> > > Project website: http://lttng.org/urcu
> > > Download link: http://lttng.org/files/urcu/
> > > 
> > 
> > Why is the git repository still at 0.7.4 and there is no tag for 0.7.6?
> > Am I looking at the right place?
> >   $ git remote -v
> > origin	git://git.lttng.org/userspace-rcu.git (fetch)
> 
> I tried doing this to confirm:
> 
> git clone git://git.lttng.org/userspace-rcu.git
> cd userspace-rcu
> git tag -l
> 
> and v0.7.6 is there.
> 
> Please note that this tag is in the stable-0.7 branch (not master).
> 
> Please let me know if the problem persists for you after making sure you
> use the right branch.
> 
> Thanks,
> 
> Mathieu
> 

Ok, I didn't see the stable branch.
