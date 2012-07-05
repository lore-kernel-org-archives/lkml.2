Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab2GENGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:06:41 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63940 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab2GENGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:06:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/9] pinctrl: pinctrl-nomadik: Fix possible memory leak
Date: Thu,  5 Jul 2012 14:06:04 +0100
Message-Id: <1341493572-29735-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the Nomadik Pin Control driver is continuously bound and unbound
from the same device a number of times the kzalloc() will leak
memory. Replacing it with devm_kzalloc() will ensure memory is
freed automatically in the event of failure and unbinding.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 3e7e47d..af0389f 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1194,7 +1194,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	}
 
 	if (np) {
-		pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+		pdata = devm_kzalloc(&dev->dev, sizeof(*pdata), GFP_KERNEL);
 		if (!pdata)
 			return -ENOMEM;
 
-- 
1.7.9.5

