Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab0EKXcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:32:48 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37312 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0EKXcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:32:47 -0400
Date: Tue, 11 May 2010 16:32:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/rcu 0/11] Add debugobjects checking to RCU
 callbacks
Message-ID: <20100511233241.GA20250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset pulls Mathieu's debugobject-specific commits out of the
earlier patchbomb (http://lkml.org/lkml/2010/5/4/298):

1.	Add transition-check capability to debugobjects.
2.	Add init_rcu_head_on_stack() and destroy_rcu_head_on_stack() APIs.
3.	Remove rcu_head initializations from RCU, except for those
	for on-stack rcu_head structures, which must use the APIs
	introduced in #2 above.
4-9.	Ditto for powerpc, block, staging, fs, mm, and selinux.
10.	Remove the old rcu_head initialization APIs.
11.	Add the debugobjects workings to RCU, enabled by
	CONFIG_DEBUG_OBJECTS_RCU_HEAD.

These have been reordered and consolidated to reduce inter-commit
dependencies.

							Thanx, Paul

 b/arch/powerpc/mm/pgtable.c                   |    1 
 b/block/cfq-iosched.c                         |    1 
 b/block/genhd.c                               |    1 
 b/drivers/staging/batman-adv/hard-interface.c |    1 
 b/fs/file.c                                   |    3 
 b/fs/fs-writeback.c                           |   31 +++-
 b/fs/partitions/check.c                       |    1 
 b/include/linux/debugobjects.h                |   11 +
 b/include/linux/init_task.h                   |    1 
 b/include/linux/rcupdate.h                    |    8 +
 b/kernel/rcupdate.c                           |  170 ++++++++++++++++++++++++++
 b/kernel/rcutiny.c                            |    6 
 b/kernel/rcutorture.c                         |    2 
 b/kernel/rcutree.c                            |    4 
 b/kernel/rcutree_plugin.h                     |    2 
 b/lib/Kconfig.debug                           |    6 
 b/lib/debugobjects.c                          |   59 ++++++++-
 b/mm/backing-dev.c                            |    1 
 b/mm/slob.c                                   |    1 
 b/security/selinux/avc.c                      |    1 
 b/security/selinux/netnode.c                  |    2 
 include/linux/rcupdate.h                      |   55 +++++++-
 kernel/rcutiny.c                              |    2 
 kernel/rcutree.c                              |    2 
 24 files changed, 344 insertions(+), 28 deletions(-)
