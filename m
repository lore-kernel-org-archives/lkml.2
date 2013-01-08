Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3AHOiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:38:46 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:40948 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab3AHOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:38:44 -0500
From: Laurent Navet <laurent.navet@gmail.com>
To: w.sang@pengutronix.de
Cc: ben-linux@fluff.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: i2c: muxes: fix sizeof(ptr)
Date: Tue,  8 Jan 2013 14:40:09 +0100
Message-Id: <1357652409-22907-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof when applied to a pointer typed expression gives the size of
the pointer

The semantic patch that makes this output is available
in scripts/coccinelle/misc/noderef.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/i2c/muxes/i2c-mux-pinctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index 7fa5b24..f958d0f 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -167,7 +167,7 @@ static int __devinit i2c_mux_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	mux->busses = devm_kzalloc(&pdev->dev,
-				   sizeof(mux->busses) * mux->pdata->bus_count,
+				   sizeof(*mux->busses) * mux->pdata->bus_count,
 				   GFP_KERNEL);
 	if (!mux->busses) {
 		dev_err(&pdev->dev, "Cannot allocate busses\n");
-- 
1.7.10.4

