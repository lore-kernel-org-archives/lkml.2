Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab2GIReb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:34:31 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41295 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2GIRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:34:30 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lior Dotan <liodot@gmail.com>,
        Christopher Harrer <charrer@alacritech.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/3] staging/slicoss: remove not-needed ASSERT
Date: Mon,  9 Jul 2012 23:04:18 +0530
Message-Id: <1341855260-9037-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the private pointer is valid at the remove of driver, and remove wont' be called if probe fails, so no point for checking of ASSERT

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/slicoss/slicoss.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index d2b82a7..a511a2b 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3196,7 +3196,6 @@ static void __devexit slic_entry_remove(struct pci_dev *pcidev)
 	struct sliccard *card;
 	struct mcast_address *mcaddr, *mlist;
 
-	ASSERT(adapter);
 	slic_adapter_freeresources(adapter);
 	slic_unmap_mmio_space(adapter);
 	unregister_netdev(dev);
-- 
1.7.9.5

