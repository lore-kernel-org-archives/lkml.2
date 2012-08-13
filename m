Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2HMUWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:22:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab2HMUWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:22:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Holler <holler@ahsoftware.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 34/82] video/smscufx: fix line counting in fb_write
Date: Mon, 13 Aug 2012 13:19:10 -0700
Message-Id: <20120813201749.416073582@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Holler <holler@ahsoftware.de>

commit 2fe2d9f47cfe1a3e66e7d087368b3d7155b04c15 upstream.

Line 0 and 1 were both written to line 0 (on the display) and all subsequent
lines had an offset of -1. The result was that the last line on the display
was never overwritten by writes to /dev/fbN.

The origin of this bug seems to have been udlfb.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/smscufx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -904,7 +904,7 @@ static ssize_t ufx_ops_write(struct fb_i
 	result = fb_sys_write(info, buf, count, ppos);
 
 	if (result > 0) {
-		int start = max((int)(offset / info->fix.line_length) - 1, 0);
+		int start = max((int)(offset / info->fix.line_length), 0);
 		int lines = min((u32)((result / info->fix.line_length) + 1),
 				(u32)info->var.yres);
 


