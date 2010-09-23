Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0IWOOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:14:15 -0400
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:55328 "EHLO
	homiemail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751592Ab0IWOOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:14:14 -0400
Subject: [PATCH] input: for best practices, return -ENOMEM instead of -1
 when returning on mem allocation errors
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: dmitry.torokhov@gmail.com, dtor@mail.ru
Cc: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 10:14:05 -0400
Message-ID: <1285251245.2127.4.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

input: for best practices, return -ENOMEM instead of -1 when returning on mem allocation errors.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/input/misc/powermate.c   |    2 +-
 drivers/input/mouse/elantech.c   |    2 +-
 drivers/input/mouse/synaptics.c  |    2 +-
 drivers/input/mouse/trackpoint.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/misc/powermate.c b/drivers/input/misc/powermate.c
index bf170f6..f459471 100644
--- a/drivers/input/misc/powermate.c
+++ b/drivers/input/misc/powermate.c
@@ -280,7 +280,7 @@ static int powermate_alloc_buffers(struct usb_device *udev, struct powermate_dev
 
 	pm->configcr = kmalloc(sizeof(*(pm->configcr)), GFP_KERNEL);
 	if (!pm->configcr)
-		return -1;
+		return -ENOMEM;
 
 	return 0;
 }
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 4831120..04d9bf3 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -699,7 +699,7 @@ int elantech_init(struct psmouse *psmouse)
 
 	psmouse->private = etd = kzalloc(sizeof(struct elantech_data), GFP_KERNEL);
 	if (!etd)
-		return -1;
+		return -ENOMEM;
 
 	etd->parity[0] = 1;
 	for (i = 1; i < 256; i++)
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 96b70a4..a79bc36 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -731,7 +731,7 @@ int synaptics_init(struct psmouse *psmouse)
 
 	psmouse->private = priv = kzalloc(sizeof(struct synaptics_data), GFP_KERNEL);
 	if (!priv)
-		return -1;
+		return -ENOMEM;
 
 	psmouse_reset(psmouse);
 
diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index 0643e49..54b2fa8 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -303,7 +303,7 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 
 	psmouse->private = kzalloc(sizeof(struct trackpoint_data), GFP_KERNEL);
 	if (!psmouse->private)
-		return -1;
+		return -ENOMEM;
 
 	psmouse->vendor = "IBM";
 	psmouse->name = "TrackPoint";
-- 
1.7.0.4



