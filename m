Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2LKKQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:16:48 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33049 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2LKKQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:16:47 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] lib/rbtree_test.c: fix uninitialized variable warning
Date: Tue, 11 Dec 2012 10:16:31 +0000
Message-Id: <1355220996-32753-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch is to fix the following compilation warning:
lib/rbtree_test.c: In function ‘check’:
lib/rbtree_test.c:121: warning: ‘blacks’ may be used uninitialized in this
function

the use of variable blacks in line 133 might be uninitialized

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 lib/rbtree_test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index da96578..af38aed 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -118,7 +118,7 @@ static void check(int nr_nodes)
 {
 	struct rb_node *rb;
 	int count = 0;
-	int blacks;
+	int blacks = 0;
 	u32 prev_key = 0;
 
 	for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
-- 
1.7.4.5

