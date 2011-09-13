Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1IMLRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:17:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45486 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1IMLRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:17:14 -0400
From: Arvydas Sidorenko <asido4@gmail.com>
To: mchehab@infradead.org
Cc: asido4@gmail.com, hverkuil@xs4all.nl, arnd@arndb.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers/media/video/stk-webcam.c: webcam LED bug fix
Date: Tue, 13 Sep 2011 13:18:10 +0200
Message-Id: <1315912691-11227-1-git-send-email-asido4@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probem was on my DC-1125 webcam chip from Syntek. Whenever the webcam turns
on, the LED light on it is turn on also and never turns off again unless system
is shut downed or restarted.

This patch will fix this issue - the LED will be turned off whenever the device
is released.

Signed-off-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/video/stk-webcam.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index d1a2cef..859e78f 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -574,6 +574,8 @@ static int v4l_stk_release(struct file *fp)
 	if (dev->owner == fp) {
 		stk_stop_stream(dev);
 		stk_free_buffers(dev);
+		stk_camera_write_reg(dev, 0x0, 0x48); /* turn off the LED */
+		unset_initialised(dev);
 		dev->owner = NULL;
 	}
 
-- 
1.7.4.4

