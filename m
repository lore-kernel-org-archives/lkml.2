Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab2HSAgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 20:36:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43686 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2HSAgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 20:36:14 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: gregkh@linux-foundation.org, Jim Cromie <jim.cromie@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: [PATCH] dyndbg: fix for SOH in logging messages
Date: Sat, 18 Aug 2012 18:35:51 -0600
Message-Id: <1345336551-10066-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.1.487.ga3935e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit af7f2158fde was done against master, and clashed with structured logging's change of KERN_LEVEL to SOH.

Bisected and fixed by Markus Trippelsdorf.

CC: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/base/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index cdd01c5..5e6e00b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1912,8 +1912,8 @@ int __dev_printk(const char *level, const struct device *dev,
 				    "DEVICE=+%s:%s", subsys, dev_name(dev));
 	}
 skip:
-	if (level[3])
-		level_extra = &level[3]; /* skip past "<L>" */
+	if (level[2])
+		level_extra = &level[2]; /* skip past KERN_SOH "L" */
 
 	return printk_emit(0, level[1] - '0',
 			   dictlen ? dict : NULL, dictlen,
-- 
1.7.10.1.487.ga3935e6

