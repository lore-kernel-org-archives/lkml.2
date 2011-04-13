Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab1DMM0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:26:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40287 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab1DMMZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:25:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6314"; a="85339906"
From: Mohan Pallaka <mpallaka@codeaurora.org>
To: dmitry.torokhov@gmail.com
Cc: Mohan Pallaka <mpallaka@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.intradead.org,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH 1/2] pwm: Add __weak attributed functions for pwm operations
Date: Wed, 13 Apr 2011 17:55:32 +0530
Message-Id: <1302697533-20456-2-git-send-email-mpallaka@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1302697533-20456-1-git-send-email-mpallaka@codeaurora.org>
References: <1302697533-20456-1-git-send-email-mpallaka@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For chip drivers that support both pwm and non-pwm modes
would encounter compilation errors if the platform doesn't
have support for pwm though the chip is programmed to work
in non-pwm mode. Add __weak attributed pwm functions to avoid
compilation issues in these scenarios.

Change-Id: Ia507bf659d4d67d71f135012e7d919aca6c45c6c
Signed-off-by: Mohan Pallaka <mpallaka@codeaurora.org>
---
 include/linux/pwm.h |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 7c77575..3a8c3df 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -3,29 +3,40 @@
 
 struct pwm_device;
 
+/* Add __weak functions to support PWM */
+
 /*
  * pwm_request - request a PWM device
  */
-struct pwm_device *pwm_request(int pwm_id, const char *label);
+struct pwm_device __weak *pwm_request(int pwm_id, const char *label)
+{
+	return NULL;
+}
 
 /*
  * pwm_free - free a PWM device
  */
-void pwm_free(struct pwm_device *pwm);
+void __weak pwm_free(struct pwm_device *pwm) { }
 
 /*
  * pwm_config - change a PWM device configuration
  */
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
+int __weak pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	return -ENODEV;
+}
 
 /*
  * pwm_enable - start a PWM output toggling
  */
-int pwm_enable(struct pwm_device *pwm);
+int __weak pwm_enable(struct pwm_device *pwm)
+{
+	return -EINVAL;
+}
 
 /*
  * pwm_disable - stop a PWM output toggling
  */
-void pwm_disable(struct pwm_device *pwm);
+void __weak pwm_disable(struct pwm_device *pwm) { }
 
 #endif /* __LINUX_PWM_H */
-- 
1.7.1.1

