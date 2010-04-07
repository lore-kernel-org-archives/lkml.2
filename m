Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab0DGPEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:04:07 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58349 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab0DGPEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=u6DDiotGEsGM6gQaZEZztrKSp7yBWnBupRv+NkJP9iERMF7UwxY9G1zNH7CyqFfFdD
         J8jduMaNJAQ2Ckp2vJSSbAAz//S0UXeoArismc7szdsZcn1ALHEFxrjRjk0EdTqexb5p
         16hD6TsMovtaUEwisfgvAaAOHhSBsPKRvdAzA=
From: yauhen.kharuzhy@promwad.com
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
Subject: [PATCH] IIO: Fix adding more than one iio device eventset
Date: Wed,  7 Apr 2010 18:03:45 +0300
Message-Id: <1270652625-30640-1-git-send-email-yauhen.kharuzhy@promwad.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>

iio_get_new_idr_val() returns new id, but this value was checked as
usual error code.

Also fix typo in sysfs attribute name generation, seems that this name
should be unique.

Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
---
 drivers/staging/iio/industrialio-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index b456dfc..8d33584 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -659,7 +659,7 @@ static int iio_device_register_eventset(struct iio_dev *dev_info)
 	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
 		dev_info->event_interfaces[i].owner = dev_info->driver_module;
 		ret = iio_get_new_idr_val(&iio_event_idr);
-		if (ret)
+		if (ret < 0)
 			goto error_free_setup_ev_ints;
 		else
 			dev_info->event_interfaces[i].id = ret;
@@ -685,7 +685,7 @@ static int iio_device_register_eventset(struct iio_dev *dev_info)
 
 	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
 		snprintf(dev_info->event_interfaces[i]._attrname, 20,
-			"event_line%d_sources", i);
+			"event_line%d_sources", dev_info->event_interfaces[i].id);
 		dev_info->event_attrs[i].name
 			= (const char *)
 			(dev_info->event_interfaces[i]._attrname);
-- 
1.6.6.1

