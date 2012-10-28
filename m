Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab2J1IL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:11:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34093 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755757Ab2J1IKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:10:12 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Subject: [PATCH 13/16] usb: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:51 -0700
Message-Id: <204c1949c94ee5d84aaa60770ead880b9aead14f.1351411048.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/core/hub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 5b131b6..fbaf3c3 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2055,7 +2055,7 @@ static void show_string(struct usb_device *udev, char *id, char *string)
 {
 	if (!string)
 		return;
-	dev_printk(KERN_INFO, &udev->dev, "%s: %s\n", id, string);
+	dev_info(&udev->dev, "%s: %s\n", id, string);
 }
 
 static void announce_device(struct usb_device *udev)
-- 
1.7.8.112.g3fd21

