Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2J1Xbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:31:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42236 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757060Ab2J1X2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:30 -0400
Message-Id: <20121028231547.147509823@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:09 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Holler <holler@ahsoftware.de>,
        Bernie Thompson <bernie@plugable.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 033/105] video/udlfb: fix line counting in fb_write
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Holler <holler@ahsoftware.de>

commit b8c4321f3d194469007f5f5f2b34ec278c264a04 upstream.

Line 0 and 1 were both written to line 0 (on the display) and all subsequent
lines had an offset of -1. The result was that the last line on the display
was never overwritten by writes to /dev/fbN.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Acked-by: Bernie Thompson <bernie@plugable.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/udlfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 8af6414..38fcfff 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -647,7 +647,7 @@ static ssize_t dlfb_ops_write(struct fb_info *info, const char __user *buf,
 	result = fb_sys_write(info, buf, count, ppos);
 
 	if (result > 0) {
-		int start = max((int)(offset / info->fix.line_length) - 1, 0);
+		int start = max((int)(offset / info->fix.line_length), 0);
 		int lines = min((u32)((result / info->fix.line_length) + 1),
 				(u32)info->var.yres);
 


