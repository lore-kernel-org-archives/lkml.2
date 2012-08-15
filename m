Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab2HOTtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:36502 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab2HOTtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: NeilBrown <neilb@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 030/165] md/linear: avoid corrupting structure while waiting for rcu_free to complete.
Date: Wed, 15 Aug 2012 15:46:14 -0400
Message-ID: <1345060109-9187-31-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1b6afa17581027218088a18a9ceda600e0ddba7a upstream.

I don't know what I was thinking putting 'rcu' after a dynamically
sized array!  The array could still be in use when we call rcu_free()
(That is the point) so we mustn't corrupt it.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/linear.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/linear.h b/drivers/md/linear.h
index 0ce29b6..2f2da05 100644
--- a/drivers/md/linear.h
+++ b/drivers/md/linear.h
@@ -10,9 +10,9 @@ typedef struct dev_info dev_info_t;
 
 struct linear_private_data
 {
+	struct rcu_head		rcu;
 	sector_t		array_sectors;
 	dev_info_t		disks[0];
-	struct rcu_head		rcu;
 };
 
 
-- 
1.7.12.rc2

