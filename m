Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab0GLWuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:50:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56309 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab0GLWuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:50:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Vefxbc8rrZU5wfMXnvAVqs2SV0MlG23lhowX9bXUVUfDxSBF3K2/oVKXTf9EZoSPo7
         GNhMMCiTXl2ZZFNO5KhXLIP5CUzoWd1seC2S3K+hvtadTN1QXEw7L91mYl9+Q37OKt35
         PaBWNqLkucxDe50NdEUuKn553wJj7KuLGKiYM=
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>, linux-kernel@vger.kernel.org,
        Roel Van Nyen <roel.vannyen@gmail.com>
Subject: [PATCH] Staging: vt6656: Remove the ULONG_PTR and DWORD_PTR defines from ttype.h
Date: Tue, 13 Jul 2010 00:49:57 +0200
Message-Id: <1278974997-27141-1-git-send-email-roel.vannyen@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the ULONG and DWORD PTR defines from ttype.h

Signed-of-by: Roel Van Nyen <roel.vannyen@gmail.com>
---
 drivers/staging/vt6656/bssdb.c |    8 ++++----
 drivers/staging/vt6656/ttype.h |    3 ---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 830dd23..0b8584b 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -469,7 +469,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 	unsigned int uLen = pRSNWPA->len + 2;
 
 	if (uLen <= (uIELength -
-		     (unsigned int) (ULONG_PTR) ((PBYTE) pRSNWPA - pbyIEs))) {
+		     (unsigned int) (unsigned long) ((PBYTE) pRSNWPA - pbyIEs))) {
 		pBSSList->wWPALen = uLen;
 		memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
 		WPA_ParseRSN(pBSSList, pRSNWPA);
@@ -482,7 +482,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 	unsigned int uLen = pRSN->len + 2;
 
 	if (uLen <= (uIELength -
-		     (unsigned int) (ULONG_PTR) ((PBYTE) pRSN - pbyIEs))) {
+		     (unsigned int) (unsigned long) ((PBYTE) pRSN - pbyIEs))) {
 		pBSSList->wRSNLen = uLen;
 		memcpy(pBSSList->byRSNIE, pRSN, uLen);
 		WPA2vParseRSN(pBSSList, pRSN);
@@ -674,7 +674,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
    if (pRSNWPA != NULL) {
 	unsigned int uLen = pRSNWPA->len + 2;
 	if (uLen <= (uIELength -
-		     (unsigned int) (ULONG_PTR) ((PBYTE) pRSNWPA - pbyIEs))) {
+		     (unsigned int) (unsigned long) ((PBYTE) pRSNWPA - pbyIEs))) {
 		pBSSList->wWPALen = uLen;
 		memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
 		WPA_ParseRSN(pBSSList, pRSNWPA);
@@ -686,7 +686,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
     if (pRSN != NULL) {
 	unsigned int uLen = pRSN->len + 2;
 	if (uLen <= (uIELength -
-			(unsigned int) (ULONG_PTR) ((PBYTE) pRSN - pbyIEs))) {
+			(unsigned int) (unsigned long) ((PBYTE) pRSN - pbyIEs))) {
 		pBSSList->wRSNLen = uLen;
 		memcpy(pBSSList->byRSNIE, pRSN, uLen);
 		WPA2vParseRSN(pBSSList, pRSN);
diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 3425773..42091c4 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -83,9 +83,6 @@ typedef UQuadWord       QWORD;          // 64-bit
 
 /****** Common pointer types ***********************************************/
 
-typedef unsigned long   ULONG_PTR;      // 32-bit
-typedef unsigned long   DWORD_PTR;      // 32-bit
-
 // boolean pointer
 typedef unsigned int *   PUINT;
 
-- 
1.7.0.4

