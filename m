Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab1DVGQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 02:16:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17701 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1DVGQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 02:16:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6323"; a="87265120"
From: Willie Ruan <wruan@codeaurora.org>
To: sameo@linux.intel.com
Cc: Willie Ruan <wruan@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: pm8921-core: add pwm device for PM8921
Date: Thu, 21 Apr 2011 23:15:52 -0700
Message-Id: <1303452952-20499-2-git-send-email-wruan@codeaurora.org>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1303452952-20499-1-git-send-email-wruan@codeaurora.org>
References: <1303452952-20499-1-git-send-email-wruan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qualcomm PM8921 has a PWM module which can output 8 channels
of PWM signals.

Signed-off-by: Willie Ruan <wruan@codeaurora.org>
---
 drivers/mfd/pm8921-core.c         |   11 +++++++++++
 include/linux/mfd/pm8xxx/pm8921.h |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 2fbd42d..47b1189 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -107,6 +107,11 @@ static const struct resource mpp_cell_resources[] __devinitconst = {
 	},
 };
 
+static struct mfd_cell pwm_cell __devinitdata = {
+	.name           = PM8XXX_PWM_DEV_NAME,
+	.id             = -1,
+};
+
 static struct mfd_cell mpp_cell __devinitdata = {
 	.name		= PM8XXX_MPP_DEV_NAME,
 	.id		= -1,
@@ -160,6 +165,12 @@ static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
 		}
 	}
 
+	ret = mfd_add_devices(pmic->dev, 0, &pwm_cell, 1, NULL, 0);
+	if (ret) {
+		pr_err("Failed to add pwm subdevice ret=%d\n", ret);
+		goto bail;
+	}
+
 	return 0;
 bail:
 	if (pmic->irq_chip) {
diff --git a/include/linux/mfd/pm8xxx/pm8921.h b/include/linux/mfd/pm8xxx/pm8921.h
index 19cffb2..8132325 100644
--- a/include/linux/mfd/pm8xxx/pm8921.h
+++ b/include/linux/mfd/pm8xxx/pm8921.h
@@ -22,6 +22,7 @@
 #include <linux/mfd/pm8xxx/irq.h>
 #include <linux/mfd/pm8xxx/gpio.h>
 #include <linux/mfd/pm8xxx/mpp.h>
+#include <linux/mfd/pm8xxx/pwm.h>
 
 #define PM8921_NR_IRQS		256
 
-- 
1.6.5.2

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
