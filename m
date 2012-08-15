Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2HOUcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:32:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:36519 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab2HOTtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Van Hensbergen <ericvh@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 036/165] net/9p: fix client code to fail more gracefully on protocol error
Date: Wed, 15 Aug 2012 15:46:20 -0400
Message-ID: <1345060109-9187-37-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b85f7d92d7bd7e3298159e8b1eed8cb8cbbb0348 upstream.

There was a BUG_ON to protect against a bad id which could be dealt with
more gracefully.

Reported-by: Natalie Orlin <norlin@us.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/9p/client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 0aa79fa..583fd03 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -272,7 +272,8 @@ struct p9_req_t *p9_tag_lookup(struct p9_client *c, u16 tag)
 	 * buffer to read the data into */
 	tag++;
 
-	BUG_ON(tag >= c->max_tag);
+	if(tag >= c->max_tag)
+		return NULL;
 
 	row = tag / P9_ROW_MAXTAG;
 	col = tag % P9_ROW_MAXTAG;
-- 
1.7.12.rc2

