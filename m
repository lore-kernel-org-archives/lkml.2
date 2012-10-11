Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2JKFLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:11:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58122 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2JKFLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:11:42 -0400
Message-ID: <1349932292.8495.2.camel@phoenix>
Subject: [PATCH] backlight: lm3639: Return proper error in
 lm3639_bled_mode_store error paths
From: Axel Lin <axel.lin@ingics.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "G.Shark Jeong" <gshark.jeong@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 13:11:32 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/video/backlight/lm3639_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
index c6915c6..585949b 100644
--- a/drivers/video/backlight/lm3639_bl.c
+++ b/drivers/video/backlight/lm3639_bl.c
@@ -206,11 +206,11 @@ static ssize_t lm3639_bled_mode_store(struct device *dev,
 
 out:
 	dev_err(pchip->dev, "%s:i2c access fail to register\n", __func__);
-	return size;
+	return ret;
 
 out_input:
 	dev_err(pchip->dev, "%s:input conversion fail\n", __func__);
-	return size;
+	return ret;
 
 }
 
-- 
1.7.9.5



