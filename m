Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab2HHGZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:25:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:26078 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab2HHGZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:25:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,730,1336374000"; 
   d="scan'208";a="183012416"
From: Dragos Tatulea <dragos.tatulea@intel.com>
To: hpa@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Dragos Tatulea <dragos.tatulea@intel.com>
Subject: [PATCH] x86: set fpmath to 387 to avoid gcc warnings
Date: Wed,  8 Aug 2012 09:27:05 +0300
Message-Id: <1344407225-1276-1-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gcc has a different default fpmath set (ex: sse),
many unuseful warnings will be spewed.

This can affect out of tree modules that compile with
-Werror (ex: systemtap stp scripts).

Be paranoid and add -msoft-float as well to try to
get an error if FP instructions are generated at all.

Change-Id: If9271d7aea7371f394ede0bc5e3ed1383cdb0e1a
Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
---
 arch/x86/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b1c611e..b771d0b 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -130,6 +130,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 # prevent gcc from generating any FP code by mistake
 KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
+KBUILD_CFLAGS += $(call cc-option,-mfpmath=387 -msoft-float,)
 
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
-- 
1.7.9.5

