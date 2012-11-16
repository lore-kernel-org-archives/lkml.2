Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab2KPG5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:57:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55754 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2KPG5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:37 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Jack Steiner <steiner@sgi.com>
Subject: [PATCH 12/14] gru: Remove redundant check on unsigned variable
Date: Fri, 16 Nov 2012 12:20:44 +0530
Message-Id: <1353048646-10935-13-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check whether unsigned variable is less than 0.

CC: Jack Steiner <steiner@sgi.com>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/misc/sgi-gru/grukdump.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/sgi-gru/grukdump.c b/drivers/misc/sgi-gru/grukdump.c
index 9b2062d..860733b 100644
--- a/drivers/misc/sgi-gru/grukdump.c
+++ b/drivers/misc/sgi-gru/grukdump.c
@@ -197,7 +197,7 @@ int gru_dump_chiplet_request(unsigned long arg)
 		return -EFAULT;
 
 	/* Currently, only dump by gid is implemented */
-	if (req.gid >= gru_max_gids || req.gid < 0)
+	if (req.gid >= gru_max_gids)
 		return -EINVAL;
 
 	gru = GID_TO_GRU(req.gid);
-- 
1.7.4.1

