Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab2KBQDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:03:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58766 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab2KBQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:01:32 -0400
Message-ID: <5093EE47.20700@gmail.com>
Date: Sat, 03 Nov 2012 00:01:11 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, timo.teras@iki.fi,
        steffen.klassert@secunet.com, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v2 1/9] net: core: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

Signed-off-by: Shan Wei <davidshan@tencent.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
---
 net/core/flow.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/core/flow.c b/net/core/flow.c
index e318c7e..3bad824 100644
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -327,11 +327,9 @@ static void flow_cache_flush_tasklet(unsigned long data)
 static void flow_cache_flush_per_cpu(void *data)
 {
 	struct flow_flush_info *info = data;
-	int cpu;
 	struct tasklet_struct *tasklet;
 
-	cpu = smp_processor_id();
-	tasklet = &per_cpu_ptr(info->cache->percpu, cpu)->flush_tasklet;
+	tasklet = &this_cpu_ptr(info->cache->percpu)->flush_tasklet;
 	tasklet->data = (unsigned long)info;
 	tasklet_schedule(tasklet);
 }
-- 
1.7.1


