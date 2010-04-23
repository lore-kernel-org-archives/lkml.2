Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0DWAPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 20:15:34 -0400
Received: from kroah.org ([198.145.64.141]:41149 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab0DWAPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 20:15:08 -0400
Subject: patch staging-iio-function-iio_get_new_idr_val-return-negative-value-if-fails.patch added to gregkh-2.6 tree
To: sonic.adi@gmail.com, gregkh@suse.de, greg@kroah.com, jic23@cam.ac.uk,
       linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 22 Apr 2010 17:13:20 -0700
In-Reply-To: <4BA76219.4030606@cam.ac.uk>
Message-ID: <12719816003115@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: iio: Function iio_get_new_idr_val() return negative value if fails.

to my gregkh-2.6 tree.  Its filename is

    staging-iio-function-iio_get_new_idr_val-return-negative-value-if-fails.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From jic23@cam.ac.uk  Thu Apr 22 16:40:17 2010
From: Sonic Zhang <sonic.adi@gmail.com>
Date: Mon, 22 Mar 2010 12:27:05 +0000
Subject: staging: iio: Function iio_get_new_idr_val() return negative value if fails.
To: sonic zhang <sonic.adi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,  linux-iio <linux-iio@vger.kernel.org>, Greg KH <greg@kroah.com>
Message-ID: <4BA76219.4030606@cam.ac.uk>


Function iio_get_new_idr_val() return negative value if fails.
So, only error when ret < 0 in iio_device_register_eventset().

Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/iio/industrialio-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -537,6 +537,7 @@ static void iio_device_unregister_sysfs(
 	sysfs_remove_group(&dev_info->dev.kobj, dev_info->attrs);
 }
 
+/* This function return negative value if fails. */
 int iio_get_new_idr_val(struct idr *this_idr)
 {
 	int ret;
@@ -660,7 +661,7 @@ static int iio_device_register_eventset(
 	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
 		dev_info->event_interfaces[i].owner = dev_info->driver_module;
 		ret = iio_get_new_idr_val(&iio_event_idr);
-		if (ret)
+		if (ret < 0)
 			goto error_free_setup_ev_ints;
 		else
 			dev_info->event_interfaces[i].id = ret;

