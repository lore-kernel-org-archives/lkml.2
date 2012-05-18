Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604Ab2ERDJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:09:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40398 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762547Ab2ERCw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:27 -0400
Message-Id: <20120518023254.656357227@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:32:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Archit Taneja <archit@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [ 02/53] ARM: OMAP: Revert "ARM: OMAP: ctrl: Fix CONTROL_DSIPHY register fields"
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Archit Taneja <archit@ti.com>

commit 08ca7444f589bedf9ad5d82883e5d0754852d73b upstream.

This reverts commit 46f8c3c7e95c0d30d95911e7975ddc4f93b3e237.

The commit above swapped the DSI1_PPID and DSI2_PPID register fields in
CONTROL_DSIPHY to be in sync with the newer public OMAP TRMs(after version V).

With this commit, contention errors were reported on DSI lanes some OMAP4 SDPs.
After probing the DSI lanes on OMAP4 SDP, it was seen that setting bits in the
DSI2_PPID field was pulling up voltage on DSI1 lanes, and DSI1_PPID field was
pulling up voltage on DSI2 lanes.

This proves that the current version of OMAP4 TRM is incorrect, swap the
position of register fields according to the older TRM versions as they were
correct.

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Archit Taneja <archit@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h b/arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h
index 1e2d332..c88420d 100644
--- a/arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h
+++ b/arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h
@@ -941,10 +941,10 @@
 #define OMAP4_DSI2_LANEENABLE_MASK				(0x7 << 29)
 #define OMAP4_DSI1_LANEENABLE_SHIFT				24
 #define OMAP4_DSI1_LANEENABLE_MASK				(0x1f << 24)
-#define OMAP4_DSI2_PIPD_SHIFT					19
-#define OMAP4_DSI2_PIPD_MASK					(0x1f << 19)
-#define OMAP4_DSI1_PIPD_SHIFT					14
-#define OMAP4_DSI1_PIPD_MASK					(0x1f << 14)
+#define OMAP4_DSI1_PIPD_SHIFT					19
+#define OMAP4_DSI1_PIPD_MASK					(0x1f << 19)
+#define OMAP4_DSI2_PIPD_SHIFT					14
+#define OMAP4_DSI2_PIPD_MASK					(0x1f << 14)
 
 /* CONTROL_MCBSPLP */
 #define OMAP4_ALBCTRLRX_FSX_SHIFT				31
-- 
1.7.10



