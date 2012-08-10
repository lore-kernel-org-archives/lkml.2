Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2HJIIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:08:53 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52797 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab2HJIIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:08:45 -0400
From: Marina Makienko <makienko@ispras.ru>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Marina Makienko <makienko@ispras.ru>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] target: Add blk_put_request()
Date: Fri, 10 Aug 2012 12:04:59 +0400
Message-Id: <1344585899-31466-1-git-send-email-makienko@ispras.ru>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk requests are obtained (some memory is allocated for them)
by means of functions blk_get_request and blk_make_request.
After usage (usually with help of blk_execute_rq) these requests
should be put (and freed) with help of blk_put_request.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Marina Makienko <makienko@ispras.ru>
---
 drivers/target/target_core_pscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 6e32ff6..c048ede 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1161,6 +1161,7 @@ static int pscsi_execute_cmd(struct se_cmd *cmd)
 	blk_execute_rq_nowait(pdv->pdv_sd->request_queue, NULL, req,
 			(cmd->sam_task_attr == MSG_HEAD_TAG),
 			pscsi_req_done);
+	blk_put_request(req);
 
 	return 0;
 
-- 
1.7.7

