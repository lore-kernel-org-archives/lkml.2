Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0DIXBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:01:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33605
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690Ab0DIXBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:01:30 -0400
Date: Fri, 09 Apr 2010 16:01:32 -0700 (PDT)
Message-Id: <20100409.160132.216116766.davem@davemloft.net>
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: [PATCH 0/4]: Respin local_irq_*_nmi() stuff.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter, I've respun the local_irq_*_nmi() interface addition, sparc64
implementation, and trace/sched_clock annotations against Linus's
tree.

I've tested all of the tracers in various different configurations on
sparc64 and I haven't triggered any of the bug checks or crashes yet
so it should be good.

It can also be pulled from:

	master.kernel.org:/pub/scm/linux/kernel/git/davem/trace-2.6.git

And it would be nice to see this upstream soon so I can build upon
it :-)

You'll need to add the perf locking fix annotation to the -tip tree
as per you initial patch set, that didn't apply to mainline so I
didn't put it in here.

Thanks!

--------------------

The following changes since commit 0eddb519b9127c73d53db4bf3ec1d45b13f844d1:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/trace-2.6.git master

David S. Miller (2):
      sparc64: Implement local_irq_save_nmi() override.
      tracing: Use local_irq_{save,restore}_nmi() in tracers.

Peter Zijlstra (2):
      kernel: local_irq_{save,restore}_nmi()
      sched: Use local_irq_save_nmi() in cpu_clock()

 arch/sparc/include/asm/irqflags_64.h |   29 +++++++++++++++++++
 include/linux/irqflags.h             |   51 ++++++++++++++++++++++++++++++++--
 kernel/lockdep.c                     |    7 ++++
 kernel/sched_clock.c                 |    4 +-
 kernel/trace/ftrace.c                |    8 ++--
 kernel/trace/trace_functions.c       |    8 ++--
 kernel/trace/trace_functions_graph.c |    8 ++--
 kernel/trace/trace_irqsoff.c         |    8 +++++
 kernel/trace/trace_sched_wakeup.c    |    4 +-
 kernel/trace/trace_stack.c           |    4 +-
 10 files changed, 110 insertions(+), 21 deletions(-)
