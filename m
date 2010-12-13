Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab0LMGrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:47:02 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49486 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab0LMGrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:47:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=N5bGARO7IuGu2FMWVP+mNMS1ZMiqQ8tU5MGXlhLNsyFegjVoUGqnohmFq+bDPulTZ7
         p8tnXjx8poaRcULAQGzC0nBxH/jkiV8EBxVmF10ANDLMWbI7k+uhMtUwEdvJTgMK+iNI
         JIk5ApjYjnWIjEixtOMkHEKCU57UR+vI+l7ro=
Subject: [PATCH] backlight: cr_bllcd.c: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>,
        Alan Hourihane <alanh@tungstengraphics.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 13 Dec 2010 14:53:50 +0800
Message-Id: <1292223230.3636.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/cr_bllcd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index a4f4546..397d15e 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -242,6 +242,7 @@ static int cr_backlight_remove(struct platform_device *pdev)
 	backlight_device_unregister(crp->cr_backlight_device);
 	lcd_device_unregister(crp->cr_lcd_device);
 	pci_dev_put(lpc_dev);
+	kfree(crp);
 
 	return 0;
 }
-- 
1.7.2



