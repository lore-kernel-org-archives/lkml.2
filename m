Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2HRV0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 17:26:44 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:61456 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836Ab2HRV0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 17:26:22 -0400
X-IronPort-AV: E=Sophos;i="4.77,791,1336341600"; 
   d="scan'208";a="170194855"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] drivers/media/video/gspca/cpia1.c: introduce missing initialization
Date: Sat, 18 Aug 2012 23:25:57 +0200
Message-Id: <1345325159-7365-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The result of one call to a function is tested, and then at the second call
to the same function, the previous result, and not the current result, is
tested again.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
identifier f;
statement S1,S2;
@@

*ret = f(...);
if (\(ret != 0\|ret < 0\|ret == NULL\)) S1
... when any
*f(...);
if (\(ret != 0\|ret < 0\|ret == NULL\)) S2
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/video/gspca/cpia1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/gspca/cpia1.c b/drivers/media/video/gspca/cpia1.c
index 2499a88..b3ba47d 100644
--- a/drivers/media/video/gspca/cpia1.c
+++ b/drivers/media/video/gspca/cpia1.c
@@ -751,7 +751,7 @@ static int goto_high_power(struct gspca_dev *gspca_dev)
 	if (signal_pending(current))
 		return -EINTR;
 
-	do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
+	ret = do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
 	if (ret)
 		return ret;
 

