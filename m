Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1A3Ubr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 15:31:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1A3Ubq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 15:31:46 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: Stefan Weil <weil@mail.berlios.de>, Karsten Keil <isdn@linux-pingi.de>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: icn: Fix potentially wrong string handling
Date: Sun, 30 Jan 2011 21:31:26 +0100
Message-Id: <1296419486-5482-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:YSeecV0k+wVTjUHGauNWRWpjAp7fiClqQ6Ixa28v5mQ
 gKrXLy1KEbABhcLUCbXexcj2iA2xT0MyjS8vjXcKXWnuVcj2FI
 5FNfk6+dhysFoK9u9aFF7DhRXLNdIdI0wct73jLlFLZ/MF4vuO
 yiu9cKpX4NpRKQh1ujRoROxu65CBFDaaFXDY5sbowHHa6lkC/e
 s9wE30I85ZxCeWgCMaqD3W9XgZPehZpJ2mv9UoEsMHeg3aIPS8
 TLujuttabo+Y+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning was reported by cppcheck:
drivers/isdn/icn/icn.c:1641: error: Dangerous usage of 'rev' (strncpy doesn't always 0-terminate it)

If strncpy copied 20 bytes, the destination string rev was not terminated.
The patch adds one more byte to rev and makes sure that this byte is
always 0.

Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/isdn/icn/icn.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/icn/icn.c b/drivers/isdn/icn/icn.c
index f2b5bab..540c181 100644
--- a/drivers/isdn/icn/icn.c
+++ b/drivers/isdn/icn/icn.c
@@ -1627,7 +1627,7 @@ __setup("icn=", icn_setup);
 static int __init icn_init(void)
 {
 	char *p;
-	char rev[20];
+	char rev[21];
 
 	memset(&dev, 0, sizeof(icn_dev));
 	dev.memaddr = (membase & 0x0ffc000);
@@ -1638,6 +1638,7 @@ static int __init icn_init(void)
 
 	if ((p = strchr(revision, ':'))) {
 		strncpy(rev, p + 1, 20);
+		rev[20] = '\0';
 		p = strchr(rev, '$');
 		if (p)
 			*p = 0;
-- 
1.7.2.3

