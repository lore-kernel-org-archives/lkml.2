Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0FDN1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:27:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:45764 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab0FDN1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:27:36 -0400
Message-ID: <4C08FF36.80806@kernel.org>
Date: Fri, 04 Jun 2010 15:27:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] sched/core: scheduler patches for cmwq
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Jun 2010 13:27:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Please pull from the following branch to receive four sched/core
patches preparing for cmwq.  All have been reviewed and acked by
Peter[1].  The first two patches are generic update to when cpu_active
and scheduler configurations are updated during CPU on/offlining.  The
latter two add hardcoded hooks for cmwq (currently noop).

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git sched-wq

Tejun Heo (4):
      sched: define and use CPU_PRI_* enums for cpu notifier priorities
      sched: adjust when cpu_active and cpuset configurations are updated during cpu on/offlining
      sched: refactor try_to_wake_up()
      sched: add hooks for workqueue

 include/linux/cpu.h        |   25 ++++++
 include/linux/cpuset.h     |    6 ++
 include/linux/perf_event.h |    2 +-
 include/linux/sched.h      |    1 +
 kernel/cpu.c               |    6 --
 kernel/cpuset.c            |   21 +----
 kernel/fork.c              |    2 +-
 kernel/sched.c             |  205 ++++++++++++++++++++++++++++++++------------
 kernel/workqueue_sched.h   |   16 ++++
 9 files changed, 203 insertions(+), 81 deletions(-)
 create mode 100644 kernel/workqueue_sched.h

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/992913
