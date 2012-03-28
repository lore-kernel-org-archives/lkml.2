Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab2C1AvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:51:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:51109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab2C1Ark (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="122444842"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Subject: [PATCH 03/13] ada152x: Remove broken usage of spin_is_locked
Date: Tue, 27 Mar 2012 17:47:07 -0700
Message-Id: <1332895637-32572-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Remove racy usage of spin_is_locked. The author seems to have been
unclear on the concept of locking.

This is debug code normally not enabled, but I caught it on a tree sweep.

Cc: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/scsi/aha152x.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f17c92c..c56b617 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -288,9 +288,6 @@ static LIST_HEAD(aha152x_host_list);
 
 #define DO_LOCK(flags)	\
 	do { \
-		if(spin_is_locked(&QLOCK)) { \
-			DPRINTK(debug_intr, DEBUG_LEAD "(%s:%d) already locked at %s:%d\n", CMDINFO(CURRENT_SC), __func__, __LINE__, QLOCKER, QLOCKERL); \
-		} \
 		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
 		spin_lock_irqsave(&QLOCK,flags); \
 		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
-- 
1.7.7.6

