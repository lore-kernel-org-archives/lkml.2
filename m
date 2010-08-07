Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0HGQr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 12:47:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55463 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab0HGQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 12:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZV/qnlXHbZow65zc+yF3LgG8YWbigfm8oHYZ+sbx/C6A8TAuIs3wFm4B10Lb4cNEqf
         eY6sPdP08GL2M47CVM4G4ryPYwc5KIRl501Y01ZkI4zCWwP5YWh6x/I6GRcX+0TiTfDZ
         x0xZp4BRL2zib5g1vY9mN0GwD1WUwS6yNIlAY=
From: Namhyung Kim <namhyung@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] padata: add missing __percpu markup in include/linux/padata.h
Date: Sun,  8 Aug 2010 01:47:25 +0900
Message-Id: <1281199645-26274-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parallel_data->queue is a percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/padata.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 8d84062..67df560 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -96,15 +96,15 @@ struct padata_queue {
  * @timer: Reorder timer.
  */
 struct parallel_data {
-	struct padata_instance	*pinst;
-	struct padata_queue	*queue;
-	atomic_t		seq_nr;
-	atomic_t		reorder_objects;
-	atomic_t                refcnt;
-	unsigned int		max_seq_nr;
-	cpumask_var_t		cpumask;
-	spinlock_t              lock;
-	struct timer_list       timer;
+	struct padata_instance		*pinst;
+	struct padata_queue __percpu	*queue;
+	atomic_t			seq_nr;
+	atomic_t			reorder_objects;
+	atomic_t                	refcnt;
+	unsigned int			max_seq_nr;
+	cpumask_var_t			cpumask;
+	spinlock_t              	lock;
+	struct timer_list       	timer;
 };
 
 /**
-- 
1.7.0.4

