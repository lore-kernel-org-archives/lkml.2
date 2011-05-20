Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837Ab1ETTNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:13:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37031 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821Ab1ETTNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:13:52 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <john.johansen@canonical.com> (supporter:APPARMOR
	SECURITY...),
        James Morris <jmorris@namei.org> (supporter:SECURITY SUBSYSTEM),
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: [PATCH 8/8] apparmor: Kill set but no used warning in common_mmap()
Date: Fri, 20 May 2011 16:13:05 -0300
Message-Id: <1305918786-7239-8-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305918786-7239-7-git-send-email-padovan@profusion.mobi>
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-4-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-5-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-6-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-7-git-send-email-padovan@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 security/apparmor/lsm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index ae3a698..4c1e4ca 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -470,7 +470,6 @@ static int apparmor_file_lock(struct file *file, unsigned int cmd)
 static int common_mmap(int op, struct file *file, unsigned long prot,
 		       unsigned long flags)
 {
-	struct dentry *dentry;
 	int mask = 0;
 
 	if (!file || !file->f_security)
@@ -487,7 +486,6 @@ static int common_mmap(int op, struct file *file, unsigned long prot,
 	if (prot & PROT_EXEC)
 		mask |= AA_EXEC_MMAP;
 
-	dentry = file->f_path.dentry;
 	return common_file_perm(op, file, mask);
 }
 
-- 
1.7.5.1

