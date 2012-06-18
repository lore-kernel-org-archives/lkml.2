Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2FRRra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:47:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45846 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2FRRr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:47:29 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] pinctrl/pinctrl-u300: remove unused variable i
Date: Mon, 18 Jun 2012 23:17:18 +0530
Message-Id: <1340041638-30233-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the unused variable warning was thrown when compiled using the
gcc for ARM (arm-linux-gnueabihf-gcc) with u300_defconfig selected,

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- u300_defconfig

and then

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-

gives the following warn,

drivers/pinctrl/pinctrl-u300.c: In function ‘u300_pmx_remove’:
drivers/pinctrl/pinctrl-u300.c:1178:6: warning: unused variable ‘i’ [-Wunused-variable]

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/pinctrl/pinctrl-u300.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 49b91c2..2ba13c5 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1175,7 +1175,6 @@ out_no_resource:
 static int __devexit u300_pmx_remove(struct platform_device *pdev)
 {
 	struct u300_pmx *upmx = platform_get_drvdata(pdev);
-	int i;
 
 	pinctrl_unregister(upmx->pctl);
 	iounmap(upmx->virtbase);
-- 
1.7.9.5

