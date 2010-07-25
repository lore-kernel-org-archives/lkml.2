Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0GYL3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 07:29:40 -0400
Received: from smtp.nokia.com ([192.100.122.233]:39334 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab0GYL3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 07:29:34 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv6 13/15] writeback: remove unnecessary init_timer call
Date: Sun, 25 Jul 2010 14:29:23 +0300
Message-Id: <1280057365-10297-14-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
References: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 Jul 2010 11:29:29.0807 (UTC) FILETIME=[A57055F0:01CB2BEC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The 'setup_timer()' function also calls 'init_timer()', so the extra
'init_timer()' call is not needed. Indeed, 'setup_timer()' is basically
'init_timer()' plus callback function and data pointers initialization.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/backing-dev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index cfff722..9989083 100644
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

