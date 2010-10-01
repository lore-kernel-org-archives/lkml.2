Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0JAHIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:08:55 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45879 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab0JAHG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:27 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 08/18] powerpc: Include the appropriate endianness header
Date: Fri,  1 Oct 2010 17:06:01 +1000
Message-Id: <1285916771-18033-9-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch will have powerpc include the appropriate generic endianness
header depending on what the compiler reports.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/byteorder.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/byteorder.h b/arch/powerpc/include/asm/byteorder.h
index aa6cc4f..ca931d0 100644
--- a/arch/powerpc/include/asm/byteorder.h
+++ b/arch/powerpc/include/asm/byteorder.h
@@ -7,6 +7,10 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#ifdef __LITTLE_ENDIAN__
+#include <linux/byteorder/little_endian.h>
+#else
 #include <linux/byteorder/big_endian.h>
+#endif
 
 #endif /* _ASM_POWERPC_BYTEORDER_H */
-- 
1.7.1

