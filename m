Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0KHXWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:22:21 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19442 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab0KHXWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:22:19 -0500
Date: Tue, 9 Nov 2010 00:10:52 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH 16/17][trivial] USB: Remove unnecessary casts of void ptr
 returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011090001120.23697@swampdragon.chaosbits.net>
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

This patch removes such casts from drivers/usb/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ehci-dbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index 86afdc7..a6bab72 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -879,7 +879,7 @@ static int fill_buffer(struct debug_buffer *buf)
 	int ret = 0;
 
 	if (!buf->output_buf)
-		buf->output_buf = (char *)vmalloc(buf->alloc_size);
+		buf->output_buf = vmalloc(buf->alloc_size);
 
 	if (!buf->output_buf) {
 		ret = -ENOMEM;



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

