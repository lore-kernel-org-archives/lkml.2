Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0GMKbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:31:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab0GMKbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:31:22 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -tip] rbtree: avoid func twice when node doesn't have a right sibling
Date: Tue, 13 Jul 2010 18:30:54 +0800
Message-Id: <1279017054-3024-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rb_augment_path(),

        if (node == parent->rb_left && parent->rb_right)
                func(parent->rb_right, data);
        else if (parent->rb_left)
                func(parent->rb_left, data);

If (node == parent->rb_left && !parent->rb_right), then kernel will
func(node,data) twice.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 lib/rbtree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 4693f79..7bb8f7f 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -295,7 +295,7 @@ up:
 
 	if (node == parent->rb_left && parent->rb_right)
 		func(parent->rb_right, data);
-	else if (parent->rb_left)
+	else if (node == parent->rb_right && parent->rb_left)
 		func(parent->rb_left, data);
 
 	node = parent;
-- 
1.7.1.1

