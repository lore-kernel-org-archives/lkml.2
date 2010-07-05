Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab0GEIBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:01:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37734 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab0GEIBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=VVeXkgACr4KcSqmw3wJhtjn5YFV0kC1wri2Vl5COhuA3L0gI7zALroTl4VEWnCgQ8K
         wUERF+vXh62v0NoPVg1QS69adN/87YX174uSIheGugsULcmSTJYwj/Oz22LCaDzcTkHE
         9anW1p/rLZ1JfFt0ZaeMHcuWEzDqcmmNoPvWA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Bing Zhao <bzhao@marvell.com>,
       Ben Hutchings <ben@decadent.org.uk>,
       =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Julia Lawall <julia@diku.dk>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] bluetooth: btmrvl_sdio: silence warning
Date: Mon,  5 Jul 2010 12:01:22 +0400
Message-Id: <1278316883-29784-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clone checking of ret to simplify the code.

This patch silences a compiler warning:
drivers/bluetooth/btmrvl_sdio.c: In function ‘btmrvl_sdio_verify_fw_download’:
drivers/bluetooth/btmrvl_sdio.c:80: warning: ‘fws1’ may be used uninitialized in this function
drivers/bluetooth/btmrvl_sdio.c:80: note: ‘fws1’ was declared here

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/bluetooth/btmrvl_sdio.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index df0773e..47f0f91 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -83,10 +83,10 @@ static int btmrvl_sdio_read_fw_status(struct btmrvl_sdio_card *card, u16 *dat)
 	*dat = 0;
 
 	fws0 = sdio_readb(card->func, CARD_FW_STATUS0_REG, &ret);
+	if (ret)
+		return -EIO;
 
-	if (!ret)
-		fws1 = sdio_readb(card->func, CARD_FW_STATUS1_REG, &ret);
-
+	fws1 = sdio_readb(card->func, CARD_FW_STATUS1_REG, &ret);
 	if (ret)
 		return -EIO;
 
-- 
1.7.0.4

