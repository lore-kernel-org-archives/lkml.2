Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2EHWUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:20:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34495 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2EHWUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:20:09 -0400
Date: Tue, 8 May 2012 15:19:59 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-2a6de3148cfd1a0240a85ea4a1cad34d250d882f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-9-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-9-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Allow absolute pa_* symbols in the realmode code
Git-Commit-ID: 2a6de3148cfd1a0240a85ea4a1cad34d250d882f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:20:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a6de3148cfd1a0240a85ea4a1cad34d250d882f
Gitweb:     http://git.kernel.org/tip/2a6de3148cfd1a0240a85ea4a1cad34d250d882f
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 8 May 2012 21:22:31 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:47:11 -0700

x86, realmode: Allow absolute pa_* symbols in the realmode code

Allow pa_* symbols to be absolute (outside any section) in the
realmode linker script.  Some versions of GNU ld are known to be
unhappy about symbols defined in a section that is otherwise empty.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-9-git-send-email-jarkko.sakkinen@intel.com
---
 scripts/x86-relocs.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/x86-relocs.c b/scripts/x86-relocs.c
index 0291470..74e16bb 100644
--- a/scripts/x86-relocs.c
+++ b/scripts/x86-relocs.c
@@ -62,6 +62,13 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 
 static const char * const sym_regex_realmode[S_NSYMTYPES] = {
 /*
+ * These symbols are known to be relative, even if the linker marks them
+ * as absolute (typically defined outside any section in the linker script.)
+ */
+	[S_REL] =
+	"^pa_",
+
+/*
  * These are 16-bit segment symbols when compiling 16-bit code.
  */
 	[S_SEG] =
