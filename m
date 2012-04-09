Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab2DIUwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:52:09 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21278 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2DIUwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:52:05 -0400
Date: Mon, 9 Apr 2012 22:52:04 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [PATCH 22/26] usb/storage/ene_ub6250: Remove redundant NULL check
 before release_firmware() and pointless assignment
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092240480.14420@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() tests for a NULL pointer, so it's redundant to do
that checking before calling it.

Additionally, in ene_load_bincode(), 'sd_fw' is a local variable so
setting it to NULL just before it goes out of scope is completely
pointless, so remove that assignment.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/usb/storage/ene_ub6250.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index e7e6781..b28f2ad 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -1933,11 +1933,7 @@ static int ene_load_bincode(struct us_data *us, unsigned char flag)
 	kfree(buf);
 
 nofw:
-	if (sd_fw != NULL) {
-		release_firmware(sd_fw);
-		sd_fw = NULL;
-	}
-
+	release_firmware(sd_fw);
 	return result;
 }
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

