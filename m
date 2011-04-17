Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1DQCDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 22:03:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57977 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab1DQCDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 22:03:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pHbBI0R5/bBoJOUdnARHw8KdO7qqNGAmXuB9i7bqkPSstjOsTy7fZjZHQCjKdecSuv
         mzn/yC1hfGb4NFz943d0u3DKq7elImscHW3wavOPjBCl2ufwVY22xD10/duEBFmWJ//7
         mqWonn8hbFr+J7O7GfLHANjT+Dt+fI5ayRXt0=
Subject: [PATCH] RTC: rtc-omap: fix a leak of the IRQ during init failure
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "George G. Davis" <gdavis@mvista.com>,
        Alessandro Zummo <a.zummo@towertech.it>, Ingo Molnar <mingo@elte.hu>,
        rtc-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Apr 2011 10:02:58 +0800
Message-ID: <1303005778.2889.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In omap_rtc_probe error path, free_irq() was using NULL rather than the
driver data as the data pointer so free_irq() wouldn't have matched.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-omap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index de0dd7b..bcae8dd 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -394,7 +394,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 fail2:
-	free_irq(omap_rtc_timer, NULL);
+	free_irq(omap_rtc_timer, rtc);
 fail1:
 	rtc_device_unregister(rtc);
 fail0:
-- 
1.7.1



