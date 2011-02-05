Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1BEOV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1BEOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RKE1SrpC8qy8TArm2nWdqREl4pMDUFwR6ZE5vMOE44C7M2ltkmWEObjA99AV3mNIgw
         eGulqxt5bFoEXfVIKZ5WhedHk61j3fnDFWiCqS5tz7VmlspG9RmeqsEeDcUPtCaTmPcR
         W8FasmWqArpusrXTy8Pt8bGO3bSjcA/jnz05o=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 07/52] kstrtox: convert fs/fuse/
Date: Sat,  5 Feb 2011 16:20:10 +0200
Message-Id: <1296915654-7458-7-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/fuse/control.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 85542a7..b916b34 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -74,7 +74,7 @@ static ssize_t fuse_conn_limit_write(struct file *file, const char __user *buf,
 				     size_t count, loff_t *ppos, unsigned *val,
 				     unsigned global_limit)
 {
-	unsigned long t;
+	unsigned int t;
 	char tmp[32];
 	unsigned limit = (1 << 16) - 1;
 	int err;
@@ -87,7 +87,7 @@ static ssize_t fuse_conn_limit_write(struct file *file, const char __user *buf,
 
 	tmp[count] = '\0';
 
-	err = strict_strtoul(tmp, 0, &t);
+	err = kstrtouint(tmp, 0, &t);
 	if (err)
 		return err;
 
-- 
1.7.3.4

