Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab2EUTj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:39:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244Ab2EUTj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:39:58 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] usb-hid-core: Set intfdata to NULL if probe fails
Date: Mon, 21 May 2012 21:39:36 +0200
Message-Id: <1337629176-1624-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having a dangling pointer in intfdata is no good, and may actually bite
other drivers which rely on frameworks which only call dev_set_drvdata
on the interface's device if no drvdata has been set (which is how I
found out that usb-hid-core leaves the dangling pointer in there).

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/hid/usbhid/hid-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 5bf91db..70d760f 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1296,6 +1296,7 @@ err_free:
 	kfree(usbhid);
 err:
 	hid_destroy_device(hid);
+	usb_set_intfdata(intf, NULL);
 	return ret;
 }
 
-- 
1.7.10

