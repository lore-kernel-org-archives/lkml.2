Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2JLLSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:18:39 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42682 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752824Ab2JLLSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:18:38 -0400
Date: Fri, 12 Oct 2012 07:18:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RELEASE] Userspace RCU 0.7.5
Message-ID: <20121012111835.GA15280@Krystal>
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

This is the start of a stable-0.7 branch to push important fixes. The
master branch development will continue and eventually result in a 0.8.0
release.

Please note that the bug "call_rcu list corruption on teardown" occurs
very rarely, only when invoking call_rcu_data_free() for per-cpu or
per-thread callback-invocation threads (typically before application
exit). The fix for this corruption bug is the same as the fix used in
the stable-0.6 branch. This fix is not needed in the master branch,
because the issue had been already fixed by moving call_rcu to the new
wfcqueue API.

Changelog:
2012-10-12 Userspace RCU 0.7.5
        * Fix: call_rcu list corruption on teardown
        * Ensure that read-side functions meet 10-line LGPL criterion
        * tls-compat.h: document sigaltstack(2) limitation
        * urcu: add notice to URCU_TLS() for it is not strictly async-signal-safe
        * Document sigaltstack(2) limitation
        * Documentation: update LICENSE file

Project website: http://lttng.org/urcu
Download link: http://lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
