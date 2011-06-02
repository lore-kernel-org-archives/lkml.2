Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1FBExN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 00:53:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39387 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab1FBExK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 00:53:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=leAgk2ffEv+d7VRZ8IVqIMSj1j1SQiJwEwiIXQ3nSGYlvqb6D7mvewZfRuDP0nqHqX
         LGMrKjwqMEhZKjhiDOKAvfy70YkwLCtiYLjUR6nJZ7ilNh1YKPFNEfGNjjvKWvoz/U2i
         H8aSgDlnMWZNlkGpg2QDXOo48amd4FsDQFcE4=
From: Namhyung Kim <namhyung@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] md: convert double atomic_inc() to atomic_add()
Date: Thu,  2 Jun 2011 13:53:02 +0900
Message-Id: <1306990383-14133-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/md.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aa640a85bb21..f210e42a56ca 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -396,8 +396,7 @@ static void submit_flushes(struct work_struct *ws)
 			 * we reclaim rcu_read_lock
 			 */
 			struct bio *bi;
-			atomic_inc(&rdev->nr_pending);
-			atomic_inc(&rdev->nr_pending);
+			atomic_add(2, &rdev->nr_pending);
 			rcu_read_unlock();
 			bi = bio_alloc_mddev(GFP_KERNEL, 0, mddev);
 			bi->bi_end_io = md_end_flush;
-- 
1.7.5.2

