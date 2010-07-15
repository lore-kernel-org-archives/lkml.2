Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab0GOGmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 02:42:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58726 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab0GOGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 02:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZlcyS7IGQMVRFZDq1hwNaLr7biV8tuGA4mgeMpVrf/fA5cqanUpOeyGDeKrj6yNBl7
         QHseW9aHOob+sewhJLtuqZBLz9YDY1By+Nf5MPdOD61hJjYLIgU1Fc4Q6y2ZVhyF4Zts
         i/FPqlMCW+xAmirJxNkKrqdP01pFJg3/Z1UCE=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
        Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] i2o: fix overflow of copy_to_user()
Date: Thu, 15 Jul 2010 10:42:27 +0400
Message-Id: <1279176147-5521-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If (len > reslen) we must not call copy_to_user() since kernel buffer is
smaller than we want to copy. Similar code in this file is correct, so
this bug was a typo.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/message/i2o/i2o_config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index c4b117f..4dd39a0 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -115,7 +115,7 @@ static int i2o_cfg_gethrt(unsigned long arg)
 	put_user(len, kcmd.reslen);
 	if (len > reslen)
 		ret = -ENOBUFS;
-	if (copy_to_user(kcmd.resbuf, (void *)hrt, len))
+	else if (copy_to_user(kcmd.resbuf, (void *)hrt, len))
 		ret = -EFAULT;
 
 	return ret;
-- 
1.7.0.4

