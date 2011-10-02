Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1JBUXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:23:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:59646 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1JBUXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:23:08 -0400
Date: Sun, 2 Oct 2011 23:22:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] pinctrl: double free on error path in pinctrl_register()
Message-ID: <20111002202255.GA6991@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E88C82B.0006:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is duplicated in the error handling after we go to out_err.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index f9263b2..8416a59 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -559,8 +559,6 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	ret = device_register(&pctldev->dev);
 	if (ret != 0) {
 		pr_err("error in device registration\n");
-		put_device(&pctldev->dev);
-		kfree(pctldev);
 		goto out_err;
 	}
 	dev_set_drvdata(&pctldev->dev, pctldev);
