Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2G2LXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 07:23:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2G2LXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 07:23:48 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 1/2] pch_phub: fix sparse warning
Date: Sun, 29 Jul 2012 17:08:29 +0545
Message-Id: <1343561010-15800-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse warns about using 0 as NULL pointer,

drivers/misc/pch_phub.c:702:44: warning: Using plain integer as NULL pointer

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/misc/pch_phub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 9fbcacd..e2c066e 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -699,7 +699,7 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 	chip->pch_phub_base_address = pci_iomap(pdev, 1, 0);
 
 
-	if (chip->pch_phub_base_address == 0) {
+	if (chip->pch_phub_base_address == NULL) {
 		dev_err(&pdev->dev, "%s : pci_iomap FAILED", __func__);
 		ret = -ENOMEM;
 		goto err_pci_iomap;
-- 
1.7.9.5

