Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456Ab2JSDYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:24:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:54441 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851Ab2JSDRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Holler <holler@ahsoftware.de>,
        Bernie Thompson <bernie@plugable.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 15/37] video/udlfb: fix line counting in fb_write
Date: Thu, 18 Oct 2012 20:16:38 -0700
Message-Id: <20121019031305.311573968@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Holler <holler@ahsoftware.de>

commit b8c4321f3d194469007f5f5f2b34ec278c264a04 upstream.

Line 0 and 1 were both written to line 0 (on the display) and all subsequent
lines had an offset of -1. The result was that the last line on the display
was never overwritten by writes to /dev/fbN.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Acked-by: Bernie Thompson <bernie@plugable.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/udlfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -613,7 +613,7 @@ static ssize_t dlfb_ops_write(struct fb_
 	result = fb_sys_write(info, buf, count, ppos);
 
 	if (result > 0) {
-		int start = max((int)(offset / info->fix.line_length) - 1, 0);
+		int start = max((int)(offset / info->fix.line_length), 0);
 		int lines = min((u32)((result / info->fix.line_length) + 1),
 				(u32)info->var.yres);
 


