Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab2KBQB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:01:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58766 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2KBQB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:01:27 -0400
Message-ID: <5093EE4F.4030601@gmail.com>
Date: Sat, 03 Nov 2012 00:01:19 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: venkat.x.venkatsubra@oracle.com, David Miller <davem@davemloft.net>,
        rds-devel@oss.oracle.com, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v2 2/9] net: rds: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

Signed-off-by: Shan Wei <davidshan@tencent.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
---
 net/rds/ib_recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 8d19491..a4a5064 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -423,7 +423,7 @@ static void rds_ib_recv_cache_put(struct list_head *new_item,
 
 	local_irq_save(flags);
 
-	chp = per_cpu_ptr(cache->percpu, smp_processor_id());
+	chp = this_cpu_ptr(cache->percpu);
 	if (!chp->first)
 		INIT_LIST_HEAD(new_item);
 	else /* put on front */
-- 
1.7.1

