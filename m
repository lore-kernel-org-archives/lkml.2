Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab0HIPDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:03:34 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62633 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab0HIPBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:01:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 09 Aug 2010 17:02:32 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv7 7/8] usb: gadget: storage: remove nofua file when unbinding
In-reply-to: <dadbebba90720630077702d19240acca9fdb2182.1281365237.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Message-id: <1a8a7e76daf68acaeecf4334848703318355a3a2.1281365237.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1281365237.git.m.nazarewicz@samsung.com>
 <49ebe5a39e05aa55a19d33a2141736d215873f86.1281365237.git.m.nazarewicz@samsung.com>
 <b4fe56570ecb77ec6acbab4502f7ad87b72885e1.1281365237.git.m.nazarewicz@samsung.com>
 <9219d2c4e7b60f2ad1455b6c702604e84ef90e1b.1281365237.git.m.nazarewicz@samsung.com>
 <fd2e70a236743436c0c2e88eb3b32e4564571e32.1281365237.git.m.nazarewicz@samsung.com>
 <e37b282da3898486df3fc33cbb1de5e1b6bc26c3.1281365237.git.m.nazarewicz@samsung.com>
 <dadbebba90720630077702d19240acca9fdb2182.1281365237.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attr_nofua file was created during fsg_bind() but
was never removed.  Made it a bit more symmetrical and added
code to remove the file in fsg_unbind().

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
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

