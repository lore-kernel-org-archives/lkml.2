Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab2EPS2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:28:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab2EPS2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:28:14 -0400
From: Peter Jones <pjones@redhat.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH] Don't continue booting if we can't load the specified initrd.
Date: Wed, 16 May 2012 13:43:26 -0400
Message-Id: <1337190206-12121-1-git-send-email-pjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we've determined we can't do what the user asked, trying to do
something else isn't going to make the user's life better.

Without this the screen scrolls a bit and then you get a panic
anyway, and it's nice not to have so much scroll after the real
problem in bug reports.
---
 arch/x86/kernel/setup.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1a29015..37ef116 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -393,10 +393,9 @@ static void __init reserve_initrd(void)
 	initrd_start = 0;
 
 	if (ramdisk_size >= (end_of_lowmem>>1)) {
-		memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
-		printk(KERN_ERR "initrd too large to handle, "
-		       "disabling initrd\n");
-		return;
+		panic("initrd too large to handle, "
+		       "disabling initrd (%lld needed, %lld available)\n",
+		       ramdisk_size, end_of_lowmem>>1);
 	}
 
 	printk(KERN_INFO "RAMDISK: %08llx - %08llx\n", ramdisk_image,
-- 
1.7.10.1

