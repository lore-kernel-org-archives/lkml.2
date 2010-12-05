Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab0LER6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:58:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab0LERuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IWwrykvE9Ma0T61z0GWTRnBJNynr0XRxD8LL4zx8y21fB8OT6FwdmFEX0Dlf3kJbIO
         EuwT3w9nGCTz9tKMgZ36+L0DBK4ZTiU625MT+7iXDrwAPKsCHKnUeVtAxgmrsu4DPodo
         pBHDqfBARoYWy5cHoFMGT01DClwAjoikhP5yc=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 07/45] kstrtox: convert fs/fuse/
Date: Sun,  5 Dec 2010 19:49:04 +0200
Message-Id: <1291571382-2719-7-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
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
1.7.2.2

