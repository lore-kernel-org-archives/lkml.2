Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0CVKPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:15:22 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:8268 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab0CVKPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:15:19 -0400
X-IronPort-AV: E=Sophos;i="4.51,286,1267419600"; 
   d="scan'208";a="13342627"
Subject: [PATCH] iio: Function iio_get_new_idr_val() return negative value
	if fails.
From: sonic zhang <sonic.adi@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       linux-iio <linux-iio@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 22 Mar 2010 18:23:34 +0800
Message-ID: <1269253414.30009.5.camel@eight.analog.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Function iio_get_new_idr_val() return negative value if fails.
So, only error when ret < 0 in iio_device_register_eventset().

Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
---
 drivers/staging/iio/industrialio-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index b456dfc..dd9267c 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -536,6 +536,7 @@ static void iio_device_unregister_sysfs(struct iio_dev *dev_info)
 	sysfs_remove_group(&dev_info->dev.kobj, dev_info->attrs);
 }
 
+/* This function return negative value if fails. */
 int iio_get_new_idr_val(struct idr *this_idr)
 {
 	int ret;
@@ -659,7 +660,7 @@ static int iio_device_register_eventset(struct iio_dev *dev_info)
 	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
 		dev_info->event_interfaces[i].owner = dev_info->driver_module;
 		ret = iio_get_new_idr_val(&iio_event_idr);
-		if (ret)
+		if (ret < 0)
 			goto error_free_setup_ev_ints;
 		else
 			dev_info->event_interfaces[i].id = ret;
-- 
1.6.0



