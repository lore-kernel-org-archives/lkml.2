Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab2KSFCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:02:10 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:33885 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2KSFCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:02:08 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, kgene.kim@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/1] pinctrl: Samsung: Do not initialise statics to 0
Date: Mon, 19 Nov 2012 10:26:01 +0530
Message-Id: <1353300961-22632-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static variables are initialised to 0 by GCC.
Fixes the following checkpatch error:
ERROR: do not initialise statics to 0 or NULL
FILE: pinctrl/pinctrl-samsung.c:50:
static unsigned int pin_base = 0;

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 81c9896..36f8875 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -47,7 +47,7 @@ struct pin_config {
 	{ "samsung,pin-pud-pdn", PINCFG_TYPE_PUD_PDN },
 };
 
-static unsigned int pin_base = 0;
+static unsigned int pin_base;
 
 static inline struct samsung_pin_bank *gc_to_pin_bank(struct gpio_chip *gc)
 {
-- 
1.7.4.1

