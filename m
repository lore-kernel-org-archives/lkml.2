Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab2F1NM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:12:29 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47959 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab2F1NIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:08:30 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 08/23 v6] Input: atmel_mxt_ts - print less overhead when dumping objects
Date: Thu, 28 Jun 2012 21:08:09 +0800
Message-Id: <1340888904-15620-9-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conserve limited (PAGE_SIZE) sysfs output buffer space by only showing
readable objects and not printing the object's index, which is not useful
to userspace.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 94dd1d1..c8cfd7b 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -897,15 +897,11 @@ static ssize_t mxt_object_show(struct device *dev,
 	for (i = 0; i < data->info.object_num; i++) {
 		object = data->object_table + i;
 
-		count += scnprintf(buf + count, PAGE_SIZE - count,
-				"Object[%d] (Type %d)\n",
-				i + 1, object->type);
-
-		if (!mxt_object_readable(object->type)) {
-			count += scnprintf(buf + count, PAGE_SIZE - count,
-					"\n");
+		if (!mxt_object_readable(object->type))
 			continue;
-		}
+
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				"T%u:\n", object->type);
 
 		error = __mxt_read_reg(data->client, object->start_address,
 				object->size + 1, obuf);
-- 
1.7.7.3

