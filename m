Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2JNPS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:18:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39383 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2JNPSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:18:54 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 1/4] Drivers: Staging: CSR: Fixed indentation problems on data_tx.c
Date: Mon, 15 Oct 2012 00:16:50 +0900
Message-Id: <1350227813-30880-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, the data_tx.c was indented with 4 spaces, so I fixed the
indentation using a single tab.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/data_tx.c |   58 ++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/csr/data_tx.c b/drivers/staging/csr/data_tx.c
index 8ed7a78..8af0358 100644
--- a/drivers/staging/csr/data_tx.c
+++ b/drivers/staging/csr/data_tx.c
@@ -15,36 +15,37 @@
 #include "csr_wifi_hip_unifi.h"
 #include "unifi_priv.h"
 
-int
-uf_verify_m4(unifi_priv_t *priv, const unsigned char *packet, unsigned int length)
-{
-    const unsigned char *p = packet;
-    u16 keyinfo;
+int uf_verify_m4 (unifi_priv_t *priv, const unsigned char *packet,
+	unsigned int length) {
+	const unsigned char *p = packet;
+	u16 keyinfo;
 
+	if (length < (4 + 5 + 8 + 32 + 16 + 8 + 8 + 16 + 1 + 8)) {
+		return 1;
+	}
 
-    if (length < (4 + 5 + 8 + 32 + 16 + 8 + 8 + 16 + 1 + 8)) {
-        return 1;
-    }
-
-    p += 8;
-    keyinfo = p[5] << 8 | p[6]; /* big-endian */
-    if (
-          (p[0] == 1 || p[0] == 2) /* protocol version 802.1X-2001 (WPA) or -2004 (WPA2) */ &&
-          p[1] == 3 /* EAPOL-Key */ &&
-          /* don't bother checking p[2] p[3] (hh ll, packet body length) */
-          (p[4] == 254 || p[4] == 2) /* descriptor type P802.1i-D3.0 (WPA) or 802.11i-2004 (WPA2) */ &&
-          ((keyinfo & 0x0007) == 1 || (keyinfo & 0x0007) == 2) /* key descriptor version */ &&
-         (keyinfo & ~0x0207U) == 0x0108 && /* key info for 4/4 or 4/2 -- ignore key desc version and sec bit (since varies in WPA 4/4) */
-          (p[4 + 5 + 8 + 32 + 16 + 8 + 8 + 16 + 0] == 0 && /* key data length (2 octets) 0 for 4/4 only */
-           p[4 + 5 + 8 + 32 + 16 + 8 + 8 + 16 + 1] == 0)
-        ) {
-        unifi_trace(priv, UDBG1, "uf_verify_m4: M4 detected \n");
-        return 0;
-    }
-    else
-    {
-        return 1;
-    }
+	p += 8;
+	keyinfo = p[5] << 8 | p[6]; /* big-endian */
+	if ((p[0] == 1 || p[0] == 2) &&
+		/* protocol version 802.1X-2001 (WPA) or -2004 (WPA2) */
+		p[1] == 3 && /* EAPOL-Key */
+		/* don't bother checking p[2] p[3]
+		 * (hh ll, packet body length) */
+		(p[4] == 254 || p[4] == 2) &&
+		/* descriptor type P802.1i-D3.0 (WPA) or 802.11i-2004 (WPA2) */
+		((keyinfo & 0x0007) == 1 || (keyinfo & 0x0007) == 2) &&
+		/* key descriptor version */
+		((keyinfo & ~0x0207U) == 0x0108) &&
+		/* key info for 4/4 or 4/2 -- ignore key desc version and
+		 * sec bit (since varies in WPA 4/4) */
+		((p[4 + 5 + 8 + 32 + 16 + 8 + 8 + 16 + 0] == 0) &&
+		/* key data length (2 octets) 0 for 4/4 only */
+		p[4 + 5 + 8 + 32 + 16 + 8 + 8 + 16 + 1] == 0)) {
+		unifi_trace(priv, UDBG1, "uf_verify_m4: M4 detected \n");
+		return 0;
+	} else {
+		return 1;
+	}
 }
 
 /*
@@ -54,4 +55,3 @@ uf_verify_m4(unifi_priv_t *priv, const unsigned char *packet, unsigned int lengt
  *
  * ---------------------------------------------------------------------------
  */
-
-- 
1.7.9.5

