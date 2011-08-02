Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1HBKfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:35:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59102 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab1HBKfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:35:15 -0400
From: Julia Lawall <julia@diku.dk>
To: Ingo Molnar <mingo@elte.hu>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/11] kernel/sysctl.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:34:58 +0200
Message-Id: <1312281304-11847-6-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312281304-11847-1-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 kernel/sysctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/kernel/sysctl.c b/kernel/sysctl.c
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1600,8 +1600,7 @@ void sysctl_head_put(struct ctl_table_he
 
 struct ctl_table_header *sysctl_head_grab(struct ctl_table_header *head)
 {
-	if (!head)
-		BUG();
+	BUG_ON(!head);
 	spin_lock(&sysctl_lock);
 	if (!use_table(head))
 		head = ERR_PTR(-ENOENT);

