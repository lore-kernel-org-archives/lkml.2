Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2AaEHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 23:07:38 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41309 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2AaEHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 23:07:36 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Tim Abbott <tim.abbott@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] module: Remove module size limit
Date: Mon, 30 Jan 2012 23:07:22 -0500
Message-Id: <1327982842-13898-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Module size was limited to 64MB, this was legacy limitation due to vmalloc()
which was removed a while ago.

Limiting module size to 64MB is both pointless and affects real world use
cases.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tim Abbott <tim.abbott@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/module.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2c93276..3d56b6f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2380,8 +2380,7 @@ static int copy_and_check(struct load_info *info,
 		return -ENOEXEC;
 
 	/* Suck in entire file: we'll want most of it. */
-	/* vmalloc barfs on "unusual" numbers.  Check here */
-	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
+	if ((hdr = vmalloc(len)) == NULL)
 		return -ENOMEM;
 
 	if (copy_from_user(hdr, umod, len) != 0) {
-- 
1.7.8.4

