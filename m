Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab2KWHGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:06:42 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55443 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab2KWHGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:06:40 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, patches@linaro.org
Subject: [PATCH 1/2] drivers/rtc/rtc-s3c.c: Remove unnecessary err_nores label
Date: Fri, 23 Nov 2012 12:30:18 +0530
Message-Id: <1353654019-1099-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353654019-1099-1-git-send-email-tushar.behera@linaro.org>
References: <1353654019-1099-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err_nores label redirects to a simple return statement. Move the
return statement to caller location and remove the label.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/rtc/rtc-s3c.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 77823d2..df7b478 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -501,8 +501,7 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 
 	if (s3c_rtc_mem == NULL) {
 		dev_err(&pdev->dev, "failed to reserve memory region\n");
-		ret = -ENOENT;
-		goto err_nores;
+		return -ENOENT;
 	}
 
 	s3c_rtc_base = ioremap(res->start, resource_size(res));
@@ -612,8 +611,6 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 
  err_nomap:
 	release_resource(s3c_rtc_mem);
-
- err_nores:
 	return ret;
 }
 
-- 
1.7.4.1

