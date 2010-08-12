Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906Ab0HLPoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:44:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62137 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760252Ab0HLPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:42:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 12 Aug 2010 17:43:50 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv8 07/13] usb: gadget: storage: remove nofua file when unbinding
In-reply-to: <9737a711d395932c8803511ba581722d46be5292.1281625724.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Message-id: <f07e8ff5f36d5893e62764b9e372da0cc305a2b5.1281625724.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1281625724.git.m.nazarewicz@samsung.com>
 <76f0f5732bfbbb36d50baf05ecdd12bec3396275.1281625724.git.m.nazarewicz@samsung.com>
 <313ee18ecf53fb8f1c040656b697de869f0c0856.1281625724.git.m.nazarewicz@samsung.com>
 <48e2d6507f004252a012cf25bc0a06e5cb69808f.1281625724.git.m.nazarewicz@samsung.com>
 <f2f6babb8b593d5c6f6141604bd647658d59f124.1281625724.git.m.nazarewicz@samsung.com>
 <4addd8199cfd6a2aa582904cd6efa01bc77a5290.1281625724.git.m.nazarewicz@samsung.com>
 <9737a711d395932c8803511ba581722d46be5292.1281625724.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attr_nofua file was created during fsg_bind() but
was never removed.  Made it a bit more symmetrical and added
code to remove the file in fsg_unbind().

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Acked-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/usb/gadget/file_storage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index a857b7a..ab77792 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3178,6 +3178,7 @@ static void /* __init_or_exit */ fsg_unbind(struct usb_gadget *gadget)
 	for (i = 0; i < fsg->nluns; ++i) {
 		curlun = &fsg->luns[i];
 		if (curlun->registered) {
+			device_remove_file(&curlun->dev, &dev_attr_nofua);
 			device_remove_file(&curlun->dev, &dev_attr_ro);
 			device_remove_file(&curlun->dev, &dev_attr_file);
 			fsg_lun_close(curlun);
-- 
1.7.1

