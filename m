Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab2J2AJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 20:09:15 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:59709 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2J2AJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 20:09:13 -0400
Message-Id: <f0cf58bc8f8a34d226cccb6f89d3cd49a2620015.1351466765.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1351466765.git.josh.cartwright@ni.com>
References: <cover.1351466765.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Sun, 21 Oct 2012 18:33:59 -0500
Subject: [PATCH v4 4/5] ARM: annotate VMALLOC_END definition with _AC
To: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Michal Simek <michal.simek@xilinx.com>
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/28/2012 07:08:53 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/28/2012 07:08:53 PM,
	Serialize complete at 10/28/2012 07:08:53 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-28_05:2012-10-26,2012-10-28,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the definition of VMALLOC_END suitable for use within
assembly code.  This is necessary to allow the use of VMALLOC_END in
defining where the early uart is mapped for use with DEBUG_LL.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 08c1231..72904a2 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -40,7 +40,7 @@
  */
 #define VMALLOC_OFFSET		(8*1024*1024)
 #define VMALLOC_START		(((unsigned long)high_memory + VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1))
-#define VMALLOC_END		0xff000000UL
+#define VMALLOC_END		_AC(0xff000000,UL)
 
 #define LIBRARY_TEXT_START	0x0c000000
 
-- 
1.8.0


