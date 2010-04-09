Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0DIWiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:38:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49772 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab0DIWiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:38:50 -0400
Date: Fri, 9 Apr 2010 15:38:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/urgent] v2 rcu: updates for RCU lockdep
Message-ID: <20100409223843.GA25133@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100409054701.GA8833@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409054701.GA8833@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

These four patches provides a pair of new APIs and documentation to handle
a couple of cases that David Howells came across when running an NFS
workload under CONFIG_PROVE_RCU, along with some comment improvements
suggested by David and also some by Yong Zhang.

Updated from v1 (http://lkml.org/lkml/2010/4/9/28) to reflect David's
and Eric Dumazet's comments:

o	Remove (void*) cast from rcu_access_pointer().

o	Merge identical definitions of rcu_access_pointer() outside
	of #ifdef.

o	Merge comment syntax-error fix into comment patch.

							Thanx, Paul

 b/Documentation/RCU/NMI-RCU.txt   |   39 +++++++++++++++++++++-----------------
 b/Documentation/RCU/checklist.txt |    7 +++---
 b/Documentation/RCU/lockdep.txt   |   28 +++++++++++++++++++++++++--
 b/Documentation/RCU/whatisRCU.txt |    6 +++++
 b/include/linux/rcupdate.h        |   32 +++++++++++++++++++++++++++++++
 include/linux/rcupdate.h          |   28 ++++++++++++++++++++++-----
 6 files changed, 113 insertions(+), 27 deletions(-)
