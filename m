Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2KICUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:20:54 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:48745 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab2KICUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:20:52 -0500
Message-ID: <509C687E.1080106@gmail.com>
Date: Fri, 09 Nov 2012 10:20:46 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: venkat.x.venkatsubra@oracle.com, David Miller <davem@davemloft.net>,
        rds-devel@oss.oracle.com, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v3 2/9] net: rds: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

Signed-off-by: Shan Wei <davidshan@tencent.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
---
no changes vs v2.
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
