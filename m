Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2JLBVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:21:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21152 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2JLBV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:21:27 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=P7jyfKTWim0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=evC8euxjDUgA:10 a=VwQbUJbxAAAA:8 a=Dy9FSkG8L0gs_orUxm0A:9 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121012012024.056658930@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Oct 2012 21:20:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/8] [ANNOUNCE] 3.2.31-rt47-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.2.31-rt47-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 10/16/2012.

Enjoy,

-- Steve


To build 3.2.31-rt47-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.31.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.31-rt47-rc1.patch.xz

You can also build from 3.2.31-rt46 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.31-rt46-rt47-rc1.patch.xz


Changes from 3.2.31-rt46:

---


Steven Rostedt (2):
      softirq: Init softirq local lock after per cpu section is set up
      Linux 3.2.31-rt47-rc1

Thomas Gleixner (6):
      random: Make it work on rt
      mm: slab: Fix potential deadlock
      mm: page_alloc: Use local_lock_on() instead of plain spinlock
      rt: rwsem/rwlock: lockdep annotations
      sched: Better debug output for might sleep
      stomp_machine: Use mutex_trylock when called from inactive cpu

----
 drivers/char/random.c     |   10 ++++++----
 include/linux/irqdesc.h   |    1 +
 include/linux/locallock.h |   19 +++++++++++++++++++
 include/linux/random.h    |    2 +-
 include/linux/sched.h     |    4 ++++
 init/main.c               |    2 +-
 kernel/irq/handle.c       |    7 +++++--
 kernel/irq/manage.c       |    6 ++++++
 kernel/rt.c               |   46 ++++++++++++++++++++++++---------------------
 kernel/sched.c            |   23 +++++++++++++++++++++--
 kernel/stop_machine.c     |   13 +++++++++----
 localversion-rt           |    2 +-
 mm/page_alloc.c           |    4 ++--
 mm/slab.c                 |   10 ++--------
 14 files changed, 103 insertions(+), 46 deletions(-)
