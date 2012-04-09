Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab2DIUuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:50:10 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20802 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DIUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:50:05 -0400
Date: Mon, 9 Apr 2012 22:50:04 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dean Anderson <linux-dev@sensoray.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/26] [media] s2255drv: Remove redundant NULL test before
 release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092206300.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() tests for NULL pointers on its own - there's no
reason to do an explicit check before calling the function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/video/s2255drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 4894cbb..37845de 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -1826,8 +1826,7 @@ static void s2255_destroy(struct s2255_dev *dev)
 		usb_free_urb(dev->fw_data->fw_urb);
 		dev->fw_data->fw_urb = NULL;
 	}
-	if (dev->fw_data->fw)
-		release_firmware(dev->fw_data->fw);
+	release_firmware(dev->fw_data->fw);
 	kfree(dev->fw_data->pfw_data);
 	kfree(dev->fw_data);
 	/* reset the DSP so firmware can be reloaded next time */
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

