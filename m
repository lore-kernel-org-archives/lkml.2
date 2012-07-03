Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab2GCVmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 17:42:16 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:40435 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab2GCVmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 17:42:15 -0400
Message-ID: <4FF36732.3060306@mni.thm.de>
Date: Tue, 03 Jul 2012 23:42:10 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/16.0 Thunderbird/16.0a1
MIME-Version: 1.0
To: neilb@suse.de
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: md: fix up plugging (again). breaks build of the latest 3.5rc5+
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proposing this patch:

>From c6ac2740ed916ccf5b6fec0682101dd7a6a50f9f Mon Sep 17 00:00:00 2001
From: Tobias Klausmann <tobias.klausmann@mni.thm.de>
Date: Tue, 3 Jul 2012 23:03:43 +0200
Subject: [PATCH] Fix patch md: fix up plugging again. Commit
 b357f04a67c2aeee828b240863cd3f21d6cb3179

---
 drivers/md/raid10.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index acf5a82..8da6282 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1394,7 +1394,7 @@ retry_write:
 		bio_list_add(&conf->pending_bio_list, mbio);
 		conf->pending_count++;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
-		if (!mddev_check_plugged(mddev, 0, 0))
+		if (!mddev_check_plugged(mddev))
 			md_wakeup_thread(mddev->thread);

 		if (!r10_bio->devs[i].repl_bio)
-- 
1.7.7

at least it compiles with this applied!

Thank you,
Tobias Klausmann

