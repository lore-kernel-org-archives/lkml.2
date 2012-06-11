Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab2FKQxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:53:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50106 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2FKQxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:53:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
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
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] nohz: Generalize nohz APIs for adaptive tickless
Date: Mon, 11 Jun 2012 18:53:17 +0200
Message-Id: <1339433602-26836-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

As per your suggestion I think it may be time to start a tree in -tip
and iterate incrementally there with what looks to me like the
uncontroversial bits of nohz cpusets.

This pile does the preparatory work to make the nohz API idle-agnostic
so that we are able to stop and restart the tick from non-idle places.

If you're fine with it, it's pullable there:

git://github.com/fweisbec/linux-dynticks.git
	nohz-for-tip

Frederic Weisbecker (5):
  nohz: Separate idle sleeping time accounting from nohz logic
  nohz: Make nohz API agnostic against idle ticks cputime accounting
  nohz: Rename ts->idle_tick to ts->last_tick
  nohz: Move ts->idle_calls incrementation into strict idle logic
  nohz: Move next idle expiry time record into idle logic area

 include/linux/tick.h     |    8 +-
 kernel/time/tick-sched.c |  191 ++++++++++++++++++++++++++--------------------
 kernel/time/timer_list.c |    4 +-
 3 files changed, 115 insertions(+), 88 deletions(-)

-- 
1.7.5.4

