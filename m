Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2HWHCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:02:05 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11637 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2HWHCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:02:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 23 Aug 2012 00:02:02 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] mfd: rc5t583: Fix warning messages
Date: Thu, 23 Aug 2012 12:21:16 +0530
Message-ID: <1345704676-25778-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two variables named master_int and sleepseq_val, were just
declared without initialization. Pointers to these variables
were passed to mfd read function. After that these variables
were used for some of the logical operations.

Though logically there is nothing wrong, compiler is complaining
that the variables may be used uninitialized.

Hence fixing these warning messages by initializing them.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/mfd/rc5t583-irq.c |    2 +-
 drivers/mfd/rc5t583.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rc5t583-irq.c b/drivers/mfd/rc5t583-irq.c
index fa6f80f..fe00cdd 100644
--- a/drivers/mfd/rc5t583-irq.c
+++ b/drivers/mfd/rc5t583-irq.c
@@ -255,7 +255,7 @@ static irqreturn_t rc5t583_irq(int irq, void *data)
 {
 	struct rc5t583 *rc5t583 = data;
 	uint8_t int_sts[RC5T583_MAX_INTERRUPT_MASK_REGS];
-	uint8_t master_int;
+	uint8_t master_int = 0;
 	int i;
 	int ret;
 	unsigned int rtc_int_sts = 0;
diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index cdc1df7..ce7c1c9 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -85,7 +85,7 @@ static int __rc5t583_set_ext_pwrreq1_control(struct device *dev,
 	int id, int ext_pwr, int slots)
 {
 	int ret;
-	uint8_t sleepseq_val;
+	uint8_t sleepseq_val = 0;
 	unsigned int en_bit;
 	unsigned int slot_bit;
 
-- 
1.7.1.1

