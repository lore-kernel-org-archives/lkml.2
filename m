Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab2BTLLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:11:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59591 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2BTLLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:11:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of consul.kautuk@gmail.com designates 10.68.208.196 as permitted sender) smtp.mail=consul.kautuk@gmail.com; dkim=pass header.i=consul.kautuk@gmail.com
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] shmem.c: Compilation failure in shmem_file_setup for !CONFIG_MMU
Date: Mon, 20 Feb 2012 06:11:32 -0500
Message-Id: <1329736292-19087-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I disabled the CONFIG_MMU and tried to compile the kernel and got the
following problem:
In function ‘shmem_file_setup’:
error: implicit declaration of function ‘ramfs_nommu_expand_for_mapping’

This is because, we do not include ramfs.h for CONFIG_SHMEM.

Included linux/ramfs.h for both CONFIG_SHMEM as well as !CONFIG_SHMEM.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/shmem.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 269d049..4884188 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -30,6 +30,7 @@
 #include <linux/mm.h>
 #include <linux/export.h>
 #include <linux/swap.h>
+#include <linux/ramfs.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -2442,8 +2443,6 @@ out4:
  * effectively equivalent, but much lighter weight.
  */
 
-#include <linux/ramfs.h>
-
 static struct file_system_type shmem_fs_type = {
 	.name		= "tmpfs",
 	.mount		= ramfs_mount,
-- 
1.7.5.4

