Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1HYOHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:07:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60927 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1HYOHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:07:04 -0400
Subject: [PATCH] Input: cm109 - fix checking return value of usb_control_msg
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Alfred E. Heggestad" <aeh@db.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 22:06:50 +0800
Message-ID: <1314281210.5915.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If successful, usb_control_msg returns the number of bytes transferred,
otherwise a negative error number.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/misc/cm109.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index b09c7d1..b741338 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -475,7 +475,7 @@ static void cm109_toggle_buzzer_sync(struct cm109_dev *dev, int on)
 				le16_to_cpu(dev->ctl_req->wIndex),
 				dev->ctl_data,
 				USB_PKT_LEN, USB_CTRL_SET_TIMEOUT);
-	if (error && error != EINTR)
+	if ((error < 0) && (error != -EINTR))
 		err("%s: usb_control_msg() failed %d", __func__, error);
 }
 
-- 
1.7.4.1



