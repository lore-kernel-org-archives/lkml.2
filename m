Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1LRXKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:10:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46918 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab1LRXKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:10:41 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 1/3] drivers: staging: vt6656: Remove not used returned data of function
Date: Sun, 18 Dec 2011 21:11:04 +0000
Message-Id: <1324242664-17892-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function always return TRUE, and it is not used by the funtions
who calls it.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/mac.c |    4 +---
 drivers/staging/vt6656/mac.h |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 26c19d1..3fc9911 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -133,10 +133,9 @@ void MACvWriteMultiAddr(PSDevice pDevice, unsigned int uByteIdx, BYTE byData)
  *  Out:
  *      none
  *
- * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL MACbShutdown (PSDevice pDevice)
+void MACbShutdown(PSDevice pDevice)
 {
     CONTROLnsRequestOutAsyn(pDevice,
                         MESSAGE_TYPE_MACSHUTDOWN,
@@ -145,7 +144,6 @@ BOOL MACbShutdown (PSDevice pDevice)
                         0,
                         NULL
                         );
-    return TRUE;
 }
 
 void MACvSetBBType(PSDevice pDevice,BYTE byType)
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 491ff5e..147ac50 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -422,7 +422,7 @@
 
 void MACvSetMultiAddrByHash(PSDevice pDevice, BYTE byHashIdx);
 void MACvWriteMultiAddr(PSDevice pDevice, unsigned int uByteIdx, BYTE byData);
-BOOL MACbShutdown(PSDevice pDevice);
+void MACbShutdown(PSDevice pDevice);
 void MACvSetBBType(PSDevice pDevice, BYTE byType);
 void MACvSetMISCFifo(PSDevice pDevice, WORD wOffset, DWORD dwData);
 void MACvDisableKeyEntry(PSDevice pDevice, unsigned int uEntryIdx);
-- 
1.7.4.4

