Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1HQRMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:12:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61506 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1HQRFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:05:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110807010"
Message-Id: <20110817163520.622136231@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:35:05 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch 08/36] Hexagon: Add delay functions
References: <20110817163457.878854582@codeaurora.org>
Content-Disposition: inline; filename=delay.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/include/asm/delay.h |   30 ++++++++++++++++++++++++++++++
 arch/hexagon/kernel/delay.S      |   30 ++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/delay.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/delay.h	2011-07-20 15:19:37.745153209 -0500
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_DELAY_H
+#define _ASM_DELAY_H
+
+#include <asm/param.h>
+
+extern void __udelay(unsigned long usecs);
+
+#define udelay(usecs) __udelay((usecs))
+
+extern void __delay(unsigned long loops);
+
+#endif /* _ASM_DELAY_H */
Index: linux-hexagon-kernel/arch/hexagon/kernel/delay.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/delay.S	2011-07-20 15:19:37.745153209 -0500
@@ -0,0 +1,30 @@
+/*
+ * __delay loop implementation for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/linkage.h>
+#include <asm/hexagon_vm.h>
+
+ENTRY(__delay)
+	loop0(1f,r0)
+1:
+	{
+		nop
+	}:endloop0
+	jumpr	R31

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

