Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0ISKWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 06:22:17 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45077 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0ISKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 06:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=fLaU/4Sx2WF5S451VHC2OLbCsEhTRIex0cRe17d/tMXySm9OzfubagHDch1Gx5zQDk
         5moH7bjOkE3BrRUWWi7YkGyHv9oGFQJPdvwMXNuYw90GCEomWuZrkE5dZEJEApvj+36g
         U2EaZUGzeSech9VA9q6PtPXaVtVZNIAzFxkI4=
Subject: [PATCH] RTC: rtc-ab3100 - Add missing platform_set_drvdata() in
 ab3100_rtc_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        rtc-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 18:22:06 +0800
Message-ID: <1284891726.2199.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, calling platform_get_drvdata() in ab3100_rtc_remove() return NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-ab3100.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index d26780e..261a07e 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -235,6 +235,7 @@ static int __init ab3100_rtc_probe(struct platform_device *pdev)
 		err = PTR_ERR(rtc);
 		return err;
 	}
+	platform_set_drvdata(pdev, rtc);
 
 	return 0;
 }
@@ -244,6 +245,7 @@ static int __exit ab3100_rtc_remove(struct platform_device *pdev)
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
 	rtc_device_unregister(rtc);
+	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.0.4



