Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2EHWVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:21:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34506 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2EHWU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:20:59 -0400
Date: Tue, 8 May 2012 15:20:49 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-487f50ffeb142d8f86fff6e43a8852ce3d46c173@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-10-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-10-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode: Add .text64 section,
  make barrier symbols absolute
Git-Commit-ID: 487f50ffeb142d8f86fff6e43a8852ce3d46c173
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:20:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  487f50ffeb142d8f86fff6e43a8852ce3d46c173
Gitweb:     http://git.kernel.org/tip/487f50ffeb142d8f86fff6e43a8852ce3d46c173
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 8 May 2012 21:22:32 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:47:18 -0700

x86, realmode: Add .text64 section, make barrier symbols absolute

Add a .text64 section.  The purpose of this is to keep 16-, 32- and
64-bit code segregated into separate sections, mainly to keep
disassembly sane.

Move barrier symbols out of sections to avoid the "symbol in empty
section" problem in some versions of GNU ld.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-10-git-send-email-jarkko.sakkinen@intel.com
---
 arch/x86/realmode/rm/realmode.lds.S |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/realmode/rm/realmode.lds.S b/arch/x86/realmode/rm/realmode.lds.S
index 91b83ea..4d4afca 100644
--- a/arch/x86/realmode/rm/realmode.lds.S
+++ b/arch/x86/realmode/rm/realmode.lds.S
@@ -32,8 +32,8 @@ SECTIONS
 	}
 
 	. = ALIGN(PAGE_SIZE);
+	pa_text_start = .;
 	.text : {
-		pa_text_start = .;
 		*(.text)
 		*(.text.*)
 	}
@@ -41,9 +41,14 @@ SECTIONS
 	.text32 : {
 		*(.text32)
 		*(.text32.*)
-		pa_ro_end = .;
 	}
 
+	.text64 : {
+		*(.text64)
+		*(.text64.*)
+	}
+	pa_ro_end = .;
+
 	. = ALIGN(PAGE_SIZE);
 	.data : {
 		*(.data)
@@ -59,8 +64,8 @@ SECTIONS
 	. = ALIGN(4);
 	.signature : {
 		*(.signature)
-		pa_end = .;
 	}
+	pa_end = .;
 
 	/DISCARD/ : {
 		*(.note*)
