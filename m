Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2DRNYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:24:36 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:64100 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2DRNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:22:04 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 02/14 v3] Input: atmel_mxt_ts - only allow root to update firmware
Date: Wed, 18 Apr 2012 21:21:47 +0800
Message-Id: <1334755319-21365-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restrict permissions on the update_fw sysfs entry to read only for root
only.

Also, update object permission to use a macro S_IRUGO macro instead of
hard coded 0444.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
Acked-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 0a6e368..15ae6fd 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1049,8 +1049,8 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(object, 0444, mxt_object_show, NULL);
-static DEVICE_ATTR(update_fw, 0664, NULL, mxt_update_fw_store);
+static DEVICE_ATTR(object, S_IRUGO, mxt_object_show, NULL);
+static DEVICE_ATTR(update_fw, S_IWUSR, NULL, mxt_update_fw_store);
 
 static struct attribute *mxt_attrs[] = {
 	&dev_attr_object.attr,
-- 
1.7.7.3

