Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1HKRfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:35:14 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:50360 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab1HKRfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:35:10 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=869cbtyjxWwA:10 a=3vTz8TldEKgA:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=YORvzBCaAAAA:8 a=abKWMCI7m_NuRPERae8A:9 a=53STBovY0Um3xrqOcI4A:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
Message-ID: <4E4412CB.9020703@systemfabricworks.com>
Date: Thu, 11 Aug 2011 12:35:07 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, joakim.tjernlund@transmode.se,
        akpm@linux-foundation.org, linux@horizon.com,
        fzago@systemfabricworks.com
Subject: [patch v5 resending 1/8] crc32: add-pointer-to-tab.diff
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


replace 2D array references by pointer references in loops

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 lib/crc32.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

Index: infiniband/lib/crc32.c
===================================================================
--- infiniband.orig/lib/crc32.c
+++ infiniband/lib/crc32.c
@@ -51,20 +51,21 @@ static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
-#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
-		tab[2][(crc >> 8) & 255] ^ \
-		tab[1][(crc >> 16) & 255] ^ \
-		tab[0][(crc >> 24) & 255]
+#  define DO_CRC(x) (crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8))
+#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
+			t2[(crc >> 8) & 255] ^ \
+			t1[(crc >> 16) & 255] ^ \
+			t0[(crc >> 24) & 255]
 # else
-#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
-		tab[1][(crc >> 8) & 255] ^ \
-		tab[2][(crc >> 16) & 255] ^ \
-		tab[3][(crc >> 24) & 255]
+#  define DO_CRC(x) (crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8))
+#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
+			t1[(crc >> 8) & 255] ^ \
+			t2[(crc >> 16) & 255] ^ \
+			t3[(crc >> 24) & 255]
 # endif
 	const u32 *b;
 	size_t    rem_len;
+	const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];

 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {
