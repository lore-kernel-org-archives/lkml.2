Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0JVL6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:58:23 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:30376 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab0JVL6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:58:19 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        jic23@cam.ac.uk
Cc: lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] hwmon: lis3: Update coordinates at polled device open
Date: Fri, 22 Oct 2010 14:57:26 +0300
Message-Id: <1287748654-2626-5-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call input device poll function at device open to refresh coordinates
immediately. This is needed for the case where poll interval is set to
zero and coordinate updates happens purely under interrupt control.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index fe97390..e2e0bb4 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -312,6 +312,11 @@ static void lis3lv02d_joystick_open(struct input_polled_dev *pidev)
 
 	if (lis3_dev.pdata && lis3_dev.whoami == WAI_8B && lis3_dev.idev)
 		atomic_set(&lis3_dev.wake_thread, 1);
+	/*
+	 * Update coordinates for the case where poll interval is 0 and
+	 * the chip in running purely under interrupt control
+	 */
+	lis3lv02d_joystick_poll(pidev);
 }
 
 static void lis3lv02d_joystick_close(struct input_polled_dev *pidev)
-- 
1.6.0.4

