Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2KZJgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:36:45 -0500
Received: from pmx.elettra.trieste.it ([140.105.206.203]:43123 "EHLO
	pmx.elettra.trieste.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2KZJgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:36:44 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2012 04:36:43 EST
From: Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
Subject: [PATCH] ARM: OMAP: Conditionally compile counter_32k
Date: Mon, 26 Nov 2012 10:28:03 +0100
Message-Id: <1353922083-1094-1-git-send-email-alessio.bogani@elettra.trieste.it>
X-Mailer: git-send-email 1.7.9.5
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.11.26.91816
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_700_799 0, FROM_NAME_PHRASE 0, __ANY_URI 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MULTIPLE_RCPTS_CC_X2 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS_NOANSWER '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32K timer isn't available on all OMAP devices.

Signed-off-by: Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
---
 arch/arm/plat-omap/Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/plat-omap/Makefile b/arch/arm/plat-omap/Makefile
index 8d88584..b1b321c 100644
--- a/arch/arm/plat-omap/Makefile
+++ b/arch/arm/plat-omap/Makefile
@@ -3,11 +3,13 @@
 #
 
 # Common support
-obj-y := sram.o dma.o fb.o counter_32k.o
+obj-y := sram.o dma.o fb.o
 obj-m :=
 obj-n :=
 obj-  :=
 
+obj-$(CONFIG_OMAP_32K_TIMER) += counter_32k.o
+
 # omap_device support (OMAP2+ only at the moment)
 
 obj-$(CONFIG_OMAP_DM_TIMER) += dmtimer.o
-- 
1.7.9.5

