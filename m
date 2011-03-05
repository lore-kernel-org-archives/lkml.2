Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1CEBkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:40:08 -0500
Received: from mout.perfora.net ([74.208.4.195]:57847 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab1CEBkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:40:07 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Stephen Wilson <wilsons@start.ca>
Subject: [PATCH] proc: Document why writing to /proc/pid/mem is a security hazard.
Date: Fri,  4 Mar 2011 20:39:35 -0500
Message-Id: <1299289175-15720-1-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
X-Provags-ID: V02:K0:WGd+VnkYH5i1/vIvq4AQnqZt/XPhvhSd+tpbWZ8jTEr
 0SVP9sdB2gPzvLxWSc5WPjqsvNZQo23WX9tMbD8pABkXlNqgyf
 g7r436d4XkZc72uNN1JRh9PUdRAKXOpHRHXpkFLJh77OFKna1w
 Ci6wB7crE2+vHHVQmVuJYlPaFYdblu2uclYcPLSSDF2uOoLdon
 ifWcZ7LfY0viTkYA74uikBaPDS8n1+BsyIMhQlL4eA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 fs/proc/base.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9d096e8..9d55b7b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -832,7 +832,11 @@ out_no_task:
 #define mem_write NULL
 
 #ifndef mem_write
-/* This is a security hazard */
+/*
+ * As implemented, mem_write would be a security hazard if enabled.  For
+ * example, the target task could exec a setuid-root binary between the
+ * permission check and the write into memory.
+ */
 static ssize_t mem_write(struct file * file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-- 
1.7.3.5

