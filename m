Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1CUMoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:44:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48244 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1CUMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PuBGdLxGVdc8ZB/Nnc92Yu3mwq7FohV7zzMBnMhtCf7SGUT3UZZhpsDwjblvWARJxp
         7UwkPGHI8VLtQMtkSCMSMT2roX0HAAvmjytyD8rfQB77UHHXSBtgz8ut5dvc2vvogd5y
         FQ9qqQC6LH0yRnf/ehM4gpeP+n6fZlIXNDnK0=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/2] rtc: s3c: Fix compilation error in s3c_rtc_remove.
Date: Mon, 21 Mar 2011 13:43:56 +0100
Message-Id: <1300711436-32296-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300711436-32296-1-git-send-email-marek.belisko@open-nandra.com>
References: <1300711436-32296-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following compilation error:
drivers/rtc/rtc-s3c.c: In function 's3c_rtc_remove':
drivers/rtc/rtc-s3c.c:410:2: error: implicit declaration of function 's3c_rtc_setpie'

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/rtc/rtc-s3c.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 43dcefd..b3466c4 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -407,7 +407,6 @@ static int __devexit s3c_rtc_remove(struct platform_device *dev)
 	platform_set_drvdata(dev, NULL);
 	rtc_device_unregister(rtc);
 
-	s3c_rtc_setpie(&dev->dev, 0);
 	s3c_rtc_setaie(&dev->dev, 0);
 
 	clk_disable(rtc_clk);
-- 
1.7.1

