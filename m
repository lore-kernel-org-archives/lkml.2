Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2FTWQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:16:51 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:3416 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754816Ab2FTWQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:16:50 -0400
Message-ID: <1340230589.1773.7.camel@x61.thuisdomein>
Subject: [PATCH] x86: boot: Remove ancient dead code
From: Paul Bolle <pebolle@tiscali.nl>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: Jeff Epler <jepler@inetnebr.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 00:16:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 20 Jun 2012 22:16:36.0220 (UTC) FILETIME=[5B4ACBC0:01CD4F32]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release v1.3.82 wrapped a few lines of code in an "#ifdef
SAFE_RESET_DISK_CONTROLLER" and "#endif" pair. Since
SAFE_RESET_DISK_CONTROLLER was never defined anywhere that was basically
a verbose "#ifdef 0" and "#endif" pair. These dead lines have been in
the tree for sixteen years but now the time has come to remove them.

I guess the main lesson here is that if you want your dead code in the
tree for a very long time you'd better be creative. A plain old "#ifdef
0" and "#endif" pair just doesn't cut it!

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Link: https://lkml.org/lkml/1996/3/30/38
Cc: Jeff Epler <jepler@inetnebr.com>
---
 arch/x86/boot/header.S |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index efe5acf..9b9c647 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -406,13 +406,6 @@ init_size:		.long INIT_SIZE		# kernel initialization size
 
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
-- 
1.7.7.6

