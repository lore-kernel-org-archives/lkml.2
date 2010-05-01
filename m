Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab0EAOd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:33:27 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:63458 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0EAOax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:30:53 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH v21 043/100] c/r: add generic '->checkpoint()' f_op to simple devices
Date: Sat,  1 May 2010 10:15:25 -0400
Message-Id: <1272723382-19470-44-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* /dev/null
* /dev/zero
* /dev/random
* /dev/urandom

Changelog [v21]:
  - Put file_ops->checkpoint under CONFIG_CHECKPOINT

Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 drivers/char/mem.c    |    6 ++++++
 drivers/char/random.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index f54dab8..4e48384 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -767,6 +767,9 @@ static const struct file_operations null_fops = {
 	.read		= read_null,
 	.write		= write_null,
 	.splice_write	= splice_write_null,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif
 };
 
 #ifdef CONFIG_DEVPORT
@@ -783,6 +786,9 @@ static const struct file_operations zero_fops = {
 	.read		= read_zero,
 	.write		= write_zero,
 	.mmap		= mmap_zero,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif
 };
 
 /*
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 2fd3d39..47a224c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1169,6 +1169,9 @@ const struct file_operations random_fops = {
 	.poll  = random_poll,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint = generic_file_checkpoint,
+#endif
 };
 
 const struct file_operations urandom_fops = {
@@ -1176,6 +1179,9 @@ const struct file_operations urandom_fops = {
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint = generic_file_checkpoint,
+#endif
 };
 
 /***************************************************************
-- 
1.6.3.3

