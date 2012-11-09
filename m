Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab2KICV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:21:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59862 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab2KICVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:21:25 -0500
Message-ID: <509C68A0.1070004@gmail.com>
Date: Fri, 09 Nov 2012 10:21:20 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: steffen.klassert@secunet.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, cl@linux-foundation.org,
        Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v3 5/9] kernel: padata : use __this_cpu_read per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

For bottom halves off, __this_cpu_read is better.

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
v3: use __this_cpu_read instead of this_cpu_read.
---
 kernel/padata.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 89fe3d1..072f4ee 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -171,7 +171,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 {
 	int cpu, num_cpus;
 	unsigned int next_nr, next_index;
-	struct padata_parallel_queue *queue, *next_queue;
+	struct padata_parallel_queue *next_queue;
 	struct padata_priv *padata;
 	struct padata_list *reorder;
 
@@ -204,8 +204,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 		goto out;
 	}
 
-	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
-	if (queue->cpu_index == next_queue->cpu_index) {
+	if (__this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index) {
 		padata = ERR_PTR(-ENODATA);
 		goto out;
 	}
-- 
1.7.1

