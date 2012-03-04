Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab2CDMKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 07:10:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64500 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2CDMKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 07:10:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linkinjeon@gmail.com designates 10.68.218.130 as permitted sender) smtp.mail=linkinjeon@gmail.com; dkim=pass header.i=linkinjeon@gmail.com
From: Namjae Jeon <linkinjeon@gmail.com>
To: axboe@kernel.dk, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] cfq: fix NULL pointer dereference in cfq_choose_cfqg.
Date: Sun,  4 Mar 2012 07:10:26 -0500
Message-Id: <1330863026-2696-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found null pointer dereferencing possibility while reviewing.
If cfq_get_next_cfqg return null by RB_EMPTY_ROOT, null pointer dereferencing error can occur.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 block/cfq-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d0ba505..d924272 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2306,7 +2306,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	cfqd->serving_group = cfqg;
 
 	/* Restore the workload type data */
-	if (cfqg->saved_workload_slice) {
+	if (!cfqg && cfqg->saved_workload_slice) {
 		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
 		cfqd->serving_type = cfqg->saved_workload;
 		cfqd->serving_prio = cfqg->saved_serving_prio;
-- 
1.7.5.4

