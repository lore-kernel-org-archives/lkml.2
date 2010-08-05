Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab0HEKjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:39:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58370 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab0HEKjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:39:52 -0400
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Sandeep Paulraj <s-paulraj@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-mtd@lists.infradead.org
Subject: [PATCH] atmel_nand: Fix warning: 'part_probes' defined but not used
Date: Thu,  5 Aug 2010 12:38:41 +0200
Message-Id: <1281004721-397-1-git-send-email-biessmann@corscience.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279099026-24298-1-git-send-email-biessmann@corscience.de>
References: <1279099026-24298-1-git-send-email-biessmann@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:/gTI31CubP3Qpca37LJyX8++C++kF/KrGPbI00913y5
 oF5DWMXr7p6rJ1voDqySi8CLG0X9rG3RF/HKRoiqaSiMDvRXyi
 Qlume5LuRBQOh00WnmcUXdddqst8fb5EjWJW6iQLJzIE6aowB7
 /XG58LUOdDEpIbq0nmEsAi9p1EYzf6v3vAWVcjB2g7JTYG9zAa
 veJc/Qi6QAe/CelSIrU8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes

drivers/mtd/nand/atmel_nand.c:372: warning: 'part_probes' defined but not used

which is issued when CONFIG_MTD_PARTITIONS is defined but
CONFIG_MTD_CMDLINE_PARTS not.

Signed-off-by: Andreas Bießmann <biessmann@corscience.de>
---
 Resent this patch as a trivial one cause it does only fix a warning which is
 seen in very rare cases. There is no functionality change here! I think this
 is the definition of a trivial patch.

 In addition no one has commented my last submission of this patch.

 drivers/mtd/nand/atmel_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 04d3088..ccce0f0 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -364,7 +364,7 @@ static void atmel_nand_hwctl(struct mtd_info *mtd, int mode)
 	}
 }
 
-#ifdef CONFIG_MTD_PARTITIONS
+#ifdef CONFIG_MTD_CMDLINE_PARTS
 static const char *part_probes[] = { "cmdlinepart", NULL };
 #endif
 
-- 
1.7.1

