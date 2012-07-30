Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2G3Tkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:40:42 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:53159 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab2G3Tkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:40:40 -0400
Date: Mon, 30 Jul 2012 21:38:59 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Cc: Jaya Kumar <jayalk@intworks.biz>, linux-fbdev@vger.kernel.org
Subject: [PATCH 6/7] HID: picoLCD: disable version check during probe
Message-ID: <20120730213859.063173c1@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120730213656.0a9f6d30@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4ea5454203d991ec85264f64f89ca8855fce69b0
[HID: Fix race condition between driver core and ll-driver] introduced
new locking around proce/remove functions that prevent any report/reply
from hardware to reach driver until it returned from probe.

As such, the ask-reply way to checking picoLCD firmware version during
probe is bound to timeout and let probe fail.

Disabling the check lets driver sucessfully probe again.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 2d7ef68..42d0791 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -478,13 +478,13 @@ static int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data *data)
 {
 	int error;
 
-	error = picolcd_check_version(hdev);
+/*	error = picolcd_check_version(hdev);
 	if (error)
 		return error;
 
 	if (data->version[0] != 0 && data->version[1] != 3)
 		hid_info(hdev, "Device with untested firmware revision, please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
-			 dev_name(&hdev->dev));
+			 dev_name(&hdev->dev)); */
 
 	/* Setup keypad input device */
 	error = picolcd_init_keys(data, picolcd_in_report(REPORT_KEY_STATE, hdev));
@@ -534,7 +534,7 @@ err:
 
 static int picolcd_probe_bootloader(struct hid_device *hdev, struct picolcd_data *data)
 {
-	int error;
+/*	int error;
 
 	error = picolcd_check_version(hdev);
 	if (error)
@@ -542,7 +542,7 @@ static int picolcd_probe_bootloader(struct hid_device *hdev, struct picolcd_data
 
 	if (data->version[0] != 1 && data->version[1] != 0)
 		hid_info(hdev, "Device with untested bootloader revision, please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
-			 dev_name(&hdev->dev));
+			 dev_name(&hdev->dev)); */
 
 	picolcd_init_devfs(data, NULL, NULL,
 			picolcd_out_report(REPORT_BL_READ_MEMORY, hdev),
-- 
1.7.8.6

