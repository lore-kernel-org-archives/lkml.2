Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0ESOs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:48:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab0ESOso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:48:44 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>
Subject: [PATCH 1/2] dlm: cleanup remove unused code
Date: Wed, 19 May 2010 09:48:32 -0500
Message-Id: <1274280513-14860-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

Smatch complains because "lkb" is never NULL.  Looking at it, the original
code actually adds the new element to the end of the list fine, so we can
just get rid of the if condition.  This code is four years old and no one
has complained so it must work.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 17903b4..031dbe3 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -733,10 +733,7 @@ static void lkb_add_ordered(struct list_head *new, struct list_head *head,
 		if (lkb->lkb_rqmode < mode)
 			break;
 
-	if (!lkb)
-		list_add_tail(new, head);
-	else
-		__list_add(new, lkb->lkb_statequeue.prev, &lkb->lkb_statequeue);
+	__list_add(new, lkb->lkb_statequeue.prev, &lkb->lkb_statequeue);
 }
 
 /* add/remove lkb to rsb's grant/convert/wait queue */
-- 
1.6.6

