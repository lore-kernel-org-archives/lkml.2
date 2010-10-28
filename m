Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab0J1LOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:14:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59426 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0J1LOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H4WH0Jq3Bs6cfliPTV6zByBPLH6LlqGSK7T1yiJoW35vkzmjw0QBLVrVBFvlMdZwKy
         FO2TT7OWXpDxBMc4/+rZdcjYzdb30kBlYJOsCoWWu38xc3ONrjcmH6Vbrk7w1/pyvTmT
         8TzSkfgnoa2YMBNxw2zqhzoBkTiLWvmw8jOsQ=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hong Liu <hong.liu@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Anantha Narayanan <anantha.narayanan@intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] misc: apds9802als: fix signedness bug
Date: Thu, 28 Oct 2010 15:13:58 +0400
Message-Id: <1288264438-10578-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_smbus_read_byte_data() may return negative error code.  This is not
seen to als_sensing_range_store() as the result is stored in unsigned int.
Made it signed.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/misc/apds9802als.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index f9b91ba..0ed0935 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -123,7 +123,7 @@ static ssize_t als_sensing_range_store(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct als_data *data = i2c_get_clientdata(client);
-	unsigned int ret_val;
+	int ret_val;
 	unsigned long val;
 
 	if (strict_strtoul(buf, 10, &val))
-- 
1.7.0.4

