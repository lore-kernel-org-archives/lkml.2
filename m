Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2DWQma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:42:30 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41702 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab2DWQm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:42:28 -0400
Date: Mon, 23 Apr 2012 09:41:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH RFC 0/6] Miscellaneous RCU fixes for 3.5
Message-ID: <20120423164159.GA13819@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-3352-0000-0000-00000436990E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series includes several miscellaneous fixes for RCU as follows:

1.	Make the rcu_blocking_is_gp() function properly guard against
	concurrent CPU-hotplug operations.
2.	Make __list_add_rcu() do pointer checks like __list_add() does,
	courtesy of Dave Jones.
3.	Replace the "unsafe at any speed" list_first_entry_rcu() macro
	with a safe and sane list_first_or_null_rcu(), courtesy of
	Michel Machado.
4.	Clarify help text for the RCU_BOOST_PRIO kernel config parameter.
5.	Convert __kfree_rcu() from an inline function to a macro in order
	to avoid spurious build failures should gcc fail to inline it.
	Courtesy of Jan Engelhardt.
6.	Reduce cache-miss initialization latencies for large systems.
	Given the widespread use of NR_CPUS=4096, there are a lot of
	large systems out there.

							Thanx, Paul


 b/include/linux/rculist.h  |    7 ++++++-
 b/include/linux/rcupdate.h |   18 ++++++++++++++++++
 b/include/linux/rcutree.h  |    7 ++++++-
 b/init/Kconfig             |   23 +++++++++++++++++++----
 b/kernel/rcutree.c         |    2 +-
 b/kernel/rcutree.h         |   10 +++-------
 b/lib/list_debug.c         |   22 ++++++++++++++++++++++
 include/linux/rculist.h    |   33 +++++++++++++++++++++++++++++----
 init/Kconfig               |   27 +++++++++++++++++++++++++++
 9 files changed, 131 insertions(+), 18 deletions(-)

