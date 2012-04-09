Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab2DIUvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:51:11 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21017 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab2DIUvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:51:08 -0400
Date: Mon, 9 Apr 2012 22:51:07 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        libertas-dev@lists.infradead.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Dan Williams <dcbw@redhat.com>
Subject: [PATCH 13/26] wireless, libertas: remove redundant NULL tests before
 calling release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092221470.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() tests for, and deals gracefully with, NULL
pointers. Remove redundant explicit tests before calling the function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/wireless/libertas/if_cs.c   |    6 ++----
 drivers/net/wireless/libertas/if_sdio.c |    6 ++----
 drivers/net/wireless/libertas/if_spi.c  |    6 ++----
 drivers/net/wireless/libertas/main.c    |   12 ++++--------
 4 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 234ee88..171a06b 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -951,10 +951,8 @@ out2:
 out1:
 	pcmcia_disable_device(p_dev);
 out:
-	if (helper)
-		release_firmware(helper);
-	if (mainfw)
-		release_firmware(mainfw);
+	release_firmware(helper);
+	release_firmware(mainfw);
 
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
 	return ret;
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 9804ebc..15bfe2f 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -751,10 +751,8 @@ success:
 	ret = 0;
 
 out:
-	if (helper)
-		release_firmware(helper);
-	if (mainfw)
-		release_firmware(mainfw);
+	release_firmware(helper);
+	release_firmware(mainfw);
 
 	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
 	return ret;
diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 50b1ee7..7a5df4f 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1095,10 +1095,8 @@ static int if_spi_init_card(struct if_spi_card *card)
 		goto out;
 
 out:
-	if (helper)
-		release_firmware(helper);
-	if (mainfw)
-		release_firmware(mainfw);
+	release_firmware(helper);
+	release_firmware(mainfw);
 
 	lbs_deb_leave_args(LBS_DEB_SPI, "err %d\n", err);
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 957681d..3b81b70 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1269,14 +1269,10 @@ int lbs_get_firmware(struct device *dev, const char *user_helper,
 
   fail:
 	/* Failed */
-	if (*helper) {
-		release_firmware(*helper);
-		*helper = NULL;
-	}
-	if (*mainfw) {
-		release_firmware(*mainfw);
-		*mainfw = NULL;
-	}
+	release_firmware(*helper);
+	*helper = NULL;
+	release_firmware(*mainfw);
+	*mainfw = NULL;
 
 	return -ENOENT;
 }
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

