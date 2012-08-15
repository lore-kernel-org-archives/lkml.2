Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2HOUJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:09:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:37062 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab2HOTwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 126/165] hfs: add sanity check for file name length
Date: Wed, 15 Aug 2012 15:47:50 -0400
Message-ID: <1345060109-9187-127-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bc5b8a9003132ae44559edd63a1623b7b99dfb68 upstream.

On a corrupted file system the ->len field could be wrong leading to
a buffer overflow.

Reported-and-acked-by: Clement LECIGNE <clement.lecigne@netasq.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/hfs/trans.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/hfs/trans.c b/fs/hfs/trans.c
index e673a88..b1ce4c7 100644
--- a/fs/hfs/trans.c
+++ b/fs/hfs/trans.c
@@ -40,6 +40,8 @@ int hfs_mac2asc(struct super_block *sb, char *out, const struct hfs_name *in)
 
 	src = in->name;
 	srclen = in->len;
+	if (srclen > HFS_NAMELEN)
+		srclen = HFS_NAMELEN;
 	dst = out;
 	dstlen = HFS_MAX_NAMELEN;
 	if (nls_io) {
-- 
1.7.12.rc2

