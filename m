Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab2G3WnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:43:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:54739 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab2G3WnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:43:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128601119"
Subject: [patch] x86, avx: don't use avx instructions with "noxsave" boot
 param
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, james.t.kukunas@linux.intel.com, neilb@suse.de
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jul 2012 15:46:15 -0700
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1343688375.3696.597.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the kernel has indeed enabled xsave before using AVX instructions.

Fixes the kernel boot panic with "noxsave" boot parameter.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/xor_avx.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
index 2510d35..77987cd 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -197,12 +197,12 @@ static struct xor_block_template xor_block_avx = {
 
 #define AVX_XOR_SPEED \
 do { \
-	if (cpu_has_avx) \
+	if (cpu_has_avx && cpu_has_osxsave) \
 		xor_speed(&xor_block_avx); \
 } while (0)
 
 #define AVX_SELECT(FASTEST) \
-	(cpu_has_avx ? &xor_block_avx : FASTEST)
+	((cpu_has_avx && cpu_has_osxsave) ? &xor_block_avx : FASTEST)
 
 #else
 


