Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162890Ab2GLXWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:22:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4313 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162580Ab2GLXT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:19:58 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=xL1HYeFVtIAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=Dy9FSkG8L0gs_orUxm0A:9 a=U62fhAwekXMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120712231827.084920483@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 12 Jul 2012 19:18:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/8] [ANNOUNCE] 3.2.22-rt35-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.2.22-rt35-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 7/16/2012.

Enjoy,

-- Steve


To build 3.2.22-rt35-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.22.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.22-rt35-rc1.patch.xz

You can also build from 3.2.22-rt34 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.22-rt34-rt35-rc1.patch.xz


Changes from 3.2.22-rt34:

---


Carsten Emde (4):
      Latency histogramms: Cope with backwards running local trace clock
      Latency histograms: Adjust timer, if already elapsed when programmed
      Disable RT_GROUP_SCHED in PREEMPT_RT_FULL
      Latency histograms: Detect another yet overlooked sharedprio condition

Mike Galbraith (1):
      fs, jbd: pull your plug when waiting for space

Steven Rostedt (1):
      Linux 3.2.22-rt35-rc1

Thomas Gleixner (1):
      slab: Prevent local lock deadlock

Yong Zhang (1):
      perf: Make swevent hrtimer run in irq instead of softirq

----
 fs/jbd/checkpoint.c         |    2 ++
 include/linux/hrtimer.h     |    3 ++
 include/linux/sched.h       |    2 +-
 init/Kconfig                |    1 +
 kernel/events/core.c        |    1 +
 kernel/hrtimer.c            |   16 ++++++++--
 kernel/trace/latency_hist.c |   74 +++++++++++++++++++++++--------------------
 localversion-rt             |    2 +-
 mm/slab.c                   |   26 ++++++++++++---
 9 files changed, 85 insertions(+), 42 deletions(-)
