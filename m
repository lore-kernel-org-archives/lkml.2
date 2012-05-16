Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab2EPVp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 17:45:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab2EPVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 17:45:24 -0400
Date: Wed, 16 May 2012 14:45:12 -0700
From: tip-bot for Peter Jones <pjones@redhat.com>
Message-ID: <tip-ab7b64e9ee1e930ffe9d7f5b5eebe618a3b3a03b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, pjones@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1337190206-12121-1-git-send-email-pjones@redhat.com>
References: <1337190206-12121-1-git-send-email-pjones@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Don't continue booting if we can'
 t load the specified initrd
Git-Commit-ID: ab7b64e9ee1e930ffe9d7f5b5eebe618a3b3a03b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 16 May 2012 14:45:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab7b64e9ee1e930ffe9d7f5b5eebe618a3b3a03b
Gitweb:     http://git.kernel.org/tip/ab7b64e9ee1e930ffe9d7f5b5eebe618a3b3a03b
Author:     Peter Jones <pjones@redhat.com>
AuthorDate: Wed, 16 May 2012 13:43:26 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 May 2012 13:59:52 -0700

x86: Don't continue booting if we can't load the specified initrd

If we've determined we can't do what the user asked, trying to do
something else isn't going to make the user's life better.

Without this the screen scrolls a bit and then you get a panic
anyway, and it's nice not to have so much scroll after the real
problem in bug reports.

Link: http://lkml.kernel.org/r/1337190206-12121-1-git-send-email-pjones@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

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
