Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab1K3CSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:18:41 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50421 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab1K3CSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:18:37 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: forest@alittletooquiet.net, driver@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 1/5] staging: vt6656: main_usb.c: Use kzalloc instead kmalloc
Date: Wed, 30 Nov 2011 00:17:15 -0200
Message-Id: <1322619435-10034-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>

Cc: Greg kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: driver@driverdev.osuosl.org

---
 drivers/staging/vt6656/main_usb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 27521b6..201dd1d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -900,7 +900,7 @@ static BOOL device_alloc_bufs(PSDevice pDevice) {
     }
 
     // allocate rcb mem
-    pDevice->pRCBMem = kmalloc((sizeof(RCB) * pDevice->cbRD), GFP_KERNEL);
+	pDevice->pRCBMem = kzalloc((sizeof(RCB) * pDevice->cbRD), GFP_KERNEL);
     if (pDevice->pRCBMem == NULL) {
         DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s : alloc rx usb context failed\n", pDevice->dev->name);
         goto free_tx;
@@ -912,7 +912,6 @@ static BOOL device_alloc_bufs(PSDevice pDevice) {
     pDevice->FirstRecvMngList = NULL;
     pDevice->LastRecvMngList = NULL;
     pDevice->NumRecvFreeList = 0;
-    memset(pDevice->pRCBMem, 0, (sizeof(RCB) * pDevice->cbRD));
     pRCB = (PRCB) pDevice->pRCBMem;
 
     for (ii = 0; ii < pDevice->cbRD; ii++) {
-- 
1.7.4.4

