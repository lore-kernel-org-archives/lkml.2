Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab1EABin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab1EABh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KciLGkypl5oQeLi0HBSDbwHe5rdqOg1V/HHr6YnWM5m+mYHkoT4nrId4f4fDUNJ0KZ
         bxGGXKTupCBmKDW49RBQql6ArxpNpBDsg1cXO3gVa4o/UHG2bbRSON8xjS086SHkQ4uV
         FZwa3DhhxdUT0ka6bgcwEVeDd5O7ivkj2CSH0=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 20/69] sysctl: remove .child from coda/
Date: Sun,  1 May 2011 03:35:50 +0200
Message-Id: <1304213799-10257-21-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/coda/sysctl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index af56ad5..8c328c9 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -39,19 +39,15 @@ static ctl_table coda_table[] = {
 	{}
 };
 
-static ctl_table fs_table[] = {
-	{
-		.procname	= "coda",
-		.mode		= 0555,
-		.child		= coda_table
-	},
-	{}
+static const __initdata struct ctl_path coda_path[] = {
+	{ .procname = "coda" },
+	{ }
 };
 
 void coda_sysctl_init(void)
 {
 	if ( !fs_table_header )
-		fs_table_header = register_sysctl_table(fs_table);
+		fs_table_header = register_sysctl_paths(coda_path, coda_table);
 }
 
 void coda_sysctl_clean(void)
-- 
1.7.5.134.g1c08b

