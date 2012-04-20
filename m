Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2DTWLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:11:20 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:57060 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2DTWLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:11:19 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Bernie Thompson <bernie@plugable.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] video/udlfb: fix line counting in fb_write
Date: Sat, 21 Apr 2012 00:10:44 +0200
Message-Id: <1334959844-3665-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line 0 and 1 were both written to line 0 (on the display) and all subsequent
lines had an offset of -1. The result was that the last line on the display
was never overwritten by writes to /dev/fbN.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/video/udlfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index a159b63..85d8110 100644
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
1.7.6.5

