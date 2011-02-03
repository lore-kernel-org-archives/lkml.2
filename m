Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab1BCCP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:15:56 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36695 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab1BCCO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:14:56 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH 4/4] RTC: Fix minor compile warning
Date: Wed,  2 Feb 2011 18:14:43 -0800
Message-Id: <1296699283-6784-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
References: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two rtc drivers return values from void functions. This patch
fixes that.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-msm6242.c |    2 +-
 drivers/rtc/rtc-rp5c01.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index b2fff0c..6782062 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -82,7 +82,7 @@ static inline unsigned int msm6242_read(struct msm6242_priv *priv,
 static inline void msm6242_write(struct msm6242_priv *priv, unsigned int val,
 				unsigned int reg)
 {
-	return __raw_writel(val, &priv->regs[reg]);
+	__raw_writel(val, &priv->regs[reg]);
 }
 
 static inline void msm6242_set(struct msm6242_priv *priv, unsigned int val,
diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
index 36eb661..694da39 100644
--- a/drivers/rtc/rtc-rp5c01.c
+++ b/drivers/rtc/rtc-rp5c01.c
@@ -76,7 +76,7 @@ static inline unsigned int rp5c01_read(struct rp5c01_priv *priv,
 static inline void rp5c01_write(struct rp5c01_priv *priv, unsigned int val,
 				unsigned int reg)
 {
-	return __raw_writel(val, &priv->regs[reg]);
+	__raw_writel(val, &priv->regs[reg]);
 }
 
 static void rp5c01_lock(struct rp5c01_priv *priv)
-- 
1.7.3.2.146.gca209

