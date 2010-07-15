Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab0GOMho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 08:37:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49024 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0GOMhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 08:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bxxY8i6z1eHFcKqpjqwqlAn0HbYSowMo1q18tqgvY11VaRxahojVj+iIE1GIyJMoeS
         5SFKeDdp10vHmnGiOFKgynNQg5NSoxS2ZkEneG+vaM2GPVcidaendxAdTb1ALyZ7tz+N
         NHbfddIKVDZMLqR8jgkT4D+1Ae//R1PjshUmo=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>, Tilman Schmidt <tilman@imap.cc>,
        netdev@vger.kernel.org
Subject: [PATCH 1/3] drivers: isdn: use kernel macros to convert hex digit
Date: Thu, 15 Jul 2010 15:37:18 +0300
Message-Id: <1279197440-6585-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/capi/capidrv.c |    7 ++-----
 drivers/isdn/hisax/q931.c   |   13 ++-----------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index bf55ed5..2978bda 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -1450,12 +1450,9 @@ static void handle_dtrace_data(capidrv_contr *card,
     	}
 
 	for (p = data, end = data+len; p < end; p++) {
-		u8 w;
 		PUTBYTE_TO_STATUS(card, ' ');
-		w = (*p >> 4) & 0xf;
-		PUTBYTE_TO_STATUS(card, (w < 10) ? '0'+w : 'A'-10+w);
-		w = *p & 0xf;
-		PUTBYTE_TO_STATUS(card, (w < 10) ? '0'+w : 'A'-10+w);
+		PUTBYTE_TO_STATUS(card, hex_asc_hi(*p));
+		PUTBYTE_TO_STATUS(card, hex_asc_lo(*p));
 	}
 	PUTBYTE_TO_STATUS(card, '\n');
 
diff --git a/drivers/isdn/hisax/q931.c b/drivers/isdn/hisax/q931.c
index 8b853d5..c0771f9 100644
--- a/drivers/isdn/hisax/q931.c
+++ b/drivers/isdn/hisax/q931.c
@@ -1152,20 +1152,11 @@ QuickHex(char *txt, u_char * p, int cnt)
 {
 	register int i;
 	register char *t = txt;
-	register u_char w;
 
 	for (i = 0; i < cnt; i++) {
 		*t++ = ' ';
-		w = (p[i] >> 4) & 0x0f;
-		if (w < 10)
-			*t++ = '0' + w;
-		else
-			*t++ = 'A' - 10 + w;
-		w = p[i] & 0x0f;
-		if (w < 10)
-			*t++ = '0' + w;
-		else
-			*t++ = 'A' - 10 + w;
+		*t++ = hex_asc_hi(p[i]);
+		*t++ = hex_asc_lo(p[i]);
 	}
 	*t++ = 0;
 	return (t - txt);
-- 
1.7.1.1

