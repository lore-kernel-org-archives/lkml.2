Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2HGJZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:25:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24520 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2HGJZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:25:13 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-fd-5020def8c7ec
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jin Park'" <jinyoungp@nvidia.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 2/3] backlight: aat2870: remove goto out
Date: Tue, 07 Aug 2012 18:25:12 +0900
Message-id: <000601cd747e$8c03c110$a40b4330$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac10fouf5dC9JeDeTYenYYEvFTqI0w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQd0f9xQCDNb1WFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MGX/nsRUs562YtL6brYHxPlcXIyeHhICJxOr+RkYIW0ziwr31
	bF2MXBxCAtMZJb7Pn80KkhASmM0kce+YLYjNJqAm8eXLYXYQW0QgQqJ5xixmEJtZoFDi8fyZ
	TCC2sIC1RMuSOWBxFgFVibkbprGB2LwCthLrjk1lh7AFJX5MvscC0aslsX7ncSYIW15i85q3
	QL0cQAepSzz6qwtiigjoSUxYGQBRISKx78U7xgmMArOQDJqFZNAsJINmIWlZwMiyilE0tSC5
	oDgpPddIrzgxt7g0L10vOT93EyM4KJ9J72Bc1WBxiFGAg1GJh3emikKAEGtiWXFl7iFGCQ5m
	JRHewzuBQrwpiZVVqUX58UWlOanFhxilOViUxHlNvL/6CwmkJ5akZqemFqQWwWSZODilGhj9
	Ai9t+bhyeZf+ivUy23kemZo+cNw7mznl30VfYZNmtgkbg7KjYvvWea9efjG2jfXEiUT3LS6L
	BSfrL1/gzrLTQjrwcPuKmfmfHocdvevA94UzxJZ91tT19yVjJDyOMixaa781d5X2oRW7bpVW
	s5xzVeiy1wr/cXpyaYRJcF5v2PnGyTXGG98qsRRnJBpqMRcVJwIAijb1DEYCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes goto out, which makes code a bit smaller.

Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Jinyoung Park <jinyoungp@nvidia.com>
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


