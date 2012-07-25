Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab2GYOmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:42:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43053 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228Ab2GYOmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:42:20 -0400
Date: Wed, 25 Jul 2012 16:42:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for v3.6
Message-ID: <20120725144214.GA31167@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   HEAD: e5a7286b5f1b0b5beb97275f2152bf10c4aa4204 x86, boot: Remove ancient, unconditionally #ifdef'd out dead code

Just a single cleanup.

 Thanks,

	Ingo

------------------>
Paul Bolle (1):
      x86, boot: Remove ancient, unconditionally #ifdef'd out dead code


 arch/x86/boot/header.S |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 8bbea6a..fde5bde 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -386,13 +386,6 @@ init_size:		.long INIT_SIZE		# kernel initialization size
 
 	.section ".entrytext", "ax"
 start_of_setup:
-#ifdef SAFE_RESET_DISK_CONTROLLER
-# Reset the disk controller.
-	movw	$0x0000, %ax		# Reset disk controller
-	movb	$0x80, %dl		# All disks
-	int	$0x13
-#endif
-
 # Force %es = %ds
 	movw	%ds, %ax
 	movw	%ax, %es
