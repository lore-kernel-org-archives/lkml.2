Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab1L1IyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 03:54:12 -0500
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:46032 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751394Ab1L1IyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 03:54:10 -0500
From: Roland Dreier <roland@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steve Hodgson <steve@purestorage.com>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH] btree: Export btree_get_prev() so modules can use btree_for_each
Date: Wed, 28 Dec 2011 00:53:59 -0800
Message-Id: <1325062439-1325-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Hodgson <steve@purestorage.com>

The btree_for_each API is implemented with macros that internally call
btree_get_prev(), so if btree_get_prev() isn't exported then modules
fail to link if they try to use one of the btree_for_each macros.  Since
the rest of the btree API is exported, we should keep things orthogonal
and make this work too.

Cc: Joern Engel <joern@logfs.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 lib/btree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/btree.c b/lib/btree.c
index 2a34392..e5ec1e9 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -357,6 +357,7 @@ miss:
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(btree_get_prev);
 
 static int getpos(struct btree_geo *geo, unsigned long *node,
 		unsigned long *key)
-- 
1.7.5.4

