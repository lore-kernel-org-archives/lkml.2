Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2KDNAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:00:31 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49060 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2KDNAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:00:24 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 06/13] HW-latency: cycle through all online cpus to re-test cpufreq
Date: Sun,  4 Nov 2012 20:59:37 -0500
Message-Id: <1352080784-30839-7-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo to enable cycling through all online cpus to get cpufreq
sample from all cpus sequentially.

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 drivers/misc/hw_latency_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
index 256b1c0..78436da 100644
--- a/drivers/misc/hw_latency_test.c
+++ b/drivers/misc/hw_latency_test.c
@@ -297,7 +297,7 @@ static int kthread_fn(void *unused)
 			for_each_cpu(cpu, cpu_online_mask) {
 				cpumask_clear(testing_cpu_mask);
 				cpumask_set_cpu(cpu, testing_cpu_mask);
-				err = stop_machine(get_sample, unused, NULL);
+				err = stop_machine(get_sample, unused, testing_cpu_mask);
 				if (err)
 					break;
 			}
-- 
1.7.12.1

