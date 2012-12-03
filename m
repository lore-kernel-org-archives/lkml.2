Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab2LCMdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 07:33:12 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64815 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2LCMdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 07:33:10 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org
Cc: ccross@android.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH Resend 0/3] sched: fix nr_busy_cpus
Date: Mon,  3 Dec 2012 13:26:25 +0100
Message-Id: <1354537588-25831-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nr_busy_cpus field of the sched_group_power is sometime different from 0
whereas the platform is fully idle. This serie fixes 3 use cases:
 - when the SCHED softirq is raised on an idle core for idle load balance but
   the platform doesn't go out of the cpuidle state
 - when some CPUs enter idle state while booting all CPUs
 - when a CPU is unplug and/or replug

Vincent Guittot (3):
  sched: fix nr_busy_cpus with coupled cpuidle
  sched: fix init NOHZ_IDLE flag
  sched: fix update NOHZ_IDLE flag

 kernel/sched/core.c      |    1 +
 kernel/sched/fair.c      |    2 +-
 kernel/time/tick-sched.c |    2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

-- 
1.7.9.5

