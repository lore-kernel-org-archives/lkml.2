Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032519Ab2CPH2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 03:28:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10317 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032330Ab2CPH2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 03:28:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 16 Mar 2012 00:28:41 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org, jedu@slimlogic.co.uk,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        gg@slimlogic.co.uk
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] mfd: Fix compilation error in TPS65910.h
Date: Fri, 16 Mar 2012 12:58:37 +0530
Message-Id: <1331882917-27960-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venu Byravarasu <vbyravarasu@nvidia.com>

Fix compilation error due to including TPS65910.h

'struct gpio_chip' is declared in include/asm-generic/gpio.h
which is included by include/linux/gpio.h.
However without including gpio.h, TPS65910.h declares
a member of this type as part of 'struct tps65910' declaration.

This causes compilation error, if gpio.h is not included
before including tps65910.h, in source files.

Hence fixing it.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 include/linux/mfd/tps65910.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 82b4c88..f226065 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -17,6 +17,8 @@
 #ifndef __LINUX_MFD_TPS65910_H
 #define __LINUX_MFD_TPS65910_H
 
+#include <linux/gpio.h>
+
 /* TPS chip id list */
 #define TPS65910			0
 #define TPS65911			1
-- 
1.7.1.1

