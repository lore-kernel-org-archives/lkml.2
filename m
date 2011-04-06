Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1DFCq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 22:46:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58122 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab1DFCqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 22:46:53 -0400
From: Sonny Rao <sonnyrao@chromium.org>
To: jic23@cam.ac.uk
Cc: linux-pm@lists.linux-foundation.org, bleung@chromium.org,
        snanda@chromium.org, Sonny Rao <sonnyrao@chromium.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Phillip Kurtenbach <pkurtenbach@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Enable async suspend/resume on industrial IO devices
Date: Tue,  5 Apr 2011 19:45:14 -0700
Message-Id: <1302057915-13549-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Industrial I/O devices can sometimes take a long time to resume,
allowing them to be asynchronus saves 50ms on one light sensor

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>

---
 drivers/staging/iio/industrialio-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 768f448..a4b099f 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -811,6 +811,8 @@ int iio_device_register(struct iio_dev *dev_info)
 	if (dev_info->modes & INDIO_RING_TRIGGERED)
 		iio_device_register_trigger_consumer(dev_info);
 
+	device_enable_async_suspend(&dev_info->dev);
+
 	return 0;
 
 error_free_sysfs:
-- 
1.7.2.3

