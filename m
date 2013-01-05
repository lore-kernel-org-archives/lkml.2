Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3AEREZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:04:25 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33007 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab3AEREW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:04:22 -0500
Date: Sat, 5 Jan 2013 09:03:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/3] Documentation and rcutorture changes for 3.9
Message-ID: <20130105170356.GA13534@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-3620-0000-0000-000000D1823F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The following are changes to documentation and rcutorture:

1.	Export trace_clock_local() in order to allow rcutorture event
	tracing to emit the time of the beginning of the RCU read-side
	critical section at the point where a failure is detected.
2.	Reduce rcutorture's read-side tracing to include only failures,
	thus cutting the number of events down to something reasonable
	(normally zero, in fact!).
3.	Add atomic_xchg() to the list of atomic operations and memory
	barriers, courtesy of Richard Braun.

							Thanx, Paul


 Documentation/atomic_ops.txt      |    2 ++
 Documentation/memory-barriers.txt |    1 +
 include/linux/rcupdate.h          |   13 ++++++++++---
 include/trace/events/rcu.h        |   19 ++++++++++++++-----
 kernel/rcupdate.c                 |    9 ++++++---
 kernel/rcutorture.c               |   31 ++++++++++++++++++++++++-------
 kernel/trace/trace_clock.c        |    1 +
 7 files changed, 58 insertions(+), 18 deletions(-)

