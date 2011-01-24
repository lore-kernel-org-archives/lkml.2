Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1AXRpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:45:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46781 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1AXRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:45:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gxoW9MF9Bm3RsoQTFNFHFn87tKKu9GiqASonNCDQK4iQ8YT9qDWcsut+t2J6P4LPNH
         f3Br9eyMwjoMAq5oc3qYlpYElQsZ7e8PaTBotXzVPa++AdsPCEYdIMJ5VTgRBCzhmgeq
         +o84UIdqrtRl27iB61iW5J5IL3Uh3bdFLQwbs=
From: Radu Voicilas <rvoicilas@gmail.com>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, Radu Voicilas <rvoicilas@gmail.com>
Subject: [PATCH] fsnotify.h: Dropped redundant code.
Date: Mon, 24 Jan 2011 19:45:26 +0200
Message-Id: <1295891126-31540-1-git-send-email-rvoicilas@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code that checks to see whether the provided dentry object is valid
or not is redundant with the one that's in fs/notify/fsnotify.c in
the __fsnotify_parent function:

    if (!dentry)
        dentry = path->dentry;

Signed-off-by: Radu Voicilas <rvoicilas@gmail.com>
---
 include/linux/fsnotify.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 2a53f10..9e67a41 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -27,9 +27,6 @@ static inline void fsnotify_d_instantiate(struct dentry *dentry,
 /* Notify this dentry's parent about a child's events. */
 static inline int fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
 {
-	if (!dentry)
-		dentry = path->dentry;
-
 	return __fsnotify_parent(path, dentry, mask);
 }
 
-- 
1.7.0.4

