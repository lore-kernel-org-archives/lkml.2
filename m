Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab1A2Vdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 16:33:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57515 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1A2Vdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 16:33:50 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: linux390@de.ibm.com
Cc: Stefan Weil <weil@mail.berlios.de>, Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] s390: Fix wrong size in memcmp (netiucv)
Date: Sat, 29 Jan 2011 22:33:27 +0100
Message-Id: <1296336808-2809-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:Aax+s9alzT5YyKeQ1iy8IVHzSIhtMvKmwqKkq7RoZo1
 G88LNJFOARXwgwugXhY2TfWKec74OiTWs5bXYVGevQ/TUFPlLX
 9cNQn+lpMJfFnmhwwanL5xudSKaQ6kxIAOYgUMP5O3sXUy3+N4
 nDOiOoOYnkSQi/JzknB/Wv8h+Fw1kz67cMy8GNaRHfN7E4IUpt
 vmAeW+a4UHEwI3O6YJaC2W8LKT9RceLYiZQR3peoBg3kP2gJhW
 msZ5iRpdSR3Rh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error was reported by cppcheck:
drivers/s390/net/netiucv.c:568: error: Using sizeof for array given as function argument returns the size of pointer.

sizeof(ipuser) did not result in 16 (as many programmers would have
expected) but sizeof(u8 *), so it is 4 or 8, too small here.

Cc: Ursula Braun <ursula.braun@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/s390/net/netiucv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 65ebee0..b6a6356 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -565,7 +565,7 @@ static int netiucv_callback_connreq(struct iucv_path *path,
 	struct iucv_event ev;
 	int rc;
 
-	if (memcmp(iucvMagic, ipuser, sizeof(ipuser)))
+	if (memcmp(iucvMagic, ipuser, 16))
 		/* ipuser must match iucvMagic. */
 		return -EINVAL;
 	rc = -EINVAL;
-- 
1.7.2.3

