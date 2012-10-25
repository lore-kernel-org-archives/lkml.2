Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946093Ab2JYOKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:10:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53709 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945971Ab2JYOKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:10:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND] mtip32xx: fix potential crash on SEC_ERASE_UNIT
To: smain@micron.com, linux-kernel@vger.kernel.org
Date: Thu, 25 Oct 2012 15:12:13 +0100
Message-ID: <20121025141133.30303.3712.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending to the list as the maintainer is not responding to direct email)

From: Alan Cox <alan@linux.intel.com>

The mtip driver lifted this code from elsewhere and then added a special
handling check for SEC_ERASE_UNIT. If the caller tries to do a security
erase but passes no output data for the command then outbuf is not
allocated and the driver duly explodes.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/block/mtip32xx/mtip32xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index adc6f36..d11e9e7 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2218,8 +2218,8 @@ static int exec_drive_taskfile(struct driver_data *dd,
 		fis.device);
 
 	/* check for erase mode support during secure erase.*/
-	if ((fis.command == ATA_CMD_SEC_ERASE_UNIT)
-					&& (outbuf[0] & MTIP_SEC_ERASE_MODE)) {
+	if (fis.command == ATA_CMD_SEC_ERASE_UNIT && outbuf &&
+					(outbuf[0] & MTIP_SEC_ERASE_MODE)) {
 		erasemode = 1;
 	}
 

