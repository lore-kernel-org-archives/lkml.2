Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2KFIGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:06:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62525 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab2KFIGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:06:37 -0500
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mooney <mfm@muteddisk.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        "harvey.yang" <harvey.huawei.yang@gmail.com>
Subject: [PATCH 1/1] staging: usbip: put usb_device and kill event handler thread in error cleanups.
Date: Tue,  6 Nov 2012 16:10:29 +0800
Message-Id: <1352189429-3024-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: harvey.yang <harvey.huawei.yang@gmail.com>

If probe returns with error, the kthread is still alive even when all usbip modules unloaded. So do cleanups in error handler.

Signed-off-by: harvey.yang <harvey.huawei.yang@gmail.com>
---
 drivers/staging/usbip/stub_dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index c8d79a7..16a6868 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -432,6 +432,8 @@ static int stub_probe(struct usb_interface *interface,
 		dev_err(&interface->dev, "stub_add_files for %s\n", udev_busid);
 		usb_set_intfdata(interface, NULL);
 		usb_put_intf(interface);
+		usb_put_dev(udev);
+		kthread_stop_put(sdev->ud.eh);
 
 		busid_priv->interf_count = 0;
 		busid_priv->sdev = NULL;
-- 
1.7.1

