Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0KHXUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:20:09 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:39349 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab0KHXUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:20:07 -0500
Date: Tue, 9 Nov 2010 00:08:41 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, linux-media@vger.kernel.org,
        Jelle Foks <jelle@foks.us>, Gerd Knorr <kraxel@bytesex.org>,
        Steven Toth <stoth@linuxtv.org>
Subject: [PATCH 04/17][trivial] drivers/media/, cx231xx-417: Remove unnecessary
 casts of void ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082318590.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from drivers/media/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 cx231xx-417.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/video/cx231xx/cx231xx-417.c
index aab21f3..42075dc 100644
--- a/drivers/media/video/cx231xx/cx231xx-417.c
+++ b/drivers/media/video/cx231xx/cx231xx-417.c
@@ -941,14 +941,14 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	u16 _buffer_size = 4096;
 	u8 *p_buffer;
 
-	p_current_fw = (u32 *)vmalloc(1884180*4);
+	p_current_fw = vmalloc(1884180*4);
 	p_fw = p_current_fw;
 	if (p_current_fw == 0) {
 		dprintk(2, "FAIL!!!\n");
 		return -1;
 	}
 
-	p_buffer = (u8 *)vmalloc(4096);
+	p_buffer = vmalloc(4096);
 	if (p_buffer == 0) {
 		dprintk(2, "FAIL!!!\n");
 		return -1;



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

