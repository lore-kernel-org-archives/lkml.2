Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab1E3M5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:57:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61029 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1E3M5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jsOX9dh1DgB0Sgld0/vhyPuiAhVVsnzNKUByb7gSqIsGOV29ZtnUs7qE7jlLBxHnED
         krdkM4rpsExr/JEY0mhkl26xpFDo4e04oZGX4NCeCzJNdEtkM80YG7NBtUIyRzCRsg1M
         Y9Lp6Uzj7sWOfwe8pEXRc6+UDxnio5c0ZqV6U=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
Subject: [PATCH] ocfs2: use proper little-endian bitops
Date: Mon, 30 May 2011 21:58:05 +0900
Message-Id: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using __test_and_{set,clear}_bit_le() with ignoring its return value
can be replaced with __{set,clear}_bit_le().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: ocfs2-devel@oss.oracle.com
---
 fs/ocfs2/ocfs2.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 4092858..bcde467 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -836,13 +836,13 @@ static inline unsigned int ocfs2_clusters_to_megabytes(struct super_block *sb,
 
 static inline void _ocfs2_set_bit(unsigned int bit, unsigned long *bitmap)
 {
-	__test_and_set_bit_le(bit, bitmap);
+	__set_bit_le(bit, bitmap);
 }
 #define ocfs2_set_bit(bit, addr) _ocfs2_set_bit((bit), (unsigned long *)(addr))
 
 static inline void _ocfs2_clear_bit(unsigned int bit, unsigned long *bitmap)
 {
-	__test_and_clear_bit_le(bit, bitmap);
+	__clear_bit_le(bit, bitmap);
 }
 #define ocfs2_clear_bit(bit, addr) _ocfs2_clear_bit((bit), (unsigned long *)(addr))
 
-- 
1.7.4.4

