Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1GUQFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:05:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab1GUQEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:14 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] dlm: don't limit active work items
Date: Thu, 21 Jul 2011 11:04:07 -0500
Message-Id: <1311264247-28129-11-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow multiple workqueue items (locks with callbacks) to be
processed concurrently.  There should be no reason not to
take advantage of this workqueue feature.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/ast.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 4f29add..90e5997 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -267,7 +267,10 @@ void dlm_callback_work(struct work_struct *work)
 int dlm_callback_start(struct dlm_ls *ls)
 {
 	ls->ls_callback_wq = alloc_workqueue("dlm_callback",
-					     WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
+					     WQ_UNBOUND |
+					     WQ_MEM_RECLAIM |
+					     WQ_NON_REENTRANT,
+					     0);
 	if (!ls->ls_callback_wq) {
 		log_print("can't start dlm_callback workqueue");
 		return -ENOMEM;
-- 
1.7.6

