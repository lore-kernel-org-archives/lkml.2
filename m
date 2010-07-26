Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0GZCle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 22:41:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46162 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab0GZCld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 22:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=IKRNv1tygJOK1CWxTd2/s8MJ/bYDPME4/HWHeWXM5/+DCz+gePkjVgRMZGVfAXXwRZ
         GeE/jsILV/a40jpBQUzPFTmYW66Qo2/vzDgE91oJVZN8ENOWISQU6RnBavtDm9zzQviS
         /BTik6DgyiQVidJqpi9wV1ikaxS1t9yre1NBk=
Subject: [PATCH] wm8350-regulator: fix wm8350_register_regulator error
	handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain
Date: Mon, 26 Jul 2010 10:41:58 +0800
Message-Id: <1280112118.14256.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of platform_device_add() fail, we should call
platform_device_put() instead of platform_device_del()

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 723cd1f..0e6ed7d 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1495,7 +1495,7 @@ int wm8350_register_regulator(struct wm8350 *wm8350, int reg,
 	if (ret != 0) {
 		dev_err(wm8350->dev, "Failed to register regulator %d: %d\n",
 			reg, ret);
-		platform_device_del(pdev);
+		platform_device_put(pdev);
 		wm8350->pmic.pdev[reg] = NULL;
 	}
 
-- 
1.5.4.3



