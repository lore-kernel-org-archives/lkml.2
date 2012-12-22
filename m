Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2LVB6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:58:19 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:51770 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2LVB6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:14 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Luciano Coelho <coelho@ti.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 09/25] wl1251: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:56:59 -0800
Message-Id: <1356141435-17340-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from wl1251.  Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/net/wireless/ti/wl1251/ps.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/ps.c b/drivers/net/wireless/ti/wl1251/ps.c
index db719f7..b9e27b9 100644
--- a/drivers/net/wireless/ti/wl1251/ps.c
+++ b/drivers/net/wireless/ti/wl1251/ps.c
@@ -68,8 +68,7 @@ int wl1251_ps_elp_wakeup(struct wl1251 *wl)
 	unsigned long timeout, start;
 	u32 elp_reg;
 
-	if (delayed_work_pending(&wl->elp_work))
-		cancel_delayed_work(&wl->elp_work);
+	cancel_delayed_work(&wl->elp_work);
 
 	if (!wl->elp)
 		return 0;
-- 
1.8.0.2

