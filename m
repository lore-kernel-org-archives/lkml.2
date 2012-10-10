Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab2JJNip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:38:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25172 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2JJNin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:38:43 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3VdUaSZ7f9UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=evC8euxjDUgA:10 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121010133801.331863565@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 10 Oct 2012 09:38:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/6] [ANNOUNCE] 3.0.45-rt68-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.0.45-rt68-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 10/15/2012.

Enjoy,

-- Steve


To build 3.0.45-rt68-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.45.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.45-rt68-rc1.patch.xz

You can also build from 3.0.45-rt67 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.45-rt67-rt68-rc1.patch.xz


Changes from 3.0.45-rt67:

---


Steven Rostedt (2):
      softirq: Init softirq local lock after per cpu section is set up
      Linux 3.0.45-rt68-rc1

Thomas Gleixner (4):
      mm: slab: Fix potential deadlock
      mm: page_alloc: Use local_lock_on() instead of plain spinlock
      rt: rwsem/rwlock: lockdep annotations
      sched: Better debug output for might sleep

----
 include/linux/locallock.h |   19 +++++++++++++++++++
 include/linux/sched.h     |    4 ++++
 init/main.c               |    2 +-
 kernel/rt.c               |   46 ++++++++++++++++++++++++---------------------
 kernel/sched.c            |   23 +++++++++++++++++++++--
 localversion-rt           |    2 +-
 mm/page_alloc.c           |    4 ++--
 mm/slab.c                 |   10 ++--------
 8 files changed, 75 insertions(+), 35 deletions(-)
