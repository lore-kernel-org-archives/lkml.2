Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab2KZRDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:03:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47309 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab2KZRDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Holler <holler@ahsoftware.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 062/270] video/udlfb: fix line counting in fb_write
Date: Mon, 26 Nov 2012 14:55:52 -0200
Message-Id: <1353949160-26803-63-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Holler <holler@ahsoftware.de>

commit b8c4321f3d194469007f5f5f2b34ec278c264a04 upstream.

Line 0 and 1 were both written to line 0 (on the display) and all subsequent
lines had an offset of -1. The result was that the last line on the display
was never overwritten by writes to /dev/fbN.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Acked-by: Bernie Thompson <bernie@plugable.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
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
 
-- 
1.7.9.5

