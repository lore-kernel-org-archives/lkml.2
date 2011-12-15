Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab1LOCoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:44:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56010 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493Ab1LOCob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:44:31 -0500
From: Michel Lespinasse <walken@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix for binary_sysctl() memory leak
Date: Wed, 14 Dec 2011 18:44:12 -0800
Message-Id: <1323917052-480-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

binary_sysctl() calls sysctl_getname() which allocates from
names_cache slab usin __getname()

The matching function to free the name is __putname(), and not
putname() which should be used only to match getname() allocations.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 kernel/sysctl_binary.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index e8bffbe..2ce1b30 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1354,7 +1354,7 @@ static ssize_t binary_sysctl(const int *name, int nlen,
 
 	fput(file);
 out_putname:
-	putname(pathname);
+	__putname(pathname);
 out:
 	return result;
 }
-- 
1.7.3.1

