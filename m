Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0LRWOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 17:14:31 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16901 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab0LRWO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 17:14:28 -0500
Date: Sat, 18 Dec 2010 23:05:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-media@vger.kernel.org
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steven Toth <stoth@kernellabs.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] saa7164: Remove pointless conditional and save a few bytes
 in saa7164_downloadfirmware().
Message-ID: <alpine.LNX.2.00.1012182259320.17400@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

release_firmware() just does nothing if passed a NULL pointer. So there's 
no reason to test before the call in 
saa7164-fw.c::saa7164_downloadfirmware().

Removing the pointless conditional also saves a few bytes.
before:
   text    data     bss     dec     hex filename
   7943     112    2144   10199    27d7 drivers/media/video/saa7164/saa7164-fw.o
after:
   text    data     bss     dec     hex filename
   7931     112    2136   10179    27c3 drivers/media/video/saa7164/saa7164-fw.o


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 saa7164-fw.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

 compile tested only.

diff --git a/drivers/media/video/saa7164/saa7164-fw.c b/drivers/media/video/saa7164/saa7164-fw.c
index 484533c..af71367 100644
--- a/drivers/media/video/saa7164/saa7164-fw.c
+++ b/drivers/media/video/saa7164/saa7164-fw.c
@@ -608,8 +608,6 @@ int saa7164_downloadfirmware(struct saa7164_dev *dev)
 	ret = 0;
 
 out:
-	if (fw)
-		release_firmware(fw);
-
+	release_firmware(fw);
 	return ret;
 }



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

