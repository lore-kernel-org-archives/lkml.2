Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2KDNAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:00:24 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42448 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2KDNAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:00:19 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 05/13] HW-latency: Add CPU field in sample output
Date: Sun,  4 Nov 2012 20:59:36 -0500
Message-Id: <1352080784-30839-6-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The filed tells user the sample is from which cpu.

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 drivers/misc/hw_latency_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
index 4303644..256b1c0 100644
--- a/drivers/misc/hw_latency_test.c
+++ b/drivers/misc/hw_latency_test.c
@@ -124,11 +124,13 @@ static struct sample *buffer_get_sample(struct sample *sample)
 static int buffer_add_sample(u64 sample)
 {
 	int ret = 0;
+	unsigned int cpu = smp_processor_id();
 
 	if (sample > data.threshold) {
 		struct sample s;
 
 		data.count++;
+		s.cpu = cpu;
 		s.seqnum = data.count;
 		s.duration = sample;
 		s.timestamp = CURRENT_TIME;
@@ -615,7 +617,8 @@ static ssize_t debug_sample_fread(struct file *filp, char __user *ubuf,
 			goto out;
 		}
 	}
-	len = snprintf(buf, sizeof(buf), "%010lu.%010lu\t%llu\n",
+	len = snprintf(buf, sizeof(buf), "[%d]%010lu.%010lu\t%llu\n",
+			sample->cpu,
 			sample->timestamp.tv_sec,
 			sample->timestamp.tv_nsec,
 			sample->duration);
-- 
1.7.12.1

