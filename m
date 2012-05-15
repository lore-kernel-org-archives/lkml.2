Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551Ab2EOCS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:49286 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964902Ab2EOCQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 045/179] UBIFS: fix memory leak on error path
Date: Mon, 14 May 2012 22:12:21 -0400
Message-ID: <1337048075-6132-46-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 812eb258311f89bcd664a34a620f249d54a2cd83 upstream.

UBIFS leaks memory on error path in 'ubifs_jnl_update()' in case of write
failure because it forgets to free the 'struct ubifs_dent_node *dent' object.
Although the object is small, the alignment can make it large - e.g., 2KiB
if the min. I/O unit is 2KiB.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ubifs/journal.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index d321bae..841f77c 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -665,6 +665,7 @@ out_free:
 
 out_release:
 	release_head(c, BASEHD);
+	kfree(dent);
 out_ro:
 	ubifs_ro_mode(c, err);
 	if (last_reference)
-- 
1.7.9.6

