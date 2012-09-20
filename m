Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2ITOYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:24:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39443 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab2ITOXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:23:41 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net
Subject: [PATCH v2 10/10] vfs: unexport getname and putname symbols
Date: Thu, 20 Sep 2012 10:23:19 -0400
Message-Id: <1348150999-13028-11-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348150999-13028-1-git-send-email-jlayton@redhat.com>
References: <1348150999-13028-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see no callers in module code.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 32a3ed0..e80434e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -209,7 +209,6 @@ getname(const char __user * filename)
 {
 	return getname_flags(filename, 0, NULL);
 }
-EXPORT_SYMBOL(getname);
 
 void putname(struct getname_info *ginfo)
 {
@@ -219,7 +218,6 @@ void putname(struct getname_info *ginfo)
 #endif
 	final_putname(ginfo);
 }
-EXPORT_SYMBOL(putname);
 
 static int check_acl(struct inode *inode, int mask)
 {
-- 
1.7.11.4

