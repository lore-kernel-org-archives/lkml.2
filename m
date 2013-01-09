Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab3AISqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:46:19 -0500
Received: from mail.openrapids.net ([64.15.138.104]:52354 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932254Ab3AISqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:46:18 -0500
Date: Wed, 9 Jan 2013 13:46:17 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [RELEASE] Userspace RCU 0.7.6
Message-ID: <20130109184616.GA14968@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This
data synchronization library provides read-side access which scales
linearly with the number of cores. It does so by allowing multiples
copies of a given data structure to live at the same time, and by
monitoring the data structure accesses to detect grace periods after
which memory reclamation is possible.

liburcu-cds provides efficient data structures based on RCU and
lock-free algorithms. Those structures include hash tables, queues,
stacks, and doubly-linked lists.

This is a bugfix release, mainly fixing handling of processes using
call_rcu, then fork() without following exec(), and then continuing use
of synchronize_rcu() or call_rcu() in the child process. A hang in
synchronize_rcu() in the child could occur, which is fixed by this
release.

Changelog:
2013-01-09 Userspace RCU 0.7.6
        * Discourage use of pthread_atfork() for call_rcu handlers
        * Fix call_rcu fork handling
        * test: fork handling
        * Fix TLS detection: test with linker, add --disable-compiler-tls
        * Cleanup: cast pthread_self() return value to unsigned long
        * Fallback mechanism not working on platform where TLS is unsupported

Project website: http://lttng.org/urcu
Download link: http://lttng.org/files/urcu/

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
