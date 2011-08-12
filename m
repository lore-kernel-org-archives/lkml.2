Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1HLI3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:29:12 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:41497 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944Ab1HLI3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:29:07 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Sebastian Rasmussen <sebastian.rasmussen@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 10/23] mfd/db8500-prcmu: reset code retrieval
Date: Fri, 12 Aug 2011 10:28:53 +0200
Message-ID: <1313137733-30914-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Rasmussen <sebastian.rasmussen@stericsson.com>

This implements the reset code retrieval function so we can
ipso facto get to know how the system was reset.

Signed-off-by: Sebastian Rasmussen <sebastian.rasmussen@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index cb58e44..6fd4e29 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1836,6 +1836,17 @@ void db8500_prcmu_system_reset(u16 reset_code)
 }
 
 /**
+ * db8500_prcmu_get_reset_code - Retrieve SW reset reason code
+ *
+ * Retrieves the reset reason code stored by prcmu_system_reset() before
+ * last restart.
+ */
+u16 db8500_prcmu_get_reset_code(void)
+{
+	return readw(tcdm_base + PRCM_SW_RST_REASON);
+}
+
+/**
  * prcmu_reset_modem - ask the PRCMU to reset modem
  */
 void prcmu_modem_reset(void)
-- 
1.7.3.2

