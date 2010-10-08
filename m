Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab0JHAIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:08:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:32878 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0JHAIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:08:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,299,1283756400"; 
   d="scan'208";a="614496510"
Subject: [PATCH] move async raid6 test to lib/Kconfig.debug
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <David.Woodhouse@intel.com>
Date: Thu, 07 Oct 2010 17:10:09 -0700
Message-ID: <20101008001009.7641.43321.stgit@localhost.localdomain>
User-Agent: StGit/0.15-6-g0854
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prompt for "Self test for hardware accelerated raid6 recovery" does not
belong in the top level configuration menu.  All the options in
crypto/async_tx/Kconfig are selected and do not depend on CRYPTO.
Kconfig.debug seems like a reasonable fit.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/Kconfig |   13 -------------
 lib/Kconfig.debug       |   13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
index 5de2ed1..1b11abb 100644
--- a/crypto/async_tx/Kconfig
+++ b/crypto/async_tx/Kconfig
@@ -24,19 +24,6 @@ config ASYNC_RAID6_RECOV
 	select ASYNC_PQ
 	select ASYNC_XOR
 
-config ASYNC_RAID6_TEST
-	tristate "Self test for hardware accelerated raid6 recovery"
-	depends on ASYNC_RAID6_RECOV
-	select ASYNC_MEMCPY
-	---help---
-	  This is a one-shot self test that permutes through the
-	  recovery of all the possible two disk failure scenarios for a
-	  N-disk array.  Recovery is performed with the asynchronous
-	  raid6 recovery routines, and will optionally use an offload
-	  engine if one is available.
-
-	  If unsure, say N.
-
 config ASYNC_TX_DISABLE_PQ_VAL_DMA
 	bool
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1b4afd2..0deaf81 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1150,6 +1150,19 @@ config ATOMIC64_SELFTEST
 
 	  If unsure, say N.
 
+config ASYNC_RAID6_TEST
+	tristate "Self test for hardware accelerated raid6 recovery"
+	depends on ASYNC_RAID6_RECOV
+	select ASYNC_MEMCPY
+	---help---
+	  This is a one-shot self test that permutes through the
+	  recovery of all the possible two disk failure scenarios for a
+	  N-disk array.  Recovery is performed with the asynchronous
+	  raid6 recovery routines, and will optionally use an offload
+	  engine if one is available.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"

