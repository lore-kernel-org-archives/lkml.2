Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1AJXrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:47:47 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17058 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1AJXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:47:46 -0500
Date: Tue, 11 Jan 2011 00:47:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-wireless@vger.kernel.org
cc: users@rt2x00.serialmonkey.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH] rt2x00: Don't leak mem in error path of
 rt2x00lib_request_firmware()
Message-ID: <alpine.LNX.2.00.1101110044580.32164@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to release_firmware() in order not to leak memory.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 rt2x00firmware.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
index f0e1eb7..be0ff78 100644
--- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
@@ -58,6 +58,7 @@ static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
 
 	if (!fw || !fw->size || !fw->data) {
 		ERROR(rt2x00dev, "Failed to read Firmware.\n");
+		release_firmware(fw);
 		return -ENOENT;
 	}
 


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

