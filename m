Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2LVB6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:58:45 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:48468 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2LVB6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:39 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 21/25] tty/max3100: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:11 -0800
Message-Id: <1356141435-17340-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from max3100.  Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/tty/serial/max3100.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index 7ce3197..dd6277e 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -179,8 +179,7 @@ static void max3100_work(struct work_struct *w);
 
 static void max3100_dowork(struct max3100_port *s)
 {
-	if (!s->force_end_work && !work_pending(&s->work) &&
-	    !freezing(current) && !s->suspending)
+	if (!s->force_end_work && !freezing(current) && !s->suspending)
 		queue_work(s->workqueue, &s->work);
 }
 
-- 
1.8.0.2

