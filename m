Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2J2EqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 00:46:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53726 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2J2EqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 00:46:24 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-bc-508e0a1e3e27
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] backlight: 88pm860x: drop devm_kfree of devm_kzalloc'd data
Date: Mon, 29 Oct 2012 13:46:22 +0900
Message-id: <000501cdb590$588260f0$098722d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac21kFhmA4SJbq7/SSeHEgsu/+gYEg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jQV15rr4Ag9uHGC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG10dGBbd4Ku5dE2hg3MbVxcjJISFgItHwuJ8VwhaTuHBvPVsX
	IxeHkMB0RommS1uZIZzZTBITT/SwgFSxCahJfPlymB3EFhGIkGieMQuoiIODWcBHYvMsTZCw
	sECARP+FNWwgYRYBVYmGqW4gYV4BW4mj0+azQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zFmyi
	hIC6xKO/uhCL9CRuvH3HClEiIrHvxTvGCYwCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIzggn0ntYFzZYHGIUYCDUYmHt/FNb4AQa2JZcWXuIUYJDmYlEd6l
	3EAh3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFCAumJJanZqakFqUUwWSYOTqkGxmVn2lrz
	2ntddx896GEpmfpgWeUX3a9/Tmxc3VX6Jylqtb9Wg/GJ/79eHXo755Jui8SRFWecqo/bti3y
	DyqOWXs0+MGuTdv2GllbX772YROj1dlP/feunFxU/HUzo8NxD/5XUaqTPwYqP9NeH7z6gdoF
	n3uOBU5NVooN3w0cJpssvMs48bNztKkSS3FGoqEWc1FxIgA4UceERAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_kfree function allocates memory that is released
when a driver detaches. Thus, there is no reason to explicitly
call devm_kfree in probe or remove functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/88pm860x_bl.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index b7ec34c..861cc40 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -208,22 +208,19 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_REG, "duty cycle");
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resource for duty cycle\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_duty_cycle = res->start;
 	res = platform_get_resource_byname(pdev, IORESOURCE_REG, "always on");
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resorce for always on\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_always_on = res->start;
 	res = platform_get_resource_byname(pdev, IORESOURCE_REG, "current");
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resource for current\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_current = res->start;
 
@@ -263,8 +260,6 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	return 0;
 out_brt:
 	backlight_device_unregister(bl);
-out:
-	devm_kfree(&pdev->dev, data);
 	return ret;
 }
 
-- 
1.7.1


