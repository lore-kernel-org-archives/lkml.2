Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab2AZRIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:08:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2738 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2AZRHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:07:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Jan 2012 09:07:46 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/8] ARM: tegra: introduce support for reading chipid
Date: Thu, 26 Jan 2012 19:07:06 +0200
Message-Id: <1327597641-7519-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a function to read the Tegra chipid. This will be used by the SMP
code to distinguish between Tegra variants.

---

Should this be merged with the fuse reading code even though this is a
hardwired register, not a fuse based register?

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/chipid.h |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/chipid.h

diff --git a/arch/arm/mach-tegra/chipid.h b/arch/arm/mach-tegra/chipid.h
new file mode 100644
index 0000000..beb6a66
--- /dev/null
+++ b/arch/arm/mach-tegra/chipid.h
@@ -0,0 +1,38 @@
+/*
+ * arch/arm/mach-tegra/chipid.h
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __MACH_TEGRA_CHIPID_H
+#define __MACH_TEGRA_CHIPID_H
+
+#define APB_MISC_GP_HIDREV	0x804
+
+#define	TEGRA20			0x20
+#define	TEGRA30			0x30
+
+#ifndef __ASSEMBLY__
+
+#include <asm/io.h>
+
+static inline u32 tegra_get_chipid(void)
+{
+	return readl_relaxed(IO_ADDRESS(TEGRA_APB_MISC_BASE) +
+				APB_MISC_GP_HIDREV) >> 8 & 0xff;
+}
+
+#endif
+#endif
-- 
1.7.7.rc0.72.g4b5ea.dirty

