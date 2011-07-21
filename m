Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1GUQFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:05:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab1GUQEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:12 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] dlm: fix kmalloc args
Date: Thu, 21 Jul 2011 11:04:02 -0500
Message-Id: <1311264247-28129-6-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gfp and size args were switched.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 84c52e6..3c72348 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4129,7 +4129,7 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 	struct dlm_message *ms_stub;
 	int wait_type, stub_unlock_result, stub_cancel_result;
 
-	ms_stub = kmalloc(GFP_KERNEL, sizeof(struct dlm_message));
+	ms_stub = kmalloc(sizeof(struct dlm_message), GFP_KERNEL);
 	if (!ms_stub) {
 		log_error(ls, "dlm_recover_waiters_pre no mem");
 		return;
-- 
1.7.6

