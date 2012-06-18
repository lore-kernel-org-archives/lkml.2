Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2FREMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:12:16 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:50931 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2FREIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:08:49 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 08/22 v4] Input: atmel_mxt_ts - print less overhead when dumping objects
Date: Mon, 18 Jun 2012 12:08:28 +0800
Message-Id: <1339992522-22073-9-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
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
index 8c99d6d..65fd89b 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -896,15 +896,11 @@ static ssize_t mxt_object_show(struct device *dev,
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

