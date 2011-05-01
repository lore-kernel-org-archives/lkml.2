Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab1EABri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:47:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab1EABhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JXrZfRkk0wHbkZkSyiUaz6tq2xDst2zPxkO/veWE4xXb1zM/+3l0Azv8tqG+2MyBSl
         j6Hav/iCSAw/WgAxjQcVwqTMgrBQ1TMSAhNaWyS9wZsOK5owna1xJVlYXp91vEYX562U
         pUxBSgyT+yhp+euhzV4dr+HW9dsd3vcciPTSc=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 42/69] sysctl: remove .child from vm/ (s390)
Date: Sun,  1 May 2011 03:36:12 +0200
Message-Id: <1304213799-10257-43-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/s390/mm/cmm.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index c66ffd8..0ef5bbf 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -348,13 +348,8 @@ static struct ctl_table cmm_table[] = {
 	{ }
 };
 
-static struct ctl_table cmm_dir_table[] = {
-	{
-		.procname	= "vm",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= cmm_table,
-	},
+static const __initdata struct ctl_path cmm_path[] = {
+	{ .procname = "vm" },
 	{ }
 };
 
@@ -434,7 +429,7 @@ static int __init cmm_init(void)
 {
 	int rc = -ENOMEM;
 
-	cmm_sysctl_header = register_sysctl_table(cmm_dir_table);
+	cmm_sysctl_header = register_sysctl_paths(cmm_path, cmm_table);
 	if (!cmm_sysctl_header)
 		goto out_sysctl;
 #ifdef CONFIG_CMM_IUCV
-- 
1.7.5.134.g1c08b

