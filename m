Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1HPOIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:08:17 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:33949 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1HPOIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:08:15 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v3 0/2] sched: Enforce order of leaf CFS runqueues
Date: Tue, 16 Aug 2011 16:07:44 +0200
Message-Id: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code review showed, that the hierarchical order of the leaf CFS runqueues
introduced by commit 67e8625 ("sched: Introduce hierarchal order on shares
update list") is not yet achieved.  (See description of second patch for an
example.)

During the discussion of possible solutions [1], Paul Turner mentioned an
"ideal approach" to solve that.

This is the third iteration of the patch-set that tries to realize this ideal
approach. 

Changes since v2 (http://lkml.org/lkml/2011/7/27/348):
- rebased against v3.1-rc2
- dropped patches that are unrelated to the actual bug fix
- fixed a race where freed memory might be accessed
- addressed Peter's comment about *not* providing this kind of
  RCU list manipulation as a separate function

Changes since v1 (http://lkml.org/lkml/2011/7/21/169):
- rebased against v3.0
- included follow-up patches 4 to 8 (demonstrating the purpose of patch 1)
- patch 1 should be complete this time
- moved more functionality to rculist.h (see patch 2+3)
- more comments everywhere


Patch 1: New functions to splice RCU lists.

Patch 2: The actual bugfix.


Regards
Jan

[1] Original discussion: http://lkml.org/lkml/2011/7/18/86


Jan H. Schönherr (2):
  rcu: More rcu-variants for list manipulation
  sched: Handle on_list ancestor in list_add_leaf_cfs_rq()

 include/linux/list.h    |   12 +++++++
 include/linux/rculist.h |   74 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_fair.c     |   79 ++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 147 insertions(+), 18 deletions(-)

-- 
1.7.6

