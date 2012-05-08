Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2EHW0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:26:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34586 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab2EHW0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:26:47 -0400
Date: Tue, 8 May 2012 15:26:38 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-6feb592dceaed1a6cf26c9747b1180958d5156cd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-17-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-17-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Fix always-zero test in reboot_32.S
Git-Commit-ID: 6feb592dceaed1a6cf26c9747b1180958d5156cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:26:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6feb592dceaed1a6cf26c9747b1180958d5156cd
Gitweb:     http://git.kernel.org/tip/6feb592dceaed1a6cf26c9747b1180958d5156cd
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 8 May 2012 21:22:39 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:48:04 -0700

x86, realmode: Fix always-zero test in reboot_32.S

A test instruction is an "and", and an and with zero is always zero.
This would cause us to always take the BIOS path, not the APM path, in
case anyone actually cares...

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-17-git-send-email-jarkko.sakkinen@intel.com
---
 arch/x86/realmode/rm/reboot_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/realmode/rm/reboot_32.S b/arch/x86/realmode/rm/reboot_32.S
index e90f8c4..50ba994 100644
--- a/arch/x86/realmode/rm/reboot_32.S
+++ b/arch/x86/realmode/rm/reboot_32.S
@@ -85,7 +85,7 @@ machine_real_restart_asm16:
 	movl	%edx, %cr0
 	LJMPW_RM(3f)
 3:
-	testb	$0, %al
+	andw	%ax, %ax
 	jz	bios
 
 apm:
