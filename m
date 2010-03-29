Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0C2L1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:27:04 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:45917 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab0C2L1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:27:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SBhnmVoUXL43OIlWQEBMMc7f0CUAcO1H5jnZgIr67flEMokIRBWN76GwmK6KkGzg3C
         a8hQfsEMjtainDLdStXnKGIlvuJ432pnlHyt9hKyZTzRc+kPn6oe4EM7LJe1gNNiHvdK
         L0+UtJ3DSE7Nwbh6GHOrxaiZT30fycsuZxF7w=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 4/4] staging: vt6656: rc4.c: Fixed coding style issues
Date: Mon, 29 Mar 2010 22:26:46 +1100
Message-Id: <1269862006-16191-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced all indentation by spaces by tabs.
Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/vt6656/rc4.c |   78 +++++++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/vt6656/rc4.c b/drivers/staging/vt6656/rc4.c
index e6c6131..64c419d 100644
--- a/drivers/staging/vt6656/rc4.c
+++ b/drivers/staging/vt6656/rc4.c
@@ -34,54 +34,54 @@
 
 VOID rc4_init(PRC4Ext pRC4, PBYTE pbyKey, UINT cbKey_len)
 {
-    UINT  ust1, ust2;
-    UINT  keyindex;
-    UINT  stateindex;
-    PBYTE pbyst;
-    UINT  idx;
+	UINT  ust1, ust2;
+	UINT  keyindex;
+	UINT  stateindex;
+	PBYTE pbyst;
+	UINT  idx;
 
-    pbyst = pRC4->abystate;
-    pRC4->ux = 0;
-    pRC4->uy = 0;
-    for (idx = 0; idx < 256; idx++)
-        pbyst[idx] = (BYTE)idx;
-    keyindex = 0;
-    stateindex = 0;
-    for (idx = 0; idx < 256; idx++) {
-        ust1 = pbyst[idx];
-        stateindex = (stateindex + pbyKey[keyindex] + ust1) & 0xff;
-        ust2 = pbyst[stateindex];
-        pbyst[stateindex] = (BYTE)ust1;
-        pbyst[idx] = (BYTE)ust2;
-        if (++keyindex >= cbKey_len)
-            keyindex = 0;
-    }
+	pbyst = pRC4->abystate;
+	pRC4->ux = 0;
+	pRC4->uy = 0;
+	for (idx = 0; idx < 256; idx++)
+		pbyst[idx] = (BYTE)idx;
+	keyindex = 0;
+	stateindex = 0;
+	for (idx = 0; idx < 256; idx++) {
+		ust1 = pbyst[idx];
+		stateindex = (stateindex + pbyKey[keyindex] + ust1) & 0xff;
+		ust2 = pbyst[stateindex];
+		pbyst[stateindex] = (BYTE)ust1;
+		pbyst[idx] = (BYTE)ust2;
+		if (++keyindex >= cbKey_len)
+			keyindex = 0;
+	}
 }
 
 UINT rc4_byte(PRC4Ext pRC4)
 {
-    UINT ux;
-    UINT uy;
-    UINT ustx, usty;
-    PBYTE pbyst;
+	UINT ux;
+	UINT uy;
+	UINT ustx, usty;
+	PBYTE pbyst;
 
-    pbyst = pRC4->abystate;
-    ux = (pRC4->ux + 1) & 0xff;
-    ustx = pbyst[ux];
-    uy = (ustx + pRC4->uy) & 0xff;
-    usty = pbyst[uy];
-    pRC4->ux = ux;
-    pRC4->uy = uy;
-    pbyst[uy] = (BYTE)ustx;
-    pbyst[ux] = (BYTE)usty;
+	pbyst = pRC4->abystate;
+	ux = (pRC4->ux + 1) & 0xff;
+	ustx = pbyst[ux];
+	uy = (ustx + pRC4->uy) & 0xff;
+	usty = pbyst[uy];
+	pRC4->ux = ux;
+	pRC4->uy = uy;
+	pbyst[uy] = (BYTE)ustx;
+	pbyst[ux] = (BYTE)usty;
 
-    return pbyst[(ustx + usty) & 0xff];
+	return pbyst[(ustx + usty) & 0xff];
 }
 
 VOID rc4_encrypt(PRC4Ext pRC4, PBYTE pbyDest,
-                     PBYTE pbySrc, UINT cbData_len)
+			PBYTE pbySrc, UINT cbData_len)
 {
-    UINT ii;
-    for (ii = 0; ii < cbData_len; ii++)
-        pbyDest[ii] = (BYTE)(pbySrc[ii] ^ rc4_byte(pRC4));
+	UINT ii;
+	for (ii = 0; ii < cbData_len; ii++)
+		pbyDest[ii] = (BYTE)(pbySrc[ii] ^ rc4_byte(pRC4));
 }
-- 
1.6.3.3

