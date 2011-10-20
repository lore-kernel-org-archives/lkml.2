Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1JTWHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 18:07:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53952 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1JTWHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 18:07:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=EnbtixWKGlSsC+WFRrPEfZoPn4cK5SOFnIHuq2F42lTm535BI8pbjjDKiV2K2LWR4
	zEkuWyNO+V2ZfhwMXKVNA==
From: Louis Huemiller <lhuemill@google.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Louis Huemiller <lhuemill@google.com>
Subject: [PATCH] fs: grow_dev_page() failure path not a BUG()
Date: Thu, 20 Oct 2011 15:05:56 -0700
Message-Id: <1319148356-15063-1-git-send-email-lhuemill@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function grow_dev_page() contains a label named failed which
is jumped to on allocation failure.  When the system is low on
memory, which is not a bug, this path can be taken.  This patch
removes the BUG() call, so that this path can be exercised for
proper operation on a debug kernel, without panicing the system.

Signed-off-by: Louis Huemiller <lhuemill@google.com>
---
 fs/buffer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1a80b04..04781e6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1032,7 +1032,6 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	return page;
 
 failed:
-	BUG();
 	unlock_page(page);
 	page_cache_release(page);
 	return NULL;
-- 
1.7.3.1

