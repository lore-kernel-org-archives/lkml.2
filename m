Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab2FPDOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 23:14:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2FPDOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 23:14:21 -0400
Date: Fri, 15 Jun 2012 20:14:10 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-0b91f45b23cb73ce11acdc3cf4c6efd4441e3b3e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1339722435.3475.57.camel@sbsiddha-desk.sc.intel.com>
References: <1339722435.3475.57.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, compat: Use test_thread_flag(TIF_IA32)
  in compat signal delivery
Git-Commit-ID: 0b91f45b23cb73ce11acdc3cf4c6efd4441e3b3e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 15 Jun 2012 20:14:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b91f45b23cb73ce11acdc3cf4c6efd4441e3b3e
Gitweb:     http://git.kernel.org/tip/0b91f45b23cb73ce11acdc3cf4c6efd4441e3b3e
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 14 Jun 2012 18:07:15 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 14 Jun 2012 18:16:04 -0700

x86, compat: Use test_thread_flag(TIF_IA32) in compat signal delivery

Signal delivery compat path may not have the 'TS_COMPAT' flag (that
flag indicates how we entered the kernel).  So use
test_thread_flag(TIF_IA32) instead of is_ia32_task(): one of the
functions of TIF_IA32 is just what kind of signal frame we want.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1339722435.3475.57.camel@sbsiddha-desk.sc.intel.com
Cc: stable@kernel.org	# v3.4
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/ia32/ia32_signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index daeca56..673ac9b 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -38,7 +38,7 @@
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err = 0;
-	bool ia32 = is_ia32_task();
+	bool ia32 = test_thread_flag(TIF_IA32);
 
 	if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
 		return -EFAULT;
