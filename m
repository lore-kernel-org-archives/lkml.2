Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2KHOiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:38:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45640 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab2KHOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:37:59 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: akpm@linux-foundation.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        a.zummo@towertech.it, spear-devel@list.st.com,
        Deepak Sikri <deepak.sikri@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] rtc: rtc-spear: Add clk_{un}prepare() support
Date: Thu,  8 Nov 2012 20:07:40 +0530
Message-Id: <aa03a92d3a31afa4e6a392aa274c1ec5ee1ae959.1352385320.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
References: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
In-Reply-To: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
References: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Sikri <deepak.sikri@st.com>

clk_{un}prepare is mandatory for platforms using common clock framework. Because
for SPEAr we don't do anything in clk_{un}prepare() calls, just call them ones
in probe/remove.

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/rtc/rtc-spear.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index 480ecc3..990de02 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -401,7 +401,7 @@ static int __devinit spear_rtc_probe(struct platform_device *pdev)
 	if (IS_ERR(config->clk))
 		return PTR_ERR(config->clk);
 
-	status = clk_enable(config->clk);
+	status = clk_prepare_enable(config->clk);
 	if (status < 0)
 		return status;
 
@@ -424,7 +424,7 @@ static int __devinit spear_rtc_probe(struct platform_device *pdev)
 
 err_disable_clock:
 	platform_set_drvdata(pdev, NULL);
-	clk_disable(config->clk);
+	clk_disable_unprepare(config->clk);
 
 	return status;
 }
@@ -435,7 +435,7 @@ static int __devexit spear_rtc_remove(struct platform_device *pdev)
 
 	rtc_device_unregister(config->rtc);
 	spear_rtc_disable_interrupt(config);
-	clk_disable(config->clk);
+	clk_disable_unprepare(config->clk);
 	device_init_wakeup(&pdev->dev, 0);
 
 	return 0;
-- 
1.7.12.rc2.18.g61b472e

