Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab2KPG5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:57:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:38824 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2KPG5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:13 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 05/14] [media] atmel-isi: Update error check for unsigned variables
Date: Fri, 16 Nov 2012 12:20:37 +0530
Message-Id: <1353048646-10935-6-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking '< 0' for unsigned variables always returns false. For error
codes, use IS_ERR_VALUE() instead.

CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/media/platform/soc_camera/atmel-isi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 6274a91..5bd65df 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -1020,7 +1020,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
+	if (IS_ERR_VALUE(irq)) {
 		ret = irq;
 		goto err_req_irq;
 	}
-- 
1.7.4.1

