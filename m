Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2KHOiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:38:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45640 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab2KHOiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:38:06 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: akpm@linux-foundation.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        a.zummo@towertech.it, spear-devel@list.st.com,
        Deepak Sikri <deepak.sikri@st.com>
Subject: [PATCH 3/3] rtc: rtc-spear: Provide flag for no support of UIE mode
Date: Thu,  8 Nov 2012 20:07:41 +0530
Message-Id: <c1177da521b7b44c7641b2806c580998d66b1be5.1352385320.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
References: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
In-Reply-To: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
References: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Sikri <deepak.sikri@st.com>

The applciations can set the RTC hardware to trigger interrupts in one
of three modes:
    * AIE: Alarm interrupt
    * UIE: Update interrupt (ie: once per second)
    * PIE: Periodic interrupt (sub-second irqs)

The above defined 3 modes are to be supported in the RTC HW in form of
interrupts. The SPEAr RTC hardware does not support the later two modes.

There have been refinements in the RTC core in mainline related to
use of timer queue infrastructure to manage events in RTC. Please refer
the below mentioned patch for details:
	* RTC: Rework RTC code to use timerqueue for events
	* SHA ID: 6610e0893b8bc6f59b14fed7f089c5997f035f88

There have been provisions added to support hardware that do not have
support the UIE mode. Please refer the following patch.
	* rtc: Provide flag for rtc devices that don't support UIE
	* SHA ID: 4a649903f91232d02284d53724b0a45728111767

The patch makes use of the provision defined in the above patch to
update the hardware status of UIE mode.

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
---
 drivers/rtc/rtc-spear.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index 990de02..0c4805c 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -417,6 +417,8 @@ static int __devinit spear_rtc_probe(struct platform_device *pdev)
 		goto err_disable_clock;
 	}
 
+	config->rtc->uie_unsupported = 1;
+
 	if (!device_can_wakeup(&pdev->dev))
 		device_init_wakeup(&pdev->dev, 1);
 
-- 
1.7.12.rc2.18.g61b472e

