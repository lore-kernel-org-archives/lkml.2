Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab2C1Aul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:50:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:24083 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415Ab2C1Ark (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124058218"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        gregkh@linuxfoundation.org
Subject: [PATCH 04/13] staging/zmem: Use lockdep_assert_held instead of spin_is_locked
Date: Tue, 27 Mar 2012 17:47:08 -0700
Message-Id: <1332895637-32572-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

WARN_ON(!spin_is_locked()) will always trigger on UP.
Use lockdep_assert_held instead.

Cc: gregkh@linuxfoundation.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/staging/zcache/tmem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/tmem.h b/drivers/staging/zcache/tmem.h
index ed147c4..0d4aa82 100644
--- a/drivers/staging/zcache/tmem.h
+++ b/drivers/staging/zcache/tmem.h
@@ -47,7 +47,7 @@
 #define ASSERT_INVERTED_SENTINEL(_x, _y) do { } while (0)
 #endif
 
-#define ASSERT_SPINLOCK(_l)	WARN_ON(!spin_is_locked(_l))
+#define ASSERT_SPINLOCK(_l)	lockdep_assert_held(_l)
 
 /*
  * A pool is the highest-level data structure managed by tmem and
-- 
1.7.7.6

