Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965001Ab2J3RcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:32:00 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56268 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622Ab2J3Rb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:31:58 -0400
Date: Tue, 30 Oct 2012 10:04:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/14] Tracing changes for 3.8
Message-ID: <20121030170454.GA25712@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7606-0000-0000-000004EEB01A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series splits RCU's debugfs tracing files into per-RCU-flavor
directories and allows seeking to CPUs.  The patches in this series are
as follows:

1.	Create per-RCU-flavor debugfs directories.  (Courtesy of
	Michael Wang.)
2.	Add functions used by later patches to allow seeking to a given
	CPU.  (Courtesy of Michael Wang.)
3-5.	Convert rcudata, rcudata.csv, and rcu_pending to the new debugfs
	format.  (Courtesy of Michael Wang.)
6.	Replace the old interface with the new one.  (Courtesy of
	Michael Wang.)
7.	Remove the unused rcudata.csv interface.  (Courtesy of Michael Wang.)
8.	Fix formatting of grace-period numbers in rcugp debugfs output.
9-12.	Split rcubarrier, rcuboost, rcugp, and rcuhier by RCU flavor.
	(Courtesy of Michael Wang.)
13.	Remove old debugfs interfaces and stop printing RCU flavor in
	output given that it is implied by the directory name.
	(Courtesy of Michael Wang.)
14.	Add debugfs tracing for synchronize_sched_expedited().

							Thanx, Paul

 b/kernel/rcutree.c       |    4 
 b/kernel/rcutree_trace.c |    8 
 kernel/rcutree_trace.c   |  698 ++++++++++++++++++++++-------------------------
 3 files changed, 351 insertions(+), 359 deletions(-)

