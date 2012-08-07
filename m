Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab2HGT6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:58:17 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49934 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab2HGT6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:58:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        J Freyensee <james_p_freyensee@linux.intel.com>
Subject: [PATCH 06/41] misc: pti, stop using iomap's unmap on ioremap space
Date: Tue,  7 Aug 2012 21:47:31 +0200
Message-Id: <1344368886-24033-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ioremap space is different to iomap. ->probe function uses ioremap,
but ->remove calls pci_iounmap. That one is illegal. Fix that by using
iounmap.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 88da085e..3bfc8e3 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -402,7 +402,7 @@ static void __devexit pti_pci_remove(struct pci_dev *pdev)
 {
 	struct pti_dev *drv_data = pci_get_drvdata(pdev);
 
-	pci_iounmap(pdev, drv_data->pti_ioaddr);
+	iounmap(drv_data->pti_ioaddr);
 	pci_set_drvdata(pdev, NULL);
 	kfree(drv_data);
 	pci_release_region(pdev, 1);
-- 
1.7.10.4


