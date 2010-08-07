Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0HGXyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 19:54:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64971 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0HGXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 19:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Yn9w14UWMWgr75F6m1tjDktSPUrQfOt8q5lMrgvUSA+MiSbiX59s8I4RU8VE7SXxAH
         Fsyk4wtsgMsAMOsPyvgM31P9+3eatn8UzccswWNGbWXCJLf/9Y6aVrYFBUNVo9kefG0+
         QXf2cOO6gvcvM2Tlgx5iLpaTi+5C3hKNRv83w=
Subject: [PATCH] stating: otus: fix compile warning and some style issues
From: Roberto Rodriguez Alkala <rralcala@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 19:52:29 -0400
Message-ID: <1281225149.10826.5.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In today linux-next I got a compile warning in staging/otus driver. 
This patch solves the issue and also improves the coding style.

Signed-off-by: Roberto Rodriguez Alcala <rralcala@gmail.com>
---
 drivers/staging/otus/80211core/ratectrl.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/otus/80211core/ratectrl.c b/drivers/staging/otus/80211core/ratectrl.c
index a1abe2f..283b2b5 100644
--- a/drivers/staging/otus/80211core/ratectrl.c
+++ b/drivers/staging/otus/80211core/ratectrl.c
@@ -422,23 +422,15 @@ u8_t zfRateCtrlRateDiff(struct zsRcCell* rcCell, u8_t retryRate)
     u16_t i;
 
     /* Find retryRate in operationRateSet[] */
-    for (i=0; i<rcCell->operationRateCount; i++)
-    {
-        if (retryRate == rcCell->operationRateSet[i])
-        {
-            if (i < rcCell->currentRateIndex)
-            {
-                return ((rcCell->currentRateIndex - i)+1)>>1;
-            }
-            else if (i == rcCell->currentRateIndex == 0)
-            {
-                return 1;
-            }
-            else
-            {
-                return 0;
-            }
-        }
+    for (i = 0; i < rcCell->operationRateCount; i++) {
+	if (retryRate == rcCell->operationRateSet[i]) {
+		if (i < rcCell->currentRateIndex)
+			return ((rcCell->currentRateIndex - i)+1)>>1;
+		else if (i == rcCell->currentRateIndex && i == 0)
+			return 1;
+		else
+			return 0;
+	}
     }
     /* TODO : retry rate not in operation rate set */
     zm_msg1_tx(ZM_LV_0, "Not in operation rate set:", retryRate);
-- 
1.7.0.4



