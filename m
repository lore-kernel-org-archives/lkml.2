Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab0C2MIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:08:46 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:38546 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab0C2MIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Cl0ciKmgmSOSQCl3hWP0zfxUZYLf1CWOyv2NC3tC4VEzg/QNRWb1lXJ3VNGSjXHfrq
         cjXwkCnBr4/qjuq4rGvYFJ2W/Y3ogqlYu93RCTbWDcrW3dwtEyrFj+mEnK5flysXJ/Sd
         GSls/2GQHqhWaWpu3UH+yNs8geKgD9Q+Xohs0=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 7/7] staging: vt6656: tether.c: Fixed coding style issues
Date: Mon, 29 Mar 2010 23:28:33 +1100
Message-Id: <1269865713-17072-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some indentation and spacing issues.
Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/vt6656/tether.c |   45 +++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/tether.c b/drivers/staging/vt6656/tether.c
index c90b469..ab1368a 100644
--- a/drivers/staging/vt6656/tether.c
+++ b/drivers/staging/vt6656/tether.c
@@ -61,25 +61,25 @@
  * Return Value: Hash value
  *
  */
-BYTE ETHbyGetHashIndexByCrc32 (PBYTE pbyMultiAddr)
+BYTE ETHbyGetHashIndexByCrc32(PBYTE pbyMultiAddr)
 {
-    int     ii;
-    BYTE    byTmpHash;
-    BYTE    byHash = 0;
+	int     ii;
+	BYTE    byTmpHash;
+	BYTE    byHash = 0;
 
-    // get the least 6-bits from CRC generator
-    byTmpHash = (BYTE)(CRCdwCrc32(pbyMultiAddr, U_ETHER_ADDR_LEN,
-            0xFFFFFFFFL) & 0x3F);
-    // reverse most bit to least bit
-    for (ii = 0; ii < (sizeof(byTmpHash) * 8); ii++) {
-        byHash <<= 1;
-        if (byTmpHash & 0x01)
-            byHash |= 1;
-        byTmpHash >>= 1;
-    }
+	/* get the least 6-bits from CRC generator */
+	byTmpHash = (BYTE)(CRCdwCrc32(pbyMultiAddr, U_ETHER_ADDR_LEN,
+			0xFFFFFFFFL) & 0x3F);
+	/* reverse most bit to least bit */
+	for (ii = 0; ii < (sizeof(byTmpHash) * 8); ii++) {
+		byHash <<= 1;
+		if (byTmpHash & 0x01)
+			byHash |= 1;
+		byTmpHash >>= 1;
+	}
 
-    // adjust 6-bits to the right most
-    return (byHash >> 2);
+	/* adjust 6-bits to the right most */
+	return byHash >> 2;
 }
 
 
@@ -96,14 +96,13 @@ BYTE ETHbyGetHashIndexByCrc32 (PBYTE pbyMultiAddr)
  * Return Value: TRUE if ok; FALSE if error.
  *
  */
-BOOL ETHbIsBufferCrc32Ok (PBYTE pbyBuffer, UINT cbFrameLength)
+BOOL ETHbIsBufferCrc32Ok(PBYTE pbyBuffer, UINT cbFrameLength)
 {
-    DWORD dwCRC;
+	DWORD dwCRC;
 
-    dwCRC = CRCdwGetCrc32(pbyBuffer, cbFrameLength - 4);
-    if (cpu_to_le32(*((PDWORD)(pbyBuffer + cbFrameLength - 4))) != dwCRC) {
-        return FALSE;
-    }
-    return TRUE;
+	dwCRC = CRCdwGetCrc32(pbyBuffer, cbFrameLength - 4);
+	if (cpu_to_le32(*((PDWORD)(pbyBuffer + cbFrameLength - 4))) != dwCRC)
+		return FALSE;
+	return TRUE;
 }
 
-- 
1.6.3.3

