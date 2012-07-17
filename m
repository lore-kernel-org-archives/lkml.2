Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2GQPcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:32:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31586 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab2GQPco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:32:44 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=Slhf0Lo6QfIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=Dy9FSkG8L0gs_orUxm0A:9 a=U62fhAwekXMA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120717153115.606116459@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Jul 2012 11:31:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 00/12] [ANNOUNCE] 3.4.4-rt14-rc2 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.4.4-rt14-rc2.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 7/18/2012.

What changed between -rc1:

  Patch was added:
    cpu/rt: Fix cpu_hotplug variable initialization

Enjoy,

-- Steve


To build 3.4.4-rt14-rc2 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.4.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.4-rt14-rc2.patch.xz

You can also build from 3.4.4-rt13 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.4-rt13-rt14-rc2.patch.xz


Changes from 3.4.4-rt13:

---


Carsten Emde (4):
      Latency histogramms: Cope with backwards running local trace clock
      Latency histograms: Adjust timer, if already elapsed when programmed
      Disable RT_GROUP_SCHED in PREEMPT_RT_FULL
      Latency histograms: Detect another yet overlooked sharedprio condition

Mike Galbraith (1):
      fs, jbd: pull your plug when waiting for space

Steven Rostedt (5):
      cpu/rt: Rework cpu down for PREEMPT_RT
      cpu/rt: Fix cpu_hotplug variable initialization
      workqueue: Revert workqueue: Fix PF_THREAD_BOUND abuse
      workqueue: Revert workqueue: Fix cpuhotplug trainwreck
      Linux 3.4.4-rt14-rc2

Thomas Gleixner (1):
      slab: Prevent local lock deadlock

Yong Zhang (1):
      perf: Make swevent hrtimer run in irq instead of softirq

----
 fs/jbd/checkpoint.c         |    2 +
 include/linux/cpu.h         |    6 +-
 include/linux/hrtimer.h     |    3 +
 include/linux/sched.h       |    9 +-
 include/linux/workqueue.h   |    5 +-
 init/Kconfig                |    1 +
 kernel/cpu.c                |  240 ++++++++++++++----
 kernel/events/core.c        |    1 +
 kernel/hrtimer.c            |   16 +-
 kernel/sched/core.c         |   82 +++++-
 kernel/trace/latency_hist.c |   74 +++---
 kernel/workqueue.c          |  578 +++++++++++++++++++++++++++++++------------
 localversion-rt             |    2 +-
 mm/slab.c                   |   26 +-
 14 files changed, 788 insertions(+), 257 deletions(-)
