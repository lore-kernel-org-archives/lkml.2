Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2EHTIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:08:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44777 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754204Ab2EHTIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:08:46 -0400
Date: Tue, 8 May 2012 15:08:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] device core: fix a copy-paste error
Message-ID: <Pine.LNX.4.44L0.1205081507010.1164-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1552) fixes a fairly obvious copy-paste error that could
have serious consequences on architectures where sizeof(int) !=
sizeof(unsigned long).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>

---

This just caught my eye while I was adding another macro immediately
below DEVICE_INT_ATTR.


 include/linux/device.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: usb-3.4/include/linux/device.h
===================================================================
--- usb-3.4.orig/include/linux/device.h
+++ usb-3.4/include/linux/device.h
@@ -502,7 +502,7 @@ ssize_t device_store_int(struct device *
 		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
 #define DEVICE_INT_ATTR(_name, _mode, _var) \
 	struct dev_ext_attribute dev_attr_##_name = \
-		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
+		{ __ATTR(_name, _mode, device_show_int, device_store_int), &(_var) }
 
 extern int device_create_file(struct device *device,
 			      const struct device_attribute *entry);

