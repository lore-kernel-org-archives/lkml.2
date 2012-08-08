Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2HHMrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:47:33 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:51850 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab2HHMrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:47:32 -0400
X-Greylist: delayed 1409 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2012 08:47:32 EDT
From: Marina Makienko <makienko@ispras.ru>
To: "Grant R. Guenther" <grant@torque.net>
Cc: Marina Makienko <makienko@ispras.ru>, Tim Waugh <tim@cyberelk.net>,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] blk: All obtained blk requests should be put after all
Date: Wed,  8 Aug 2012 16:20:17 +0400
Message-Id: <1344428417-30558-1-git-send-email-makienko@ispras.ru>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk requests are obtained (some memory is allocated for them) by means of functions blk_get_request and blk_make_request. After usage (usually with help of blk_execute_rq) these requests should be put (and freed) with help of blk_put_request.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Marina Makienko <makienko@ispras.ru>
---
 drivers/block/paride/pd.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 831e3ac..528a9a5 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -723,6 +723,11 @@ static int pd_special_command(struct pd_unit *disk,
 
 	rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);
 
+	if (!rq) {
+		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
+		return NULL;
+	}
+
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = func;
 
-- 
1.7.7

