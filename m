Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2KMBwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:52:45 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64882 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2KMBwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:52:42 -0500
Message-ID: <50A1A7E1.3030401@gmail.com>
Date: Tue, 13 Nov 2012 09:52:33 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: steffen.klassert@secunet.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, cl@linux-foundation.org,
        Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v4 5/9] kernel: padata : use __this_cpu_read per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

For bottom halves off, __this_cpu_read is better.

Signed-off-by: Shan Wei <davidshan@tencent.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
---
no changes vs v4.
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


