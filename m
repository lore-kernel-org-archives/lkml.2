Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2HFJdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:33:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18331 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2HFJdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:33:00 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-07-501f8f4be277
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jin Park'" <jinyoungp@nvidia.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 2/3] backlight: aat2870: remove goto out
Date: Mon, 06 Aug 2012 18:32:59 +0900
Message-id: <003f01cd73b6$77ce18d0$676a4a70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1ztne3F2A0b+hXScmlr4lEx6LeBg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAV3vfvkAgykndCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGz3sr2Avm8Fasf3GAtYHxClcXIyeHhICJxJWNt9khbDGJC/fW
	s3UxcnEICSxilNjVvocJwpnNJDFn+1mwKjYBNYkvXw6D2SICERLNM2Yxg9jMAoUSj+fPZAKx
	hQUsJHZsPMYIYrMIqErMXzYBrJ5XwFbi9tteRghbUOLH5HssEL1aEpu3NbFC2PISm9e8BZrJ
	AXSRusSjv7oQq/Qk1ky8C1UuIrHvxTvGCYwCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIzgwn0nvYFzVYHGIUYCDUYmH95aBfIAQa2JZcWXuIUYJDmYlEd7e
	ZqAQb0piZVVqUX58UWlOavEhRmkOFiVxXhPvr/5CAumJJanZqakFqUUwWSYOTqkGxpl9m19K
	rfqze8XGE18PyUnl8z4p3T1lV6zxXKGMRZdfx63xN+/703L9oH9NoIp0sYrYhLSzInUyLeLi
	a98Lv7u2+6dkWyVbl8jPGxE7skp3958Jf/2Q9TqneJE2q3Z6vaBS4PYljecX2l2bVv/ImPn5
	PWfv89s/qCvddGD9prh49kKlktU7fJRYijMSDbWYi4oTATM1oTpIAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes goto out, which makes code a bit smaller.

Cc: Jin Park <jinyoungp@nvidia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/aat2870_bl.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
index 7ff7522..619a1e0 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -135,14 +135,12 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform data\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	if (pdev->id != AAT2870_ID_BL) {
 		dev_err(&pdev->dev, "Invalid device ID, %d\n", pdev->id);
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	aat2870_bl = devm_kzalloc(&pdev->dev,
@@ -151,8 +149,7 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 	if (!aat2870_bl) {
 		dev_err(&pdev->dev,
 			"Failed to allocate memory for aat2870 backlight\n");
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
@@ -163,8 +160,7 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev,
 			"Failed allocate memory for backlight device\n");
-		ret = PTR_ERR(bd);
-		goto out;
+		return PTR_ERR(bd);
 	}
 
 	aat2870_bl->pdev = pdev;
@@ -201,7 +197,6 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 
 out_bl_dev_unregister:
 	backlight_device_unregister(bd);
-out:
 	return ret;
 }
 
-- 
1.7.1


