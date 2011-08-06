Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab1HFW2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 18:28:09 -0400
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:57647 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709Ab1HFW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 18:28:04 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Anssi Hannula <anssi.hannula@iki.fi>
To: dmitry.torokhov@gmail.com
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] [media] ati_remote: parent input devices to usb interface
Date: Sun,  7 Aug 2011 01:18:09 +0300
Message-Id: <1312669093-23771-4-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1312669093-23771-1-git-send-email-anssi.hannula@iki.fi>
References: <4E3DB2C2.7040104@iki.fi>
 <1312669093-23771-1-git-send-email-anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parent the input devices to usb_interface instead of usb_device. This
fixes (at least) persistent input device nodes.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
---
 drivers/media/rc/ati_remote.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index a1df21f..842dee4 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -693,7 +693,7 @@ static void ati_remote_input_init(struct ati_remote *ati_remote)
 	idev->phys = ati_remote->mouse_phys;
 
 	usb_to_input_id(ati_remote->udev, &idev->id);
-	idev->dev.parent = &ati_remote->udev->dev;
+	idev->dev.parent = &ati_remote->interface->dev;
 }
 
 static void ati_remote_rc_init(struct ati_remote *ati_remote)
@@ -712,7 +712,7 @@ static void ati_remote_rc_init(struct ati_remote *ati_remote)
 	rdev->input_phys = ati_remote->rc_phys;
 
 	usb_to_input_id(ati_remote->udev, &rdev->input_id);
-	rdev->dev.parent = &ati_remote->udev->dev;
+	rdev->dev.parent = &ati_remote->interface->dev;
 
 	rdev->map_name = RC_MAP_ATI_X10;
 }
-- 
1.7.4.4

