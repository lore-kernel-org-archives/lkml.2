Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab2KDNBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:01:11 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63898 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2KDNBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:01:06 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 13/13] HW-latency: some sample data format change
Date: Sun,  4 Nov 2012 20:59:44 -0500
Message-Id: <1352080784-30839-14-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some trival format changes

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 drivers/misc/hw_latency_test.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
index 0b79b5e..549ea13 100644
--- a/drivers/misc/hw_latency_test.c
+++ b/drivers/misc/hw_latency_test.c
@@ -671,13 +671,15 @@ static ssize_t debug_sample_fread(struct file *filp, char __user *ubuf,
 			goto out;
 		}
 	}
+
 	len = snprintf(buf, sizeof(buf), "[%d]%010lu.%010lu\t%llu%2s\t[%llx]\n",
 			sample->cpu,
 			sample->timestamp.tv_sec,
 			sample->timestamp.tv_nsec,
 			sample->duration,
 			sample->unit ? "us":"ns",
-			sample->addr);
+			(((u64) (current_sample_func->get_sample)
+				== (u64) get_mem_sample) ? sample->addr: 0));
 	if (len > cnt)
 		goto out;
 	if (copy_to_user(ubuf, buf,len))
-- 
1.7.12.1

