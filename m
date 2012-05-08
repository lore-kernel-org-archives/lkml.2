Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2EHW0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:26:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34577 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab2EHW0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:26:01 -0400
Date: Tue, 8 May 2012 15:25:48 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-be60828920d23758da8124bed771404a0438f369@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-16-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-16-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode: Move trampoline_*.
 S early in the link order
Git-Commit-ID: be60828920d23758da8124bed771404a0438f369
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:25:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be60828920d23758da8124bed771404a0438f369
Gitweb:     http://git.kernel.org/tip/be60828920d23758da8124bed771404a0438f369
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 8 May 2012 21:22:38 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:48:03 -0700

x86, realmode: Move trampoline_*.S early in the link order

Move trampoline_*.S earlier in the link order so it ends up being
first in the text segment; since the SIPI vector requires 4K alignment
it otherwise ends up padding the .text segment with that much
completely unnecessarily.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-16-git-send-email-jarkko.sakkinen@intel.com
---
 arch/x86/realmode/rm/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 2432acb..2423142 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -12,8 +12,8 @@ subdir- := wakeup
 always := realmode.bin
 
 realmode-y			+= header.o
-realmode-$(CONFIG_X86_32)	+= reboot_32.o
 realmode-y			+= trampoline_$(BITS).o
+realmode-$(CONFIG_X86_32)	+= reboot_32.o
 realmode-$(CONFIG_ACPI_SLEEP)	+= wakeup/wakeup.o
 
 targets	+= $(realmode-y)
