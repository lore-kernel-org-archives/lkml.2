Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab0DFGAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 02:00:08 -0400
Received: from smtp.nokia.com ([192.100.122.233]:45488 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab0DFF7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:59:21 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [RESEND PATCH v2 6/6] lis3: Setup poll interval limits
Date: Tue,  6 Apr 2010 08:58:45 +0300
Message-Id: <1270533525-15312-7-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Apr 2010 05:59:03.0659 (UTC) FILETIME=[42B1BBB0:01CAD54E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set valid adjustment window (0 - 2000ms).

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/lis3lv02d.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 56a1d34..6138f03 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -41,6 +41,8 @@
 
 /* joystick device poll interval in milliseconds */
 #define MDPS_POLL_INTERVAL 50
+#define MDPS_POLL_MIN	   0
+#define MDPS_POLL_MAX	   2000
 /*
  * The sensor can also generate interrupts (DRDY) but it's pretty pointless
  * because they are generated even if the data do not change. So it's better
@@ -459,6 +461,8 @@ int lis3lv02d_joystick_enable(void)
 
 	lis3_dev.idev->poll = lis3lv02d_joystick_poll;
 	lis3_dev.idev->poll_interval = MDPS_POLL_INTERVAL;
+	lis3_dev.idev->poll_interval_min = MDPS_POLL_MIN;
+	lis3_dev.idev->poll_interval_max = MDPS_POLL_MAX;
 	input_dev = lis3_dev.idev->input;
 
 	input_dev->name       = "ST LIS3LV02DL Accelerometer";
-- 
1.6.0.4

