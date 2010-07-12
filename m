Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0GLW2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:28:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45463 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab0GLW2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z49qa92xmOEZDYJfYYU5n0lXxu/3e0nUx8IzB8f78/2NzRl5TmSGwxVNqYtUlVkLCg
         lmSOOw675s7XHMYM8qiyz76Xv88HzTgMzaOUXHySVo0Pw9Ytm1I0xruL7QhIePAjXshN
         lySPPaRxr/AnFvtFq93ZINh9pX6IZccizmaes=
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Roel Van Nyen <roel.vannyen@gmail.com>
Subject: [PATCH] Staging: vt6656: Remove PUINT from ttype.h
Date: Tue, 13 Jul 2010 00:28:02 +0200
Message-Id: <1278973682-25540-1-git-send-email-roel.vannyen@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove PUINT from ttype.h and change it to unsigned int *

Signed-of-by Roel Van Nyen <roel.vannyen@gmail.com>
---
 drivers/staging/vt6656/bssdb.c |    4 ++--
 drivers/staging/vt6656/bssdb.h |    4 ++--
 drivers/staging/vt6656/dpc.c   |    8 ++++----
 drivers/staging/vt6656/ttype.h |    1 -
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 830dd23..a417b7e 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -736,7 +736,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
 
 BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
 		       PBYTE abyDstAddr,
-		       PUINT puNodeIndex)
+		       unsigned int * puNodeIndex)
 {
     PSDevice        pDevice = (PSDevice)hDeviceContext;
     PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
@@ -768,7 +768,7 @@ BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
  *    None
  *
 -*/
-void BSSvCreateOneNode(void *hDeviceContext, PUINT puNodeIndex)
+void BSSvCreateOneNode(void *hDeviceContext, unsigned int * puNodeIndex)
 {
 
     PSDevice     pDevice = (PSDevice)hDeviceContext;
diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
index c3aaefe..e016fe7 100644
--- a/drivers/staging/vt6656/bssdb.h
+++ b/drivers/staging/vt6656/bssdb.h
@@ -278,9 +278,9 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
 
 BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
 		       PBYTE abyDstAddr,
-		       PUINT puNodeIndex);
+		       unsigned int * puNodeIndex);
 
-void BSSvCreateOneNode(void *hDeviceContext, PUINT puNodeIndex);
+void BSSvCreateOneNode(void *hDeviceContext, unsigned int * puNodeIndex);
 
 void BSSvUpdateAPNode(void *hDeviceContext,
 		      PWORD pwCapInfo,
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 81ce46f..8362272 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -80,7 +80,7 @@ static
 void
 s_vGetDASA(
       PBYTE pbyRxBufferAddr,
-     PUINT pcbHeaderSize,
+     unsigned int * pcbHeaderSize,
      PSEthernetHeader psEthHeader
     );
 
@@ -92,7 +92,7 @@ s_vProcessRxMACHeader (
       unsigned int cbPacketSize,
       BOOL bIsWEP,
       BOOL bExtIV,
-     PUINT pcbHeadSize
+     unsigned int * pcbHeadSize
     );
 
 static BOOL s_bAPModeRxCtl(
@@ -167,7 +167,7 @@ s_vProcessRxMACHeader (
       unsigned int cbPacketSize,
       BOOL bIsWEP,
       BOOL bExtIV,
-     PUINT pcbHeadSize
+     unsigned int * pcbHeadSize
     )
 {
     PBYTE           pbyRxBuffer;
@@ -261,7 +261,7 @@ static
 void
 s_vGetDASA (
       PBYTE pbyRxBufferAddr,
-     PUINT pcbHeaderSize,
+     unsigned int * pcbHeaderSize,
      PSEthernetHeader psEthHeader
     )
 {
diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 3425773..fd78135 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -87,7 +87,6 @@ typedef unsigned long   ULONG_PTR;      // 32-bit
 typedef unsigned long   DWORD_PTR;      // 32-bit
 
 // boolean pointer
-typedef unsigned int *   PUINT;
 
 typedef BYTE *           PBYTE;
 
-- 
1.7.0.4

