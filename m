Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2CNF7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 01:59:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43985 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab2CNF7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 01:59:12 -0400
Date: Tue, 13 Mar 2012 22:58:51 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-bb6fa8b275e132b1e9319dbab94211543a0b7bd3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, gregory.m.lueck@intel.com, hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com, gregory.m.lueck@intel.com
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x32: Fix stupid ia32/
 x32 inversion in the siginfo format
Git-Commit-ID: bb6fa8b275e132b1e9319dbab94211543a0b7bd3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Mar 2012 22:58:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb6fa8b275e132b1e9319dbab94211543a0b7bd3
Gitweb:     http://git.kernel.org/tip/bb6fa8b275e132b1e9319dbab94211543a0b7bd3
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 13 Mar 2012 22:44:41 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 13 Mar 2012 22:44:41 -0700

x32: Fix stupid ia32/x32 inversion in the siginfo format

Fix a stray ! which flipped the sense if we were generating a signal
frame for ia32 vs. x32.

Introduced in:

e7084fd5 x32: Switch to a 64-bit clock_t

Reported-by: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Gregory M. Lueck <gregory.m.lueck@intel.com>
Link: http://lkml.kernel.org/r/1329696488-16970-1-git-send-email-hpa@zytor.com
---
 arch/x86/ia32/ia32_signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index bc09ed2..ef026aa 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -37,7 +37,7 @@
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err = 0;
-	bool ia32 = !is_ia32_task();
+	bool ia32 = is_ia32_task();
 
 	if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
 		return -EFAULT;
