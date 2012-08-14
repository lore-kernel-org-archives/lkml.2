Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab2HNSLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:11:37 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42100 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab2HNSLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:11:36 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 0/6] system_highpri_wq
Date: Wed, 15 Aug 2012 03:10:10 +0900
Message-Id: <1344967816-1136-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Yes>
References: <Yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change from v1
[ALL] Add cover-letter
[ALL] Rebase on git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7

[1/6] No change
[2/6] First added into this series.
[3/6] Add change log to clarify what pacth do,
      Add logic to handle the case "@cpu is WORK_CPU_UNBOUND"
[4/6] Fix awsome mistake: Set WQ_HIGHPRI for system_highpri_wq
[5/6] Adopt Tejun's comment about selection system_wq
[6/6] No change

This patchset introduce system_highpri_wq
in order to use proper cwq for highpri worker.

First 3 patches are not related to that purpose.
Just fix arbitrary issues.
Last 3 patches are for our purpose.

Joonsoo Kim (6):
  workqueue: use enum value to set array size of pools in gcwq
  workqueue: correct req_cpu in trace_workqueue_queue_work()
  workqueue: change value of lcpu in __queue_delayed_work_on()
  workqueue: introduce system_highpri_wq
  workqueue: use system_highpri_wq for highpri workers in
    rebind_workers()
  workqueue: use system_highpri_wq for unbind_work

 kernel/workqueue.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

-- 
1.7.9.5

