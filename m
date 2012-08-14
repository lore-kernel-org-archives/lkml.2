Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab2HNHLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 03:11:31 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:40854 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2HNHLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 03:11:30 -0400
Message-ID: <5029FA0D.1090107@ahsoftware.de>
Date: Tue, 14 Aug 2012 09:11:09 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Bernie Thompson <bernie@plugable.com>,
        Alexander Holler <holler@ahsoftware.de>, linux-fbdev@vger.kernel.org
Subject: [PATCH RESEND] video/udlfb: fix line counting in fb_write
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line 0 and 1 were both written to line 0 (on the display) and all subsequent
lines had an offset of -1. The result was that the last line on the display
was never overwritten by writes to /dev/fbN.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
  drivers/video/udlfb.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index a159b63..85d8110 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -647,7 +647,7 @@ static ssize_t dlfb_ops_write(struct fb_info *info, 
const char __user *buf,
  	result = fb_sys_write(info, buf, count, ppos);
   	if (result > 0) {
-		int start = max((int)(offset / info->fix.line_length) - 1, 0);
+		int start = max((int)(offset / info->fix.line_length), 0);
  		int lines = min((u32)((result / info->fix.line_length) + 1),
  				(u32)info->var.yres);
  -- 1.7.6.5

