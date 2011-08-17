Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1HQRMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:12:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61506 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab1HQRFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:05:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110807041"
Message-Id: <20110817163520.979569743@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:35:09 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>
Subject: [patch 12/36] Hexagon: Export ksyms defined in assembly files.
References: <20110817163457.878854582@codeaurora.org>
Content-Disposition: inline; filename=ksyms.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Linas Vepstas <linas@codeaurora.org>

---
 arch/hexagon/kernel/hexagon_ksyms.c |   42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/kernel/hexagon_ksyms.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/hexagon_ksyms.c	2011-07-20 15:19:38.815152873 -0500
@@ -0,0 +1,42 @@
+/*
+ * Export of symbols defined in assembly files and/or libgcc.
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
+#include <asm/hexagon_vm.h>
+#include <asm/uaccess.h>
+
+EXPORT_SYMBOL(__copy_from_user_hexagon);
+EXPORT_SYMBOL(__copy_to_user_hexagon);
+EXPORT_SYMBOL(__vmgetie);
+EXPORT_SYMBOL(__vmsetie);
+EXPORT_SYMBOL(memcpy);
+EXPORT_SYMBOL(memset);
+
+#define DECLARE_EXPORT(name)     \
+	extern void name(void); EXPORT_SYMBOL(name)
+
+/* Symbols found in libgcc that assorted kernel modules need */
+DECLARE_EXPORT(__hexagon_memcpy_likely_aligned_min32bytes_mult8bytes);
+
+DECLARE_EXPORT(__hexagon_divsi3);
+DECLARE_EXPORT(__hexagon_modsi3);
+DECLARE_EXPORT(__hexagon_udivsi3);
+DECLARE_EXPORT(__hexagon_umodsi3);
+
+

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

