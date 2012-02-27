Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2B0Twj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:52:39 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19403 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab2B0Twi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:52:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 27 Feb 2012 11:52:33 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] ARM: boot/compressed/misc.s: Include <linux/bug.h> to fix build break
Date: Mon, 27 Feb 2012 12:52:30 -0700
Message-ID: <1330372350-6432-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commmit cf86c17 "kernel.h: doesn't explicitly use bug.h, so don't include
it." caused the following build failure on ARM:

  CC      arch/arm/boot/compressed/misc.o
In file included from arch/arm/boot/compressed/misc.c:28:0:
arch/arm/mach-tegra/include/mach/uncompress.h: In function 'arch_decomp_setup':
arch/arm/mach-tegra/include/mach/uncompress.h:125:2: error: implicit declaration of function 'BUILD_BUG_ON_ZERO' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

Include <linux/bug.h> to fix that.

This should probably be squashed into commit a3a3a1a "bug.h: add include
of it to various implicit C users".

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/compressed/misc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 8e2a8fc..30055be 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -18,6 +18,7 @@
 
 unsigned int __machine_arch_type;
 
+#include <linux/bug.h>
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>
 #include <linux/linkage.h>
-- 
1.7.0.4

