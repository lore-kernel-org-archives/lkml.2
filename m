Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab2KILwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:52:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56471 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2KILwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:52:32 -0500
Message-ID: <1352461942.9150.1.camel@phoenix>
Subject: [PATCH] pwm: spear: Staticize spear_pwm_config()
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.com>, linux-kernel@vger.kernel.org
Date: Fri, 09 Nov 2012 19:52:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spear_pwm_config() is not referenced outside of this file, make it static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-spear.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 6a8fd9b..83b21d9 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -76,8 +76,8 @@ static inline void spear_pwm_writel(struct spear_pwm_chip *chip,
 	writel_relaxed(val, chip->mmio_base + (num << 4) + offset);
 }
 
-int spear_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm, int duty_ns,
-		     int period_ns)
+static int spear_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			    int duty_ns, int period_ns)
 {
 	struct spear_pwm_chip *pc = to_spear_pwm_chip(chip);
 	u64 val, div, clk_rate;
-- 
1.7.9.5



