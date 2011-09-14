Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab1IQAqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:46:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5596 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594Ab1IQAqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:46:31 -0400
Message-Id: <093448$3hsttm@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6471"; a="119437238"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Wed, 14 Sep 2011 13:18:56 -0500
Subject: [PATCH v4 12/36] Hexagon: Export ksyms defined in assembly files.
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/kernel/hexagon_ksyms.c |   42 +++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/kernel/hexagon_ksyms.c

diff --git a/arch/hexagon/kernel/hexagon_ksyms.c b/arch/hexagon/kernel/hexagon_ksyms.c
new file mode 100644
index 0000000..3528d05
--- /dev/null
+++ b/arch/hexagon/kernel/hexagon_ksyms.c
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
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
