Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1EXDTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:19:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47842 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1EXDS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kM2lLnBMAQmomTS7C+WdY7qpePBX/vB0CMEQBC19T3TxkCZyLXYUWIc9aGtn2carGY
         q7w9FuYAinyGYIvo7RsXnTNVrOpRWtfJ8AYEOx/EDCU3+S1ZS98F/Qwo7pS7qWfnmTAx
         ntCogCgdgcE0CK8UUHMVKGOzdokNYlLo8bLcU=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] cfq-iosched: algebraic simplification in cfq_prio_to_maxrq()
Date: Tue, 24 May 2011 12:18:48 +0900
Message-Id: <1306207131-2296-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the calculation in cfq_prio_to_maxrq(), plus replace CFQ_PRIO_LISTS to
IOPRIO_BE_NR since they are the same and IOPRIO_BE_NR looks more reasonable in
this context IMHO.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/cfq-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ab7a9e6a9b1c..151a050e692c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2029,7 +2029,7 @@ cfq_prio_to_maxrq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	WARN_ON(cfqq->ioprio >= IOPRIO_BE_NR);
 
-	return 2 * (base_rq + base_rq * (CFQ_PRIO_LISTS - 1 - cfqq->ioprio));
+	return 2 * base_rq * (IOPRIO_BE_NR - cfqq->ioprio);
 }
 
 /*
-- 
1.7.5.2

