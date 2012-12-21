Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab2LUF1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:27:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41648 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUF1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:27:11 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-85-50d3f32e8b22
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
In-reply-to: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
Subject: [PATCH 6/6] backlight: omap1: use bl_get_data instead of
 dev_get_drvdata
Date: Fri, 21 Dec 2012 14:27:09 +0900
Message-id: <001501cddf3b$d2e68680$78b39380$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fO3udRdsnHWRmS2i/6pBmiWTW1AAAEujg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zY129z5cDDOYv5La4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZtybcYimYIFTxcwpPA+Na/i5GTg4JAROJzx82MkHYYhIX7q1n
	62Lk4hASWMYoMe/yZ+YuRg6womvfvCHiixglDvzazQLhzGaS2L1/IiNIN5uAmsSXL4fZQWwR
	gQiJ5hmzwJqZBXwkNs/SBAkLCdhKXJj0hRnE5hSwk+jc/QisVVggWKKlsxXMZhFQlVi14AQb
	iM0LVL9xB8R4XgFBiR+T77GA2MwCWhLrdx5ngrDlJTaveQt1p7rEo7+6EBcYSUxY/4IdokRE
	Yt+Ld1DjBSS+TT7EAlEuK7HpADPIJxICi9glGu9sYoWEg6TEwRU3WCYwSsxCsnkWks2zkGye
	hWTFAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxghUSW1g3Flg8UhRgEORiUeXkazywFC
	rIllxZW5hxglOJiVRHj9PwCFeFMSK6tSi/Lji0pzUosPMfoAXT6RWUo0OR8Y8Xkl8YbGxiZm
	JqYm5pam5qY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1MDopR+QpHG9OrP4f/7GzzuTT
	weS+38dKvbvaKua6yMRYm/O9P/bVaska/y/lgkd50nTOFW43Etvwhzl1iXV2s3LKLe2OXvPg
	H5OkLmd8yVFxnWi998mfpzMkYyamvmNa8eLKqtCa52Flj+ZvO79XgZNp/s7lZUziS8zaCssv
	fTGU3f1Ie+7ZLiWW4oxEQy3mouJEAHE0uubXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAV29z5cDDF7eYrW4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGbcm3GIpmCBU8XMKTwPj
	Wv4uRg4OCQETiWvfvLsYOYFMMYkL99azdTFycQgJLGKUOPBrNwuEM5tJYvf+iYwgVWwCahJf
	vhxmB7FFBCIkmmfMYgYZxCzgI7F5liZIWEjAVuLCpC/MIDangJ1E5+5HYK3CAsESLZ2tYDaL
	gKrEqgUn2EBsXqD6jTsgxvMKCEr8mHyPBcRmFtCSWL/zOBOELS+xec1bZoib1SUe/dWFuMBI
	YsL6F+wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGCY/aZ1A7GlQ0WhxgFOBiVeHgZzS4HCLEmlhVX5h5ilOBgVhLh9f8AFOJNSaysSi3K
	jy8qzUktPsToA/ToRGYp0eR8YDrJK4k3NDYxM7I0MrMwMjE3xyGsJM7b7JESICSQnliSmp2a
	WpBaBDOOiYNTqoHR8/xOh7Xfk/yPMAtPWfy+VPzN71OaKYevdAoJG+iYT/r6ia3y8NLAVIta
	h/ZfG5x3VK+7mRhYprZVIsg4sKp11+In3L39Ab+r/txjK5xqlvF0hpDJLe8TX2T3p0SVrZa7
	Zq0WESc0rz2oz9T4SPFtfq7VjVZ5H9aclV6W7JrKKcD2oOH7znglluKMREMt5qLiRAD3XaRk
	BgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev,
so we can directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/omap1_bl.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index af31c26..6271101 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -77,7 +77,7 @@ static void omapbl_blank(struct omap_backlight *bl, int mode)
 static int omapbl_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	omapbl_blank(bl, FB_BLANK_POWERDOWN);
 	return 0;
@@ -86,7 +86,7 @@ static int omapbl_suspend(struct platform_device *pdev, pm_message_t state)
 static int omapbl_resume(struct platform_device *pdev)
 {
 	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	omapbl_blank(bl, bl->powermode);
 	return 0;
@@ -98,7 +98,7 @@ static int omapbl_resume(struct platform_device *pdev)
 
 static int omapbl_set_power(struct backlight_device *dev, int state)
 {
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	omapbl_blank(bl, state);
 	bl->powermode = state;
@@ -108,7 +108,7 @@ static int omapbl_set_power(struct backlight_device *dev, int state)
 
 static int omapbl_update_status(struct backlight_device *dev)
 {
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	if (bl->current_intensity != dev->props.brightness) {
 		if (bl->powermode == FB_BLANK_UNBLANK)
@@ -124,7 +124,7 @@ static int omapbl_update_status(struct backlight_device *dev)
 
 static int omapbl_get_intensity(struct backlight_device *dev)
 {
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 	return bl->current_intensity;
 }
 
-- 
1.7.2.5


