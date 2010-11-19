Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab0KSXdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:33:37 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:42961 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0KSXdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:33:36 -0500
From: Jef Driesen <jefdriesen@telenet.be>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jef Driesen <jefdriesen@telenet.be>
Subject: [PATCH] USB: g_serial: Allow to override the default VID/PID
Date: Sat, 20 Nov 2010 00:32:34 +0100
Message-Id: <1290209554-7026-1-git-send-email-jefdriesen@telenet.be>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4CE6F807.1090607@telenet.be>
References: <4CE6F807.1090607@telenet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Override the default VID/PID if custom values are supplied through the
idVendor and idProduct kernel module parameters.

Signed-off-by: Jef Driesen <jefdriesen@telenet.be>
---
 drivers/usb/gadget/serial.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index f46a609..77b410e 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -271,6 +271,11 @@ static int __init init(void)
 	}
 	strings_dev[STRING_DESCRIPTION_IDX].s = serial_config_driver.label;
 
+	if (idVendor)
+		device_desc.idVendor = idVendor;
+	if (idProduct)
+		device_desc.idProduct = idProduct;
+
 	return usb_composite_register(&gserial_driver);
 }
 module_init(init);
-- 
1.7.1

