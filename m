Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2BPJLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:11:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59721 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab2BPJJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:45 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v5 14/27] mfd: twl-core.c: Fix the number of interrupts managed by twl4030
Date: Thu, 16 Feb 2012 02:09:15 -0700
Message-Id: <1329383368-12122-15-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Cousson <b-cousson@ti.com>

TWL4030 does handle 3 different interrupts ranges: 8 for the core, 8 for
the power events and 18 for the GPIOs.

Change the total number of interrupts managed by TWL4030 from 8 to 34.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/mfd/twl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 8ce3959..4967733 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -149,7 +149,7 @@
 
 #define TWL_MODULE_LAST TWL4030_MODULE_LAST
 
-#define TWL4030_NR_IRQS    8
+#define TWL4030_NR_IRQS    34 /* core:8, power:8, gpio: 18 */
 #define TWL6030_NR_IRQS    20
 
 /* Base Address defns for twl4030_map[] */
-- 
1.7.9

