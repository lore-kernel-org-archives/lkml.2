Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504Ab1JaU2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 16:28:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54524 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709Ab1JaU2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 16:28:06 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: swarren@nvidia.com, linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATH v2 2/2] pinmux: Unify pin type from signed to unsigned.
Date: Mon, 31 Oct 2011 21:27:52 +0100
Message-Id: <1320092872-6120-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <CACRpkdZ1Y1sHh1oQKFVYUEftyZnJnuUGLmXUHg3vaZKbSfra2Q@mail.gmail.com>
References: <CACRpkdZ1Y1sHh1oQKFVYUEftyZnJnuUGLmXUHg3vaZKbSfra2Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/pinctrl/core.c |    2 +-
 drivers/pinctrl/core.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 423522d..18a7dda 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -87,7 +87,7 @@ struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
 	return found ? pctldev : NULL;
 }
 
-struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin)
+struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin)
 {
 	struct pin_desc *pindesc;
 	unsigned long flags;
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 472fa13..759dc1f 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -65,7 +65,7 @@ struct pin_desc {
 
 struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
 					     const char *dev_name);
-struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin);
+struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin);
 int pinctrl_get_device_gpio_range(unsigned gpio,
 				  struct pinctrl_dev **outdev,
 				  struct pinctrl_gpio_range **outrange);
-- 
1.7.5.4

