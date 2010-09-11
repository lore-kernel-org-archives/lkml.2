Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0IKNdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 09:33:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50765 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0IKNdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 09:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cw1AhabBzBAE9w64Rphy+XfmNVEAg83nn1XoRXvmTxqI+RjdLQpoFhynYFCZRPGrgr
         CSVJ++yfKIC2Dj7qvOezwBkcJ5HcC2s2UxDk5A5cosBnK+m8jXUnjslZH3ZWrzUpHFVa
         MzxADZNE3azUF7TK0vtxLFlUo86cgZ4STwO4E=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH] arch: mips: use newly introduced hex_to_bin()
Date: Sat, 11 Sep 2010 16:33:29 +0300
Message-Id: <1284212009-25708-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove custom implementation of hex_to_bin().

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/rb532/devices.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
index 041fc1a..a969eb8 100644
--- a/arch/mips/rb532/devices.c
+++ b/arch/mips/rb532/devices.c
@@ -251,28 +251,22 @@ static struct platform_device *rb532_devs[] = {
 
 static void __init parse_mac_addr(char *macstr)
 {
-	int i, j;
-	unsigned char result, value;
+	int i, h, l;
 
 	for (i = 0; i < 6; i++) {
-		result = 0;
-
 		if (i != 5 && *(macstr + 2) != ':')
 			return;
 
-		for (j = 0; j < 2; j++) {
-			if (isxdigit(*macstr)
-			    && (value =
-				isdigit(*macstr) ? *macstr -
-				'0' : toupper(*macstr) - 'A' + 10) < 16) {
-				result = result * 16 + value;
-				macstr++;
-			} else
-				return;
-		}
+		h = hex_to_bin(*macstr++);
+		if (h == -1)
+			return;
+
+		l = hex_to_bin(*macstr++);
+		if (l == -1)
+			return;
 
 		macstr++;
-		korina_dev0_data.mac[i] = result;
+		korina_dev0_data.mac[i] = (h << 4) + l;
 	}
 }
 
-- 
1.7.2.2

