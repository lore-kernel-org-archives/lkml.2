Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464Ab2EJRea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:34:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58653 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760413Ab2EJReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:25 -0400
Message-Id: <20120510173134.763009072@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Archit Taneja <archit@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [ 21/52] ARM: OMAP: Revert "ARM: OMAP: ctrl: Fix CONTROL_DSIPHY register fields"
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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


