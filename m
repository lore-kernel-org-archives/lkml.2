Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1H2PZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:25:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54224 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1H2PZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:25:56 -0400
Subject: Re: [PATCH 13/32] nohz: Adaptive tick stop and restart on nohz
 cpuset
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 17:25:36 +0200
In-Reply-To: <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314631536.2816.89.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> When a CPU is included in a nohz cpuset, try to switch
> it to nohz mode from the timer interrupt if it is the
> only non-idle task running.
> 
> Then restart the tick if necessary from the wakeup path
> if we are enqueuing a second task while the timer is stopped,
> so that the scheduler tick is rearmed.

Shouldn't you first put the syscall hooks in place before allowing the
tick to be switched off? It seems this patch is somewhat too early in
the series.

> This assumes we are using TTWU_QUEUE sched feature so I need
> to handle the off case (or actually not handle it but properly),
> because we need the adaptive tick restart and what will come
> along in further patches to be done locally and before the new
> task ever gets scheduled.

We could certainly remove that feature flag and always use it, it was
mostly a transition debug switch in case something didn't work or
performance issues were found due to this.

> I also need to look at the ARCH_WANT_INTERRUPTS_ON_CTXW case
> and the remote wakeups.

Well, ideally we'd simply get rid of that, rmk has some preliminary
patches in that direction.

