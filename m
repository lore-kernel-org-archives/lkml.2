Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1AFQBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:01:39 -0500
Received: from mail.nec-labs.com ([138.15.200.209]:56502 "EHLO
	mail.nec-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1AFQBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:01:38 -0500
X-Greylist: delayed 769 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 11:01:38 EST
From: Akshat Aranya <aranya@nec-labs.com>
To: dhowells@redhat.com
Cc: Akshat Aranya <aranya@nec-labs.com>, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fscache: fix incorrect op count check for delayed operations
Date: Thu,  6 Jan 2011 10:47:56 -0500
Message-Id: <1294328876-8612-1-git-send-email-aranya@nec-labs.com>
X-Mailer: git-send-email 1.7.1
To: dhowells@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fscache_submit_exclusive_op() adds an operation to the pending list if
other operations are pending.  Fixed the check for pending ops.

Signed-off-by: Akshat Aranya <aranya@nec-labs.com>
---
 fs/fscache/operation.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index b9f34ea..48a18f1 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -101,7 +101,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 		object->n_ops++;
 		object->n_exclusive++;	/* reads and writes must wait */
 
-		if (object->n_ops > 0) {
+		if (object->n_ops > 1) {
 			atomic_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
 			fscache_stat(&fscache_n_op_pend);
-- 
1.7.1

