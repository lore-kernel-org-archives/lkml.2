Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030503Ab2CNC3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:29:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965217Ab2CNC3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:29:46 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=JYP23UEXQ_gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=Dy9FSkG8L0gs_orUxm0A:9 a=YOzYloys-ObbU2UDB7EA:7 a=U62fhAwekXMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314022658.783312660@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 13 Mar 2012 22:26:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/7] [ANNOUNCE] 3.0.23-rt40-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.0.23-rt40-rc1.

Please scream at me if I messed something up. Please test the patches too.

Note that this release will be quick, and I plan on pushing out
3.0.23-rt40 tomorrow, and start testing and release 3.0.24-rt41.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 3/14/2012.

Enjoy,

-- Steve


To build 3.0.23-rt40-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.23.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.23-rt40-rc1.patch.xz

You can also build from 3.0.23-rt39 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.23-rt39-rt40-rc1.patch.xz


Changes from 3.0.23-rt39:

---


Steven Rostedt (2):
      Revert "ACPI: Convert embedded controller lock to raw spinlock"
      Linux 3.0.23-rt40-rc1

Thomas Gleixner (5):
      softirq: Check preemption after reenabling interrupts
      rt: Introduce cpu_chill()
      fs: dcache: Use cpu_chill() in trylock loops
      fs: namespace: Use cpu_chill() instead of cpu_relax()
      net: Use cpu_chill() instead of cpu_relax()

----
 block/blk-iopoll.c      |    3 +++
 block/blk-softirq.c     |    3 +++
 drivers/acpi/ec.c       |   22 +++++++++++-----------
 drivers/acpi/internal.h |    2 +-
 fs/autofs4/autofs_i.h   |    1 +
 fs/autofs4/expire.c     |    2 +-
 fs/dcache.c             |    7 ++++---
 fs/namespace.c          |    3 ++-
 include/linux/delay.h   |    6 ++++++
 include/linux/preempt.h |    3 +++
 localversion-rt         |    2 +-
 net/core/dev.c          |    6 ++++++
 net/rds/ib_rdma.c       |    3 ++-
 13 files changed, 44 insertions(+), 19 deletions(-)
