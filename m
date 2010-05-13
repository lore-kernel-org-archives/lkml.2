Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab0EMUCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:02:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41995 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759472Ab0EMUCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:02:08 -0400
Date: Thu, 13 May 2010 22:02:03 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 9/20] drivers/bluetooth: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132201470.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/bluetooth/btmrvl_sdio.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -u -p a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -216,7 +216,7 @@ static int btmrvl_sdio_download_helper(s
 
 	tmphlprbufsz = ALIGN_SZ(BTM_UPLD_SIZE, BTSDIO_DMA_ALIGN);
 
-	tmphlprbuf = kmalloc(tmphlprbufsz, GFP_KERNEL);
+	tmphlprbuf = kzalloc(tmphlprbufsz, GFP_KERNEL);
 	if (!tmphlprbuf) {
 		BT_ERR("Unable to allocate buffer for helper."
 			" Terminating download");
@@ -224,8 +224,6 @@ static int btmrvl_sdio_download_helper(s
 		goto done;
 	}
 
-	memset(tmphlprbuf, 0, tmphlprbufsz);
-
 	helperbuf = (u8 *) ALIGN_ADDR(tmphlprbuf, BTSDIO_DMA_ALIGN);
 
 	/* Perform helper data transfer */
@@ -318,7 +316,7 @@ static int btmrvl_sdio_download_fw_w_hel
 	BT_DBG("Downloading FW image (%d bytes)", firmwarelen);
 
 	tmpfwbufsz = ALIGN_SZ(BTM_UPLD_SIZE, BTSDIO_DMA_ALIGN);
-	tmpfwbuf = kmalloc(tmpfwbufsz, GFP_KERNEL);
+	tmpfwbuf = kzalloc(tmpfwbufsz, GFP_KERNEL);
 	if (!tmpfwbuf) {
 		BT_ERR("Unable to allocate buffer for firmware."
 		       " Terminating download");
@@ -326,8 +324,6 @@ static int btmrvl_sdio_download_fw_w_hel
 		goto done;
 	}
 
-	memset(tmpfwbuf, 0, tmpfwbufsz);
-
 	/* Ensure aligned firmware buffer */
 	fwbuf = (u8 *) ALIGN_ADDR(tmpfwbuf, BTSDIO_DMA_ALIGN);
 
