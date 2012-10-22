Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2JVVOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:14:33 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:37516 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab2JVVOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:14:31 -0400
Date: Mon, 22 Oct 2012 16:11:57 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        John Linn <john.linn@xilinx.com>
Subject: [PATCH v2 1/4] ARM: annotate VMALLOC_END definition with _AC
Message-ID: <20121022211157.GB31538@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
In-Reply-To: <20121022211040.GA31538@beefymiracle.amer.corp.natinst.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/22/2012 04:11:52 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/22/2012 04:11:53 PM,
	Serialize complete at 10/22/2012 04:11:53 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-22_03:2012-10-22,2012-10-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the definition of VMALLOC_END suitable for use within
assembly code.  This is necessary to allow the use of VMALLOC_END in
defining where the early uart is mapped for use with DEBUG_LL.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
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

