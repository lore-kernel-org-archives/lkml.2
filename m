Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab0HLKyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 06:54:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44714 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759789Ab0HLKyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 06:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SLqztAXYWHNc0G65QWFTn5unGUSs0riTF9kmhz043FwxujVc9YrFJskH/hIVNKEx9b
         zc4J/T9uV/icbHuK8Jw9yQ/0RhWW2FskvDmnanuXn6EUuqqbr/b+bQinWzLDsAiALPGS
         C3br2LjKxAfN5D0AFZSCaMjXl46IqAt9aTFDU=
From: Namhyung Kim <namhyung@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH resend] padata: add missing __percpu markup in include/linux/padata.h
Date: Thu, 12 Aug 2010 19:54:27 +0900
Message-Id: <1281610467-9414-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100811182925.GB4097@secunet.com>
References: <20100811182925.GB4097@secunet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parallel_data->queue is a percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/padata.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index bdcd1e9..4633b2f 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -127,8 +127,8 @@ struct padata_cpumask {
  */
 struct parallel_data {
 	struct padata_instance		*pinst;
-	struct padata_parallel_queue	*pqueue;
-	struct padata_serial_queue	*squeue;
+	struct padata_parallel_queue	__percpu *pqueue;
+	struct padata_serial_queue	__percpu *squeue;
 	atomic_t			seq_nr;
 	atomic_t			reorder_objects;
 	atomic_t			refcnt;
-- 
1.7.0.4

