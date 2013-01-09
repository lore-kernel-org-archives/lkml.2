Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab3AISjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:39:19 -0500
Received: from mail.openrapids.net ([64.15.138.104]:52327 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932165Ab3AISjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:39:18 -0500
Date: Wed, 9 Jan 2013 13:39:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [RELEASE] Userspace RCU 0.6.9
Message-ID: <20130109183911.GA14358@Krystal>
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

This is a bugfix release for the stable-0.6 series of the Userspace RCU
library. It fixes a hang in use-case where call_rcu is used in a parent
process that performs a fork(), without following exec(), and then
continues to use call_rcu or synchronize_rcu.

Changelog:
2013-01-09 Userspace RCU 0.6.9
        * API cleanup: use "uatomic_*" in cmm_smp_mb__ API
        * uatomic: add memory barrier API for and/or/add/sub/inc/sub
        * Fix uatomic sign cast
        * Discourage use of pthread_atfork() for call_rcu handlers
        * Fix call_rcu fork handling
        * test: fork handling

Project website: http://lttng.org/urcu
Download link: http://lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
