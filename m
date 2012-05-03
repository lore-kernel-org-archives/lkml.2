Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab2ECWNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:13:08 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36668 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2ECWNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:13:06 -0400
To: gregkh@linuxfoundation.org
Subject: [PATCH] driver-core: fix DEVICE_INT_ATTR to use correct show/store functions
Cc: linux-kernel@vger.kernel.org
Message-Id: <20120503220747.7B1E88095E@fiasco.mtv.corp.google.com>
Date: Thu,  3 May 2012 15:07:47 -0700 (PDT)
From: md@google.com (Michael Davidson)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] driver-core: fix DEVICE_INT_ATTR to use correct show/store functions

DEVICE_INT_ATTR() should use device_show_int() and device_store_int()
not device_show_ulong() and device_store_ulong()

Signed-off-by: Michael Davidson <md@google.com>
---

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -508,7 +508,7 @@ ssize_t device_store_int(struct device *
 		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
 #define DEVICE_INT_ATTR(_name, _mode, _var)  	struct dev_ext_attribute dev_attr_##_name = -		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
+		{ __ATTR(_name, _mode, device_show_int, device_store_int), &(_var) }
 
 extern int device_create_file(struct device *device,
 			      const struct device_attribute *entry);
