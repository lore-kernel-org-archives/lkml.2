Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2FFOcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:32:19 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56034 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756146Ab2FFOcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:32:17 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2012 10:32:05 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAMFmz09bdWOb/2dsb2JhbABFhU6uZ4EHghkBBSMECwFGECUCJgICVwcSiA+kSZJggSOOfIESA5Udj3qCYg
X-IronPort-AV: E=Sophos;i="4.75,724,1330902000"; 
   d="scan'208";a="999999593"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 4/4] Staging: xgifb: disable pci device on pci remove function.
Date: Wed,  6 Jun 2012 16:22:07 +0200
Message-Id: <1338992527-5659-4-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338992527-5659-1-git-send-email-magomez@igalia.com>
References: <1338992527-5659-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 438781f..033463d 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2297,6 +2297,7 @@ static void __devexit xgifb_remove(struct pci_dev *pdev)
 	iounmap(xgifb_info->video_vbase);
 	release_mem_region(xgifb_info->mmio_base, xgifb_info->mmio_size);
 	release_mem_region(xgifb_info->video_base, xgifb_info->video_size);
+	pci_disable_device(pdev);
 	framebuffer_release(fb_info);
 	pci_set_drvdata(pdev, NULL);
 }
-- 
1.7.9.5

