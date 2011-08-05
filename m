Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855Ab1HEEFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 00:05:08 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26027 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698Ab1HEEFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 00:05:04 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 1/3] gpio-ml-ioh: Delete unnecessary code
Date: Fri,  5 Aug 2011 13:04:20 +0900
Message-Id: <1312517062-5582-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This register restore processing is unnecessary in suspend processing.
(The restore processing is already in resume processing)

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/gpio-ml-ioh.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index a9016f5..655e55c 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -284,7 +284,6 @@ static int ioh_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct ioh_gpio *chip = pci_get_drvdata(pdev);
 
 	ioh_gpio_save_reg_conf(chip);
-	ioh_gpio_restore_reg_conf(chip);
 
 	ret = pci_save_state(pdev);
 	if (ret) {
-- 
1.7.4.4

