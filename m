Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0KAJWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:22:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38856 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab0KAJWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=B/ESLXJR7VucszrYxqdMBW4+eBrOFQkw8y3S0xQwBN/s1ZSNcuSNQRaZtARfiM6KiD
         mLIHaPlkwb3LovY7xDLUHyuHKFOlH0RkUfFzYRHbgJAPqBHLG/3hL1vE+B1JkjeSn6eU
         boMI3ur5U15U19WL17JZjC3Qvce9sZy6uaPxQ=
Subject: [PATCH] V4L/DVB: tea6415c: return -EIO if i2c_check_functionality
	fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain
Date: Mon, 01 Nov 2010 17:25:39 +0800
Message-Id: <1288603539.3831.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the adapter does not support I2C_FUNC_SMBUS_WRITE_BYTE,
return -EIO instead of 0.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/media/video/tea6415c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
index 3e99cea..19621ed 100644
--- a/drivers/media/video/tea6415c.c
+++ b/drivers/media/video/tea6415c.c
@@ -148,7 +148,7 @@ static int tea6415c_probe(struct i2c_client *client,
 
 	/* let's see whether this adapter can support what we need */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WRITE_BYTE))
-		return 0;
+		return -EIO;
 
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
-- 
1.7.2



