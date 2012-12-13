Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2LMOGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:06:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44411 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab2LMOGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 094/241] i2c-mux-pinctrl: Fix probe error path
Date: Thu, 13 Dec 2012 11:57:39 -0200
Message-Id: <1355407206-17100-95-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit aa1e3e81e75ceb3d977c3292cefafcd5179eb8b8 upstream.

When allocating the memory for i2c busses, the code checked the wrong
variable and thus never detected if there was a memory error.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/i2c/muxes/i2c-mux-pinctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index 46a6697..c524018 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -169,7 +169,7 @@ static int __devinit i2c_mux_pinctrl_probe(struct platform_device *pdev)
 	mux->busses = devm_kzalloc(&pdev->dev,
 				   sizeof(mux->busses) * mux->pdata->bus_count,
 				   GFP_KERNEL);
-	if (!mux->states) {
+	if (!mux->busses) {
 		dev_err(&pdev->dev, "Cannot allocate busses\n");
 		ret = -ENOMEM;
 		goto err;
-- 
1.7.9.5

