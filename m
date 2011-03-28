Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1C1RlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:41:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59107 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab1C1RlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=b+8EhzwR6H/swUumKGmGTwMP7Uds6CLX3U3FJbNpvcopP4KiMzLQ5G/JyXOMWekpZf
         Z0sDDTEaQEaBvIihsDWDRxAjRtVEU76Xz+RshO16jr/Y0feMDzBVBaJZHupCQpJA87n8
         s0He9efiZOKiYANAUSHP+2HopWUANBcOi5Zw8=
MIME-Version: 1.0
Date: Mon, 28 Mar 2011 23:09:53 +0530
Message-ID: <AANLkTikVjknc32PiZ2O4jb+JUgwffhULyxRxFUCOS+bv@mail.gmail.com>
Subject: [PATCH] block: Replace NR_CPUS with num_online_cpus()
From: Sisir Koppaka <sisir.koppaka@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NR_CPUS is a boot state and hence, not indicative of the actual number
of online CPUs. This is a known checkpatch warning.

Signed-off-by: Sisir Koppaka <sisir.koppaka@gmail.com>
CC: Jens Axboe <jaxboe@fusionio.com>
CC: Tejun Heo <tj@kernel.org>
---
 block/blk.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index c8db371..9a55515 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -1,3 +1,4 @@
+#include <linux/cpumask.h>
 #ifndef BLK_INTERNAL_H
 #define BLK_INTERNAL_H

@@ -136,7 +137,7 @@ static inline int
queue_congestion_off_threshold(struct request_queue *q)

 static inline int blk_cpu_to_group(int cpu)
 {
-	int group = NR_CPUS;
+	int group = num_online_cpus();
 #ifdef CONFIG_SCHED_MC
 	const struct cpumask *mask = cpu_coregroup_mask(cpu);
 	group = cpumask_first(mask);
@@ -145,7 +146,7 @@ static inline int blk_cpu_to_group(int cpu)
 #else
 	return cpu;
 #endif
-	if (likely(group < NR_CPUS))
+	if (likely(group < num_online_cpus()))
 		return group;
 	return cpu;
 }
-- 
1.7.0.4

                sk
