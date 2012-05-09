Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257Ab2EIWfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:35:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50596 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab2EIWf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:35:29 -0400
From: mathieu.poirier@linaro.org
To: grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH] spi/topcliff: use correct __devexit_p annotation
Date: Wed,  9 May 2012 16:35:23 -0600
Message-Id: <1336602923-5724-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

__devexit functions are discarded when CONFIG_HOTPLUG
is not set, so the symbol needs to be referenced carefully.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/spi/spi-topcliff-pch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index ec47d3b..77c4562 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1779,7 +1779,7 @@ static struct pci_driver pch_spi_pcidev_driver = {
 	.name = "pch_spi",
 	.id_table = pch_spi_pcidev_id,
 	.probe = pch_spi_probe,
-	.remove = pch_spi_remove,
+	.remove = __devexit_p(pch_spi_remove),
 	.suspend = pch_spi_suspend,
 	.resume = pch_spi_resume,
 };
-- 
1.7.5.4

