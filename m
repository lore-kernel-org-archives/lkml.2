Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab1K3RvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:51:19 -0500
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:44461 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750984Ab1K3RvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:51:13 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Wed, 30 Nov 2011 09:50:59 -0800
Message-Id: <1322675459-24792-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few fixes:

 - Fixes for missing RCU read locking due to net neighbour changes
 - Fix for IPoIB softlockup in error path
 - Low-level driver fixes to cxgb4 and qib

Thanks!

Eric Dumazet (1):
      IB: Fix RCU lockdep splats

Jonathan Lallinger (1):
      RDMA/cxgb4: Fix iw_cxgb4 count_rcqes() logic

Kumar Sanghvi (1):
      RDMA/cxgb4: Fix retry with MPAv1 logic for MPAv2

Mike Marciniszyn (3):
      IB/qib: Don't use schedule_work()
      IB/qib: Fix over-scheduling of QSFP work
      IB/ipoib: Prevent hung task or softlockup processing multicast response

Roland Dreier (1):
      Merge branches 'cxgb4', 'ipoib', 'misc' and 'qib' into for-next

 drivers/infiniband/core/addr.c                 |    9 ++++++---
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |    4 ++++
 drivers/infiniband/hw/cxgb4/cm.c               |   10 +++++++++-
 drivers/infiniband/hw/cxgb4/cq.c               |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c             |    6 ++++--
 drivers/infiniband/hw/qib/qib_iba7322.c        |   18 +++++++++---------
 drivers/infiniband/hw/qib/qib_qsfp.c           |   12 ------------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |   13 ++++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   20 ++++++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   13 +++++++++----
 10 files changed, 62 insertions(+), 45 deletions(-)
