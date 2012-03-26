Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2CZUus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:50:48 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:59579 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab2CZUus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:50:48 -0400
Message-Id: <201203262049.q2QKnNph010298@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 26 Mar 2012 16:46:55 -0400
Subject: [PATCH] list_debug: WARN for adding something already in the list
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 26 Mar 2012 20:49:24.0083 (UTC) FILETIME=[ED2B8C30:01CD0B91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were bitten by this at one point and added an additional sanity
test for DEBUG_LIST.  You can't validly add a list_head to a list
where either prev or next is the same as the thing you're adding.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 lib/list_debug.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/list_debug.c b/lib/list_debug.c
index b8029a5..ee41bd2 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -28,6 +28,9 @@ void __list_add(struct list_head *new,
 		"list_add corruption. prev->next should be "
 		"next (%p), but was %p. (prev=%p).\n",
 		next, prev->next, prev);
+	WARN(new == prev || new == next,
+	     "list_add double add: new=%p, prev=%p, next=%p.\n",
+	     new, prev, next);
 	next->prev = new;
 	new->next = next;
 	new->prev = prev;
-- 
1.6.5.2

