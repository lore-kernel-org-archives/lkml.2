Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab2C1AsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:48:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:51109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528Ab2C1Arm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125867365"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 10/13] smsc911x: Use lockdep_assert_held instead of home grown buggy construct
Date: Tue, 27 Mar 2012 17:47:14 -0700
Message-Id: <1332895637-32572-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: netdev@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/net/ethernet/smsc/smsc911x.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.h b/drivers/net/ethernet/smsc/smsc911x.h
index 9ad5e5d..4fbb697 100644
--- a/drivers/net/ethernet/smsc/smsc911x.h
+++ b/drivers/net/ethernet/smsc/smsc911x.h
@@ -52,7 +52,7 @@
 
 #ifdef CONFIG_DEBUG_SPINLOCK
 #define SMSC_ASSERT_MAC_LOCK(pdata) \
-		WARN_ON(!spin_is_locked(&pdata->mac_lock))
+		lockdep_assert_held(&(pdata)->mac_lock)
 #else
 #define SMSC_ASSERT_MAC_LOCK(pdata) do {} while (0)
 #endif				/* CONFIG_DEBUG_SPINLOCK */
-- 
1.7.7.6

