Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab2IQNqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:46:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37248 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2IQNqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:46:53 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devendra.aaru@gmail.com, peter.senna@gmail.com, benchan@chromium.org,
        syahn@gctsemi.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/staging/gdm72xx/gdm_sdio.c: Replace kmalloc+memset for kzalloc
Date: Mon, 17 Sep 2012 15:45:54 +0200
Message-Id: <1347889554-28901-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <20120917121831.GA23117@kroah.com>
References: <20120917121831.GA23117@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace kmalloc+memset for kzalloc and cleanup related code.

To be applied after 47ad3428a1086af425447f763705e06b16ae905d:
[PATCH 5/9] drivers/staging/gdm72xx/gdm_sdio.c: Remove useless kfree

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/staging/gdm72xx/gdm_sdio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index a0621d9..2e1a964 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -91,14 +91,12 @@ static void free_tx_struct(struct sdio_tx *t)
 
 static struct sdio_rx *alloc_rx_struct(struct rx_cxt *rx)
 {
-	struct sdio_rx *r = NULL;
+	struct sdio_rx *r;
 
-	r = kmalloc(sizeof(*r), GFP_ATOMIC);
+	r = kzalloc(sizeof(*r), GFP_ATOMIC);
 	if (!r)
 		return NULL;
 
-	memset(r, 0, sizeof(*r));
-
 	r->rx_cxt = rx;
 
 	return r;
-- 
1.7.11.4

