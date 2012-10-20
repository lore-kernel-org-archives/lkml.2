Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2JTQax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:30:53 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:64209 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2JTQa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:30:27 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 2/3] workqueue: trivial fix for return statement in work_busy()
Date: Sun, 21 Oct 2012 01:30:06 +0900
Message-Id: <1350750607-2051-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350750607-2051-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1350750607-2051-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return type of work_busy() is unsigned int.
There is return statement returning boolean value, 'false' in work_busy().
It is not problem, because 'false' may be treated '0'.
However, fixing it would make code robust.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c57358e..27a6dee 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3479,7 +3479,7 @@ unsigned int work_busy(struct work_struct *work)
 	unsigned int ret = 0;
 
 	if (!gcwq)
-		return false;
+		return 0;
 
 	spin_lock_irqsave(&gcwq->lock, flags);
 
-- 
1.7.9.5

