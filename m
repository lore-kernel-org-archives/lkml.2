Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1GUQEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:04:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1GUQEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:13 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] dlm: remove deadlock debug print
Date: Thu, 21 Jul 2011 11:04:05 -0500
Message-Id: <1311264247-28129-9-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfs2 recently began using this feature heavily,
creating more debug output than we want to see.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 9ebeaa6..6772e5c 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2421,9 +2421,6 @@ static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 
 	if (deadlk) {
 		/* it's left on the granted queue */
-		log_debug(r->res_ls, "deadlock %x node %d sts%d g%d r%d %s",
-			  lkb->lkb_id, lkb->lkb_nodeid, lkb->lkb_status,
-			  lkb->lkb_grmode, lkb->lkb_rqmode, r->res_name);
 		revert_lock(r, lkb);
 		queue_cast(r, lkb, -EDEADLK);
 		error = -EDEADLK;
-- 
1.7.6

