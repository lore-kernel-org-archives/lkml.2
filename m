Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab2KBQB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:01:56 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:62509 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab2KBQBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:01:52 -0400
Message-ID: <5093EE63.5000005@gmail.com>
Date: Sat, 03 Nov 2012 00:01:39 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: steffen.klassert@secunet.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, cl@linux-foundation.org,
        Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v2 5/9] kernel: padata : use this_cpu_read per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>


Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 kernel/padata.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 89fe3d1..cf94137 100644
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
+	if (this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index) {
 		padata = ERR_PTR(-ENODATA);
 		goto out;
 	}
-- 
1.7.1

