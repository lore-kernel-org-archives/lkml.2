Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1A2Vd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 16:33:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab1A2Vd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 16:33:57 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: linux390@de.ibm.com
Cc: Stefan Weil <weil@mail.berlios.de>, Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] s390: Fix possibly wrong size in strncmp (smsglucv)
Date: Sat, 29 Jan 2011 22:33:28 +0100
Message-Id: <1296336808-2809-2-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296336808-2809-1-git-send-email-weil@mail.berlios.de>
References: <1296336808-2809-1-git-send-email-weil@mail.berlios.de>
X-Provags-ID: V02:K0:TENTT34I6GVRVfpK+WdRlYvgdzsE5hd3Nc8WpGFZZuU
 Ua0RkoxYvWqQGulkMxmNecoh87nXTD9ZflX0jW0o8eYUTAnjp4
 lj4iEIPTMbYlMQTIymxoHwBqzAoPwhXWgCeGusaWpHRBluXpip
 5vwUzh74aTjB1g6A6PiDPbWwmH3YoZUsdY676jrXBSdbxuh3CY
 i91MuDpxOhB8uXH58kd0IaTRwA9oDO6uYMk0t73+Qcw+q01EEU
 utIGUaxkN0NnT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error was reported by cppcheck:
drivers/s390/net/smsgiucv.c:63: error: Using sizeof for array given as function argument returns the size of pointer.

Although there is no runtime problem as long as sizeof(u8 *) == 8,
this misleading code should get fixed.

Cc: Ursula Braun <ursula.braun@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/s390/net/smsgiucv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/net/smsgiucv.c b/drivers/s390/net/smsgiucv.c
index 65e1cf1..207b7d7 100644
--- a/drivers/s390/net/smsgiucv.c
+++ b/drivers/s390/net/smsgiucv.c
@@ -60,7 +60,7 @@ static struct iucv_handler smsg_handler = {
 static int smsg_path_pending(struct iucv_path *path, u8 ipvmid[8],
 			     u8 ipuser[16])
 {
-	if (strncmp(ipvmid, "*MSG    ", sizeof(ipvmid)) != 0)
+	if (strncmp(ipvmid, "*MSG    ", 8) != 0)
 		return -EINVAL;
 	/* Path pending from *MSG. */
 	return iucv_path_accept(path, &smsg_handler, "SMSGIUCV        ", NULL);
-- 
1.7.2.3

