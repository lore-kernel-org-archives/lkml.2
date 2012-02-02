Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2BBAnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:43:04 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57812 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab2BBAnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:43:02 -0500
Date: Wed, 1 Feb 2012 16:42:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH RFC idle] Make arm, sh, and x86 stop using RCU when idle
Message-ID: <20120202004253.GA10946@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020200-5806-0000-0000-000011F512BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

RCU's shiny new diagnostics (thank you, Frederic!) for using RCU when idle
located a few problems in arm, sh, and x86.  This patch series contains
alleged fixes for these problems.  And they are real problems -- if RCU
believes that the CPU is idle, it is ignoring it.  Which means that the
idle CPU can say "rcu_read_lock()" all it like, but there will be no
useful effect.

I was tempted to break these up, but doing so is bad for bisectability.

							Thanx, Paul

------------------------------------------------------------------------

 arch/arm/kernel/process.c          |    2 --
 arch/arm/mach-at91/cpuidle.c       |    3 +++
 arch/arm/mach-davinci/cpuidle.c    |    3 +++
 arch/arm/mach-exynos/common.c      |    2 ++
 arch/arm/mach-highbank/pm.c        |   12 ++++++++++++
 arch/arm/mach-imx/mm-imx3.c        |    3 +++
 arch/arm/mach-imx/pm-imx27.c       |    4 ++++
 arch/arm/mach-imx/pm-imx6q.c       |    4 ++++
 arch/arm/mach-kirkwood/cpuidle.c   |    3 +++
 arch/arm/mach-mx5/mm.c             |    3 +++
 arch/arm/mach-mx5/pm-imx5.c        |    3 +++
 arch/arm/mach-mxs/pm.c             |    4 ++++
 arch/arm/mach-omap1/pm.c           |    4 ++++
 arch/arm/mach-omap2/pm24xx.c       |    2 ++
 arch/arm/mach-omap2/pm34xx.c       |    2 ++
 arch/arm/mach-omap2/pm44xx.c       |    3 +++
 arch/arm/mach-pnx4008/pm.c         |    2 ++
 arch/arm/mach-prima2/pm.c          |    4 ++++
 arch/arm/mach-s5p64x0/common.c     |    2 ++
 arch/arm/mach-s5pc100/common.c     |    2 ++
 arch/arm/mach-s5pv210/common.c     |    2 ++
 arch/arm/mach-shmobile/cpuidle.c   |    3 +++
 arch/arm/mach-shmobile/pm-sh7372.c |    8 ++++++++
 arch/sh/kernel/idle.c              |   11 ++++++++---
 arch/x86/kernel/process.c          |   13 ++++++++++++-
 arch/x86/kernel/process_32.c       |    2 --
 arch/x86/kernel/process_64.c       |    4 ----
 drivers/idle/intel_idle.c          |    2 ++
 28 files changed, 100 insertions(+), 12 deletions(-)

