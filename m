Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab0JJR2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:28:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38797 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab0JJR2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FhF69n14oQSO1AzhPrwrnJwZ+wDlUb6Zojny5eW+UlxrbkqywqBgwG/BVhNy8j/6Ae
         QdtIYTpUUQx+r1JBud6kqP6ljQMrUzO1bGkcUTGnMpKGzIf6F8aLybVYTIiNvO+zDO71
         /lvuDNyx5svNXjS3gLuQP4RRZnx64MnZ2CpKE=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: mfd: fix off by one error
Date: Sun, 10 Oct 2010 21:28:31 +0400
Message-Id: <1286731711-17865-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snprintf() is overflowed iff result is greater or equal than
argument "size".

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/mfd/mc13xxx-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 93258ad..cd4d670 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -696,7 +696,7 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 	};
 
 	/* there is no asnprintf in the kernel :-( */
-	if (snprintf(buf, sizeof(buf), format, name) > sizeof(buf))
+	if (snprintf(buf, sizeof(buf), format, name) >= sizeof(buf))
 		return -E2BIG;
 
 	cell.name = kmemdup(buf, strlen(buf) + 1, GFP_KERNEL);
-- 
1.7.0.4

