Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab2KICUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:20:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48793 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab2KICUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:20:36 -0500
Message-ID: <509C686F.20400@gmail.com>
Date: Fri, 09 Nov 2012 10:20:31 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, timo.teras@iki.fi,
        steffen.klassert@secunet.com, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v3 1/9] net: core: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

flush_tasklet is a struct, not a pointer in percpu var.
so use this_cpu_ptr to get the member pointer.

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 net/core/flow.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/core/flow.c b/net/core/flow.c
index e318c7e..b0901ee 100644
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
+	tasklet = this_cpu_ptr(&info->cache->percpu->flush_tasklet);
 	tasklet->data = (unsigned long)info;
 	tasklet_schedule(tasklet);
 }
-- 
1.7.1
