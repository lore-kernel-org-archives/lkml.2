Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2GKGJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:09:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48904 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2GKGJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:09:27 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Lior Dotan <liodot@gmail.com>,
        Christopher Harrer <charrer@alacritech.com>
Subject: [PATCH V2] staging/slicoss: disable pci device at remove
Date: Wed, 11 Jul 2012 11:54:15 +0545
Message-Id: <1341986955-20020-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at probe we enabled the device, and we should disable it at remove.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---

changes v2:
	nothing, just a resend, incremented patch version count for maintainer to have notified the latest change easily.

 drivers/staging/slicoss/slicoss.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 785e4c5..56829fc 100644
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

