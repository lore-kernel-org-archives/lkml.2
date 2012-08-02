Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2HBHEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:04:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45184 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab2HBHD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:03:59 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@avionic-design.de, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH] pwm: Add missing static storage class specifiers in core.c file
Date: Thu,  2 Aug 2012 12:32:42 +0530
Message-Id: <1343890962-25467-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warnings:
drivers/pwm/core.c:152:6: warning:
symbol 'of_pwmchip_add' was not declared. Should it be static?
drivers/pwm/core.c:165:6: warning:
symbol 'of_pwmchip_remove' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pwm/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index ecb7690..4a8bdfa 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -149,7 +149,7 @@ static struct pwm_device *of_pwm_simple_xlate(struct pwm_chip *pc,
 	return pwm;
 }
 
-void of_pwmchip_add(struct pwm_chip *chip)
+static void of_pwmchip_add(struct pwm_chip *chip)
 {
 	if (!chip->dev || !chip->dev->of_node)
 		return;
@@ -162,7 +162,7 @@ void of_pwmchip_add(struct pwm_chip *chip)
 	of_node_get(chip->dev->of_node);
 }
 
-void of_pwmchip_remove(struct pwm_chip *chip)
+static void of_pwmchip_remove(struct pwm_chip *chip)
 {
 	if (chip->dev && chip->dev->of_node)
 		of_node_put(chip->dev->of_node);
-- 
1.7.4.1

