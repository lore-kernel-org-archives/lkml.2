Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab2HGDl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:41:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59913 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964808Ab2HGDjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:39:01 -0400
Message-Id: <20120807032800.101155066@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexander Holler <holler@ahsoftware.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 27/70] video/smscufx: fix line counting in fb_write
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Holler <holler@ahsoftware.de>

commit 2fe2d9f47cfe1a3e66e7d087368b3d7155b04c15 upstream.

Line 0 and 1 were both written to line 0 (on the display) and all subsequent
lines had an offset of -1. The result was that the last line on the display
was never overwritten by writes to /dev/fbN.

The origin of this bug seems to have been udlfb.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/smscufx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
index af3ef27..f39e069 100644
--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -904,7 +904,7 @@ static ssize_t ufx_ops_write(struct fb_info *info, const char __user *buf,
 	result = fb_sys_write(info, buf, count, ppos);
 
 	if (result > 0) {
-		int start = max((int)(offset / info->fix.line_length) - 1, 0);
+		int start = max((int)(offset / info->fix.line_length), 0);
 		int lines = min((u32)((result / info->fix.line_length) + 1),
 				(u32)info->var.yres);
 


