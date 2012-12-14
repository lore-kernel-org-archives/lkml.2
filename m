Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2LNFuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:50:06 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34352 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab2LNFuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:50:03 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, johnstul@us.ibm.com, horms@verge.net.au,
        shinya.kuribayashi.px@renesas.com, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Fri, 14 Dec 2012 14:54:37 +0900
Message-Id: <20121214055437.10081.97676.sendpatchset@w520>
In-Reply-To: <20121214055323.10081.12056.sendpatchset@w520>
References: <20121214055323.10081.12056.sendpatchset@w520>
Subject: [PATCH 08/08] clocksource: sh_cmt: Add CMT register layout comment
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add a comment about different register layouts
supported by the CMT driver.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/clocksource/sh_cmt.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- 0005/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2012-12-14 11:43:10.000000000 +0900
@@ -66,6 +66,21 @@ struct sh_cmt_priv {
 			    unsigned long value);
 };
 
+/* Examples of supported CMT timer register layouts and I/O access widths:
+ *
+ * "16-bit counter and 16-bit control" as found on sh7263:
+ * CMSTR 0xfffec000 16-bit
+ * CMCSR 0xfffec002 16-bit
+ * CMCNT 0xfffec004 16-bit
+ * CMCOR 0xfffec006 16-bit
+ *
+ * "32-bit counter and 16-bit control" as found on sh7372, sh73a0, r8a7740:
+ * CMSTR 0xffca0000 16-bit
+ * CMCSR 0xffca0060 16-bit
+ * CMCNT 0xffca0064 32-bit
+ * CMCOR 0xffca0068 32-bit
+ */
+
 static unsigned long sh_cmt_read16(void __iomem *base, unsigned long offs)
 {
 	return ioread16(base + (offs << 1));
