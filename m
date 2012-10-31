Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528Ab2JaLXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:23:14 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63014 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965450Ab2JaLXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:23:02 -0400
Message-ID: <50910A10.3090004@gmail.com>
Date: Wed, 31 Oct 2012 19:22:56 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: steffen.klassert@secunet.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, cl@linux-foundation.org
Subject: [PATCH 6/9] kernel: padata : use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>


Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 kernel/padata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 89fe3d1..70dffe8 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -204,7 +204,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 		goto out;
 	}
 
-	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
+	queue = this_cpu_ptr(pd->pqueue);
 	if (queue->cpu_index == next_queue->cpu_index) {
 		padata = ERR_PTR(-ENODATA);
 		goto out;
-- 
1.7.1

