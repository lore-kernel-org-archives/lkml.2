Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab1DNScQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:32:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:37571 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab1DNRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 022/209] i2c-pca-platform: Change device name of request_irq
Date: Thu, 14 Apr 2011 13:40:52 -0400
Message-Id: <1302803039-9400-23-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 323584436db0cb05286425d4dfd9516fce88487f upstream.

i2c->adap.name shouldn't be used in request_irq.
Instead the driver name "i2c-pca-platform" should be used.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/i2c/busses/i2c-pca-platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index 1d8c208..fd295dd 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -224,7 +224,7 @@ static int __devinit i2c_pca_pf_probe(struct platform_device *pdev)
 
 	if (irq) {
 		ret = request_irq(irq, i2c_pca_pf_handler,
-			IRQF_TRIGGER_FALLING, i2c->adap.name, i2c);
+			IRQF_TRIGGER_FALLING, pdev->name, i2c);
 		if (ret)
 			goto e_reqirq;
 	}
-- 
1.7.4.4

