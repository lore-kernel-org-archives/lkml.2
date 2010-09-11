Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0IKRds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 13:33:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41232 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0IKRdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 13:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tF1ubmFdH8m3+8dUnWc/4jtI790ZZR6dWKwgnqzzrg2jDjdPcJLlrRgMUW70ySE0vy
         qazYSzdX0aW/JBzxdtLNEb7CqhqK+2vyq8qtvvkIXq1HtcPyGy1vgmauo0SngtLSO2GJ
         01nkBTO5W6VTE4txO5mtIsnbL2ImAmo6ASsjA=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Joe Perches <joe@perches.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 1/2] dvb: mantis: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 20:33:27 +0300
Message-Id: <0ffd3b30fbaa2168656dd17fbdb290cf2e0a867e.1284226281.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/media/dvb/mantis/mantis_core.c |    5 +----
 drivers/media/dvb/mantis/mantis_ioc.c  |    9 +--------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_core.c b/drivers/media/dvb/mantis/mantis_core.c
index 8113b23..22524a8 100644
--- a/drivers/media/dvb/mantis/mantis_core.c
+++ b/drivers/media/dvb/mantis/mantis_core.c
@@ -91,10 +91,7 @@ static int get_mac_address(struct mantis_pci *mantis)
 		return err;
 	}
 	dprintk(verbose, MANTIS_ERROR, 0,
-		"    MAC Address=[%02x:%02x:%02x:%02x:%02x:%02x]\n",
-		mantis->mac_address[0], mantis->mac_address[1],
-		mantis->mac_address[2],	mantis->mac_address[3],
-		mantis->mac_address[4], mantis->mac_address[5]);
+		"    MAC Address=[%pM]\n", mantis->mac_address);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/mantis/mantis_ioc.c b/drivers/media/dvb/mantis/mantis_ioc.c
index de148de..fe31cfb 100644
--- a/drivers/media/dvb/mantis/mantis_ioc.c
+++ b/drivers/media/dvb/mantis/mantis_ioc.c
@@ -68,14 +68,7 @@ int mantis_get_mac(struct mantis_pci *mantis)
 		return err;
 	}
 
-	dprintk(MANTIS_ERROR, 0,
-		"    MAC Address=[%02x:%02x:%02x:%02x:%02x:%02x]\n",
-		mac_addr[0],
-		mac_addr[1],
-		mac_addr[2],
-		mac_addr[3],
-		mac_addr[4],
-		mac_addr[5]);
+	dprintk(MANTIS_ERROR, 0, "    MAC Address=[%pM]\n", mac_addr);
 
 	return 0;
 }
-- 
1.7.2.2

