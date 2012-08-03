Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2HCBXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 21:23:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11953 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2HCBXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 21:23:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6791"; a="218098483"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Fix XIP build due to PHYS_OFFSET definition moving
Date: Thu,  2 Aug 2012 18:23:14 -0700
Message-Id: <1343956994-27513-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.rc1.16.g05a20c8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the p2v changes, the PHYS_OFFSET #define moved into a
!__ASSEMBLY__ section. This causes a XIP build to fail with

 arch/arm/kernel/head.o: In function 'stext':
 arch/arm/kernel/head.S:146: undefined reference to 'PHYS_OFFSET'

Momentarily leave the #ifndef __ASSEMBLY__ section so we can
define PHYS_OFFSET for all compilation units.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I don't know if it's worth stable, seems that nobody has compiled XIP for
a year (back to 2.6.39 days?).

 arch/arm/include/asm/memory.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index fcb5757..3299b2d 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -187,6 +187,7 @@ static inline unsigned long __phys_to_virt(unsigned long x)
 #define __phys_to_virt(x)	((x) - PHYS_OFFSET + PAGE_OFFSET)
 #endif
 #endif
+#endif /* __ASSEMBLY__ */
 
 #ifndef PHYS_OFFSET
 #ifdef PLAT_PHYS_OFFSET
@@ -196,6 +197,8 @@ static inline unsigned long __phys_to_virt(unsigned long x)
 #endif
 #endif
 
+#ifndef __ASSEMBLY__
+
 /*
  * PFNs are used to describe any physical page; this means
  * PFN 0 == physical address 0.
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

