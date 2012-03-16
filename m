Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2CPTBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:01:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:7734 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795Ab2CPTBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:01:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129848676"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH 03/11] ada152x: Remove broken usage of spin_is_locked
Date: Fri, 16 Mar 2012 12:00:56 -0700
Message-Id: <1331924464-18023-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
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

