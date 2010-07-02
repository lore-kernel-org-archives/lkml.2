Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab0GBIfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:35:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40739 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab0GBIfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=JX5FbjkPZ2tmtiLKfbvtJMKnWVFOcZhGwqYXhjV2DpfDvYGxAzClJ6tFqdnTqKZ6RN
         L5GwIsEO/krtuGQEiC22PcIJxOMn373ZhiOKWGP37bdXoxf3w/8Da/rNS4MrZggVCmCs
         9ornm8FH30sl03BHVSnT4fS8TYOS8gJqGftyo=
Message-ID: <4C2DA4C1.2000509@gmail.com>
Date: Fri, 02 Jul 2010 10:35:13 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: [PATCH 3/4] workqueue: fix incorrect cpu number BUG_ON() in get_work_gcwq()
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <4C2DA42C.7090804@gmail.com>
In-Reply-To: <4C2DA42C.7090804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_work_gcwq() was incorrectly triggering BUG_ON() if cpu number is
equal to or higher than num_possible_cpus() instead of nr_cpu_ids.
Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b59c946..0c485a5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -445,7 +445,7 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 	if (cpu == NR_CPUS)
 		return NULL;

-	BUG_ON(cpu >= num_possible_cpus());
+	BUG_ON(cpu >= nr_cpu_ids);
 	return get_gcwq(cpu);
 }

-- 
1.6.4.2

