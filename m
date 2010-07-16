Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965387Ab0GPMtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:49:09 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54022 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965302Ab0GPMtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:07 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 02/16] writeback: remove redundant list initialization
Date: Fri, 16 Jul 2010 15:44:58 +0300
Message-Id: <1279284312-2411-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:48:59.0633 (UTC) FILETIME=[42C24610:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

We do not have to call 'INIT_LIST_HEAD()' for list elements
('bdi->bdi_list') before inserting them to the 'bdi_pending_list',
because 'list_add_tail' will initialize the element anyway. Thus,
kill the redundant initialization.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 mm/backing-dev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index ff5669a..0fad60d 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -416,7 +416,6 @@ static void bdi_add_to_pending(struct rcu_head *head)
 	struct backing_dev_info *bdi;
 
 	bdi = container_of(head, struct backing_dev_info, rcu_head);
-	INIT_LIST_HEAD(&bdi->bdi_list);
 
 	spin_lock(&bdi_lock);
 	list_add_tail(&bdi->bdi_list, &bdi_pending_list);
-- 
1.7.1.1

