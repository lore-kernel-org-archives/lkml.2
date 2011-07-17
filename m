Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab1GQLfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 07:35:21 -0400
Received: from relay.parallels.com ([195.214.232.42]:46554 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab1GQLfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 07:35:18 -0400
Subject: [PATCH] vfs: use ERR_CAST for err-ptr tossing in
 lookup_instantiate_filp
To: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Sun, 17 Jul 2011 15:35:12 +0400
Message-ID: <20110717113512.17120.29865.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace unclear (struct dentry *) to (struct file *) typecast with ERR_CAST() macro.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/open.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index b52cf01..739b751 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -793,7 +793,7 @@ out:
 	return nd->intent.open.file;
 out_err:
 	release_open_intent(nd);
-	nd->intent.open.file = (struct file *)dentry;
+	nd->intent.open.file = ERR_CAST(dentry);
 	goto out;
 }
 EXPORT_SYMBOL_GPL(lookup_instantiate_filp);

