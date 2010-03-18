Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0CRJIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:08:19 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:60035 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0CRJII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pIZ7h5ypLowyI7Tl3fUYLNdfNqS2k6csrPfbYd+jN5giuIN4yJ4eKdl/+BXt//Nklx
         Mzm5n6+ozi7K5H9crDWHqsvk6LQ16LwwbHKmUxHCseMKVO4zsd6NE2FQ4pHEZCy7Tow5
         W1KwnmGxeNaelHC9b1cCFZk6cs90r0EStbOlM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 09/12] ehca: convert cpu notifier to return encapsulate errno value
Date: Thu, 18 Mar 2010 18:05:21 +0900
Message-Id: <1268903124-10237-9-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the previous modification, the cpu notifier can return encapsulate
errno value. This converts the cpu notifiers for ehca.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/ehca/ehca_irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index b2b6fea..31f3ee1 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -845,7 +845,7 @@ static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
 		ehca_gen_dbg("CPU: %x (CPU_PREPARE)", cpu);
 		if (!create_comp_task(pool, cpu)) {
 			ehca_gen_err("Can't create comp_task for cpu: %x", cpu);
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		}
 		break;
 	case CPU_UP_CANCELED:
-- 
1.6.0.6

