Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1KOM6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:58:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52448 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1KOM6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:58:15 -0500
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH] Fix typo in use of BUG_ON_NONRT macro for RT
Date: Tue, 15 Nov 2011 13:58:07 +0100
Message-Id: <1321361887-544-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/md/dm.c BUG_ON_NORT should be BUG_ON_NONRT

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/md/dm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e917b7f..b1eff42 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1648,14 +1648,14 @@ static void dm_request_fn(struct request_queue *q)
 		if (map_request(ti, clone, md))
 			goto requeued;
 
-		BUG_ON_NORT(!irqs_disabled());
+		BUG_ON_NONRT(!irqs_disabled());
 		spin_lock(q->queue_lock);
 	}
 
 	goto out;
 
 requeued:
-	BUG_ON_NORT(!irqs_disabled());
+	BUG_ON_NONRT(!irqs_disabled());
 	spin_lock(q->queue_lock);
 
 delay_and_out:
-- 
1.7.2.3

