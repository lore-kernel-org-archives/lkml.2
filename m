Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2FUAic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:38:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43605 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab2FUAib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:38:31 -0400
Date: Wed, 20 Jun 2012 17:38:09 -0700
From: tip-bot for Paul Bolle <pebolle@tiscali.nl>
Message-ID: <tip-e5a7286b5f1b0b5beb97275f2152bf10c4aa4204@git.kernel.org>
Cc: jepler@unpythonic.net, linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
        hpa@zytor.com, mingo@kernel.org, jj@chaosbits.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org, jepler@unpythonic.net, jj@chaosbits.net,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1340230589.1773.7.camel@x61.thuisdomein>
References: <1340230589.1773.7.camel@x61.thuisdomein>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, boot: Remove ancient,
  unconditionally #ifdef'd out dead code
Git-Commit-ID: e5a7286b5f1b0b5beb97275f2152bf10c4aa4204
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 17:38:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5a7286b5f1b0b5beb97275f2152bf10c4aa4204
Gitweb:     http://git.kernel.org/tip/e5a7286b5f1b0b5beb97275f2152bf10c4aa4204
Author:     Paul Bolle <pebolle@tiscali.nl>
AuthorDate: Thu, 21 Jun 2012 00:16:29 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 20 Jun 2012 17:28:56 -0700

x86, boot: Remove ancient, unconditionally #ifdef'd out dead code

Release v1.3.82 wrapped a few lines of code in an "#ifdef
SAFE_RESET_DISK_CONTROLLER" and "#endif" pair. Since
SAFE_RESET_DISK_CONTROLLER was never defined anywhere that was basically
a verbose "#ifdef 0" and "#endif" pair. These dead lines have been in
the tree for sixteen years but now the time has come to remove them.

I guess the main lesson here is that if you want your dead code in the
tree for a very long time you'd better be creative. A plain old "#ifdef
0" and "#endif" pair just doesn't cut it!

See: http://lkml.kernel.org/r/199603301718.LAA00178@craie.inetnebr.com

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Link: http://lkml.kernel.org/r/1340230589.1773.7.camel@x61.thuisdomein
Acked-by: Jeff Epler <jepler@unpythonic.net>
Acked-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/header.S |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

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
