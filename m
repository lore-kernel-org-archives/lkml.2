Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab0IMUPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:15:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:46365 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab0IMUOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:14:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,360,1280732400"; 
   d="scan'208";a="656856292"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Florian Mickler <florian@mickler.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 5/5] x86, bitops: Remove gcc < 4.1 workaround
Date: Mon, 13 Sep 2010 13:14:40 -0700
Message-Id: <1284408880-14414-6-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
References: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove workaround for gcc older than 4.1.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/bitops.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 545776e..1532109 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -22,14 +22,7 @@
  *
  * bit 0 is the LSB of addr; bit 32 is the LSB of (addr+1).
  */
-
-#if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
-/* Technically wrong, but this avoids compilation errors on some gcc
-   versions. */
-#define BITOP_ADDR(x) "=m" (*(volatile long *) (x))
-#else
 #define BITOP_ADDR(x) "+m" (*(volatile long *) (x))
-#endif
 
 #define ADDR				BITOP_ADDR(addr)
 
-- 
1.7.2.1

