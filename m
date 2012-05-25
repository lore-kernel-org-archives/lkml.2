Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2EYIFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:05:51 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:31812 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755543Ab2EYIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:05:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIo8v09bdWOb/2dsb2JhbABEtRCBB4IWAQUnUhBRVwYTiBG7SJBHA5UYj3CCYg
X-IronPort-AV: E=Sophos;i="4.75,655,1330902000"; 
   d="scan'208";a="995215619"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] Staging: ipack/bridges/tpci200: avoid dereference of a freed tpci200->info
Date: Fri, 25 May 2012 10:03:04 +0200
Message-Id: <1337932985-10668-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337932985-10668-1-git-send-email-siglesias@igalia.com>
References: <1337932985-10668-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tpci200->info is used later when uninstalling the module. As there is another
kfree in the proper place, this patch removes the wrong one.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 6751625..e04cb8a 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -290,8 +290,6 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 	pci_disable_device(tpci200->info->pdev);
 	pci_dev_put(tpci200->info->pdev);
 
-	kfree(tpci200->info);
-
 	for (i = 0; i < TPCI200_NB_SLOT; i++) {
 		tpci200->slots[i].io_phys.address = NULL;
 		tpci200->slots[i].io_phys.size = 0;
-- 
1.7.10

