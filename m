Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347Ab0GWPGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:06:11 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52443 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760246Ab0GWPGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:06:02 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv4 13/14] writeback: remove unnecessary init_timer call
Date: Fri, 23 Jul 2010 18:05:53 +0300
Message-Id: <1279897554-1526-14-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
References: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 23 Jul 2010 15:05:52.0004 (UTC) FILETIME=[8A9AE440:01CB2A78]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The 'setup_timer()' function also calls 'init_timer()', so the extra
'init_timer()' call is not needed. Indeed, 'setup_timer()' is basically
'init_timer()' plus callback function and data pointers initialization.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 mm/backing-dev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index cedd9b1..ce105fc 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -236,7 +236,6 @@ static int __init default_bdi_init(void)
 	sync_supers_tsk = kthread_run(bdi_sync_supers, NULL, "sync_supers");
 	BUG_ON(IS_ERR(sync_supers_tsk));
 
-	init_timer(&sync_supers_timer);
 	setup_timer(&sync_supers_timer, sync_supers_timer_fn, 0);
 	bdi_arm_supers_timer();
 
-- 
1.7.1.1

