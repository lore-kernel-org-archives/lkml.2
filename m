Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2FMQUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:20:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34893 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab2FMQUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:20:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [RFC GIT PULL] nohz: Basic cputime accounting for adaptive tickless
Date: Wed, 13 Jun 2012 18:19:50 +0200
Message-Id: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

This starts the basic code that allow accounting of cputime spent tickless
outside idle, which is a first step to prepare for the adaptive nohz
infrastructure.

I hope we can set a tree in -tip for that. If you're fine with it
this is pullable from:

git://github.com/fweisbec/linux-dynticks.git
	nohz-for-tip

Thanks.


Frederic Weisbecker (7):
  nohz: Add more comment about CONFIG_NO_HZ
  nohz: Introduce adaptive nohz config
  nohz: Generalize tickless cpu time accounting
  nohz: Account user and system times in adaptive nohz mode
  x86: Syscall hooks for adaptive nohz mode
  x86: Add adaptive tickless hooks on do_notify_resume()
  x86: Exception hooks for adaptive tickless

 arch/Kconfig                       |    8 ++
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/thread_info.h |   10 ++-
 arch/x86/kernel/ptrace.c           |    5 ++
 arch/x86/kernel/signal.c           |    3 +
 arch/x86/kernel/traps.c            |   14 +++-
 arch/x86/mm/fault.c                |   13 +++-
 include/linux/kernel_stat.h        |    2 +
 include/linux/tick.h               |   59 +++++++++++-----
 kernel/sched/core.c                |   27 +++++++
 kernel/time/Kconfig                |   14 +++-
 kernel/time/tick-sched.c           |  139 ++++++++++++++++++++++++++++++-----
 kernel/time/timer_list.c           |    3 +-
 13 files changed, 246 insertions(+), 52 deletions(-)

-- 
1.7.5.4

