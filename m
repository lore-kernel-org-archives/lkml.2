Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1CUMoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:44:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46578 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1CUMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=G+w5HIhdioHzTCuWMwFhr0WPbt4qo29WESKOpO9yowxIfHj+2K7TBY3RgbT7CuQkje
         ywvJfNh1noGUatIcJj6DRWsBNGP4kcx4z48lRngVnj6fQzBwJZL9a/z49M6LT8lRA49l
         qV75XwUZP4zFcQ6irimKeVmJjWUSZIznMQJc4=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/2] rtc: s3c: Fix compilation error in s3c_rtc_release.
Date: Mon, 21 Mar 2011 13:43:55 +0100
Message-Id: <1300711436-32296-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300711436-32296-1-git-send-email-marek.belisko@open-nandra.com>
References: <1300711436-32296-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation error:
drivers/rtc/rtc-s3c.c: In function 's3c_rtc_release':
drivers/rtc/rtc-s3c.c:339:2: error: implicit declaration of function 's3c_rtc_setpie'

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/rtc/rtc-s3c.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 7149649..43dcefd 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -336,7 +336,6 @@ static void s3c_rtc_release(struct device *dev)
 
 	/* do not clear AIE here, it may be needed for wake */
 
-	s3c_rtc_setpie(dev, 0);
 	free_irq(s3c_rtc_alarmno, rtc_dev);
 	free_irq(s3c_rtc_tickno, rtc_dev);
 }
-- 
1.7.1

