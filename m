Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab0KORRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:17:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932871Ab0KORRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:17:06 -0500
From: Josef Bacik <josef@redhat.com>
To: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fallocate.2: add FALLOC_FL_PUNCH_HOLE flag definition
Date: Mon, 15 Nov 2010 12:07:56 -0500
Message-Id: <1289840876-3546-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the relevant documenation for using fallocate with the
FALLOC_FL_PUNCH_HOLE mode.  This information comes from the implementation of
FALLOC_FL_PUNCH_HOLE that I've posted along with this man page update to outline
the definition for hole punching.  Obviously this patch is dependant upon the
current implementation being accepted.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 man2/fallocate.2 |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/man2/fallocate.2 b/man2/fallocate.2
index 42eefbd..1b28916 100644
--- a/man2/fallocate.2
+++ b/man2/fallocate.2
@@ -31,9 +31,8 @@ bytes.
 
 The
 .I mode
-argument determines the operation to be performed on the given range.
-Currently only one flag is supported for
-.IR mode :
+argument determines the operation to be performed on the given range, the
+value can be one of the following:
 .TP
 .B FALLOC_FL_KEEP_SIZE
 This flag allocates and initializes to zero the disk space
@@ -50,6 +49,16 @@ the file size (as reported by
 .BR stat (2))
 even if it is less than
 .IR offset + len .
+.TP
+.B FALLOC_FL_PUNCH_HOLE
+This flag de-allocates the disk space within the range specified by
+.I offset
+and
+.IR len .
+This call preserves the file size (as reported by
+.BR stat (2)),
+the only change will be to the amount of space used by the file.  After a
+successful call, subsequent reads from this range will return 0's.
 .\"
 .\" Note from Amit Arora:
 .\" There were few more flags which were discussed, but none of
-- 
1.6.6.1

