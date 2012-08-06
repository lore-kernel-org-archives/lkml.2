Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab2HFEn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:43:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44512 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2HFEnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:43:55 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-ce-501f4b898c43
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Ashish Jangam'" <ashish.jangam@kpitcummins.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] backlight: da9052: Use usleep_range() instead of msleep()
 for small sleeps
Date: Mon, 06 Aug 2012 13:43:53 +0900
Message-id: <002c01cd738e$14a880b0$3df98210$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1zjhRxChTNF6bmT0WQwuhda3lWtA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd1Ob/kAg41nZC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGy/PvWQv2sFUcWXeJuYFxF2sXIweHhICJxIQ/Yl2MnECmmMSF
	e+vZuhi5OIQEFjFK7Lt/EMqZzSTRu+0pI0gVm4CaxJcvh9lBbBGBCInmGbOYQYqYBRoZJVZe
	3MMMkhAWSJS48PkYE4jNIqAq8WA3hM0rYCvxfPFBFghbUOLH5HtgNrOAlsTmbU2sELa8xOY1
	b5khrlOXePRXF2KXnsTVS/sYIUpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBAfmM6kdjCsbLA4xCnAwKvHw3jSQDxBiTSwrrsw9xCjBwawk
	wpvuLBcgxJuSWFmVWpQfX1Sak1p8iFGag0VJnNfY+6u/kEB6YklqdmpqQWoRTJaJg1OqgVHs
	5eR1cbunGbLdUIv9oXpjtu2tnK2LZ6/5u0hTykeaYeOFtTvrl5YfTp1vlSRoejacwXXLRn7j
	uu86Zxe4nAlM/izy77LjhfMP2A5dl9y3pcNSht1tUeuGszu8XbdFvprkvcbguPVer4NMNR/f
	ammIZDUox9oJHp3cY22ftVo2ct29vD7+relKLMUZiYZazEXFiQBcGSlQSAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since msleep might not sleep for the desired amount when less
than 20ms, use usleep_range.

Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/da9052_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
index b628d68..10485c9 100644
--- a/drivers/video/backlight/da9052_bl.c
+++ b/drivers/video/backlight/da9052_bl.c
@@ -72,7 +72,7 @@ static int da9052_adjust_wled_brightness(struct da9052_bl *wleds)
 	if (ret < 0)
 		return ret;
 
-	msleep(10);
+	usleep_range(10000, 11000);
 
 	if (wleds->brightness) {
 		ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg],
-- 
1.7.1


