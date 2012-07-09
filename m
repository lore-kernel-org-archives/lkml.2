Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab2GIRgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:36:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34376 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2GIRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:36:21 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lior Dotan <liodot@gmail.com>,
        Christopher Harrer <charrer@alacritech.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/3] staging/slicoss: disable pci device at remove
Date: Mon,  9 Jul 2012 23:04:19 +0530
Message-Id: <1341855260-9037-2-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341855260-9037-1-git-send-email-devendra.aaru@gmail.com>
References: <1341855260-9037-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at probe we enabled the device, and we should disable it at remove.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/slicoss/slicoss.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index a511a2b..5bd3825 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3234,6 +3234,7 @@ static void __devexit slic_entry_remove(struct pci_dev *pcidev)
 	}
 	free_netdev(dev);
 	pci_release_regions(pcidev);
+	pci_disable_device(pcidev);
 }
 
 static int slic_entry_halt(struct net_device *dev)
-- 
1.7.9.5

