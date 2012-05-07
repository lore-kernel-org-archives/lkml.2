Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2EGRNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:13:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33686 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab2EGRNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:13:10 -0400
MIME-Version: 1.0
Date: Tue, 8 May 2012 01:13:09 +0800
Message-ID: <CAEwRVpOeG-WWzwF7_fhTayh0a8GS86Wyu9eKSkGhPC+73XsC3Q@mail.gmail.com>
Subject: [PATCH] ecryptfs: Fix warnings as errors in fs/ecryptfs/miscdev.c
 when using android prebuilt linux-x86 toolchain arm-eabi-4.4.3
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: "Michael A. Halcrow" <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am submitting this patch for review as it failed to compile using
toolchain provided by android aka
android/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3.

The patch commit id is db10e556518eb9d21ee92ff944530d84349684f4
upstream and 3.0.y commit id is
cdce30003c234575bbcfddb0980adc04b82408c7 which causes such warning as
error issue in 3.0.y.  This patch is based on 3.0.y tree.  This patch
just cast the type accordingly which I am not sure whether is this the
right thing to do but this fix my compile problem though.

Thanks.


From: Giam Teck Choon <giamteckchoon@gmail.com>

cc1: warnings being treated as errors
fs/ecryptfs/miscdev.c: In function 'ecryptfs_miscdev_write':
fs/ecryptfs/miscdev.c:427: error: format '%lu' expects type 'long
unsigned int', but argument 4 has type 'unsigned int' [-Wformat]
make[2]: *** [fs/ecryptfs/miscdev.o] Error 1

Signed-off-by: Giam Teck Choon <giamteckchoon@gmail.com>
---
 fs/ecryptfs/miscdev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index 0dc5a3d..c132e70 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -423,7 +423,8 @@ ecryptfs_miscdev_write(struct file *file, const
char __user *buf,
 		printk(KERN_WARNING "%s: Acceptable packet size range is "
 		       "[%d-%lu], but amount of data written is [%zu].",
 		       __func__, (1 + 4 + 1),
-		       (1 + 4 + 2 + sizeof(struct ecryptfs_message) + 4
+		       (long unsigned int)(1 + 4 + 2 +
+			sizeof(struct ecryptfs_message) + 4
 			+ ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES), count);
 		return -EINVAL;
 	}
