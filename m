Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab0J1LON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:14:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59426 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0J1LOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gelC5jo41YXy0jXjrDx49CT6VePyXEVVoiG7af+itnQ0I2Z9hGmQ2BOizdXS0lWAav
         ZGLWkITsmMjr4wVBPdejPOP0O/Jv//+3zk42HMp9+/lujUSjaqsb0997OmYarnbtsbD+
         Nyew+i35SCoNDo5ttmz0BBJWL79CoRLWls5a0=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Liu Hong <hong.liu@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Kalhan Trisal <kalhan.trisal@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] misc: isl29020: fix signedness bug
Date: Thu, 28 Oct 2010 15:14:03 +0400
Message-Id: <1288264443-10627-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_smbus_write_byte_data() may return negative error code.  This is not
seen to als_sensing_range_store() as the result is stored in unsigned int.
Made it signed.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/misc/isl29020.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index 34fe835..629d31e 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -87,7 +87,7 @@ static ssize_t als_sensing_range_store(struct device *dev,
 		struct device_attribute *attr, const  char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	unsigned int ret_val;
+	int ret_val;
 	unsigned long val;
 
 	if (strict_strtoul(buf, 10, &val))
-- 
1.7.0.4

