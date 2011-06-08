Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1FHBLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:11:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:64877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab1FHBLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:11:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="10897513"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: [PATCH 3/3] x86: Change dotraplinkage into asmregparm for 32bit
Date: Tue,  7 Jun 2011 18:10:01 -0700
Message-Id: <1307495401-2631-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307495401-2631-1-git-send-email-andi@firstfloor.org>
References: <1307495401-2631-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Now with asmregparm available again it's cleaner to explicitely
mark them as needing register params on 32bit.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/traps.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0310da6..2d06195 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -5,7 +5,7 @@
 #include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
 #ifdef CONFIG_X86_32
-#define dotraplinkage
+#define dotraplinkage asmregparm
 #else
 #define dotraplinkage asmlinkage
 #endif
-- 
1.7.4.4

