Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851Ab2J3QlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:41:19 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39008 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759704Ab2J3Qji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:38 -0400
Date: Tue, 30 Oct 2012 09:27:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org, oleg@redhat.com
Subject: [PATCH tip/core/rcu 0/6] Fixes for 3.8
Message-ID: <20121030162728.GA22648@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-7408-0000-0000-000009C554E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch contains fixes as follows:

1.	Reinstate a grace-period acceleration that permits invoking
	the first callback registered on an idle system in one grace
	period rather than two.  The previous version of this acceleration
	was invalidated by the new grace-period kthreads.
2.	Fix an integer-size mismatch that prevented RCU from shifting
	to bulk-callback-invocation mode under overload.  (Courtesy of
	Eric Dumazet.)
3.	Remove list_for_each_continue_rcu(), as it is no longer used.
4.	Update rcutorture's module-parameter printout to include new
	parameters.
5.	Document the memory-ordering properties of RCU's grace-period
	primitives.  Note that the SRCU rewrite weakened these properties
	slightly.
6.	Reduce the RCU CPU stall warning timeout to 21 seconds so that
	it is once again somewhat shorter than the soft-lockup timeout.

							Thanx, Paul


 b/Documentation/RCU/checklist.txt |   17 +++++------
 b/Documentation/RCU/whatisRCU.txt |    4 --
 b/include/linux/rculist.h         |   17 -----------
 b/include/linux/rcupdate.h        |   20 +++++++++++++
 b/kernel/rcutorture.c             |    4 ++
 b/kernel/rcutree.c                |   57 ++++++++++++++++++++++++++++++++------
 b/kernel/rcutree_plugin.h         |    8 +++++
 b/lib/Kconfig.debug               |    2 -
 8 files changed, 90 insertions(+), 39 deletions(-)

