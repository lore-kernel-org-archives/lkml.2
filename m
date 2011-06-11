Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab1FKBOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 21:14:21 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60167 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758354Ab1FKBOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 21:14:20 -0400
Date: Fri, 10 Jun 2011 21:14:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RELEASE] Userspace RCU 0.6.0
Message-ID: <20110611011417.GA8722@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:47:05 up 199 days,  5:50,  7 users,  load average: 0.21, 0.10,
	0.02
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

Changelog:

- Added call_rcu() support, graciously contributed by Paul E. McKenney.
- Added urcu/cds.h and merged all "Concurrent Data Containers" (CDS)
  into a single .so: liburcu-cds.so to have a single header/shared
  object holding all concurrency-aware data containers. It provides
  support for RCU lists, queues and stacks at the moment.
- liburcu 0.6.0 now allows linking a single application with multiple
  flavors of RCU. This required a library API change which is
  incompatible with older 0.5.x liburcu. The .so version number
  is therefore bumped from 0 to 1 (e.g. liburcu.so.1).
- Added "atfork" handling API, documented in README. Only useful for
  processes using fork() without following exec().
- Renaming the following files, keeping the old files (producing a
  compiler warning):
    urcu/uatomic_arch.h -> urcu/uatomic.h
    urcu/urcu-futex.h -> urcu/futex.h
    urcu/urcu_ref.h -> urcu/ref.h

Project website: http://lttng.org/urcu
Download link: http://www.lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
