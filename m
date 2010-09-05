Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0IESdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:33:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60131 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab0IESdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qa/gcQ1i8VP1AW0eVPWpSDP8/7pN1Xkyb0B373CVeFQneNvSykNwy3kY8S1UbhtGoz
         Fy8HCHmgsqa0Is8+2AvOYCNZJuEHcavI2q7Ux469mi7N4D65+/U7Nl2uEb1yivSwyaDH
         4mGspfzRJEypzlqf6+Y6cV9BxvVdZveCXlpvA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, Julia Lawall <julia@diku.dk>,
        Tejun Heo <tj@kernel.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] ubifs: check return code of pnode_lookup
Date: Sun,  5 Sep 2010 22:33:04 +0400
Message-Id: <1283711584-7587-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function pnode_lookup may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 fs/ubifs/lpt_commit.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/lpt_commit.c b/fs/ubifs/lpt_commit.c
index d12535b..5c90dec 100644
--- a/fs/ubifs/lpt_commit.c
+++ b/fs/ubifs/lpt_commit.c
@@ -705,6 +705,9 @@ static int make_tree_dirty(struct ubifs_info *c)
 	struct ubifs_pnode *pnode;
 
 	pnode = pnode_lookup(c, 0);
+	if (IS_ERR(pnode))
+		return PTR_ERR(pnode);
+
 	while (pnode) {
 		do_make_pnode_dirty(c, pnode);
 		pnode = next_pnode_to_dirty(c, pnode);
-- 
1.7.0.4

