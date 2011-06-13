Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1FMU7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:59:14 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23936 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1FMU7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:59:11 -0400
Date: Mon, 13 Jun 2011 22:50:41 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-usb@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, Ionut Nicu <ionut.nicu@mindbit.ro>,
        Al Borchers <alborchers@steinerpoint.com>,
        Peter Berger <pberger@brimson.com>
Subject: [PATCH] TI 3410/5052 USB Serial Driver: Fix mem leak when firmware
 is too big.
Message-ID: <alpine.LNX.2.00.1106132244220.30934@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the size of the firmware exceeds TI_FIRMWARE_BUF_SIZE we'll leak 'fw_p' 
by failing to call release_firmware().
This patch fixes the leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ti_usb_3410_5052.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index c6d92a5..ea84456 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1745,6 +1745,7 @@ static int ti_download_firmware(struct ti_device *tdev)
 	}
 	if (fw_p->size > TI_FIRMWARE_BUF_SIZE) {
 		dev_err(&dev->dev, "%s - firmware too large %zu\n", __func__, fw_p->size);
+		release_firmware(fw_p);
 		return -ENOENT;
 	}
 


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

