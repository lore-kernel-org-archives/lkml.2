Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2HBKKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:10:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56195 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2HBKKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:10:19 -0400
Message-ID: <1343902209.1207.2.camel@phoenix>
Subject: [PATCH] iio: lm3533-als: Fix build warnings
From: Axel Lin <axel.lin@gmail.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Aug 2012 18:10:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build warnings:
  CC [M]  drivers/iio/light/lm3533-als.o
drivers/iio/light/lm3533-als.c:667:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/iio/light/lm3533-als.c:667:8: warning: (near initialization for 'dev_attr_in_illuminance0_thresh_either_en.show') [enabled by default]
drivers/iio/light/lm3533-als.c:667:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/iio/light/lm3533-als.c:667:8: warning: (near initialization for 'dev_attr_in_illuminance0_thresh_either_en.store') [enabled by default]

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/iio/light/lm3533-als.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/lm3533-als.c b/drivers/iio/light/lm3533-als.c
index c3e7bac..e45712a9 100644
--- a/drivers/iio/light/lm3533-als.c
+++ b/drivers/iio/light/lm3533-als.c
@@ -404,7 +404,7 @@ out:
 	return ret;
 }
 
-static int show_thresh_either_en(struct device *dev,
+static ssize_t show_thresh_either_en(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
@@ -424,7 +424,7 @@ static int show_thresh_either_en(struct device *dev,
 	return scnprintf(buf, PAGE_SIZE, "%u\n", enable);
 }
 
-static int store_thresh_either_en(struct device *dev,
+static ssize_t store_thresh_either_en(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
-- 
1.7.9.5



