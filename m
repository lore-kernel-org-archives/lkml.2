Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab2HFEor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:44:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17547 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2HFEoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:44:46 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-dc-501f4bbc7e7c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Haavard Skinnemoen'" <hskinnemoen@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 2/3] backlight: ltv350qv: Use usleep_range() instead of
 msleep() for small sleeps
Date: Mon, 06 Aug 2012 13:44:44 +0900
Message-id: <002d01cd738e$334a25a0$99de70e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1zjjM0qzJKAtnMQjie3lKYSaw+NA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd093vIBBnvvmltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mzh3vWQr6uCtmrdrE3sC4kLOLkZNDQsBE4tuel6wQtpjEhXvr
	2boYuTiEBBYxSrT8vMgK4cxmktj/8CATSBWbgJrEly+H2UFsEYEIieYZs5i7GDk4mAXqJDZ9
	TgcxhQWSJQ4vLAKpYBFQlTh1fS1YNa+ArcT5iVdYIWxBiR+T77GA2MwCWhKbtzWxQtjyEpvX
	vAWbKCGgLvHory7EIj2JRws3QZWISOx78Y5xAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECA7KZ1I7GFc2WBxiFOBgVOLhvWkgHyDEmlhWXJl7iFGCg1lJ
	hDfdWS5AiDclsbIqtSg/vqg0J7X4EKM0B4uSOK+x91d/IYH0xJLU7NTUgtQimCwTB6dUA+Px
	HX87EzJCmrXOzvt5+onmK70+ubf3kpoe5DkbRpxVvblxBmv5y4PHDt5bHe242cgg4OzRp1v4
	P/1+s1EykOnL/Sqdx1wzdp7QV567RtPu2q0Dkcy/9xb8OP1R73ZUV12TwHv7o1t2y856FOfW
	dfuiwPnHS2t0P0wLa54yt0B+6SWpwpsNFl/fK7EUZyQaajEXFScCAMnDbcNGAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since msleep might not sleep for the desired amount when less
than 20ms, use usleep_range.

Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ltv350qv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index 6c0f1ac..4066a5b 100644
--- a/drivers/video/backlight/ltv350qv.c
+++ b/drivers/video/backlight/ltv350qv.c
@@ -75,7 +75,7 @@ static int ltv350qv_power_on(struct ltv350qv *lcd)
 	/* Power On Reset Display off State */
 	if (ltv350qv_write_reg(lcd, LTV_PWRCTL1, 0x0000))
 		goto err;
-	msleep(15);
+	usleep_range(15000, 16000);
 
 	/* Power Setting Function 1 */
 	if (ltv350qv_write_reg(lcd, LTV_PWRCTL1, LTV_VCOM_DISABLE))
@@ -153,7 +153,7 @@ err_settings:
 err_power2:
 err_power1:
 	ltv350qv_write_reg(lcd, LTV_PWRCTL2, 0x0000);
-	msleep(1);
+	usleep_range(1000, 1100);
 err:
 	ltv350qv_write_reg(lcd, LTV_PWRCTL1, LTV_VCOM_DISABLE);
 	return -EIO;
@@ -175,7 +175,7 @@ static int ltv350qv_power_off(struct ltv350qv *lcd)
 	ret |= ltv350qv_write_reg(lcd, LTV_PWRCTL2, 0x0000);
 
 	/* Wait at least 1 ms */
-	msleep(1);
+	usleep_range(1000, 1100);
 
 	/* Power down setting 2 */
 	ret |= ltv350qv_write_reg(lcd, LTV_PWRCTL1, LTV_VCOM_DISABLE);
-- 
1.7.1


